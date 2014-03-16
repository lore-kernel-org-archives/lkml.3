Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaCPQgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:36:52 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:61268 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbaCPQgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:36:50 -0400
Date: Sun, 16 Mar 2014 17:36:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140316163645.GA10946@gmail.com>
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

   # HEAD: 96b3d28bf4b00f62fc8386ff5d487d1830793a3d sched/clock: Prevent tracing recursion in sched_clock_cpu()

Three small fixes.

 Thanks,

	Ingo

------------------>
Fernando Luis Vazquez Cao (1):
      sched/clock: Prevent tracing recursion in sched_clock_cpu()

Juri Lelli (1):
      sched/deadline: Deny unprivileged users to set/change SCHED_DEADLINE policy

Peter Zijlstra (1):
      stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()


 kernel/sched/clock.c  | 4 ++--
 kernel/sched/core.c   | 9 +++++++++
 kernel/stop_machine.c | 2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 43c2bcc..b30a292 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -301,14 +301,14 @@ u64 sched_clock_cpu(int cpu)
 	if (unlikely(!sched_clock_running))
 		return 0ull;
 
-	preempt_disable();
+	preempt_disable_notrace();
 	scd = cpu_sdc(cpu);
 
 	if (cpu != smp_processor_id())
 		clock = sched_clock_remote(scd);
 	else
 		clock = sched_clock_local(scd);
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return clock;
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6edbef2..f5c6635 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3338,6 +3338,15 @@ recheck:
 				return -EPERM;
 		}
 
+		 /*
+		  * Can't set/change SCHED_DEADLINE policy at all for now
+		  * (safest behavior); in the future we would like to allow
+		  * unprivileged DL tasks to increase their relative deadline
+		  * or reduce their runtime (both ways reducing utilization)
+		  */
+		if (dl_policy(policy))
+			return -EPERM;
+
 		/*
 		 * Treat SCHED_IDLE as nice 20. Only allow a switch to
 		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 84571e0..01fbae5 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -293,7 +293,7 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 	 */
 	smp_call_function_single(min(cpu1, cpu2),
 				 &irq_cpu_stop_queue_work,
-				 &call_args, 0);
+				 &call_args, 1);
 	lg_local_unlock(&stop_cpus_lock);
 	preempt_enable();
 
