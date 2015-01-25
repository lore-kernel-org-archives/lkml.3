Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbbAYOhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:37:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:42396 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbAYOhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:37:37 -0500
Date: Sun, 25 Jan 2015 15:37:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for 3.19
Message-ID: <alpine.DEB.2.11.1501251526530.5526@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

Hopefully the last round of fixes for 3.19
  - Regression fix for the LDT changes
  - Regression fix for XEN interrupt handling caused by the APIC changes
  - Regression fixes for the PAT changes
  - Last minute fixes for new the MPX support
  - Regression fix for 32bit UP
  - Fix for a long standing relocation issue on 64bit tagged for stable
  - Functional fix for the Hyper-V clocksource tagged for stable
  - Downgrade of a pr_err which tends to confuse users

Looks a bit on the large side, but almost half of it are valuable
comments.

Thanks,

	tglx

------------------>
Alexandre Demers (1):
      x86/tsc: Change Fast TSC calibration failed from error to info

Andy Lutomirski (2):
      x86, tls, ldt: Stop checking lm in LDT_empty
      x86, tls: Interpret an all-zero struct user_desc as "no segment"

Bryan O'Donoghue (1):
      x86/apic: Re-enable PCI_MSI support for non-SMP X86_32

Dave Hansen (3):
      x86, mpx: Explicitly disable 32-bit MPX support on 64-bit kernels
      x86, mpx: Fix potential performance issue on unmaps
      x86, mpx: Strictly enforce empty prctl() args

Jan Beulich (1):
      x86, irq: Properly tag virtualization entry in /proc/interrupts

Jiang Liu (3):
      x86/xen: Treat SCI interrupt as normal GSI interrupt
      ACPI: pci: Do not clear pci_dev->irq in acpi_pci_irq_disable()
      x86/xen: Override ACPI IRQ management callback __acpi_unregister_gsi

Juergen Gross (2):
      x86: Don't rely on VMWare emulating PAT MSR correctly
      x86, mm: Change cachemode exports to non-gpl

K. Y. Srinivasan (1):
      x86, hyperv: Mark the Hyper-V clocksource as being continuous

Kees Cook (1):
      x86, boot: Skip relocs when load address unchanged


 arch/x86/Kconfig                   |  6 ++++-
 arch/x86/boot/compressed/misc.c    |  9 ++++++-
 arch/x86/include/asm/acpi.h        |  1 +
 arch/x86/include/asm/desc.h        | 20 +++++++++++-----
 arch/x86/include/asm/mmu_context.h | 20 +++++++++++++++-
 arch/x86/kernel/acpi/boot.c        | 26 ++++++++++----------
 arch/x86/kernel/cpu/mshyperv.c     |  1 +
 arch/x86/kernel/irq.c              |  2 +-
 arch/x86/kernel/tls.c              | 25 +++++++++++++++++--
 arch/x86/kernel/tsc.c              |  2 +-
 arch/x86/mm/init.c                 |  4 ++--
 arch/x86/mm/mpx.c                  |  6 +++++
 arch/x86/mm/pat.c                  |  7 +++++-
 arch/x86/pci/xen.c                 | 49 ++------------------------------------
 drivers/acpi/pci_irq.c             |  1 -
 kernel/sys.c                       |  4 ++++
 16 files changed, 106 insertions(+), 77 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bde7948..0dc9d0144a27 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -857,7 +857,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
+	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
 	---help---
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -868,6 +868,10 @@ config X86_UP_APIC
 	  performance counters), and the NMI watchdog which detects hard
 	  lockups.
 
