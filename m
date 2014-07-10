Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaGJSZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:25:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58022 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbaGJSZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:25:46 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/3] irqchip: atmel-aic: Add irq fixup infrastructure
Date: Thu, 10 Jul 2014 20:25:39 +0200
Message-Id: <1405016741-2407-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add irq fixup infrastructure to handle IP blocks connected to shared irqs
that are left in an unknown state when booting the kernel.

In this case the IP block which has not masked its interrupt and has no
driver loaded (either because it is not compiled or because it is not
loaded yet) might generate spurious interrupts when another IP block
request the shared irq.

A good example of this case is the RTC block on which register configs are
kept even after a shutdown (if a proper VDDcore is supplied), and thus
might generate spurious interrupts when the platform is switched on.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic-common.c | 19 +++++++++++++++++++
 drivers/irqchip/irq-atmel-aic-common.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index 18b76fc..4705bdb 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -139,6 +139,25 @@ static void __init aic_common_ext_irq_of_init(struct irq_domain *domain)
 	}
 }
 
+void __init aic_common_irq_fixup(const struct of_device_id *matches)
+{
+	struct device_node *root = of_find_node_by_path("/");
+	const struct of_device_id *match;
+
+	if (!root)
+		return;
+
+	match = of_match_node(matches, root);
+	of_node_put(root);
+
+	if (match) {
+		void (*fixup)(struct device_node *) = match->data;
+		fixup(root);
+	}
+
+	of_node_put(root);
+}
+
 struct irq_domain *__init aic_common_of_init(struct device_node *node,
 					     const struct irq_domain_ops *ops,
 					     const char *name, int nirqs)
diff --git a/drivers/irqchip/irq-atmel-aic-common.h b/drivers/irqchip/irq-atmel-aic-common.h
index c178557..aa0a42c 100644
--- a/drivers/irqchip/irq-atmel-aic-common.h
+++ b/drivers/irqchip/irq-atmel-aic-common.h
@@ -32,4 +32,6 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 					     const struct irq_domain_ops *ops,
 					     const char *name, int nirqs);
 
+void __init aic_common_irq_fixup(const struct of_device_id *matches);
+
 #endif /* __IRQ_ATMEL_AIC_COMMON_H */
-- 
1.8.3.2

