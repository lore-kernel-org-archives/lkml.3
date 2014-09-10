Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaIJJPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:15:39 -0400
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:6176
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231AbaIJJPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:15:33 -0400
X-Greylist: delayed 122688 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 05:15:32 EDT
X-WSS-ID: 0NBOHPP-07-X0D-02
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
Subject: [PATCH 1/2 V5] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Date: Wed, 10 Sep 2014 04:15:00 -0500
Message-ID: <1410340501-30752-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410340501-30752-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1410340501-30752-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(428002)(199003)(189002)(21056001)(99396002)(76176999)(92566001)(83072002)(101416001)(46102001)(90102001)(83322001)(85306004)(19580405001)(68736004)(92726001)(2201001)(104166001)(88136002)(50466002)(106466001)(87286001)(36756003)(50986999)(44976005)(87936001)(19580395003)(81542001)(84676001)(4396001)(62966002)(31966008)(76482001)(95666004)(47776003)(33646002)(20776003)(229853001)(93916002)(64706001)(50226001)(77156001)(86362001)(48376002)(102836001)(81342001)(89996001)(49486002)(86152002)(105586002)(85852003)(77982001)(80022001)(77096002)(97736003)(74502001)(79102001)(74662001)(107046002)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB045;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
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
 Documentation/devicetree/bindings/arm/gic.txt |  39 ++++
 drivers/irqchip/Kconfig                       |   7 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 259 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                     |  88 ++++++---
 drivers/irqchip/irq-gic.h                     |  51 +++++
 6 files changed, 417 insertions(+), 28 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index c7d2fa1..a461591 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -96,3 +96,42 @@ Example:
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
+		v2m0 {
+			msi-controller;
+			reg = <0x0 0x80000 0 0x1000>;
+		};
+
+		....
+
+		v2mN {
+			msi-controller;
+			reg = <0x0 0x90000 0 0x1000>;
+		};
+	};
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b8632bf..ddb31ee 100644
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
index 0000000..2471e4c
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -0,0 +1,259 @@
+/*
+ * ARM GIC v2m MSI(-X) support
+ * Support for Message Signaled Interrupts for systems that
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
+#define pr_fmt(fmt) "GICv2m: " fmt
+
+#include <linux/bitmap.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
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
+#define V2M_MSI_TYPER_BASE_SHIFT	16
+#define V2M_MSI_TYPER_BASE_MASK		0x3FF
+#define V2M_MSI_TYPER_NUM_MASK		0x3FF
+#define V2M_MSI_SETSPI_NS		0x040
+#define V2M_MIN_SPI			32
+#define V2M_MAX_SPI			1019
+
+/*
+ * alloc_msi_irq - Allocate MSIs from available MSI bitmap.
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
+static int gicv2m_setup_msi_irq(struct msi_chip *chip,
+				struct pci_dev *pdev,
+				struct msi_desc *desc)
+{
+	int irq, avail;
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
+#ifdef CONFIG_OF
+
+int __init
+v2m_init_resource(struct device_node *node, struct v2m_data *v2m,
+		  struct resource *res)
+{
+	int ret;
+	unsigned int val;
+
+	v2m->msi_chip.owner = THIS_MODULE;
+	v2m->msi_chip.of_node = node;
+	v2m->msi_chip.setup_irq = gicv2m_setup_msi_irq;
+	v2m->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
+	ret = of_pci_msi_chip_add(&v2m->msi_chip);
+	if (ret) {
+		pr_info("Failed to add msi_chip.\n");
+		return ret;
+	}
+
+	v2m->base = ioremap(res->start, resource_size(res));
+	if (!v2m->base) {
+		pr_err("Failed to map GICv2m resource\n");
+		return -EINVAL;
+	}
+
+	memcpy(&v2m->res, res, sizeof(struct resource));
+
+	val = readl_relaxed(v2m->base + V2M_MSI_TYPER);
+	if (!val) {
+		pr_warn("Failed to read V2M_MSI_TYPER register\n");
+		return -EINVAL;
+	}
+
+	v2m->spi_start = (val >> V2M_MSI_TYPER_BASE_SHIFT) &
+				V2M_MSI_TYPER_BASE_MASK;
+	v2m->nr_spis = val & V2M_MSI_TYPER_NUM_MASK;
+	if ((v2m->spi_start < V2M_MIN_SPI) || (v2m->nr_spis >= V2M_MAX_SPI)) {
+			pr_err("Invalid MSI_TYPER (%#x)\n", val);
+			return -EINVAL;
+	}
+
+	v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
+			  GFP_KERNEL);
+	if (!v2m->bm) {
+		pr_err("Failed to allocate MSI bitmap\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&v2m->msi_cnt_lock);
+
+	pr_info("SPI range [%d:%d]\n",
+		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
+
+	return 0;
+}
+
+int __init gicv2m_of_init(struct device_node *node,
+			  struct gic_chip_data *gic,
+			  struct irq_chip *v2m_chip)
+{
+	int ret = 0;
+	struct v2m_data *v2m;
+	struct resource res;
+	struct device_node *child = NULL;
+
+	INIT_LIST_HEAD(&gic->v2m_list);
+
+	for (;;) {
+		child = of_get_next_child(node, child);
+		if (!child)
+			break;
+
+		if (!of_find_property(child, "msi-controller", NULL))
+			continue;
+
+		ret = of_address_to_resource(child, 0, &res);
+		if (ret)
+			break;
+
+		v2m = kzalloc(sizeof(struct v2m_data), GFP_KERNEL);
+		if (!v2m) {
+			pr_err("Failed to allocate struct v2m_data\n");
+			return -ENOMEM;
+		}
+
+		ret = v2m_init_resource(child, v2m, &res);
+		if (ret)
+			break;
+
+		v2m->gic = gic;
+
+		pr_info(" %s: [%lx : %lx]\n", child->name,
+			(unsigned long)res.start, (unsigned long)res.end);
+
+		list_add_tail(&v2m->list, &gic->v2m_list);
+	}
+
+	if (ret && list_empty(&gic->v2m_list)) {
+		pr_err("MSI resource not found\n");
+		return -EINVAL;
+	}
+
+	v2m_chip->irq_mask = gicv2m_mask_irq;
+	v2m_chip->irq_unmask = gicv2m_unmask_irq;
+
+	return 0;
+}
+
+#endif /* CONFIG_OF */
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4b959e6..37679e1 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -46,30 +46,9 @@
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
@@ -131,15 +110,36 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
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
+		gic_data = v2mdat->gic;
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
 