+config X86_UP_APIC_MSI
+	def_bool y
+	select X86_UP_APIC if X86_32 && !SMP && !X86_32_NON_STANDARD && PCI_MSI
+
 config X86_UP_IOAPIC
 	bool "IO-APIC support on uniprocessors"
 	depends on X86_UP_APIC
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index dcc1c536cc21..a950864a64da 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -373,6 +373,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned long output_len,
 				  unsigned long run_size)
 {
+	unsigned char *output_orig = output;
+
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -421,7 +423,12 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	handle_relocations(output, output_len);
+	/*
+	 * 32-bit always performs relocations. 64-bit relocations are only
+	 * needed if kASLR has chosen a different load address.
+	 */
+	if (!IS_ENABLED(CONFIG_X86_64) || output != output_orig)
+		handle_relocations(output, output_len);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 0ab4f9fd2687..3a45668f6dc3 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -50,6 +50,7 @@ void acpi_pic_sci_set_trigger(unsigned int, u16);
 
 extern int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 				  int trigger, int polarity);
+extern void (*__acpi_unregister_gsi)(u32 gsi);
 
 static inline void disable_acpi(void)
 {
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 50d033a8947d..a94b82e8f156 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -251,7 +251,8 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
 }
 
-#define _LDT_empty(info)				\
+/* This intentionally ignores lm, since 32-bit apps don't have that field. */
+#define LDT_empty(info)					\
 	((info)->base_addr		== 0	&&	\
 	 (info)->limit			== 0	&&	\
 	 (info)->contents		== 0	&&	\
@@ -261,11 +262,18 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 	 (info)->seg_not_present	== 1	&&	\
 	 (info)->useable		== 0)
 
-#ifdef CONFIG_X86_64
-#define LDT_empty(info) (_LDT_empty(info) && ((info)->lm == 0))
-#else
-#define LDT_empty(info) (_LDT_empty(info))
-#endif
+/* Lots of programs expect an all-zero user_desc to mean "no segment at all". */
+static inline bool LDT_zero(const struct user_desc *info)
+{
+	return (info->base_addr		== 0 &&
+		info->limit		== 0 &&
+		info->contents		== 0 &&
+		info->read_exec_only	== 0 &&
+		info->seg_32bit		== 0 &&
+		info->limit_in_pages	== 0 &&
+		info->seg_not_present	== 0 &&
+		info->useable		== 0);
+}
 
 static inline void clear_LDT(void)
 {
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 40269a2bf6f9..4b75d591eb5e 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -130,7 +130,25 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 static inline void arch_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
 			      unsigned long start, unsigned long end)
 {
-	mpx_notify_unmap(mm, vma, start, end);
+	/*
+	 * mpx_notify_unmap() goes and reads a rarely-hot
+	 * cacheline in the mm_struct.  That can be expensive
+	 * enough to be seen in profiles.
+	 *
+	 * The mpx_notify_unmap() call and its contents have been
+	 * observed to affect munmap() performance on hardware
+	 * where MPX is not present.
+	 *
+	 * The unlikely() optimizes for the fast case: no MPX
+	 * in the CPU, or no MPX use in the process.  Even if
+	 * we get this wrong (in the unlikely event that MPX
+	 * is widely enabled on some system) the overhead of
+	 * MPX itself (reading bounds tables) is expected to
+	 * overwhelm the overhead of getting this unlikely()
+	 * consistently wrong.
+	 */
+	if (unlikely(cpu_feature_enabled(X86_FEATURE_MPX)))
+		mpx_notify_unmap(mm, vma, start, end);
 }
 
 #endif /* _ASM_X86_MMU_CONTEXT_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d1626364a28a..b9e30daa0881 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -611,20 +611,20 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq;
