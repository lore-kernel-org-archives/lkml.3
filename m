Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbaJaL0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:26:49 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48344 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbaJaL0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:26:47 -0400
Date: Fri, 31 Oct 2014 12:26:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20141031112641.GA28813@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: d1cd1210834649ce1ca6bafe5ac25d2f40331343 x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Fixes from all around the place:

 - hyper-V 32-bit PAE guest kernel fix
 - two IRQ allocation fixes on certain x86 boards
 - intel-mid boot crash fix
 - intel-quark quirk
 - intel-quark 
 - /proc/interrupts duplicate irq chip name fix
 - cma boot crash fix
 - syscall audit fix
 - boot crash fix with certain TSC configurations (seen on Qemu)
 - smpboot.c build warning fix

 Thanks,

	Ingo

------------------>
Andy Lutomirski (1):
      x86, apic: Handle a bad TSC more gracefully

Dave Jones (1):
      x86: Don't enable F00F workaround on Intel Quark processors

Dexuan Cui (1):
      x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Eric Paris (1):
      i386/audit: stop scribbling on the stack frame

Ingo Molnar (1):
      x86/smpboot: Move data structure to its primary usage scope

Jiang Liu (3):
      x86: ACPI: Do not translate GSI number if IOAPIC is disabled
      x86, intel-mid: Create IRQs for APB timers and RTC timers
      ACPI, irq, x86: Return IRQ instead of GSI in mp_register_gsi()

Maciej W. Rozycki (1):
      x86/irq: Fix XT-PIC-XT-PIC in /proc/interrupts

Weijie Yang (1):
      x86, cma: Reserve DMA contiguous area after initmem_init()


 arch/x86/kernel/acpi/boot.c       | 16 ++++++++++------
 arch/x86/kernel/apb_timer.c       |  2 --
 arch/x86/kernel/apic/apic.c       |  4 ++--
 arch/x86/kernel/cpu/intel.c       |  5 +++--
 arch/x86/kernel/entry_32.S        | 15 +++++++--------
 arch/x86/kernel/i8259.c           |  3 +--
 arch/x86/kernel/irqinit.c         |  3 +--
 arch/x86/kernel/setup.c           |  2 +-
 arch/x86/kernel/smpboot.c         |  4 ++--
 arch/x86/kernel/tsc.c             |  5 ++++-
 arch/x86/mm/pageattr.c            |  2 +-
 arch/x86/platform/intel-mid/sfi.c |  2 ++
 12 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b436fc735aa4..a142e77693e1 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -397,7 +397,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return gsi;
+		return mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
 
 	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
 	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
@@ -604,14 +604,18 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+	int irq;
 
