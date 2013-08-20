Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3HTIsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:48:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43175 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3HTIsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:48:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.19
Date: Tue, 20 Aug 2013 09:47:55 +0100
Message-Id: <1376988475-7943-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376988475-7943-1-git-send-email-luis.henriques@canonical.com>
References: <1376988475-7943-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 928c4bf..fa278f9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .18
+EXTRAVERSION = .19
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index aca782f..67e758c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -184,7 +184,8 @@ config VECTORS_BASE
 	default DRAM_BASE if REMAP_VECTORS_TO_RAM
 	default 0x00000000
 	help
-	  The base address of exception vectors.
+	  The base address of exception vectors.  This must be two pages
+	  in size.
 
 config ARM_PATCH_PHYS_VIRT
 	bool "Patch physical to virtual translations at runtime" if EMBEDDED
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..5492d72 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -784,6 +784,18 @@ ENDPROC(__switch_to)
 #endif
 	.endm
 
+	.macro	kuser_pad, sym, size
+	.if	(. - \sym) & 3
+	.rept	4 - (. - \sym) & 3
+	.byte	0
+	.endr
+	.endif
+	.rept	(\size - (. - \sym)) / 4
+	.word	0xe7fddef1
+	.endr
+	.endm
+
+#ifdef CONFIG_KUSER_HELPERS
 	.align	5
 	.globl	__kuser_helper_start
 __kuser_helper_start:
@@ -874,18 +886,13 @@ kuser_cmpxchg64_fixup:
 #error "incoherent kernel configuration"
 #endif
 
-	/* pad to next slot */
-	.rept	(16 - (. - __kuser_cmpxchg64)/4)
-	.word	0
-	.endr
-
-	.align	5
+	kuser_pad __kuser_cmpxchg64, 64
 
 __kuser_memory_barrier:				@ 0xffff0fa0
 	smp_dmb	arm
 	usr_ret	lr
 
-	.align	5
+	kuser_pad __kuser_memory_barrier, 32
 
 __kuser_cmpxchg:				@ 0xffff0fc0
 
@@ -958,13 +965,14 @@ kuser_cmpxchg32_fixup:
 
 #endif
 
-	.align	5
+	kuser_pad __kuser_cmpxchg, 32
 
 __kuser_get_tls:				@ 0xffff0fe0
 	ldr	r0, [pc, #(16 - 8)]	@ read TLS, set in kuser_get_tls_init
 	usr_ret	lr
 	mrc	p15, 0, r0, c13, c0, 3	@ 0xffff0fe8 hardware TLS code
-	.rep	4
+	kuser_pad __kuser_get_tls, 16
+	.rep	3
 	.word	0			@ 0xffff0ff0 software TLS value, then
 	.endr				@ pad up to __kuser_helper_version
 
@@ -974,14 +982,16 @@ __kuser_helper_version:				@ 0xffff0ffc
 	.globl	__kuser_helper_end
 __kuser_helper_end:
 
+#endif
+
  THUMB(	.thumb	)
 
 /*
  * Vector stubs.
  *
- * This code is copied to 0xffff0200 so we can use branches in the
- * vectors, rather than ldr's.  Note that this code must not
- * exceed 0x300 bytes.
+ * This code is copied to 0xffff1000 so we can use branches in the
+ * vectors, rather than ldr's.  Note that this code must not exceed
+ * a page size.
  *
  * Common stub entry macro:
  *   Enter in IRQ mode, spsr = SVC/USR CPSR, lr = SVC/USR PC
@@ -1028,8 +1038,17 @@ ENDPROC(vector_\name)
 1:
 	.endm
 
-	.globl	__stubs_start
+	.section .stubs, "ax", %progbits
 __stubs_start:
+	@ This must be the first word
+	.word	vector_swi
+
+vector_rst:
+ ARM(	swi	SYS_ERROR0	)
+ THUMB(	svc	#0		)
+ THUMB(	nop			)
+	b	vector_und
+
 /*
  * Interrupt dispatcher
  */
@@ -1124,6 +1143,16 @@ __stubs_start:
 	.align	5
 
 /*=============================================================================
+ * Address exception handler
+ *-----------------------------------------------------------------------------
+ * These aren't too critical.
+ * (they're not supposed to happen, and won't happen in 32-bit data mode).
+ */
+
+vector_addrexcptn:
+	b	vector_addrexcptn
+
+/*=============================================================================
  * Undefined FIQs
  *-----------------------------------------------------------------------------
  * Enter in FIQ mode, spsr = ANY CPSR, lr = ANY PC
@@ -1136,45 +1165,19 @@ __stubs_start:
 vector_fiq:
 	subs	pc, lr, #4
 
-/*=============================================================================
- * Address exception handler
- *-----------------------------------------------------------------------------
- * These aren't too critical.
- * (they're not supposed to happen, and won't happen in 32-bit data mode).
- */
-
-vector_addrexcptn:
-	b	vector_addrexcptn
-
-/*
- * We group all the following data together to optimise
- * for CPUs with separate I & D caches.
- */
-	.align	5
-
-.LCvswi:
-	.word	vector_swi
-
-	.globl	__stubs_end
-__stubs_end:
-
-	.equ	stubs_offset, __vectors_start + 0x200 - __stubs_start
+	.globl	vector_fiq_offset
+	.equ	vector_fiq_offset, vector_fiq
 
-	.globl	__vectors_start
+	.section .vectors, "ax", %progbits
 __vectors_start:
- ARM(	swi	SYS_ERROR0	)
- THUMB(	svc	#0		)
- THUMB(	nop			)
-	W(b)	vector_und + stubs_offset
-	W(ldr)	pc, .LCvswi + stubs_offset
-	W(b)	vector_pabt + stubs_offset
-	W(b)	vector_dabt + stubs_offset
-	W(b)	vector_addrexcptn + stubs_offset
-	W(b)	vector_irq + stubs_offset
-	W(b)	vector_fiq + stubs_offset
-
-	.globl	__vectors_end
-__vectors_end:
+	W(b)	vector_rst
+	W(b)	vector_und
+	W(ldr)	pc, __vectors_start + 0x1000
+	W(b)	vector_pabt
+	W(b)	vector_dabt
+	W(b)	vector_addrexcptn
+	W(b)	vector_irq
+	W(b)	vector_fiq
 
 	.data
 
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index c32f845..2bf329b 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -47,6 +47,11 @@
 #include <asm/irq.h>
 #include <asm/traps.h>
 
+#define FIQ_OFFSET ({					\
+		extern void *vector_fiq_offset;		\
+		(unsigned)&vector_fiq_offset;		\
+	})
+
 static unsigned long no_fiq_insn;
 
 /* Default reacquire function
@@ -80,13 +85,16 @@ int show_fiq_list(struct seq_file *p, int prec)
 void set_fiq_handler(void *start, unsigned int length)
 {
 #if defined(CONFIG_CPU_USE_DOMAINS)
-	memcpy((void *)0xffff001c, start, length);
+	void *base = (void *)0xffff0000;
 #else
-	memcpy(vectors_page + 0x1c, start, length);
+	void *base = vectors_page;
 #endif
-	flush_icache_range(0xffff001c, 0xffff001c + length);
+	unsigned offset = FIQ_OFFSET;
+
+	memcpy(base + offset, start, length);
+	flush_icache_range(0xffff0000 + offset, 0xffff0000 + offset + length);
 	if (!vectors_high())
-		flush_icache_range(0x1c, 0x1c + length);
+		flush_icache_range(offset, offset + length);
 }
 
 int claim_fiq(struct fiq_handler *f)
@@ -142,5 +150,6 @@ EXPORT_SYMBOL(disable_fiq);
 
 void __init init_FIQ(void)
 {
-	no_fiq_insn = *(unsigned long *)0xffff001c;
+	unsigned offset = FIQ_OFFSET;
+	no_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
 }
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index eeb7520..7f227f7 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -775,39 +775,54 @@ void __init trap_init(void)
 	return;
 }
 
-static void __init kuser_get_tls_init(unsigned long vectors)
+#ifdef CONFIG_KUSER_HELPERS
+static void __init kuser_init(void *vectors)
 {
+	extern char __kuser_helper_start[], __kuser_helper_end[];
+	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+
+	memcpy(vectors + 0x1000 - kuser_sz, __kuser_helper_start, kuser_sz);
+
 	/*
 	 * vectors + 0xfe0 = __kuser_get_tls
 	 * vectors + 0xfe8 = hardware TLS instruction at 0xffff0fe8
 	 */
 	if (tls_emu || has_tls_reg)
-		memcpy((void *)vectors + 0xfe0, (void *)vectors + 0xfe8, 4);
+		memcpy(vectors + 0xfe0, vectors + 0xfe8, 4);
 }
