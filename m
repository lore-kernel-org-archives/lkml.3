Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423040Ab3FUJYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:24:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48257 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030473Ab3FUJYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:24:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.15
Date: Fri, 21 Jun 2013 10:24:16 +0100
Message-Id: <1371806656-7492-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371806656-7492-1-git-send-email-luis.henriques@canonical.com>
References: <1371806656-7492-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index b57a3c0f..ddb7313 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .14
+EXTRAVERSION = .15
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index bb26756..8504174 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -126,7 +126,7 @@ KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
 ccflags-y := -fpic -fno-builtin -I$(obj)
-asflags-y := -Wa,-march=all
+asflags-y :=
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
 KBSS_SZ = $(shell $(CROSS_COMPILE)size $(obj)/../../../../vmlinux | \
diff --git a/arch/arm/boot/compressed/head-sa1100.S b/arch/arm/boot/compressed/head-sa1100.S
index 6179d94..3115e31 100644
--- a/arch/arm/boot/compressed/head-sa1100.S
+++ b/arch/arm/boot/compressed/head-sa1100.S
@@ -11,6 +11,7 @@
 #include <asm/mach-types.h>
 
 		.section        ".start", "ax"
+		.arch	armv4
 
 __SA1100_start:
 
diff --git a/arch/arm/boot/compressed/head-shark.S b/arch/arm/boot/compressed/head-shark.S
index 089c560..92b5689 100644
--- a/arch/arm/boot/compressed/head-shark.S
+++ b/arch/arm/boot/compressed/head-shark.S
@@ -18,6 +18,7 @@
 	
 		.section	".start", "ax"
 
+		.arch armv4
 		b	__beginning
 	
 __ofw_data:	.long	0				@ the number of memory blocks
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index bc67cbf..a7ae392 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -10,6 +10,7 @@
  */
 #include <linux/linkage.h>
 
+	.arch	armv7-a
 /*
  * Debugging stuff
  *
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 8200dea..140c817 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -13,6 +13,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/node.h>
@@ -42,6 +43,7 @@
 #define MPIDR_LEVEL2_SHIFT 16
 
 struct cputopo_arm cpu_topology[NR_CPUS];
+EXPORT_SYMBOL_GPL(cpu_topology);
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index d197e7f..ac85f16 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -2752,11 +2752,9 @@ func_return	get_new_page
 #ifdef CONFIG_MAC
 
 L(scc_initable_mac):
-	.byte	9,12		/* Reset */
 	.byte	4,0x44		/* x16, 1 stopbit, no parity */
 	.byte	3,0xc0		/* receiver: 8 bpc */
 	.byte	5,0xe2		/* transmitter: 8 bpc, assert dtr/rts */
-	.byte	9,0		/* no interrupts */
 	.byte	10,0		/* NRZ */
 	.byte	11,0x50		/* use baud rate generator */
 	.byte	12,1,13,0	/* 38400 baud */
@@ -2899,6 +2897,7 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 	is_not_mac(L(serial_init_not_mac))
 
 #ifdef SERIAL_DEBUG
+
 /* You may define either or both of these. */
 #define MAC_USE_SCC_A /* Modem port */
 #define MAC_USE_SCC_B /* Printer port */
@@ -2908,9 +2907,21 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 #define mac_scc_cha_b_data_offset	0x4
 #define mac_scc_cha_a_data_offset	0x6
 
+#if defined(MAC_USE_SCC_A) || defined(MAC_USE_SCC_B)
+	movel	%pc@(L(mac_sccbase)),%a0
+	/* Reset SCC device */
+	moveb	#9,%a0@(mac_scc_cha_a_ctrl_offset)
+	moveb	#0xc0,%a0@(mac_scc_cha_a_ctrl_offset)
+	/* Wait for 5 PCLK cycles, which is about 68 CPU cycles */
+	/* 5 / 3.6864 MHz = approx. 1.36 us = 68 / 50 MHz */
+	movel	#35,%d0
+5:
+	subq	#1,%d0
+	jne	5b
+#endif
+
 #ifdef MAC_USE_SCC_A
 	/* Initialize channel A */
-	movel	%pc@(L(mac_sccbase)),%a0
 	lea	%pc@(L(scc_initable_mac)),%a1
 5:	moveb	%a1@+,%d0
 	jmi	6f
@@ -2922,9 +2933,6 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 
 #ifdef MAC_USE_SCC_B
 	/* Initialize channel B */
-#ifndef MAC_USE_SCC_A	/* Load mac_sccbase only if needed */
-	movel	%pc@(L(mac_sccbase)),%a0
-#endif	/* MAC_USE_SCC_A */
 	lea	%pc@(L(scc_initable_mac)),%a1
 7:	moveb	%a1@+,%d0
 	jmi	8f
@@ -2933,6 +2941,7 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 	jra	7b
 8:
 #endif	/* MAC_USE_SCC_B */
+
 #endif	/* SERIAL_DEBUG */
 
 	jra	L(serial_init_done)
@@ -3006,17 +3015,17 @@ func_start	serial_putc,%d0/%d1/%a0/%a1
 
 #ifdef SERIAL_DEBUG
 
-#ifdef MAC_USE_SCC_A
+#if defined(MAC_USE_SCC_A) || defined(MAC_USE_SCC_B)
 	movel	%pc@(L(mac_sccbase)),%a1
+#endif
+
+#ifdef MAC_USE_SCC_A
 3:	btst	#2,%a1@(mac_scc_cha_a_ctrl_offset)
 	jeq	3b
 	moveb	%d0,%a1@(mac_scc_cha_a_data_offset)
 #endif	/* MAC_USE_SCC_A */
 
 #ifdef MAC_USE_SCC_B
-#ifndef MAC_USE_SCC_A	/* Load mac_sccbase only if needed */
-	movel	%pc@(L(mac_sccbase)),%a1
-#endif	/* MAC_USE_SCC_A */
 4:	btst	#2,%a1@(mac_scc_cha_b_ctrl_offset)
 	jeq	4b
 	moveb	%d0,%a1@(mac_scc_cha_b_data_offset)
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index d58fc4e..6afb13a 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -320,7 +320,7 @@ label##_common:							\
  */
 #define STD_EXCEPTION_COMMON_ASYNC(trap, label, hdlr)		  \
 	EXCEPTION_COMMON(trap, label, hdlr, ret_from_except_lite, \
-			 FINISH_NAP;RUNLATCH_ON;DISABLE_INTS)
+			 FINISH_NAP;DISABLE_INTS;RUNLATCH_ON)
 
 /*
  * When the idle code in power4_idle puts the CPU into NAP mode,
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 1c06d29..f9d4812 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -489,7 +489,7 @@ machine_check_common:
 	STD_EXCEPTION_COMMON(0xb00, trap_0b, .unknown_exception)
 	STD_EXCEPTION_COMMON(0xd00, single_step, .single_step_exception)
 	STD_EXCEPTION_COMMON(0xe00, trap_0e, .unknown_exception)
-        STD_EXCEPTION_COMMON(0xe40, emulation_assist, .program_check_exception)
+	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .emulation_assist_interrupt)
         STD_EXCEPTION_COMMON(0xe60, hmi_exception, .unknown_exception)
 	STD_EXCEPTION_COMMON_ASYNC(0xf00, performance_monitor, .performance_monitor_exception)
 	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, .instruction_breakpoint_exception)
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 1f017bb..86cb68e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -162,7 +162,7 @@ notrace unsigned int __check_irq_replay(void)
 	 * in case we also had a rollover while hard disabled
 	 */
 	local_paca->irq_happened &= ~PACA_IRQ_DEC;
-	if (decrementer_check_overflow())
+	if ((happened & PACA_IRQ_DEC) || decrementer_check_overflow())
 		return 0x900;
 
 	/* Finally check if an external interrupt happened */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 1a1f2dd..b1e4ac1 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1221,7 +1221,7 @@ EXPORT_SYMBOL(dump_stack);
 
 #ifdef CONFIG_PPC64
 /* Called with hard IRQs off */
-void __ppc64_runlatch_on(void)
+void notrace __ppc64_runlatch_on(void)
 {
 	struct thread_info *ti = current_thread_info();
 	unsigned long ctrl;
@@ -1234,7 +1234,7 @@ void __ppc64_runlatch_on(void)
 }
 
 /* Called with hard IRQs off */
-void __ppc64_runlatch_off(void)
+void notrace __ppc64_runlatch_off(void)
 {
 	struct thread_info *ti = current_thread_info();
 	unsigned long ctrl;
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 3bb7197..5557044 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1074,6 +1074,16 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
 }
 
+/*
+ * This occurs when running in hypervisor mode on POWER6 or later
+ * and an illegal instruction is encountered.
+ */
+void __kprobes emulation_assist_interrupt(struct pt_regs *regs)
+{
+	regs->msr |= REASON_ILLEGAL;
+	program_check_exception(regs);
+}
+
 void alignment_exception(struct pt_regs *regs)
 {
 	int sig, code, fixed = 0;
diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 8752f79..8a811d9 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -83,7 +83,11 @@ static int pseries_eeh_init(void)
 	ibm_configure_pe		= rtas_token("ibm,configure-pe");
 	ibm_configure_bridge		= rtas_token ("ibm,configure-bridge");
 
-	/* necessary sanity check */
+	/*
+	 * Necessary sanity check. We needn't check "get-config-addr-info"
+	 * and its variant since the old firmware probably support address
+	 * of domain/bus/slot/function for EEH RTAS operations.
+	 */
 	if (ibm_set_eeh_option == RTAS_UNKNOWN_SERVICE) {
 		pr_warning("%s: RTAS service <ibm,set-eeh-option> invalid\n",
 			__func__);
@@ -102,12 +106,6 @@ static int pseries_eeh_init(void)
 		pr_warning("%s: RTAS service <ibm,slot-error-detail> invalid\n",
 			__func__);
 		return -EINVAL;
-	} else if (ibm_get_config_addr_info2 == RTAS_UNKNOWN_SERVICE &&
-		   ibm_get_config_addr_info == RTAS_UNKNOWN_SERVICE) {
-		pr_warning("%s: RTAS service <ibm,get-config-addr-info2> and "
-			"<ibm,get-config-addr-info> invalid\n",
-			__func__);
-		return -EINVAL;
 	} else if (ibm_configure_pe == RTAS_UNKNOWN_SERVICE &&
 		   ibm_configure_bridge == RTAS_UNKNOWN_SERVICE) {
 		pr_warning("%s: RTAS service <ibm,configure-pe> and "
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 7a6f3b3..f2bb9c9 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -160,7 +160,7 @@ identity_mapped:
 	xorq    %rbp, %rbp
 	xorq	%r8,  %r8
 	xorq	%r9,  %r9
-	xorq	%r10, %r9
+	xorq	%r10, %r10
 	xorq	%r11, %r11
 	xorq	%r12, %r12
 	xorq	%r13, %r13
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 3837739..403283d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -447,6 +447,38 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion dm4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dm4 Notebook PC"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion g6 Notebook PC",
+	 .matches = {
+		 DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP 1000 Notebook PC",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP 1000 Notebook PC"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion m4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion m4 Notebook PC"),
+		},
+	},
 	{}
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a382b7c..624a948 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -151,6 +151,7 @@ enum piix_controller_ids {
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
 	ich8_2port_sata_snb,
+	ich8_2port_sata_byt,
 };
 
 struct piix_map_db {
@@ -356,6 +357,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x8d60, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d68, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (BayTrail) */
+	{ 0x8086, 0x0F20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
+	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 
 	{ }	/* terminate list */
 };
@@ -521,6 +525,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
 	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
+	[ich8_2port_sata_byt]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -671,6 +676,15 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
+
+	[ich8_2port_sata_byt] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 23f092d..9e47300 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1599,6 +1599,12 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	qc->tf = *tf;
 	if (cdb)
 		memcpy(qc->cdb, cdb, ATAPI_CDB_LEN);
+
+	/* some SATA bridges need us to indicate data xfer direction */
+	if (tf->protocol == ATAPI_PROT_DMA && (dev->flags & ATA_DFLAG_DMADIR) &&
+	    dma_dir == DMA_FROM_DEVICE)
+		qc->tf.feature |= ATAPI_DMADIR;
+
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
 	qc->dma_dir = dma_dir;
 	if (dma_dir != DMA_NONE) {
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..d3446f6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -161,8 +161,6 @@ static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id);
 static int cciss_open(struct block_device *bdev, fmode_t mode);
 static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode);
 static int cciss_release(struct gendisk *disk, fmode_t mode);
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned int cmd, unsigned long arg);
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg);
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
@@ -229,7 +227,7 @@ static const struct block_device_operations cciss_fops = {
 	.owner = THIS_MODULE,
 	.open = cciss_unlocked_open,
 	.release = cciss_release,
-	.ioctl = do_ioctl,
+	.ioctl = cciss_ioctl,
 	.getgeo = cciss_getgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = cciss_compat_ioctl,
@@ -1140,16 +1138,6 @@ static int cciss_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned cmd, unsigned long arg)
-{
-	int ret;
-	mutex_lock(&cciss_mutex);
-	ret = cciss_ioctl(bdev, mode, cmd, arg);
-	mutex_unlock(&cciss_mutex);
-	return ret;
-}
-
 #ifdef CONFIG_COMPAT
 
 static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
