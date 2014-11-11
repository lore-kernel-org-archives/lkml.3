Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaKKPs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:48:29 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56159 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:26 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 04/15] irqchip: GICv3: Convert to domain hierarchy
Date: Tue, 11 Nov 2014 15:48:02 +0000
Message-Id: <1415720893-13371-5-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to start supporting stacked domains, convert the GICv3
code base to the new domain hierarchy framework, which mostly
amounts to supporting the new alloc/free callbacks.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/Kconfig      |  1 +
 drivers/irqchip/irq-gic-v3.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b21f12f..4631685 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -14,6 +14,7 @@ config ARM_GIC_V3
 	bool
 	select IRQ_DOMAIN
 	select MULTI_IRQ_HANDLER
+	select IRQ_DOMAIN_HIERARCHY
 
 config ARM_NVIC
 	bool
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index aa17ae8..a2770b6 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -594,14 +594,16 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	/* PPIs */
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_percpu_devid_irq);
+		irq_domain_set_hwirq_and_chip(d, irq, hw,
+					      &gic_chip, d->host_data);
+		irq_set_handler(irq, handle_percpu_devid_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	}
 	/* SPIs */
 	if (hw >= 32 && hw < gic_data.irq_nr) {
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_fasteoi_irq);
+		irq_domain_set_hwirq_and_chip(d, irq, hw,
+					      &gic_chip, d->host_data);
+		irq_set_handler(irq, handle_fasteoi_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 	irq_set_chip_data(irq, d->host_data);
@@ -633,9 +635,41 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 	return 0;
 }
 
+static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;
+	struct of_phandle_args *irq_data = arg;
+
+	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
+				   irq_data->args_count, &hwirq, &type);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++)
+		gic_irq_domain_map(domain, virq + i, hwirq + i);
+
+	return 0;
+}
+
+static void gic_irq_domain_free(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs)
+{
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_set_handler(virq + i, NULL);
+		irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
+	}
+}
+
+
 static const struct irq_domain_ops gic_irq_domain_ops = {
-	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
+	.alloc = gic_irq_domain_alloc,
+	.free = gic_irq_domain_free,
 };
 
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
-- 
2.0.4

