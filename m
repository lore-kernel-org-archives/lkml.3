Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbaJaXVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:21:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:44609 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbaJaXVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:21:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="615021350"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH RFC] sched/deadline: support dl task migrate during cpu hotplug
Date: Sat,  1 Nov 2014 07:21:11 +0800
Message-Id: <1414797671-121836-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I observe that dl task can't be migrated to other cpus during cpu hotplug, in 
addition, task may/may not be running again if cpu is added back. The root cause 
which I found is that dl task will be throtted and removed from dl rq after 
comsuming all budget, which leads to stop task can't pick it up from dl rq and 
migrate to other cpus during hotplug. 

So I try two methods.

- add throttled dl sched_entity to a throttled_list, the list will be traversed
  during cpu hotplug, and the dl sched_entity will be picked and enqueue, then 
  stop task will pick and migrate it. However, dl sched_entity is throttled again 
  before stop task running since the below path. This path will set rq->online 0 
  which lead to set_rq_offline() won't be called in function migration_call().

Call Trace:
 [...] rq_offline_dl+0x44/0x66
 [...] set_rq_offline+0x29/0x54
 [...] rq_attach_root+0x3f/0xb7
 [...] cpu_attach_domain+0x1c7/0x354
 [...] build_sched_domains+0x295/0x304
 [...] partition_sched_domains+0x26a/0x2e6
 [...] ? emulator_write_gpr+0x27/0x27 [kvm]
 [...] cpuset_update_active_cpus+0x12/0x2c
 [...] cpuset_cpu_inactive+0x1b/0x38
 [...] notifier_call_chain+0x32/0x5e
 [...] __raw_notifier_call_chain+0x9/0xb
 [...] __cpu_notify+0x1b/0x2d
 [...] _cpu_down+0x81/0x22a
 [...] cpu_down+0x28/0x35
 [...] cpu_subsys_offline+0xf/0x11
 [...] device_offline+0x78/0xa8
 [...] online_store+0x48/0x69
 [...] ? kernfs_fop_write+0x61/0x129
 [...] dev_attr_store+0x1b/0x1d
 [...] sysfs_kf_write+0x37/0x39
 [...] kernfs_fop_write+0xe9/0x129
 [...] vfs_write+0xc6/0x19e
 [...] SyS_write+0x4b/0x8f
 [...] system_call_fastpath+0x16/0x1b


- The difference of the method two is that dl sched_entity won't be throtted
  if rq is offline, the dl sched_entity will be replenished in update_curr_dl().
  However, the echo 0 > /sys/devices/system/cpu/cpuN/online hung.

Juri, your proposal is a great welcome. ;-)

Note: This patch is just a proposal and still can't successfully migrate 
dl task during cpu hotplug.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 include/linux/sched.h   |  2 ++
 kernel/sched/deadline.c | 22 +++++++++++++++++++++-
 kernel/sched/sched.h    |  3 +++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4400ddc..bd71f19 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1253,6 +1253,8 @@ struct sched_dl_entity {
 	 * own bandwidth to be enforced, thus we need one timer per task.
 	 */
 	struct hrtimer dl_timer;
+	struct list_head throttled_node;
+	int on_list;
 };
 
 union rcu_special {
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2e31a30..d6d6b71 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -80,6 +80,7 @@ void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
 	dl_rq->dl_nr_migratory = 0;
 	dl_rq->overloaded = 0;
 	dl_rq->pushable_dl_tasks_root = RB_ROOT;
+	INIT_LIST_HEAD(&dl_rq->throttled_list);
 #else
 	init_dl_bw(&dl_rq->dl_bw);
 #endif
@@ -538,6 +539,10 @@ again:
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_yielded = 0;
+	if (dl_se->on_list) {
+		list_del(&dl_se->throttled_node);
+		dl_se->on_list = 0;
+	}
 	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (dl_task(rq->curr))
@@ -636,8 +641,12 @@ static void update_curr_dl(struct rq *rq)
 	dl_se->runtime -= delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
-		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
+		if (rq->online && likely(start_dl_timer(dl_se, curr->dl.dl_boosted))) {
 			dl_se->dl_throttled = 1;
+			dl_se->on_list = 1;
+			list_add(&dl_se->throttled_node,
+					&rq->dl.throttled_list);
+		}
 		else
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
 
@@ -1593,9 +1602,20 @@ static void rq_online_dl(struct rq *rq)
 /* Assumes rq->lock is held */
 static void rq_offline_dl(struct rq *rq)
 {
+	struct task_struct *p, *n;
+
 	if (rq->dl.overloaded)
 		dl_clear_overload(rq);
 
+	/* Make sched_dl_entity available for pick_next_task() */
+	list_for_each_entry_safe(p, n, &rq->dl.throttled_list, dl.throttled_node) {
+		p->dl.dl_throttled = 0;
+		hrtimer_cancel(&p->dl.dl_timer);
+		p->dl.dl_runtime = p->dl.dl_runtime;
+		if (task_on_rq_queued(p))
+			enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
+	}
+
 	cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ec3917c..8f95036 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -482,6 +482,9 @@ struct dl_rq {
 	 */
 	struct rb_root pushable_dl_tasks_root;
 	struct rb_node *pushable_dl_tasks_leftmost;
+
+	struct list_head throttled_list;
+
 #else
 	struct dl_bw dl_bw;
 #endif
-- 
1.9.1

