Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbaCEOqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:46:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaCEOqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:46:12 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, toshi.kani@hp.com, prarit@redhat.com,
        kirill.shutemov@linux.intel.com, JBeulich@suse.com,
        peterz@infradead.org, paul.gortmaker@windriver.com,
        seiji.aguchi@hds.com, bp@suse.de, imammedo@redhat.com, hpa@zytor.com,
        mingo@redhat.com, x86@kernel.org, tglx@linutronix.de, riel@redhat.com
Subject: [PATCH] abort secondary CPU bring-up gracefully if do_boot_cpu timed out on cpu_callin_mask
Date: Wed,  5 Mar 2014 15:45:23 +0100
Message-Id: <1394030723-15084-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Master CPU may timeout before cpu_callin_mask is set and cancel
booting CPU, but being onlined CPU still continues to boot, sets
cpu_active_mask (CPU_STARTING notifiers) and spins in
check_tsc_sync_target() for master cpu to arrive. Following attempt
to online another cpu hangs in stop_machine, initiated from here:

smp_callin ->
  smp_store_cpu_info ->
    identify_secondary_cpu ->
      mtrr_ap_init -> set_mtrr_from_inactive_cpu

stop_machine waits on completion of stop_work on all CPUs from
cpu_active_mask including a failed CPU that spins in check_tsc_sync_target().

Issue is fixed if being onlined CPU continues to boot and calls
notify_cpu_starting(cpuid) only when master CPU waits for it to
come online. If master CPU times out on cpu_callin_mask and goes via
cancel path, the being onlined CPU should gracefully shutdown itself.

Patch introduces cpu_may_complete_boot_mask to notify a being onlined
CPU that it may call notify_cpu_starting(cpuid) and continue to boot
when master CPU goes via normal boot path and going to wait till the
being onlined CPU completes its initialization.

- normal boot sequence will look like:
    master CPU1                         being onlined CPU2

 * wait for CPU2 in cpu_callin_mask
---------------------------------------------------------------------
                                        * set CPU2 in cpu_callin_mask
                                        * wait till CPU1 set CPU2 bit
                                        in cpu_may_complete_boot_mask
---------------------------------------------------------------------
 * set CPU2 bit in
   cpu_may_complete_boot_mask
 * return from do_boot_cpu() and
   wait in
     - check_tsc_sync_source() or
     - while (!cpu_online(CPU2))
---------------------------------------------------------------------
                                        * call notify_cpu_starting()
                                          and continue CPU2 initialization
                                        * mark itself as ONLINE
---------------------------------------------------------------------
 * return to _cpu_up and call
   cpu_notify(CPU_ONLINE, ...)

- cancel/error path will look like:
    master CPU1                         being onlined CPU2

 * time out on cpu_callin_mask
---------------------------------------------------------------------
                                       * set CPU2 in cpu_callin_mask
                                       * wait till CPU2 is set in
                                         cpu_may_complete_boot_mask or
                                         cleared in cpu_callout_mask
---------------------------------------------------------------------
 * clear CPU2 in cpu_callout_mask
 and return with error
---------------------------------------------------------------------
                                       * do cleanups and play_dead()

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/cpumask.h |    1 +
 arch/x86/kernel/cpu/common.c   |    2 ++
 arch/x86/kernel/smpboot.c      |   37 +++++++++++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
index 61c852f..eacd269 100644
--- a/arch/x86/include/asm/cpumask.h
+++ b/arch/x86/include/asm/cpumask.h
@@ -7,6 +7,7 @@ extern cpumask_var_t cpu_callin_mask;
 extern cpumask_var_t cpu_callout_mask;
 extern cpumask_var_t cpu_initialized_mask;
 extern cpumask_var_t cpu_sibling_setup_mask;
+extern cpumask_var_t cpu_may_complete_boot_mask;
 
 extern void setup_cpu_local_masks(void);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8e28bf2..4797111 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -50,6 +50,7 @@
 cpumask_var_t cpu_initialized_mask;
 cpumask_var_t cpu_callout_mask;
 cpumask_var_t cpu_callin_mask;
+cpumask_var_t cpu_may_complete_boot_mask;
 
 /* representing cpus for which sibling maps can be computed */
 cpumask_var_t cpu_sibling_setup_mask;
@@ -61,6 +62,7 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_callin_mask);
 	alloc_bootmem_cpumask_var(&cpu_callout_mask);
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
+	alloc_bootmem_cpumask_var(&cpu_may_complete_boot_mask);
 }
 
 static void default_init(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..4e9a63b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -104,6 +104,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
+static void remove_siblinginfo(int cpu);
+
 /*
  * Report back to the Boot Processor during boot time or to the caller processor
  * during CPU online.
@@ -202,12 +204,38 @@ static void smp_callin(void)
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
 
-	notify_cpu_starting(cpuid);
-
 	/*
 	 * Allow the master to continue.
 	 */
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
+
+	/*
+	* Wait for signal from master CPU to continue or abort.
+	*/
+	while (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask) &&
+		cpumask_test_cpu(cpuid, cpu_callout_mask)) {
+		cpu_relax();
+	}
+
+	/* die if master cancelled cpu_up */
+	if (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
+		goto die;
+
+	notify_cpu_starting(cpuid);
+	return;
+
+die:
+#ifdef CONFIG_HOTPLUG_CPU
+	/* was set by smp_store_cpu_info->...->numa_add_cpu */
+	numa_remove_cpu(cpuid);
+	remove_siblinginfo(cpuid);
+	clear_local_APIC();
+	/* was set by cpu_init() */
+	cpumask_clear_cpu(cpuid, cpu_initialized_mask);
+	cpumask_clear_cpu(cpuid, cpu_callin_mask);
+	play_dead();
+#endif
+	panic("%s: Failed to online CPU%d!\n", __func__, cpuid);
 }
 
 static int cpu0_logical_apicid;
@@ -827,6 +855,8 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		}
 
 		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
+			/* Signal AP that it may continue to boot */
+			cpumask_set_cpu(cpu, cpu_may_complete_boot_mask);
 			print_cpu_msr(&cpu_data(cpu));
 			pr_debug("CPU%d: has booted.\n", cpu);
 		} else {
@@ -1085,6 +1115,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	smp_store_boot_cpu_info(); /* Final full version of the data */
 	cpumask_copy(cpu_callin_mask, cpumask_of(0));
+	cpumask_copy(cpu_may_complete_boot_mask, cpumask_of(0));
 	mb();
 
 	current_thread_info()->cpu = 0;  /* needed? */
@@ -1294,6 +1325,8 @@ static void __ref remove_cpu_from_maps(int cpu)
 	cpumask_clear_cpu(cpu, cpu_callin_mask);
 	/* was set by cpu_init() */
 	cpumask_clear_cpu(cpu, cpu_initialized_mask);
+	/* set by do_boot_cpu() */
+	cpumask_clear_cpu(cpu, cpu_may_complete_boot_mask);
 	numa_remove_cpu(cpu);
 }
 
-- 
1.7.1

