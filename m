Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbaCRVkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:40:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:26727 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751575AbaCRVj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:39:59 -0400
Date: Tue, 18 Mar 2014 17:39:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.2.55-rt81
Message-ID: <20140318173957.2a174fa6@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.55-rt81 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.2-rt
  Head SHA1: 3c8ce5f0a334826f3341a8233503d4748df11a3b


Or to build 3.2.55-rt81 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.55.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.55-rt81.patch.xz



You can also build from 3.2.55-rt80 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.55-rt80-rt81.patch.xz



Enjoy,

-- Steve


Changes from v3.2.55-rt80:

---

Marc Kleine-Budde (1):
      net: sched: dev_deactivate_many(): use msleep(1) instead of yield() to wait for outstanding qdisc_run calls

Sebastian Andrzej Siewior (1):
      fs: jbd2: pull your plug when waiting for space

Steven Rostedt (1):
      cpu_chill: Add a UNINTERRUPTIBLE hrtimer_nanosleep

Steven Rostedt (Red Hat) (1):
      Linux 3.2.55-rt81

----
 fs/jbd2/checkpoint.c    |  2 ++
 kernel/hrtimer.c        | 25 ++++++++++++++++++-------
 localversion-rt         |  2 +-
 net/sched/sch_generic.c |  2 +-
 4 files changed, 22 insertions(+), 9 deletions(-)
---------------------------
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 16a698b..c6443c3 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -129,6 +129,8 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 		if (journal->j_flags & JBD2_ABORT)
 			return;
 		write_unlock(&journal->j_state_lock);
+		if (current->plug)
+			io_schedule();
 		mutex_lock(&journal->j_checkpoint_mutex);
 
 		/*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 71acc21..0316f75 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1726,12 +1726,13 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
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
@@ -1775,7 +1776,8 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 				HRTIMER_MODE_ABS);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 
-	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
+	/* cpu_chill() does not care about restart state. */
+	if (do_nanosleep(&t, HRTIMER_MODE_ABS, TASK_INTERRUPTIBLE))
 		goto out;
 
 	rmtp = restart->nanosleep.rmtp;
@@ -1792,8 +1794,10 @@ out:
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
@@ -1806,7 +1810,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
-	if (do_nanosleep(&t, mode))
+	if (do_nanosleep(&t, mode, state))
 		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
@@ -1833,6 +1837,12 @@ out:
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
@@ -1859,7 +1869,8 @@ void cpu_chill(void)
 	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
 
 	current->flags |= PF_NOFREEZE;
-	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	__hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC,
+			    TASK_UNINTERRUPTIBLE);
 	if (!freeze_flag)
 		current->flags &= ~PF_NOFREEZE;
 }
diff --git a/localversion-rt b/localversion-rt
index 5ba2c20..8269ec1 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt80
+-rt81
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 69fca27..9ede52e 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -847,7 +847,7 @@ void dev_deactivate_many(struct list_head *head)
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, unreg_list)
 		while (some_qdisc_is_busy(dev))
-			yield();
+			msleep(1);
 }
 
 void dev_deactivate(struct net_device *dev)