+#else
+static void __init kuser_init(void *vectors)
+{
+}
+#endif
 
 void __init early_trap_init(void *vectors_base)
 {
 	unsigned long vectors = (unsigned long)vectors_base;
 	extern char __stubs_start[], __stubs_end[];
 	extern char __vectors_start[], __vectors_end[];
-	extern char __kuser_helper_start[], __kuser_helper_end[];
-	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+	unsigned i;
 
 	vectors_page = vectors_base;
 
 	/*
+	 * Poison the vectors page with an undefined instruction.  This
+	 * instruction is chosen to be undefined for both ARM and Thumb
+	 * ISAs.  The Thumb version is an undefined instruction with a
+	 * branch back to the undefined instruction.
+	 */
+	for (i = 0; i < PAGE_SIZE / sizeof(u32); i++)
+		((u32 *)vectors_base)[i] = 0xe7fddef1;
+
+	/*
 	 * Copy the vectors, stubs and kuser helpers (in entry-armv.S)
 	 * into the vector page, mapped at 0xffff0000, and ensure these
 	 * are visible to the instruction stream.
 	 */
 	memcpy((void *)vectors, __vectors_start, __vectors_end - __vectors_start);
-	memcpy((void *)vectors + 0x200, __stubs_start, __stubs_end - __stubs_start);
-	memcpy((void *)vectors + 0x1000 - kuser_sz, __kuser_helper_start, kuser_sz);
+	memcpy((void *)vectors + 0x1000, __stubs_start, __stubs_end - __stubs_start);
 
-	/*
-	 * Do processor specific fixups for the kuser helpers
-	 */
-	kuser_get_tls_init(vectors);
+	kuser_init(vectors_base);
 
 	/*
 	 * Copy signal return handlers into the vector page, and
@@ -818,6 +833,6 @@ void __init early_trap_init(void *vectors_base)
 	memcpy((void *)(vectors + KERN_RESTART_CODE - CONFIG_VECTORS_BASE),
 	       syscall_restart_code, sizeof(syscall_restart_code));
 
-	flush_icache_range(vectors, vectors + PAGE_SIZE);
+	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
 	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
 }
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 36ff15b..2f8f92e 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -137,6 +137,23 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__init_begin = .;
 #endif
+	/*
+	 * The vectors and stubs are relocatable code, and the
+	 * only thing that matters is their relative offsets
+	 */
+	__vectors_start = .;
+	.vectors 0 : AT(__vectors_start) {
+		*(.vectors)
+	}
+	. = __vectors_start + SIZEOF(.vectors);
+	__vectors_end = .;
+
+	__stubs_start = .;
+	.stubs 0x1000 : AT(__stubs_start) {
+		*(.stubs)
+	}
+	. = __stubs_start + SIZEOF(.stubs);
+	__stubs_end = .;
 
 	INIT_TEXT_SECTION(8)
 	.exit.text : {
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 101b968..8d194df 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -400,24 +400,28 @@ config CPU_32v3
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v4
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v4T
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v5
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v6
 	bool
@@ -735,6 +739,7 @@ config CPU_BPREDICT_DISABLE
 
 config TLS_REG_EMUL
 	bool
+	select NEED_KUSER_HELPERS
 	help
 	  An SMP system using a pre-ARMv6 processor (there are apparently
 	  a few prototypes like that in existence) and therefore access to
@@ -742,11 +747,40 @@ config TLS_REG_EMUL
 
 config NEEDS_SYSCALL_FOR_CMPXCHG
 	bool
+	select NEED_KUSER_HELPERS
 	help
 	  SMP on a pre-ARMv6 processor?  Well OK then.
 	  Forget about fast user space cmpxchg support.
 	  It is just not possible.
 
+config NEED_KUSER_HELPERS
+	bool
+
+config KUSER_HELPERS
+	bool "Enable kuser helpers in vector page" if !NEED_KUSER_HELPERS
+	default y
+	help
+	  Warning: disabling this option may break user programs.
+
+	  Provide kuser helpers in the vector page.  The kernel provides
+	  helper code to userspace in read only form at a fixed location
+	  in the high vector page to allow userspace to be independent of
+	  the CPU type fitted to the system.  This permits binaries to be
+	  run on ARMv4 through to ARMv7 without modification.
+
+	  However, the fixed address nature of these helpers can be used
+	  by ROP (return orientated programming) authors when creating
+	  exploits.
+
+	  If all of the binaries and libraries which run on your platform
+	  are built specifically for your platform, and make no use of
+	  these helpers, then you can turn this option off.  However,
+	  when such an binary or library is run, it will receive a SIGILL
+	  signal, which will terminate the program.
+
+	  Say N here only if you are absolutely certain that you do not
+	  need these helpers; otherwise, the safe option is to say Y.
+
 config DMA_CACHE_RWFO
 	bool "Enable read/write for ownership DMA cache maintenance"
 	depends on CPU_V6K && SMP
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index f117e1f..6b3e749 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1086,7 +1086,7 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 	/*
 	 * Allocate the vector page early.
 	 */
-	vectors = early_alloc(PAGE_SIZE);
+	vectors = early_alloc(PAGE_SIZE * 2);
 
 	early_trap_init(vectors);
 
@@ -1136,10 +1136,18 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 
 	if (!vectors_high()) {
 		map.virtual = 0;
+		map.length = PAGE_SIZE * 2;
 		map.type = MT_LOW_VECTORS;
 		create_mapping(&map);
 	}
 
+	/* Now create a kernel read-only mapping */
+	map.pfn += 1;
+	map.virtual = 0xffff0000 + PAGE_SIZE;
+	map.length = PAGE_SIZE;
+	map.type = MT_LOW_VECTORS;
+	create_mapping(&map);
+
 	/*
 	 * Ask the machine support to map in the statically mapped devices.
 	 */
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f250431..6c5a7dc 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -132,7 +132,7 @@ static void __cpuinit mxcsr_feature_mask_init(void)
 	clts();
 	if (cpu_has_fxsr) {
 		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (fx_scratch));
+		asm volatile("fxsave %0" : "+m" (fx_scratch));
 		mask = fx_scratch.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 6ea287e2..9bdfcf5 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -117,6 +117,7 @@ struct acpi_battery {
 	struct acpi_device *device;
 	struct notifier_block pm_nb;
 	unsigned long update_time;
+	int revision;
 	int rate_now;
 	int capacity_now;
 	int voltage_now;
@@ -350,6 +351,7 @@ static struct acpi_offsets info_offsets[] = {
 };
 
 static struct acpi_offsets extended_info_offsets[] = {
+	{offsetof(struct acpi_battery, revision), 0},
 	{offsetof(struct acpi_battery, power_unit), 0},
 	{offsetof(struct acpi_battery, design_capacity), 0},
 	{offsetof(struct acpi_battery, full_charge_capacity), 0},
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 2be8ef1..39cafa6 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -93,7 +93,7 @@ config SATA_FSL
 	  If unsure, say N.
 
 config SATA_INIC162X
-	tristate "Initio 162x SATA support"
+	tristate "Initio 162x SATA support (Very Experimental)"
 	depends on PCI
 	help
 	  This option enables support for Initio 162x Serial ATA.
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 5c7d70c..3a8b55e 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -6,6 +6,18 @@
  *
  * This file is released under GPL v2.
  *
+ * **** WARNING ****
+ *
+ * This driver never worked properly and unfortunately data corruption is
+ * relatively common.  There isn't anyone working on the driver and there's
+ * no support from the vendor.  Do not use this driver in any production
+ * environment.
+ *
+ * http://thread.gmane.org/gmane.linux.debian.devel.bugs.rc/378525/focus=54491
+ * https://bugzilla.kernel.org/show_bug.cgi?id=60565
+ *
+ * *****************
+ *
  * This controller is eccentric and easily locks up if something isn't
  * right.  Documentation is available at initio's website but it only
  * documents registers (not programming model).
@@ -809,6 +821,8 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
+	dev_alert(&pdev->dev, "inic162x support is broken with common data corruption issues and will be disabled by default, contact linux-ide@vger.kernel.org if in production use\n");
+
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, NR_PORTS);
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 4ed7bf9..b83b40e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -274,6 +274,7 @@ int xen_blkif_schedule(void *arg)
 {
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
+	int ret;
 
 	xen_blkif_get(blkif);
 
@@ -294,8 +295,12 @@ int xen_blkif_schedule(void *arg)
 		blkif->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
 
-		if (do_block_io_op(blkif))
+		ret = do_block_io_op(blkif);
+		if (ret > 0)
 			blkif->waiting_reqs = 1;
+		if (ret == -EACCES)
+			wait_event_interruptible(blkif->shutdown_wq,
+						 kthread_should_stop());
 
 		if (log_stats && time_after(jiffies, blkif->st_print))
 			print_stats(blkif);
@@ -530,6 +535,12 @@ __do_block_io_op(struct xen_blkif *blkif)
 	rp = blk_rings->common.sring->req_prod;
 	rmb(); /* Ensure we see queued requests up to 'rp'. */
 
+	if (RING_REQUEST_PROD_OVERFLOW(&blk_rings->common, rp)) {
+		rc = blk_rings->common.rsp_prod_pvt;
+		pr_warn(DRV_PFX "Frontend provided bogus ring requests (%d - %d = %d). Halting ring processing on dev=%04x\n",
+			rp, rc, rp - rc, blkif->vbd.pdevice);
+		return -EACCES;
+	}
 	while (rc != rp) {
 
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index fc2a486..933adc5 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -216,6 +216,8 @@ struct xen_blkif {
 	int			st_wr_sect;
 
 	wait_queue_head_t	waiting_to_free;
+	/* Thread shutdown wait queue. */
+	wait_queue_head_t	shutdown_wq;
 };
 
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index a155254..5a0062f 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -118,6 +118,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	atomic_set(&blkif->drain, 0);
 	blkif->st_print = jiffies;
 	init_waitqueue_head(&blkif->waiting_to_free);
+	init_waitqueue_head(&blkif->shutdown_wq);
 
 	return blkif;
 }
@@ -178,6 +179,7 @@ static void xen_blkif_disconnect(struct xen_blkif *blkif)
 {
 	if (blkif->xenblkd) {
 		kthread_stop(blkif->xenblkd);
+		wake_up(&blkif->shutdown_wq);
 		blkif->xenblkd = NULL;
 	}
 
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 957f293..50f0838 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -257,9 +257,12 @@ static struct port *find_port_by_devt_in_portdev(struct ports_device *portdev,
 	unsigned long flags;
 
 	spin_lock_irqsave(&portdev->ports_lock, flags);
-	list_for_each_entry(port, &portdev->ports, list)
-		if (port->cdev->dev == dev)
+	list_for_each_entry(port, &portdev->ports, list) {
+		if (port->cdev->dev == dev) {
+			kref_get(&port->kref);
 			goto out;
+		}
+	}
 	port = NULL;
 out:
 	spin_unlock_irqrestore(&portdev->ports_lock, flags);
@@ -633,6 +636,10 @@ static ssize_t port_fops_read(struct file *filp, char __user *ubuf,
 
 	port = filp->private_data;
 
+	/* Port is hot-unplugged. */
+	if (!port->guest_connected)
+		return -ENODEV;
+
 	if (!port_has_data(port)) {
 		/*
 		 * If nothing's connected on the host just return 0 in
@@ -649,7 +656,7 @@ static ssize_t port_fops_read(struct file *filp, char __user *ubuf,
 		if (ret < 0)
 			return ret;
 	}
-	/* Port got hot-unplugged. */
+	/* Port got hot-unplugged while we were waiting above. */
 	if (!port->guest_connected)
 		return -ENODEV;
 	/*
@@ -792,14 +799,14 @@ static int port_fops_open(struct inode *inode, struct file *filp)
 	struct port *port;
 	int ret;
 
+	/* We get the port with a kref here */
 	port = find_port_by_devt(cdev->dev);
+	if (!port) {
+		/* Port was unplugged before we could proceed */
+		return -ENXIO;
+	}
 	filp->private_data = port;
 
-	/* Prevent against a port getting hot-unplugged at the same time */
-	spin_lock_irq(&port->portdev->ports_lock);
-	kref_get(&port->kref);
-	spin_unlock_irq(&port->portdev->ports_lock);
-
 	/*
 	 * Don't allow opening of console port devices -- that's done
 	 * via /dev/hvc
@@ -1257,14 +1264,6 @@ static void remove_port(struct kref *kref)
 
 	port = container_of(kref, struct port, kref);
 
-	sysfs_remove_group(&port->dev->kobj, &port_attribute_group);
-	device_destroy(pdrvdata.class, port->dev->devt);
-	cdev_del(port->cdev);
-
-	kfree(port->name);
-
-	debugfs_remove(port->debugfs_file);
-
 	kfree(port);
 }
 
@@ -1294,12 +1293,14 @@ static void unplug_port(struct port *port)
 	spin_unlock_irq(&port->portdev->ports_lock);
 
 	if (port->guest_connected) {
+		/* Let the app know the port is going down. */
+		send_sigio_to_port(port);
+
+		/* Do this after sigio is actually sent */
 		port->guest_connected = false;
 		port->host_connected = false;
-		wake_up_interruptible(&port->waitqueue);
 
-		/* Let the app know the port is going down. */
-		send_sigio_to_port(port);
+		wake_up_interruptible(&port->waitqueue);
 	}
 
 	if (is_console_port(port)) {
@@ -1318,6 +1319,14 @@ static void unplug_port(struct port *port)
 	 */
 	port->portdev = NULL;
 
+	sysfs_remove_group(&port->dev->kobj, &port_attribute_group);
+	device_destroy(pdrvdata.class, port->dev->devt);
+	cdev_del(port->cdev);
+
+	kfree(port->name);
+
+	debugfs_remove(port->debugfs_file);
+
 	/*
 	 * Locks around here are not necessary - a port can't be
 	 * opened after we removed the port struct from ports_list
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index f8d2287..87ae86f 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -54,6 +54,7 @@
 #define FW_CDEV_KERNEL_VERSION			5
 #define FW_CDEV_VERSION_EVENT_REQUEST2		4
 #define FW_CDEV_VERSION_ALLOCATE_REGION_END	4
+#define FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW	5
 
 struct client {
 	u32 version;
@@ -1009,6 +1010,8 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 			a->channel, a->speed, a->header_size, cb, client);
 	if (IS_ERR(context))
 		return PTR_ERR(context);
+	if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
+		context->drop_overflow_headers = true;
 
 	/* We only support one context at this time. */
 	spin_lock_irq(&client->lock);
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index c1af05e..4f36463 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2692,8 +2692,11 @@ static void copy_iso_headers(struct iso_context *ctx, const u32 *dma_hdr)
 {
 	u32 *ctx_hdr;
 
-	if (ctx->header_length + ctx->base.header_size > PAGE_SIZE)
+	if (ctx->header_length + ctx->base.header_size > PAGE_SIZE) {
+		if (ctx->base.drop_overflow_headers)
+			return;
 		flush_iso_completions(ctx);
+	}
 
 	ctx_hdr = ctx->header + ctx->header_length;
 	ctx->last_timestamp = (u16)le32_to_cpu((__force __le32)dma_hdr[0]);
@@ -2853,8 +2856,11 @@ static int handle_it_packet(struct context *context,
 
 	sync_it_packet_for_cpu(context, d);
 
-	if (ctx->header_length + 4 > PAGE_SIZE)
+	if (ctx->header_length + 4 > PAGE_SIZE) {
+		if (ctx->base.drop_overflow_headers)
+			return 1;
 		flush_iso_completions(ctx);
+	}
 
 	ctx_hdr = ctx->header + ctx->header_length;
 	ctx->last_timestamp = le16_to_cpu(last->res_count);
diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 2a6027c..566934c 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -348,6 +348,7 @@ int ast_bo_create(struct drm_device *dev, int size, int align,
 
 	astbo->gem.driver_private = NULL;
 	astbo->bo.bdev = &ast->ttm.bdev;
+	astbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	ast_ttm_placement(astbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index d4b1b1d..d57bcc8 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -353,6 +353,7 @@ int cirrus_bo_create(struct drm_device *dev, int size, int align,
 
 	cirrusbo->gem.driver_private = NULL;
 	cirrusbo->bo.bdev = &cirrus->ttm.bdev;
+	cirrusbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	cirrus_ttm_placement(cirrusbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index d85db22..bb95eda 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -329,6 +329,7 @@ enum intel_pch {
 #define QUIRK_PIPEA_FORCE (1<<0)
 #define QUIRK_LVDS_SSC_DISABLE (1<<1)
 #define QUIRK_INVERT_BRIGHTNESS (1<<2)
+#define QUIRK_NO_PCH_PWM_ENABLE (1<<3)
 
 struct intel_fbdev;
 struct intel_fbc_work;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 290d89d..05f75ff 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6874,6 +6874,17 @@ static void quirk_invert_brightness(struct drm_device *dev)
 	DRM_INFO("applying inverted panel brightness quirk\n");
 }
 
+/*
+ * Some machines (Dell XPS13) suffer broken backlight controls if
+ * BLM_PCH_PWM_ENABLE is set.
+ */
+static void quirk_no_pcm_pwm_enable(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	dev_priv->quirks |= QUIRK_NO_PCH_PWM_ENABLE;
+	DRM_INFO("applying no-PCH_PWM_ENABLE quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -6949,6 +6960,11 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer/Packard Bell NCL20 */
 	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
+
+	/* Dell XPS13 HD Sandy Bridge */
+	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
+	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
+	{ 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index d18c49a..440ed88 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -1097,7 +1097,8 @@ bool intel_lvds_init(struct drm_device *dev)
 		goto failed;
 
 out:
-	if (HAS_PCH_SPLIT(dev)) {
+	if (HAS_PCH_SPLIT(dev) &&
+	    !(dev_priv->quirks & QUIRK_NO_PCH_PWM_ENABLE)) {
 		u32 pwm;
 
 		pipe = (I915_READ(PCH_LVDS) & LVDS_PIPEB_SELECT) ? 1 : 0;
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index d5fd67e..192002f 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -285,6 +285,17 @@ void intel_panel_disable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	/*
+	 * Do not disable backlight on the vgaswitcheroo path. When switching
+	 * away from i915, the other client may depend on i915 to handle the
+	 * backlight. This will leave the backlight on unnecessarily when
+	 * another client is not activated.
+	 */
+	if (dev->switch_power_state == DRM_SWITCH_POWER_CHANGING) {
+		DRM_DEBUG_DRIVER("Skipping backlight disable on vga switch\n");
+		return;
+	}
+
 	dev_priv->backlight_enabled = false;
 	intel_panel_actually_set_backlight(dev, 0);
 }
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index a707394..95b5377 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -347,6 +347,7 @@ int mgag200_bo_create(struct drm_device *dev, int size, int align,
 
 	mgabo->gem.driver_private = NULL;
 	mgabo->bo.bdev = &mdev->ttm.bdev;
+	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 43672b6..daa1e34 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1222,12 +1222,17 @@ int atom_execute_table(struct atom_context *ctx, int index, uint32_t * params)
 	int r;
 
 	mutex_lock(&ctx->mutex);
+	/* reset data block */
+	ctx->data_block = 0;
 	/* reset reg block */
 	ctx->reg_block = 0;
 	/* reset fb window */
 	ctx->fb_base = 0;
 	/* reset io mode */
 	ctx->io_mode = ATOM_IO_MM;
+	/* reset divmul */
+	ctx->divmul[0] = 0;
+	ctx->divmul[1] = 0;
 	r = atom_execute_table_locked(ctx, index, params);
 	mutex_unlock(&ctx->mutex);
 	return r;
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 7dbb1aa..7ac565f 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3064,6 +3064,8 @@ static int evergreen_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (ASIC_IS_DCE5(rdev)) {
 		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
 			r = ni_init_microcode(rdev);
@@ -3091,7 +3093,6 @@ static int evergreen_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		evergreen_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 8d2a168..ba9ae56 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1239,6 +1239,8 @@ static int cayman_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (rdev->flags & RADEON_IS_IGP) {
 		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 			r = ni_init_microcode(rdev);
@@ -1267,7 +1269,6 @@ static int cayman_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	r = cayman_pcie_gart_enable(rdev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index ffaf3ba..0e431c0 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2361,6 +2361,8 @@ int r600_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	r600_pcie_gen2_enable(rdev);
 
+	r600_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -2373,7 +2375,6 @@ int r600_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r600_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 3b8e95a..d6fa2b5 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -890,6 +890,8 @@ static int rv770_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	rv770_pcie_gen2_enable(rdev);
 
+	rv770_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -902,7 +904,6 @@ static int rv770_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	rv770_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 97b89b7..625c4ba 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3683,6 +3683,8 @@ static int si_startup(struct radeon_device *rdev)
 	struct radeon_ring *ring;
 	int r;
 
+	si_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
 	    !rdev->rlc_fw || !rdev->mc_fw) {
 		r = si_init_microcode(rdev);
@@ -3702,7 +3704,6 @@ static int si_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	si_mc_program(rdev);
 	r = si_pcie_gart_enable(rdev);
 	if (r)
 		return r;
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 54ec890..034085d 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -215,7 +215,7 @@ static inline int adt7470_write_word_data(struct i2c_client *client, u8 reg,
 					  u16 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value & 0xFF)
-	       && i2c_smbus_write_byte_data(client, reg + 1, value >> 8);
+	       || i2c_smbus_write_byte_data(client, reg + 1, value >> 8);
 }
 
 static void adt7470_init_client(struct i2c_client *client)
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 4790110..9e47774 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -694,18 +694,18 @@ static int elantech_packet_check_v3(struct psmouse *psmouse)
 static int elantech_packet_check_v4(struct psmouse *psmouse)
 {
 	unsigned char *packet = psmouse->packet;
+	unsigned char packet_type = packet[3] & 0x03;
 
-	if ((packet[0] & 0x0c) == 0x04 &&
-	    (packet[3] & 0x1f) == 0x11)
+	switch (packet_type) {
+	case 0:
+		return PACKET_V4_STATUS;
+
+	case 1:
 		return PACKET_V4_HEAD;
 
-	if ((packet[0] & 0x0c) == 0x04 &&
-	    (packet[3] & 0x1f) == 0x12)
+	case 2:
 		return PACKET_V4_MOTION;
-
-	if ((packet[0] & 0x0c) == 0x04 &&
-	    (packet[3] & 0x1f) == 0x10)
-		return PACKET_V4_STATUS;
+	}
 
 	return PACKET_UNKNOWN;
 }
@@ -1282,6 +1282,7 @@ static int elantech_set_properties(struct elantech_data *etd)
 			etd->hw_version = 3;
 			break;
 		case 6:
+		case 7:
 			etd->hw_version = 4;
 			break;
 		default:
diff --git a/drivers/macintosh/windfarm_rm31.c b/drivers/macintosh/windfarm_rm31.c
index 3eca6d4..e13d9fd 100644
--- a/drivers/macintosh/windfarm_rm31.c
+++ b/drivers/macintosh/windfarm_rm31.c
@@ -439,15 +439,15 @@ static void backside_setup_pid(void)
 
 /* Slots fan */
 static const struct wf_pid_param slots_param = {
-	.interval	= 5,
-	.history_len	= 2,
-	.gd		= 30 << 20,
-	.gp		= 5 << 20,
-	.gr		= 0,
-	.itarget	= 40 << 16,
-	.additive	= 1,
-	.min		= 300,
-	.max		= 4000,
+	.interval	= 1,
+	.history_len	= 20,
+	.gd		= 0,
+	.gp		= 0,
+	.gr		= 0x00100000,
+	.itarget	= 3200000,
+	.additive	= 0,
+	.min		= 20,
+	.max		= 100,
 };
 
 static void slots_fan_tick(void)
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index a746ba2..a956053 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -1007,7 +1007,7 @@ static void arcnet_rx(struct net_device *dev, int bufnum)
 
 	soft = &pkt.soft.rfc1201;
 
-	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, sizeof(ARC_HDR_SIZE));
+	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, ARC_HDR_SIZE);
 	if (pkt.hard.offset[0]) {
 		ofs = pkt.hard.offset[0];
 		length = 256 - ofs;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
index 87592b4..b3c05de 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
@@ -108,9 +108,8 @@ s32 ixgbe_dcb_config_tx_desc_arbiter_82598(struct ixgbe_hw *hw,
 
 	/* Enable arbiter */
 	reg &= ~IXGBE_DPMCS_ARBDIS;
-	/* Enable DFP and Recycle mode */
-	reg |= (IXGBE_DPMCS_TDPAC | IXGBE_DPMCS_TRM);
 	reg |= IXGBE_DPMCS_TSOEF;
+
 	/* Configure Max TSO packet size 34KB including payload and headers */
 	reg |= (0x4 << IXGBE_DPMCS_MTSOS_SHIFT);
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index d9ef667..bf8eb57 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -478,7 +478,7 @@ rx_status_loop:
 
 	while (1) {
 		u32 status, len;
-		dma_addr_t mapping;
+		dma_addr_t mapping, new_mapping;
 		struct sk_buff *skb, *new_skb;
 		struct cp_desc *desc;
 		const unsigned buflen = cp->rx_buf_sz;
@@ -520,6 +520,13 @@ rx_status_loop:
 			goto rx_next;
 		}
 
+		new_mapping = dma_map_single(&cp->pdev->dev, new_skb->data, buflen,
+					 PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
+			dev->stats.rx_dropped++;
+			goto rx_next;
+		}
+
 		dma_unmap_single(&cp->pdev->dev, mapping,
 				 buflen, PCI_DMA_FROMDEVICE);
 
@@ -531,12 +538,11 @@ rx_status_loop:
 
 		skb_put(skb, len);
 
-		mapping = dma_map_single(&cp->pdev->dev, new_skb->data, buflen,
-					 PCI_DMA_FROMDEVICE);
 		cp->rx_skb[rx_tail] = new_skb;
 
 		cp_rx_skb(cp, skb, desc);
 		rx++;
+		mapping = new_mapping;
 
 rx_next:
 		cp->rx_ring[rx_tail].opts2 = 0;
@@ -707,6 +713,22 @@ static inline u32 cp_tx_vlan_tag(struct sk_buff *skb)
 		TxVlanTag | swab16(vlan_tx_tag_get(skb)) : 0x00;
 }
 
+static void unwind_tx_frag_mapping(struct cp_private *cp, struct sk_buff *skb,
+				   int first, int entry_last)
+{
+	int frag, index;
+	struct cp_desc *txd;
+	skb_frag_t *this_frag;
+	for (frag = 0; frag+first < entry_last; frag++) {
+		index = first+frag;
+		cp->tx_skb[index] = NULL;
+		txd = &cp->tx_ring[index];
+		this_frag = &skb_shinfo(skb)->frags[frag];
+		dma_unmap_single(&cp->pdev->dev, le64_to_cpu(txd->addr),
+				 skb_frag_size(this_frag), PCI_DMA_TODEVICE);
+	}
+}
+
 static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 					struct net_device *dev)
 {
@@ -740,6 +762,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 
 		len = skb->len;
 		mapping = dma_map_single(&cp->pdev->dev, skb->data, len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping))
+			goto out_dma_error;
+
 		txd->opts2 = opts2;
 		txd->addr = cpu_to_le64(mapping);
 		wmb();
@@ -777,6 +802,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 		first_len = skb_headlen(skb);
 		first_mapping = dma_map_single(&cp->pdev->dev, skb->data,
 					       first_len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, first_mapping))
+			goto out_dma_error;
+
 		cp->tx_skb[entry] = skb;
 		entry = NEXT_TX(entry);
 
@@ -790,6 +818,11 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 			mapping = dma_map_single(&cp->pdev->dev,
 						 skb_frag_address(this_frag),
 						 len, PCI_DMA_TODEVICE);
+			if (dma_mapping_error(&cp->pdev->dev, mapping)) {
+				unwind_tx_frag_mapping(cp, skb, first_entry, entry);
+				goto out_dma_error;
+			}
+
 			eor = (entry == (CP_TX_RING_SIZE - 1)) ? RingEnd : 0;
 
 			ctrl = eor | len | DescOwn;
@@ -848,11 +881,16 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 	if (TX_BUFFS_AVAIL(cp) <= (MAX_SKB_FRAGS + 1))
 		netif_stop_queue(dev);
 
+out_unlock:
 	spin_unlock_irqrestore(&cp->lock, intr_flags);
 
 	cpw8(TxPoll, NormalTxPoll);
 
 	return NETDEV_TX_OK;
+out_dma_error:
+	kfree_skb(skb);
+	cp->dev->stats.tx_dropped++;
+	goto out_unlock;
 }
 
 /* Set or clear the multicast filter for this adaptor.
@@ -1039,6 +1077,10 @@ static int cp_refill_rx(struct cp_private *cp)
 
 		mapping = dma_map_single(&cp->pdev->dev, skb->data,
 					 cp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping)) {
+			kfree_skb(skb);
+			goto err_out;
+		}
 		cp->rx_skb[i] = skb;
 
 		cp->rx_ring[i].opts2 = 0;
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 2e50fbb..c241ae7 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -43,7 +43,6 @@
 #define EEPROM_MAC_OFFSET		(0x01)
 #define DEFAULT_TX_CSUM_ENABLE		(true)
 #define DEFAULT_RX_CSUM_ENABLE		(true)
-#define DEFAULT_TSO_ENABLE		(true)
 #define SMSC75XX_INTERNAL_PHY_ID	(1)
 #define SMSC75XX_TX_OVERHEAD		(8)
 #define MAX_RX_FIFO_SIZE		(20 * 1024)
@@ -1053,17 +1052,14 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
 
-	if (DEFAULT_TX_CSUM_ENABLE) {
+	if (DEFAULT_TX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		if (DEFAULT_TSO_ENABLE)
-			dev->net->features |= NETIF_F_SG |
-				NETIF_F_TSO | NETIF_F_TSO6;
-	}
+
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
 
 	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_RXCSUM;
+				NETIF_F_RXCSUM;
 
 	/* Init all registers */
 	ret = smsc75xx_reset(dev);
@@ -1188,8 +1184,6 @@ static struct sk_buff *smsc75xx_tx_fixup(struct usbnet *dev,
 {
 	u32 tx_cmd_a, tx_cmd_b;
 
-	skb_linearize(skb);
-
 	if (skb_headroom(skb) < SMSC75XX_TX_OVERHEAD) {
 		struct sk_buff *skb2 =
 			skb_copy_expand(skb, SMSC75XX_TX_OVERHEAD, 0, flags);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f18149a..858a8da 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -528,7 +528,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 {
 	struct virtnet_info *vi = container_of(napi, struct virtnet_info, napi);
 	void *buf;
-	unsigned int len, received = 0;
+	unsigned int r, len, received = 0;
 
 again:
 	while (received < budget &&
@@ -545,8 +545,9 @@ again:
 
 	/* Out of packets? */
 	if (received < budget) {
+		r = virtqueue_enable_cb_prepare(vi->rvq);
 		napi_complete(napi);
-		if (unlikely(!virtqueue_enable_cb(vi->rvq)) &&
+		if (unlikely(virtqueue_poll(vi->rvq, r)) &&
 		    napi_schedule_prep(napi)) {
 			virtqueue_disable_cb(vi->rvq);
 			__napi_schedule(napi);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 21c280b..29641e7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -824,6 +824,7 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	if (error != 0)
 		goto err_rx;
 
+	ath9k_hw_disable(priv->ah);
 #ifdef CONFIG_MAC80211_LEDS
 	/* must be initialized before ieee80211_register_hw */
 	priv->led_cdev.default_trigger = ieee80211_create_tpt_led_trigger(priv->hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index a0b0b78..2c86c55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -776,9 +776,23 @@ int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		if (old_state == IEEE80211_STA_NOTEXIST &&
-		    new_state == IEEE80211_STA_NONE)
+		    new_state == IEEE80211_STA_NONE) {
+			/*
+			 * Firmware bug - it'll crash if the beacon interval is less
+			 * than 16. We can't avoid connecting at all, so refuse the
+			 * station state change, this will cause mac80211 to abandon
+			 * attempts to connect to this AP, and eventually wpa_s will
+			 * blacklist the AP...
+			 */
+			if (vif->bss_conf.beacon_int < 16) {
+				IWL_ERR(priv,
+					"AP %pM beacon interval is %d, refusing due to firmware bug!\n",
+					sta->addr, vif->bss_conf.beacon_int);
+				ret = -EINVAL;
+				goto out_unlock;
+			}
 			op = ADD;
-		else if (old_state == IEEE80211_STA_NONE &&
+		} else if (old_state == IEEE80211_STA_NONE &&
 			 new_state == IEEE80211_STA_NOTEXIST)
 			op = REMOVE;
 		else if (old_state == IEEE80211_STA_AUTH &&
@@ -846,6 +860,7 @@ int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	if (iwl_is_rfkill(priv))
 		ret = 0;
 
+out_unlock:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index f482515..2b425da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -131,6 +131,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x423C, 0x1306, iwl5150_abg_cfg)}, /* Half Mini Card */
 	{IWL_PCI_DEVICE(0x423C, 0x1221, iwl5150_agn_cfg)}, /* Mini Card */
 	{IWL_PCI_DEVICE(0x423C, 0x1321, iwl5150_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1326, iwl5150_abg_cfg)}, /* Half Mini Card */
 
 	{IWL_PCI_DEVICE(0x423D, 0x1211, iwl5150_agn_cfg)}, /* Mini Card */
 	{IWL_PCI_DEVICE(0x423D, 0x1311, iwl5150_agn_cfg)}, /* Half Mini Card */
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 82cf0fa..821d9d2 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1455,8 +1455,8 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) pkt_len;
-	*(u16 *) &payload[2] = type;
+	*(__le16 *)&payload[0] = cpu_to_le16((u16)pkt_len);
+	*(__le16 *)&payload[2] = cpu_to_le16(type);
 
 	/*
 	 * This is SDIO specific header
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2fd8301..6d0c651 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -877,13 +877,8 @@ void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
-void rt2x00queue_pause_queue(struct data_queue *queue)
+void rt2x00queue_pause_queue_nocheck(struct data_queue *queue)
 {
-	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
-	    !test_bit(QUEUE_STARTED, &queue->flags) ||
-	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
-		return;
-
 	switch (queue->qid) {
 	case QID_AC_VO:
 	case QID_AC_VI:
@@ -899,6 +894,15 @@ void rt2x00queue_pause_queue(struct data_queue *queue)
 		break;
 	}
 }
+void rt2x00queue_pause_queue(struct data_queue *queue)
+{
+	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
+	    !test_bit(QUEUE_STARTED, &queue->flags) ||
+	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
+		return;
+
+	rt2x00queue_pause_queue_nocheck(queue);
+}
 EXPORT_SYMBOL_GPL(rt2x00queue_pause_queue);
 
 void rt2x00queue_unpause_queue(struct data_queue *queue)
@@ -960,7 +964,7 @@ void rt2x00queue_stop_queue(struct data_queue *queue)
 		return;
 	}
 
-	rt2x00queue_pause_queue(queue);
+	rt2x00queue_pause_queue_nocheck(queue);
 
 	queue->rt2x00dev->ops->lib->stop_queue(queue);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d525297..7593e28 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3493,11 +3493,21 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		break;
 	}
 
-	/*
-	 * We expect the FW state to be READY
-	 */
-	if (megasas_transition_to_ready(instance, 0))
-		goto fail_ready_state;
+	if (megasas_transition_to_ready(instance, 0)) {
+		atomic_set(&instance->fw_reset_no_pci_access, 1);
+		instance->instancet->adp_reset
+			(instance, instance->reg_set);
+		atomic_set(&instance->fw_reset_no_pci_access, 0);
+		dev_info(&instance->pdev->dev,
+			"megasas: FW restarted successfully from %s!\n",
+			__func__);
+
+		/*waitting for about 30 second before retry*/
+		ssleep(30);
+
+		if (megasas_transition_to_ready(instance, 0))
+			goto fail_ready_state;
+	}
 
 	/* Check if MSI-X is supported while in ready state */
 	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 62b6168..e705ed3 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2926,7 +2926,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	mdelay(RESET_HOLD_TIME / 1000);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index bbbc9c9..203c7c5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1029,6 +1029,9 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 {
 	int i, result;
 
+	if (sdev->skip_vpd_pages)
+		goto fail;
+
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result)
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 1ae0610..2e88a68 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -545,7 +545,7 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 	end = start + (bio->bi_size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
 	/* out of range range */
-	if (unlikely(start >= bound || end >= bound || start > end))
+	if (unlikely(start >= bound || end > bound || start > end))
 		return 0;
 
 	/* I/O request is valid */
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index ec56d83..64565f8 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -376,11 +376,18 @@ static void mxs_auart_settermios(struct uart_port *u,
 
 static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 {
-	u32 istatus, istat;
+	u32 istat;
 	struct mxs_auart_port *s = context;
 	u32 stat = readl(s->port.membase + AUART_STAT);
 
-	istatus = istat = readl(s->port.membase + AUART_INTR);
+	istat = readl(s->port.membase + AUART_INTR);
+
+	/* ack irq */
+	writel(istat & (AUART_INTR_RTIS
+		| AUART_INTR_TXIS
+		| AUART_INTR_RXIS
+		| AUART_INTR_CTSMIS),
+			s->port.membase + AUART_INTR_CLR);
 
 	if (istat & AUART_INTR_CTSMIS) {
 		uart_handle_cts_change(&s->port, stat & AUART_STAT_CTS);
@@ -399,12 +406,6 @@ static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 		istat &= ~AUART_INTR_TXIS;
 	}
 
-	writel(istatus & (AUART_INTR_RTIS
-		| AUART_INTR_TXIS
-		| AUART_INTR_RXIS
-		| AUART_INTR_CTSMIS),
-			s->port.membase + AUART_INTR_CLR);
-
 	return IRQ_HANDLED;
 }
 
@@ -544,7 +545,7 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 	struct mxs_auart_port *s;
 	struct uart_port *port;
 	unsigned int old_ctrl0, old_ctrl2;
-	unsigned int to = 1000;
+	unsigned int to = 20000;
 
 	if (co->index >	MXS_AUART_PORTS || co->index < 0)
 		return;
@@ -565,18 +566,23 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 
 	uart_console_write(port, str, count, mxs_auart_console_putchar);
 
-	/*
-	 * Finally, wait for transmitter to become empty
-	 * and restore the TCR
-	 */
+	/* Finally, wait for transmitter to become empty ... */
 	while (readl(port->membase + AUART_STAT) & AUART_STAT_BUSY) {
+		udelay(1);
 		if (!to--)
 			break;
-		udelay(1);
 	}
 
-	writel(old_ctrl0, port->membase + AUART_CTRL0);
-	writel(old_ctrl2, port->membase + AUART_CTRL2);
+	/*
+	 * ... and restore the TCR if we waited long enough for the transmitter
+	 * to be idle. This might keep the transmitter enabled although it is
+	 * unused, but that is better than to disable it while it is still
+	 * transmitting.
+	 */
+	if (!(readl(port->membase + AUART_STAT) & AUART_STAT_BUSY)) {
+		writel(old_ctrl0, port->membase + AUART_CTRL0);
+		writel(old_ctrl2, port->membase + AUART_CTRL2);
+	}
 
 	clk_disable(s->clk);
 }
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d5515c0..8deaeb5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4552,7 +4552,8 @@ static void hub_events(void)
 					hub->hdev->children[i - 1];
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev) {
+				if (!udev || !(portstatus &
+						USB_PORT_STAT_CONNECTION)) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
@@ -4562,8 +4563,8 @@ static void hub_events(void)
 					usb_lock_device(udev);
 					status = usb_reset_device(udev);
 					usb_unlock_device(udev);
+					connect_change = 0;
 				}
-				connect_change = 0;
 			}
 
 			if (connect_change)
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3dbec15..c57562a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -743,9 +743,34 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_RTS01_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S03_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_59_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57A_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29A_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29F_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_62B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S01_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_63_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29C_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_81B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_82B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K5D_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K4Y_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K5G_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S05_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_60_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_61_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_62_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_63B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_64_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_65_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_92_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_92D_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_W5R_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_A5R_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_PW1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 6dd7925..1b8af46 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -815,11 +815,35 @@
 /*
  * RT Systems programming cables for various ham radios
  */
-#define RTSYSTEMS_VID			0x2100	/* Vendor ID */
-#define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
-#define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
-#define RTSYSTEMS_RTS01_PID		0x9e57	/* USB-RTS01 Radio Cable */
-
+#define RTSYSTEMS_VID		0x2100	/* Vendor ID */
+#define RTSYSTEMS_USB_S03_PID	0x9001	/* RTS-03 USB to Serial Adapter */
+#define RTSYSTEMS_USB_59_PID	0x9e50	/* USB-59 USB to 8 pin plug */
+#define RTSYSTEMS_USB_57A_PID	0x9e51	/* USB-57A USB to 4pin 3.5mm plug */
+#define RTSYSTEMS_USB_57B_PID	0x9e52	/* USB-57B USB to extended 4pin 3.5mm plug */
+#define RTSYSTEMS_USB_29A_PID	0x9e53	/* USB-29A USB to 3.5mm stereo plug */
+#define RTSYSTEMS_USB_29B_PID	0x9e54	/* USB-29B USB to 6 pin mini din */
+#define RTSYSTEMS_USB_29F_PID	0x9e55	/* USB-29F USB to 6 pin modular plug */
+#define RTSYSTEMS_USB_62B_PID	0x9e56	/* USB-62B USB to 8 pin mini din plug*/
+#define RTSYSTEMS_USB_S01_PID	0x9e57	/* USB-RTS01 USB to 3.5 mm stereo plug*/
+#define RTSYSTEMS_USB_63_PID	0x9e58	/* USB-63 USB to 9 pin female*/
+#define RTSYSTEMS_USB_29C_PID	0x9e59	/* USB-29C USB to 4 pin modular plug*/
+#define RTSYSTEMS_USB_81B_PID	0x9e5A	/* USB-81 USB to 8 pin mini din plug*/
+#define RTSYSTEMS_USB_82B_PID	0x9e5B	/* USB-82 USB to 2.5 mm stereo plug*/
+#define RTSYSTEMS_USB_K5D_PID	0x9e5C	/* USB-K5D USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_K4Y_PID	0x9e5D	/* USB-K4Y USB to 2.5/3.5 mm plugs*/
+#define RTSYSTEMS_USB_K5G_PID	0x9e5E	/* USB-K5G USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_S05_PID	0x9e5F	/* USB-RTS05 USB to 2.5 mm stereo plug*/
+#define RTSYSTEMS_USB_60_PID	0x9e60	/* USB-60 USB to 6 pin din*/
+#define RTSYSTEMS_USB_61_PID	0x9e61	/* USB-61 USB to 6 pin mini din*/
+#define RTSYSTEMS_USB_62_PID	0x9e62	/* USB-62 USB to 8 pin mini din*/
+#define RTSYSTEMS_USB_63B_PID	0x9e63	/* USB-63 USB to 9 pin female*/
+#define RTSYSTEMS_USB_64_PID	0x9e64	/* USB-64 USB to 9 pin male*/
+#define RTSYSTEMS_USB_65_PID	0x9e65	/* USB-65 USB to 9 pin female null modem*/
+#define RTSYSTEMS_USB_92_PID	0x9e66	/* USB-92 USB to 12 pin plug*/
+#define RTSYSTEMS_USB_92D_PID	0x9e67	/* USB-92D USB to 12 pin plug data*/
+#define RTSYSTEMS_USB_W5R_PID	0x9e68	/* USB-W5R USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_A5R_PID	0x9e69	/* USB-A5R USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_PW1_PID	0x9e6A	/* USB-PW1 USB to 8 pin modular plug*/
 
 /*
  * Physik Instrumente
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 297847b..0d51815 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -188,7 +188,9 @@
 #define LED_ON_MS	500
 #define LED_OFF_MS	500
 
-static int device_type;
+enum mos7840_flag {
+	MOS7840_FLAG_CTRL_BUSY,
+};
 
 static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
@@ -248,6 +250,8 @@ struct moschip_port {
 	bool led_flag;
 	struct timer_list led_timer1;	/* Timer for LED on */
 	struct timer_list led_timer2;	/* Timer for LED off */
+
+	unsigned long flags;
 };
 
 static bool debug;
@@ -508,11 +512,11 @@ static void mos7840_control_callback(struct urb *urb)
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d", __func__,
 		    status);
-		return;
+		goto out;
 	default:
 		dbg("%s - nonzero urb status received: %d", __func__,
 		    status);
-		return;
+		goto out;
 	}
 
 	dbg("%s urb buffer size is %d", __func__, urb->actual_length);
@@ -525,6 +529,8 @@ static void mos7840_control_callback(struct urb *urb)
 		mos7840_handle_new_msr(mos7840_port, regval);
 	else if (mos7840_port->MsrLsr == 1)
 		mos7840_handle_new_lsr(mos7840_port, regval);
+out:
+	clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mos7840_port->flags);
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
@@ -535,6 +541,9 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 	unsigned char *buffer = mcs->ctrl_buf;
 	int ret;
 
+	if (test_and_set_bit_lock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags))
+		return -EBUSY;
+
 	dr->bRequestType = MCS_RD_RTYPE;
 	dr->bRequest = MCS_RDREQ;
 	dr->wValue = cpu_to_le16(Wval);	/* 0 */
@@ -546,6 +555,9 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 			     mos7840_control_callback, mcs);
 	mcs->control_urb->transfer_buffer_length = 2;
 	ret = usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	if (ret)
+		clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags);
+
 	return ret;
 }
 
@@ -880,18 +892,6 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 /************************************************************************/
 /*       D R I V E R  T T Y  I N T E R F A C E  F U N C T I O N S       */
 /************************************************************************/
-#ifdef MCSSerialProbe
-static int mos7840_serial_probe(struct usb_serial *serial,
-				const struct usb_device_id *id)
-{
-
-	/*need to implement the mode_reg reading and updating\
-	   structures usb_serial_ device_type\
-	   (i.e num_ports, num_bulkin,bulkout etc) */
-	/* Also we can update the changes  attach */
-	return 1;
-}
-#endif
 
 /*****************************************************************************
  * mos7840_open
@@ -2402,38 +2402,48 @@ static int mos7810_check(struct usb_serial *serial)
 	return 0;
 }
 
-static int mos7840_calc_num_ports(struct usb_serial *serial)
+static int mos7840_probe(struct usb_serial *serial,
+				const struct usb_device_id *id)
 {
-	__u16 data = 0x00;
+	u16 product = serial->dev->descriptor.idProduct;
 	u8 *buf;
-	int mos7840_num_ports;
+	int device_type;
+
+	if (product == MOSCHIP_DEVICE_ID_7810 ||
+		product == MOSCHIP_DEVICE_ID_7820) {
+		device_type = product;
+		goto out;
+	}
 
 	buf = kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
-	if (buf) {
-		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	if (!buf)
+		return -ENOMEM;
+
+	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
 			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
-		data = *buf;
-		kfree(buf);
-	}
 
-	if (serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7810 ||
-		serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7820) {
-		device_type = serial->dev->descriptor.idProduct;
-	} else {
-		/* For a MCS7840 device GPIO0 must be set to 1 */
-		if ((data & 0x01) == 1)
-			device_type = MOSCHIP_DEVICE_ID_7840;
-		else if (mos7810_check(serial))
-			device_type = MOSCHIP_DEVICE_ID_7810;
-		else
-			device_type = MOSCHIP_DEVICE_ID_7820;
-	}
+	/* For a MCS7840 device GPIO0 must be set to 1 */
+	if (buf[0] & 0x01)
+		device_type = MOSCHIP_DEVICE_ID_7840;
+	else if (mos7810_check(serial))
+		device_type = MOSCHIP_DEVICE_ID_7810;
+	else
+		device_type = MOSCHIP_DEVICE_ID_7820;
+
+	kfree(buf);
+out:
+	usb_set_serial_data(serial, (void *)(unsigned long)device_type);
+
+	return 0;
+}
+
+static int mos7840_calc_num_ports(struct usb_serial *serial)
+{
+	int device_type = (unsigned long)usb_get_serial_data(serial);
+	int mos7840_num_ports;
 
 	mos7840_num_ports = (device_type >> 4) & 0x000F;
-	serial->num_bulk_in = mos7840_num_ports;
-	serial->num_bulk_out = mos7840_num_ports;
-	serial->num_ports = mos7840_num_ports;
 
 	return mos7840_num_ports;
 }
@@ -2444,6 +2454,7 @@ static int mos7840_calc_num_ports(struct usb_serial *serial)
 
 static int mos7840_startup(struct usb_serial *serial)
 {
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	struct moschip_port *mos7840_port;
 	struct usb_device *dev;
 	int i, status;
@@ -2785,9 +2796,7 @@ static struct usb_serial_driver moschip7840_4port_device = {
 	.throttle = mos7840_throttle,
 	.unthrottle = mos7840_unthrottle,
 	.calc_num_ports = mos7840_calc_num_ports,
-#ifdef MCSSerialProbe
-	.probe = mos7840_serial_probe,
-#endif
+	.probe = mos7840_probe,
 	.ioctl = mos7840_ioctl,
 	.set_termios = mos7840_set_termios,
 	.break_ctl = mos7840_break,
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 52bfd07..c212de7 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -498,16 +498,18 @@ EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
  * virtqueue_enable_cb - restart callbacks after disable_cb.
  * @vq: the struct virtqueue we're talking about.
  *
- * This re-enables callbacks; it returns "false" if there are pending
- * buffers in the queue, to detect a possible race between the driver
- * checking for more work, and enabling callbacks.
+ * This re-enables callbacks; it returns current queue state
+ * in an opaque unsigned value. This value should be later tested by
+ * virtqueue_poll, to detect a possible race between the driver checking for
+ * more work, and enabling callbacks.
  *
  * Caller must ensure we don't call this with other virtqueue
  * operations at the same time (except where noted).
  */
-bool virtqueue_enable_cb(struct virtqueue *_vq)
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 last_used_idx;
 
 	START_USE(vq);
 
@@ -517,15 +519,45 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 	 * either clear the flags bit or point the event index at the next
 	 * entry. Always do both to keep code simple. */
 	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
-	vring_used_event(&vq->vring) = vq->last_used_idx;
+	vring_used_event(&vq->vring) = last_used_idx = vq->last_used_idx;
+	END_USE(vq);
+	return last_used_idx;
+}
+EXPORT_SYMBOL_GPL(virtqueue_enable_cb_prepare);
+
+/**
+ * virtqueue_poll - query pending used buffers
+ * @vq: the struct virtqueue we're talking about.
+ * @last_used_idx: virtqueue state (from call to virtqueue_enable_cb_prepare).
+ *
+ * Returns "true" if there are pending used buffers in the queue.
+ *
+ * This does not need to be serialized.
+ */
+bool virtqueue_poll(struct virtqueue *_vq, unsigned last_used_idx)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
 	virtio_mb(vq);
-	if (unlikely(more_used(vq))) {
-		END_USE(vq);
-		return false;
-	}
+	return (u16)last_used_idx != vq->vring.used->idx;
+}
+EXPORT_SYMBOL_GPL(virtqueue_poll);
 
-	END_USE(vq);
-	return true;
+/**
+ * virtqueue_enable_cb - restart callbacks after disable_cb.
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * This re-enables callbacks; it returns "false" if there are pending
+ * buffers in the queue, to detect a possible race between the driver
+ * checking for more work, and enabling callbacks.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ */
+bool virtqueue_enable_cb(struct virtqueue *_vq)
+{
+	unsigned last_used_idx = virtqueue_enable_cb_prepare(_vq);
+	return !virtqueue_poll(_vq, last_used_idx);
 }
 EXPORT_SYMBOL_GPL(virtqueue_enable_cb);
 
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index b2db77e..82b27d4 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -377,18 +377,12 @@ static long evtchn_ioctl(struct file *file,
 		if (unbind.port >= NR_EVENT_CHANNELS)
 			break;
 
-		spin_lock_irq(&port_user_lock);
-
 		rc = -ENOTCONN;
-		if (get_port_user(unbind.port) != u) {
-			spin_unlock_irq(&port_user_lock);
+		if (get_port_user(unbind.port) != u)
 			break;
-		}
 
 		disable_irq(irq_from_evtchn(unbind.port));
 
-		spin_unlock_irq(&port_user_lock);
-
 		evtchn_unbind_from_user(u, unbind.port);
 
 		rc = 0;
@@ -488,26 +482,15 @@ static int evtchn_release(struct inode *inode, struct file *filp)
 	int i;
 	struct per_user_data *u = filp->private_data;
 
-	spin_lock_irq(&port_user_lock);
-
-	free_page((unsigned long)u->ring);
-
 	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
 		if (get_port_user(i) != u)
 			continue;
 
 		disable_irq(irq_from_evtchn(i));
-	}
-
-	spin_unlock_irq(&port_user_lock);
-
-	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
-		if (get_port_user(i) != u)
-			continue;
-
 		evtchn_unbind_from_user(get_port_user(i), i);
 	}
 
+	free_page((unsigned long)u->ring);
 	kfree(u->name);
 	kfree(u);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b1dc7b..6bb1213 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6848,6 +6848,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int err = 0;
 	int ret;
 	int level;
+	bool root_dropped = false;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -7018,12 +7019,22 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		free_extent_buffer(root->commit_root);
 		kfree(root);
 	}
+	root_dropped = true;
 out_end_trans:
 	btrfs_end_transaction_throttle(trans, tree_root);
 out_free:
 	kfree(wc);
 	btrfs_free_path(path);
 out:
+	/*
+	 * So if we need to stop dropping the snapshot for whatever reason we
+	 * need to make sure to add it back to the dead root list so that we
+	 * keep trying to do the work later.  This also cleans up roots if we
+	 * don't have it in the radix (like when we recover after a power fail
+	 * or unmount) so we don't leak memory.
+	 */
+	if (root_dropped == false)
+		btrfs_add_dead_root(root);
 	if (err)
 		btrfs_std_error(root->fs_info, err);
 	return err;
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 6d0c62a..6dd3b61 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -369,7 +369,7 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		if (blobptr + attrsize > blobend)
 			break;
 		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
-			if (!attrsize)
+			if (!attrsize || attrsize >= CIFS_MAX_DOMAINNAME_LEN)
 				break;
 			if (!ses->domainName) {
 				ses->domainName =
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d86ba9f..761e13c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -38,6 +38,7 @@
 #define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
 #define MAX_SERVER_SIZE 15
 #define MAX_SHARE_SIZE 80
+#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
 #define MAX_USERNAME_SIZE 256	/* reasonable maximum for current servers */
 #define MAX_PASSWORD_SIZE 512	/* max for windows seems to be 256 wide chars */
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9169ae3..780385f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1766,7 +1766,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnlen(string, 256) == 256) {
+			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
+					== CIFS_MAX_DOMAINNAME_LEN) {
 				printk(KERN_WARNING "CIFS: domain name too"
 						    " long\n");
 				goto cifs_parse_mount_err;
@@ -2453,8 +2454,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 #ifdef CONFIG_KEYS
 
-/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
-#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
+/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
+#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
 
 /* Populate username and pw fields from keyring if possible */
 static int
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 551d0c2..de9b1c1 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -198,7 +198,7 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 		bytes_ret = 0;
 	} else
 		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->domainName,
-					    256, nls_cp);
+					    CIFS_MAX_DOMAINNAME_LEN, nls_cp);
 	bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2;  /* account for null terminator */
 
@@ -256,8 +256,8 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 
 	/* copy domain */
 	if (ses->domainName != NULL) {
-		strncpy(bcc_ptr, ses->domainName, 256);
-		bcc_ptr += strnlen(ses->domainName, 256);
+		strncpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
+		bcc_ptr += strnlen(ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
 	} /* else we will send a null domain name
 	     so the server will default to its own domain */
 	*bcc_ptr = 0;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b80bc84..9dc6e76 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -527,8 +527,7 @@ EXPORT_SYMBOL_GPL(debugfs_remove);
  */
 void debugfs_remove_recursive(struct dentry *dentry)
 {
-	struct dentry *child;
-	struct dentry *parent;
+	struct dentry *child, *next, *parent;
 
 	if (!dentry)
 		return;
@@ -538,61 +537,37 @@ void debugfs_remove_recursive(struct dentry *dentry)
 		return;
 
 	parent = dentry;
+ down:
 	mutex_lock(&parent->d_inode->i_mutex);
+	list_for_each_entry_safe(child, next, &parent->d_subdirs, d_u.d_child) {
+		if (!debugfs_positive(child))
+			continue;
 
-	while (1) {
-		/*
-		 * When all dentries under "parent" has been removed,
-		 * walk up the tree until we reach our starting point.
-		 */
-		if (list_empty(&parent->d_subdirs)) {
-			mutex_unlock(&parent->d_inode->i_mutex);
-			if (parent == dentry)
-				break;
-			parent = parent->d_parent;
-			mutex_lock(&parent->d_inode->i_mutex);
-		}
-		child = list_entry(parent->d_subdirs.next, struct dentry,
-				d_u.d_child);
- next_sibling:
-
-		/*
-		 * If "child" isn't empty, walk down the tree and
-		 * remove all its descendants first.
-		 */
+		/* perhaps simple_empty(child) makes more sense */
 		if (!list_empty(&child->d_subdirs)) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
-			mutex_lock(&parent->d_inode->i_mutex);
-			continue;
+			goto down;
 		}
-		__debugfs_remove(child, parent);
-		if (parent->d_subdirs.next == &child->d_u.d_child) {
-			/*
-			 * Try the next sibling.
-			 */
-			if (child->d_u.d_child.next != &parent->d_subdirs) {
-				child = list_entry(child->d_u.d_child.next,
-						   struct dentry,
-						   d_u.d_child);
-				goto next_sibling;
-			}
-
-			/*
-			 * Avoid infinite loop if we fail to remove
-			 * one dentry.
-			 */
-			mutex_unlock(&parent->d_inode->i_mutex);
-			break;
-		}
-		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+ up:
+		if (!__debugfs_remove(child, parent))
+			simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	}
 
-	parent = dentry->d_parent;
+	mutex_unlock(&parent->d_inode->i_mutex);
+	child = parent;
+	parent = parent->d_parent;
 	mutex_lock(&parent->d_inode->i_mutex);
-	__debugfs_remove(dentry, parent);
+
+	if (child != dentry) {
+		next = list_entry(child->d_u.d_child.next, struct dentry,
+					d_u.d_child);
+		goto up;
+	}
+
+	if (!__debugfs_remove(child, parent))
+		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	mutex_unlock(&parent->d_inode->i_mutex);
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b1919af..fa068c0 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -707,11 +707,8 @@ repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
 					      inode_bitmap_bh->b_data,
 					      EXT4_INODES_PER_GROUP(sb), ino);
-		if (ino >= EXT4_INODES_PER_GROUP(sb)) {
-			if (++group == ngroups)
-				group = 0;
-			continue;
-		}
+		if (ino >= EXT4_INODES_PER_GROUP(sb))
+			goto next_group;
 		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
 			ext4_error(sb, "reserved inode found cleared - "
 				   "inode=%lu", ino + 1);
@@ -729,6 +726,9 @@ repeat_in_this_group:
 			goto got; /* we grabbed the inode! */
 		if (ino < EXT4_INODES_PER_GROUP(sb))
 			goto repeat_in_this_group;
+next_group:
+		if (++group == ngroups)
+			group = 0;
 	}
 	err = -ENOSPC;
 	goto out;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0689c5d..0581e45 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1435,7 +1435,7 @@ static const struct mount_opts {
 	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_SET},
 	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_CLEAR},
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC, MOPT_SET | MOPT_EXPLICIT},
-	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR | MOPT_EXPLICIT},
+	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM, MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
 				    EXT4_MOUNT_JOURNAL_CHECKSUM), MOPT_SET},
@@ -3410,7 +3410,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+				 "both data=journal and dioread_nolock");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -4571,6 +4571,21 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "both data=journal and delalloc");
+			err = -EINVAL;
+			goto restore_opts;
+		}
+		if (test_opt(sb, DIOREAD_NOLOCK)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "both data=journal and dioread_nolock");
+			err = -EINVAL;
+			goto restore_opts;
+		}
+	}
+
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, "Abort forced by user");
 
