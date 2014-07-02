Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaGBPWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:22:45 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:22542
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753435AbaGBPWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:22:43 -0400
X-WSS-ID: 0N83C1M-08-3M6-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "Marc Zyngier" <Marc.Zyngier@arm.com>
Subject: [PATCH 3/3 V2] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Date: Wed, 2 Jul 2014 10:22:23 -0500
Message-ID: <1404314544-7762-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(77096002)(53416004)(44976005)(92726001)(86152002)(19580405001)(68736004)(83322001)(62966002)(31966008)(20776003)(47776003)(81542001)(81342001)(105586002)(104166001)(95666004)(36756003)(2201001)(50226001)(33646001)(4396001)(19580395003)(92566001)(80022001)(46102001)(101416001)(74662001)(86362001)(77982001)(64706001)(77156001)(85306003)(102836001)(93916002)(79102001)(76482001)(84676001)(50466002)(97736001)(229853001)(74502001)(21056001)(89996001)(99396002)(88136002)(87936001)(48376002)(85852003)(83072002)(87286001)(50986999)(106466001)(107046002)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:BN3PR0201MB0916;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0260457E99
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

ARM GICv2m specification extends GICv2 to support MSI(-X) with
a new set of register frames. This patch introduces support for
the non-secure GICv2m register frame.

The driver currently matchs "arm,gic-400-plus" in device tree binding,
which implements GICv2m.

The "msi-controller" keyword in ARM GIC devicetree binding is used to indentify
GIC driver that it should enable MSI(-X) support, The region of GICv2m MSI
register frame is specified using the register frame index 4 in the device tree.
MSI support is optional.

Each GIC maintains an "msi_chip" structure. To discover the msi_chip,
PCI host driver can do the following:

    struct device_node *gic_node = of_irq_find_parent(pdev->dev.of_node);
    pcie_bus->msi_chip = of_pci_find_msi_chip_by_node(gic_node);

Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 Documentation/devicetree/bindings/arm/gic.txt |  19 +-
 drivers/irqchip/Kconfig                       |   6 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 248 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v2m.h                 |  13 ++
 5 files changed, 284 insertions(+), 3 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.h

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 5573c08..9e46f7f 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -12,11 +12,13 @@ Main node required properties:
 
 - compatible : should be one of:
 	"arm,gic-400"
+	"arm,gic-400-plus"
 	"arm,cortex-a15-gic"
 	"arm,cortex-a9-gic"
 	"arm,cortex-a7-gic"
 	"arm,arm11mp-gic"
 - interrupt-controller : Identifies the node as an interrupt controller
+
 - #interrupt-cells : Specifies the number of cells needed to encode an
   interrupt source.  The type shall be a <u32> and the value shall be 3.
 
@@ -37,9 +39,16 @@ Main node required properties:
 	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
 	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
 
-- reg : Specifies base physical address(s) and size of the GIC registers. The
-  first region is the GIC distributor register base and size. The 2nd region is
-  the GIC cpu interface register base and size.
+- reg : Specifies base physical address(s) and size of the GIC register frames.
+
+  Region | Description
+  Index  |
+  -------------------------------------------------------------------
+     0   | GIC distributor register base and size
+     1   | GIC cpu interface register base and size
+     2   | VGIC interface control register base and size (Optional)
+     3   | VGIC CPU interface register base and size (Optional)
+     4   | GICv2m MSI interface register base and size (Optional)
 
 Optional
 - interrupts	: Interrupt source of the parent interrupt controller on
@@ -55,6 +64,10 @@ Optional
 		  by a crossbar/multiplexer preceding the GIC. The GIC irq
 		  input line is assigned dynamically when the corresponding
 		  peripheral's crossbar line is mapped.