@@ -1176,7 +1164,7 @@ static int cciss_compat_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_REGNEWD:
 	case CCISS_RESCANDISK:
 	case CCISS_GETLUNINFO:
-		return do_ioctl(bdev, mode, cmd, arg);
+		return cciss_ioctl(bdev, mode, cmd, arg);
 
 	case CCISS_PASSTHRU32:
 		return cciss_ioctl32_passthru(bdev, mode, cmd, arg);
@@ -1216,7 +1204,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1258,7 +1246,7 @@ static int cciss_ioctl32_big_passthru(struct block_device *bdev, fmode_t mode,
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1308,11 +1296,14 @@ static int cciss_getpciinfo(ctlr_info_t *h, void __user *argp)
 static int cciss_getintinfo(ctlr_info_t *h, void __user *argp)
 {
 	cciss_coalint_struct intinfo;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	intinfo.delay = readl(&h->cfgtable->HostWrite.CoalIntDelay);
 	intinfo.count = readl(&h->cfgtable->HostWrite.CoalIntCount);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user
 	    (argp, &intinfo, sizeof(cciss_coalint_struct)))
 		return -EFAULT;
@@ -1353,12 +1344,15 @@ static int cciss_setintinfo(ctlr_info_t *h, void __user *argp)
 static int cciss_getnodename(ctlr_info_t *h, void __user *argp)
 {
 	NodeName_type NodeName;
+	unsigned long flags;
 	int i;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	for (i = 0; i < 16; i++)
 		NodeName[i] = readb(&h->cfgtable->ServerName[i]);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, NodeName, sizeof(NodeName_type)))
 		return -EFAULT;
 	return 0;
@@ -1395,10 +1389,13 @@ static int cciss_setnodename(ctlr_info_t *h, void __user *argp)
 static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
 {
 	Heartbeat_type heartbeat;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	heartbeat = readl(&h->cfgtable->HeartBeat);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &heartbeat, sizeof(Heartbeat_type)))
 		return -EFAULT;
 	return 0;
@@ -1407,10 +1404,13 @@ static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
 static int cciss_getbustypes(ctlr_info_t *h, void __user *argp)
 {
 	BusTypes_type BusTypes;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	BusTypes = readl(&h->cfgtable->BusTypes);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &BusTypes, sizeof(BusTypes_type)))
 		return -EFAULT;
 	return 0;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 000d309..aec952f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1393,10 +1393,13 @@ static void dma_tc_handle(struct d40_chan *d40c)
 			return;
 		}
 
-		if (d40_queue_start(d40c) == NULL)
+		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
-		pm_runtime_mark_last_busy(d40c->base->dev);
-		pm_runtime_put_autosuspend(d40c->base->dev);
+
+			pm_runtime_mark_last_busy(d40c->base->dev);
+			pm_runtime_put_autosuspend(d40c->base->dev);
+		}
+
 	}
 
 	d40c->pending_tx++;
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index c798eea..c7a1348 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -981,7 +981,7 @@ EXPORT_SYMBOL(drm_vblank_off);
  */
 void drm_vblank_pre_modeset(struct drm_device *dev, int crtc)
 {
-	/* vblank is not initialized (IRQ not installed ?) */
+	/* vblank is not initialized (IRQ not installed ?), or has been freed */
 	if (!dev->num_crtcs)
 		return;
 	/*
@@ -1003,6 +1003,10 @@ void drm_vblank_post_modeset(struct drm_device *dev, int crtc)
 {
 	unsigned long irqflags;
 
+	/* vblank is not initialized (IRQ not installed ?), or has been freed */
+	if (!dev->num_crtcs)
+		return;
+
 	if (dev->vblank_inmodeset[crtc]) {
 		spin_lock_irqsave(&dev->vbl_lock, irqflags);
 		dev->vblank_disable_allowed = 1;
diff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_display.c
index c3e9a0f..a80d61f 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_display.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_display.c
@@ -1600,6 +1600,19 @@ static void cdv_intel_crtc_destroy(struct drm_crtc *crtc)
 	kfree(psb_intel_crtc);
 }
 
+static void cdv_intel_crtc_disable(struct drm_crtc *crtc)
+{
+	struct gtt_range *gt;
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+
+	if (crtc->fb) {
+		gt = to_psb_fb(crtc->fb)->gtt;
+		psb_gtt_unpin(gt);
+	}
+}
+
 const struct drm_crtc_helper_funcs cdv_intel_helper_funcs = {
 	.dpms = cdv_intel_crtc_dpms,
 	.mode_fixup = cdv_intel_crtc_mode_fixup,
@@ -1607,6 +1620,7 @@ const struct drm_crtc_helper_funcs cdv_intel_helper_funcs = {
 	.mode_set_base = cdv_intel_pipe_set_base,
 	.prepare = cdv_intel_crtc_prepare,
 	.commit = cdv_intel_crtc_commit,
+	.disable = cdv_intel_crtc_disable,
 };
 
 const struct drm_crtc_funcs cdv_intel_crtc_funcs = {
diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 5732b57..71a4b61 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -793,8 +793,8 @@ void psb_modeset_init(struct drm_device *dev)
 	for (i = 0; i < dev_priv->num_pipe; i++)
 		psb_intel_crtc_init(dev, i, mode_dev);
 
-	dev->mode_config.max_width = 2048;
-	dev->mode_config.max_height = 2048;
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
 
 	psb_setup_outputs(dev);
 
diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
index 73e44a8..f408dad 100644
--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -1246,6 +1246,19 @@ void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 	kfree(psb_intel_crtc);
 }
 
+static void psb_intel_crtc_disable(struct drm_crtc *crtc)
+{
+	struct gtt_range *gt;
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+
+	if (crtc->fb) {
+		gt = to_psb_fb(crtc->fb)->gtt;
+		psb_gtt_unpin(gt);
+	}
+}
+
 const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.dpms = psb_intel_crtc_dpms,
 	.mode_fixup = psb_intel_crtc_mode_fixup,
@@ -1253,6 +1266,7 @@ const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.mode_set_base = psb_intel_pipe_set_base,
 	.prepare = psb_intel_crtc_prepare,
 	.commit = psb_intel_crtc_commit,
+	.disable = psb_intel_crtc_disable,
 };
 
 const struct drm_crtc_funcs psb_intel_crtc_funcs = {
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 6d6bf60..d18c49a 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -746,10 +746,10 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
-		.ident = "Hewlett-Packard HP t5740e Thin Client",
+		.ident = "Hewlett-Packard HP t5740",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP t5740e Thin Client"),
+			DMI_MATCH(DMI_PRODUCT_NAME, " t5740"),
 		},
 	},
 	{
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 1af5db5..00c6af5 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1595,11 +1595,14 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 	 * Assume that the preferred modes are
 	 * arranged in priority order.
 	 */
-	intel_ddc_get_modes(connector, intel_sdvo->i2c);
-	if (list_empty(&connector->probed_modes) == false)
-		goto end;
+	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 
-	/* Fetch modes from VBT */
+	/*
+	 * Fetch modes from VBT. For SDVO prefer the VBT mode since some
+	 * SDVO->LVDS transcoders can't cope with the EDID mode. Since
+	 * drm_mode_probed_add adds the mode at the head of the list we add it
+	 * last.
+	 */
 	if (dev_priv->sdvo_lvds_vbt_mode != NULL) {
 		newmode = drm_mode_duplicate(connector->dev,
 					     dev_priv->sdvo_lvds_vbt_mode);
@@ -1611,7 +1614,6 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 		}
 	}
 
-end:
 	list_for_each_entry(newmode, &connector->probed_modes, head) {
 		if (newmode->type & DRM_MODE_TYPE_PREFERRED) {
 			intel_sdvo->sdvo_lvds_fixed_mode =
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 4860c35..4e48f91 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1042,13 +1042,14 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 			else
 				hi_pri_lvl = 5;
 
-			WREG8(0x1fde, 0x06);
-			WREG8(0x1fdf, hi_pri_lvl);
+			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
+			WREG8(MGAREG_CRTCEXT_DATA, hi_pri_lvl);
 		} else {
+			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
 			if (mdev->reg_1e24 >= 0x01)
-				WREG8(0x1fdf, 0x03);
+				WREG8(MGAREG_CRTCEXT_DATA, 0x03);
 			else
-				WREG8(0x1fdf, 0x04);
+				WREG8(MGAREG_CRTCEXT_DATA, 0x04);
 		}
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 74cc710..66ecc38 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -396,6 +396,8 @@ atombios_digital_setup(struct drm_encoder *encoder, int action)
 int
 atombios_get_encoder_mode(struct drm_encoder *encoder)
 {
+	struct drm_device *dev = encoder->dev;
+	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
@@ -421,7 +423,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_HDMIB: /* HDMI-B is basically DL-DVI; analog works fine */
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else if (radeon_connector->use_digital)
 			return ATOM_ENCODER_MODE_DVI;
@@ -432,7 +435,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_HDMIA:
 	default:
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else
 			return ATOM_ENCODER_MODE_DVI;
@@ -446,7 +450,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 		    (dig_connector->dp_sink_type == CONNECTOR_OBJECT_ID_eDP))
 			return ATOM_ENCODER_MODE_DP;
 		else if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-			 radeon_audio)
+			 radeon_audio &&
+			 !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else
 			return ATOM_ENCODER_MODE_DVI;
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index d18b343..7dbb1aa 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3120,6 +3120,12 @@ static int evergreen_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -3264,10 +3270,6 @@ int evergreen_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 137b1f5..8d2a168 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1313,6 +1313,12 @@ static int cayman_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -1441,10 +1447,6 @@ int cayman_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index fb44e7e..fe70204 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3896,6 +3896,12 @@ static int r100_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r100.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -4054,9 +4060,6 @@ int r100_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 97722a3..30ec27a 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1382,6 +1382,12 @@ static int r300_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -1519,9 +1525,6 @@ int r300_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 99137be..1cf55d9 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -265,6 +265,12 @@ static int r420_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -414,10 +420,6 @@ int r420_init(struct radeon_device *rdev)
 	if (r) {
 		return r;
 	}
