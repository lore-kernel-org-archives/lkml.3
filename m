Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3KSWDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:03:10 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:34218 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464Ab3KSWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:03:07 -0500
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2013 17:03:06 EST
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: jcm@redhat.com, Catalin.Marinas@arm.com, Feng Kan <fkan@apm.com>
Subject: [PATCH 1/1] irq-gic: add capability to set bypass flag in GIC
Date: Tue, 19 Nov 2013 13:42:38 -0800
Message-Id: <1384897358-22940-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GIC-400 implementation allows for FIQ and IRQ bypass. In the
X-Gene implementation, the FIQ bypass must be enabled at all time.
Otherwise, some PPI will appear as FIQ and cause kernel problem.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/irqchip/irq-gic.c       |   15 +++++++++++----
 include/linux/irqchip/arm-gic.h |    4 ++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d0e9480..aa7342e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -65,6 +65,7 @@ struct gic_chip_data {
 #endif
 	struct irq_domain *domain;
 	unsigned int gic_irqs;
+	unsigned int bypass_flag;
 #ifdef CONFIG_GIC_NON_BANKED
 	void __iomem *(*get_base)(union gic_base *);
 #endif
@@ -450,7 +451,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
 
 	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+	writel_relaxed(gic->bypass_flag | 1, base + GIC_CPU_CTRL);
 }
 
 void gic_cpu_if_down(void)
@@ -591,7 +592,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(gic_data[gic_nr].bypass_flag | 1, cpu_base + GIC_CPU_CTRL);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
@@ -733,7 +734,8 @@ const struct irq_domain_ops gic_irq_domain_ops = {
 
 void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 			   void __iomem *dist_base, void __iomem *cpu_base,
-			   u32 percpu_offset, struct device_node *node)
+			   u32 percpu_offset, u32 bypass_val,
+			   struct device_node *node)
 {
 	irq_hw_number_t hwirq_base;
 	struct gic_chip_data *gic;
@@ -821,6 +823,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 
 	set_handle_irq(gic_handle_irq);
 
+	gic->bypass_flag = (bypass_val & 0xf) << 4;
 	gic_chip.flags |= gic_arch_extn.flags;
 	gic_dist_init(gic);
 	gic_cpu_init(gic);
@@ -835,6 +838,7 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 	void __iomem *cpu_base;
 	void __iomem *dist_base;
 	u32 percpu_offset;
+	u32 bypass_val;
 	int irq;
 
 	if (WARN_ON(!node))
@@ -849,7 +853,10 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
-	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
+	if (of_property_read_u32(node, "bypass-flags", &bypass_val))
+		bypass_val = 0;
+
+	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, bypass_val, node);
 
 	if (parent) {
 		irq = irq_of_parse_and_map(node, 0);
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 0e5d9ec..999515b 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -64,14 +64,14 @@ struct device_node;
 extern struct irq_chip gic_arch_extn;
 
 void gic_init_bases(unsigned int, int, void __iomem *, void __iomem *,
-		    u32 offset, struct device_node *);
+		    u32 offset, u32 bypass_val, struct device_node *);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_cpu_if_down(void);
 
 static inline void gic_init(unsigned int nr, int start,
 			    void __iomem *dist , void __iomem *cpu)
 {
-	gic_init_bases(nr, start, dist, cpu, 0, NULL);
+	gic_init_bases(nr, start, dist, cpu, 0, 0, NULL);
 }
 
 #endif /* __ASSEMBLY */
-- 
1.7.6.1

