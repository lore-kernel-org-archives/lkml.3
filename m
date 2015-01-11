Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbbAKIr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 03:47:58 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:39295 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbAKIrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:47:55 -0500
Date: Sun, 11 Jan 2015 09:47:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@ftp.linux.org.uk>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20150111084750.GA2024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 7f1a169b88f513e32a432ca0f85bfd282d117bd6 sched/fair: Fix RCU stall upon -ENOMEM in sched_create_group()

[ Note: the fs/notify/fanotify/fanotify_user.c fix is an out of 
  tree fix, found by nested sleep debugging - I hope it's fine to
  merge it this way, Al Cc:-ed. ]

Misc fixes: group scheduling corner case fix, two deadline 
scheduler fixes, effective_load() overflow fix, nested sleep fix, 
6144 CPUs system fix.

 Thanks,

	Ingo

------------------>
Alex Thorlton (1):
      sched: Fix KMALLOC_MAX_SIZE overflow during cpumask allocation

Luca Abeni (2):
      sched/deadline: Fix migration of SCHED_DEADLINE tasks
      sched/deadline: Avoid double-accounting in case of missed deadlines

Peter Zijlstra (1):
      sched, fanotify: Deal with nested sleeps

Tetsuo Handa (1):
      sched/fair: Fix RCU stall upon -ENOMEM in sched_create_group()

Yuyang Du (1):
      sched: Fix odd values in effective_load() calculations


 fs/notify/fanotify/fanotify_user.c | 10 +++++-----
 kernel/sched/core.c                | 13 +++++--------
 kernel/sched/deadline.c            | 25 ++++---------------------
 kernel/sched/fair.c                |  6 +++++-
 4 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c991616acca9..bff8567aa42d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -259,16 +259,15 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 	struct fsnotify_event *kevent;
 	char __user *start;
 	int ret;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	start = buf;
 	group = file->private_data;
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
+	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
-
 		mutex_lock(&group->notification_mutex);
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
@@ -289,7 +288,8 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 
 			if (start != buf)
 				break;
-			schedule();
+
+			wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 			continue;
 		}
 
@@ -318,8 +318,8 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 		buf += ret;
 		count -= ret;
 	}
+	remove_wait_queue(&group->notification_waitq, &wait);
 
-	finish_wait(&group->notification_waitq, &wait);
 	if (start != buf && ret != -EFAULT)
 		ret = buf - start;
 	return ret;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5797b78add6..c0accc00566e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7113,9 +7113,6 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size += num_possible_cpus() * cpumask_size();
-#endif
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
@@ -7135,13 +7132,13 @@ void __init sched_init(void)
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_RT_GROUP_SCHED */
+	}
 #ifdef CONFIG_CPUMASK_OFFSTACK
-		for_each_possible_cpu(i) {
-			per_cpu(load_balance_mask, i) = (void *)ptr;
-			ptr += cpumask_size();
-		}
-#endif /* CONFIG_CPUMASK_OFFSTACK */
+	for_each_possible_cpu(i) {
+		per_cpu(load_balance_mask, i) = (cpumask_var_t)kzalloc_node(
+			cpumask_size(), GFP_KERNEL, cpu_to_node(i));
 	}
+#endif /* CONFIG_CPUMASK_OFFSTACK */
 
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e5db8c6feebd..b52092f2636d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -570,24 +570,7 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
 static
 int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 {
-	int dmiss = dl_time_before(dl_se->deadline, rq_clock(rq));
-	int rorun = dl_se->runtime <= 0;
-
-	if (!rorun && !dmiss)
-		return 0;
-
-	/*
-	 * If we are beyond our current deadline and we are still
-	 * executing, then we have already used some of the runtime of
-	 * the next instance. Thus, if we do not account that, we are
-	 * stealing bandwidth from the system at each deadline miss!
-	 */
-	if (dmiss) {
-		dl_se->runtime = rorun ? dl_se->runtime : 0;
-		dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
-	}
-
-	return 1;
+	return (dl_se->runtime <= 0);
 }
 
 extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
@@ -826,10 +809,10 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se,
 	 * parameters of the task might need updating. Otherwise,
 	 * we want a replenishment of its runtime.
 	 */
-	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
-		replenish_dl_entity(dl_se, pi_se);
-	else
+	if (dl_se->dl_new || flags & ENQUEUE_WAKEUP)
 		update_dl_entity(dl_se, pi_se);
+	else if (flags & ENQUEUE_REPLENISH)
+		replenish_dl_entity(dl_se, pi_se);
 
 	__enqueue_dl_entity(dl_se);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf77f899..40667cbf371b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4005,6 +4005,10 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b, bool force)
 
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
+	/* init_cfs_bandwidth() was not called */
+	if (!cfs_b->throttled_cfs_rq.next)
+		return;
+
 	hrtimer_cancel(&cfs_b->period_timer);
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
@@ -4424,7 +4428,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		 * wl = S * s'_i; see (2)
 		 */
 		if (W > 0 && w < W)
-			wl = (w * tg->shares) / W;
+			wl = (w * (long)tg->shares) / W;
 		else
 			wl = tg->shares;
 
