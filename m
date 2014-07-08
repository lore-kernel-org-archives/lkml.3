Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaGHXBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:01:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56149 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085AbaGHXBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:01:09 -0400
Date: Tue, 8 Jul 2014 19:01:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.10.44-rt46
Message-ID: <20140708190107.73506103@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.10.44-rt46 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.10-rt
  Head SHA1: 6cdb407a1ef32c5f757af68ea294505c6dd1ed4c


Or to build 3.10.44-rt46 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.44.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.44-rt46.patch.xz



You can also build from 3.10.44-rt45 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.44-rt45-rt46.patch.xz



Enjoy,

-- Steve


Changes from v3.10.44-rt45:

---

Ben Hutchings (1):
      Fix latency histogram after "hrtimer: Set expiry time before switch_hrtimer_base()"

Sebastian Andrzej Siewior (1):
      timer: do not spin_trylock() on UP

Steven Rostedt (Red Hat) (1):
      Linux 3.10.44-rt46

----
 kernel/hrtimer.c | 10 +++++-----
 kernel/timer.c   | 13 +++++++++++++
 localversion-rt  |  2 +-
 3 files changed, 19 insertions(+), 6 deletions(-)
---------------------------
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f7a3a7a5a61b..1defbda1def8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1102,6 +1102,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
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
@@ -1113,11 +1118,6 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	}
 #endif
 
-	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
-
-	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
-
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
diff --git a/kernel/timer.c b/kernel/timer.c
index 26cca8b924e7..40cfa14131ca 100644
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
index 38c40b21a885..272158183778 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt45
+-rt46