-	r = radeon_irq_kms_init(rdev);
-	if (r) {
-		return r;
-	}
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index b5cf837..36b7a5c 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -194,6 +194,12 @@ static int r520_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -299,9 +305,6 @@ int r520_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 0c7476d..ffaf3ba 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2401,6 +2401,12 @@ int r600_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -2548,10 +2554,6 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index a464eb5..9ada7ed 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -417,6 +417,12 @@ static int rs400_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -538,9 +544,6 @@ int rs400_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index e95c5e6..d0eea5c 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -899,6 +899,12 @@ static int rs600_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -1026,9 +1032,6 @@ int rs600_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 159b6a4..bcfb0a3 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -628,6 +628,12 @@ static int rs690_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -756,9 +762,6 @@ int rs690_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 5e70fcb..3368c8c 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -386,6 +386,12 @@ static int rv515_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -518,9 +524,6 @@ int rv515_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index b4f51c5..3b8e95a 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -931,6 +931,12 @@ static int rv770_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -1062,10 +1068,6 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index df76c27..97b89b7 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3747,6 +3747,12 @@ static int si_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = si_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -3911,10 +3917,6 @@ int si_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring = &rdev->ring[RADEON_RING_TYPE_GFX_INDEX];
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 4394e7e..5653461 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -332,26 +332,68 @@ static int adm1021_detect(struct i2c_client *client,
 	man_id = i2c_smbus_read_byte_data(client, ADM1021_REG_MAN_ID);
 	dev_id = i2c_smbus_read_byte_data(client, ADM1021_REG_DEV_ID);
 
+	if (man_id < 0 || dev_id < 0)
+		return -ENODEV;
+
 	if (man_id == 0x4d && dev_id == 0x01)
 		type_name = "max1617a";
 	else if (man_id == 0x41) {
 		if ((dev_id & 0xF0) == 0x30)
 			type_name = "adm1023";
-		else
+		else if ((dev_id & 0xF0) == 0x00)
 			type_name = "adm1021";
+		else
+			return -ENODEV;
 	} else if (man_id == 0x49)
 		type_name = "thmc10";
 	else if (man_id == 0x23)
 		type_name = "gl523sm";
 	else if (man_id == 0x54)
 		type_name = "mc1066";
-	/* LM84 Mfr ID in a different place, and it has more unused bits */
-	else if (conv_rate == 0x00
-		 && (config & 0x7F) == 0x00
-		 && (status & 0xAB) == 0x00)
-		type_name = "lm84";
-	else
-		type_name = "max1617";
+	else {
+		int lte, rte, lhi, rhi, llo, rlo;
+
+		/* extra checks for LM84 and MAX1617 to avoid misdetections */
+
+		llo = i2c_smbus_read_byte_data(client, ADM1021_REG_THYST_R(0));
+		rlo = i2c_smbus_read_byte_data(client, ADM1021_REG_THYST_R(1));
+
+		/* fail if any of the additional register reads failed */
+		if (llo < 0 || rlo < 0)
+			return -ENODEV;
+
+		lte = i2c_smbus_read_byte_data(client, ADM1021_REG_TEMP(0));
+		rte = i2c_smbus_read_byte_data(client, ADM1021_REG_TEMP(1));
+		lhi = i2c_smbus_read_byte_data(client, ADM1021_REG_TOS_R(0));
+		rhi = i2c_smbus_read_byte_data(client, ADM1021_REG_TOS_R(1));
+
+		/*
+		 * Fail for negative temperatures and negative high limits.
+		 * This check also catches read errors on the tested registers.
+		 */
+		if ((s8)lte < 0 || (s8)rte < 0 || (s8)lhi < 0 || (s8)rhi < 0)
+			return -ENODEV;
+
+		/* fail if all registers hold the same value */
+		if (lte == rte && lte == lhi && lte == rhi && lte == llo
+		    && lte == rlo)
+			return -ENODEV;
+
+		/*
+		 * LM84 Mfr ID is in a different place,
+		 * and it has more unused bits.
+		 */
+		if (conv_rate == 0x00
+		    && (config & 0x7F) == 0x00
+		    && (status & 0xAB) == 0x00) {
+			type_name = "lm84";
+		} else {
+			/* fail if low limits are larger than high limits */
+			if ((s8)llo > lhi || (s8)rlo > rhi)
+				return -ENODEV;
+			type_name = "max1617";
+		}
+	}
 
 	pr_debug("adm1021: Detected chip %s at adapter %d, address 0x%02x.\n",
 		 type_name, i2c_adapter_id(adapter), client->addr);
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 33fee0a..d3be586 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -531,11 +531,23 @@ retry:
 
 static void iommu_poll_events(struct amd_iommu *iommu)
 {
-	u32 head, tail;
+	u32 head, tail, status;
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu->lock, flags);
 
+	/* enable event interrupts again */
+	do {
+		/*
+		 * Workaround for Erratum ERBT1312
+		 * Clearing the EVT_INT bit may race in the hardware, so read
+		 * it again and make sure it was really cleared
+		 */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		writel(MMIO_STATUS_EVT_INT_MASK,
+		       iommu->mmio_base + MMIO_STATUS_OFFSET);
+	} while (status & MMIO_STATUS_EVT_INT_MASK);
+
 	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
@@ -572,16 +584,25 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
 static void iommu_poll_ppr_log(struct amd_iommu *iommu)
 {
 	unsigned long flags;
-	u32 head, tail;
+	u32 head, tail, status;
 
 	if (iommu->ppr_log == NULL)
 		return;
 
-	/* enable ppr interrupts again */
-	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
-
 	spin_lock_irqsave(&iommu->lock, flags);
 
+	/* enable ppr interrupts again */
+	do {
+		/*
+		 * Workaround for Erratum ERBT1312
+		 * Clearing the PPR_INT bit may race in the hardware, so read
+		 * it again and make sure it was really cleared
+		 */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		writel(MMIO_STATUS_PPR_INT_MASK,
+		       iommu->mmio_base + MMIO_STATUS_OFFSET);
+	} while (status & MMIO_STATUS_PPR_INT_MASK);
+
 	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index c1b1d48..f9addfd 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -99,6 +99,7 @@
 #define PASID_MASK		0x000fffff
 
 /* MMIO status bits */
+#define MMIO_STATUS_EVT_INT_MASK	(1 << 1)
 #define MMIO_STATUS_COM_WAIT_INT_MASK	(1 << 2)
 #define MMIO_STATUS_PPR_INT_MASK	(1 << 6)
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cb781a1..aa58c02 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -413,7 +413,17 @@ static void raid1_end_write_request(struct bio *bio, int error)
 
 		r1_bio->bios[mirror] = NULL;
 		to_put = bio;
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+		/*
+		 * Do not set R1BIO_Uptodate if the current device is
+		 * rebuilding or Faulty. This is because we cannot use
+		 * such device for properly reading the data back (we could
+		 * potentially use it, if the current write would have felt
+		 * before rdev->recovery_offset, but for simplicity we don't
+		 * check this here.
+		 */
+		if (test_bit(In_sync, &conf->mirrors[mirror].rdev->flags) &&
+		    !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags))
+			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(conf->mirrors[mirror].rdev,
@@ -802,17 +812,17 @@ static void allow_barrier(struct r1conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void freeze_array(struct r1conf *conf)
+static void freeze_array(struct r1conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
 	 * go quite.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until nr_pending match nr_queued+1
+	 * wait until nr_pending match nr_queued+extra
 	 * This is called in the context of one normal IO request
 	 * that has failed. Thus any sync request that might be pending
 	 * will be blocked by nr_pending, and we need to wait for
 	 * pending IO requests to complete or be queued for re-try.
-	 * Thus the number queued (nr_queued) plus this request (1)
+	 * Thus the number queued (nr_queued) plus this request (extra)
 	 * must match the number of pending IOs (nr_pending) before
 	 * we continue.
 	 */
@@ -820,7 +830,7 @@ static void freeze_array(struct r1conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 	spin_unlock_irq(&conf->resync_lock);
@@ -1419,8 +1429,8 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * we wait for all outstanding requests to complete.
 		 */
 		synchronize_sched();
-		raise_barrier(conf);
-		lower_barrier(conf);
+		freeze_array(conf, 0);
+		unfreeze_array(conf);
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
@@ -1468,11 +1478,11 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			 */
 			struct md_rdev *repl =
 				conf->mirrors[conf->raid_disks + number].rdev;
-			raise_barrier(conf);
+			freeze_array(conf, 0);
 			clear_bit(Replacement, &repl->flags);
 			p->rdev = repl;
 			conf->mirrors[conf->raid_disks + number].rdev = NULL;
-			lower_barrier(conf);
+			unfreeze_array(conf);
 			clear_bit(WantReplacement, &rdev->flags);
 		} else
 			clear_bit(WantReplacement, &rdev->flags);
@@ -2089,7 +2099,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * frozen
 	 */
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio->read_disk,
 			       r1_bio->sector, r1_bio->sectors);
 		unfreeze_array(conf);
@@ -2852,7 +2862,7 @@ static int raid1_reshape(struct mddev *mddev)
 		return -ENOMEM;
 	}
 
-	raise_barrier(conf);
+	freeze_array(conf, 0);
 
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
@@ -2884,7 +2894,7 @@ static int raid1_reshape(struct mddev *mddev)
 	mddev->delta_disks = 0;
 
 	conf->last_used = 0; /* just make sure it is in-range */
-	lower_barrier(conf);
+	unfreeze_array(conf);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e97d046..e76227e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -461,7 +461,17 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		sector_t first_bad;
 		int bad_sectors;
 
-		set_bit(R10BIO_Uptodate, &r10_bio->state);
+		/*
+		 * Do not set R10BIO_Uptodate if the current device is
+		 * rebuilding or Faulty. This is because we cannot use
+		 * such device for properly reading the data back (we could
+		 * potentially use it, if the current write would have felt
+		 * before rdev->recovery_offset, but for simplicity we don't
+		 * check this here.
+		 */
+		if (test_bit(In_sync, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags))
+			set_bit(R10BIO_Uptodate, &r10_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(rdev,
@@ -985,17 +995,17 @@ static void allow_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void freeze_array(struct r10conf *conf)
+static void freeze_array(struct r10conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
 	 * go quiet.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until nr_pending match nr_queued+1
+	 * wait until nr_pending match nr_queued+extra
 	 * This is called in the context of one normal IO request
 	 * that has failed. Thus any sync request that might be pending
 	 * will be blocked by nr_pending, and we need to wait for
 	 * pending IO requests to complete or be queued for re-try.
-	 * Thus the number queued (nr_queued) plus this request (1)
+	 * Thus the number queued (nr_queued) plus this request (extra)
 	 * must match the number of pending IOs (nr_pending) before
 	 * we continue.
 	 */
@@ -1003,7 +1013,7 @@ static void freeze_array(struct r10conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 
@@ -1705,8 +1715,8 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * we wait for all outstanding requests to complete.
 		 */
 		synchronize_sched();
-		raise_barrier(conf, 0);
-		lower_barrier(conf);
+		freeze_array(conf, 0);
+		unfreeze_array(conf);
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
@@ -2499,7 +2509,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	r10_bio->devs[slot].bio = NULL;
 
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
 	} else
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 99d4d07..8a0b948 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1631,6 +1631,9 @@ static int tg3_poll_fw(struct tg3 *tp)
 	int i;
 	u32 val;
 
+	if (tg3_flag(tp, NO_FWARE_REPORTED))
+		return 0;
+
 	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906) {
 		/* Wait up to 20ms for init done. */
 		for (i = 0; i < 200; i++) {
@@ -8572,6 +8575,14 @@ static void tg3_rss_write_indir_tbl(struct tg3 *tp)
 	}
 }
 
+static inline u32 tg3_lso_rd_dma_workaround_bit(struct tg3 *tp)
+{
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719)
+		return TG3_LSO_RD_DMA_TX_LENGTH_WA_5719;
+	else
+		return TG3_LSO_RD_DMA_TX_LENGTH_WA_5720;
+}
+
 /* tp->lock is held. */
 static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 {
@@ -9208,6 +9219,20 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 	tw32_f(RDMAC_MODE, rdmac_mode);
 	udelay(40);
 
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719 ||
+	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5720) {
+		for (i = 0; i < TG3_NUM_RDMA_CHANNELS; i++) {
+			if (tr32(TG3_RDMA_LENGTH + (i << 2)) > TG3_MAX_MTU(tp))
+				break;
+		}
+		if (i < TG3_NUM_RDMA_CHANNELS) {
+			val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
+			val |= tg3_lso_rd_dma_workaround_bit(tp);
+			tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
+			tg3_flag_set(tp, 5719_5720_RDMA_BUG);
+		}
+	}
+
 	tw32(RCVDCC_MODE, RCVDCC_MODE_ENABLE | RCVDCC_MODE_ATTN_ENABLE);
 	if (!tg3_flag(tp, 5705_PLUS))
 		tw32(MBFREE_MODE, MBFREE_MODE_ENABLE);
@@ -9429,6 +9454,13 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
  */
 static int tg3_init_hw(struct tg3 *tp, int reset_phy)
 {
+	/* Chip may have been just powered on. If so, the boot code may still
+	 * be running initialization. Wait for it to finish to avoid races in
+	 * accessing the hardware.
+	 */
+	tg3_enable_register_access(tp);
+	tg3_poll_fw(tp);
+
 	tg3_switch_clocks(tp);
 
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
@@ -9463,6 +9495,16 @@ static void tg3_periodic_fetch_stats(struct tg3 *tp)
 	TG3_STAT_ADD32(&sp->tx_ucast_packets, MAC_TX_STATS_UCAST);
 	TG3_STAT_ADD32(&sp->tx_mcast_packets, MAC_TX_STATS_MCAST);
 	TG3_STAT_ADD32(&sp->tx_bcast_packets, MAC_TX_STATS_BCAST);
+	if (unlikely(tg3_flag(tp, 5719_5720_RDMA_BUG) &&
+		     (sp->tx_ucast_packets.low + sp->tx_mcast_packets.low +
+		      sp->tx_bcast_packets.low) > TG3_NUM_RDMA_CHANNELS)) {
+		u32 val;
+
+		val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
+		val &= ~tg3_lso_rd_dma_workaround_bit(tp);
+		tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
+		tg3_flag_clear(tp, 5719_5720_RDMA_BUG);
+	}
 
 	TG3_STAT_ADD32(&sp->rx_octets, MAC_RX_STATS_OCTETS);
 	TG3_STAT_ADD32(&sp->rx_fragments, MAC_RX_STATS_FRAGMENTS);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 93865f8..622bbaf 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -1376,7 +1376,12 @@
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL	0x00004910
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_BD_4K	 0x00030000
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_LSO_4K	 0x000c0000
-/* 0x4914 --> 0x4c00 unused */
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5719	 0x02000000
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5720	 0x00200000
+/* 0x4914 --> 0x4be0 unused */
+
+#define TG3_NUM_RDMA_CHANNELS		4
+#define TG3_RDMA_LENGTH			0x00004be0
 
 /* Write DMA control registers */
 #define WDMAC_MODE			0x00004c00
@@ -2920,6 +2925,7 @@ enum TG3_FLAGS {
 	TG3_FLAG_L1PLLPD_EN,
 	TG3_FLAG_APE_HAS_NCSI,
 	TG3_FLAG_4K_FIFO_LIMIT,
+	TG3_FLAG_5719_5720_RDMA_BUG,
 	TG3_FLAG_RESET_TASK_PENDING,
 	TG3_FLAG_5705_PLUS,
 	TG3_FLAG_IS_5788,
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index e507e78..3b8c930 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -89,13 +89,17 @@ config ATH9K_MAC_DEBUG
 	  This option enables collection of statistics for Rx/Tx status
 	  data and some other MAC related statistics
 
-config ATH9K_RATE_CONTROL
+config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
-	default y
+	default n
 	---help---
 	  Say Y, if you want to use the ath9k specific rate control
-	  module instead of minstrel_ht.
+	  module instead of minstrel_ht. Be warned that there are various
+	  issues with the ath9k RC and minstrel is a more robust algorithm.
+	  Note that even if this option is selected, "ath9k_rate_control"
+	  has to be passed to mac80211 using the module parameter,
+	  ieee80211_default_rc_algo.
 
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 3f0b8472..04b51c5 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -6,7 +6,7 @@ ath9k-y +=	beacon.o \
 		xmit.o
 
 ath9k-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += mci.o
-ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
+ath9k-$(CONFIG_ATH9K_LEGACY_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index bad8cd1..4e2a52c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -777,11 +777,11 @@ static const u32 ar9300Common_rx_gain_table_2p2[][2] = {
 	{0x0000a074, 0x00000000},
 	{0x0000a078, 0x00000000},
 	{0x0000a07c, 0x00000000},
-	{0x0000a080, 0x1a1a1a1a},
-	{0x0000a084, 0x1a1a1a1a},
-	{0x0000a088, 0x1a1a1a1a},
-	{0x0000a08c, 0x1a1a1a1a},
-	{0x0000a090, 0x171a1a1a},
+	{0x0000a080, 0x22222229},
+	{0x0000a084, 0x1d1d1d1d},
+	{0x0000a088, 0x1d1d1d1d},
+	{0x0000a08c, 0x1d1d1d1d},
+	{0x0000a090, 0x171d1d1d},
 	{0x0000a094, 0x11111717},
 	{0x0000a098, 0x00030311},
 	{0x0000a09c, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index dee9e09..9aa005e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -696,8 +696,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->iface_combinations = &if_comb;
 	hw->wiphy->n_iface_combinations = 1;
 
-	if (AR_SREV_5416(sc->sc_ah))
-		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
@@ -721,10 +720,6 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	sc->ant_rx = hw->wiphy->available_antennas_rx;
 	sc->ant_tx = hw->wiphy->available_antennas_tx;
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
-	hw->rate_control_algorithm = "ath9k_rate_control";
-#endif
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&sc->sbands[IEEE80211_BAND_2GHZ];
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 75f8e9b..12cf122 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -219,7 +219,7 @@ struct ath_rate_priv {
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
 };
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
+#ifdef CONFIG_ATH9K_LEGACY_RATE_CONTROL
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
 #else
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f8fd420..5b349da 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2451,7 +2451,7 @@ static void b43_request_firmware(struct work_struct *work)
 	for (i = 0; i < B43_NR_FWTYPES; i++) {
 		errmsg = ctx->errors[i];
 		if (strlen(errmsg))
-			b43err(dev->wl, errmsg);
+			b43err(dev->wl, "%s", errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
 	goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index b4f0661..dff75ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -763,7 +763,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
 
-				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+				if (memcmp(&lq, &zero_lq, sizeof(lq)))
 					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 526702d..b88afc7 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -36,7 +36,7 @@
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
-#include <linux/tcp.h>
+#include <net/tcp.h>
 #include <linux/udp.h>
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
@@ -491,6 +491,16 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned int len = skb_headlen(skb);
 	unsigned long flags;
 
+	/* If skb->len is too big for wire format, drop skb and alert
+	 * user about misconfiguration.
+	 */
+	if (unlikely(skb->len > XEN_NETIF_MAX_TX_SIZE)) {
+		net_alert_ratelimited(
+			"xennet: skb->len = %u, too big for wire format\n",
+			skb->len);
+		goto drop;
+	}
+
 	frags += DIV_ROUND_UP(offset + len, PAGE_SIZE);
 	if (unlikely(frags > MAX_SKB_FRAGS + 1)) {
 		printk(KERN_ALERT "xennet: skb rides the rocket: %d frags\n",
@@ -1039,7 +1049,8 @@ err:
 
 static int xennet_change_mtu(struct net_device *dev, int mtu)
 {
-	int max = xennet_can_sg(dev) ? 65535 - ETH_HLEN : ETH_DATA_LEN;
+	int max = xennet_can_sg(dev) ?
+		XEN_NETIF_MAX_TX_SIZE - MAX_TCP_HEADER : ETH_DATA_LEN;
 
 	if (mtu > max)
 		return -EINVAL;
@@ -1343,6 +1354,8 @@ static struct net_device * __devinit xennet_create_dev(struct xenbus_device *dev
 	SET_ETHTOOL_OPS(netdev, &xennet_ethtool_ops);
 	SET_NETDEV_DEV(netdev, &dev->dev);
 
+	netif_set_gso_max_size(netdev, XEN_NETIF_MAX_TX_SIZE - MAX_TCP_HEADER);
+
 	np->netdev = netdev;
 
 	netif_carrier_off(netdev);
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 8b5610d..aa232de 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8662,6 +8662,13 @@ static int __must_check __init get_thinkpad_model_data(
 		tp->model_str = kstrdup(s, GFP_KERNEL);
 		if (!tp->model_str)
 			return -ENOMEM;
+	} else {
+		s = dmi_get_system_info(DMI_BIOS_VENDOR);
+		if (s && !(strnicmp(s, "Lenovo", 6))) {
+			tp->model_str = kstrdup(s, GFP_KERNEL);
+			if (!tp->model_str)
+				return -ENOMEM;
+		}
 	}
 
 	s = dmi_get_system_info(DMI_PRODUCT_NAME);
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 795f75a..dc568f7 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -675,7 +675,7 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_STATUS);
+							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 		}
 
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 9277d94..1789a25 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -523,6 +523,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index fae7885..3530c2b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1537,10 +1537,19 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 
 	for (epnum = 0; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
 		dep = dwc->eps[epnum];
-		dwc3_free_trb_pool(dep);
-
-		if (epnum != 0 && epnum != 1)
+		/*
+		 * Physical endpoints 0 and 1 are special; they form the
+		 * bi-directional USB endpoint 0.
+		 *
+		 * For those two physical endpoints, we don't allocate a TRB
+		 * pool nor do we add them the endpoints list. Due to that, we
+		 * shouldn't do these two operations otherwise we would end up
+		 * with all sorts of bugs when removing dwc3.ko.
+		 */
+		if (epnum != 0 && epnum != 1) {
+			dwc3_free_trb_pool(dep);
 			list_del(&dep->endpoint.ep_list);
+		}
 
 		kfree(dep);
 	}
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index ccc9f70..33182c6 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -236,7 +236,7 @@ static inline unsigned char tt_start_uframe(struct ehci_hcd *ehci, __hc32 mask)
 }
 
 static const unsigned char
-max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 125, 25 };
+max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 30, 0 };
 
 /* carryover low/fullspeed bandwidth that crosses uframe boundries */
 static inline void carryover_tt_bandwidth(unsigned short tt_usecs[8])
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 90ce33b..0618f25 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1847,6 +1847,9 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	if (!xhci->rh_bw)
+		goto no_bw;
+
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
 	for (i = 0; i < num_ports; i++) {
 		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
@@ -1865,6 +1868,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		}
 	}
 
+no_bw:
 	xhci->num_usb2_ports = 0;
 	xhci->num_usb3_ports = 0;
 	xhci->num_active_eps = 0;
@@ -2276,6 +2280,9 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	u32 page_size, temp;
 	int i;
 
+	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
+	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
+
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
 	xhci_dbg(xhci, "Supported page size register = 0x%x\n", page_size);
 	for (i = 0; i < 16; i++) {
@@ -2354,7 +2361,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, 1, TYPE_COMMAND, flags);
 	if (!xhci->cmd_ring)
 		goto fail;
-	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
 	xhci_dbg(xhci, "Allocated command ring at %p\n", xhci->cmd_ring);
 	xhci_dbg(xhci, "First segment DMA is 0x%llx\n",
 			(unsigned long long)xhci->cmd_ring->first_seg->dma);
@@ -2465,8 +2471,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	if (xhci_setup_port_arrays(xhci, flags))
 		goto fail;
 
-	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
-
 	/* Enable USB 3.0 device notifications for function remote wake, which
 	 * is necessary for allowing USB 3.0 devices to do remote wakeup from
 	 * U3 (device suspend).
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 23a0091..bd96077 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -947,6 +947,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
+	bool			comp_timer_running = false;
 
 	/* Wait a bit if either of the roothubs need to settle from the
 	 * transition into bus suspend.
@@ -984,6 +985,13 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
 	/* If restore operation fails, re-initialize the HC during resume */
 	if ((temp & STS_SRE) || hibernated) {
+
+		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+				!(xhci_all_ports_seen_u0(xhci))) {
+			del_timer_sync(&xhci->comp_mode_recovery_timer);
+			xhci_dbg(xhci, "Compliance Mode Recovery Timer deleted!\n");
+		}
+
 		/* Let the USB core know _both_ roothubs lost power. */
 		usb_root_hub_lost_power(xhci->main_hcd->self.root_hub);
 		usb_root_hub_lost_power(xhci->shared_hcd->self.root_hub);
@@ -1026,6 +1034,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		retval = xhci_init(hcd->primary_hcd);
 		if (retval)
 			return retval;
+		comp_timer_running = true;
+
 		xhci_dbg(xhci, "Start the primary HCD\n");
 		retval = xhci_run(hcd->primary_hcd);
 		if (!retval) {
@@ -1067,7 +1077,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	 * to suffer the Compliance Mode issue again. It doesn't matter if
 	 * ports have entered previously to U0 before system's suspension.
 	 */
-	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+	if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) && !comp_timer_running)
 		compliance_mode_recovery_timer_init(xhci);
 
 	/* Re-enable port polling. */
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 15bd068..f1173df 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -49,7 +49,7 @@ static bool debug;
 #define DRIVER_NAME "ark3116"
 
 /* usb timeout of 1 second */
-#define ARK_TIMEOUT (1*HZ)
+#define ARK_TIMEOUT 1000
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x6547, 0x0232) },
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index dec5b2f..83a9b0e 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -70,6 +70,7 @@ static const struct usb_device_id id_table_earthmate[] = {
 static const struct usb_device_id id_table_cyphidcomrs232[] = {
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
+	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ }						/* Terminating entry */
 };
 
@@ -83,6 +84,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB_LT20) },
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
+	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ USB_DEVICE(VENDOR_ID_DAZZLE, PRODUCT_ID_CA42) },
 	{ }						/* Terminating entry */
 };
@@ -235,6 +237,12 @@ static struct usb_serial_driver * const serial_drivers[] = {
  * Cypress serial helper functions
  *****************************************************************************/
 
+/* FRWD Dongle hidcom needs to skip reset and speed checks */
+static inline bool is_frwd(struct usb_device *dev)
+{
+	return ((le16_to_cpu(dev->descriptor.idVendor) == VENDOR_ID_FRWD) &&
+		(le16_to_cpu(dev->descriptor.idProduct) == PRODUCT_ID_CYPHIDCOM_FRWD));
+}
 
 static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 {
@@ -244,6 +252,10 @@ static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 	if (unstable_bauds)
 		return new_rate;
 
+	/* FRWD Dongle uses 115200 bps */
+	if (is_frwd(port->serial->dev))
+		return new_rate;
+
 	/*
 	 * The general purpose firmware for the Cypress M8 allows for
 	 * a maximum speed of 57600bps (I have no idea whether DeLorme
@@ -452,7 +464,11 @@ static int generic_startup(struct usb_serial *serial)
 		return -ENOMEM;
 	}
 
-	usb_reset_configuration(serial->dev);
+	/* Skip reset for FRWD device. It is a workaound:
+	   device hangs if it receives SET_CONFIGURE in Configured
+	   state. */
+	if (!is_frwd(serial->dev))
+		usb_reset_configuration(serial->dev);
 
 	priv->cmd_ctrl = 0;
 	priv->line_control = 0;
diff --git a/drivers/usb/serial/cypress_m8.h b/drivers/usb/serial/cypress_m8.h
index 67cf608..b461311 100644
--- a/drivers/usb/serial/cypress_m8.h
+++ b/drivers/usb/serial/cypress_m8.h
@@ -24,6 +24,10 @@
 #define VENDOR_ID_CYPRESS		0x04b4
 #define PRODUCT_ID_CYPHIDCOM		0x5500
 
+/* FRWD Dongle - a GPS sports watch */
+#define VENDOR_ID_FRWD			0x6737
+#define PRODUCT_ID_CYPHIDCOM_FRWD	0x0001
+
 /* Powercom UPS, chip CY7C63723 */
 #define VENDOR_ID_POWERCOM		0x0d9f
 #define PRODUCT_ID_UPS			0x0002
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 45e80a7..3dbec15 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2137,7 +2137,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
 	cflag = termios->c_cflag;
 
-	if (old_termios == 0)
+	if (!old_termios)
 		goto no_skip;
 
 	if (old_termios->c_cflag == termios->c_cflag
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 22b1eb5..3e7980a 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -308,7 +308,7 @@ static int bulk_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 	    usb_bulk_msg(serial->dev,
 			 usb_sndbulkpipe(serial->dev,
 					 port->bulk_out_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
@@ -328,7 +328,7 @@ static int read_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 	    usb_bulk_msg(serial->dev,
 			 usb_rcvbulkpipe(serial->dev,
 					 port->bulk_in_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index a1b9924..2d35ad4 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1670,7 +1670,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	d_details = s_priv->device_details;
 	device_port = port->number - port->serial->minor;
 
-	outcont_urb = d_details->outcont_endpoints[port->number];
+	outcont_urb = d_details->outcont_endpoints[device_port];
 	this_urb = p_priv->outcont_urb;
 
 	dbg("%s - endpoint %d", __func__, usb_pipeendpoint(this_urb->pipe));
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index a07dd3c..614ad93 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -44,7 +44,7 @@
 #define DRIVER_DESC "Moschip USB Serial Driver"
 
 /* default urb timeout */
-#define MOS_WDR_TIMEOUT	(HZ * 5)
+#define MOS_WDR_TIMEOUT	5000
 
 #define MOS_MAX_PORT	0x02
 #define MOS_WRITE	0x0E
@@ -234,11 +234,22 @@ static int read_mos_reg(struct usb_serial *serial, unsigned int serial_portnum,
 	__u8 requesttype = (__u8)0xc0;
 	__u16 index = get_reg_index(reg);
 	__u16 value = get_reg_value(reg, serial_portnum);
-	int status = usb_control_msg(usbdev, pipe, request, requesttype, value,
-				     index, data, 1, MOS_WDR_TIMEOUT);
-	if (status < 0)
+	u8 *buf;
+	int status;
+
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	status = usb_control_msg(usbdev, pipe, request, requesttype, value,
+				     index, buf, 1, MOS_WDR_TIMEOUT);
+	if (status == 1)
+		*data = *buf;
+	else if (status < 0)
 		dev_err(&usbdev->dev,
 			"mos7720: usb_control_msg() failed: %d", status);
+	kfree(buf);
+
 	return status;
 }
 
@@ -1684,7 +1695,7 @@ static void change_port_settings(struct tty_struct *tty,
 		mos7720_port->shadowMCR |= (UART_MCR_XONANY);
 		/* To set hardware flow control to the specified *
 		 * serial port, in SP1/2_CONTROL_REG             */
-		if (port->number)
+		if (port_number)
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x01);
 		else
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x02);
@@ -2088,7 +2099,7 @@ static int mos7720_startup(struct usb_serial *serial)
 
 	/* setting configuration feature to one */
 	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5*HZ);
+			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
 
 	/* start the interrupt urb */
 	ret_val = usb_submit_urb(serial->port[0]->interrupt_in_urb, GFP_KERNEL);
@@ -2133,7 +2144,7 @@ static void mos7720_release(struct usb_serial *serial)
 		/* wait for synchronous usb calls to return */
 		if (mos_parport->msg_pending)
 			wait_for_completion_timeout(&mos_parport->syncmsg_compl,
-						    MOS_WDR_TIMEOUT);
+					    msecs_to_jiffies(MOS_WDR_TIMEOUT));
 
 		parport_remove_port(mos_parport->pp);
 		usb_set_serial_data(serial, NULL);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 2727955..dada37f 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2342,13 +2342,21 @@ static int mos7840_ioctl(struct tty_struct *tty,
 static int mos7810_check(struct usb_serial *serial)
 {
 	int i, pass_count = 0;
+	u8 *buf;
 	__u16 data = 0, mcr_data = 0;
 	__u16 test_pattern = 0x55AA;
+	int res;
+
+	buf = kmalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (!buf)
+		return 0;	/* failed to identify 7810 */
 
 	/* Store MCR setting */
-	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 		MCS_RDREQ, MCS_RD_RTYPE, 0x0300, MODEM_CONTROL_REGISTER,
-		&mcr_data, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		buf, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+	if (res == VENDOR_READ_LENGTH)
+		mcr_data = *buf;
 
 	for (i = 0; i < 16; i++) {
 		/* Send the 1-bit test pattern out to MCS7810 test pin */
@@ -2358,9 +2366,12 @@ static int mos7810_check(struct usb_serial *serial)
 			MODEM_CONTROL_REGISTER, NULL, 0, MOS_WDR_TIMEOUT);
 
 		/* Read the test pattern back */
-		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
-			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		res = usb_control_msg(serial->dev,
+				usb_rcvctrlpipe(serial->dev, 0), MCS_RDREQ,
+				MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
+				VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		if (res == VENDOR_READ_LENGTH)
+			data = *buf;
 
 		/* If this is a MCS7810 device, both test patterns must match */
 		if (((test_pattern >> i) ^ (~data >> 1)) & 0x0001)
@@ -2374,6 +2385,8 @@ static int mos7810_check(struct usb_serial *serial)
 		MCS_WR_RTYPE, 0x0300 | mcr_data, MODEM_CONTROL_REGISTER, NULL,
 		0, MOS_WDR_TIMEOUT);
 
+	kfree(buf);
+
 	if (pass_count == 16)
 		return 1;
 
@@ -2383,11 +2396,17 @@ static int mos7810_check(struct usb_serial *serial)
 static int mos7840_calc_num_ports(struct usb_serial *serial)
 {
 	__u16 data = 0x00;
+	u8 *buf;
 	int mos7840_num_ports;
 
-	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-		MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
-		VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+	buf = kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (buf) {
+		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
+			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		data = *buf;
+		kfree(buf);
+	}
 
 	if (serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7810 ||
 		serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7820) {
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 38ea4b7..ccd2d11 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -593,6 +593,8 @@ static const struct usb_device_id option_ids[] = {
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x14ac, 0xff, 0xff, 0xff),	/* Huawei E1820 */
+		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0xff, 0xff) },
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 6fe8d0e..5150a27 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -258,7 +258,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */
 
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
 	cflag = tty->termios->c_cflag;
@@ -267,7 +267,8 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
 		/* Report back no change occurred */
-		*tty->termios = *old_termios;
+		if (old_termios)
+			*tty->termios = *old_termios;
 		return;
 	}
 
@@ -407,7 +408,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	control = priv->line_control;
 	if ((cflag & CBAUD) == B0)
 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	else if ((old_termios->c_cflag & CBAUD) == B0)
+	else if (old_termios && (old_termios->c_cflag & CBAUD) == B0)
 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
 	if (control != priv->line_control) {
 		control = priv->line_control;
@@ -466,7 +467,6 @@ static void pl2303_close(struct usb_serial_port *port)
 
 static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	int result;
@@ -482,7 +482,7 @@ static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		pl2303_set_termios(tty, port, &tmp_termios);
+		pl2303_set_termios(tty, port, NULL);
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (result) {
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 4302733..5fd9122 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -115,6 +115,8 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x1199, 0x9019)},	/* Sierra Wireless Gobi 3000 Modem device */
 	{USB_DEVICE(0x12D1, 0x14F0)},	/* Sony Gobi 3000 QDL */
 	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
+	{USB_DEVICE(0x0AF0, 0x8120)},	/* Option GTM681W */
+
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 66a4871..10760f2 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -329,7 +329,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
-	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
 	int baud;
@@ -338,15 +337,15 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 
 
 	/* check that they really want us to change something */
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
 	/* set DTR/RTS active */
 	spin_lock_irqsave(&priv->lock, flags);
 	control = priv->line_control;
-	if ((old_cflag & CBAUD) == B0) {
+	if (old_termios && (old_termios->c_cflag & CBAUD) == B0) {
 		priv->line_control |= MCR_DTR;
-		if (!(old_cflag & CRTSCTS))
+		if (!(old_termios->c_cflag & CRTSCTS))
 			priv->line_control |= MCR_RTS;
 	}
 	if (control != priv->line_control) {
@@ -436,7 +435,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
  * status of the device. */
 static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int ret;
@@ -457,7 +455,7 @@ static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		spcp8x5_set_termios(tty, port, &tmp_termios);
+		spcp8x5_set_termios(tty, port, NULL);
 
 	spcp8x5_get_msr(serial->dev, &status, priv->type);
 
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index f253c91..4b53336 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -570,10 +570,19 @@ static int treo_attach(struct usb_serial *serial)
 	*/
 #define COPY_PORT(dest, src)						\
 	do { \
+		int i;							\
+									\
+		for (i = 0; i < ARRAY_SIZE(src->read_urbs); ++i) {	\
+			dest->read_urbs[i] = src->read_urbs[i];		\
+			dest->read_urbs[i]->context = dest;		\
+			dest->bulk_in_buffers[i] = src->bulk_in_buffers[i]; \
+		}							\
 		dest->read_urb = src->read_urb;				\
 		dest->bulk_in_endpointAddress = src->bulk_in_endpointAddress;\
 		dest->bulk_in_buffer = src->bulk_in_buffer;		\
+		dest->bulk_in_size = src->bulk_in_size;			\
 		dest->interrupt_in_urb = src->interrupt_in_urb;		\
+		dest->interrupt_in_urb->context = dest;			\
 		dest->interrupt_in_endpointAddress = \
 					src->interrupt_in_endpointAddress;\
 		dest->interrupt_in_buffer = src->interrupt_in_buffer;	\
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index b65ac03..65e093e 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -727,7 +727,7 @@ static void firm_setup_port(struct tty_struct *tty)
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	port_settings.port = port->number + 1;
+	port_settings.port = port->number - port->serial->minor + 1;
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 99c5345..b5b559a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1267,7 +1267,7 @@ static void __xen_evtchn_do_upcall(void)
 {
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
-	int i;
+	int i, irq;
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
@@ -1275,6 +1275,8 @@ static void __xen_evtchn_do_upcall(void)
 
 	do {
 		unsigned long pending_words;
+		unsigned long pending_bits;
+		struct irq_desc *desc;
 
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1285,6 +1287,17 @@ static void __xen_evtchn_do_upcall(void)
 		/* Clear master flag /before/ clearing selector flag. */
 		wmb();
 #endif
+		if ((irq = per_cpu(virq_to_irq, cpu)[VIRQ_TIMER]) != -1) {
+			int evtchn = evtchn_from_irq(irq);
+			word_idx = evtchn / BITS_PER_LONG;
+			pending_bits = evtchn % BITS_PER_LONG;
+			if (active_evtchns(cpu, s, word_idx) & (1ULL << pending_bits)) {
+				desc = irq_to_desc(irq);
+				if (desc)
+					generic_handle_irq_desc(irq, desc);
+			}
+		}
+
 		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
 
 		start_word_idx = __this_cpu_read(current_word_idx);
@@ -1293,7 +1306,6 @@ static void __xen_evtchn_do_upcall(void)
 		word_idx = start_word_idx;
 
 		for (i = 0; pending_words != 0; i++) {
-			unsigned long pending_bits;
 			unsigned long words;
 
 			words = MASK_LSBS(pending_words, word_idx);
@@ -1322,8 +1334,7 @@ static void __xen_evtchn_do_upcall(void)
 
 			do {
 				unsigned long bits;
-				int port, irq;
-				struct irq_desc *desc;
+				int port;
 
 				bits = MASK_LSBS(pending_bits, bit_idx);
 
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 80576d05..bb5fb3d 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -191,27 +191,23 @@ void ceph_count_locks(struct inode *inode, int *fcntl_count, int *flock_count)
 }
 
 /**
- * Encode the flock and fcntl locks for the given inode into the pagelist.
- * Format is: #fcntl locks, sequential fcntl locks, #flock locks,
- * sequential flock locks.
- * Must be called with lock_flocks() already held.
- * If we encounter more of a specific lock type than expected,
- * we return the value 1.
+ * Encode the flock and fcntl locks for the given inode into the ceph_filelock
+ * array. Must be called with lock_flocks() already held.
+ * If we encounter more of a specific lock type than expected, return -ENOSPC.
  */
-int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
-		      int num_fcntl_locks, int num_flock_locks)
+int ceph_encode_locks_to_buffer(struct inode *inode,
+				struct ceph_filelock *flocks,
+				int num_fcntl_locks, int num_flock_locks)
 {
 	struct file_lock *lock;
-	struct ceph_filelock cephlock;
 	int err = 0;
 	int seen_fcntl = 0;
 	int seen_flock = 0;
+	int l = 0;
 
 	dout("encoding %d flock and %d fcntl locks", num_flock_locks,
 	     num_fcntl_locks);
-	err = ceph_pagelist_append(pagelist, &num_fcntl_locks, sizeof(u32));
-	if (err)
-		goto fail;
+
 	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
 		if (lock->fl_flags & FL_POSIX) {
 			++seen_fcntl;
@@ -219,19 +215,12 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
 				err = -ENOSPC;
 				goto fail;
 			}
-			err = lock_to_ceph_filelock(lock, &cephlock);
+			err = lock_to_ceph_filelock(lock, &flocks[l]);
 			if (err)
 				goto fail;
-			err = ceph_pagelist_append(pagelist, &cephlock,
-					   sizeof(struct ceph_filelock));
+			++l;
 		}
-		if (err)
-			goto fail;
 	}
-
-	err = ceph_pagelist_append(pagelist, &num_flock_locks, sizeof(u32));
-	if (err)
-		goto fail;
 	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
 		if (lock->fl_flags & FL_FLOCK) {
 			++seen_flock;
@@ -239,19 +228,51 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
 				err = -ENOSPC;
 				goto fail;
 			}
-			err = lock_to_ceph_filelock(lock, &cephlock);
+			err = lock_to_ceph_filelock(lock, &flocks[l]);
 			if (err)
 				goto fail;
-			err = ceph_pagelist_append(pagelist, &cephlock,
-					   sizeof(struct ceph_filelock));
+			++l;
 		}
-		if (err)
-			goto fail;
 	}
 fail:
 	return err;
 }
 
+/**
+ * Copy the encoded flock and fcntl locks into the pagelist.
+ * Format is: #fcntl locks, sequential fcntl locks, #flock locks,
+ * sequential flock locks.
+ * Returns zero on success.
+ */
+int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
+			   struct ceph_pagelist *pagelist,
+			   int num_fcntl_locks, int num_flock_locks)
+{
+	int err = 0;
+	__le32 nlocks;
+
+	nlocks = cpu_to_le32(num_fcntl_locks);
+	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
+	if (err)
+		goto out_fail;
+
+	err = ceph_pagelist_append(pagelist, flocks,
+				   num_fcntl_locks * sizeof(*flocks));
+	if (err)
+		goto out_fail;
+
+	nlocks = cpu_to_le32(num_flock_locks);
+	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
+	if (err)
+		goto out_fail;
+
+	err = ceph_pagelist_append(pagelist,
+				   &flocks[num_fcntl_locks],
+				   num_flock_locks * sizeof(*flocks));
+out_fail:
+	return err;
+}
+
 /*
  * Given a pointer to a lock, convert it to a ceph filelock
  */
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7f1682d..0b26ea8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -335,9 +335,9 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
 	     atomic_read(&s->s_ref), atomic_read(&s->s_ref)-1);
 	if (atomic_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
-		     s->s_mdsc->fsc->client->monc.auth->ops->destroy_authorizer(
-			     s->s_mdsc->fsc->client->monc.auth,
-			     s->s_auth.authorizer);
+			ceph_auth_destroy_authorizer(
+				s->s_mdsc->fsc->client->monc.auth,
+				s->s_auth.authorizer);
 		kfree(s);
 	}
 }
@@ -2450,39 +2450,44 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 
 	if (recon_state->flock) {
 		int num_fcntl_locks, num_flock_locks;
-		struct ceph_pagelist_cursor trunc_point;
-
-		ceph_pagelist_set_cursor(pagelist, &trunc_point);
-		do {
-			lock_flocks();
-			ceph_count_locks(inode, &num_fcntl_locks,
-					 &num_flock_locks);
-			rec.v2.flock_len = (2*sizeof(u32) +
-					    (num_fcntl_locks+num_flock_locks) *
-					    sizeof(struct ceph_filelock));
-			unlock_flocks();
-
-			/* pre-alloc pagelist */
-			ceph_pagelist_truncate(pagelist, &trunc_point);
-			err = ceph_pagelist_append(pagelist, &rec, reclen);
-			if (!err)
-				err = ceph_pagelist_reserve(pagelist,
-							    rec.v2.flock_len);
-
-			/* encode locks */
-			if (!err) {
-				lock_flocks();
-				err = ceph_encode_locks(inode,
-							pagelist,
-							num_fcntl_locks,
-							num_flock_locks);
-				unlock_flocks();
-			}
-		} while (err == -ENOSPC);
+		struct ceph_filelock *flocks;
+
+encode_again:
+		lock_flocks();
+		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
+		unlock_flocks();
+		flocks = kmalloc((num_fcntl_locks+num_flock_locks) *
+				 sizeof(struct ceph_filelock), GFP_NOFS);
+		if (!flocks) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+		lock_flocks();
+		err = ceph_encode_locks_to_buffer(inode, flocks,
+						  num_fcntl_locks,
+						  num_flock_locks);
+		unlock_flocks();
+		if (err) {
+			kfree(flocks);
+			if (err == -ENOSPC)
+				goto encode_again;
+			goto out_free;
+		}
+		/*
+		 * number of encoded locks is stable, so copy to pagelist
+		 */
+		rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
+				    (num_fcntl_locks+num_flock_locks) *
+				    sizeof(struct ceph_filelock));
+		err = ceph_pagelist_append(pagelist, &rec, reclen);
+		if (!err)
+			err = ceph_locks_to_pagelist(flocks, pagelist,
+						     num_fcntl_locks,
+						     num_flock_locks);
+		kfree(flocks);
 	} else {
 		err = ceph_pagelist_append(pagelist, &rec, reclen);
 	}
-
 out_free:
 	kfree(path);
 out_dput:
@@ -3408,13 +3413,17 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	struct ceph_auth_handshake *auth = &s->s_auth;
 
 	if (force_new && auth->authorizer) {
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, auth->authorizer);
+		ceph_auth_destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
-		int ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
-							auth);
+	if (!auth->authorizer) {
+		int ret = ceph_auth_create_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
+						      auth);
+		if (ret)
+			return ERR_PTR(ret);
+	} else {
+		int ret = ceph_auth_update_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
+						      auth);
 		if (ret)
 			return ERR_PTR(ret);
 	}
