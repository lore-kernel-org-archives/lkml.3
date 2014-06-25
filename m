Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaFYLHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:07:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41129 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbaFYLHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH -repost 09/21] kgr: mark task_safe in some kthreads
Date: Wed, 25 Jun 2014 13:07:03 +0200
Message-Id: <1403694435-3180-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we enable a kthread support in kGraft, we must make sure all
kthreads mark themselves as kGraft-safe at some point explicitly.

We do this by injecting kgr_task_safe to the freezer test. There, we
assume that kthreads are in some predefined state and can expect
something bad to happen. Hence we switch the kGraft worlds there from
the old one to the new one. The optimal solution would be to convert
most of kthreads (that need not be kthreads actually) to workqeues as
suggested by Tejun. This is an upcoming work that will appear next.
But until we get there, we use freezer for kGraft that way as is
presented here.

Note that there are also some kthreads that do not utilize freezer, so
we use kgr_task_safe in them explicitly. This happens at locations
that appear to be safe for the kthreads to switch the worlds.

The end result after we migrate kthreads (that need not be kthreads)
to workqueues is: have only kthreads that contain kgr_task_safe
explicitly (or using some helper) and nothing else.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> [devtmpfs]
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com> [rcu]
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/base/devtmpfs.c     |  1 +
 drivers/scsi/scsi_error.c   |  2 ++
 drivers/usb/core/hub.c      |  4 ++--
 fs/jbd2/journal.c           |  2 ++
 fs/notify/mark.c            |  5 ++++-
 include/linux/freezer.h     |  2 ++
 kernel/hung_task.c          |  5 ++++-
 kernel/kthread.c            |  3 +++
 kernel/rcu/tree.c           |  6 ++++--
 kernel/rcu/tree_plugin.h    | 10 ++++++++--
 kernel/smpboot.c            |  2 ++
 kernel/workqueue.c          |  3 +++
 mm/huge_memory.c            |  1 +
 net/bluetooth/rfcomm/core.c |  2 ++
 14 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 25798db14553..c7d52d1b8c9c 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -387,6 +387,7 @@ static int devtmpfsd(void *p)
 	sys_chroot(".");
 	complete(&setup_done);
 	while (1) {
+		kgr_task_safe(current);
 		spin_lock(&req_lock);
 		while (requests) {
 			struct req *req = requests;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cbe38e5e7955..28bc61251e2a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2153,6 +2153,8 @@ int scsi_error_handler(void *data)
 	 * disables signal delivery for the created thread.
 	 */
 	while (!kthread_should_stop()) {
+		kgr_task_safe(current);
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 21b99b4b4082..85a53488ed3f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5070,9 +5070,9 @@ static int hub_thread(void *__unused)
 
 	do {
 		hub_events();
-		wait_event_freezable(khubd_wait,
+		wait_event_freezable(khubd_wait, ({ kgr_task_safe(current);
 				!list_empty(&hub_event_list) ||
-				kthread_should_stop());
+				kthread_should_stop(); }));
 	} while (!kthread_should_stop() || !list_empty(&hub_event_list));
 
 	pr_debug("%s: khubd exiting\n", usbcore_name);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 67b8e303946c..1b9c4c2e014a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -43,6 +43,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bitops.h>
 #include <linux/ratelimit.h>
+#include <linux/sched.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/jbd2.h>
@@ -260,6 +261,7 @@ loop:
 			write_lock(&journal->j_state_lock);
 		}
 		finish_wait(&journal->j_wait_commit, &wait);
+		kgr_task_safe(current);
 	}
 
 	jbd_debug(1, "kjournald2 wakes\n");
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index d90deaa08e78..d30a491cacf2 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -82,6 +82,7 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -355,7 +356,9 @@ static int fsnotify_mark_destroy(void *ignored)
 			fsnotify_put_mark(mark);
 		}
 
