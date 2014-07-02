Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaGBPXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:23:38 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:29052
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbaGBPXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:23:36 -0400
X-WSS-ID: 0N83C32-08-3PP-02
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
Subject: [PATCH 2/3 V2] irqchip: gic: Restructuring ARM GIC code
Date: Wed, 2 Jul 2014 10:23:10 -0500
Message-ID: <1404314590-7802-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(77096002)(53416004)(44976005)(92726001)(86152002)(19580405001)(68736004)(83322001)(62966002)(31966008)(20776003)(47776003)(81542001)(81342001)(105586002)(104166001)(95666004)(36756003)(2201001)(50226001)(33646001)(4396001)(19580395003)(92566001)(80022001)(46102001)(101416001)(74662001)(86362001)(77982001)(64706001)(77156001)(85306003)(102836001)(93916002)(79102001)(76482001)(84676001)(50466002)(97736001)(229853001)(74502001)(21056001)(89996001)(99396002)(88136002)(87936001)(48376002)(85852003)(83072002)(87286001)(50986999)(106466001)(107046002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN3PR0201MB0916;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0260457E99
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch restructures the code to prepare for future MSI support.
It moves the declaration of structures and functions into the header file,
and omit the static prefix.

Since we are planing to have different irq_chip for GIC, the patch adds
irq_chip pointer in the gic_chip_data which is initialized during probing phase.
For examnple, this will be used by the V2M irq_chip.

It also add msi_chip in the gic_chip_data structure which can be used
for the MSI-support code.

This should not have any functional changes.

Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/irqchip/irq-gic.c | 86 +++++++++++++++++++++++++++--------------------
 drivers/irqchip/irq-gic.h | 60 +++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 37 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic.h

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index adc86de..df99e2f 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -47,28 +47,7 @@
 #include <asm/smp_plat.h>
 
 #include "irqchip.h"
-
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
+#include "irq-gic.h"
 
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
@@ -131,15 +110,34 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
 #define gic_set_base_accessor(d, f)
 #endif
 
+static inline
+struct gic_chip_data *irq_data_get_gic_chip_data(struct irq_data *d)
+{
+	struct gic_chip_data *gic_data;
+	struct msi_chip *mchip;
+
+	/* NOTE:
+	 * For MSI, irq_data.chip_data is set to point to struct msi_chip.
+	 * For non-MSI, it is pointing to struct gic_chip_data.
+	 */
+	if (d->msi_desc) {
+		mchip = irq_data_get_irq_chip_data(d);
+		gic_data = container_of(mchip, struct gic_chip_data, msi_chip);
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
 
@@ -151,7 +149,7 @@ static inline unsigned int gic_irq(struct irq_data *d)
 /*
  * Routines to acknowledge, disable and enable interrupts
  */
-static void gic_mask_irq(struct irq_data *d)
+void gic_mask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (gic_irq(d) % 32);
 
@@ -162,7 +160,7 @@ static void gic_mask_irq(struct irq_data *d)
 	raw_spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(struct irq_data *d)
+void gic_unmask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (gic_irq(d) % 32);
 
@@ -173,7 +171,7 @@ static void gic_unmask_irq(struct irq_data *d)
 	raw_spin_unlock(&irq_controller_lock);
 }
 
-static void gic_eoi_irq(struct irq_data *d)
+void gic_eoi_irq(struct irq_data *d)
 {
 	if (gic_arch_extn.irq_eoi) {
 		raw_spin_lock(&irq_controller_lock);
@@ -184,7 +182,7 @@ static void gic_eoi_irq(struct irq_data *d)
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
 }
 
-static int gic_set_type(struct irq_data *d, unsigned int type)
+int gic_set_type(struct irq_data *d, unsigned int type)
 {
 	void __iomem *base = gic_dist_base(d);
 	unsigned int gicirq = gic_irq(d);
@@ -232,7 +230,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	return 0;
 }
 
-static int gic_retrigger(struct irq_data *d)
+int gic_retrigger(struct irq_data *d)
 {
 	if (gic_arch_extn.irq_retrigger)
 		return gic_arch_extn.irq_retrigger(d);
@@ -242,8 +240,8 @@ static int gic_retrigger(struct irq_data *d)
 }
 
 #ifdef CONFIG_SMP
-static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
-			    bool force)
+int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
+		     bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
 	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
@@ -269,7 +267,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 #endif
 
 #ifdef CONFIG_PM
-static int gic_set_wake(struct irq_data *d, unsigned int on)
+int gic_set_wake(struct irq_data *d, unsigned int on)
 {
 	int ret = -ENXIO;
 
@@ -819,19 +817,21 @@ void __init gic_init_physaddr(struct device_node *node)
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
 
@@ -1040,8 +1040,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_OF
 static int gic_cnt __initdata;
 
-static int __init
-gic_of_init(struct device_node *node, struct device_node *parent)
+int __init _gic_of_init(struct device_node *node, struct device_node *parent,
+		    struct irq_chip *chip, struct gic_chip_data **gic)
 {
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
@@ -1060,6 +1060,8 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
+	gic_data[gic_cnt].irq_chip = chip;
+
 	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
 	if (!gic_cnt)
 		gic_init_physaddr(node);
@@ -1068,10 +1070,20 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 		irq = irq_of_parse_and_map(node, 0);
 		gic_cascade_irq(gic_cnt, irq);
 	}
+
+	if (gic)
+		*gic = &gic_data[gic_cnt];
+
 	gic_cnt++;
 	return 0;
 }
 
+static int __init
+gic_of_init(struct device_node *node, struct device_node *parent)
+{
+	return _gic_of_init(node, parent, &gic_chip, NULL);
+}
+
 IRQCHIP_DECLARE(arm_gic_400, "arm,gic-400", gic_of_init);
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
diff --git a/drivers/irqchip/irq-gic.h b/drivers/irqchip/irq-gic.h
new file mode 100644
index 0000000..6d00e97
--- /dev/null
+++ b/drivers/irqchip/irq-gic.h
@@ -0,0 +1,60 @@
+#ifndef _IRQ_GIC_H_
+#define _IRQ_GIC_H_
+
+#include <linux/msi.h>
+
+#ifdef CONFIG_ARM_GIC_V2M
+#include "gic-msi-v2m.h"
+#endif
+
+union gic_base {
+	void __iomem *common_base;
+	void __percpu * __iomem *percpu_base;
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
+	struct irq_chip *irq_chip;
+	struct msi_chip msi_chip;
+#ifdef CONFIG_ARM_GIC_V2M
+	struct v2m_data v2m_data;
+#endif
+};
+
+#ifdef CONFIG_OF
+extern int _gic_of_init(struct device_node *node,
+			struct device_node *parent,
+			struct irq_chip *chip,
+			struct gic_chip_data **gic) __init;
+#endif
+
+extern void gic_mask_irq(struct irq_data *d);
+extern void gic_unmask_irq(struct irq_data *d);
+extern void gic_eoi_irq(struct irq_data *d);
+extern int gic_set_type(struct irq_data *d, unsigned int type);
+extern int gic_retrigger(struct irq_data *d);
+
+#ifdef CONFIG_SMP
+extern int gic_set_affinity(struct irq_data *d,
+			    const struct cpumask *mask_val,
+			    bool force);
+#endif
+
+#ifdef CONFIG_PM
+extern int gic_set_wake(struct irq_data *d, unsigned int on);
+#endif
+
+#endif /* _IRQ_GIC_H_ */
-- 
1.9.0