@@ -3430,7 +3439,7 @@ static int verify_authorizer_reply(struct ceph_connection *con, int len)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_auth_client *ac = mdsc->fsc->client->monc.auth;
 
-	return ac->ops->verify_authorizer_reply(ac, s->s_auth.authorizer, len);
+	return ceph_auth_verify_authorizer_reply(ac, s->s_auth.authorizer, len);
 }
 
 static int invalidate_authorizer(struct ceph_connection *con)
@@ -3439,8 +3448,7 @@ static int invalidate_authorizer(struct ceph_connection *con)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_auth_client *ac = mdsc->fsc->client->monc.auth;
 
-	if (ac->ops->invalidate_authorizer)
-		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_MDS);
+	ceph_auth_invalidate_authorizer(ac, CEPH_ENTITY_TYPE_MDS);
 
 	return ceph_monc_validate_auth(&mdsc->fsc->client->monc);
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 1e67dd7..a7a70ee 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -70,8 +70,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	/*
 	 * express utilization in terms of large blocks to avoid
 	 * overflow on 32-bit machines.
+	 *
+	 * NOTE: for the time being, we make bsize == frsize to humor
+	 * not-yet-ancient versions of glibc that are broken.
+	 * Someday, we will probably want to report a real block
+	 * size...  whatever that may mean for a network file system!
 	 */
 	buf->f_bsize = 1 << CEPH_BLOCK_SHIFT;
