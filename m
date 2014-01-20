Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaATPEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:04:06 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50073 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:04:03 -0500
Date: Mon, 20 Jan 2014 16:03:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.14
Message-ID: <20140120150359.GA15571@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   # HEAD: ca1e631c3acf80bc5f5934ce9054a9b4880c96e1 x86, tsc, apic: Unbreak static (MSR) calibration when CONFIG_X86_LOCAL_APIC=n

Improved Intel SoC platform support.

 Thanks,

	Ingo

------------------>
Bin Gao (1):
      x86, tsc: Add static (MSR) TSC calibration on Intel Atom SoCs

David E. Box (1):
      arch: x86: New MailBox support driver for Intel SOC's

H. Peter Anvin (1):
      x86, tsc, apic: Unbreak static (MSR) calibration when CONFIG_X86_LOCAL_APIC=n


 arch/x86/Kconfig                |   8 ++
 arch/x86/include/asm/iosf_mbi.h |  90 ++++++++++++++++
 arch/x86/include/asm/tsc.h      |   3 +
 arch/x86/kernel/Makefile        |   3 +-
 arch/x86/kernel/iosf_mbi.c      | 226 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tsc.c           |  10 ++
 arch/x86/kernel/tsc_msr.c       | 127 ++++++++++++++++++++++
 7 files changed, 466 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/iosf_mbi.h
 create mode 100644 arch/x86/kernel/iosf_mbi.c
 create mode 100644 arch/x86/kernel/tsc_msr.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0952ecd..ca5959a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2393,6 +2393,14 @@ config X86_DMA_REMAP
 	bool
 	depends on STA2X11
 
+config IOSF_MBI
+	bool
+	depends on PCI
+	---help---
+	  To be selected by modules requiring access to the Intel OnChip System
+	  Fabric (IOSF) Sideband MailBox Interface (MBI). For MBI platforms
+	  enumerable by PCI.
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
new file mode 100644
index 0000000..8e71c79
--- /dev/null
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -0,0 +1,90 @@
+/*
+ * iosf_mbi.h: Intel OnChip System Fabric MailBox access support
+ */
+
+#ifndef IOSF_MBI_SYMS_H
+#define IOSF_MBI_SYMS_H
+
+#define MBI_MCR_OFFSET		0xD0
+#define MBI_MDR_OFFSET		0xD4
+#define MBI_MCRX_OFFSET		0xD8
+
+#define MBI_RD_MASK		0xFEFFFFFF
+#define MBI_WR_MASK		0X01000000
+
+#define MBI_MASK_HI		0xFFFFFF00
+#define MBI_MASK_LO		0x000000FF
+#define MBI_ENABLE		0xF0
+
+/* Baytrail available units */
+#define BT_MBI_UNIT_AUNIT	0x00
+#define BT_MBI_UNIT_SMC		0x01
+#define BT_MBI_UNIT_CPU		0x02
+#define BT_MBI_UNIT_BUNIT	0x03
+#define BT_MBI_UNIT_PMC		0x04
+#define BT_MBI_UNIT_GFX		0x06
+#define BT_MBI_UNIT_SMI		0x0C
+#define BT_MBI_UNIT_USB		0x43
+#define BT_MBI_UNIT_SATA	0xA3
+#define BT_MBI_UNIT_PCIE	0xA6
+
+/* Baytrail read/write opcodes */
+#define BT_MBI_AUNIT_READ	0x10
+#define BT_MBI_AUNIT_WRITE	0x11
+#define BT_MBI_SMC_READ		0x10
+#define BT_MBI_SMC_WRITE	0x11
+#define BT_MBI_CPU_READ		0x10
+#define BT_MBI_CPU_WRITE	0x11
+#define BT_MBI_BUNIT_READ	0x10
+#define BT_MBI_BUNIT_WRITE	0x11
+#define BT_MBI_PMC_READ		0x06
+#define BT_MBI_PMC_WRITE	0x07
+#define BT_MBI_GFX_READ		0x00
+#define BT_MBI_GFX_WRITE	0x01
+#define BT_MBI_SMIO_READ	0x06
+#define BT_MBI_SMIO_WRITE	0x07
+#define BT_MBI_USB_READ		0x06
+#define BT_MBI_USB_WRITE	0x07
+#define BT_MBI_SATA_READ	0x00
+#define BT_MBI_SATA_WRITE	0x01
+#define BT_MBI_PCIE_READ	0x00
+#define BT_MBI_PCIE_WRITE	0x01
+
+/**
+ * iosf_mbi_read() - MailBox Interface read command
+ * @port:	port indicating subunit being accessed
+ * @opcode:	port specific read or write opcode
+ * @offset:	register address offset
+ * @mdr:	register data to be read
+ *
+ * Locking is handled by spinlock - cannot sleep.
+ * Return: Nonzero on error
+ */
+int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr);
+
+/**
+ * iosf_mbi_write() - MailBox unmasked write command
+ * @port:	port indicating subunit being accessed
+ * @opcode:	port specific read or write opcode
+ * @offset:	register address offset
+ * @mdr:	register data to be written
+ *
+ * Locking is handled by spinlock - cannot sleep.
+ * Return: Nonzero on error
+ */
+int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
+
+/**
+ * iosf_mbi_modify() - MailBox masked write command
+ * @port:	port indicating subunit being accessed
+ * @opcode:	port specific read or write opcode
+ * @offset:	register address offset
+ * @mdr:	register data being modified
+ * @mask:	mask indicating bits in mdr to be modified
+ *
+ * Locking is handled by spinlock - cannot sleep.
+ * Return: Nonzero on error
+ */
+int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
+
+#endif /* IOSF_MBI_SYMS_H */
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 235be70..57ae63c 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -65,4 +65,7 @@ extern int notsc_setup(char *);
 extern void tsc_save_sched_clock_state(void);
 extern void tsc_restore_sched_clock_state(void);
 
