Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3JJL2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:28:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36944 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264Ab3JJL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:28:03 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-kernel@vger.kernel.org>
CC: <haojian.zhuang@gmail.com>, <tglx@linutronix.de>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 2/2] irqchip: mmp: add dt support for wakeup
Date: Thu, 10 Oct 2013 19:27:55 +0800
Message-ID: <1381404475-25843-2-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381404475-25843-1-git-send-email-zhangwm@marvell.com>
References: <1381404475-25843-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-10_04:2013-10-10,2013-10-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310100028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the Marvell SoCs use GIC as its interrupt controller, and ICU
only used as wakeup logic. When AP subsystem is powered off, GIC will
lose its context, the PMU will need ICU to wakeup the AP subsystem.
So add wakeup entry for such kind of usage.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 .../devicetree/bindings/arm/mrvl/intc.txt          |   14 ++-
 drivers/irqchip/irq-mmp.c                          |  124 ++++++++++++++++++++
 include/linux/irqchip/mmp.h                        |   14 +++
 3 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/mrvl/intc.txt b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
index 8b53273..6fa01b4 100644
--- a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
+++ b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
@@ -2,7 +2,7 @@
 
 Required properties:
 - compatible : Should be "mrvl,mmp-intc", "mrvl,mmp2-intc" or
-  "mrvl,mmp2-mux-intc"
+  "mrvl,mmp2-mux-intc", "mrvl,mmp-intc-wakeupgen"
 - reg : Address and length of the register set of the interrupt controller.
   If the interrupt controller is intc, address and length means the range
   of the whold interrupt controller. If the interrupt controller is mux-intc,
@@ -15,6 +15,9 @@ Required properties:
 - interrupt-controller : Identifies the node as an interrupt controller.
 - #interrupt-cells : Specifies the number of cells needed to encode an
   interrupt source.
+- mrvl,intc-gbl-mask : Specifies the address and value for global mask in the
+  interrupt controller.
+- mrvl,intc-for-cp : Specifies the irqs that will be routed to cp
 - mrvl,intc-nr-irqs : Specifies the number of interrupts in the interrupt
   controller.
 - mrvl,clr-mfp-irq : Specifies the interrupt that needs to clear MFP edge
@@ -39,6 +42,15 @@ Example:
 		mrvl,intc-nr-irqs = <2>;
 	};
 
+    intc: wakeupgen@d4282000 {
+		compatible = "mrvl,mmp-intc-wakeupgen";
+		reg = <0xd4282000 0x1000>;
+		mrvl,intc-nr-irqs = <64>;
+		mrvl,intc-gbl-mask = <0x114 0x3
+		                      0x144 0x3>;
+		mrvl,intc-for-cp = <0 31 32>;
+    };
+
 * Marvell Orion Interrupt controller
 
 Required properties
diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
index 470c5de..7e194b4 100644
--- a/drivers/irqchip/irq-mmp.c
+++ b/drivers/irqchip/irq-mmp.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/irqchip/arm-gic.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/of_address.h>
@@ -58,6 +59,8 @@ struct mmp_intc_conf {
 static void __iomem *mmp_icu_base;
 static struct icu_chip_data icu_data[MAX_ICU_NR];
 static int max_icu_nr;
+static u32 irq_for_cp[64];
+static u32 irq_for_cp_nr;	/* How many irqs will be routed to cp */
 
 extern void mmp2_clear_pmic_int(void);
 
@@ -123,6 +126,50 @@ static void icu_unmask_irq(struct irq_data *d)
 	}
 }
 
+static int irq_ignore_wakeup(struct icu_chip_data *data, int hwirq)
+{
+	int i;
+
+	if (hwirq < 0 || hwirq >= data->nr_irqs)
+		return 1;
+
+	for (i = 0; i < irq_for_cp_nr; i++)
+		if (irq_for_cp[i] == hwirq)
+			return 1;
+
+	return 0;
+}
+
+static void icu_mask_irq_wakeup(struct irq_data *d)
+{
+	struct icu_chip_data *data = &icu_data[0];
+	int hwirq = d->hwirq - data->virq_base;
+	u32 r;
+
+	if (irq_ignore_wakeup(data, hwirq))
+		return;
+
+	r = readl_relaxed(mmp_icu_base + (hwirq << 2));
+	r &= ~data->conf_mask;
+	r |= data->conf_disable;
+	writel_relaxed(r, mmp_icu_base + (hwirq << 2));
+}
+
+static void icu_unmask_irq_wakeup(struct irq_data *d)
+{
+	struct icu_chip_data *data = &icu_data[0];
+	int hwirq = d->irq - data->virq_base;
+	u32 r;
+
+	if (irq_ignore_wakeup(data, hwirq))
+		return;
+
+	r = readl_relaxed(mmp_icu_base + (hwirq << 2));
+	r &= ~data->conf_mask;
+	r |= data->conf_enable;
+	writel_relaxed(r, mmp_icu_base + (hwirq << 2));
+}
+
 struct irq_chip icu_irq_chip = {
 	.name		= "icu_irq",
 	.irq_mask	= icu_mask_irq,
@@ -491,5 +538,82 @@ err:
 	irq_domain_remove(icu_data[i].domain);
 	return -EINVAL;
 }
