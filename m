Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaHUOxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48635 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaHUOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 8/9] nohz: Consolidate nohz full init code
Date: Thu, 21 Aug 2014 16:52:56 +0200
Message-Id: <1408632777-3348-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The supports for CONFIG_NO_HZ_FULL_ALL=y and the nohz_full= kernel
parameter both have their own way to do the same thing: allocate
full dynticks cpumasks, fill them and initialize some state variables.

Lets consolidate that all in the same place.

While at it, convert some regular printk message to warnings when
fundamental allocations fail.

Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f654a8a..eb4af01 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -295,22 +295,12 @@ out:
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
 static int __init tick_nohz_full_setup(char *str)
 {
-	int cpu;
-
 	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
-	alloc_bootmem_cpumask_var(&housekeeping_mask);
 	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
 		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
+		free_bootmem_cpumask_var(tick_nohz_full_mask);
 		return 1;
 	}
-
-	cpu = smp_processor_id();
-	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
-		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
-	}
-	cpumask_andnot(housekeeping_mask,
-		       cpu_possible_mask, tick_nohz_full_mask);
 	tick_nohz_full_running = true;
 
 	return 1;
@@ -349,18 +339,11 @@ static int tick_nohz_init_all(void)
 
 #ifdef CONFIG_NO_HZ_FULL_ALL
 	if (!alloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL)) {
-		pr_err("NO_HZ: Can't allocate full dynticks cpumask\n");
-		return err;
-	}
-	if (!alloc_cpumask_var(&housekeeping_mask, GFP_KERNEL)) {
-		pr_err("NO_HZ: Can't allocate not-full dynticks cpumask\n");
+		WARN(1, "NO_HZ: Can't allocate full dynticks cpumask\n");
 		return err;
 	}
 	err = 0;
 	cpumask_setall(tick_nohz_full_mask);
-	cpumask_clear_cpu(smp_processor_id(), tick_nohz_full_mask);
-	cpumask_clear(housekeeping_mask);
-	cpumask_set_cpu(smp_processor_id(), housekeeping_mask);
 	tick_nohz_full_running = true;
 #endif
 	return err;
@@ -375,6 +358,23 @@ void __init tick_nohz_init(void)
 			return;
 	}
 
+	if (!alloc_cpumask_var(&housekeeping_mask, GFP_KERNEL)) {
+		WARN(1, "NO_HZ: Can't allocate not-full dynticks cpumask\n");
+		cpumask_clear(tick_nohz_full_mask);
+		tick_nohz_full_running = false;
+		return;
+	}
+
+	cpu = smp_processor_id();
+
+	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
+		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
+		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+	}
+
+	cpumask_andnot(housekeeping_mask,
+		       cpu_possible_mask, tick_nohz_full_mask);
+
 	for_each_cpu(cpu, tick_nohz_full_mask)
 		context_tracking_cpu_set(cpu);
 
-- 
1.8.3.1

