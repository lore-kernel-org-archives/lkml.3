Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab3D3IXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:23:40 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:54208 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab3D3IXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:23:36 -0400
Date: Tue, 30 Apr 2013 10:23:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/paravirt changes for v3.10
Message-ID: <20130430082332.GA22160@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-paravirt-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-paravirt-for-linus

   HEAD: 4d681be3c33dd74efffbe2a8f70634f7128602ec x86, wakeup, sleep: Use pvops functions for changing GDT entries

Various paravirtualization related changes - the biggest one makes guest 
support optional via CONFIG_HYPERVISOR_GUEST.

out-of-topic modifications in x86-paravirt-for-linus:
-----------------------------------------------------
drivers/hv/Kconfig                 # 6276a07: x86: Make Linux guest support opt
drivers/misc/Kconfig               # 6276a07: x86: Make Linux guest support opt

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu
      x86: Make Linux guest support optional

Konrad Rzeszutek Wilk (3):
      x86-64, gdt: Store/load GDT for ACPI S3 or hibernate/resume path is not needed.
      x86-32, gdt: Store/load GDT for ACPI S3 or hibernation/resume path is not needed
      x86, xen, gdt: Remove the pvops variant of store_gdt.

konrad@kernel.org (1):
      x86, wakeup, sleep: Use pvops functions for changing GDT entries


 arch/x86/Kconfig                      | 89 ++++++++++++++++++-----------------
 arch/x86/include/asm/hypervisor.h     | 16 +++++--
 arch/x86/include/asm/paravirt.h       |  4 --
 arch/x86/include/asm/paravirt_types.h |  2 +-
 arch/x86/include/asm/suspend_32.h     |  1 -
 arch/x86/include/asm/suspend_64.h     |  3 --
 arch/x86/kernel/acpi/sleep.c          |  2 +-
 arch/x86/kernel/acpi/wakeup_32.S      |  3 --
 arch/x86/kernel/cpu/Makefile          |  3 +-
 arch/x86/kernel/doublefault_32.c      |  2 +-
 arch/x86/kernel/paravirt.c            |  1 -
 arch/x86/kvm/vmx.c                    |  2 +-
 arch/x86/lguest/Kconfig               |  3 +-
 arch/x86/power/cpu.c                  | 13 ++---
 arch/x86/xen/Kconfig                  |  2 +-
 arch/x86/xen/enlighten.c              |  1 -
 drivers/hv/Kconfig                    |  2 +-
 drivers/misc/Kconfig                  |  2 +-
 18 files changed, 73 insertions(+), 78 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5..e9e4623 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -389,7 +389,7 @@ config X86_NUMACHIP
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
-	select PARAVIRT_GUEST
+	select HYPERVISOR_GUEST
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
@@ -596,44 +596,17 @@ config SCHED_OMIT_FRAME_POINTER
 
 	  If in doubt, say "Y".
 
-menuconfig PARAVIRT_GUEST
-	bool "Paravirtualized guest support"
+menuconfig HYPERVISOR_GUEST
+	bool "Linux guest support"
 	---help---
-	  Say Y here to get to see options related to running Linux under
-	  various hypervisors.  This option alone does not add any kernel code.
+	  Say Y here to enable options for running Linux under various hyper-
+	  visors. This option enables basic hypervisor detection and platform
+	  setup.
 
-	  If you say N, all options in this submenu will be skipped and disabled.
+	  If you say N, all options in this submenu will be skipped and
+	  disabled, and Linux guest support won't be built in.
 
-if PARAVIRT_GUEST
-
-config PARAVIRT_TIME_ACCOUNTING
-	bool "Paravirtual steal time accounting"
-	select PARAVIRT
-	default n
-	---help---
-	  Select this option to enable fine granularity task steal time
-	  accounting. Time spent executing other tasks in parallel with
-	  the current vCPU is discounted from the vCPU power. To account for
-	  that, there can be a small performance impact.
-
-	  If in doubt, say N here.
-
-source "arch/x86/xen/Kconfig"
-
-config KVM_GUEST
-	bool "KVM Guest support (including kvmclock)"
-	select PARAVIRT
-	select PARAVIRT
-	select PARAVIRT_CLOCK
-	default y if PARAVIRT_GUEST
-	---help---
-	  This option enables various optimizations for running under the KVM
-	  hypervisor. It includes a paravirtualized clock, so that instead
-	  of relying on a PIT (or probably other) emulation by the
-	  underlying device model, the host provides the guest with
-	  timing infrastructure such as time of day, and system time
-
-source "arch/x86/lguest/Kconfig"
+if HYPERVISOR_GUEST
 
 config PARAVIRT
 	bool "Enable paravirtualization code"
@@ -643,6 +616,13 @@ config PARAVIRT
 	  over full virtualization.  However, when run without a hypervisor
 	  the kernel is theoretically slower and slightly larger.
 
