Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3DQQZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:25:00 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55947 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3DQQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:24:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] nohz: Force boot CPU outside full dynticks range
Date: Wed, 17 Apr 2013 18:24:47 +0200
Message-Id: <1366215889-2635-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366215889-2635-1-git-send-email-fweisbec@gmail.com>
References: <1366215889-2635-1-git-send-email-fweisbec@gmail.com>
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
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    4 +-
 kernel/time/tick-sched.c            |   54 +++++++++-------------------------
 2 files changed, 17 insertions(+), 41 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82365dd..887b297 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1916,8 +1916,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	nohz_full=	[KNL,BOOT]
 			In kernels built with CONFIG_NO_HZ_FULL=y, set
 			the specified list of CPUs whose tick will be stopped
-			whenever possible. You need to keep at least one online
-			CPU outside the range to maintain the timekeeping.
+			whenever possible. The boot CPU will be forced outside
+			the range to maintain the timekeeping.
 
 	noiotrap	[SH] Disables trapped I/O port accesses.
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 369b576..2bac5ea 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -158,11 +158,21 @@ int tick_nohz_full_cpu(int cpu)
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
 static int __init tick_nohz_full_setup(char *str)
 {
+	int cpu;
+
 	alloc_bootmem_cpumask_var(&nohz_full_mask);
-	if (cpulist_parse(str, nohz_full_mask) < 0)
+	if (cpulist_parse(str, nohz_full_mask) < 0) {
 		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
-	else
-		have_nohz_full_mask = true;
+		return 1;
+	}
+
+	cpu = smp_processor_id();
+	if (cpumask_test_cpu(cpu, nohz_full_mask)) {
+		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
+		cpumask_clear_cpu(cpu, nohz_full_mask);
+	}
+	have_nohz_full_mask = true;
+
 	return 1;
 }
 __setup("nohz_full=", tick_nohz_full_setup);
@@ -195,42 +205,8 @@ static char __initdata nohz_full_buf[NR_CPUS + 1];
 
 static int __init init_tick_nohz_full(void)
 {
-	cpumask_var_t online_nohz;
-	int cpu;
-
-	if (!have_nohz_full_mask)
-		return 0;
-
-	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-
-	if (!zalloc_cpumask_var(&online_nohz, GFP_KERNEL)) {
-		pr_warning("NO_HZ: Not enough memory to check full nohz mask\n");
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
-	cpumask_and(online_nohz, cpu_online_mask, nohz_full_mask);
-	if (cpumask_equal(online_nohz, cpu_online_mask)) {
-		pr_warning("NO_HZ: Must keep at least one online CPU "
-			   "out of nohz_full range\n");
-		/*
-		 * We know the current CPU doesn't have its tick stopped.
-		 * Let's use it for the timekeeping duty.
-		 */
-		preempt_disable();
-		cpu = smp_processor_id();
-		pr_warning("NO_HZ: Clearing %d from nohz_full range\n", cpu);
-		cpumask_clear_cpu(cpu, nohz_full_mask);
-		preempt_enable();
-	}
-	put_online_cpus();
-	free_cpumask_var(online_nohz);
+	if (have_nohz_full_mask)
+		cpu_notifier(tick_nohz_cpu_down_callback, 0);
 
 	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
-- 
1.7.5.4

