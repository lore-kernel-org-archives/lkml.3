Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaHMPBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:01:24 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:26528
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbaHMPBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:01:21 -0400
X-WSS-ID: 0NA931R-07-2DX-02
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
Subject: [PATCH 1/2 V4] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Date: Wed, 13 Aug 2014 10:00:40 -0500
Message-ID: <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(189002)(199003)(47776003)(87286001)(79102001)(77156001)(21056001)(84676001)(74662001)(229853001)(76176999)(50986999)(62966002)(36756003)(107046002)(92566001)(104166001)(105586002)(77982001)(106466001)(81542001)(74502001)(101416001)(102836001)(48376002)(31966008)(33646002)(92726001)(2201001)(81342001)(99396002)(85306004)(83072002)(97736001)(19580395003)(575784001)(64706001)(86362001)(86152002)(4396001)(19580405001)(80022001)(50466002)(95666004)(53416004)(88136002)(76482001)(89996001)(77096002)(46102001)(83322001)(87936001)(50226001)(93916002)(20776003)(44976005)(85852003)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB039;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0302D4F392
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

ARM GICv2m specification extends GICv2 to support MSI(-X) with
a new set of register frame. This patch introduces support for
the non-secure GICv2m register frame. Currently, GICV2m is available
in certain version of GIC-400.

The patch introduces a new property in ARM gic binding, the v2m subnode.
It is optional.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>
---
 Documentation/devicetree/bindings/arm/gic.txt |  32 ++++
 drivers/irqchip/Kconfig                       |   7 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 215 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                     |  75 +++++----
 drivers/irqchip/irq-gic.h                     |  48 ++++++
 6 files changed, 348 insertions(+), 30 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 5573c08..8a64179 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -95,3 +95,35 @@ Example:
 		      <0x2c006000 0x2000>;
 		interrupts = <1 9 0xf04>;
 	};
+
+
+* GICv2m extension for MSI/MSI-x support (Optional)
+
+Certain revision of GIC-400 supports MSI/MSI-x via V2M register frame.
+This is enabled by specifying v2m sub-node.
+
+Required properties:
+
+- msi-controller : Identifies the node as an MSI controller.
+
+- reg : GICv2m MSI interface register base and size
+
+Example:
+
+	interrupt-controller@e1101000 {
+		compatible = "arm,gic-400";
+		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		interrupt-controller;
+		interrupts = <1 8 0xf04>;
+		ranges = <0 0 0 0xe1100000 0 0x100000>;
+		reg = <0x0 0xe1110000 0 0x01000>,
+		      <0x0 0xe112f000 0 0x02000>,
+		      <0x0 0xe1140000 0 0x10000>,
+		      <0x0 0xe1160000 0 0x10000>;
+		v2m {
+			msi-controller;
+			reg = <0x0 0x80000 0 0x1000>;
+		};
+	};
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4e230e7..9aa5edc 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -7,6 +7,13 @@ config ARM_GIC
 	select IRQ_DOMAIN
 	select MULTI_IRQ_HANDLER
 
+config ARM_GIC_V2M
+	bool
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+	depends on ARM_GIC
+	depends on PCI && PCI_MSI
+
 config GIC_NON_BANKED
 	bool
 
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 73052ba..3bda951 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o irq-gic-common.o
+obj-$(CONFIG_ARM_GIC_V2M)		+= irq-gic-v2m.o
 obj-$(CONFIG_ARM_GIC_V3)		+= irq-gic-v3.o irq-gic-common.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