+	buf->f_frsize = 1 << CEPH_BLOCK_SHIFT;
 	buf->f_blocks = le64_to_cpu(st.kb) >> (CEPH_BLOCK_SHIFT-10);
 	buf->f_bfree = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
 	buf->f_bavail = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
@@ -79,7 +85,6 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = le64_to_cpu(st.num_objects);
 	buf->f_ffree = -1;
 	buf->f_namelen = NAME_MAX;
-	buf->f_frsize = PAGE_CACHE_SIZE;
 
 	/* leave fsid little-endian, regardless of host endianness */
 	fsid = *(u64 *)(&monmap->fsid) ^ *((u64 *)&monmap->fsid + 1);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index fc35036..d2e01a6 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -21,7 +21,7 @@
 
 /* large granularity for statfs utilization stats to facilitate
  * large volume sizes on 32-bit machines. */
-#define CEPH_BLOCK_SHIFT   20  /* 1 MB */
+#define CEPH_BLOCK_SHIFT   22  /* 4 MB */
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
 
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
@@ -847,8 +847,13 @@ extern const struct export_operations ceph_export_ops;
 extern int ceph_lock(struct file *file, int cmd, struct file_lock *fl);
 extern int ceph_flock(struct file *file, int cmd, struct file_lock *fl);
 extern void ceph_count_locks(struct inode *inode, int *p_num, int *f_num);
