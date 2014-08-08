Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbaHHXVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:21:10 -0400
Received: from [207.46.163.145] ([207.46.163.145]:22311 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932180AbaHHXVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:21:05 -0400
X-WSS-ID: 0NA0GR1-08-MK1-02
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
Subject: [PATCH 4/4] irqchip: gic-v2m: Restructure the initalization code for v2m
Date: Fri, 8 Aug 2014 18:17:16 -0500
Message-ID: <1407539836-9768-5-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(189002)(199002)(77156001)(88136002)(36756003)(74502001)(101416001)(50466002)(79102001)(95666004)(74662001)(31966008)(105586002)(85306004)(77982001)(106466001)(87936001)(68736004)(97736001)(62966002)(102836001)(48376002)(81342001)(44976005)(4396001)(87286001)(64706001)(21056001)(107046002)(84676001)(93916002)(46102001)(81542001)(77096002)(575784001)(86362001)(53416004)(33646002)(2201001)(92566001)(86152002)(50226001)(92726001)(19580395003)(19580405001)(47776003)(20776003)(229853001)(83322001)(89996001)(80022001)(104166001)(76176999)(76482001)(50986999)(85852003)(83072002)(99396002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB038;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch remove register index 4 in gic binding, and
introduce the "v2m" subnode. It also changes in the
gic_of_init function to probe for v2m subnode before calling
the gicv2m_of_init.

Besides, this patch also moves the "struct msi_chip" from
"struct gic_chip_data" to "struct v2m_data".

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
---
 Documentation/devicetree/bindings/arm/gic.txt |  37 +++++++--
 drivers/irqchip/irq-gic-v2m.c                 | 115 +++++++++-----------------
 drivers/irqchip/irq-gic.c                     |  30 +++----
 drivers/irqchip/irq-gic.h                     |  10 +--
 4 files changed, 91 insertions(+), 101 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index d2eea0b..9e38abe 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -12,7 +12,6 @@ Main node required properties:
 
 - compatible : should be one of:
 	"arm,gic-400"
-	"arm,gic-400-v2m"
 	"arm,cortex-a15-gic"
 	"arm,cortex-a9-gic"
 	"arm,cortex-a7-gic"
@@ -49,7 +48,6 @@ Main node required properties:
      1   | GIC cpu interface register base and size
      2   | VGIC interface control register base and size (Optional)
      3   | VGIC CPU interface register base and size (Optional)
-     4   | GICv2m MSI interface register base and size (Optional)
 
 Optional
 - interrupts	: Interrupt source of the parent interrupt controller on
@@ -66,9 +64,6 @@ Optional
 		  input line is assigned dynamically when the corresponding
 		  peripheral's crossbar line is mapped.
 
-- msi-controller : Identifies the node as an MSI controller.
-                   (Required for GICv2m)
-
 Example:
 
 	intc: interrupt-controller@fff11000 {
@@ -109,3 +104,35 @@ Example:
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
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index 57b5a51..1ac0ace 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -42,8 +42,6 @@
 #define V2M_MIN_SPI			32
 #define V2M_MAX_SPI			1019
 
-#define GIC_OF_MSIV2M_RANGE_INDEX	4
-
 /*
  * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
  * @data: Pointer to v2m_data
@@ -85,17 +83,10 @@ static int alloc_msi_irq(struct v2m_data *data, int nvec, int *irq)
 	return ret;
 }
 
-static struct v2m_data *to_v2m_data(struct msi_chip *chip)
-{
-	struct gic_chip_data *gic = container_of(chip, struct gic_chip_data,
-						 msi_chip);
-	return &gic->v2m_data;
-}
-
 static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
 {
 	int pos;
-	struct v2m_data *data = to_v2m_data(chip);
+	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
 
 	spin_lock(&data->msi_cnt_lock);
 
@@ -112,7 +103,7 @@ static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	int avail, irq = 0;
 	struct msi_msg msg;
 	phys_addr_t addr;
-	struct v2m_data *data = to_v2m_data(chip);
+	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
 
 	if (!desc) {
 		dev_err(&pdev->dev,
@@ -141,18 +132,46 @@ static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	return 0;
 }
 
-static int __init
-gicv2m_msi_init(struct device_node *node, struct v2m_data *v2m)
+static void gicv2m_mask_irq(struct irq_data *d)
+{
+	gic_mask_irq(d);
+	if (d->msi_desc)
+		mask_msi_irq(d);
+}
+
+static void gicv2m_unmask_irq(struct irq_data *d)
 {
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
 	unsigned int val;
+	struct v2m_data *v2m = &gic->v2m_data;
 
-	if (of_address_to_resource(node, GIC_OF_MSIV2M_RANGE_INDEX,
-				   &v2m->res)) {
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
 		pr_err("GICv2m: Failed locate GICv2m MSI register frame\n");
 		return -EINVAL;
 	}
 
-	v2m->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);
+	v2m->base = of_iomap(node, 0);
 	if (!v2m->base) {
 		pr_err("GICv2m: Failed to map GIC MSI registers\n");
 		return -EINVAL;
@@ -184,65 +203,13 @@ gicv2m_msi_init(struct device_node *node, struct v2m_data *v2m)
 	pr_info("GICv2m: SPI range [%d:%d]\n",
 		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
 
-	return 0;
-}
+	memcpy(&gicv2m_chip, gic->irq_chip, sizeof(struct irq_chip));
+	gicv2m_chip.name = "GICv2m",
+	gicv2m_chip.irq_mask = gicv2m_mask_irq;
+	gicv2m_chip.irq_unmask = gicv2m_unmask_irq;
+	gic->irq_chip = &gicv2m_chip;
 
-static void gicv2m_mask_irq(struct irq_data *d)
-{
-	gic_mask_irq(d);
-	if (d->msi_desc)
-		mask_msi_irq(d);
-}
-
-static void gicv2m_unmask_irq(struct irq_data *d)
-{
-	gic_unmask_irq(d);
-	if (d->msi_desc)
-		unmask_msi_irq(d);
+	return 0;
 }
 
-static struct irq_chip gicv2m_chip = {
-	.name			= "GICv2m",
-	.irq_mask		= gicv2m_mask_irq,
-	.irq_unmask		= gicv2m_unmask_irq,
-	.irq_eoi		= gic_eoi_irq,
-	.irq_set_type		= gic_set_type,
-	.irq_retrigger		= gic_retrigger,
-#ifdef CONFIG_SMP
-	.irq_set_affinity	= gic_set_affinity,
-#endif
-#ifdef CONFIG_PM
-	.irq_set_wake		= gic_set_wake,
-#endif
-};
-
-#ifdef CONFIG_OF
-static int __init
-gicv2m_of_init(struct device_node *node, struct device_node *parent)
-{
-	struct gic_chip_data *gic;
-	int ret;
-
-	ret = _gic_of_init(node, parent, &gicv2m_chip, &gic);
-	if (ret) {
-		pr_err("GICv2m: Failed to initialize GIC\n");
-		return ret;
-	}
-
-	gic->msi_chip.owner = THIS_MODULE;
-	gic->msi_chip.of_node = node;
-	gic->msi_chip.setup_irq = gicv2m_setup_msi_irq;
-	gic->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
-	ret = of_pci_msi_chip_add(&gic->msi_chip);
-	if (ret) {
-		/*
-		* Note: msi-controller is checked in of_pci_msi_chip_add().
-		* MSI support is optional, and enabled only if msi-controller
-		* is specified. Hence, return 0.
-		*/
-		return 0;
-	}
-
-	return gicv2m_msi_init(node, &gic->v2m_data);
-}
 #endif /* CONFIG_OF */
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index cedaeb4..d308d93 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -116,6 +116,7 @@ struct gic_chip_data *irq_data_get_gic_chip_data(struct irq_data *d)
 {
 	struct gic_chip_data *gic_data;
 	struct msi_chip *mchip;
+	struct v2m_data *v2mdat;
 
 	/*
 	 * For MSI, irq_data.chip_data points to struct msi_chip.
@@ -123,7 +124,8 @@ struct gic_chip_data *irq_data_get_gic_chip_data(struct irq_data *d)
 	 */
 	if (d->msi_desc) {
 		mchip = irq_data_get_irq_chip_data(d);
-		gic_data = container_of(mchip, struct gic_chip_data, msi_chip);
+		v2mdat = container_of(mchip, struct v2m_data, msi_chip);
+		gic_data = container_of(v2mdat, struct gic_chip_data, v2m_data);
 	} else {
 		gic_data = irq_data_get_irq_chip_data(d);
 	}
@@ -989,14 +991,14 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_OF
 static int gic_cnt __initdata;
 
-int __init
-_gic_of_init(struct device_node *node, struct device_node *parent,
-	     struct irq_chip *chip, struct gic_chip_data **gic)
+static int
+__init gic_of_init(struct device_node *node, struct device_node *parent)
 {
+	struct device_node *child;
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
 	u32 percpu_offset;
-	int irq;
+	int irq, ret;
 
 	if (WARN_ON(!node))
 		return -ENODEV;
@@ -1010,7 +1012,15 @@ _gic_of_init(struct device_node *node, struct device_node *parent,
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
-	gic_data[gic_cnt].irq_chip = chip;
+	gic_data[gic_cnt].irq_chip = &gic_chip;
+
+	/* Currently, we only support one v2m subnode. */
+	child = of_get_child_by_name(node, "v2m");
+	if (child) {
+		ret = gicv2m_of_init(child, &gic_data[gic_cnt]);
+		if (ret)
+			return ret;
+	}
 
 	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
 	if (!gic_cnt)
@@ -1021,18 +1031,10 @@ _gic_of_init(struct device_node *node, struct device_node *parent,
 		gic_cascade_irq(gic_cnt, irq);
 	}
 
-	if (gic)
-		*gic = &gic_data[gic_cnt];
 	gic_cnt++;
 	return 0;
 }
 
-static int __init
-gic_of_init(struct device_node *node, struct device_node *parent)
-{
-	return _gic_of_init(node, parent, &gic_chip, NULL);
-}
-
 IRQCHIP_DECLARE(gic_400, "arm,gic-400", gic_of_init);
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
diff --git a/drivers/irqchip/irq-gic.h b/drivers/irqchip/irq-gic.h
index 83aa772..2ec6bc3 100644
--- a/drivers/irqchip/irq-gic.h
+++ b/drivers/irqchip/irq-gic.h
@@ -11,6 +11,7 @@ union gic_base {
 #ifdef CONFIG_ARM_GIC_V2M
 struct v2m_data {
 	spinlock_t msi_cnt_lock;
+	struct msi_chip msi_chip;
 	struct resource res;      /* GICv2m resource */
 	void __iomem *base;       /* GICv2m virt address */
 	unsigned int spi_start;   /* The SPI number that MSIs start */
@@ -35,20 +36,13 @@ struct gic_chip_data {
 	void __iomem *(*get_base)(union gic_base *);
 #endif
 	struct irq_chip *irq_chip;
-	struct msi_chip msi_chip;
 #ifdef CONFIG_ARM_GIC_V2M
 	struct v2m_data v2m_data;
 #endif
 };
 
-#ifdef CONFIG_OF
-int _gic_of_init(struct device_node *node,
-		 struct device_node *parent,
-		 struct irq_chip *chip,
-		 struct gic_chip_data **gic) __init;
-#endif
-
 void gic_mask_irq(struct irq_data *d);
 void gic_unmask_irq(struct irq_data *d);
+int gicv2m_of_init(struct device_node *node, struct gic_chip_data *gic) __init;
 
 #endif /* _IRQ_GIC_H_ */
-- 
1.9.0