+config PARAVIRT_DEBUG
+	bool "paravirt-ops debugging"
+	depends on PARAVIRT && DEBUG_KERNEL
+	---help---
+	  Enable to debug paravirt_ops internals.  Specifically, BUG if
+	  a paravirt_op is missing when it is called.
+
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
 	depends on PARAVIRT && SMP
@@ -656,17 +636,38 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer N.
 
-config PARAVIRT_CLOCK
-	bool
+source "arch/x86/xen/Kconfig"
 
-endif
+config KVM_GUEST
+	bool "KVM Guest support (including kvmclock)"
+	depends on PARAVIRT
+	select PARAVIRT_CLOCK
+	default y
+	---help---
+	  This option enables various optimizations for running under the KVM
+	  hypervisor. It includes a paravirtualized clock, so that instead
+	  of relying on a PIT (or probably other) emulation by the
+	  underlying device model, the host provides the guest with
+	  timing infrastructure such as time of day, and system time
 
-config PARAVIRT_DEBUG
-	bool "paravirt-ops debugging"
-	depends on PARAVIRT && DEBUG_KERNEL
+source "arch/x86/lguest/Kconfig"
+
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	depends on PARAVIRT
+	default n
 	---help---
-	  Enable to debug paravirt_ops internals.  Specifically, BUG if
-	  a paravirt_op is missing when it is called.
+	  Select this option to enable fine granularity task steal time
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
+config PARAVIRT_CLOCK
+	bool
+
+endif #HYPERVISOR_GUEST
 
 config NO_BOOTMEM
 	def_bool y
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 86095ed..2d4b5e6 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -20,13 +20,11 @@
 #ifndef _ASM_X86_HYPERVISOR_H
 #define _ASM_X86_HYPERVISOR_H
 
+#ifdef CONFIG_HYPERVISOR_GUEST
+
 #include <asm/kvm_para.h>
 #include <asm/xen/hypervisor.h>
 
-extern void init_hypervisor(struct cpuinfo_x86 *c);
-extern void init_hypervisor_platform(void);
-extern bool hypervisor_x2apic_available(void);
-
 /*
  * x86 hypervisor information
  */
@@ -55,4 +53,12 @@ extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
 extern const struct hypervisor_x86 x86_hyper_kvm;
 
-#endif
+extern void init_hypervisor(struct cpuinfo_x86 *c);
+extern void init_hypervisor_platform(void);
+extern bool hypervisor_x2apic_available(void);
+#else
+static inline void init_hypervisor(struct cpuinfo_x86 *c) { }
+static inline void init_hypervisor_platform(void) { }
+static inline bool hypervisor_x2apic_available(void) { return false; }
+#endif /* CONFIG_HYPERVISOR_GUEST */
+#endif /* _ASM_X86_HYPERVISOR_H */
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5edd174..7365128 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -262,10 +262,6 @@ static inline void set_ldt(const void *addr, unsigned entries)
 {
 	PVOP_VCALL2(pv_cpu_ops.set_ldt, addr, entries);
 }
-static inline void store_gdt(struct desc_ptr *dtr)
-{
-	PVOP_VCALL1(pv_cpu_ops.store_gdt, dtr);
-}
 static inline void store_idt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_idt, dtr);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..b6c69a6 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -122,7 +122,7 @@ struct pv_cpu_ops {
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct desc_ptr *);
 	void (*load_idt)(const struct desc_ptr *);