-extern int ceph_encode_locks(struct inode *i, struct ceph_pagelist *p,
-			     int p_locks, int f_locks);
+extern int ceph_encode_locks_to_buffer(struct inode *inode,
+				       struct ceph_filelock *flocks,
+				       int num_fcntl_locks,
+				       int num_flock_locks);
+extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
+				  struct ceph_pagelist *pagelist,
+				  int num_fcntl_locks, int num_flock_locks);
 extern int lock_to_ceph_filelock(struct file_lock *fl, struct ceph_filelock *c);
 
 /* debugfs.c */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index df4b8db..89abdd7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2208,7 +2208,9 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
+			mutex_lock(&inode->i_mutex);
 			ext4_truncate(inode);
+			mutex_unlock(&inode->i_mutex);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 89d2a58..4816908 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -50,7 +50,7 @@ static secno hpfs_bmap(struct inode *inode, unsigned file_secno)
 	return disk_secno;
 }
 
-static void hpfs_truncate(struct inode *i)
+void hpfs_truncate(struct inode *i)
 {
 	if (IS_IMMUTABLE(i)) return /*-EPERM*/;
 	hpfs_lock_assert(i->i_sb);
@@ -105,6 +105,20 @@ static int hpfs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page,hpfs_get_block);
 }
 
+static void hpfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	hpfs_lock(inode->i_sb);
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		hpfs_truncate(inode);
+	}
+
+	hpfs_unlock(inode->i_sb);
+}
+
 static int hpfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -115,11 +129,8 @@ static int hpfs_write_begin(struct file *file, struct address_space *mapping,
 	ret = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				hpfs_get_block,
 				&hpfs_i(mapping->host)->mmu_private);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		hpfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
@@ -166,6 +177,5 @@ const struct file_operations hpfs_file_ops =
 
 const struct inode_operations hpfs_file_iops =
 {
-	.truncate	= hpfs_truncate,
 	.setattr	= hpfs_setattr,
 };
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index c07ef1f..2623e7e 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -252,6 +252,7 @@ void hpfs_set_ea(struct inode *, struct fnode *, const char *,
 /* file.c */
 
 int hpfs_file_fsync(struct file *, loff_t, loff_t, int);
+void hpfs_truncate(struct inode *);
 extern const struct file_operations hpfs_file_ops;
 extern const struct inode_operations hpfs_file_iops;
 extern const struct address_space_operations hpfs_aops;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index ed671e0..4c57a50 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -274,9 +274,12 @@ int hpfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			goto out_unlock;
+
+		truncate_setsize(inode, attr->ia_size);
+		hpfs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index bd4b5a7..bdfabda 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -21,12 +21,12 @@ extern wait_queue_head_t log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
-	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_PROC);
 }
 
 static int kmsg_release(struct inode * inode, struct file * file)
 {
-	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_FILE);
+	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_PROC);
 	return 0;
 }
 