+/* MSR based TSC calibration for Intel Atom SoC platforms */
+int try_msr_calibrate_tsc(unsigned long *fast_calibrate);
+
 #endif /* _ASM_X86_TSC_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b0a34e..6dbbb1e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
-obj-y			+= tsc.o io_delay.o rtc.o
+obj-y			+= tsc.o tsc_msr.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
@@ -111,6 +111,7 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
+obj-$(CONFIG_IOSF_MBI)			+= iosf_mbi.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
new file mode 100644
index 0000000..c3aae66
--- /dev/null
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -0,0 +1,226 @@
+/*
+ * IOSF-SB MailBox Interface Driver
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ *
+ * The IOSF-SB is a fabric bus available on Atom based SOC's that uses a
+ * mailbox interface (MBI) to communicate with mutiple devices. This
+ * driver implements access to this interface for those platforms that can
+ * enumerate the device using PCI.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+
+#include <asm/iosf_mbi.h>
+
+static DEFINE_SPINLOCK(iosf_mbi_lock);
+
+static inline u32 iosf_mbi_form_mcr(u8 op, u8 port, u8 offset)
+{
+	return (op << 24) | (port << 16) | (offset << 8) | MBI_ENABLE;
+}
+
+static struct pci_dev *mbi_pdev;	/* one mbi device */
+
+static int iosf_mbi_pci_read_mdr(u32 mcrx, u32 mcr, u32 *mdr)
+{
+	int result;
+
+	if (!mbi_pdev)
+		return -ENODEV;
+
+	if (mcrx) {
+		result = pci_write_config_dword(mbi_pdev, MBI_MCRX_OFFSET,
+						mcrx);
+		if (result < 0)
+			goto fail_read;
+	}
+
+	result = pci_write_config_dword(mbi_pdev, MBI_MCR_OFFSET, mcr);
+	if (result < 0)
+		goto fail_read;
+
+	result = pci_read_config_dword(mbi_pdev, MBI_MDR_OFFSET, mdr);
+	if (result < 0)
+		goto fail_read;
+
+	return 0;
+
+fail_read:
+	dev_err(&mbi_pdev->dev, "PCI config access failed with %d\n", result);
+	return result;
+}
+
+static int iosf_mbi_pci_write_mdr(u32 mcrx, u32 mcr, u32 mdr)
+{
+	int result;
+
+	if (!mbi_pdev)
+		return -ENODEV;
+
+	result = pci_write_config_dword(mbi_pdev, MBI_MDR_OFFSET, mdr);
+	if (result < 0)
+		goto fail_write;
+
+	if (mcrx) {
+		result = pci_write_config_dword(mbi_pdev, MBI_MCRX_OFFSET,
+						mcrx);
+		if (result < 0)
+			goto fail_write;
+	}
+
+	result = pci_write_config_dword(mbi_pdev, MBI_MCR_OFFSET, mcr);
+	if (result < 0)
+		goto fail_write;
+
+	return 0;
+
+fail_write:
+	dev_err(&mbi_pdev->dev, "PCI config access failed with %d\n", result);
+	return result;
+}
+
+int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
+{
+	u32 mcr, mcrx;
+	unsigned long flags;
+	int ret;
+
+	/*Access to the GFX unit is handled by GPU code */
+	if (port == BT_MBI_UNIT_GFX) {
+		WARN_ON(1);
+		return -EPERM;
+	}
+
+	mcr = iosf_mbi_form_mcr(opcode, port, offset & MBI_MASK_LO);
+	mcrx = offset & MBI_MASK_HI;
+
+	spin_lock_irqsave(&iosf_mbi_lock, flags);
+	ret = iosf_mbi_pci_read_mdr(mcrx, mcr, mdr);
+	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(iosf_mbi_read);
+
+int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
+{
+	u32 mcr, mcrx;
+	unsigned long flags;
+	int ret;
+
+	/*Access to the GFX unit is handled by GPU code */
+	if (port == BT_MBI_UNIT_GFX) {
+		WARN_ON(1);
+		return -EPERM;
+	}
+
+	mcr = iosf_mbi_form_mcr(opcode, port, offset & MBI_MASK_LO);
+	mcrx = offset & MBI_MASK_HI;
+
+	spin_lock_irqsave(&iosf_mbi_lock, flags);
+	ret = iosf_mbi_pci_write_mdr(mcrx, mcr, mdr);
+	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(iosf_mbi_write);
+
+int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
+{
+	u32 mcr, mcrx;
+	u32 value;
+	unsigned long flags;
+	int ret;
+
+	/*Access to the GFX unit is handled by GPU code */
+	if (port == BT_MBI_UNIT_GFX) {
+		WARN_ON(1);
+		return -EPERM;
+	}
+
+	mcr = iosf_mbi_form_mcr(opcode, port, offset & MBI_MASK_LO);
+	mcrx = offset & MBI_MASK_HI;
+
+	spin_lock_irqsave(&iosf_mbi_lock, flags);
+
+	/* Read current mdr value */
+	ret = iosf_mbi_pci_read_mdr(mcrx, mcr & MBI_RD_MASK, &value);
+	if (ret < 0) {
+		spin_unlock_irqrestore(&iosf_mbi_lock, flags);
+		return ret;
+	}
+
+	/* Apply mask */
+	value &= ~mask;
+	mdr &= mask;
+	value |= mdr;
+
+	/* Write back */
+	ret = iosf_mbi_pci_write_mdr(mcrx, mcr | MBI_WR_MASK, value);
+
+	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(iosf_mbi_modify);
+
+static int iosf_mbi_probe(struct pci_dev *pdev,
+			  const struct pci_device_id *unused)
+{
+	int ret;
+
+	ret = pci_enable_device(pdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "error: could not enable device\n");
+		return ret;
+	}
+
+	mbi_pdev = pci_dev_get(pdev);
+	return 0;
+}
+
+static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);
+
+static struct pci_driver iosf_mbi_pci_driver = {
+	.name		= "iosf_mbi_pci",
+	.probe		= iosf_mbi_probe,
+	.id_table	= iosf_mbi_pci_ids,
+};
+
+static int __init iosf_mbi_init(void)
+{
+	return pci_register_driver(&iosf_mbi_pci_driver);
+}
+
+static void __exit iosf_mbi_exit(void)
+{
+	pci_unregister_driver(&iosf_mbi_pci_driver);
+	if (mbi_pdev) {
+		pci_dev_put(mbi_pdev);
+		mbi_pdev = NULL;
+	}
+}
+
+module_init(iosf_mbi_init);
+module_exit(iosf_mbi_exit);
+
+MODULE_AUTHOR("David E. Box <david.e.box@linux.intel.com>");
+MODULE_DESCRIPTION("IOSF Mailbox Interface accessor");
+MODULE_LICENSE("GPL v2");
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d4..e574716 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -419,6 +419,16 @@ unsigned long native_calibrate_tsc(void)
 	unsigned long flags, latch, ms, fast_calibrate;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
+	/* Calibrate TSC using MSR for Intel Atom SoCs */
+	local_irq_save(flags);
+	i = try_msr_calibrate_tsc(&fast_calibrate);
+	local_irq_restore(flags);
+	if (i >= 0) {
+		if (i == 0)
+			pr_warn("Fast TSC calibration using MSR failed\n");
+		return fast_calibrate;
+	}
+
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);
diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
new file mode 100644
index 0000000..8b5434f
--- /dev/null
+++ b/arch/x86/kernel/tsc_msr.c
@@ -0,0 +1,127 @@
+/*
+ * tsc_msr.c - MSR based TSC calibration on Intel Atom SoC platforms.
+ *
+ * TSC in Intel Atom SoC runs at a constant rate which can be figured
+ * by this formula:
+ * <maximum core-clock to bus-clock ratio> * <maximum resolved frequency>
+ * See Intel 64 and IA-32 System Programming Guid section 16.12 and 30.11.5
+ * for details.
+ * Especially some Intel Atom SoCs don't have PIT(i8254) or HPET, so MSR
+ * based calibration is the only option.
+ *
+ *
+ * Copyright (C) 2013 Intel Corporation
+ * Author: Bin Gao <bin.gao@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/param.h>
+
+/* CPU reference clock frequency: in KHz */
+#define FREQ_83		83200
+#define FREQ_100	99840
+#define FREQ_133	133200
+#define FREQ_166	166400
+
+#define MAX_NUM_FREQS	8
+
+/*
+ * According to Intel 64 and IA-32 System Programming Guide,
+ * if MSR_PERF_STAT[31] is set, the maximum resolved bus ratio can be
+ * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
+ * Unfortunately some Intel Atom SoCs aren't quite compliant to this,
+ * so we need manually differentiate SoC families. This is what the
+ * field msr_plat does.
+ */
+struct freq_desc {
+	u8 x86_family;	/* CPU family */
+	u8 x86_model;	/* model */
+	u8 msr_plat;	/* 1: use MSR_PLATFORM_INFO, 0: MSR_IA32_PERF_STATUS */
+	u32 freqs[MAX_NUM_FREQS];
+};
+
+static struct freq_desc freq_desc_tables[] = {
+	/* PNW */
+	{ 6, 0x27, 0, { 0, 0, 0, 0, 0, FREQ_100, 0, FREQ_83 } },
+	/* CLV+ */
+	{ 6, 0x35, 0, { 0, FREQ_133, 0, 0, 0, FREQ_100, 0, FREQ_83 } },
+	/* TNG */
+	{ 6, 0x4a, 1, { 0, FREQ_100, FREQ_133, 0, 0, 0, 0, 0 } },
+	/* VLV2 */
+	{ 6, 0x37, 1, { 0, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
+	/* ANN */
+	{ 6, 0x5a, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_100, 0, 0, 0, 0 } },
+};
+
+static int match_cpu(u8 family, u8 model)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(freq_desc_tables); i++) {
+		if ((family == freq_desc_tables[i].x86_family) &&
+			(model == freq_desc_tables[i].x86_model))
+			return i;
+	}
+
+	return -1;
+}
+
+/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
+#define id_to_freq(cpu_index, freq_id) \
+	(freq_desc_tables[cpu_index].freqs[freq_id])
+
+/*
+ * Do MSR calibration only for known/supported CPUs.
+ * Return values:
+ * -1: CPU is unknown/unsupported for MSR based calibration
+ *  0: CPU is known/supported, but calibration failed
+ *  1: CPU is known/supported, and calibration succeeded
+ */
+int try_msr_calibrate_tsc(unsigned long *fast_calibrate)
+{
+	int cpu_index;
+	u32 lo, hi, ratio, freq_id, freq;
+
+	cpu_index = match_cpu(boot_cpu_data.x86, boot_cpu_data.x86_model);
+	if (cpu_index < 0)
+		return -1;
+
+	*fast_calibrate = 0;
+
+	if (freq_desc_tables[cpu_index].msr_plat) {
+		rdmsr(MSR_PLATFORM_INFO, lo, hi);
+		ratio = (lo >> 8) & 0x1f;
+	} else {
+		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
+		ratio = (hi >> 8) & 0x1f;
+	}
+	pr_info("Maximum core-clock to bus-clock ratio: 0x%x\n", ratio);
+
+	if (!ratio)
+		return 0;
+
+	/* Get FSB FREQ ID */
+	rdmsr(MSR_FSB_FREQ, lo, hi);
+	freq_id = lo & 0x7;
+	freq = id_to_freq(cpu_index, freq_id);
+	pr_info("Resolved frequency ID: %u, frequency: %u KHz\n",
+				freq_id, freq);
+	if (!freq)
+		return 0;
+
+	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
+	*fast_calibrate = freq * ratio;
+	pr_info("TSC runs at %lu KHz\n", *fast_calibrate);
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	lapic_timer_frequency = (freq * 1000) / HZ;
+	pr_info("lapic_timer_frequency = %d\n", lapic_timer_frequency);
+#endif
+
+	return 1;
+}
