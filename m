Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3DNPv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 11:51:56 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:45918 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3DNPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 11:51:55 -0400
Date: Sun, 14 Apr 2013 17:51:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20130414155149.GA6216@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: e614b3332a4f3f264a26da28e5a1f4cc3aea3974 sched/cputime: Fix accounting on multi-threaded processes

Misc fixlets.

 Thanks,

	Ingo

------------------>
Stanislaw Gruszka (1):
      sched/cputime: Fix accounting on multi-threaded processes

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems

libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow


 kernel/sched/clock.c   | 26 ++++++++++++++++++++++++++
 kernel/sched/core.c    |  8 +++++---
 kernel/sched/cputime.c |  2 +-
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c685e31..c3ae144 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -176,10 +176,36 @@ static u64 sched_clock_remote(struct sched_clock_data *scd)
 	u64 this_clock, remote_clock;
 	u64 *ptr, old_val, val;
 
+#if BITS_PER_LONG != 64
+again:
+	/*
+	 * Careful here: The local and the remote clock values need to
+	 * be read out atomic as we need to compare the values and
+	 * then update either the local or the remote side. So the
+	 * cmpxchg64 below only protects one readout.
+	 *
+	 * We must reread via sched_clock_local() in the retry case on
+	 * 32bit as an NMI could use sched_clock_local() via the
+	 * tracer and hit between the readout of
+	 * the low32bit and the high 32bit portion.
+	 */
+	this_clock = sched_clock_local(my_scd);
+	/*
+	 * We must enforce atomic readout on 32bit, otherwise the
+	 * update on the remote cpu can hit inbetween the readout of
+	 * the low32bit and the high 32bit portion.
+	 */
+	remote_clock = cmpxchg64(&scd->clock, 0, 0);
+#else
+	/*
+	 * On 64bit the read of [my]scd->clock is atomic versus the
+	 * update, so we can avoid the above 32bit dance.
+	 */
 	sched_clock_local(my_scd);
 again:
 	this_clock = my_scd->clock;
 	remote_clock = scd->clock;
+#endif
 
 	/*
 	 * Use the opportunity that we have both locks
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7b03cd..fa07792 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1488,8 +1488,10 @@ static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
 
-	BUG_ON(rq != this_rq());
-	BUG_ON(p == current);
+	if (WARN_ON_ONCE(rq != this_rq()) ||
+	    WARN_ON_ONCE(p == current))
+		return;
+
 	lockdep_assert_held(&rq->lock);
 
 	if (!raw_spin_trylock(&p->pi_lock)) {
@@ -4931,7 +4933,7 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 }
 
 static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX;
+static int max_load_idx = CPU_LOAD_IDX_MAX-1;
 
 static void
 set_table_entry(struct ctl_table *entry,
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..e93cca9 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -310,7 +310,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	t = tsk;
 	do {
-		task_cputime(tsk, &utime, &stime);
+		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