-		wait_event_interruptible(destroy_waitq, !list_empty(&destroy_list));
+		wait_event_interruptible(destroy_waitq, ({
+					kgr_task_safe(current);
+					!list_empty(&destroy_list); }));
 	}
 
 	return 0;
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 7fd81b8c4897..e08c3bef251b 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -61,6 +61,8 @@ static inline bool try_to_freeze_unsafe(void)
 
 static inline bool try_to_freeze(void)
 {
+	kgr_task_safe(current);
+
 	if (!(current->flags & PF_NOFREEZE))
 		debug_check_no_locks_held();
 	return try_to_freeze_unsafe();
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 06db12434d72..3d59261a8e2c 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/lockdep.h>
 #include <linux/export.h>
+#include <linux/sched.h>
 #include <linux/sysctl.h>
 #include <linux/utsname.h>
 #include <trace/events/sched.h>
@@ -229,8 +230,10 @@ static int watchdog(void *dummy)
 	for ( ; ; ) {
 		unsigned long timeout = sysctl_hung_task_timeout_secs;
 
-		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
+		while (schedule_timeout_interruptible(timeout_jiffies(timeout))) {
+			kgr_task_safe(current);
 			timeout = sysctl_hung_task_timeout_secs;
+		}
 
 		if (atomic_xchg(&reset_hung_task, 0))
 			continue;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index c2390f41307b..099ff4a07753 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -111,6 +111,8 @@ bool kthread_freezable_should_stop(bool *was_frozen)
 {
 	bool frozen = false;
 
+	kgr_task_safe(current);
+
 	might_sleep();
 
 	if (unlikely(freezing(current)))
@@ -497,6 +499,7 @@ int kthreadd(void *unused)
 		if (list_empty(&kthread_create_list))
 			schedule();
 		__set_current_state(TASK_RUNNING);
+		kgr_task_safe(current);
 
 		spin_lock(&kthread_create_lock);
 		while (!list_empty(&kthread_create_list)) {
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba77363fbb..51acec198818 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1701,9 +1701,10 @@ static int __noreturn rcu_gp_kthread(void *arg)
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("reqwait"));
 			rsp->gp_state = RCU_GP_WAIT_GPS;
-			wait_event_interruptible(rsp->gp_wq,
+			wait_event_interruptible(rsp->gp_wq, ({
+						 kgr_task_safe(current);
 						 ACCESS_ONCE(rsp->gp_flags) &
-						 RCU_GP_FLAG_INIT);
+						 RCU_GP_FLAG_INIT; }));
 			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
@@ -1735,6 +1736,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 					(!ACCESS_ONCE(rnp->qsmask) &&
 					 !rcu_preempt_blocked_readers_cgp(rnp)),
 					j);
+			kgr_task_safe(current);
 			/* Locking provides needed memory barriers. */
 			/* If grace period done, leave loop. */
 			if (!ACCESS_ONCE(rnp->qsmask) &&
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cbc2c45265e2..ac012deb387b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -27,6 +27,7 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 #include <linux/oom.h>
+#include <linux/sched.h>
 #include <linux/smpboot.h>
 #include "../time/tick-internal.h"
 
@@ -1224,7 +1225,8 @@ static int rcu_boost_kthread(void *arg)
 	for (;;) {
 		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
 		trace_rcu_utilization(TPS("End boost kthread@rcu_wait"));
-		rcu_wait(rnp->boost_tasks || rnp->exp_tasks);
+		rcu_wait(({ kgr_task_safe(current);
+					rnp->boost_tasks || rnp->exp_tasks; }));
 		trace_rcu_utilization(TPS("Start boost kthread@rcu_wait"));
 		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
@@ -2227,11 +2229,15 @@ static int rcu_nocb_kthread(void *arg)
 
 	/* Each pass through this loop invokes one batch of callbacks */
 	for (;;) {
+		kgr_task_safe(current);
+
 		/* If not polling, wait for next batch of callbacks. */
 		if (!rcu_nocb_poll) {
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("Sleep"));
-			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
+			wait_event_interruptible(rdp->nocb_wq, ({
+						kgr_task_safe(current);
+						rdp->nocb_head; }));
 			/* Memory barrier provide by xchg() below. */
 		} else if (firsttime) {
 			firsttime = 0;
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index eb89e1807408..9764c83c0ef2 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -107,6 +107,8 @@ static int smpboot_thread_fn(void *data)
 	struct smp_hotplug_thread *ht = td->ht;
 
 	while (1) {
+		kgr_task_safe(current);
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		preempt_disable();
 		if (kthread_should_stop()) {
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6203d2900877..69222618d3e4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2231,6 +2231,7 @@ sleep:
 	__set_current_state(TASK_INTERRUPTIBLE);
 	spin_unlock_irq(&pool->lock);
 	schedule();
+	kgr_task_safe(current);
 	goto woke_up;
 }
 
@@ -2272,6 +2273,8 @@ static int rescuer_thread(void *__rescuer)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	kgr_task_safe(current);
+
 	/*
 	 * By the time the rescuer is requested to stop, the workqueue
 	 * shouldn't have any work pending, but @wq->maydays may still have
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e60837dc785c..fbcff9041fca 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2699,6 +2699,7 @@ static void khugepaged_do_scan(void)
 			break;
 
 		cond_resched();
+		kgr_task_safe(current);
 
 		if (unlikely(kthread_should_stop() || freezing(current)))
 			break;
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 754b6fe4f742..65c27adea565 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -2094,6 +2094,8 @@ static int rfcomm_run(void *unused)
 		if (kthread_should_stop())
 			break;
 
+		kgr_task_safe(current);
+
 		/* Process stuff */
 		rfcomm_process_sessions();
 
-- 
2.0.0

