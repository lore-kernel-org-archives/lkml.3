Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaCDFnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:43:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:17502 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaCDFnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:43:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,583,1389772800"; 
   d="scan'208";a="493587984"
From: "David E. Box" <david.e.box@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH] Revert "X86 platform: New BayTrail IOSF-SB MBI driver"
Date: Mon,  3 Mar 2014 21:41:43 -0800
Message-Id: <1393911703-31691-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

This reverts commit 997ab407d2b4e7d7ce2788d2de68435eb94fcfec. This driver is
replaced by the more general SOC IOSF driver in commit 46184415368a.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 drivers/platform/x86/Kconfig          |    8 --
 drivers/platform/x86/Makefile         |    1 -
 drivers/platform/x86/intel_baytrail.c |  224 ---------------------------------
 drivers/platform/x86/intel_baytrail.h |   90 -------------
 4 files changed, 323 deletions(-)
 delete mode 100644 drivers/platform/x86/intel_baytrail.c
 delete mode 100644 drivers/platform/x86/intel_baytrail.h

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 5ae65c1..aee5f72 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -819,12 +819,4 @@ config PVPANIC
 	  a paravirtualized device provided by QEMU; it lets a virtual machine
 	  (guest) communicate panic events to the host.
 
-config INTEL_BAYTRAIL_MBI
-	tristate
-	depends on PCI
-	---help---
-	  Needed on Baytrail platforms for access to the IOSF Sideband Mailbox
-	  Interface. This is a requirement for systems that need to configure
-	  the PUNIT for power management features such as RAPL.
-
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 9b87cfc..b8c36f7 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -55,4 +55,3 @@ obj-$(CONFIG_INTEL_RST)		+= intel-rst.o
 obj-$(CONFIG_INTEL_SMARTCONNECT)	+= intel-smartconnect.o
 
 obj-$(CONFIG_PVPANIC)           += pvpanic.o