diff --git a/fs/super.c b/fs/super.c
index cf00177..3c520a5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -298,19 +298,19 @@ EXPORT_SYMBOL(deactivate_super);
  *	and want to turn it into a full-blown active reference.  grab_super()
  *	is called with sb_lock held and drops it.  Returns 1 in case of
  *	success, 0 if we had failed (superblock contents was already dead or
- *	dying when grab_super() had been called).
+ *	dying when grab_super() had been called).  Note that this is only
+ *	called for superblocks not in rundown mode (== ones still on ->fs_supers
+ *	of their type), so increment of ->s_count is OK here.
  */
 static int grab_super(struct super_block *s) __releases(sb_lock)
 {
-	if (atomic_inc_not_zero(&s->s_active)) {
-		spin_unlock(&sb_lock);
-		return 1;
-	}
-	/* it's going away */
 	s->s_count++;
 	spin_unlock(&sb_lock);
-	/* wait for it to die */
 	down_write(&s->s_umount);
+	if ((s->s_flags & MS_BORN) && atomic_inc_not_zero(&s->s_active)) {
+		put_super(s);
+		return 1;
+	}
 	up_write(&s->s_umount);
 	put_super(s);
 	return 0;
@@ -440,11 +440,6 @@ retry:
 				destroy_super(s);
 				s = NULL;
 			}