+
+- msi-controller : Identifies the node as an MSI controller.  This requires
+  the register region index 4.
+
 Example:
 
 	intc: interrupt-controller@fff11000 {
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index bbb746e..795d704 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -7,6 +7,12 @@ config ARM_GIC
 	select IRQ_DOMAIN
 	select MULTI_IRQ_HANDLER
 
+config ARM_GIC_V2M
+	bool
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+	depends on PCI && PCI_MSI
+
 config GIC_NON_BANKED
 	bool
 
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 62a13e5..c8a9ca9 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
+obj-$(CONFIG_ARM_GIC_V2M)		+= irq-gic-v2m.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_IMGPDC_IRQ)		+= irq-imgpdc.o
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
new file mode 100644
index 0000000..232a220
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -0,0 +1,248 @@
+/*
+ * ARM GIC v2m MSI support
+ * Support for Message Signalelled Interrupts for systems that
+ * implement ARM Generic Interrupt Controller: GICv2m.
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
+ *          Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
+ *          Brandon Anderson <brandon.anderson@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/bitmap.h>
+
+#include "irqchip.h"
+#include "irq-gic.h"
+#include "gic-msi-v2m.h"
+
+/* GICv2m MSI Registers */
+#define MSI_TYPER			0x008
+#define MSI_SETSPI_NS			0x040
+#define GIC_V2M_MIN_SPI			32
+#define GIC_V2M_MAX_SPI			1024
+#define GIC_OF_MSIV2M_RANGE_INDEX	4
+
+/**
+ * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
+ * @data: Pointer to v2m_data
+ * @nvec: Number of interrupts to allocate
+ * @irq: Pointer to the allocated irq
+ *
+ * Allocates interrupts only if the contiguous range of MSIs
+ * with specified nvec are available. Otherwise return the number
+ * of available interrupts. If none are available, then returns -ENOENT.
+ */
+static int alloc_msi_irq(struct v2m_data *data, int nvec, int *irq)
+{
+	int size = data->nr_spis;
+	int next = size, i = nvec, ret;
+
+	/* We should never allocate more than available nr_spis */
+	if (i >= size)
+		i = size - 1;
+
+	spin_lock(&data->msi_cnt_lock);
+
+	for (; i > 0; i--) {
+		next = bitmap_find_next_zero_area(data->bm,
+					size, 0, i, 0);
+		if (next < size)
+			break;
+	}
+
+	if (next >= size || i != nvec) {
+		ret = i ? : -ENOENT;
+	} else {
+		bitmap_set(data->bm, next, nvec);
+		*irq = data->spi_start + next;
+		ret = 0;
+	}
+
+	spin_unlock(&data->msi_cnt_lock);
+
+	return ret;
+}
+
+static struct v2m_data *to_v2m_data(struct msi_chip *chip)
+{
+	struct gic_chip_data *gic = container_of(chip, struct gic_chip_data,
+						 msi_chip);
+	return &gic->v2m_data;
+}
+
+static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
+{
+	int pos;
+	struct v2m_data *data = to_v2m_data(chip);
+
+	spin_lock(&data->msi_cnt_lock);
+
+	pos = irq - data->spi_start;
+	if (pos >= 0 && pos < data->nr_spis)
+		bitmap_clear(data->bm, pos, 1);
+
+	spin_unlock(&data->msi_cnt_lock);
+}
+
+static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
+		      struct msi_desc *desc)
+{
+	int avail, irq = 0;
+	struct msi_msg msg;
+	phys_addr_t addr;
+	struct v2m_data *data = to_v2m_data(chip);
+
+	if (!desc) {
+		dev_err(&pdev->dev,
+			"GICv2m: MSI setup failed. Invalid msi descriptor\n");
+		return -EINVAL;
+	}
+
+	avail = alloc_msi_irq(data, 1, &irq);
+	if (avail != 0) {
+		dev_err(&pdev->dev,
+			"GICv2m: MSI setup failed. Cannnot allocate IRQ\n");
+		return -ENOSPC;
+	}
+
+	irq_set_chip_data(irq, chip);
+	irq_set_msi_desc(irq, desc);
+	irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
+
+	addr = data->res.start + MSI_SETSPI_NS;
+
+	msg.address_hi = (u32)(addr >> 32);
+	msg.address_lo = (u32)(addr);
+	msg.data = irq;
+#ifdef CONFIG_PCI_MSI
+	write_msi_msg(irq, &msg);
+#endif
+
+	return 0;
+}
+
+static int __init
+gicv2m_msi_init(struct device_node *node, struct v2m_data *v2m)
+{
+	unsigned int val;
+
+	if (of_address_to_resource(node, GIC_OF_MSIV2M_RANGE_INDEX,
+				   &v2m->res)) {
+		pr_err("GICv2m: Failed locate GICv2m MSI register frame\n");
+		return -EINVAL;
+	}
+
+	v2m->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);
+
+	/*
+	* MSI_TYPER:
+	*     [31:26] Reserved
+	*     [25:16] lowest SPI assigned to MSI
+	*     [15:10] Reserved
+	*     [9:0]   Numer of SPIs assigned to MSI
+	*/
+	val = readl_relaxed(v2m->base + MSI_TYPER);
+	if (!val) {
+		pr_warn("GICv2m: Failed to read MSI_TYPER register\n");
+		return -EINVAL;
+	}
+
+	v2m->spi_start = (val >> 16) & 0x3ff;
+	v2m->nr_spis = val & 0x3ff;
+
+	if (v2m->spi_start < GIC_V2M_MIN_SPI ||
+		v2m->nr_spis >= GIC_V2M_MAX_SPI) {
+			pr_err("GICv2m: Init failed\n");
+			return -EINVAL;
+	}
+
+	v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
+			  GFP_KERNEL);
+	if (!v2m->bm)
+		return -ENOMEM;
+
+	spin_lock_init(&v2m->msi_cnt_lock);
+
+	pr_info("GICv2m: SPI range [%d:%d]\n",
+		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
+
+	return 0;
+}
+
+static void gicv2m_mask_irq(struct irq_data *d)
+{
+	gic_mask_irq(d);
+	if (d->msi_desc)
+		mask_msi_irq(d);
+}
+
+static void gicv2m_unmask_irq(struct irq_data *d)
+{
+	gic_unmask_irq(d);
+	if (d->msi_desc)
+		unmask_msi_irq(d);
+}
+
+static struct irq_chip gicv2m_chip = {
+	.name			= "GICv2m",
+	.irq_mask		= gicv2m_mask_irq,
+	.irq_unmask		= gicv2m_unmask_irq,
+	.irq_eoi		= gic_eoi_irq,
+	.irq_set_type		= gic_set_type,
+	.irq_retrigger		= gic_retrigger,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= gic_set_affinity,
+#endif
+#ifdef CONFIG_PM
+	.irq_set_wake		= gic_set_wake,
+#endif
+};
+
+#ifdef CONFIG_OF
+static int __init
+gicv2m_of_init(struct device_node *node, struct device_node *parent)
+{
+	struct gic_chip_data *gic;
+	int ret;
+
+	ret = _gic_of_init(node, parent, &gicv2m_chip, &gic);
+	if (ret) {
+		pr_err("GICv2m: Failed to initialize GIC\n");
+		return ret;
+	}
+
+#ifdef CONFIG_PCI_MSI
+	gic->msi_chip.owner = THIS_MODULE;
+	gic->msi_chip.of_node = node;
+	gic->msi_chip.setup_irq = gicv2m_setup_msi_irq;
+	gic->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
+	ret = of_pci_msi_chip_add(&gic->msi_chip);
+	if (ret) {
+		/* MSI is optional and not supported here */
+		pr_warn("GICv2m: MSI is not supported.\n");
+		return 0;
+	}
+
+	ret = gicv2m_msi_init(node, &gic->v2m_data);
+	if (ret)
+		return ret;
+#endif
+	return ret;
+}
+
+IRQCHIP_DECLARE(arm_gic_400_plus, "arm,gic-400-plus", gicv2m_of_init);
+
+#endif /* CONFIG_OF */
diff --git a/drivers/irqchip/irq-gic-v2m.h b/drivers/irqchip/irq-gic-v2m.h
new file mode 100644
index 0000000..2d93a87
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v2m.h
@@ -0,0 +1,13 @@
+#ifndef _IRQ_GIC_V2M_H_
+#define _IRQ_GIC_V2M_H_
+
+struct v2m_data {
+	spinlock_t msi_cnt_lock;
+	struct resource res;      /* GICv2m resource */
+	void __iomem *base;       /* GICv2m virt address */
+	unsigned int spi_start;   /* The SPI number that MSIs start */
+	unsigned int nr_spis;     /* The number of SPIs for MSIs */
+	unsigned long *bm;        /* MSI vector bitmap */
+};
+
+#endif /*_IRQ_GIC_V2M_H_*/
-- 
1.9.0