new file mode 100644
index 0000000..1ac0ace
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -0,0 +1,215 @@
+/*
+ * ARM GIC v2m MSI(-X) support
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
+
+/*
+* MSI_TYPER:
+*     [31:26] Reserved
+*     [25:16] lowest SPI assigned to MSI
+*     [15:10] Reserved
+*     [9:0]   Numer of SPIs assigned to MSI
+*/
+#define V2M_MSI_TYPER			0x008
+#define V2M_MSI_TYPER_BASE_SHIFT	(16)
+#define V2M_MSI_TYPER_BASE_MASK		(0x3FF)
+#define V2M_MSI_TYPER_NUM_MASK		(0x3FF)
+#define V2M_MSI_SETSPI_NS		0x040
+#define V2M_MIN_SPI			32
+#define V2M_MAX_SPI			1019
+
+/*
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
+		i = size;
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
+	if (i != nvec) {
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
+static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
+{
+	int pos;
+	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
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
+	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
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
+	addr = data->res.start + V2M_MSI_SETSPI_NS;
+
+	msg.address_hi = (u32)(addr >> 32);
+	msg.address_lo = (u32)(addr);
+	msg.data = irq;
+	write_msi_msg(irq, &msg);
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
+static struct irq_chip gicv2m_chip;
+
+#ifdef CONFIG_OF
+int __init
+gicv2m_of_init(struct device_node *node, struct gic_chip_data *gic)
+{
+	int ret;
+	unsigned int val;
+	struct v2m_data *v2m = &gic->v2m_data;
+
+	v2m->msi_chip.owner = THIS_MODULE;
+	v2m->msi_chip.of_node = node;
+	v2m->msi_chip.setup_irq = gicv2m_setup_msi_irq;
+	v2m->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
+	ret = of_pci_msi_chip_add(&v2m->msi_chip);
+	if (ret) {
+		pr_info("GICv2m: Failed to add msi_chip.\n");
+		return ret;
+	}
+
+	if (of_address_to_resource(node, 0, &v2m->res)) {
+		pr_err("GICv2m: Failed locate GICv2m MSI register frame\n");
+		return -EINVAL;
+	}
+
+	v2m->base = of_iomap(node, 0);
+	if (!v2m->base) {
+		pr_err("GICv2m: Failed to map GIC MSI registers\n");
+		return -EINVAL;
+	}
+
+	val = readl_relaxed(v2m->base + V2M_MSI_TYPER);
+	if (!val) {
+		pr_warn("GICv2m: Failed to read V2M_MSI_TYPER register\n");
+		return -EINVAL;
+	}
+
+	v2m->spi_start = (val >> V2M_MSI_TYPER_BASE_SHIFT) &
+				V2M_MSI_TYPER_BASE_MASK;
+	v2m->nr_spis = val & V2M_MSI_TYPER_NUM_MASK;
+	if ((v2m->spi_start < V2M_MIN_SPI) || (v2m->nr_spis >= V2M_MAX_SPI)) {
+			pr_err("GICv2m: Invalid MSI_TYPER (%#x)\n", val);
+			return -EINVAL;
+	}
+
+	v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
+			  GFP_KERNEL);
+	if (!v2m->bm) {
+		pr_err("GICv2m: Failed to allocate MSI bitmap\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&v2m->msi_cnt_lock);
+
+	pr_info("GICv2m: SPI range [%d:%d]\n",
+		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
+
+	memcpy(&gicv2m_chip, gic->irq_chip, sizeof(struct irq_chip));
+	gicv2m_chip.name = "GICv2m",
+	gicv2m_chip.irq_mask = gicv2m_mask_irq;
+	gicv2m_chip.irq_unmask = gicv2m_unmask_irq;
+	gic->irq_chip = &gicv2m_chip;
+
+	return 0;
+}
+
+#endif /* CONFIG_OF */
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 508b815..b175ccf 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -47,30 +47,9 @@
 #include <asm/smp_plat.h>
 
 #include "irq-gic-common.h"
+#include "irq-gic.h"
 #include "irqchip.h"
 
-union gic_base {
-	void __iomem *common_base;
-	void __percpu * __iomem *percpu_base;
-};
-
-struct gic_chip_data {
-	union gic_base dist_base;
-	union gic_base cpu_base;
-#ifdef CONFIG_CPU_PM
-	u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
-	u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
-	u32 saved_spi_target[DIV_ROUND_UP(1020, 4)];
-	u32 __percpu *saved_ppi_enable;
-	u32 __percpu *saved_ppi_conf;
-#endif
-	struct irq_domain *domain;
-	unsigned int gic_irqs;
-#ifdef CONFIG_GIC_NON_BANKED
-	void __iomem *(*get_base)(union gic_base *);
-#endif
-};
-
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
 /*
@@ -132,15 +111,36 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
 #define gic_set_base_accessor(d, f)
 #endif
 
+static inline
+struct gic_chip_data *irq_data_get_gic_chip_data(struct irq_data *d)
+{
+	struct gic_chip_data *gic_data;
+	struct msi_chip *mchip;
+	struct v2m_data *v2mdat;
+
+	/*
+	 * For MSI, irq_data.chip_data points to struct msi_chip.
+	 * For non-MSI, irq_data.chip_data points to struct gic_chip_data.
+	 */
+	if (d->msi_desc) {
+		mchip = irq_data_get_irq_chip_data(d);
+		v2mdat = container_of(mchip, struct v2m_data, msi_chip);
+		gic_data = container_of(v2mdat, struct gic_chip_data, v2m_data);
+	} else {
+		gic_data = irq_data_get_irq_chip_data(d);
+	}
+	return gic_data;
+}
+
 static inline void __iomem *gic_dist_base(struct irq_data *d)
 {
-	struct gic_chip_data *gic_data = irq_data_get_irq_chip_data(d);
+	struct gic_chip_data *gic_data = irq_data_get_gic_chip_data(d);
 	return gic_data_dist_base(gic_data);
 }
 
 static inline void __iomem *gic_cpu_base(struct irq_data *d)
 {
-	struct gic_chip_data *gic_data = irq_data_get_irq_chip_data(d);
+	struct gic_chip_data *gic_data = irq_data_get_gic_chip_data(d);
 	return gic_data_cpu_base(gic_data);
 }
 