+
+void __init mmp_of_wakeup_init(void)
+{
+	struct device_node *node;
+	const __be32 *wakeup_reg;
+	const __be32 *cp_irq_reg;
+	int ret, nr_irqs;
+	int size, i = 0;
+	int irq;
+
+	node = of_find_compatible_node(NULL, NULL, "mrvl,mmp-intc-wakeupgen");
+	if (!node) {
+		pr_err("Failed to find interrupt controller in arch-mmp\n");
+		return;
+	}
+
+	mmp_icu_base = of_iomap(node, 0);
+	if (!mmp_icu_base) {
+		pr_err("Failed to get interrupt controller register\n");
+		return;
+	}
+
+	ret = of_property_read_u32(node, "mrvl,intc-nr-irqs", &nr_irqs);
+	if (ret) {
+		pr_err("Not found mrvl,intc-nr-irqs property\n");
+		return;
+	}
+
+	/*
+	 * Config all the interrupt source be able to interrupt the cpu 0,
+	 * in IRQ mode, with priority 0 as masked by default.
+	 */
+	for (irq = 0; irq < nr_irqs; irq++)
+		__raw_writel(ICU_IRQ_CPU0_MASKED, mmp_icu_base + (irq << 2));
+
+	/* ICU is only used as wake up logic
+	  * disable the global irq/fiq in icu for all cores.
+	  */
+	wakeup_reg = of_get_property(node, "mrvl,intc-gbl-mask", &size);
+	if (!wakeup_reg) {
+		pr_err("Not found mrvl,intc-gbl-mask property\n");
+		return;
+	}
+
+	size /= sizeof(*wakeup_reg);
+	while (i < size) {
+		unsigned offset, val;
+
+		offset = be32_to_cpup(wakeup_reg + i++);
+		val = be32_to_cpup(wakeup_reg + i++);
+		writel_relaxed(val, mmp_icu_base + offset);
+	}
+
+	/* Get the irq lines and ignore irqs */
+	cp_irq_reg = of_get_property(node, "mrvl,intc-for-cp", &size);
+	if (!cp_irq_reg)
+		return;
+
+	irq_for_cp_nr = size / sizeof(*cp_irq_reg);
+	for (i = 0; i < irq_for_cp_nr; i++) {
+		irq_for_cp[i] = be32_to_cpup(cp_irq_reg + i);
+		__raw_writel(ICU_CONF_SEAGULL, mmp_icu_base + (irq_for_cp[i] << 2));
+	}
+
+	icu_data[0].conf_enable = mmp_conf.conf_enable;
+	icu_data[0].conf_disable = mmp_conf.conf_disable;
+	icu_data[0].conf_mask = mmp_conf.conf_mask;
+	icu_data[0].nr_irqs = nr_irqs;
+	icu_data[0].virq_base = 32;
+
+	gic_arch_extn.irq_mask = icu_mask_irq_wakeup;
+	gic_arch_extn.irq_unmask = icu_unmask_irq_wakeup;
+	gic_arch_extn.irq_set_affinity = icu_set_affinity;
+
+	return;
+}
+
 IRQCHIP_DECLARE(mmp2_mux_intc, "mrvl,mmp2-mux-intc", mmp2_mux_of_init);
 #endif
diff --git a/include/linux/irqchip/mmp.h b/include/linux/irqchip/mmp.h
index c78a892..0f22f57 100644
--- a/include/linux/irqchip/mmp.h
+++ b/include/linux/irqchip/mmp.h
@@ -1,6 +1,20 @@
 #ifndef	__IRQCHIP_MMP_H
 #define	__IRQCHIP_MMP_H
 
+#define ICU_CONF_CPU3      (1 << 9)
+#define ICU_CONF_CPU2      (1 << 8)
+#define ICU_CONF_CPU1      (1 << 7)
+#define ICU_CONF_CPU0      (1 << 6)
+#define ICU_CONF_AP(n)     (1 << (6 + (n & 0x3)))
+#define ICU_CONF_AP_MASK   (0xF << 6)
+#define ICU_CONF_SEAGULL   (1 << 5)
+#define ICU_CONF_IRQ_FIQ   (1 << 4)
+#define ICU_CONF_PRIO(n)   (n & 0xF)
+
+#define ICU_IRQ_CPU0_MASKED    (ICU_CONF_IRQ_FIQ | ICU_CONF_CPU0)
+
 extern struct irq_chip icu_irq_chip;
 
+extern void __init mmp_of_wakeup_init(void);
+
 #endif	/* __IRQCHIP_MMP_H */
-- 
1.7.9.5