-			down_write(&old->s_umount);
-			if (unlikely(!(old->s_flags & MS_BORN))) {
-				deactivate_locked_super(old);
-				goto retry;
-			}
 			return old;
 		}
 	}
@@ -677,10 +672,10 @@ restart:
 		if (hlist_unhashed(&sb->s_instances))
 			continue;
 		if (sb->s_bdev == bdev) {
-			if (grab_super(sb)) /* drops sb_lock */
-				return sb;
-			else
+			if (!grab_super(sb))
 				goto restart;
+			up_write(&sb->s_umount);
+			return sb;
 		}
 	}
 	spin_unlock(&sb_lock);
diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index d500369..1db453e 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -215,8 +215,8 @@ struct fw_cdev_event_request2 {
  * with the %FW_CDEV_ISO_INTERRUPT bit set, when explicitly requested with
  * %FW_CDEV_IOC_FLUSH_ISO, or when there have been so many completed packets
  * without the interrupt bit set that the kernel's internal buffer for @header
- * is about to overflow.  (In the last case, kernels with ABI version < 5 drop
- * header data up to the next interrupt packet.)
+ * is about to overflow.  (In the last case, ABI versions < 5 drop header data
+ * up to the next interrupt packet.)
  *
  * Isochronous transmit events (context type %FW_CDEV_ISO_CONTEXT_TRANSMIT):
  *
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 7edcf10..babdb98 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -426,6 +426,7 @@ struct fw_iso_context {
 	int type;
 	int channel;
 	int speed;
+	bool drop_overflow_headers;
 	size_t header_size;
 	union {
 		fw_iso_callback_t sc;
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 176a939..16cad53 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -71,6 +71,8 @@ struct trace_iterator {
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
 
+	cpumask_var_t		started;
+
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
@@ -83,7 +85,7 @@ struct trace_iterator {
 	loff_t			pos;
 	long			idx;
 
-	cpumask_var_t		started;
+	/* All new field here will be zeroed out in pipe_read */
 };
 
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b8cdad6..9003fe3 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -301,6 +301,17 @@ static inline unsigned hstate_index_to_shift(unsigned index)
 	return hstates[index].order + PAGE_SHIFT;
 }
 
+pgoff_t __basepage_index(struct page *page);
+
+/* Return page->index in PAGE_SIZE units */
+static inline pgoff_t basepage_index(struct page *page)
+{
+	if (!PageCompound(page))
+		return page->index;
+
+	return __basepage_index(page);
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -319,6 +330,11 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 	return 1;
 }
 #define hstate_index_to_shift(index) 0
+
+static inline pgoff_t basepage_index(struct page *page)
+{
+	return page->index;
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 56af22e..adde16f 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -14,6 +14,7 @@
  */
 
 #include <linux/list.h>
+#include <linux/err.h>
 
 struct module;
 struct device;
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 8efd28a..2b779bf 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -44,6 +44,10 @@ void virtqueue_disable_cb(struct virtqueue *vq);
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
 
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
+
+bool virtqueue_poll(struct virtqueue *vq, unsigned);
+
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
 
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);
diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
index 75271b9..7d28aff 100644
--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -188,6 +188,11 @@ struct __name##_back_ring {						\
 #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
+/* Ill-behaved frontend determination: Can there be this many requests? */
+#define RING_REQUEST_PROD_OVERFLOW(_r, _prod)               \
+    (((_prod) - (_r)->rsp_prod_pvt) > RING_SIZE(_r))
+
+
 #define RING_PUSH_REQUESTS(_r) do {					\
     wmb(); /* back sees requests /before/ updated producer index */	\
     (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 00aa7e3..dd815c3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -915,6 +915,15 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 }
 
 /*
+ * Initialize event state based on the perf_event_attr::disabled.
+ */
+static inline void perf_event__state_init(struct perf_event *event)
+{
+	event->state = event->attr.disabled ? PERF_EVENT_STATE_OFF :
+					      PERF_EVENT_STATE_INACTIVE;
+}
+
+/*
  * Called at perf_event creation and when events are attached/detached from a
  * group.
  */
@@ -6061,8 +6070,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->overflow_handler	= overflow_handler;
 	event->overflow_handler_context = context;
 
-	if (attr->disabled)
-		event->state = PERF_EVENT_STATE_OFF;
+	perf_event__state_init(event);
 
 	pmu = NULL;
 
@@ -6484,9 +6492,17 @@ SYSCALL_DEFINE5(perf_event_open,
 
 		mutex_lock(&gctx->mutex);
 		perf_remove_from_context(group_leader);
+
+		/*
+		 * Removing from the context ends up with disabled
+		 * event. What we want here is event in the initial
+		 * startup state, ready to be add into new context.
+		 */
+		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
 			perf_remove_from_context(sibling);
+			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
 		mutex_unlock(&gctx->mutex);
diff --git a/kernel/futex.c b/kernel/futex.c
index 8879430..f0ee318 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -60,6 +60,7 @@
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
+#include <linux/hugetlb.h>
 
 #include <asm/futex.h>
 
@@ -363,7 +364,7 @@ again:
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.inode = page_head->mapping->host;
-		key->shared.pgoff = page_head->index;
+		key->shared.pgoff = basepage_index(page);
 	}
 
 	get_futex_key_refs(key);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c099cc6..eb12b9e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5250,7 +5250,7 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8aba3f9..09739c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3526,6 +3526,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c6557ef..44fd603 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -679,6 +679,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
+pgoff_t __basepage_index(struct page *page)
+{
+	struct page *page_head = compound_head(page);
+	pgoff_t index = page_index(page_head);
+	unsigned long compound_idx;
+
+	if (!PageHuge(page_head))
+		return page_index(page);
+
+	if (compound_order(page_head) >= MAX_ORDER)
+		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
+	else
+		compound_idx = page - page_head;
+
+	return (index << compound_order(page_head)) + compound_idx;
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e6791f2..d56c8bb 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -35,6 +35,8 @@ static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
 static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
+static int tcp_syn_retries_min = 1;
+static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 
@@ -277,7 +279,9 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_tcp_syn_retries,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &tcp_syn_retries_min,
+		.extra2		= &tcp_syn_retries_max
 	},
 	{
 		.procname	= "tcp_synack_retries",
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 461e47c..65dff8a 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -256,10 +256,12 @@ static void __net_exit ip6mr_rules_exit(struct net *net)
 {
 	struct mr6_table *mrt, *next;
 
+	rtnl_lock();
 	list_for_each_entry_safe(mrt, next, &net->ipv6.mr6_tables, list) {
 		list_del(&mrt->list);
 		ip6mr_free_table(mrt);
 	}
+	rtnl_unlock();
 	fib_rules_unregister(net->ipv6.mr6_rules_ops);
 }
 #else
@@ -286,7 +288,10 @@ static int __net_init ip6mr_rules_init(struct net *net)
 
 static void __net_exit ip6mr_rules_exit(struct net *net)
 {
+	rtnl_lock();
 	ip6mr_free_table(net->ipv6.mrt6);
+	net->ipv6.mrt6 = NULL;
+	rtnl_unlock();
 }
 #endif
 
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7a09bbb..7dcb525 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2073,6 +2073,7 @@ static int pfkey_xfrm_policy2msg(struct sk_buff *skb, const struct xfrm_policy *
 			pol->sadb_x_policy_type = IPSEC_POLICY_NONE;
 	}
 	pol->sadb_x_policy_dir = dir+1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
 	pol->sadb_x_policy_priority = xp->priority;
 
@@ -3108,7 +3109,9 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	pol->sadb_x_policy_exttype = SADB_X_EXT_POLICY;
 	pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = dir+1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
+	pol->sadb_x_policy_priority = xp->priority;
 
 	/* Set sadb_comb's. */
 	if (x->id.proto == IPPROTO_AH)
@@ -3496,6 +3499,7 @@ static int pfkey_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	pol->sadb_x_policy_exttype = SADB_X_EXT_POLICY;
 	pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = dir + 1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = 0;
 	pol->sadb_x_policy_priority = 0;
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 56386f1..0042e61 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -561,6 +561,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 			if (sta->sdata->dev != dev)
 				continue;
 
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1914a65..d419c47 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -831,8 +831,14 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
-	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
-	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
+	/*
+	 * Drop duplicate 802.11 retransmissions
+	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
+	 */
+	if (rx->skb->len >= 24 && rx->sta &&
+	    !ieee80211_is_ctl(hdr->frame_control) &&
+	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index ca8e0a5..1f9c314 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -605,6 +605,7 @@ static int atm_tc_dump_class(struct Qdisc *sch, unsigned long cl,
 		struct sockaddr_atmpvc pvc;
 		int state;
 
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = flow->vcc->dev ? flow->vcc->dev->number : -1;
 		pvc.sap_addr.vpi = flow->vcc->vpi;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 611d5e9..823f07f 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1469,6 +1469,7 @@ static int cbq_dump_wrr(struct sk_buff *skb, struct cbq_class *cl)
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_cbq_wrropt opt;
 
+	memset(&opt, 0, sizeof(opt));
 	opt.flags = 0;
 	opt.allot = cl->allot;
 	opt.priority = cl->priority + 1;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 206465d..ad9a11c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5212,12 +5212,14 @@ EXPORT_SYMBOL(cfg80211_testmode_alloc_event_skb);
 
 void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 {
+	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
-	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), skb, 0,
+				nl80211_testmode_mcgrp.id, gfp);
 }
 EXPORT_SYMBOL(cfg80211_testmode_event);
 #endif
@@ -7925,7 +7927,8 @@ void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 54b422e..956c75d 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -584,7 +584,7 @@ static long snd_compr_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	mutex_lock(&stream->device->lock);
 	switch (_IOC_NR(cmd)) {
 	case _IOC_NR(SNDRV_COMPRESS_IOCTL_VERSION):
-		put_user(SNDRV_COMPRESS_VERSION,
+		retval = put_user(SNDRV_COMPRESS_VERSION,
 				(int __user *)arg) ? -EFAULT : 0;
 		break;
 	case _IOC_NR(SNDRV_COMPRESS_GET_CAPS):
diff --git a/sound/usb/6fire/comm.c b/sound/usb/6fire/comm.c
index 6c3d531..ed3f828 100644
--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -110,31 +110,56 @@ static int usb6fire_comm_send_buffer(u8 *buffer, struct usb_device *dev)
 static int usb6fire_comm_write8(struct comm_runtime *rt, u8 request,
 		u8 reg, u8 value)
 {
-	u8 buffer[13]; /* 13: maximum length of message */
+	u8 *buffer;
+	int ret;
+
+	/* 13: maximum length of message */
+	buffer = kmalloc(13, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
 	usb6fire_comm_init_buffer(buffer, 0x00, request, reg, value, 0x00);
-	return usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+	ret = usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+
+	kfree(buffer);
+	return ret;
 }
 
 static int usb6fire_comm_write16(struct comm_runtime *rt, u8 request,
 		u8 reg, u8 vl, u8 vh)
 {
-	u8 buffer[13]; /* 13: maximum length of message */
+	u8 *buffer;
+	int ret;
+
+	/* 13: maximum length of message */
+	buffer = kmalloc(13, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
 	usb6fire_comm_init_buffer(buffer, 0x00, request, reg, vl, vh);
-	return usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+	ret = usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+
+	kfree(buffer);
+	return ret;
 }
 
 int __devinit usb6fire_comm_init(struct sfire_chip *chip)
 {
 	struct comm_runtime *rt = kzalloc(sizeof(struct comm_runtime),
 			GFP_KERNEL);
-	struct urb *urb = &rt->receiver;
+	struct urb *urb;
 	int ret;
 
 	if (!rt)
 		return -ENOMEM;
 
+	rt->receiver_buffer = kzalloc(COMM_RECEIVER_BUFSIZE, GFP_KERNEL);
+	if (!rt->receiver_buffer) {
+		kfree(rt);
+		return -ENOMEM;
+	}
+
+	urb = &rt->receiver;
 	rt->serial = 1;
 	rt->chip = chip;
 	usb_init_urb(urb);
@@ -152,6 +177,7 @@ int __devinit usb6fire_comm_init(struct sfire_chip *chip)
 	urb->interval = 1;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(rt->receiver_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create comm data receiver.");
 		return ret;
@@ -170,6 +196,9 @@ void usb6fire_comm_abort(struct sfire_chip *chip)
 
 void usb6fire_comm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->comm);
+	struct comm_runtime *rt = chip->comm;
+
+	kfree(rt->receiver_buffer);
+	kfree(rt);
 	chip->comm = NULL;
 }
diff --git a/sound/usb/6fire/comm.h b/sound/usb/6fire/comm.h
index d2af0a5..fca24e3 100644
--- a/sound/usb/6fire/comm.h
+++ b/sound/usb/6fire/comm.h
@@ -24,7 +24,7 @@ struct comm_runtime {
 	struct sfire_chip *chip;
 
 	struct urb receiver;
-	u8 receiver_buffer[COMM_RECEIVER_BUFSIZE];
+	u8 *receiver_buffer;
 
 	u8 serial; /* urb serial */
 
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 060dccb..5fa3bd7 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -582,17 +582,16 @@ static int data_ep_set_params(struct snd_usb_endpoint *ep,
 	ep->stride = frame_bits >> 3;
 	ep->silence_value = format == SNDRV_PCM_FORMAT_U8 ? 0x80 : 0;
 
-	/* calculate max. frequency */
-	if (ep->maxpacksize) {
+	/* assume max. frequency is 25% higher than nominal */
+	ep->freqmax = ep->freqn + (ep->freqn >> 2);
+	maxsize = ((ep->freqmax + 0xffff) * (frame_bits >> 3))
+				>> (16 - ep->datainterval);
+	/* but wMaxPacketSize might reduce this */
+	if (ep->maxpacksize && ep->maxpacksize < maxsize) {
 		/* whatever fits into a max. size packet */
 		maxsize = ep->maxpacksize;
 		ep->freqmax = (maxsize / (frame_bits >> 3))
 				<< (16 - ep->datainterval);
-	} else {
-		/* no max. packet size: just take 25% higher than nominal */
-		ep->freqmax = ep->freqn + (ep->freqn >> 2);
-		maxsize = ((ep->freqmax + 0xffff) * (frame_bits >> 3))
-				>> (16 - ep->datainterval);
 	}
 
 	if (ep->fill_max)
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a1f4e36..81072b6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -15,7 +15,8 @@ const char *map_type__name[MAP__NR_TYPES] = {
 
 static inline int is_anon_memory(const char *filename)
 {
-	return strcmp(filename, "//anon") == 0;
+	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
 static inline int is_no_dso_memory(const char *filename)
