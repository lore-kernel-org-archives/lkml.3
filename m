Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaFXAd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:33:28 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:35818
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753069AbaFXAdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:33:15 -0400
X-WSS-ID: 0N7NDJA-07-8E4-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
Date: Mon, 23 Jun 2014 19:33:00 -0500
Message-ID: <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(81542001)(105586002)(97736001)(93916002)(74662001)(99396002)(31966008)(87286001)(104166001)(106466001)(79102001)(85306003)(77982001)(86362001)(36756003)(77156001)(74502001)(92726001)(46102001)(80022001)(92566001)(48376002)(575784001)(86152002)(50466002)(88136002)(87936001)(64706001)(76482001)(53416004)(89996001)(2201001)(101416001)(81342001)(19580405001)(84676001)(19580395003)(44976005)(83322001)(95666004)(21056001)(50986999)(20776003)(47776003)(50226001)(4396001)(85852003)(68736004)(62966002)(77096002)(102836001)(83072002)(76176999)(33646001);DIR:OUT;SFP:;SCL:1;SRVR:BN3PR0201MB0913;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

GICv2m extends GICv2 to support MSI(-X) with a new set of register frames.

This patch introduces support for the non-secure GICv2m register frame.
This is optional. It uses the "msi-controller" keyword in ARM GIC
devicetree binding to indentify GIC driver that it should enable MSI(-X)
support, The region of GICv2m MSI register frame is specified using the register
frame index 4 in the device tree.

Each GIC maintains an "msi_chip" structure. To discover the msi_chip,
PCI host driver can do the following:

    struct device_node *gic_node = of_irq_find_parent(pdev->dev.of_node);
    pcie_bus->msi_chip = of_pci_find_msi_chip_by_node(gic_node);

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 Documentation/devicetree/bindings/arm/gic.txt |  18 +-
 drivers/irqchip/Kconfig                       |   6 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/gic-msi-v2m.c                 | 249 ++++++++++++++++++++++++++
 drivers/irqchip/gic-msi-v2m.h                 |  20 +++
 drivers/irqchip/irq-gic.c                     |  21 ++-
 6 files changed, 311 insertions(+), 4 deletions(-)
 create mode 100644 drivers/irqchip/gic-msi-v2m.c
 create mode 100644 drivers/irqchip/gic-msi-v2m.h

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 5573c08..ee4bc02 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -17,6 +17,7 @@ Main node required properties:
 	"arm,cortex-a7-gic"
 	"arm,arm11mp-gic"
 - interrupt-controller : Identifies the node as an interrupt controller
+
 - #interrupt-cells : Specifies the number of cells needed to encode an
   interrupt source.  The type shall be a <u32> and the value shall be 3.
 
@@ -37,9 +38,16 @@ Main node required properties:
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
@@ -55,6 +63,10 @@ Optional
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
index bbb746e..a36bf94 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -7,6 +7,12 @@ config ARM_GIC
 	select IRQ_DOMAIN
 	select MULTI_IRQ_HANDLER
 
