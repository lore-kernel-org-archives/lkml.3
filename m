Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaGJS0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:26:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58033 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865AbaGJSZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:25:47 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/3] irqchip: atmel-aic: Implement RTC irq fixup
Date: Thu, 10 Jul 2014 20:25:40 +0200
Message-Id: <1405016741-2407-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an implementation to fix RTC irqs before enabling the irqchip.

This was previously done in arch/arm/mach-at91/sysirq_mask.c but as we're
trying to use standard implementation (IRQCHIP_DECLARE and automatic call
of irqchip_init within arch/arm/kernel/irq.c) we need to do those fixups
in the irqchip driver.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic-common.c | 28 ++++++++++++++++++++++++++++
 drivers/irqchip/irq-atmel-aic-common.h |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index 4705bdb..6ae3cdee 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -139,6 +139,34 @@ static void __init aic_common_ext_irq_of_init(struct irq_domain *domain)
 	}
 }
 
+#define AT91_RTC_IDR           0x24
+#define AT91_RTC_IMR           0x28
+#define AT91_RTC_IRQ_MASK      0x1f
+
+void __init aic_common_rtc_irq_fixup(struct device_node *root)
+{
+	struct device_node *np;
+	void __iomem *regs;
+
+	np = of_find_compatible_node(root, NULL, "atmel,at91rm9200-rtc");
+	if (!np)
+		np = of_find_compatible_node(root, NULL,
+					     "atmel,at91sam9x5-rtc");
+
+	if (!np)
+		return;
+
+	regs = of_iomap(np, 0);
+	of_node_put(np);
+
+	if (!regs)
+		return;
+
+	writel(AT91_RTC_IRQ_MASK, regs + AT91_RTC_IDR);
+
+	iounmap(regs);
+}
+
 void __init aic_common_irq_fixup(const struct of_device_id *matches)
 {
 	struct device_node *root = of_find_node_by_path("/");
diff --git a/drivers/irqchip/irq-atmel-aic-common.h b/drivers/irqchip/irq-atmel-aic-common.h
index aa0a42c..90aa00e 100644
--- a/drivers/irqchip/irq-atmel-aic-common.h
+++ b/drivers/irqchip/irq-atmel-aic-common.h
@@ -32,6 +32,8 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 					     const struct irq_domain_ops *ops,
 					     const char *name, int nirqs);
 
+void __init aic_common_rtc_irq_fixup(struct device_node *root);
+
 void __init aic_common_irq_fixup(const struct of_device_id *matches);
 
 #endif /* __IRQ_ATMEL_AIC_COMMON_H */
-- 
1.8.3.2

