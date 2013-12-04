Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3LDMNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:13:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12114 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755287Ab3LDMNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:13:48 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <mark.rutland@arm.com>, <haojian.zhuang@gmail.com>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH v3] irqchip: mmp: add dt support for wakeup
Date: Wed, 4 Dec 2013 20:13:34 +0800
Message-ID: <1386159214-31483-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-12-04_04:2013-12-04,2013-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312040043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the Marvell SoCs use GIC as its interrupt controller,and ICU
only used as wakeup logic. When AP subsystem is powered off, GIC will
lose its context, the PMU will need ICU to wakeup the AP subsystem.
So add wakeup entry for such kind of usage.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 .../devicetree/bindings/arm/mrvl/intc.txt          |   12 +-
 drivers/irqchip/irq-mmp.c                          |  116 ++++++++++++++++++++
 include/linux/irqchip/mmp.h                        |   13 +++
 3 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/mrvl/intc.txt b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
index 8b53273..401be87 100644
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
@@ -39,6 +42,13 @@ Example:
 		mrvl,intc-nr-irqs = <2>;
 	};
 
+	intc: interrupt-controller@d4282000 {
+		compatible = "mrvl,mmp-intc";
+		reg = <0xd4282000 0x1000>;
+		mrvl,intc-wakeup = <0x114 0x3
+		                    0x144 0x3>;
+	};
+
 * Marvell Orion Interrupt controller
 
 Required properties
diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
index 470c5de..6a2f4d1 100644
--- a/drivers/irqchip/irq-mmp.c
+++ b/drivers/irqchip/irq-mmp.c
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/irqchip/mmp.h>
+#include <linux/irqchip/arm-gic.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/of_address.h>
@@ -58,6 +60,8 @@ struct mmp_intc_conf {
 static void __iomem *mmp_icu_base;
 static struct icu_chip_data icu_data[MAX_ICU_NR];
 static int max_icu_nr;
+static u32 irq_for_cp[64];
+static u32 irq_for_cp_nr;	/* How many irqs will be routed to cp */
 
 extern void mmp2_clear_pmic_int(void);
 
@@ -123,6 +127,50 @@ static void icu_unmask_irq(struct irq_data *d)
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
@@ -491,5 +539,73 @@ err:
 	irq_domain_remove(icu_data[i].domain);
 	return -EINVAL;
 }
+
+void __init mmp_of_wakeup_init(void)
+{
+	struct device_node *node;
+	int ret, nr_irqs;
+	int irq, i = 0;
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
+	i = 0;
+	while (1) {
+		u32 offset, val;
+		if (of_property_read_u32_index(node, "mrvl,intc-gbl-mask", i++, &offset))
+			break;
+		if (of_property_read_u32_index(node, "mrvl,intc-gbl-mask", i++, &val)) {
+			pr_warn("The params should keep pair!!!\n");
+			break;
+		}
+
+		writel_relaxed(val, mmp_icu_base + offset);
+	}
+
+	/* Get the irq lines for cp */
+	i = 0;
+	while (!of_property_read_u32_index(node, "mrvl,intc-for-cp", i, &irq_for_cp[i])) {
+		writel_relaxed(ICU_CONF_SEAGULL, mmp_icu_base + (irq_for_cp[i] << 2));
+		i++;
+	}
+	irq_for_cp_nr = i;
+
+	icu_data[0].conf_enable = mmp_conf.conf_enable;
+	icu_data[0].conf_disable = mmp_conf.conf_disable;
+	icu_data[0].conf_mask = mmp_conf.conf_mask;
+	icu_data[0].nr_irqs = nr_irqs;
+	icu_data[0].virq_base = 32;
+
+	gic_arch_extn.irq_mask = icu_mask_irq_wakeup;
+	gic_arch_extn.irq_unmask = icu_unmask_irq_wakeup;
+
+	return;
+}
+
 IRQCHIP_DECLARE(mmp2_mux_intc, "mrvl,mmp2-mux-intc", mmp2_mux_of_init);
 #endif
diff --git a/include/linux/irqchip/mmp.h b/include/linux/irqchip/mmp.h
index c78a892..93b05ad 100644
--- a/include/linux/irqchip/mmp.h
+++ b/include/linux/irqchip/mmp.h
@@ -1,6 +1,19 @@
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
 #endif	/* __IRQCHIP_MMP_H */
-- 
1.7.9.5

