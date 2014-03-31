Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaCaULg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaCaULf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:11:35 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com
Subject: [PATCH v2 1/5] x86: replace timeouts when booting secondary CPU with infinite wait loop
Date: Mon, 31 Mar 2014 22:09:21 +0200
Message-Id: <1396296565-19709-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hang is observed on virtual machines during CPU hotplug,
especially in big guests with many CPUs. (It reproducible
more often if host is over-committed).

It happens because master CPU gives up waiting on
secondary CPU and allows it to run wild. As result
AP causes locking or crashing system. For example
as described here: https://lkml.org/lkml/2014/3/6/257

If master CPU have sent STARTUP IPI successfully,
make it wait indefinitely till AP boots.
To ensure that AP won't ever run wild, make it
wait at early startup till master CPU confirms its
intention to wait for it.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
v2:
 - ammend comment in cpu_init()
---
 arch/x86/kernel/cpu/common.c |   17 +++++++++-
 arch/x86/kernel/smpboot.c    |   68 ++----------------------------------------
 2 files changed, 18 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8e28bf2..248161e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1235,16 +1235,22 @@ void cpu_init(void)
 	struct task_struct *me;
 	struct tss_struct *t;
 	unsigned long v;
-	int cpu;
+	int cpu = stack_smp_processor_id();
 	int i;
 
 	/*
+	 * wait for ACK from master CPU before continuing
+	 * with AP initialization
+	 */
+	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
+		cpu_relax();
+
+	/*
 	 * Load microcode on this cpu if a valid microcode is available.
 	 * This is early microcode loading procedure.
 	 */
 	load_ucode_ap();
 
-	cpu = stack_smp_processor_id();
 	t = &per_cpu(init_tss, cpu);
 	oist = &per_cpu(orig_ist, cpu);
 
@@ -1335,6 +1341,13 @@ void cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
+	/*
+	 * wait for ACK from master CPU before continuing
+	 * with AP initialization
+	 */
+	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
+		cpu_relax();
+
 	show_ucode_info_early();
 
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 37e11e5..8bf67bd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -111,7 +111,6 @@ atomic_t init_deasserted;
 static void smp_callin(void)
 {
 	int cpuid, phys_id;
-	unsigned long timeout;
 
 	/*
 	 * If waken up by an INIT in an 82489DX configuration
@@ -129,37 +128,6 @@ static void smp_callin(void)
 	 * (This works even if the APIC is not enabled.)
 	 */
 	phys_id = read_apic_id();
-	if (cpumask_test_cpu(cpuid, cpu_callin_mask)) {
-		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
-					phys_id, cpuid);
-	}
-	pr_debug("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
-
-	/*
-	 * STARTUP IPIs are fragile beasts as they might sometimes
-	 * trigger some glue motherboard logic. Complete APIC bus
-	 * silence for 1 second, this overestimates the time the
-	 * boot CPU is spending to send the up to 2 STARTUP IPIs
-	 * by a factor of two. This should be enough.
-	 */
-
-	/*
-	 * Waiting 2s total for startup (udelay is not yet working)
-	 */
-	timeout = jiffies + 2*HZ;
-	while (time_before(jiffies, timeout)) {
-		/*
-		 * Has the boot CPU finished it's STARTUP sequence?
-		 */
-		if (cpumask_test_cpu(cpuid, cpu_callout_mask))
-			break;
-		cpu_relax();
-	}
-
-	if (!time_before(jiffies, timeout)) {
-		panic("%s: CPU%d started up but did not get a callout!\n",
-		      __func__, cpuid);
-	}
 
 	/*
 	 * the boot CPU has finished the init stage and is spinning
@@ -749,7 +717,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	unsigned long start_ip = real_mode_header->trampoline_start;
 
 	unsigned long boot_error = 0;
-	int timeout;
 	int cpu0_nmi_registered = 0;
 
 	/* Just in case we booted with a single CPU. */
@@ -818,12 +785,9 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		pr_debug("After Callout %d\n", cpu);
 
 		/*
-		 * Wait 5s total for a response
+		 * Wait till AP completes initial initialization
 		 */
-		for (timeout = 0; timeout < 50000; timeout++) {
-			if (cpumask_test_cpu(cpu, cpu_callin_mask))
-				break;	/* It has booted */
-			udelay(100);
+		while (!cpumask_test_cpu(cpu, cpu_callin_mask)) {
 			/*
 			 * Allow other tasks to run while we wait for the
 			 * AP to come online. This also gives a chance
@@ -832,33 +796,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 			 */
 			schedule();
 		}
-
-		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
-			print_cpu_msr(&cpu_data(cpu));
-			pr_debug("CPU%d: has booted.\n", cpu);
-		} else {
-			boot_error = 1;
-			if (*trampoline_status == 0xA5A5A5A5)
-				/* trampoline started but...? */
-				pr_err("CPU%d: Stuck ??\n", cpu);
-			else
-				/* trampoline code not run */
-				pr_err("CPU%d: Not responding\n", cpu);
-			if (apic->inquire_remote_apic)
-				apic->inquire_remote_apic(apicid);
-		}
-	}
-
-	if (boot_error) {
-		/* Try to put things back the way they were before ... */
-		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
-
-		/* was set by do_boot_cpu() */
-		cpumask_clear_cpu(cpu, cpu_callout_mask);
-
-		/* was set by cpu_init() */
-		cpumask_clear_cpu(cpu, cpu_initialized_mask);
-
+	} else {
 		set_cpu_present(cpu, false);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
-- 
1.7.1