@@ -34,15 +34,15 @@ static ssize_t kmsg_read(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	if ((file->f_flags & O_NONBLOCK) &&
-	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return -EAGAIN;
-	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_PROC);
 }
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &log_wait, wait);
-	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
index d4080f3..5f33868 100644
--- a/include/linux/ceph/auth.h
+++ b/include/linux/ceph/auth.h
@@ -52,6 +52,9 @@ struct ceph_auth_client_ops {
 	 */
 	int (*create_authorizer)(struct ceph_auth_client *ac, int peer_type,
 				 struct ceph_auth_handshake *auth);
+	/* ensure that an existing authorizer is up to date */
+	int (*update_authorizer)(struct ceph_auth_client *ac, int peer_type,
+				 struct ceph_auth_handshake *auth);
 	int (*verify_authorizer_reply)(struct ceph_auth_client *ac,
 				       struct ceph_authorizer *a, size_t len);
 	void (*destroy_authorizer)(struct ceph_auth_client *ac,
@@ -75,6 +78,8 @@ struct ceph_auth_client {
 	u64 global_id;          /* our unique id in system */
 	const struct ceph_crypto_key *key;     /* our secret key */
 	unsigned want_keys;     /* which services we want */
+
+	struct mutex mutex;
 };
 
 extern struct ceph_auth_client *ceph_auth_init(const char *name,
@@ -94,5 +99,18 @@ extern int ceph_build_auth(struct ceph_auth_client *ac,
 		    void *msg_buf, size_t msg_len);
 
 extern int ceph_auth_is_authenticated(struct ceph_auth_client *ac);
+extern int ceph_auth_create_authorizer(struct ceph_auth_client *ac,
+				       int peer_type,
+				       struct ceph_auth_handshake *auth);
+extern void ceph_auth_destroy_authorizer(struct ceph_auth_client *ac,
+					 struct ceph_authorizer *a);
+extern int ceph_auth_update_authorizer(struct ceph_auth_client *ac,
+				       int peer_type,
+				       struct ceph_auth_handshake *a);
+extern int ceph_auth_verify_authorizer_reply(struct ceph_auth_client *ac,
+					     struct ceph_authorizer *a,
+					     size_t len);
+extern void ceph_auth_invalidate_authorizer(struct ceph_auth_client *ac,
+					    int peer_type);
 
 #endif
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..714e792 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -175,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -198,6 +200,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define cpu_hotplug_disable()	do { } while (0)
+#define cpu_hotplug_enable()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 47ead51..c5fd30d 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -137,6 +137,7 @@ static inline void make_migration_entry_read(swp_entry_t *entry)
 
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
+extern void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte);
 #else
 
 #define make_migration_entry(page, write) swp_entry(0, 0)
@@ -148,6 +149,8 @@ static inline int is_migration_entry(swp_entry_t swp)
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
+static inline void migration_entry_wait_huge(struct mm_struct *mm,
+					pte_t *pte) { }
 static inline int is_write_migration_entry(swp_entry_t entry)
 {
 	return 0;
diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 3891139..98a3153 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -44,8 +44,8 @@
 /* Return size of the log buffer */
 #define SYSLOG_ACTION_SIZE_BUFFER   10
 
-#define SYSLOG_FROM_CALL 0
-#define SYSLOG_FROM_FILE 1
+#define SYSLOG_FROM_READER           0
+#define SYSLOG_FROM_PROC             1
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
 
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9fc7728..e3fe61f 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -981,6 +981,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event);
 int mgmt_control(struct sock *sk, struct msghdr *msg, size_t len);
 int mgmt_index_added(struct hci_dev *hdev);
 int mgmt_index_removed(struct hci_dev *hdev);
+int mgmt_set_powered_failed(struct hci_dev *hdev, int err);
 int mgmt_powered(struct hci_dev *hdev, u8 powered);
 int mgmt_discoverable(struct hci_dev *hdev, u8 discoverable);
 int mgmt_connectable(struct hci_dev *hdev, u8 connectable);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23fd054..4ea860e 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -42,6 +42,7 @@
 #define MGMT_STATUS_NOT_POWERED		0x0f
 #define MGMT_STATUS_CANCELLED		0x10
 #define MGMT_STATUS_INVALID_INDEX	0x11
+#define MGMT_STATUS_RFKILLED		0x12
 
 struct mgmt_hdr {
 	__le16	opcode;
diff --git a/include/xen/interface/io/netif.h b/include/xen/interface/io/netif.h
index a36c87a..d4635cd 100644
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -65,6 +65,7 @@
 #define _XEN_NETTXF_extra_info		(3)
 #define  XEN_NETTXF_extra_info		(1U<<_XEN_NETTXF_extra_info)
 
+#define XEN_NETIF_MAX_TX_SIZE 0xFFFF
 struct xen_netif_tx_request {
     grant_ref_t gref;      /* Reference to buffer page */
     uint16_t offset;       /* Offset within buffer page */
diff --git a/kernel/audit.c b/kernel/audit.c
index 1c7f2c6..5917dfe 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1167,7 +1167,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 
 			/* Wait for auditd to drain the queue a little */
 			DECLARE_WAITQUEUE(wait, current);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&audit_backlog_wait, &wait);
 
 			if (audit_backlog_limit &&
diff --git a/kernel/cpu.c b/kernel/cpu.c
index a4eb522..42b5ffc 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -129,6 +129,27 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 
+/*
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
+ */
+void cpu_hotplug_disable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 1;
+	cpu_maps_update_done();
+}
+
+void cpu_hotplug_enable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 0;
+	cpu_maps_update_done();
+}
+
 #else /* #if CONFIG_HOTPLUG_CPU */
 static void cpu_hotplug_begin(void) {}
 static void cpu_hotplug_done(void) {}
@@ -534,36 +555,6 @@ static int __init alloc_frozen_cpus(void)
 core_initcall(alloc_frozen_cpus);
 
 /*
- * Prevent regular CPU hotplug from racing with the freezer, by disabling CPU
- * hotplug when tasks are about to be frozen. Also, don't allow the freezer
- * to continue until any currently running CPU hotplug operation gets
- * completed.
- * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
- * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
- * CPU hotplug path and released only after it is complete. Thus, we
- * (and hence the freezer) will block here until any currently running CPU
- * hotplug operation gets completed.
- */
-void cpu_hotplug_disable_before_freeze(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 1;
-	cpu_maps_update_done();
-}
-
-
-/*
- * When tasks have been thawed, re-enable regular CPU hotplug (which had been
- * disabled while beginning to freeze tasks).
- */
-void cpu_hotplug_enable_after_thaw(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 0;
-	cpu_maps_update_done();
-}
-
-/*
  * When callbacks for CPU hotplug notifications are being executed, we must
  * ensure that the state of the system with respect to the tasks being frozen
  * or not, as reported by the notification, remains unchanged *throughout the
@@ -582,12 +573,12 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 	case PM_SUSPEND_PREPARE:
 	case PM_HIBERNATION_PREPARE:
-		cpu_hotplug_disable_before_freeze();
+		cpu_hotplug_disable();
 		break;
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
-		cpu_hotplug_enable_after_thaw();
+		cpu_hotplug_enable();
 		break;
 
 	default:
diff --git a/kernel/printk.c b/kernel/printk.c
index 46f0c2c..5758501 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -357,6 +357,53 @@ static void log_store(int facility, int level,
 	log_next_seq++;
 }
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict = 1;
+#else
+int dmesg_restrict;
+#endif
+
+static int syslog_action_restricted(int type)
+{
+	if (dmesg_restrict)
+		return 1;
+	/*
+	 * Unless restricted, we allow "read all" and "get buffer size"
+	 * for everybody.
+	 */
+	return type != SYSLOG_ACTION_READ_ALL &&
+	       type != SYSLOG_ACTION_SIZE_BUFFER;
+}
+
+static int check_syslog_permissions(int type, bool from_file)
+{
+	/*
+	 * If this is from /proc/kmsg and we've already opened it, then we've
+	 * already done the capabilities checks at open time.
+	 */
+	if (from_file && type != SYSLOG_ACTION_OPEN)
+		return 0;
+
+	if (syslog_action_restricted(type)) {
+		if (capable(CAP_SYSLOG))
+			return 0;
+		/*
+		 * For historical reasons, accept CAP_SYS_ADMIN too, with
+		 * a warning.
+		 */
+		if (capable(CAP_SYS_ADMIN)) {
+			pr_warn_once("%s (%d): Attempt to access syslog with "
+				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
+				     "(deprecated).\n",
+				 current->comm, task_pid_nr(current));
+			return 0;
+		}
+		return -EPERM;
+	}
+	return security_syslog(type);
+}
+
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -592,7 +639,8 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
 
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+				       SYSLOG_FROM_READER);
 	if (err)
 		return err;
 
@@ -759,45 +807,6 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
-#else
-int dmesg_restrict;
-#endif
-
-static int syslog_action_restricted(int type)
-{
-	if (dmesg_restrict)
-		return 1;
-	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
-	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
-}
-
-static int check_syslog_permissions(int type, bool from_file)
-{
-	/*
-	 * If this is from /proc/kmsg and we've already opened it, then we've
-	 * already done the capabilities checks at open time.
-	 */
-	if (from_file && type != SYSLOG_ACTION_OPEN)
-		return 0;
-
-	if (syslog_action_restricted(type)) {
-		if (capable(CAP_SYSLOG))
-			return 0;
-		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
-		if (capable(CAP_SYS_ADMIN)) {
-			printk_once(KERN_WARNING "%s (%d): "
-				 "Attempt to access syslog with CAP_SYS_ADMIN "
-				 "but no CAP_SYSLOG (deprecated).\n",
-				 current->comm, task_pid_nr(current));
-			return 0;
-		}
-		return -EPERM;
-	}
-	return 0;
-}
-
 #if defined(CONFIG_PRINTK_TIME)
 static bool printk_time = 1;
 #else
@@ -1195,7 +1204,7 @@ out:
 
 SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 {
-	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
+	return do_syslog(type, buf, len, SYSLOG_FROM_READER);
 }
 
 static bool __read_mostly ignore_loglevel;
diff --git a/kernel/sys.c b/kernel/sys.c
index 0836a7f..1451e54 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -356,6 +356,29 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+/* Add backwards compatibility for stable trees. */
+#ifndef PF_NO_SETAFFINITY
+#define PF_NO_SETAFFINITY		PF_THREAD_BOUND
+#endif
+
+static void migrate_to_reboot_cpu(void)
+{
+	/* The boot cpu is always logical cpu 0 */
+	int cpu = 0;
+
+	cpu_hotplug_disable();
+
+	/* Make certain the cpu I'm about to reboot on is online */
+	if (!cpu_online(cpu))
+		cpu = cpumask_first(cpu_online_mask);
+
+	/* Prevent races with other tasks migrating this task */
+	current->flags |= PF_NO_SETAFFINITY;
+
+	/* Make certain I only run on the appropriate processor */
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -367,7 +390,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
@@ -394,7 +417,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
@@ -413,7 +436,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
diff --git a/lib/klist.c b/lib/klist.c
index 0874e41..358a368 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -193,10 +193,10 @@ static void klist_release(struct kref *kref)
 		if (waiter->node != n)
 			continue;
 
+		list_del(&waiter->list);
 		waiter->woken = 1;
 		mb();
 		wake_up_process(waiter->process);
-		list_del(&waiter->list);
 	}
 	spin_unlock(&klist_remove_lock);
 	knode_set_klist(n, NULL);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 74b8327..c6557ef 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2769,7 +2769,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait(mm, (pmd_t *)ptep, address);
+			migration_entry_wait_huge(mm, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
diff --git a/mm/migrate.c b/mm/migrate.c
index 65cc229..41e906a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -182,15 +182,14 @@ static void remove_migration_ptes(struct page *old, struct page *new)
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
  */
-void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long address)
+static void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
+				spinlock_t *ptl)
 {
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
+	pte_t pte;
 	swp_entry_t entry;
 	struct page *page;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	spin_lock(ptl);
 	pte = *ptep;
 	if (!is_swap_pte(pte))
 		goto out;
@@ -218,6 +217,20 @@ out:
 	pte_unmap_unlock(ptep, ptl);
 }
 
