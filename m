Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaJVN6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:58:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49417 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaJVN6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:18 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 10/10] sched: io_latency: Tracking via buckets
Date: Wed, 22 Oct 2014 15:57:53 +0200
Message-Id: <1413986273-28522-11-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was recently added in the energy aware scheduler kernel tree the io latency
tracking mechanism. The purpose of this framework is to provide a way to
predict the IO latencies, in other words try to guess how long we will be
sleeping on waiting an IO. When the cpu goes idle, we know how long is the
sleep duration with the timer but then we rely on some statistics in the
menu governor, which is part of the cpuidle framework for other wakes up.

The io latency tracking will provide an additional information about the
length of the expected sleep time, which combined with the timer duration
should give us a more accurate prediction.

The first step of the io latency tracking was simply using a sliding average
of the values, which is not really accurate as it is not immune against IOs
ping pong or big variations.

In order to improve that, each latency is grouped into a bucket which
represent an interval of latency and for each bucket a sliding average is
computed.

Why ? Because we don't want to take all the latencies and compute the
statistics on them. It does not make sense, takes a lot of memory,
computation time, for finally a result which is mathematically impossible
to resolve. It is better to use intervals to group the small variations of
the latencies. For example. 186us, 123us, 134us can fall into the bucket
[100 - 199].

The size of the bucket is the bucket interval and represent the resolution
of the statistic model. Eg with a bucket interval of 1us, it leads us to
do statitics on all numbers, with of course a bad prediction because the
number of latencies is big. A big interval can give better statistics,
but can give us a misprediction as the interval is larger.

Choosing the size of the bucket interval vs the idle sleep time is the
tradeoff to find. With a 200us bucket interval, the measurements show
we still have good predictions, less mispredictions and cover the idle
state target residency.

The buckets are dynamically created and stored into a list. A new bucket is
added at the end of the list.

This list is always moving depending on the number of successives hits a
bucket will have. The more a bucket is successively hit, the more it will
be the first element of the list.

The guessed next latency, which is a bucket (understand it will be between
eg. 200us and 300us, with a bucket interval of 100us), is retrieved from
the list. Each bucket present in the list will mark a score, the more the
hits a bucket has, the bigger score it has. *But* this is weighted by
the position in the list. The first elements will have more weight than the
last ones. This position is dynamically changed when a bucket is hit several
times.

Example the following latencies:
	10, 100, 100, 100, 100, 100, 10, 10

We will have two buckets: 0 and 1.

	10  => bucket0(1)
	100 => bucket0(1), bucket1(1)
	100 => bucket0(1), bucket1(2)
	100 => bucket0(1), bucket1(3)
	100 => bucket0(1), bucket1(4)
*	100 => bucket1(5), bucket0(1)
	10  => bucket1(5), bucket0(2)
	10  => bucket1(5), bucket0(3)

At (*), bucket1 reached 5 successive hits at has been move at the beginning
of the list and bucket0 became the second one.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/linux/sched.h     |   8 ++
 kernel/exit.c             |   1 +
 kernel/fork.c             |   1 +
 kernel/sched/core.c       |   3 +-
 kernel/sched/io_latency.c | 309 ++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched/io_latency.h |   8 +-
 6 files changed, 304 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6af032b..9652ad6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1228,7 +1228,15 @@ struct io_latency_node {
 	unsigned int avg_latency;
 	ktime_t start_time;
 	ktime_t end_time;
+	struct list_head bucket_list;
 };
