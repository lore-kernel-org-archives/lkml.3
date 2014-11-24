Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaKXOfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:35:36 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37961 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaKXOfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:32 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: [PATCH v3 02/13] irqchip: GICv3: Convert to domain hierarchy
Date: Mon, 24 Nov 2014 14:35:09 +0000
Message-Id: <1416839720-18400-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to start supporting stacked domains, convert the GICv3
code base to the new domain hierarchy framework, which mostly
amounts to supporting the new alloc/free callbacks.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/Kconfig      |  1 +
 drivers/irqchip/irq-gic-v3.c | 42 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

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
index aa17ae8..4cb355a 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -594,14 +594,14 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	/* PPIs */
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_percpu_devid_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_percpu_devid_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	}
 	/* SPIs */
 	if (hw >= 32 && hw < gic_data.irq_nr) {
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_fasteoi_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_fasteoi_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 	irq_set_chip_data(irq, d->host_data);
@@ -633,9 +633,41 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
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
+		struct irq_data *d = irq_domain_get_irq_data(domain, virq + i);
+		irq_set_handler(virq + i, NULL);
+		irq_domain_reset_irq_data(d);
+	}
+}
+
 static const struct irq_domain_ops gic_irq_domain_ops = {
-	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
+	.alloc = gic_irq_domain_alloc,
+	.free = gic_irq_domain_free,
 };
 
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
-- 
2.1.3