-	if (irq >= 0) {
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
+		*irqp = gsi;
+	} else {
+		irq = mp_map_gsi_to_irq(gsi,
+					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+		if (irq < 0)
+			return -1;
 		*irqp = irq;
-		return 0;
 	}
-
-	return -1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 5972b108f15a..b708738d016e 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -185,8 +185,6 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 
 	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
 	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
-	/* APB timer irqs are set up as mp_irqs, timer is edge type */
-	__irq_set_handler(adev->irq, handle_edge_irq, 0, "edge");
 }
 
 /* Should be called with per cpu */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 00853b254ab0..ba6cc041edb1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1297,7 +1297,7 @@ void setup_local_APIC(void)
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz;
+	long long max_loops = cpu_khz ? cpu_khz : 1000000;
 
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1383,7 +1383,7 @@ void setup_local_APIC(void)
 			break;
 		}
 		if (queued) {
-			if (cpu_has_tsc) {
+			if (cpu_has_tsc && cpu_khz) {
 				rdtscll(ntsc);
 				max_loops = (cpu_khz << 10) - (ntsc - tsc);
 			} else
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1ef456273172..9cc6b6f25f42 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -213,12 +213,13 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_F00F_BUG
 	/*
-	 * All current models of Pentium and Pentium with MMX technology CPUs
+	 * All models of Pentium and Pentium with MMX technology CPUs
 	 * have the F0 0F bug, which lets nonprivileged users lock up the
 	 * system. Announce that the fault handler will be checking for it.
+	 * The Quark is also family 5, but does not have the same bug.
 	 */
 	clear_cpu_bug(c, X86_BUG_F00F);
-	if (!paravirt_enabled() && c->x86 == 5) {
+	if (!paravirt_enabled() && c->x86 == 5 && c->x86_model < 9) {
 		static int f00f_workaround_enabled;
 
 		set_cpu_bug(c, X86_BUG_F00F);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index b553ed89e5f5..344b63f18d14 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -447,15 +447,14 @@ ENTRY(ia32_sysenter_target)
 sysenter_audit:
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
 	jnz syscall_trace_entry
-	addl $4,%esp
-	CFI_ADJUST_CFA_OFFSET -4
-	movl %esi,4(%esp)		/* 5th arg: 4th syscall arg */
-	movl %edx,(%esp)		/* 4th arg: 3rd syscall arg */
-	/* %ecx already in %ecx		   3rd arg: 2nd syscall arg */
-	movl %ebx,%edx			/* 2nd arg: 1st syscall arg */
-	/* %eax already in %eax		   1st arg: syscall number */
+	/* movl PT_EAX(%esp), %eax	already set, syscall number: 1st arg to audit */
+	movl PT_EBX(%esp), %edx		/* ebx/a0: 2nd arg to audit */
+	/* movl PT_ECX(%esp), %ecx	already set, a1: 3nd arg to audit */
+	pushl_cfi PT_ESI(%esp)		/* a3: 5th arg */
+	pushl_cfi PT_EDX+4(%esp)	/* a2: 4th arg */
 	call __audit_syscall_entry
-	pushl_cfi %ebx
+	popl_cfi %ecx /* get that remapped edx off the stack */
+	popl_cfi %ecx /* get that remapped esi off the stack */
 	movl PT_EAX(%esp),%eax		/* reload syscall number */
 	jmp sysenter_do_call
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 8af817105e29..e7cc5370cd2f 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -111,8 +111,7 @@ static void make_8259A_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
-	irq_set_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
-				      i8259A_chip.name);
+	irq_set_chip_and_handler(irq, &i8259A_chip, handle_level_irq);
 	enable_irq(irq);
 }
 
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 44f1ed42fdf2..4de73ee78361 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -70,7 +70,6 @@ int vector_used_by_percpu_irq(unsigned int vector)
 void __init init_ISA_irqs(void)
 {
 	struct irq_chip *chip = legacy_pic->chip;
-	const char *name = chip->name;
 	int i;
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
@@ -79,7 +78,7 @@ void __init init_ISA_irqs(void)
 	legacy_pic->init(0);
 
 	for (i = 0; i < nr_legacy_irqs(); i++)
-		irq_set_chip_and_handler_name(i, chip, handle_level_irq, name);
+		irq_set_chip_and_handler(i, chip, handle_level_irq);
 }
 
 void __init init_IRQ(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 235cfd39e0d7..ab08aa2276fb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1128,7 +1128,6 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	memblock_set_current_limit(get_max_mapped());
-	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
@@ -1159,6 +1158,7 @@ void __init setup_arch(char **cmdline_p)
 	early_acpi_boot_init();
 
 	initmem_init();
+	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
 	/*
 	 * Reserve memory for crash kernel after SRAT is parsed so that it
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d5200e56357..4d2128ac70bd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,8 +102,6 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
-static DEFINE_PER_CPU(struct completion, die_complete);
-
 atomic_t init_deasserted;
 
 /*
@@ -1318,6 +1316,8 @@ void cpu_disable_common(void)
 	fixup_irqs();
 }
 
+static DEFINE_PER_CPU(struct completion, die_complete);
+
 int native_cpu_disable(void)
 {
 	int ret;
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b6025f9e36c6..b7e50bba3bbb 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1166,14 +1166,17 @@ void __init tsc_init(void)
 
 	x86_init.timers.tsc_pre_init();
 
-	if (!cpu_has_tsc)
+	if (!cpu_has_tsc) {
+		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 		return;
+	}
 
 	tsc_khz = x86_platform.calibrate_tsc();
 	cpu_khz = tsc_khz;
 
 	if (!tsc_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
+		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 		return;
 	}
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index ae242a7c11c7..36de293caf25 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -409,7 +409,7 @@ phys_addr_t slow_virt_to_phys(void *__virt_addr)
 	psize = page_level_size(level);
 	pmask = page_level_mask(level);
 	offset = virt_addr & ~pmask;
-	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+	phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
 	return (phys_addr | offset);
 }
 EXPORT_SYMBOL_GPL(slow_virt_to_phys);
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 3c53a90fdb18..c14ad34776c4 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -106,6 +106,7 @@ int __init sfi_parse_mtmr(struct sfi_table_header *table)
 			mp_irq.dstapic = MP_APIC_ALL;
 			mp_irq.dstirq = pentry->irq;
 			mp_save_irq(&mp_irq);
+			mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
 	}
 
 	return 0;
@@ -176,6 +177,7 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
 		mp_save_irq(&mp_irq);
+		mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
 	}
 	return 0;
 }