@@ -152,7 +152,7 @@ static inline unsigned int gic_irq(struct irq_data *d)
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
-static void gic_mask_irq(struct irq_data *d)
+void gic_mask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (gic_irq(d) % 32);
 
@@ -163,7 +163,7 @@ static void gic_mask_irq(struct irq_data *d)
 	raw_spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(struct irq_data *d)
+void gic_unmask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (gic_irq(d) % 32);
 
@@ -768,19 +768,21 @@ void __init gic_init_physaddr(struct device_node *node)
 static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 				irq_hw_number_t hw)
 {
+	struct gic_chip_data *gic = d->host_data;
+
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_set_chip_and_handler(irq, &gic_chip,
+		irq_set_chip_and_handler(irq, gic->irq_chip,
 					 handle_percpu_devid_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	} else {
-		irq_set_chip_and_handler(irq, &gic_chip,
+		irq_set_chip_and_handler(irq, gic->irq_chip,
 					 handle_fasteoi_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 
 		gic_routable_irq_domain_ops->map(d, irq, hw);
 	}
-	irq_set_chip_data(irq, d->host_data);
+	irq_set_chip_data(irq, gic);
 	return 0;
 }
 
@@ -992,10 +994,11 @@ static int gic_cnt __initdata;
 static int __init
 gic_of_init(struct device_node *node, struct device_node *parent)
 {
+	struct device_node *child;
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
 	u32 percpu_offset;
-	int irq;
+	int irq, ret;
 
 	if (WARN_ON(!node))
 		return -ENODEV;
@@ -1009,6 +1012,16 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
+	gic_data[gic_cnt].irq_chip = &gic_chip;
+
+	/* Currently, we only support one v2m subnode. */
+	child = of_get_child_by_name(node, "v2m");
+	if (child) {
+		ret = gicv2m_of_init(child, &gic_data[gic_cnt]);
+		if (ret)
+			return ret;
+	}
+
 	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
 	if (!gic_cnt)
 		gic_init_physaddr(node);
@@ -1020,6 +1033,8 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	gic_cnt++;
 	return 0;
 }
+
+IRQCHIP_DECLARE(gic_400, "arm,gic-400", gic_of_init);
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
diff --git a/drivers/irqchip/irq-gic.h b/drivers/irqchip/irq-gic.h
new file mode 100644
index 0000000..2ec6bc3
--- /dev/null
+++ b/drivers/irqchip/irq-gic.h
@@ -0,0 +1,48 @@
+#ifndef _IRQ_GIC_H_
+#define _IRQ_GIC_H_
+
+#include <linux/msi.h>
+
+union gic_base {
+	void __iomem *common_base;
+	void __percpu * __iomem *percpu_base;
+};
+
+#ifdef CONFIG_ARM_GIC_V2M
+struct v2m_data {
+	spinlock_t msi_cnt_lock;
+	struct msi_chip msi_chip;
+	struct resource res;      /* GICv2m resource */
+	void __iomem *base;       /* GICv2m virt address */
+	unsigned int spi_start;   /* The SPI number that MSIs start */
+	unsigned int nr_spis;     /* The number of SPIs for MSIs */
+	unsigned long *bm;        /* MSI vector bitmap */
+};
+#endif
+
+struct gic_chip_data {
+	union gic_base dist_base;
+	union gic_base cpu_base;
+#ifdef CONFIG_CPU_PM
+	u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
+	u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
+	u32 saved_spi_target[DIV_ROUND_UP(1020, 4)];
+	u32 __percpu *saved_ppi_enable;
+	u32 __percpu *saved_ppi_conf;
+#endif
+	struct irq_domain *domain;
+	unsigned int gic_irqs;
+#ifdef CONFIG_GIC_NON_BANKED
+	void __iomem *(*get_base)(union gic_base *);
+#endif
+	struct irq_chip *irq_chip;
+#ifdef CONFIG_ARM_GIC_V2M
+	struct v2m_data v2m_data;
+#endif
+};
+
+void gic_mask_irq(struct irq_data *d);
+void gic_unmask_irq(struct irq_data *d);
+int gicv2m_of_init(struct device_node *node, struct gic_chip_data *gic) __init;
+
+#endif /* _IRQ_GIC_H_ */
-- 
1.9.0

