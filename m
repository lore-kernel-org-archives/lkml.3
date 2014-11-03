Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaKCIbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:31:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51380 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025AbaKCIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:31:09 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 1/5] irqchip: atmel-aic: add irq fixup for RTT block
Date: Mon,  3 Nov 2014 09:31:00 +0100
Message-Id: <1415003464-29239-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

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