-	void (*store_gdt)(struct desc_ptr *);
+	/* store_gdt has been removed. */
 	void (*store_idt)(struct desc_ptr *);
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index 487055c..f6064b7 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -15,7 +15,6 @@ struct saved_context {
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
 	bool misc_enable_saved;
-	struct desc_ptr gdt;
 	struct desc_ptr idt;
 	u16 ldt;
 	u16 tss;
diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 09b0bf1..97b84e0 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -25,9 +25,6 @@ struct saved_context {
 	u64 misc_enable;
 	bool misc_enable_saved;
 	unsigned long efer;
-	u16 gdt_pad;
-	u16 gdt_limit;
-	unsigned long gdt_base;
 	u16 idt_pad;
 	u16 idt_limit;
 	unsigned long idt_base;
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 0532f5d..b44577b 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -46,7 +46,7 @@ int acpi_suspend_lowlevel(void)
 	header->pmode_behavior = 0;
 
 #ifndef CONFIG_64BIT
-	store_gdt((struct desc_ptr *)&header->pmode_gdt);
+	native_store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
 	if (!rdmsr_safe(MSR_EFER,
 			&header->pmode_efer_low,
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 13ab720..91adb1b 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -18,7 +18,6 @@ wakeup_pmode_return:
 	movw	%ax, %gs
 
 	# reload the gdt, as we need the full 32 bit address
-	lgdt	saved_gdt
 	lidt	saved_idt
 	lldt	saved_ldt
 	ljmp	$(__KERNEL_CS), $1f
@@ -44,7 +43,6 @@ bogus_magic:
 
 
 save_registers:
-	sgdt	saved_gdt
 	sidt	saved_idt
 	sldt	saved_ldt
 	str	saved_tss
@@ -93,7 +91,6 @@ ENTRY(saved_magic)	.long	0
 ENTRY(saved_eip)	.long	0
 
 # saved registers
-saved_gdt:	.long	0,0
 saved_idt:	.long	0,0
 saved_ldt:	.long	0
 saved_tss:	.long	0
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d..5f81bce 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -14,7 +14,6 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o mshyperv.o
 obj-y			+= rdrand.o
 obj-y			+= match.o
 
@@ -42,6 +41,8 @@ obj-$(CONFIG_MTRR)			+= mtrr/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
+obj-$(CONFIG_HYPERVISOR_GUEST)		+= vmware.o hypervisor.o mshyperv.o
+
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
 
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index 37250fe..155a13f 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -20,7 +20,7 @@ static void doublefault_fn(void)
 	struct desc_ptr gdt_desc = {0, 0};
 	unsigned long gdt, tss;
 
-	store_gdt(&gdt_desc);
+	native_store_gdt(&gdt_desc);
 	gdt = gdt_desc.address;
 
 	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 17fff18..4ae3d23 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -360,7 +360,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
 	.load_idt = native_load_idt,
-	.store_gdt = native_store_gdt,
 	.store_idt = native_store_idt,
 	.store_tr = native_store_tr,
 	.load_tls = native_load_tls,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6667042..867b810 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2459,7 +2459,7 @@ static int hardware_enable(void *garbage)
 		ept_sync_global();
 	}
 
-	store_gdt(&__get_cpu_var(host_gdt));
+	native_store_gdt(&__get_cpu_var(host_gdt));
 
 	return 0;
 }
diff --git a/arch/x86/lguest/Kconfig b/arch/x86/lguest/Kconfig
index 29043d2..4a0890f 100644
--- a/arch/x86/lguest/Kconfig
+++ b/arch/x86/lguest/Kconfig
@@ -1,7 +1,6 @@
 config LGUEST_GUEST
 	bool "Lguest guest support"
-	select PARAVIRT
-	depends on X86_32
+	depends on X86_32 && PARAVIRT
 	select TTY
 	select VIRTUALIZATION
 	select VIRTIO
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 120cee1..168da84 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -61,11 +61,9 @@ static void __save_processor_state(struct saved_context *ctxt)
 	 * descriptor tables
 	 */
 #ifdef CONFIG_X86_32
-	store_gdt(&ctxt->gdt);
 	store_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
 	store_idt((struct desc_ptr *)&ctxt->idt_limit);
 #endif
 	store_tr(ctxt->tr);
@@ -134,7 +132,10 @@ static void fix_processor_context(void)
 {
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
+#ifdef CONFIG_X86_64
+	struct desc_struct *desc = get_cpu_gdt_table(cpu);
+	tss_desc tss;
+#endif
 	set_tss_desc(cpu, t);	/*
 				 * This just modifies memory; should not be
 				 * necessary. But... This is necessary, because
@@ -143,7 +144,9 @@ static void fix_processor_context(void)
 				 */
 
 #ifdef CONFIG_X86_64
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
+	memcpy(&tss, &desc[GDT_ENTRY_TSS], sizeof(tss_desc));
+	tss.type = 0x9; /* The available 64-bit TSS (see AMD vol 2, pg 91 */
+	write_gdt_entry(desc, GDT_ENTRY_TSS, &tss, DESC_TSS);
 
 	syscall_init();				/* This sets MSR_*STAR and related */
 #endif
@@ -182,11 +185,9 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	 * ltr is done i fix_processor_context().
 	 */
 #ifdef CONFIG_X86_32
-	load_gdt(&ctxt->gdt);
 	load_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
 	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
 #endif
 
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 131dacd..1a3c765 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Xen guest support"
-	select PARAVIRT
+	depends on PARAVIRT
 	select PARAVIRT_CLOCK
 	select XEN_HAVE_PVMMU
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8e1c7b..ddab539 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1220,7 +1220,6 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.alloc_ldt = xen_alloc_ldt,
 	.free_ldt = xen_free_ldt,
 
-	.store_gdt = native_store_gdt,
 	.store_idt = native_store_idt,
 	.store_tr = xen_store_tr,
 
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 64630f1..0403b51 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -2,7 +2,7 @@ menu "Microsoft Hyper-V guest support"
 
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && PCI && X86_LOCAL_APIC
+	depends on X86 && ACPI && PCI && X86_LOCAL_APIC && HYPERVISOR_GUEST
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e83fdfe..891123e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -418,7 +418,7 @@ config TI_DAC7512
 
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"
-	depends on X86
+	depends on X86 && HYPERVISOR_GUEST
 	help
 	  This is VMware physical memory management driver which acts
 	  like a "balloon" that can be inflated to reclaim physical pages