+config ARM_GIC_MSI_V2M
+	bool
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+	depends on PCI && PCI_MSI
+
 config GIC_NON_BANKED
 	bool
 
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 62a13e5..d43f904 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
+obj-$(CONFIG_ARM_GIC_MSI_V2M)		+= gic-msi-v2m.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_IMGPDC_IRQ)		+= irq-imgpdc.o
diff --git a/drivers/irqchip/gic-msi-v2m.c b/drivers/irqchip/gic-msi-v2m.c
new file mode 100644
index 0000000..e5c0f79
--- /dev/null
+++ b/drivers/irqchip/gic-msi-v2m.c
@@ -0,0 +1,249 @@
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
+#include <linux/bitmap.h>
+
+#include "gic-msi-v2m.h"
+
+/* GICv2m MSI Registers */
+#define MSI_TYPER			0x008
+#define MSI_SETSPI_NS			0x040
+#define GIC_V2M_MIN_SPI			32
+#define GIC_V2M_MAX_SPI			1024
+#define GIC_OF_MSIV2M_RANGE_INDEX	4
+
+extern struct irq_chip gic_arch_extn;
+
+/**
+ * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
+ * @data: Pointer to gicv2m_msi_data
+ * @nvec: Number of interrupts to allocate
+ * @irq: Pointer to the allocated irq
+ *
+ * Allocates interrupts only if the contiguous range of MSIs
+ * with specified nvec are avaiable. Otherwise return the number
+ * of avaiable interrupts. If none is avaiable, then returns -ENOENT.
+ */
+static int alloc_msi_irq(struct gicv2m_msi_data *data, int nvec, int *irq)
+{
+	int size = sizeof(unsigned long) * data->bm_sz;
+	int next = size, ret, num;
+
+	spin_lock(&data->msi_cnt_lock);
+
+	for (num = nvec; num > 0; num--) {
+		next = bitmap_find_next_zero_area(data->bm,
+					size, 0, num, 0);
+		if (next < size)
+			break;
+	}
+
+	if (next < size) {
+		bitmap_set(data->bm, next, nvec);
+		*irq = data->spi_start + next;
+		ret = 0;
+	} else if (num != 0) {
+		ret = num;
+	} else {
+		ret = -ENOENT;
+	}
+
+
+	spin_unlock(&data->msi_cnt_lock);
+
+	return ret;
+}
+
+static void free_msi_irq(struct gicv2m_msi_data *data, unsigned int irq)
+{
+	int pos;
+
+	spin_lock(&data->msi_cnt_lock);
+
+	pos = irq - data->spi_start;
+	if (pos >= 0 && pos < data->max_spi_cnt)
+		bitmap_clear(data->bm, pos, 1);
+
+	spin_unlock(&data->msi_cnt_lock);
+}
+
+static inline struct gicv2m_msi_data *to_gicv2m_msi_data(struct msi_chip *chip)
+{
+	return container_of(chip, struct gicv2m_msi_data, chip);
+}
+
+static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
+{
+	free_msi_irq(to_gicv2m_msi_data(chip), irq);
+}
+
+static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
+		      struct msi_desc *desc)
+{
+	int avail, irq = 0;
+	struct msi_msg msg;
+	phys_addr_t addr;
+	struct gicv2m_msi_data *data = to_gicv2m_msi_data(chip);
+
+	if (data == NULL) {
+		dev_err(&pdev->dev,
+			"GICv2m: MSI setup failed. Invalid platform data\n");
+		return -EINVAL;
+	}
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
+	irq_set_msi_desc(irq, desc);
+	irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
+
+	addr = (unsigned long)(data->paddr64 + MSI_SETSPI_NS);
+
+	msg.address_hi = (unsigned int)(addr >> 32);
+	msg.address_lo = (unsigned int)(addr);
+	msg.data = irq;
+#ifdef CONFIG_PCI_MSI
+	write_msi_msg(irq, &msg);
+#endif
+
+	return 0;
+}
+
+static void gicv2m_mask_msi(struct irq_data *d)
+{
+	if (d->msi_desc)
+		mask_msi_irq(d);
+}
+
+static void gicv2m_unmask_msi(struct irq_data *d)
+{
+	if (d->msi_desc)
+		unmask_msi_irq(d);
+}
+
+int __init gicv2m_msi_init(struct device_node *node,
+			   struct gicv2m_msi_data *msi)
+{
+	unsigned int val;
+	const __be32 *msi_be;
+
+	msi_be = of_get_address(node, GIC_OF_MSIV2M_RANGE_INDEX, NULL, NULL);
+	if (!msi_be) {
+		pr_err("GICv2m failed. Fail to locate MSI base.\n");
+		return -EINVAL;
+	}
+
+	msi->paddr64 = of_translate_address(node, msi_be);
+	msi->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);
+
+	/*
+	* MSI_TYPER:
+	*     [31:26] Reserved
+	*     [25:16] lowest SPI assigned to MSI
+	*     [15:10] Reserved
+	*     [9:0]   Numer of SPIs assigned to MSI
+	*/
+	val = __raw_readl(msi->base + MSI_TYPER);
+	if (!val) {
+		pr_warn("GICv2m: Failed to read MSI_TYPER register\n");
+		return -EINVAL;
+	}
+
+	msi->spi_start = (val >> 16) & 0x3ff;
+	msi->max_spi_cnt = val & 0x3ff;
+
+	pr_debug("GICv2m: SPI = %u, cnt = %u\n",
+		msi->spi_start, msi->max_spi_cnt);
+
+	if (msi->spi_start < GIC_V2M_MIN_SPI ||
+		msi->max_spi_cnt >= GIC_V2M_MAX_SPI) {
+			pr_err("GICv2m: Init failed\n");
+			return -EINVAL;
+	}
+
+	msi->bm_sz = BITS_TO_LONGS(msi->max_spi_cnt);
+	msi->bm = kzalloc(msi->bm_sz, GFP_KERNEL);
+	if (!msi->bm)
+		return -ENOMEM;
+
+	spin_lock_init(&msi->msi_cnt_lock);
+
+	msi->chip.owner = THIS_MODULE;
+	msi->chip.of_node = node;
+	msi->chip.setup_irq = gicv2m_setup_msi_irq;
+	msi->chip.teardown_irq = gicv2m_teardown_msi_irq;
+
+	pr_info("GICv2m: SPI range [%d:%d]\n",
+		msi->spi_start, (msi->spi_start + msi->max_spi_cnt));
+
+	gic_arch_extn.irq_mask = gicv2m_mask_msi;
+	gic_arch_extn.irq_unmask = gicv2m_unmask_msi;
+
+	return 0;
+}
+EXPORT_SYMBOL(gicv2m_msi_init);
+
+
+
+/**
+ * Override arch_setup_msi_irq in drivers/pci/msi.c
+ * since we don't want to change the chip_data
+ */
+int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+{
+	struct msi_chip *chip = pdev->bus->msi;
+
+	if (!chip || !chip->setup_irq)
+		return -EINVAL;
+
+	return chip->setup_irq(chip, pdev, desc);
+}
+
+/**
+ * Override arch_teardown_msi_irq in drivers/pci/msi.c
+ */
+void arch_teardown_msi_irq(unsigned int irq)
+{
+	struct msi_desc *desc;
+	struct msi_chip *chip;
+
+	desc = irq_get_msi_desc(irq);
+	if (!desc)
+		return;
+
+	chip = desc->dev->bus->msi;
+	if (!chip)
+		return;
+
+	chip->teardown_irq(chip, irq);
+}
diff --git a/drivers/irqchip/gic-msi-v2m.h b/drivers/irqchip/gic-msi-v2m.h
new file mode 100644
index 0000000..164d929
--- /dev/null
+++ b/drivers/irqchip/gic-msi-v2m.h
@@ -0,0 +1,20 @@
+#ifndef GIC_MSI_V2M_H
+#define GIC_MSI_V2M_H
+
+#include <linux/msi.h>
+
+struct gicv2m_msi_data {
+	struct msi_chip chip;
+	spinlock_t msi_cnt_lock;
+	u64 paddr64;              /* GICv2m phys address */
+	void __iomem *base;       /* GICv2m virt address */
+	unsigned int spi_start;   /* The SPI number that MSIs start */
+	unsigned int max_spi_cnt; /* The number of SPIs for MSIs */
+	unsigned long *bm;        /* MSI vector bitmap */
+	unsigned long bm_sz;      /* MSI bitmap size */
+};
+
+extern int gicv2m_msi_init(struct device_node *node,
+			   struct gicv2m_msi_data *msi) __init;
+
+#endif /*GIC_MSI_V2M_H*/
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index adc86de..dcff99b 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -35,6 +35,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/of_pci.h>
 #include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
