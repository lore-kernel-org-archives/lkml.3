Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaGPVEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:59730 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaGPVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:34 -0400
Message-Id: <20140716205054.719040247@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 30/64] sched: Make task->real_start_time nanoseconds based
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=sched-make-real-start-time-ktime-t.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the only user of this data by removing the timespec
conversion.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/array.c       |    7 +------
 include/linux/sched.h |    2 +-
 kernel/fork.c         |    3 +--
 3 files changed, 3 insertions(+), 9 deletions(-)

Index: tip/fs/proc/array.c
===================================================================
--- tip.orig/fs/proc/array.c
+++ tip/fs/proc/array.c
@@ -473,13 +473,8 @@ static int do_task_stat(struct seq_file
 	priority = task_prio(task);
 	nice = task_nice(task);
 
-	/* Temporary variable needed for gcc-2.96 */
-	/* convert timespec -> nsec*/
-	start_time =
-		(unsigned long long)task->real_start_time.tv_sec * NSEC_PER_SEC
-				+ task->real_start_time.tv_nsec;
 	/* convert nsec -> ticks */
-	start_time = nsec_to_clock_t(start_time);
+	start_time = nsec_to_clock_t(task->real_start_time);
 
 	seq_printf(m, "%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
 	seq_put_decimal_ll(m, ' ', ppid);
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -1368,7 +1368,7 @@ struct task_struct {
 #endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
-	struct timespec real_start_time;	/* boot based time */
+	u64 real_start_time;	/* boot based time in nsec */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
 
Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -1263,8 +1263,7 @@ static struct task_struct *copy_process(
 	posix_cpu_timers_init(p);
 
 	ktime_get_ts(&p->start_time);
-	p->real_start_time = p->start_time;
-	monotonic_to_bootbased(&p->real_start_time);
+	p->real_start_time = ktime_get_boot_ns();
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	if (clone_flags & CLONE_THREAD)


