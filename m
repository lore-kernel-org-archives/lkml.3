Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaIJVdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:33:51 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58860 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaIJVdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:33:45 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7/8] nohz: Consolidate nohz full init code
Date: Wed, 10 Sep 2014 23:33:27 +0200
Message-Id: <1410384808-14760-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The supports for CONFIG_NO_HZ_FULL_ALL=y and the nohz_full= kernel
parameter both have their own way to do the same thing: allocate
full dynticks cpumasks, fill them and initialize some state variables.

Lets consolidate that all in the same place.

While at it, convert some regular printk message to warnings when
fundamental allocations fail.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 99aa6ee..45cdfbb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -281,22 +281,12 @@ out:
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
@@ -335,18 +325,11 @@ static int tick_nohz_init_all(void)
 
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
@@ -361,6 +344,23 @@ void __init tick_nohz_init(void)
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
2.1.0