+
+void exit_io_latency(struct task_struct *tsk);
+#else
+static inline void exit_io_latency(struct task_struct *tsk)
+{
+	;
+}
 #endif
 
 struct task_struct {
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..3413fbe 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -757,6 +757,7 @@ void do_exit(long code)
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
 	exit_thread();
+	exit_io_latency(tsk);
 
 	/*
 	 * Flush inherited counters to the parent - before the parent
diff --git a/kernel/fork.c b/kernel/fork.c
index 7201bc4..d4e7ecc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -347,6 +347,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	tsk->task_frag.page = NULL;
 #ifdef CONFIG_SCHED_IO_LATENCY
 	tsk->io_latency.avg_latency = 0;
+	INIT_LIST_HEAD(&tsk->io_latency.bucket_list);
 #endif
 	account_kernel_stack(ti, 1);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 64181f6..96403f2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6961,6 +6961,8 @@ void __init sched_init(void)
 	autogroup_init(&init_task);
 
 #endif /* CONFIG_CGROUP_SCHED */
+	
+	io_latency_init();
 
 	for_each_possible_cpu(i) {
 		struct rq *rq;
@@ -7035,7 +7037,6 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
-		io_latency_init(rq);
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/sched/io_latency.c b/kernel/sched/io_latency.c
index 2d56a38..5f6bd50 100644
--- a/kernel/sched/io_latency.c
+++ b/kernel/sched/io_latency.c
@@ -23,23 +23,280 @@ struct io_latency_tree {
 	struct io_latency_node *left_most;
 };
 
+/*
+ * That represents the resolution of the statistics in usec, the latency
+ * for a bucket is BUCKET_INTERVAL * index.
+ * The higher the resolution is the lesser good prediction you will have.
+ * Some measurements:
+ *
+ * For 1ms:
+ *  SSD 6Gb/s       : 99.7%
+ *  SD card class 10: 97.7%
+ *  SD card class 4 : 54.3%
+ *  HDD on USB      : 93.6%
+ *
+ * For 500us:
+ *  SSD 6Gb/s               : 99.9%
+ *  SD card class 10        : 96.8%
+ *  SD card class 4         : 55.8%
+ *  HDD on USB              : 86.3%
+ *
+ * For 200us:
+ *  SSD 6Gb/s               : 99.7%
+ *  SD card class 10        : 95.5%
+ *  SD card class 4         : 29.5%
+ *  HDD on USB              : 66.3%
+ *
+ * For 100us:
+ *  SSD 6Gb/s               : 85.7%
+ *  SD card class 10        : 67.63%
+ *  SD card class 4         : 31.4%
+ *  HDD on USB              : 44.97%
+ *
+ * Aiming a 100% is not necessary good because we want to hit the correct
+ * idle state. Setting a low resolution will group the different latencies
+ * into a big interval which may overlap with the cpuidle state target
+ * residency.
+ *
+ */
+#define BUCKET_INTERVAL 200
+
+/*
+ * Number of successive hits for the same bucket. That is the thresold
+ * triggering the move of the element at the beginning of the list, so
+ * becoming more weighted for the statistics when guessing for the next
+ * latency.
+ */
+#define BUCKET_SUCCESSIVE 5
+
+/*
+ * What is a bucket ?
+ *
+ * A bucket is an interval of latency. This interval is defined with the
+ * BUCKET_INTERVAL. The bucket index gives what latency interval we have.
+ * For example, if you have an index 2 and a bucket interval of 1000usec,
+ * then the bucket contains the latencies 2000 and 2999 usec.
+ *
+ */
+struct bucket {
+	int hits;
+	int successive_hits;
+	int index;
+	int average;
+	struct list_head list;
+};
+
+static struct kmem_cache *bucket_cachep;
+
 static DEFINE_PER_CPU(struct io_latency_tree, latency_trees);
 
 /**
- * io_latency_init : initialization routine to be called for each possible cpu.
+ * io_latency_bucket_find - Find a bucket associated with the specified index
  *
- * @rq: the runqueue associated with the cpu
+ * @index: the index of the bucket to find
+ * @tsk: the task to retrieve the task list
  *
+ * Returns the bucket associated with the index, NULL if no bucket is found
  */
-void io_latency_init(struct rq *rq)
+static struct bucket *io_latency_bucket_find(struct task_struct *tsk, int index)
 {
-	int cpu = rq->cpu;
-	struct io_latency_tree *latency_tree = &per_cpu(latency_trees, cpu);
-	struct rb_root *root = &latency_tree->tree;
+	struct list_head *list;
+	struct bucket *bucket = NULL;
+	struct list_head *bucket_list = &tsk->io_latency.bucket_list;
 
-	spin_lock_init(&latency_tree->lock);
-	latency_tree->left_most = NULL;
-	root->rb_node = NULL;
+	list_for_each(list, bucket_list) {
+
+		bucket = list_entry(list, struct bucket, list);
+
+		if (bucket->index == index)
+			return bucket;
+	}
+
+	return NULL;
+}
+
+/**
+ * io_latency_bucket_alloc - Allocate a bucket
+ * 
+ * @index: index of the bucket to allow
+ *
+ * Allocate and initialize a bucket structure
+ *
+ * Returns a pointer to a bucket or NULL is the allocation failed
+ */
+static struct bucket *io_latency_bucket_alloc(int index)
+{
+	struct bucket *bucket;
+
+	bucket = kmem_cache_alloc(bucket_cachep, GFP_KERNEL);
+	if (bucket) {
+		bucket->hits  = 0;
+		bucket->successive_hits = 0;
+		bucket->index = index;
+		bucket->average = 0;
+		INIT_LIST_HEAD(&bucket->list);
+	}
+
+	return bucket;
+}
+
+/**
+ * io_latency_guessed_bucket - try to predict the next bucket
+ *
+ * @tsk: the task to get the bucket list
+ *
+ * The list is ordered by history. The first element is the one with
+ * the more *successive* hits. This function is called each time a new
+ * latency is inserted. The algorithm is pretty simple here: As the
+ * first element is the one which more chance to occur next, its
+ * weight is the bigger, the second one has less weight, etc ...
+ *
+ * The bucket which has the maximum score (number of hits weighted by
+ * its position in the list) is the next bucket which has more chances
+ * to occur.
+ *
+ * Returns a pointer to the bucket structure, NULL if there are no
+ * buckets in the list
+ */
+static struct bucket *io_latency_guessed_bucket(struct task_struct *tsk)
+{
+	int weight = 0;
+	int score, score_max = 0;
+	struct bucket *bucket, *winner = NULL;
+	struct list_head *list = NULL;
+	struct list_head *bucket_list = &tsk->io_latency.bucket_list;
+
+	if (list_empty(bucket_list))
+		return NULL;
+
+	list_for_each(list, bucket_list) {
+
+		bucket = list_entry(list, struct bucket, list);
+
+		/*
+		 * The list is ordered by history, the first element has
+		 * more weight the next one
+		 */
+		score = bucket->hits / ((2 * weight) + 1);
+
+		weight++;
+
+		if (score < score_max)
+			continue;
+
+		score_max = score;
+		winner = bucket;
+	}
+
+	return winner;
+}
+
+/*
+ * io_latency_bucket_index - Returns the bucket index for the specified latency
+ *
+ * @latency: the latency fitting a bucket with the specified index
+ *
+ * Returns an integer for the bucket's index
+ */
+static int io_latency_bucket_index(int latency)
+{
+	return latency / BUCKET_INTERVAL;
+}
+
+/*
+ * io_latency_bucket_fill - Compute and fill the bucket list
+ *
+ * @tsk: the task completing an IO
+ * @latency: the latency of the IO
+ *
+ * The dynamic of the list is the following.
+ * - Each new element is inserted at the end of the list
+ * - Each element passing <BUCKET_SUCCESSIVE> times in this function
+ *   is elected to be moved at the beginning at the list
+ *
+ * Returns 0 on success, -1 if a bucket allocation failed
+ */
+static int io_latency_bucket_fill(struct task_struct *tsk, int latency)
+{
+	int diff, index = io_latency_bucket_index(latency);
+	struct bucket *bucket;
+
+	/*
+	 * Find the bucket associated with the index
+	 */
+	bucket = io_latency_bucket_find(tsk, index);
+	if (!bucket) {
+		bucket = io_latency_bucket_alloc(index);
+		if (!bucket)
+			return -1;
+
+		list_add_tail(&bucket->list, &tsk->io_latency.bucket_list);
+	}
+
+	/*
+	 * Increase the number of times this bucket has been hit
+	 */
+	bucket->hits++;
+	bucket->successive_hits++;
+
+	/*
+	 * Compute a sliding average for latency in this bucket
+	 */
+	diff = latency - bucket->average;
+	bucket->average += (diff >> 6);
+
+	/*
+	 * We hit a successive number of times the same bucket, move
+	 * it at the beginning of the list
+	 */
+	if (bucket->successive_hits == BUCKET_SUCCESSIVE) {
+		list_move(&bucket->list, &tsk->io_latency.bucket_list);
+		bucket->successive_hits = 1;
+	}
+
+	return 0;
+}
+
+/*
+ * exit_io_latency - free ressources when the task exits
+ *
+ * @tsk : the exiting task
+ *
+ */
+void exit_io_latency(struct task_struct *tsk)
+{
+	struct list_head *bucket_list = &tsk->io_latency.bucket_list;
+	struct list_head *tmp, *list;
+	struct bucket *bucket;
+
+	list_for_each_safe(list, tmp, bucket_list) {
+
+		list_del(list);
+		bucket = list_entry(list, struct bucket, list);
+		kmem_cache_free(bucket_cachep, bucket);
+	}
+}
+
+/**
+ * io_latency_init : initialization routine
+ *
+ * Initializes the cache pool and the io latency rb trees.
+ */
+void io_latency_init(void)
+{
+	int cpu;
+	struct io_latency_tree *latency_tree;
+	struct rb_root *root;
+
+	bucket_cachep = KMEM_CACHE(bucket, SLAB_PANIC);
+
+	for_each_possible_cpu(cpu) {
+		latency_tree = &per_cpu(latency_trees, cpu);
+		latency_tree->left_most = NULL;
+		spin_lock_init(&latency_tree->lock);
+		root = &latency_tree->tree;
+		root->rb_node = NULL;
+	}
 }
 
 /**
@@ -54,18 +311,20 @@ s64 io_latency_get_sleep_length(struct rq *rq)
 	int cpu = rq->cpu;
 	struct io_latency_tree *latency_tree = &per_cpu(latency_trees, cpu);
 	struct io_latency_node *node;
-	ktime_t now = ktime_get();
-	s64 diff;
+	s64 diff, next_event, now;
 
 	node = latency_tree->left_most;
-
 	if (!node)
 		return 0;
 
-	diff = ktime_to_us(ktime_sub(now, node->start_time));
-	diff = node->avg_latency - diff;
+	next_event = ktime_to_us(node->start_time) + node->avg_latency;
+	now = ktime_to_us(ktime_get());
+	diff = next_event - now;
 
-	/* Estimation was wrong, return 0 */
+	/* Estimation was wrong, so the next io event should have
+	 * already occured but it actually didn't, so we have a
+	 * negative value, return 0 in this case as it is considered
+	 * by the caller as an invalid value */
 	if (diff < 0)
 		return 0;
 
@@ -78,13 +337,17 @@ s64 io_latency_get_sleep_length(struct rq *rq)
  * @node: a rb tree node belonging to a task
  *
  */
-static void io_latency_avg(struct io_latency_node *node)
+static void io_latency_avg(struct task_struct *tsk)
 {
-	/* MA*[i]= MA*[i-1] + X[i] - MA*[i-1]/N */
+	struct io_latency_node *node = &tsk->io_latency;
 	s64 latency = ktime_to_us(ktime_sub(node->end_time, node->start_time));
-	s64 diff = latency - node->avg_latency;
+	struct bucket *bucket;
+
+	io_latency_bucket_fill(tsk, latency);
 
-	node->avg_latency = node->avg_latency + (diff >> 6);
+	bucket = io_latency_guessed_bucket(tsk);
+	if (bucket)
+		node->avg_latency = bucket->average;
 }
 
 /**
@@ -118,7 +381,11 @@ int io_latency_begin(struct rq *rq, struct task_struct *tsk)
 
 		parent = *new;
 
-		if (lat->avg_latency > node->avg_latency)
+		/*
+		 * Check *when* will occur the next event
+		 */
+		if (ktime_to_us(lat->start_time) + lat->avg_latency >
+		    ktime_to_us(node->start_time) + node->avg_latency)
 			new = &parent->rb_left;
 		else {
 			new = &parent->rb_right;
@@ -170,5 +437,5 @@ void io_latency_end(struct rq *rq, struct task_struct *tsk)
 
 	spin_unlock(&latency_tree->lock);
 
-	io_latency_avg(old);
+	io_latency_avg(tsk);
 }
diff --git a/kernel/sched/io_latency.h b/kernel/sched/io_latency.h
index 62ece7c..c54de4d 100644
--- a/kernel/sched/io_latency.h
+++ b/kernel/sched/io_latency.h
@@ -11,12 +11,12 @@
  */
 
 #ifdef CONFIG_SCHED_IO_LATENCY
-extern void io_latency_init(struct rq *rq);
+extern void io_latency_init(void);
 extern int  io_latency_begin(struct rq *rq, struct task_struct *tsk);
 extern void io_latency_end(struct rq *rq, struct task_struct *tsk);
-extern int  io_latency_get_sleep_length(struct rq *rq);
+extern s64  io_latency_get_sleep_length(struct rq *rq);
 #else
-static inline void io_latency_init(struct rq *rq)
+static inline void io_latency_init(void)
 {
 	;
 }
@@ -31,7 +31,7 @@ static inline void io_latency_end(struct rq *rq, struct task_struct *tsk)
 	;
 }
 
-static inline int io_latency_get_sleep_length(struct rq *rq)
+static inline s64 io_latency_get_sleep_length(struct rq *rq)
 {
 	return 0;
 }
-- 
1.9.1

