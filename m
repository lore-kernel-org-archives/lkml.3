Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaGHXAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:00:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:48793 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751082AbaGHXAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:00:45 -0400
Date: Tue, 8 Jul 2014 19:00:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.12.22-rt35
Message-ID: <20140708190043.42c8996c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.12.22-rt35 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.12-rt
  Head SHA1: 3d9a32ec9382bfb61fdc45c1eb038dc514cd0bfb


Or to build 3.12.22-rt35 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.12.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.12.22.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.22-rt35.patch.xz



You can also build from 3.12.22-rt34 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.22-rt34-rt35.patch.xz



Enjoy,

-- Steve


Changes from v3.12.22-rt34:

---

Ben Hutchings (1):
      Fix latency histogram after "hrtimer: Set expiry time before switch_hrtimer_base()"

Sebastian Andrzej Siewior (2):
      Revert "migrate_disable pushd down in atomic_dec_and_spin_lock"
      timer: do not spin_trylock() on UP

Steven Rostedt (Red Hat) (1):
      Linux 3.12.22-rt35

----
 kernel/hrtimer.c | 10 +++++-----
 kernel/rtmutex.c |  6 +++---
 kernel/timer.c   | 13 +++++++++++++
 localversion-rt  |  2 +-
 4 files changed, 22 insertions(+), 9 deletions(-)
---------------------------
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index bc0e47dc0a05..c967b718ab37 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1105,6 +1105,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 #endif
 	}
 
+	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
+
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
 	{
 		ktime_t now = new_base->get_time();
@@ -1116,11 +1121,6 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	}
 #endif
 
-	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
-
-	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
-
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 4057bc607923..d1b2ca08b160 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -952,12 +952,12 @@ int atomic_dec_and_spin_lock(atomic_t *atomic, spinlock_t *lock)
 	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
 	if (atomic_add_unless(atomic, -1, 1))
 		return 0;
+	migrate_disable();
 	rt_spin_lock(lock);
-	if (atomic_dec_and_test(atomic)){
-		migrate_disable();
+	if (atomic_dec_and_test(atomic))
 		return 1;
-	}
 	rt_spin_unlock(lock);
+	migrate_enable();
 	return 0;
 }
 EXPORT_SYMBOL(atomic_dec_and_spin_lock);
diff --git a/kernel/timer.c b/kernel/timer.c
index 611a5973d9e1..3b79da2f9c67 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1461,6 +1461,19 @@ void run_local_timers(void)
 	 * the timer softirq.
 	 */
 #ifdef CONFIG_PREEMPT_RT_FULL
+
+#ifndef CONFIG_SMP
+	/*
+	 * The spin_do_trylock() later may fail as the lock may be hold before
+	 * the interrupt arrived. The spin-lock debugging code will raise a
+	 * warning if the try_lock fails on UP. Since this is only an
+	 * optimization for the FULL_NO_HZ case (not to run the timer softirq on
+	 * an nohz_full CPU) we don't really care and shedule the softirq.
+	 */
+	raise_softirq(TIMER_SOFTIRQ);
+	return;
+#endif
+
 	/* On RT, irq work runs from softirq */
 	if (irq_work_needs_cpu()) {
 		raise_softirq(TIMER_SOFTIRQ);
diff --git a/localversion-rt b/localversion-rt
index 21988f9ad53f..366440d74b77 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt34
+-rt35
