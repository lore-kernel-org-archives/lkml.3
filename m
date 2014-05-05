Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaEEUwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:52:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbaEEUvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:51:16 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Subject: [PATCH v5 4/4] x86: initialize secondary CPU only if master CPU will wait for it
Date: Mon,  5 May 2014 22:49:51 +0200
Message-Id: <1399322991-19329-5-git-send-email-imammedo@redhat.com>
In-Reply-To: <1399322991-19329-1-git-send-email-imammedo@redhat.com>
References: <1399322991-19329-1-git-send-email-imammedo@redhat.com>
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
and AP signalled to master CPU that it's ready
to start initialization, make master CPU wait
indefinitely till AP is onlined.
To ensure that AP won't ever run wild, make it
wait at early startup till master CPU confirms its
intention to wait for AP. If AP doesn't respond in 10
seconds, the master CPU will timeout and cancel
AP onlining.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
v2:
 - ammend comment in cpu_init()
v3:
 - leave timeouts in do_boot_cpu(), so that master CPU
   won't hang if AP doesn't respond, use cpu_initialized_mask
   as a way for AP to signal to master CPU that it's ready
   to start initialzation.
v4:
 - move commont code in cpu_init() for x32/x64 in shared
   helper function wait_formaster_cpu()
 - add WARN_ON(cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
   to wait_formaster_cpu()
v5:
 - add smp_mb() after clearing cpu_initialized_mask in do_boot_cpu()
 - add 10 sec timeout description into commit message.
---
 arch/x86/kernel/cpu/common.c |   27 +++++++-----
 arch/x86/kernel/smpboot.c    |   99 +++++++++++++-----------------------------
 2 files changed, 47 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..a4bcbac 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1221,6 +1221,17 @@ static void dbg_restore_debug_regs(void)
 #define dbg_restore_debug_regs()
 #endif /* ! CONFIG_KGDB */
 
+static void wait_for_master_cpu(int cpu)
+{
+	/*
+	 * wait for ACK from master CPU before continuing
+	 * with AP initialization
+	 */
+	WARN_ON(cpumask_test_and_set_cpu(cpu, cpu_initialized_mask));
+	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
+		cpu_relax();
+}
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -1236,16 +1247,17 @@ void cpu_init(void)
 	struct task_struct *me;
 	struct tss_struct *t;
 	unsigned long v;
-	int cpu;
+	int cpu = stack_smp_processor_id();
 	int i;
 
+	wait_for_master_cpu(cpu);
+
 	/*
 	 * Load microcode on this cpu if a valid microcode is available.
 	 * This is early microcode loading procedure.
 	 */
 	load_ucode_ap();
 
-	cpu = stack_smp_processor_id();
 	t = &per_cpu(init_tss, cpu);
 	oist = &per_cpu(orig_ist, cpu);
 
@@ -1257,9 +1269,6 @@ void cpu_init(void)
 
 	me = current;
 
-	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
-		panic("CPU#%d already initialized!\n", cpu);
-
 	pr_debug("Initializing CPU#%d\n", cpu);
 
 	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
@@ -1336,13 +1345,9 @@ void cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
-	show_ucode_info_early();
+	wait_for_master_cpu(cpu);
 
-	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
-		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
-		for (;;)
-			local_irq_enable();
-	}
+	show_ucode_info_early();
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ae2fd97..bc52fac 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -111,7 +111,6 @@ atomic_t init_deasserted;
 static void smp_callin(void)
 {
 	int cpuid, phys_id;
-	unsigned long timeout;
 
 	/*
 	 * If waken up by an INIT in an 82489DX configuration
@@ -130,37 +129,6 @@ static void smp_callin(void)
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
@@ -750,8 +718,8 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	unsigned long start_ip = real_mode_header->trampoline_start;
 
 	unsigned long boot_error = 0;
-	int timeout;
 	int cpu0_nmi_registered = 0;
+	unsigned long timeout;
 
 	/* Just in case we booted with a single CPU. */
 	alternatives_enable_smp();
@@ -799,6 +767,15 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	}
 
 	/*
+	 * AP might wait on cpu_callout_mask in cpu_init() with
+	 * cpu_initialized_mask set if previous attempt to online
+	 * it timed-out. Clear cpu_initialized_mask so that after
+	 * INIT/SIPI it could start with a clean state.
+	 */
+	cpumask_clear_cpu(cpu, cpu_initialized_mask);
+	smp_mb();
+
+	/*
 	 * Wake up a CPU in difference cases:
 	 * - Use the method in the APIC driver if it's defined
 	 * Otherwise,
@@ -810,55 +787,41 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
 						     &cpu0_nmi_registered);
 
+
 	if (!boot_error) {
 		/*
-		 * allow APs to start initializing.
+		 * Wait 10s total for a response from AP
 		 */
-		pr_debug("Before Callout %d\n", cpu);
-		cpumask_set_cpu(cpu, cpu_callout_mask);
-		pr_debug("After Callout %d\n", cpu);
+		boot_error = -1;
+		timeout = jiffies + 10*HZ;
+		while (time_before(jiffies, timeout)) {
+			if (cpumask_test_cpu(cpu, cpu_initialized_mask)) {
+				/*
+				 * Tell AP to proceed with initialization
+				 */
+				cpumask_set_cpu(cpu, cpu_callout_mask);
+				boot_error = 0;
+				break;
+			}
+			udelay(100);
+			schedule();
+		}
+	}
 
+	if (!boot_error) {
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
 			 * for the MTRR work(triggered by the AP coming online)
 			 * to be completed in the stop machine context.
 			 */
+			udelay(100);
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
 	}
 
 	/* mark "stuck" area as not stuck */
-- 
1.7.1