-obj-$(CONFIG_INTEL_BAYTRAIL_MBI)	+= intel_baytrail.o
diff --git a/drivers/platform/x86/intel_baytrail.c b/drivers/platform/x86/intel_baytrail.c
deleted file mode 100644
index f96626b..0000000
--- a/drivers/platform/x86/intel_baytrail.c
+++ /dev/null
@@ -1,224 +0,0 @@
-/*
- * Baytrail IOSF-SB MailBox Interface Driver
- * Copyright (c) 2013, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- *
- * The IOSF-SB is a fabric bus available on Atom based SOC's that uses a
- * mailbox interface (MBI) to communicate with mutiple devices. This
- * driver implements BayTrail-specific access to this interface.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/pci.h>
-
-#include "intel_baytrail.h"
-
-static DEFINE_SPINLOCK(iosf_mbi_lock);
-
-static inline u32 iosf_mbi_form_mcr(u8 op, u8 port, u8 offset)
-{
-	return (op << 24) | (port << 16) | (offset << 8) | BT_MBI_ENABLE;
-}
-
-static struct pci_dev *mbi_pdev;	/* one mbi device */
-
-/* Hold lock before calling */
-static int iosf_mbi_pci_read_mdr(u32 mcrx, u32 mcr, u32 *mdr)
-{
-	int result;
-
-	if (!mbi_pdev)
-		return -ENODEV;
-
-	if (mcrx) {
-		result = pci_write_config_dword(mbi_pdev,
-						BT_MBI_MCRX_OFFSET, mcrx);
-		if (result < 0)
-			goto iosf_mbi_read_err;
-	}
-
-	result = pci_write_config_dword(mbi_pdev,
-					BT_MBI_MCR_OFFSET, mcr);
-	if (result < 0)
-		goto iosf_mbi_read_err;
-
-	result = pci_read_config_dword(mbi_pdev,
-				       BT_MBI_MDR_OFFSET, mdr);
-	if (result < 0)
-		goto iosf_mbi_read_err;
-
-	return 0;
-
-iosf_mbi_read_err:
-	dev_err(&mbi_pdev->dev, "error: PCI config operation returned %d\n",
-		result);
-	return result;
-}
-
-/* Hold lock before calling */
-static int iosf_mbi_pci_write_mdr(u32 mcrx, u32 mcr, u32 mdr)
-{
-	int result;
-
-	if (!mbi_pdev)
-		return -ENODEV;
-
-	result = pci_write_config_dword(mbi_pdev,
-					BT_MBI_MDR_OFFSET, mdr);
-	if (result < 0)
-		goto iosf_mbi_write_err;
-
-	if (mcrx) {
-		result = pci_write_config_dword(mbi_pdev,
-			 BT_MBI_MCRX_OFFSET, mcrx);
-		if (result < 0)
-			goto iosf_mbi_write_err;
-	}
-
-	result = pci_write_config_dword(mbi_pdev,
-					BT_MBI_MCR_OFFSET, mcr);
-	if (result < 0)
-		goto iosf_mbi_write_err;
-
-	return 0;
-
-iosf_mbi_write_err:
-	dev_err(&mbi_pdev->dev, "error: PCI config operation returned %d\n",
-		result);
-	return result;
-}
-
-int bt_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
-{
-	u32 mcr, mcrx;
-	unsigned long flags;
-	int ret;
-
-	/*Access to the GFX unit is handled by GPU code */
-	BUG_ON(port == BT_MBI_UNIT_GFX);
-
-	mcr = iosf_mbi_form_mcr(opcode, port, offset & BT_MBI_MASK_LO);
-	mcrx = offset & BT_MBI_MASK_HI;
-
-	spin_lock_irqsave(&iosf_mbi_lock, flags);
-	ret = iosf_mbi_pci_read_mdr(mcrx, mcr, mdr);
-	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(bt_mbi_read);
-
-int bt_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
-{
-	u32 mcr, mcrx;
-	unsigned long flags;
-	int ret;
-
-	/*Access to the GFX unit is handled by GPU code */
-	BUG_ON(port == BT_MBI_UNIT_GFX);
-
-	mcr = iosf_mbi_form_mcr(opcode, port, offset & BT_MBI_MASK_LO);
-	mcrx = offset & BT_MBI_MASK_HI;
-
-	spin_lock_irqsave(&iosf_mbi_lock, flags);
-	ret = iosf_mbi_pci_write_mdr(mcrx, mcr, mdr);
-	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(bt_mbi_write);
-
-int bt_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
-{
-	u32 mcr, mcrx;
-	u32 value;
-	unsigned long flags;
-	int ret;
-
-	/*Access to the GFX unit is handled by GPU code */
-	BUG_ON(port == BT_MBI_UNIT_GFX);
-
-	mcr = iosf_mbi_form_mcr(opcode, port, offset & BT_MBI_MASK_LO);
-	mcrx = offset & BT_MBI_MASK_HI;
-
-	spin_lock_irqsave(&iosf_mbi_lock, flags);
-
-	/* Read current mdr value */
-	ret = iosf_mbi_pci_read_mdr(mcrx, mcr & BT_MBI_RD_MASK, &value);
-	if (ret < 0) {
-		spin_unlock_irqrestore(&iosf_mbi_lock, flags);
-		return ret;
-	}
-
-	/* Apply mask */
-	value &= ~mask;
-	mdr &= mask;
-	value |= mdr;
-
-	/* Write back */
-	ret = iosf_mbi_pci_write_mdr(mcrx, mcr | BT_MBI_WR_MASK, value);
-
-	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(bt_mbi_modify);
-
-static int iosf_mbi_probe(struct pci_dev *pdev,
-			  const struct pci_device_id *unused)
-{
-	int ret;
-
-	ret = pci_enable_device(pdev);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "error: could not enable device\n");
-		return ret;
-	}
-
-	mbi_pdev = pci_dev_get(pdev);
-	return 0;
-}
-
-static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
-	{ 0, },
-};
-MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);
-
-static struct pci_driver iosf_mbi_pci_driver = {
-	.name		= "iosf_mbi_pci",
-	.probe		= iosf_mbi_probe,
-	.id_table	= iosf_mbi_pci_ids,
-};
-
-static int __init bt_mbi_init(void)
-{
-	return pci_register_driver(&iosf_mbi_pci_driver);
-}
-
-static void __exit bt_mbi_exit(void)
-{
-	pci_unregister_driver(&iosf_mbi_pci_driver);
-	if (mbi_pdev) {
-		pci_dev_put(mbi_pdev);
-		mbi_pdev = NULL;
-	}
-}
-
-module_init(bt_mbi_init);
-module_exit(bt_mbi_exit);
-
-MODULE_AUTHOR("David E. Box <david.e.box@linux.intel.com>");
-MODULE_DESCRIPTION("BayTrail Mailbox Interface accessor");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/intel_baytrail.h b/drivers/platform/x86/intel_baytrail.h
deleted file mode 100644
index 8bcc311..0000000
--- a/drivers/platform/x86/intel_baytrail.h
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * intel_baytrail.h: MailBox access support for Intel BayTrail platforms
- */
-
-#ifndef INTEL_BAYTRAIL_MBI_SYMS_H
-#define INTEL_BAYTRAIL_MBI_SYMS_H
-
-#define BT_MBI_MCR_OFFSET	0xD0
-#define BT_MBI_MDR_OFFSET	0xD4
-#define BT_MBI_MCRX_OFFSET	0xD8
-
-#define BT_MBI_RD_MASK		0xFEFFFFFF
-#define BT_MBI_WR_MASK		0X01000000
-
-#define BT_MBI_MASK_HI		0xFFFFFF00
-#define BT_MBI_MASK_LO		0x000000FF
-#define BT_MBI_ENABLE		0xF0
-
-/* BT-SB unit access methods */
-#define BT_MBI_UNIT_AUNIT	0x00
-#define BT_MBI_UNIT_SMC		0x01
-#define BT_MBI_UNIT_CPU		0x02
-#define BT_MBI_UNIT_BUNIT	0x03
-#define BT_MBI_UNIT_PMC		0x04
-#define BT_MBI_UNIT_GFX		0x06
-#define BT_MBI_UNIT_SMI		0x0C
-#define BT_MBI_UNIT_USB		0x43
-#define BT_MBI_UNIT_SATA	0xA3
-#define BT_MBI_UNIT_PCIE	0xA6
-
-/* Read/write opcodes */
-#define BT_MBI_AUNIT_READ	0x10
-#define BT_MBI_AUNIT_WRITE	0x11
-#define BT_MBI_SMC_READ		0x10
-#define BT_MBI_SMC_WRITE	0x11
-#define BT_MBI_CPU_READ		0x10
-#define BT_MBI_CPU_WRITE	0x11
-#define BT_MBI_BUNIT_READ	0x10
-#define BT_MBI_BUNIT_WRITE	0x11
-#define BT_MBI_PMC_READ		0x06
-#define BT_MBI_PMC_WRITE	0x07
-#define BT_MBI_GFX_READ		0x00
-#define BT_MBI_GFX_WRITE	0x01
-#define BT_MBI_SMIO_READ	0x06
-#define BT_MBI_SMIO_WRITE	0x07
-#define BT_MBI_USB_READ		0x06
-#define BT_MBI_USB_WRITE	0x07
-#define BT_MBI_SATA_READ	0x00
-#define BT_MBI_SATA_WRITE	0x01
-#define BT_MBI_PCIE_READ	0x00
-#define BT_MBI_PCIE_WRITE	0x01
-
-/**
- * bt_mbi_read() - MailBox Interface read command
- * @port:	port indicating subunit being accessed
- * @opcode:	port specific read or write opcode
- * @offset:	register address offset
- * @mdr:	register data to be read
- *
- * Locking is handled by spinlock - cannot sleep.
- * Return: Nonzero on error
- */
-int bt_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr);
-
-/**
- * bt_mbi_write() - MailBox unmasked write command
- * @port:	port indicating subunit being accessed
- * @opcode:	port specific read or write opcode
- * @offset:	register address offset
- * @mdr:	register data to be written
- *
- * Locking is handled by spinlock - cannot sleep.
- * Return: Nonzero on error
- */
-int bt_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
-
-/**
- * bt_mbi_modify() - MailBox masked write command
- * @port:	port indicating subunit being accessed
- * @opcode:	port specific read or write opcode
- * @offset:	register address offset
- * @mdr:	register data being modified
- * @mask:	mask indicating bits in mdr to be modified
- *
- * Locking is handled by spinlock - cannot sleep.
- * Return: Nonzero on error
- */
-int bt_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
-
-#endif /* INTEL_BAYTRAIL_MBI_SYMS_H */
-- 
1.7.10.4