-
-	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
-		*irqp = gsi;
-	} else {
-		mutex_lock(&acpi_ioapic_lock);
-		irq = mp_map_gsi_to_irq(gsi,
-					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
-		mutex_unlock(&acpi_ioapic_lock);
-		if (irq < 0)
-			return -1;
-		*irqp = irq;
+	int rc, irq, trigger, polarity;
+
+	rc = acpi_get_override_irq(gsi, &trigger, &polarity);
+	if (rc == 0) {
+		trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
+		polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
+		irq = acpi_register_gsi(NULL, gsi, trigger, polarity);
+		if (irq >= 0) {
+			*irqp = irq;
+			return 0;
+		}
 	}
-	return 0;
+
+	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index a450373e8e91..939155ffdece 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -107,6 +107,7 @@ static struct clocksource hyperv_cs = {
 	.rating		= 400, /* use this when running on Hyperv*/
 	.read		= read_hv_clock,
 	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init ms_hyperv_init_platform(void)
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6307a0f0cf17..705ef8d48e2d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -127,7 +127,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_puts(p, "  Machine check polls\n");
 #endif
 #if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
-	seq_printf(p, "%*s: ", prec, "THR");
+	seq_printf(p, "%*s: ", prec, "HYP");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
 	seq_puts(p, "  Hypervisor callback interrupts\n");
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 4e942f31b1a7..7fc5e843f247 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -29,7 +29,28 @@ static int get_free_idx(void)
 
 static bool tls_desc_okay(const struct user_desc *info)
 {
-	if (LDT_empty(info))
+	/*
+	 * For historical reasons (i.e. no one ever documented how any
+	 * of the segmentation APIs work), user programs can and do
+	 * assume that a struct user_desc that's all zeros except for
+	 * entry_number means "no segment at all".  This never actually
+	 * worked.  In fact, up to Linux 3.19, a struct user_desc like
+	 * this would create a 16-bit read-write segment with base and
+	 * limit both equal to zero.
+	 *
+	 * That was close enough to "no segment at all" until we
+	 * hardened this function to disallow 16-bit TLS segments.  Fix
+	 * it up by interpreting these zeroed segments the way that they
+	 * were almost certainly intended to be interpreted.
+	 *
+	 * The correct way to ask for "no segment at all" is to specify
+	 * a user_desc that satisfies LDT_empty.  To keep everything
+	 * working, we accept both.
+	 *
+	 * Note that there's a similar kludge in modify_ldt -- look at
+	 * the distinction between modes 1 and 0x11.
+	 */
+	if (LDT_empty(info) || LDT_zero(info))
 		return true;
 
 	/*
@@ -71,7 +92,7 @@ static void set_tls_desc(struct task_struct *p, int idx,
 	cpu = get_cpu();
 
 	while (n-- > 0) {
-		if (LDT_empty(info))
+		if (LDT_empty(info) || LDT_zero(info))
 			desc->a = desc->b = 0;
 		else
 			fill_ldt(desc, info);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b7e50bba3bbb..505449700e0c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -617,7 +617,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_info("Fast TSC calibration failed\n");
 	return 0;
 
 success:
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 08a7d313538a..079c3b6a3ff1 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -43,7 +43,7 @@ uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
 	[_PAGE_CACHE_MODE_WT]		= _PAGE_PCD,
 	[_PAGE_CACHE_MODE_WP]		= _PAGE_PCD,
 };
-EXPORT_SYMBOL_GPL(__cachemode2pte_tbl);
+EXPORT_SYMBOL(__cachemode2pte_tbl);
 uint8_t __pte2cachemode_tbl[8] = {
 	[__pte2cm_idx(0)] = _PAGE_CACHE_MODE_WB,
 	[__pte2cm_idx(_PAGE_PWT)] = _PAGE_CACHE_MODE_WC,
@@ -54,7 +54,7 @@ uint8_t __pte2cachemode_tbl[8] = {
 	[__pte2cm_idx(_PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC_MINUS,
 	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
 };
-EXPORT_SYMBOL_GPL(__pte2cachemode_tbl);
+EXPORT_SYMBOL(__pte2cachemode_tbl);
 
 static unsigned long __initdata pgt_buf_start;
 static unsigned long __initdata pgt_buf_end;
diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index 67ebf5751222..c439ec478216 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -349,6 +349,12 @@ static __user void *task_get_bounds_dir(struct task_struct *tsk)
 		return MPX_INVALID_BOUNDS_DIR;
 
 	/*
+	 * 32-bit binaries on 64-bit kernels are currently
+	 * unsupported.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) && test_thread_flag(TIF_IA32))
+		return MPX_INVALID_BOUNDS_DIR;
+	/*
 	 * The bounds directory pointer is stored in a register
 	 * only accessible if we first do an xsave.
 	 */
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index edf299c8ff6c..7ac68698406c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -234,8 +234,13 @@ void pat_init(void)
 	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
 
 	/* Boot CPU check */
-	if (!boot_pat_state)
+	if (!boot_pat_state) {
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+		if (!boot_pat_state) {
+			pat_disable("PAT read returns always zero, disabled.");
+			return;
+		}
+	}
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index c489ef2c1a39..9098d880c476 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -458,6 +458,7 @@ int __init pci_xen_hvm_init(void)
 	 * just how GSIs get registered.
 	 */
 	__acpi_register_gsi = acpi_register_gsi_xen_hvm;
+	__acpi_unregister_gsi = NULL;
 #endif
 
 #ifdef CONFIG_PCI_MSI
@@ -471,52 +472,6 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
-static __init void xen_setup_acpi_sci(void)
-{
-	int rc;
-	int trigger, polarity;
-	int gsi = acpi_sci_override_gsi;
-	int irq = -1;
-	int gsi_override = -1;
-
-	if (!gsi)
-		return;
-
-	rc = acpi_get_override_irq(gsi, &trigger, &polarity);
-	if (rc) {
-		printk(KERN_WARNING "xen: acpi_get_override_irq failed for acpi"
-				" sci, rc=%d\n", rc);
-		return;
-	}
-	trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
-	polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
-
-	printk(KERN_INFO "xen: sci override: global_irq=%d trigger=%d "
-			"polarity=%d\n", gsi, trigger, polarity);
-
-	/* Before we bind the GSI to a Linux IRQ, check whether
-	 * we need to override it with bus_irq (IRQ) value. Usually for
-	 * IRQs below IRQ_LEGACY_IRQ this holds IRQ == GSI, as so:
-	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
-	 * but there are oddballs where the IRQ != GSI:
-	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
-	 * which ends up being: gsi_to_irq[9] == 20
-	 * (which is what acpi_gsi_to_irq ends up calling when starting the
-	 * the ACPI interpreter and keels over since IRQ 9 has not been
-	 * setup as we had setup IRQ 20 for it).
-	 */
-	if (acpi_gsi_to_irq(gsi, &irq) == 0) {
-		/* Use the provided value if it's valid. */
-		if (irq >= 0)
-			gsi_override = irq;
-	}
-
-	gsi = xen_register_gsi(gsi, gsi_override, trigger, polarity);
-	printk(KERN_INFO "xen: acpi sci %d\n", gsi);
-
-	return;
-}
-
 int __init pci_xen_initial_domain(void)
 {
 	int irq;
@@ -527,8 +482,8 @@ int __init pci_xen_initial_domain(void)
 	x86_msi.restore_msi_irqs = xen_initdom_restore_msi_irqs;
 	pci_msi_ignore_mask = 1;
 #endif
-	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
+	__acpi_unregister_gsi = NULL;
 	/* Pre-allocate legacy irqs */
 	for (irq = 0; irq < nr_legacy_irqs(); irq++) {
 		int trigger, polarity;
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 5277a0ee5704..b1def411c0b8 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -512,7 +512,6 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
 	if (gsi >= 0) {
 		acpi_unregister_gsi(gsi);
-		dev->irq = 0;
 		dev->irq_managed = 0;
 	}
 }
diff --git a/kernel/sys.c b/kernel/sys.c
index a8c9f5a7dda6..ea9c88109894 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2210,9 +2210,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		up_write(&me->mm->mmap_sem);
 		break;
 	case PR_MPX_ENABLE_MANAGEMENT:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
 		error = MPX_ENABLE_MANAGEMENT(me);
 		break;
 	case PR_MPX_DISABLE_MANAGEMENT:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
 		error = MPX_DISABLE_MANAGEMENT(me);
 		break;
 	default:
