Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3LEUFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:05:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:27568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3LEUFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:05:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="420082586"
From: "David E. Box" <david.e.box@linux.intel.com>
To: mjg59@srcf.ucam.org, rjw@rjwysocki.net
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>
Subject: [PATCH] X86 platform: New IOSF-SB MBI driver for Intel SOCs
Date: Thu,  5 Dec 2013 12:01:46 -0800
Message-Id: <1386273706-26343-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
References: <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

Current Intel SOC cores use a MailBox Interface (MBI) to provide access to unit
devices connected to the system fabric. This driver implements the API required
for other kernel drivers to configure the unit registers accessible through this
interface. Drivers requiring access to the MBI include RAPL as well as future
drivers. Serialized access is handled by all exported routines with spinlocks.

The API includes 3 functions for access to unit registers:

u32 iosf_mbi_read(u8 port, u8 opcode, u32 offset)
void iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
void iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)

port:	indicating the unit being accessed
opcode:	the read or write port specific opcode
offset:	the register offset within the port
mdr:	the register data to be written, or modified
mask:	bit locations in mdr to change

Note: GPU code handles access to the GFX unit. Therefore access to that unit
with this driver is disallowed to avoid conflicts.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
v3: Converted to PNP ACPI driver as sugessted by Rafael Wysocki <rjw@rjwysocki.net>
    Removed config visibility to user as suggested by Andi Kleen <andi@firstfloor.org>

v2: Made modular since there was no longer a reason not to
    Moved to x86 platform as suggested by Mathhew Garrett <mjg59@srcf.ucam.org>
    Added probe to init to cause driver load to fail if device not detected.

 drivers/platform/x86/Kconfig    |    9 ++
 drivers/platform/x86/Makefile   |    1 +
 drivers/platform/x86/iosf_mbi.c |  188 +++++++++++++++++++++++++++++++++++++++
 drivers/platform/x86/iosf_mbi.h |   89 ++++++++++++++++++
 4 files changed, 287 insertions(+)
 create mode 100644 drivers/platform/x86/iosf_mbi.c
 create mode 100644 drivers/platform/x86/iosf_mbi.h

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index b51a746..ba6c316 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -819,4 +819,13 @@ config PVPANIC
 	  a paravirtualized device provided by QEMU; it lets a virtual machine
 	  (guest) communicate panic events to the host.
 
+config INTEL_IOSF_MBI
+	tristate
+	depends on PNP
+	depends on ACPI
+	---help---
+	  This device provides access to the Intel On-Chip System Fabric
+	  Sideband MailBox Interface which required for the configuration of
+	  some unit devices connected on the fabric.
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 5dbe193..9b8e8b8 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_INTEL_RST)		+= intel-rst.o
 obj-$(CONFIG_INTEL_SMARTCONNECT)	+= intel-smartconnect.o
 
 obj-$(CONFIG_PVPANIC)           += pvpanic.o
+obj-$(CONFIG_INTEL_IOSF_MBI)	+= iosf_mbi.o
diff --git a/drivers/platform/x86/iosf_mbi.c b/drivers/platform/x86/iosf_mbi.c
new file mode 100644
index 0000000..7936812
--- /dev/null
+++ b/drivers/platform/x86/iosf_mbi.c
@@ -0,0 +1,188 @@
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
+ * driver implements access to this interface.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/pnp.h>
+
+#include "iosf_mbi.h"
+
+static DEFINE_SPINLOCK(iosf_mbi_lock);
+
+static inline u32 iosf_mbi_form_mcr(u8 op, u8 port, u8 offset)
+{
+	return (op << 24) | (port << 16) | (offset << 8) | IOSF_MBI_ENABLE;
+}
+
+static struct {
+	void __iomem *addr;
+	bool probed;
+} iosf_mbi_data;
+
+/* Hold lock before calling */
+static u32 iosf_mbi_read_mdr(u32 mcrx, u32 mcr, void __iomem *addr)
+{
+	if (mcrx)
+		iowrite32(mcrx, addr + IOSF_MBI_MCRX_OFFSET);
+	iowrite32(mcr, addr + IOSF_MBI_MCR_OFFSET);
+	return ioread32(addr + IOSF_MBI_MDR_OFFSET);
+}
+
+/* Hold lock before calling */
+static void iosf_mbi_write_mdr(u32 mcrx, u32 mcr, u32 mdr, void __iomem *addr)
+{
+
+	iowrite32(mdr, addr + IOSF_MBI_MDR_OFFSET);
+	if (mcrx)
+		iowrite32(mcrx, addr + IOSF_MBI_MCRX_OFFSET);
+	iowrite32(mcr, addr + IOSF_MBI_MCR_OFFSET);
+}
+
+u32 iosf_mbi_read(u8 port, u8 opcode, u32 offset)
+{
+	u32 mcr, mcrx;
+	u32 ret;
+	unsigned long flags;
+
+	/*Access to the GFX unit is handled by GPU code */
+	BUG_ON(port == IOSF_MBI_UNIT_GFX);
+
+	mcr = iosf_mbi_form_mcr(opcode, port, offset & IOSF_MBI_MASK_LO);
+	mcrx = offset & IOSF_MBI_MASK_HI;
+
+	spin_lock_irqsave(&iosf_mbi_lock, flags);
+	ret = iosf_mbi_read_mdr(mcrx, mcr, iosf_mbi_data.addr);
+	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(iosf_mbi_read);
+
+void iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
+{
+	u32 mcr, mcrx;
+	unsigned long flags;
+
+	/*Access to the GFX unit is handled by GPU code */
+	BUG_ON(port == IOSF_MBI_UNIT_GFX);
+
+	mcr = iosf_mbi_form_mcr(opcode, port, offset & IOSF_MBI_MASK_LO);
+	mcrx = offset & IOSF_MBI_MASK_HI;
+
+	spin_lock_irqsave(&iosf_mbi_lock, flags);
+	iosf_mbi_write_mdr(mcrx, mcr, mdr, iosf_mbi_data.addr);
+	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
+}
+EXPORT_SYMBOL(iosf_mbi_write);
+
+void iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
+{
+	u32 mcr, mcrx;
+	u32 value;
+	unsigned long flags;
+
+	/*Access to the GFX unit is handled by GPU code */
+	BUG_ON(port == IOSF_MBI_UNIT_GFX);
+
+	mcr = iosf_mbi_form_mcr(opcode, port, offset & IOSF_MBI_MASK_LO);
+	mcrx = offset & IOSF_MBI_MASK_HI;
+
+	spin_lock_irqsave(&iosf_mbi_lock, flags);
+
+	/* Read current mdr value */
+	value = iosf_mbi_read_mdr(mcrx, mcr & IOSF_MBI_RD_MASK,
+				  iosf_mbi_data.addr);
+
+	/* Apply mask */
+	value &= ~mask;
+	mdr &= mask;
+	value |= mdr;
+
+	/* Write back */
+	iosf_mbi_write_mdr(mcrx, mcr | IOSF_MBI_WR_MASK, value,
+			   iosf_mbi_data.addr);
+
+	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
+}
+EXPORT_SYMBOL(iosf_mbi_modify);
+
+static int iosf_mbi_pnp_probe(struct pnp_dev *pnp,
+			      const struct pnp_device_id *dev_id)
+{
+	struct resource *mem;
+
+	/* Get and map MBI address space */
+	mem = pnp_get_resource(pnp, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -ENOMEM;
+
+	iosf_mbi_data.addr = devm_ioremap_resource(&pnp->dev, mem);
+	if (IS_ERR(iosf_mbi_data.addr))
+		return PTR_ERR(iosf_mbi_data.addr);
+
+	iosf_mbi_data.probed = true;
+	return 0;
+}
+
+static void iosf_mbi_pnp_remove(struct pnp_dev *pdev)
+{
+	return;
+}
+
+static const struct pnp_device_id iosf_mbi_dev_table[] = {
+	{ "INT33BD", 0},
+	{ "", 0},
+};
+MODULE_DEVICE_TABLE(pnp, iosf_mbi_dev_table);
+
+static struct pnp_driver iosf_mbi_pnp_driver = {
+	.name		= "iosf_mbi",
+	.probe		= iosf_mbi_pnp_probe,
+	.remove		= iosf_mbi_pnp_remove,
+	.id_table	= iosf_mbi_dev_table,
+};
+
+static int __init iosf_mbi_init(void)
+{
+	int ret;
+
+	iosf_mbi_data.probed = false;
+
+	ret = pnp_register_driver(&iosf_mbi_pnp_driver);
+	if (!ret && !iosf_mbi_data.probed) {
+		pnp_unregister_driver(&iosf_mbi_pnp_driver);
+		return -ENODEV;
+	}
+
+	return ret;
+}
+
+static void __exit iosf_mbi_exit(void)
+{
+	pnp_unregister_driver(&iosf_mbi_pnp_driver);
+}
+
+module_init(iosf_mbi_init);
+module_exit(iosf_mbi_exit);
+
+MODULE_AUTHOR("David Box");
+MODULE_DESCRIPTION("IOSF-SB Message Bus Interface accessor");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/iosf_mbi.h b/drivers/platform/x86/iosf_mbi.h
new file mode 100644
index 0000000..861834f
--- /dev/null
+++ b/drivers/platform/x86/iosf_mbi.h
@@ -0,0 +1,89 @@
+/*
+ * iosf_mbi.h: IOSF MailBox Interface access for Intel SOC's.
+ */
+
+#ifndef INTEL_IOSF_MBI_SYMS_H
+#define INTEL_IOSF_MBI_SYMS_H
+
+#define IOSF_MBI_MCR_OFFSET	0x0
+#define IOSF_MBI_MDR_OFFSET	0x4
+#define IOSF_MBI_MCRX_OFFSET	0x8
+
+#define IOSF_MBI_RD_MASK	0xFEFFFFFF
+#define IOSF_MBI_WR_MASK	0X01000000
+
+#define IOSF_MBI_MASK_HI	0xFFFFFF00
+#define IOSF_MBI_MASK_LO	0x000000FF
+#define IOSF_MBI_ENABLE		0xF0
+
+#define IOSF_MBI_MAX_PORTS	0xFF
+
+/* IOSF-SB unit access methods */
+#define IOSF_MBI_UNIT_AUNIT	0x00
+#define IOSF_MBI_UNIT_SMC	0x01
+#define IOSF_MBI_UNIT_CPU	0x02
+#define IOSF_MBI_UNIT_BUNIT	0x03
+#define IOSF_MBI_UNIT_PMC	0x04
+#define IOSF_MBI_UNIT_GFX	0x06
+#define IOSF_MBI_UNIT_SMI	0x0C
+#define IOSF_MBI_UNIT_USB	0x43
+#define IOSF_MBI_UNIT_SATA	0xA3
+#define IOSF_MBI_UNIT_PCIE	0xA6
+
+/* Read/write opcodes */
+#define IOSF_MBI_AUNIT_READ	0x10
+#define IOSF_MBI_AUNIT_WRITE	0x11
+#define IOSF_MBI_SMC_READ	0x10
+#define IOSF_MBI_SMC_WRITE	0x11
+#define IOSF_MBI_CPU_READ	0x10
+#define IOSF_MBI_CPU_WRITE	0x11
+#define IOSF_MBI_BUNIT_READ	0x10
+#define IOSF_MBI_BUNIT_WRITE	0x11
+#define IOSF_MBI_PMC_READ	0x06
+#define IOSF_MBI_PMC_WRITE	0x07
+#define IOSF_MBI_GFX_READ	0x00
+#define IOSF_MBI_GFX_WRITE	0x01
+#define IOSF_MBI_SMIO_READ	0x06
+#define IOSF_MBI_SMIO_WRITE	0x07
+#define IOSF_MBI_USB_READ	0x06
+#define IOSF_MBI_USB_WRITE	0x07
+#define IOSF_MBI_SATA_READ	0x00
+#define IOSF_MBI_SATA_WRITE	0x01
+#define IOSF_MBI_PCIE_READ	0x00
+#define IOSF_MBI_PCIE_WRITE	0x01
+
+/**
+ * iosf_mbi_read() - IOSF MailBox Interface read command
+ * @port:	port indicating subunit being accessed
+ * @opcode:	port specific read or write opcode
+ * @offset:	register address offset
+ *
+ * Locking is handled by spinlock - cannot sleep.
+ * Return: 32 bit value of mdr register
+ */
+u32 iosf_mbi_read(u8 port, u8 opcode, u32 offset);
+
+/**
+ * iosf_mbi_write() - IOSF MailBox unmasked write command
+ * @port:	port indicating subunit being accessed
+ * @opcode:	port specific read or write opcode
+ * @offset:	register address offset
+ * @mdr:	register data to be written
+ *
+ * Locking is handled by spinlock - cannot sleep.
+ */
+void iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
+
+/**
+ * iosf_mbi_modify() - IOSF MailBox maksed write command
+ * @port:	port indicating subunit being accessed
+ * @opcode:	port specific read or write opcode
+ * @offset:	register address offset
+ * @mdr:	register data being modified
+ * @mask:	mask indicating bits in mdr to be modified
+ *
+ * Locking is handled by spinlock - cannot sleep.
+ */
+void iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
+
+#endif /* INTEL_IOSF_MBI_SYMS_H */
-- 
1.7.10.4

