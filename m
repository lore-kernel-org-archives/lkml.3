Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaFGVBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:01:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaFGVBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:01:11 -0400
Date: Sat, 7 Jun 2014 13:59:54 -0700
Message-Id: <201406072059.s57KxsIp025789@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.15
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Igor Mammedov <imammedo@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt (Red Hat) <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A significantly larger than I'd like set of patches for just below the
wire.  All of these, however, fix real problems.  However, if you feel
it is too scary we can do it for the merge window and rely on pushing
them into -stable.

The one thing that is genuinely scary in here is the change of SMP
initialization, but that *does* fix a confirmed hang when booting
virtual machines.

There is also a patch to actually do the right thing about not
offlining a CPU when there are not enough interrupt vectors available
in the system; the accounting was done incorrectly.  The worst case
for that patch is that we fail to offline CPUs when we should (the new
code is strictly more conservative than the old), so is not
particularly risky.

Most of the rest is minor stuff; the EFI patches are all about
exporting correct information to boot loaders and kexec.

The following changes since commit d2cfd3105094f593bc1fbd0b042a7752ddf08691:

  Merge tag 'sound-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2014-06-03 12:07:30 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

for you to fetch changes up to 745c51673e289acf4d9ffc2835524de73ef923fd:

  x86/boot: EFI_MIXED should not prohibit loading above 4G (2014-06-07 09:31:00 -0700)

----------------------------------------------------------------
Dave Young (2):
      x86/efi: earlyprintk=efi,keep fix
      x86/efi: Do not export efi runtime map in case old map

H. Peter Anvin (1):
      Merge tag 'efi-urgent' into x86/urgent

Igor Mammedov (3):
      x86: Fix list/memory corruption on CPU hotplug
      x86/smpboot: Log error on secondary CPU wakeup failure at ERR level
      x86/smpboot: Initialize secondary CPU only if master CPU will wait for it

Matt Fleming (1):
      x86/boot: EFI_MIXED should not prohibit loading above 4G

Yinghai Lu (1):
      x86: irq: Get correct available vectors for cpu disable

 arch/x86/boot/header.S       |   3 +-
 arch/x86/kernel/cpu/common.c |  27 ++++++-----
 arch/x86/kernel/irq.c        |  16 +++++--
 arch/x86/kernel/smpboot.c    | 104 +++++++++++++------------------------------
 arch/x86/platform/efi/efi.c  |   3 ++
 5 files changed, 64 insertions(+), 89 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 0ca9a5c362bc..84c223479e3c 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -375,8 +375,7 @@ xloadflags:
 # define XLF0 0
 #endif
 
-#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64) && \
-	!defined(CONFIG_EFI_MIXED)
+#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
    /* kernel/boot_param/ramdisk could be loaded above 4g */
 # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
 #else
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239badb7..a4bcbacdbe0b 100644
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
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 283a76a9cc40..11ccfb0a63e7 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/desc.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
@@ -334,10 +335,17 @@ int check_irq_vectors_for_cpu_disable(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == this_cpu)
 			continue;
-		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
-		     vector++) {
-			if (per_cpu(vector_irq, cpu)[vector] < 0)
-				count++;
+		/*
+		 * We scan from FIRST_EXTERNAL_VECTOR to first system
+		 * vector. If the vector is marked in the used vectors
+		 * bitmap or an irq is assigned to it, we don't count
+		 * it as available.
+		 */
+		for (vector = FIRST_EXTERNAL_VECTOR;
+		     vector < first_system_vector; vector++) {
+			if (!test_bit(vector, used_vectors) &&
+			    per_cpu(vector_irq, cpu)[vector] < 0)
+					count++;
 		}
 	}
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 34826934d4a7..bc52fac39dd3 100644
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
@@ -810,58 +787,41 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
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
-
-		set_cpu_present(cpu, false);
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
 
 	/* mark "stuck" area as not stuck */
@@ -921,7 +881,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
-		pr_debug("do_boot_cpu failed %d\n", err);
+		pr_err("do_boot_cpu failed(%d) to wakeup CPU#%u\n", err, cpu);
 		return -EIO;
 	}
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3781dd39e8bd..4d36932ca4f2 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -919,6 +919,9 @@ static void __init save_runtime_map(void)
 	void *tmp, *p, *q = NULL;
 	int count = 0;
 
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 