@@ -151,7 +151,7 @@ static inline unsigned int gic_irq(struct irq_data *d)
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
-static void gic_mask_irq(struct irq_data *d)
+void gic_mask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (gic_irq(d) % 32);
 
@@ -162,7 +162,7 @@ static void gic_mask_irq(struct irq_data *d)
 	raw_spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(struct irq_data *d)
+void gic_unmask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (gic_irq(d) % 32);
 
@@ -325,6 +325,15 @@ static struct irq_chip gic_chip = {
 	.irq_set_wake		= gic_set_wake,
 };
 
+static struct irq_chip v2m_chip = {
+	.name			= "GICv2m",
+	.irq_eoi		= gic_eoi_irq,
+	.irq_set_type		= gic_set_type,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= gic_set_affinity,
+#endif
+};
+
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 {
 	if (gic_nr >= MAX_GIC_NR)
@@ -767,6 +776,24 @@ void __init gic_init_physaddr(struct device_node *node)
 static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 				irq_hw_number_t hw)
 {
+	struct gic_chip_data *gic = d->host_data;
+	struct v2m_data *v2m;
+
+	irq_set_chip_data(irq, gic);
+
+#ifdef CONFIG_ARM_GIC_V2M
+	list_for_each_entry(v2m, &gic->v2m_list, list) {
+		if (hw >= v2m->spi_start &&
+		    hw <  v2m->spi_start + v2m->nr_spis) {
+
+			irq_set_chip_and_handler(irq, &v2m_chip,
+					 handle_fasteoi_irq);
+			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+			return 0;
+		}
+	}
+#endif
+
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
 		irq_set_chip_and_handler(irq, &gic_chip,
@@ -779,7 +806,6 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 
 		gic_routable_irq_domain_ops->map(d, irq, hw);
 	}
-	irq_set_chip_data(irq, d->host_data);
 	return 0;
 }
 
@@ -996,7 +1022,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
 	u32 percpu_offset;
-	int irq;
+	int irq, ret;
 
 	if (WARN_ON(!node))
 		return -ENODEV;
@@ -1010,6 +1036,12 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
+	if (IS_ENABLED(CONFIG_ARM_GIC_V2M)) {
+		ret = gicv2m_of_init(node, &gic_data[gic_cnt], &v2m_chip);
+		if (ret)
+			return ret;
+	}
+
 	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
 	if (!gic_cnt)
 		gic_init_physaddr(node);
diff --git a/drivers/irqchip/irq-gic.h b/drivers/irqchip/irq-gic.h
new file mode 100644
index 0000000..1f4a2b0
--- /dev/null
+++ b/drivers/irqchip/irq-gic.h
@@ -0,0 +1,51 @@
+#ifndef _IRQ_GIC_H_
+#define _IRQ_GIC_H_
+
+#include <linux/msi.h>
+#include <linux/pci.h>
+
+union gic_base {
+	void __iomem *common_base;
+	void __percpu * __iomem *percpu_base;
+};
+
+struct gic_chip_data;
+
+struct v2m_data {
+#ifdef CONFIG_ARM_GIC_V2M
+	struct list_head list;
+	spinlock_t msi_cnt_lock;
+	struct msi_chip msi_chip;
+	struct resource res;      /* GICv2m resource */
+	void __iomem *base;       /* GICv2m virt address */
+	unsigned int spi_start;   /* The SPI number that MSIs start */
+	unsigned int nr_spis;     /* The number of SPIs for MSIs */
+	unsigned long *bm;        /* MSI vector bitmap */
+	struct gic_chip_data *gic;
+#endif
+};
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
+	struct list_head v2m_list;
+};
+
+void gic_mask_irq(struct irq_data *d);
+void gic_unmask_irq(struct irq_data *d);
+int gicv2m_of_init(struct device_node *node, struct gic_chip_data *gic,
+		   struct irq_chip *v2m_chip) __init;
+
+#endif /* _IRQ_GIC_H_ */
-- 
1.9.3

