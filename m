Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaD0Ohy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:37:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59960 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753054AbaD0OgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:36:09 -0400
Message-Id: <20140427143608.599377625@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 27 Apr 2014 10:36:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>
Subject: [PATCH RT 3/4] cpu_chill: Add a UNINTERRUPTIBLE hrtimer_nanosleep
References: <20140427143558.300461400@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-cpu_chill-Add-a-UNINTERRUPTIBLE-hrtimer_nanosleep.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.82-rt103-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

We hit another bug that was caused by switching cpu_chill() from
msleep() to hrtimer_nanosleep().

This time it is a livelock. The problem is that hrtimer_nanosleep()
calls schedule with the state == TASK_INTERRUPTIBLE. But these means
that if a signal is pending, the scheduler wont schedule, and will
simply change the current task state back to TASK_RUNNING. This
nullifies the whole point of cpu_chill() in the first place. That is,
if a task is spinning on a try_lock() and it preempted the owner of the
lock, if it has a signal pending, it will never give up the CPU to let
the owner of the lock run.

I made a static function __hrtimer_nanosleep() that takes a fifth
parameter "state", which determines the task state of that the
nanosleep() will be in. The normal hrtimer_nanosleep() will act the
same, but cpu_chill() will call the __hrtimer_nanosleep() directly with
the TASK_UNINTERRUPTIBLE state.

cpu_chill() only cares that the first sleep happens, and does not care
about the state of the restart schedule (in hrtimer_nanosleep_restart).

Cc: stable-rt@vger.kernel.org
Reported-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/hrtimer.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a87d70d..5342f82 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1724,12 +1724,13 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
 
-static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
+static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode,
+				unsigned long state)
 {
 	hrtimer_init_sleeper(t, current);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(state);
 		hrtimer_start_expires(&t->timer, mode);
 		if (!hrtimer_active(&t->timer))
 			t->task = NULL;
@@ -1773,7 +1774,8 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 				HRTIMER_MODE_ABS);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 
-	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
+	/* cpu_chill() does not care about restart state. */
+	if (do_nanosleep(&t, HRTIMER_MODE_ABS, TASK_INTERRUPTIBLE))
 		goto out;
 
 	rmtp = restart->nanosleep.rmtp;
@@ -1790,8 +1792,10 @@ out:
 	return ret;
 }
 
-long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
-		       const enum hrtimer_mode mode, const clockid_t clockid)
+static long
+__hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
+		    const enum hrtimer_mode mode, const clockid_t clockid,
+		    unsigned long state)
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
@@ -1804,7 +1808,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
-	if (do_nanosleep(&t, mode))
+	if (do_nanosleep(&t, mode, state))
 		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
@@ -1831,6 +1835,12 @@ out:
 	return ret;
 }
 
+long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
+		       const enum hrtimer_mode mode, const clockid_t clockid)
+{
+	return __hrtimer_nanosleep(rqtp, rmtp, mode, clockid, TASK_INTERRUPTIBLE);
+}
+
 SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 		struct timespec __user *, rmtp)
 {
@@ -1857,7 +1867,8 @@ void cpu_chill(void)
 	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
 
 	current->flags |= PF_NOFREEZE;
-	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	__hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC,
+			    TASK_UNINTERRUPTIBLE);
 	if (!freeze_flag)
 		current->flags &= ~PF_NOFREEZE;
 }
-- 
1.8.5.3