+void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long address)
+{
+	spinlock_t *ptl = pte_lockptr(mm, pmd);
+	pte_t *ptep = pte_offset_map(pmd, address);
+	__migration_entry_wait(mm, ptep, ptl);
+}
+
+void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte)
+{
+	spinlock_t *ptl = &(mm)->page_table_lock;
+	__migration_entry_wait(mm, pte, ptl);
+}
+
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
 static bool buffer_migrate_lock_buffers(struct buffer_head *head,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4c5ff7f..1fa9220 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -313,8 +313,24 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
-		if (err == -EEXIST) {	/* seems racy */
+		if (err == -EEXIST) {
 			radix_tree_preload_end();
+			/*
+			 * We might race against get_swap_page() and stumble
+			 * across a SWAP_HAS_CACHE swap_map entry whose page
+			 * has not been brought into the swapcache yet, while
+			 * the other end is scheduled away waiting on discard
+			 * I/O completion at scan_swap_map().
+			 *
+			 * In order to avoid turning this transitory state
+			 * into a permanent loop around this -EEXIST case
+			 * if !CONFIG_PREEMPT and the I/O completion happens
+			 * to be waiting on the CPU waitqueue where we are now
+			 * busy looping, we just conditionally invoke the
+			 * scheduler here, if there are some more important
+			 * tasks to run.
+			 */
+			cond_resched();
 			continue;
 		}
 		if (err) {		/* swp entry is obsolete ? */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index de01610..448a574 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1097,11 +1097,15 @@ static const struct rfkill_ops hci_rfkill_ops = {
 static void hci_power_on(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, power_on);
+	int err;
 
 	BT_DBG("%s", hdev->name);
 
-	if (hci_dev_open(hdev->id) < 0)
+	err = hci_dev_open(hdev->id);
+	if (err < 0) {
+		mgmt_set_powered_failed(hdev, err);
 		return;
+	}
 
 	if (test_bit(HCI_AUTO_OFF, &hdev->dev_flags))
 		schedule_delayed_work(&hdev->power_off,
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ec098bd..6406d7e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2912,6 +2912,27 @@ int mgmt_powered(struct hci_dev *hdev, u8 powered)
 	return err;
 }
 
+int mgmt_set_powered_failed(struct hci_dev *hdev, int err)
+{
+	struct pending_cmd *cmd;
+	u8 status;
+
+	cmd = mgmt_pending_find(MGMT_OP_SET_POWERED, hdev);
+	if (!cmd)
+		return -ENOENT;
+
+	if (err == -ERFKILL)
+		status = MGMT_STATUS_RFKILLED;
+	else
+		status = MGMT_STATUS_FAILED;
+
+	err = cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_POWERED, status);
+
+	mgmt_pending_remove(cmd);
+
+	return err;
+}
+
 int mgmt_discoverable(struct hci_dev *hdev, u8 discoverable)
 {
 	struct cmd_lookup match = { NULL, hdev };
diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index b4bf4ac..6b923bc 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -47,6 +47,7 @@ struct ceph_auth_client *ceph_auth_init(const char *name, const struct ceph_cryp
 	if (!ac)
 		goto out;
 
+	mutex_init(&ac->mutex);
 	ac->negotiating = true;
 	if (name)
 		ac->name = name;
@@ -73,10 +74,12 @@ void ceph_auth_destroy(struct ceph_auth_client *ac)
  */
 void ceph_auth_reset(struct ceph_auth_client *ac)
 {
+	mutex_lock(&ac->mutex);
 	dout("auth_reset %p\n", ac);
 	if (ac->ops && !ac->negotiating)
 		ac->ops->reset(ac);
 	ac->negotiating = true;
+	mutex_unlock(&ac->mutex);
 }
 
 int ceph_entity_name_encode(const char *name, void **p, void *end)
@@ -102,6 +105,7 @@ int ceph_auth_build_hello(struct ceph_auth_client *ac, void *buf, size_t len)
 	int i, num;
 	int ret;
 
+	mutex_lock(&ac->mutex);
 	dout("auth_build_hello\n");
 	monhdr->have_version = 0;
 	monhdr->session_mon = cpu_to_le16(-1);
@@ -122,15 +126,19 @@ int ceph_auth_build_hello(struct ceph_auth_client *ac, void *buf, size_t len)
 
 	ret = ceph_entity_name_encode(ac->name, &p, end);
 	if (ret < 0)
-		return ret;
+		goto out;
 	ceph_decode_need(&p, end, sizeof(u64), bad);
 	ceph_encode_64(&p, ac->global_id);
 
 	ceph_encode_32(&lenp, p - lenp - sizeof(u32));
-	return p - buf;
+	ret = p - buf;
+out:
+	mutex_unlock(&ac->mutex);
+	return ret;
 
 bad:
-	return -ERANGE;
+	ret = -ERANGE;
+	goto out;
 }
 
 static int ceph_build_auth_request(struct ceph_auth_client *ac,
@@ -151,11 +159,13 @@ static int ceph_build_auth_request(struct ceph_auth_client *ac,
 	if (ret < 0) {
 		pr_err("error %d building auth method %s request\n", ret,
 		       ac->ops->name);
-		return ret;
+		goto out;
 	}
 	dout(" built request %d bytes\n", ret);
 	ceph_encode_32(&p, ret);
-	return p + ret - msg_buf;
+	ret = p + ret - msg_buf;
+out:
+	return ret;
 }
 
 /*
@@ -176,6 +186,7 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 	int result_msg_len;
 	int ret = -EINVAL;
 
+	mutex_lock(&ac->mutex);
 	dout("handle_auth_reply %p %p\n", p, end);
 	ceph_decode_need(&p, end, sizeof(u32) * 3 + sizeof(u64), bad);
 	protocol = ceph_decode_32(&p);
@@ -227,33 +238,103 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	ret = ac->ops->handle_reply(ac, result, payload, payload_end);
 	if (ret == -EAGAIN) {
-		return ceph_build_auth_request(ac, reply_buf, reply_len);
+		ret = ceph_build_auth_request(ac, reply_buf, reply_len);
 	} else if (ret) {
 		pr_err("auth method '%s' error %d\n", ac->ops->name, ret);
-		return ret;
 	}
-	return 0;
 
-bad:
-	pr_err("failed to decode auth msg\n");
 out:
+	mutex_unlock(&ac->mutex);
 	return ret;
+
+bad:
+	pr_err("failed to decode auth msg\n");
+	ret = -EINVAL;
+	goto out;
 }
 
 int ceph_build_auth(struct ceph_auth_client *ac,
 		    void *msg_buf, size_t msg_len)
 {
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
 	if (!ac->protocol)
-		return ceph_auth_build_hello(ac, msg_buf, msg_len);
-	BUG_ON(!ac->ops);
-	if (ac->ops->should_authenticate(ac))
-		return ceph_build_auth_request(ac, msg_buf, msg_len);
-	return 0;
+		ret = ceph_auth_build_hello(ac, msg_buf, msg_len);
+	else if (ac->ops->should_authenticate(ac))
+		ret = ceph_build_auth_request(ac, msg_buf, msg_len);
+	mutex_unlock(&ac->mutex);
+	return ret;
 }
 
 int ceph_auth_is_authenticated(struct ceph_auth_client *ac)
 {
-	if (!ac->ops)
-		return 0;
-	return ac->ops->is_authenticated(ac);
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops)
+		ret = ac->ops->is_authenticated(ac);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_is_authenticated);
+
+int ceph_auth_create_authorizer(struct ceph_auth_client *ac,
+				int peer_type,
+				struct ceph_auth_handshake *auth)
+{
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->create_authorizer)
+		ret = ac->ops->create_authorizer(ac, peer_type, auth);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_create_authorizer);
+
+void ceph_auth_destroy_authorizer(struct ceph_auth_client *ac,
+				  struct ceph_authorizer *a)
+{
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->destroy_authorizer)
+		ac->ops->destroy_authorizer(ac, a);
+	mutex_unlock(&ac->mutex);
+}
+EXPORT_SYMBOL(ceph_auth_destroy_authorizer);
+
+int ceph_auth_update_authorizer(struct ceph_auth_client *ac,
+				int peer_type,
+				struct ceph_auth_handshake *a)
+{
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->update_authorizer)
+		ret = ac->ops->update_authorizer(ac, peer_type, a);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_update_authorizer);
+
+int ceph_auth_verify_authorizer_reply(struct ceph_auth_client *ac,
+				      struct ceph_authorizer *a, size_t len)
+{
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->verify_authorizer_reply)
+		ret = ac->ops->verify_authorizer_reply(ac, a, len);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_verify_authorizer_reply);
+
+void ceph_auth_invalidate_authorizer(struct ceph_auth_client *ac, int peer_type)
+{
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->invalidate_authorizer)
+		ac->ops->invalidate_authorizer(ac, peer_type);
+	mutex_unlock(&ac->mutex);
 }
+EXPORT_SYMBOL(ceph_auth_invalidate_authorizer);
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index a16bf14..96238ba 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -298,6 +298,7 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 			return -ENOMEM;
 	}
 	au->service = th->service;
+	au->secret_id = th->secret_id;
 
 	msg_a = au->buf->vec.iov_base;
 	msg_a->struct_v = 1;
@@ -555,6 +556,26 @@ static int ceph_x_create_authorizer(
 	return 0;
 }
 
+static int ceph_x_update_authorizer(
+	struct ceph_auth_client *ac, int peer_type,
+	struct ceph_auth_handshake *auth)
+{
+	struct ceph_x_authorizer *au;
+	struct ceph_x_ticket_handler *th;
+
+	th = get_ticket_handler(ac, peer_type);
+	if (IS_ERR(th))
+		return PTR_ERR(th);
+
+	au = (struct ceph_x_authorizer *)auth->authorizer;
+	if (au->secret_id < th->secret_id) {
+		dout("ceph_x_update_authorizer service %u secret %llu < %llu\n",
+		     au->service, au->secret_id, th->secret_id);
+		return ceph_x_build_authorizer(ac, th, au);
+	}
+	return 0;
+}
+
 static int ceph_x_verify_authorizer_reply(struct ceph_auth_client *ac,
 					  struct ceph_authorizer *a, size_t len)
 {
@@ -630,7 +651,7 @@ static void ceph_x_invalidate_authorizer(struct ceph_auth_client *ac,
 
 	th = get_ticket_handler(ac, peer_type);
 	if (!IS_ERR(th))
-		remove_ticket_handler(ac, th);
+		memset(&th->validity, 0, sizeof(th->validity));
 }
 
 
@@ -641,6 +662,7 @@ static const struct ceph_auth_client_ops ceph_x_ops = {
 	.build_request = ceph_x_build_request,
 	.handle_reply = ceph_x_handle_reply,
 	.create_authorizer = ceph_x_create_authorizer,
+	.update_authorizer = ceph_x_update_authorizer,
 	.verify_authorizer_reply = ceph_x_verify_authorizer_reply,
 	.destroy_authorizer = ceph_x_destroy_authorizer,
 	.invalidate_authorizer = ceph_x_invalidate_authorizer,
diff --git a/net/ceph/auth_x.h b/net/ceph/auth_x.h
index f459e93..c5a058d 100644
--- a/net/ceph/auth_x.h
+++ b/net/ceph/auth_x.h
@@ -29,6 +29,7 @@ struct ceph_x_authorizer {
 	struct ceph_buffer *buf;
 	unsigned int service;
 	u64 nonce;
+	u64 secret_id;
 	char reply_buf[128];  /* big enough for encrypted blob */
 };
 
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 692243a..559690f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1548,7 +1548,6 @@ static int process_connect(struct ceph_connection *con)
 			con->error_msg = "connect authorization failure";
 			return -1;
 		}
-		con->auth_retry = 1;
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
@@ -1633,7 +1632,7 @@ static int process_connect(struct ceph_connection *con)
 
 		BUG_ON(con->state != CON_STATE_NEGOTIATING);
 		con->state = CON_STATE_OPEN;
-
+		con->auth_retry = 0;    /* we authenticated; clear flag */
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 900ea0f..8a9235d 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -737,7 +737,7 @@ static void delayed_work(struct work_struct *work)
 
 		__validate_auth(monc);
 
-		if (monc->auth->ops->is_authenticated(monc->auth))
+		if (ceph_auth_is_authenticated(monc->auth))
 			__send_subscribe(monc);
 	}
 	__schedule_delayed(monc);
@@ -893,8 +893,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 
 	mutex_lock(&monc->mutex);
 	had_debugfs_info = have_debugfs_info(monc);
-	if (monc->auth->ops)
-		was_auth = monc->auth->ops->is_authenticated(monc->auth);
+	was_auth = ceph_auth_is_authenticated(monc->auth);
 	monc->pending_auth = 0;
 	ret = ceph_handle_auth_reply(monc->auth, msg->front.iov_base,
 				     msg->front.iov_len,
@@ -905,7 +904,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 		wake_up_all(&monc->client->auth_wq);
 	} else if (ret > 0) {
 		__send_prepared_auth_request(monc, ret);
-	} else if (!was_auth && monc->auth->ops->is_authenticated(monc->auth)) {
+	} else if (!was_auth && ceph_auth_is_authenticated(monc->auth)) {
 		dout("authenticated, starting session\n");
 
 		monc->client->msgr.inst.name.type = CEPH_ENTITY_TYPE_CLIENT;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 065cc38..f181972 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -672,8 +672,7 @@ static void put_osd(struct ceph_osd *osd)
 	if (atomic_dec_and_test(&osd->o_ref) && osd->o_auth.authorizer) {
 		struct ceph_auth_client *ac = osd->o_osdc->client->monc.auth;
 
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, osd->o_auth.authorizer);
+		ceph_auth_destroy_authorizer(ac, osd->o_auth.authorizer);
 		kfree(osd);
 	}
 }
@@ -1301,7 +1300,7 @@ static void reset_changed_osds(struct ceph_osd_client *osdc)
  * Requeue requests whose mapping to an OSD has changed.  If requests map to
  * no osd, request a new map.
  *
- * Caller should hold map_sem for read and request_mutex.
+ * Caller should hold map_sem for read.
  */
 static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 {
@@ -1359,9 +1358,10 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 
 		dout("kicking lingering %p tid %llu osd%d\n", req, req->r_tid,
 		     req->r_osd ? req->r_osd->o_osd : -1);
-		__unregister_linger_request(osdc, req);
 		__register_request(osdc, req);
+		__unregister_linger_request(osdc, req);
 	}
+	reset_changed_osds(osdc);
 	mutex_unlock(&osdc->request_mutex);
 
 	if (needmap) {
@@ -1424,7 +1424,6 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 				osdc->osdmap = newmap;
 			}
 			kick_requests(osdc, 0);
-			reset_changed_osds(osdc);
 		} else {
 			dout("ignoring incremental map %u len %d\n",
 			     epoch, maplen);
@@ -2151,13 +2150,17 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	struct ceph_auth_handshake *auth = &o->o_auth;
 
 	if (force_new && auth->authorizer) {
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, auth->authorizer);
+		ceph_auth_destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
-		int ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
-							auth);
+	if (!auth->authorizer) {
+		int ret = ceph_auth_create_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
+						      auth);
+		if (ret)
+			return ERR_PTR(ret);
+	} else {
+		int ret = ceph_auth_update_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
+						     auth);
 		if (ret)
 			return ERR_PTR(ret);
 	}
@@ -2173,11 +2176,7 @@ static int verify_authorizer_reply(struct ceph_connection *con, int len)
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
-	/*
-	 * XXX If ac->ops or ac->ops->verify_authorizer_reply is null,
-	 * XXX which do we do:  succeed or fail?
-	 */
-	return ac->ops->verify_authorizer_reply(ac, o->o_auth.authorizer, len);
+	return ceph_auth_verify_authorizer_reply(ac, o->o_auth.authorizer, len);
 }
 
 static int invalidate_authorizer(struct ceph_connection *con)
@@ -2186,9 +2185,7 @@ static int invalidate_authorizer(struct ceph_connection *con)
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
-	if (ac->ops && ac->ops->invalidate_authorizer)
-		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
-
+	ceph_auth_invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
 	return ceph_monc_validate_auth(&osdc->client->monc);
 }
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4b4d9c5..f51a61c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1408,6 +1408,15 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 
 	ASSERT_RTNL();
 
+	/*
+	 * Close all AP_VLAN interfaces first, as otherwise they
+	 * might be closed while the AP interface they belong to
+	 * is closed, causing unregister_netdevice_many() to crash.
+	 */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			dev_close(sdata->dev);
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f7e937f..3fd50a1 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -222,6 +222,9 @@ void cfg80211_conn_work(struct work_struct *work)
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 7203c9a..ffb9153 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1633,6 +1633,7 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
 	}
 	if (!snd_pcm_stream_linked(substream)) {
 		substream->group = group;
+		group = NULL;
 		spin_lock_init(&substream->group->lock);
 		INIT_LIST_HEAD(&substream->group->substreams);
 		list_add_tail(&substream->link_list, &substream->group->substreams);
@@ -1647,8 +1648,7 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
  _nolock:
 	snd_card_unref(substream1->pcm->card);
 	fput(file);
-	if (res < 0)
-		kfree(group);
+	kfree(group);
 	return res;
 }
 
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 4d8ddc6..a3308e1 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -842,6 +842,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
+	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
 	/* Most audio usb devices lie about volume resolution.
 	 * Most Logitech webcams have res = 384.
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 128eb0c..cfb8033 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -157,7 +157,13 @@
 	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL
 },
 {
-	USB_DEVICE(0x046d, 0x0990),
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x046d,
+	.idProduct = 0x0990,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		.vendor_name = "Logitech, Inc.",
 		.product_name = "QuickCam Pro 9000",
@@ -1622,7 +1628,11 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	USB_DEVICE_VENDOR_SPEC(0x0582, 0x0108),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		.ifnum = 0,
-		.type = QUIRK_MIDI_STANDARD_INTERFACE
+		.type = QUIRK_MIDI_FIXED_ENDPOINT,
+		.data = & (const struct snd_usb_midi_endpoint_info) {
+			.out_cables = 0x0007,
+			.in_cables  = 0x0007
+		}
 	}
 },
 {
