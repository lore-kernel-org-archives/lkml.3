Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaJMHTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:19:54 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57979 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJMHTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:19:53 -0400
Date: Mon, 13 Oct 2014 09:19:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot tree changes for v3.18
Message-ID: <20141013071948.GA13930@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   # HEAD: eeeda4cd06e828b331b15741a204ff9f5874d28d x86/relocs: Make per_cpu_load_addr static

The changes in this cycle were:

 - Fix rare SMP-boot hang (mostly in virtual environments)

 - Fix build warning with certain (rare) toolchains

 Thanks,

	Ingo

------------------>
Ben Hutchings (1):
      x86/relocs: Make per_cpu_load_addr static

Igor Mammedov (1):
      x86/smpboot: Initialize secondary CPU only if master CPU will wait for it


 arch/x86/kernel/cpu/common.c | 29 ++++++++-----
 arch/x86/kernel/smpboot.c    | 98 ++++++++++++++------------------------------
 arch/x86/tools/relocs.c      |  2 +-
 arch/x86/xen/smp.c           |  2 +
 4 files changed, 51 insertions(+), 80 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b42bd6f..426cfedefd04 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1266,6 +1266,19 @@ static void dbg_restore_debug_regs(void)
 #define dbg_restore_debug_regs()
 #endif /* ! CONFIG_KGDB */
 
+static void wait_for_master_cpu(int cpu)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * wait for ACK from master CPU before continuing
+	 * with AP initialization
+	 */
+	WARN_ON(cpumask_test_and_set_cpu(cpu, cpu_initialized_mask));
+	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
+		cpu_relax();
+#endif
+}
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -1281,16 +1294,17 @@ void cpu_init(void)
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
 
@@ -1302,9 +1316,6 @@ void cpu_init(void)
 
 	me = current;
 
-	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
-		panic("CPU#%d already initialized!\n", cpu);
-
 	pr_debug("Initializing CPU#%d\n", cpu);
 
 	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
@@ -1381,13 +1392,9 @@ void cpu_init(void)
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
index 2d872e08fab9..735c420eba2d 100644
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
@@ -753,8 +721,8 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	unsigned long start_ip = real_mode_header->trampoline_start;
 
 	unsigned long boot_error = 0;
-	int timeout;
 	int cpu0_nmi_registered = 0;
+	unsigned long timeout;
 
 	/* Just in case we booted with a single CPU. */
 	alternatives_enable_smp();
@@ -802,6 +770,15 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
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
@@ -815,53 +792,38 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 
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
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index bbb1d2259ecf..a5efb21d5228 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -695,7 +695,7 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
  *
  */
 static int per_cpu_shndx	= -1;
-Elf_Addr per_cpu_load_addr;
+static Elf_Addr per_cpu_load_addr;
 
 static void percpu_init(void)
 {
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7005974c3ff3..3631e7129e8c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -360,6 +360,8 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	struct desc_struct *gdt;
 	unsigned long gdt_mfn;
 
+	/* used to tell cpu_init() that it can proceed with initialization */
+	cpumask_set_cpu(cpu, cpu_callout_mask);
 	if (cpumask_test_and_set_cpu(cpu, xen_cpu_initialized_map))
 		return 0;
 
