Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbaAHV3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:29:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:10639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbaAHV3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:29:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,626,1384329600"; 
   d="scan'208";a="463742780"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v7] arch: x86: New MailBox support driver for Intel SOC's
Date: Wed,  8 Jan 2014 13:27:51 -0800
Message-Id: <1389216471-734-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387492666-5398-1-git-send-email-david.e.box@linux.intel.com>
References: <1387492666-5398-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

Current Intel SOC cores use a MailBox Interface (MBI) to provide access to
configuration registers on devices (called units) connected to the system
fabric. This is a support driver that implements access to this interface on
those platforms that can enumerate the device using PCI. Initial support is for
BayTrail, for which port definitons are provided. This is a requirement for
implementing platform specific features (e.g. RAPL driver requires this to
perform platform specific power management using the registers in PUNIT).
Dependant modules should select IOSF_MBI in their respective Kconfig
configuraiton. Serialized access is handled by all exported routines with
spinlocks.

The API includes 3 functions for access to unit registers:

int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)

port:	indicating the unit being accessed
opcode:	the read or write port specific opcode
offset:	the register offset within the port
mdr:	the register data to be read, written, or modified
mask:	bit locations in mdr to change

Returns nonzero on error

Note: GPU code handles access to the GFX unit. Therefore access to that unit
with this driver is disallowed to avoid conflicts.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
v7: Moved to arch/x86 as suggested by Rafael Wysocki <rjw@rjwysocki.net>
    State that the driver supports all platforms that enumerate MBI using PCI
    though pci ids initially just BayTrail.
    Remove platform-specific naming where not required.

v6: Changed BUG_ON to WARN_ON on attempted access to GFX port as suggested by
    Rafael Wysocki <rjw@rjwysocki.net>
    Added line to Kconfig noting available definitions in header.
    Other cosmetic changes suggested by Rafael.

v5: Converted from pnpacpi/mmio driver to pci/config_space driver as
    necessitated by firmware change.

v4: Define driver as platform specific to BayTrail as some platforms cannot
    enumerate the MBI using ACPI as noted by Bin Gao <bin.gao@linux.intel.com>
    Renamed register macros and API funcitons to platform specific names.
    Changed dependency to PNPACPI as suggested by Rafael Wysocki <rjw@rjwysocki.net>

v3: Converted to PNP ACPI driver as suggested by Rafael Wysocki <rjw@rjwysocki.net>
    Removed config visibility to user as suggested by Andi Kleen <andi@firstfloor.org>

v2: Made modular since there was no longer a reason not to
    Moved to x86 platform as suggested by Mathhew Garrett <mjg59@srcf.ucam.org>
    Added probe to init to cause driver load to fail if device not detected.

 arch/x86/Kconfig                |    8 ++
 arch/x86/include/asm/iosf_mbi.h |   90 ++++++++++++++++
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/iosf_mbi.c      |  226 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 325 insertions(+)
 create mode 100644 arch/x86/include/asm/iosf_mbi.h
 create mode 100644 arch/x86/kernel/iosf_mbi.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..d3b1f8b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2384,6 +2384,14 @@ config X86_DMA_REMAP
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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a5408b9..510551e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 
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
-- 
1.7.10.4

