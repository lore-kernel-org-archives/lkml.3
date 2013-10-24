Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3JXJ1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:27:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36738 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3JXJ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:20 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/11] percpu_ida: make percpu_ida percpu size/batch configurable
Date: Thu, 24 Oct 2013 10:26:00 +0100
Message-Id: <1382606764-8309-8-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shli@kernel.org>

Make percpu_ida percpu size/batch configurable. The block-mq-tag will
use it.

After block-mq uses percpu_ida to manage tags, performance is improved.
My test is done in a 2 sockets machine, 12 process cross the 2 sockets.
So if there is lock contention or ipi, should be stressed heavily.
Testing is done for null-blk.

hw_queue_depth	nopatch iops	patch iops
64		~800k/s		~1470k/s
2048		~4470k/s	~4340k/s

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/percpu_ida.h | 18 +++++++++++++++++-
 lib/percpu_ida.c           | 28 +++++++++++-----------------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 0b23edb..56c1403 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -16,6 +16,8 @@ struct percpu_ida {
 	 * percpu_ida_init()
 	 */
 	unsigned			nr_tags;
+	unsigned			percpu_max_size;
+	unsigned			percpu_batch_size;
 
 	struct percpu_ida_cpu __percpu	*tag_cpu;
 
@@ -51,10 +53,24 @@ struct percpu_ida {
 	} ____cacheline_aligned_in_smp;
 };
 
+/*
+ * Number of tags we move between the percpu freelist and the global freelist at
+ * a time
+ */
+#define IDA_DEFAULT_PCPU_BATCH_MOVE	32U
+/* Max size of percpu freelist, */
+#define IDA_DEFAULT_PCPU_SIZE	((IDA_DEFAULT_PCPU_BATCH_MOVE * 3) / 2)
+
 int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
 void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
 
 void percpu_ida_destroy(struct percpu_ida *pool);
-int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags);
+int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
+	unsigned long max_size, unsigned long batch_size);
+static inline int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
+{
+	return __percpu_ida_init(pool, nr_tags, IDA_DEFAULT_PCPU_SIZE,
+		IDA_DEFAULT_PCPU_BATCH_MOVE);
+}
 
 #endif /* __PERCPU_IDA_H__ */
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index bab1ba2..a601d42 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -30,15 +30,6 @@
 #include <linux/spinlock.h>
 #include <linux/percpu_ida.h>
 
-/*
- * Number of tags we move between the percpu freelist and the global freelist at
- * a time
- */
-#define IDA_PCPU_BATCH_MOVE	32U
-
-/* Max size of percpu freelist, */
-#define IDA_PCPU_SIZE		((IDA_PCPU_BATCH_MOVE * 3) / 2)
-
 struct percpu_ida_cpu {
 	/*
 	 * Even though this is percpu, we need a lock for tag stealing by remote
@@ -78,7 +69,7 @@ static inline void steal_tags(struct percpu_ida *pool,
 	struct percpu_ida_cpu *remote;
 
 	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
-	     cpus_have_tags * IDA_PCPU_SIZE > pool->nr_tags / 2;
+	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
 	     cpus_have_tags--) {
 		cpu = cpumask_next(cpu, &pool->cpus_have_tags);
 
@@ -123,7 +114,7 @@ static inline void alloc_global_tags(struct percpu_ida *pool,
 {
 	move_tags(tags->freelist, &tags->nr_free,
 		  pool->freelist, &pool->nr_free,
-		  min(pool->nr_free, IDA_PCPU_BATCH_MOVE));
+		  min(pool->nr_free, pool->percpu_batch_size));
 }
 
 static inline unsigned alloc_local_tag(struct percpu_ida *pool,
@@ -245,17 +236,17 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 		wake_up(&pool->wait);
 	}
 
-	if (nr_free == IDA_PCPU_SIZE) {
+	if (nr_free == pool->percpu_max_size) {
 		spin_lock(&pool->lock);
 
 		/*
 		 * Global lock held and irqs disabled, don't need percpu
 		 * lock
 		 */
-		if (tags->nr_free == IDA_PCPU_SIZE) {
+		if (tags->nr_free == pool->percpu_max_size) {
 			move_tags(pool->freelist, &pool->nr_free,
 				  tags->freelist, &tags->nr_free,
-				  IDA_PCPU_BATCH_MOVE);
+				  pool->percpu_batch_size);
 
 			wake_up(&pool->wait);
 		}
@@ -292,7 +283,8 @@ EXPORT_SYMBOL_GPL(percpu_ida_destroy);
  * Allocation is percpu, but sharding is limited by nr_tags - for best
  * performance, the workload should not span more cpus than nr_tags / 128.
  */
-int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
+int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
+	unsigned long max_size, unsigned long batch_size)
 {
 	unsigned i, cpu, order;
 
@@ -301,6 +293,8 @@ int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
 	init_waitqueue_head(&pool->wait);
 	spin_lock_init(&pool->lock);
 	pool->nr_tags = nr_tags;
+	pool->percpu_max_size = max_size;
+	pool->percpu_batch_size = batch_size;
 
 	/* Guard against overflow */
 	if (nr_tags > (unsigned) INT_MAX + 1) {
@@ -319,7 +313,7 @@ int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
 	pool->nr_free = nr_tags;
 
 	pool->tag_cpu = __alloc_percpu(sizeof(struct percpu_ida_cpu) +
-				       IDA_PCPU_SIZE * sizeof(unsigned),
+				       pool->percpu_max_size * sizeof(unsigned),
 				       sizeof(unsigned));
 	if (!pool->tag_cpu)
 		goto err;
@@ -332,4 +326,4 @@ err:
 	percpu_ida_destroy(pool);
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(percpu_ida_init);
+EXPORT_SYMBOL_GPL(__percpu_ida_init);
-- 
1.8.1.2

