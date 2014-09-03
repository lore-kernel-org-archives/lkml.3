Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaICJH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:07:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44139 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755997AbaICJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:07:55 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/5] irqchip: atmel-aic: add irq fixup for RTT block
Date: Wed,  3 Sep 2014 11:07:47 +0200
Message-Id: <1409735271-15353-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new fixup function for the RTT (Real Time Timer) block.

This fixup function was previously implemented in
arch/arm/mach-at91/sysirq_mask.c, but is now moved to the AIC driver so
that we can remove SoC specific hooks in arch/arm/mach-at91/ when booting
a DT kernel.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic-common.c | 26 ++++++++++++++++++++++++++
 drivers/irqchip/irq-atmel-aic-common.h |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index 6ae3cdee..656cfe3 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -167,6 +167,32 @@ void __init aic_common_rtc_irq_fixup(struct device_node *root)
 	iounmap(regs);
 }
 
+#define AT91_RTT_MR		0x00			/* Real-time Mode Register */
+#define AT91_RTT_ALMIEN		(1 << 16)		/* Alarm Interrupt Enable */
+#define AT91_RTT_RTTINCIEN	(1 << 17)		/* Real Time Timer Increment Interrupt Enable */
+
+void __init aic_common_rtt_irq_fixup(struct device_node *root)
+{
+	struct device_node *np;
+	void __iomem *regs;
+
+	/*
+	 * The at91sam9263 SoC has 2 instances of the RTT block, hence we
+	 * iterate over the DT to find each occurrence.
+	 */
+	for_each_compatible_node(np, NULL, "atmel,at91sam9260-rtt") {
+		regs = of_iomap(np, 0);
+		if (!regs)
+			continue;
+
+		writel(readl(regs + AT91_RTT_MR) &
+		       ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN),
+		       regs + AT91_RTT_MR);
+
+		iounmap(regs);
+	}
+}
+
 void __init aic_common_irq_fixup(const struct of_device_id *matches)
 {
 	struct device_node *root = of_find_node_by_path("/");
diff --git a/drivers/irqchip/irq-atmel-aic-common.h b/drivers/irqchip/irq-atmel-aic-common.h
index 90aa00e..603f0a9 100644
--- a/drivers/irqchip/irq-atmel-aic-common.h
+++ b/drivers/irqchip/irq-atmel-aic-common.h
@@ -34,6 +34,8 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 
 void __init aic_common_rtc_irq_fixup(struct device_node *root);
 
+void __init aic_common_rtt_irq_fixup(struct device_node *root);
+
 void __init aic_common_irq_fixup(const struct of_device_id *matches);
 
 #endif /* __IRQ_ATMEL_AIC_COMMON_H */
-- 
1.9.1