@@ -48,6 +49,10 @@
 
 #include "irqchip.h"
 
+#ifdef CONFIG_ARM_GIC_MSI_V2M
+#include "gic-msi-v2m.h"
+#endif
+
 union gic_base {
 	void __iomem *common_base;
 	void __percpu * __iomem *percpu_base;
@@ -68,6 +73,9 @@ struct gic_chip_data {
 #ifdef CONFIG_GIC_NON_BANKED
 	void __iomem *(*get_base)(union gic_base *);
 #endif
+#ifdef CONFIG_ARM_GIC_MSI_V2M
+	struct gicv2m_msi_data msi_data;
+#endif
 };
 
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
@@ -246,7 +254,8 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
-	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
+	unsigned int shift = (gic_irq(d) % 4) * 8;
+	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
 	u32 val, mask, bit;
 
 	if (!force)
@@ -1047,6 +1056,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	void __iomem *dist_base;
 	u32 percpu_offset;
 	int irq;
+	struct gic_chip_data *gic;
 
 	if (WARN_ON(!node))
 		return -ENODEV;
@@ -1068,6 +1078,15 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 		irq = irq_of_parse_and_map(node, 0);
 		gic_cascade_irq(gic_cnt, irq);
 	}
+
+#ifdef CONFIG_ARM_GIC_MSI_V2M
+	if (of_find_property(node, "msi-controller", NULL)) {
+		gic = &gic_data[gic_cnt];
+		if (!gicv2m_msi_init(node, &gic->msi_data))
+			of_pci_msi_chip_add(&gic->msi_data.chip);
+	}
+#endif
+
 	gic_cnt++;
 	return 0;
 }
-- 
1.9.0

