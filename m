Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3C0Pc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:32:58 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:37034 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3C0Pcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:32:53 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4] nohz: Force boot CPU outside full dynticks range
Date: Wed, 27 Mar 2013 16:32:36 +0100
Message-Id: <1364398359-21990-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timekeeping job must be able to run early on boot
because there may be some pre-SMP (and thus pre-initcalls )
components that rely on it. The IO-APIC is one such users
as it tests the timer health by watching jiffies progression.

Given that it happens before we know the initial online
set, we can't rely on it to select a timekeeper. We need
one before SMP time otherwise we simply crash on boot.

To fix this and keep things simple for now, force the boot CPU
outside of the full dynticks range in any case and do this early
on kernel parameter parsing time.

We might want a trickier solution later, expecially for aSMP
architectures that need to assign housekeeping tasks to arbitrary
low power CPUs.

But it's still first pass KISS time for now.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    4 +-
 kernel/time/tick-sched.c            |   52 ++++++++++-------------------------
 2 files changed, 17 insertions(+), 39 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 231698f..28e039c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1916,8 +1916,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	nohz_extended=  [KNL,BOOT]
 			In kernels built with CONFIG_NO_HZ_EXTENDED=y, set
 			the specified list of CPUs whose tick will be stopped
-			whenever possible. You need to keep at least one online
-			CPU outside the range to maintain the timekeeping.
+			whenever possible. The boot CPU will be forced outside
+			the range to maintain the timekeeping.
 
 	noiotrap	[SH] Disables trapped I/O port accesses.
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 57bb3fe..74bc7f1 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -158,11 +158,21 @@ int tick_nohz_extended_cpu(int cpu)
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
 static int __init tick_nohz_extended_setup(char *str)
 {
+	int cpu;
+
 	alloc_bootmem_cpumask_var(&nohz_extended_mask);
-	if (cpulist_parse(str, nohz_extended_mask) < 0)
+	if (cpulist_parse(str, nohz_extended_mask) < 0) {
 		pr_warning("NOHZ: Incorrect nohz_extended cpumask\n");
-	else
-		have_nohz_extended_mask = true;
+		return 1;
+	}
+
+	cpu = smp_processor_id();
+	if (cpumask_test_cpu(cpu, nohz_extended_mask)) {
+		pr_warning("NO_HZ: Clearing %d from nohz_extended range for timekeeping\n", cpu);
+		cpumask_clear_cpu(cpu, nohz_extended_mask);
+	}
+	have_nohz_extended_mask = true;
+
 	return 1;
 }
 __setup("nohz_extended=", tick_nohz_extended_setup);
@@ -188,42 +198,10 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 
 static int __init init_tick_nohz_extended(void)
 {
-	cpumask_var_t online_nohz;
 	int cpu;
 
-	if (!have_nohz_extended_mask)
-		return 0;
-
-	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-
-	if (!zalloc_cpumask_var(&online_nohz, GFP_KERNEL)) {
-		pr_warning("NO_HZ: Not enough memory to check extended nohz mask\n");
-		return -ENOMEM;
-	}
-
-	/*
-	 * CPUs can probably not be concurrently offlined on initcall time.
-	 * But we are paranoid, aren't we?
-	 */
-	get_online_cpus();
-
-	/* Ensure we keep a CPU outside the dynticks range for timekeeping */
-	cpumask_and(online_nohz, cpu_online_mask, nohz_extended_mask);
-	if (cpumask_equal(online_nohz, cpu_online_mask)) {
-		pr_warning("NO_HZ: Must keep at least one online CPU "
-			   "out of nohz_extended range\n");
-		/*
-		 * We know the current CPU doesn't have its tick stopped.
-		 * Let's use it for the timekeeping duty.
-		 */
-		preempt_disable();
-		cpu = smp_processor_id();
-		pr_warning("NO_HZ: Clearing %d from nohz_extended range\n", cpu);
-		cpumask_clear_cpu(cpu, nohz_extended_mask);
-		preempt_enable();
-	}
-	put_online_cpus();
-	free_cpumask_var(online_nohz);
+	if (have_nohz_extended_mask)
+		cpu_notifier(tick_nohz_cpu_down_callback, 0);
 
 	return 0;
 }
-- 
1.7.5.4

