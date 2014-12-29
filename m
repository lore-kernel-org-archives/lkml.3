Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaL2Xc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:32:29 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41062 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaL2Xc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 02/12] irqchip: nvic: support hierarchy irq domain
Date: Tue, 30 Dec 2014 00:32:05 +0100
Message-Id: <1419895935-22966-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for hierarchy irq domain. Use to support the interrupt
router found in Vybrid SoC, which is between the NVIC and the
peripherals.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/irqchip/irq-nvic.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index 4ff0805..5fac910 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -49,6 +49,31 @@ nvic_handle_irq(irq_hw_number_t hwirq, struct pt_regs *regs)
 	handle_IRQ(irq, regs);
 }
 
+static int nvic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;
+	struct of_phandle_args *irq_data = arg;
+
+	ret = irq_domain_xlate_onecell(domain, irq_data->np, irq_data->args,
+				   irq_data->args_count, &hwirq, &type);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++)
+		irq_map_generic_chip(domain, virq + i, hwirq + i);
+
+	return 0;
+}
+
+static const struct irq_domain_ops nvic_irq_domain_ops = {
+	.xlate = irq_domain_xlate_onecell,
+	.alloc = nvic_irq_domain_alloc,
+	.free = irq_domain_free_irqs_top,
+};
+
 static int __init nvic_of_init(struct device_node *node,
 			       struct device_node *parent)
 {
@@ -70,7 +95,8 @@ static int __init nvic_of_init(struct device_node *node,
 		irqs = NVIC_MAX_IRQ;
 
 	nvic_irq_domain =
-		irq_domain_add_linear(node, irqs, &irq_generic_chip_ops, NULL);
+		irq_domain_add_linear(node, irqs, &nvic_irq_domain_ops, NULL);
+
 	if (!nvic_irq_domain) {
 		pr_warn("Failed to allocate irq domain\n");
 		return -ENOMEM;
-- 
2.2.1

