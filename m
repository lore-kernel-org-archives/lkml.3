Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaL2Xce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:32:34 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41063 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaL2Xc0 (ORCPT
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
Subject: [PATCH v2 03/12] irqchip: vf610-mscm: support NVIC parent
Date: Tue, 30 Dec 2014 00:32:06 +0100
Message-Id: <1419895935-22966-4-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the NVIC interrupt controller as node parent of the MSCM
interrupt router. On the dual-core variants of Vybird (VF6xx), the
NVIC interrupt controller is used by the Cortex-M4. To support
running Linux on this core too, MSCM needs NVIC parent support too.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/irqchip/irq-vf610-mscm.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-vf610-mscm.c b/drivers/irqchip/irq-vf610-mscm.c
index 7a284d5..f4f7d78 100644
--- a/drivers/irqchip/irq-vf610-mscm.c
+++ b/drivers/irqchip/irq-vf610-mscm.c
@@ -30,6 +30,7 @@ struct vf610_mscm_chip_data {
 	void __iomem *mscm_base;
 	u16 cpu_mask;
 	u16 saved_irsprc[MSCM_IRSPRC_NUM];
+	bool is_nvic;
 };
 
 static struct vf610_mscm_chip_data *mscm_data;
@@ -74,6 +75,7 @@ static void vf610_mscm_enable(struct irq_data *data)
 {
 	irq_hw_number_t hwirq = data->hwirq;
 	struct vf610_mscm_chip_data *chip_data = data->chip_data;
+	struct irq_data *parent = data->parent_data;
 	u16 irsprc;
 
 	irsprc = readw_relaxed(chip_data->mscm_base + MSCM_IRSPRC(hwirq));
@@ -84,17 +86,24 @@ static void vf610_mscm_enable(struct irq_data *data)
 	writew_relaxed(chip_data->cpu_mask,
 		       chip_data->mscm_base + MSCM_IRSPRC(hwirq));
 
-	irq_chip_unmask_parent(data);
+	if (parent->chip->irq_enable)
+		parent->chip->irq_enable(parent);
+	else
+		parent->chip->irq_unmask(parent);
 }
 
 static void vf610_mscm_disable(struct irq_data *data)
 {
 	irq_hw_number_t hwirq = data->hwirq;
 	struct vf610_mscm_chip_data *chip_data = data->chip_data;
+	struct irq_data *parent = data->parent_data;
 
 	writew_relaxed(0x0, chip_data->mscm_base + MSCM_IRSPRC(hwirq));
 
-	irq_chip_mask_parent(data);
+	if (parent->chip->irq_enable)
+		parent->chip->irq_disable(parent);
+	else
+		parent->chip->irq_mask(parent);
 }
 
 static struct irq_chip vf610_mscm_irq_chip = {
@@ -126,10 +135,17 @@ static int vf610_mscm_domain_alloc(struct irq_domain *domain, unsigned int virq,
 					      domain->host_data);
 
 	gic_data.np = domain->parent->of_node;
-	gic_data.args_count = 3;
-	gic_data.args[0] = GIC_SPI;
-	gic_data.args[1] = irq_data->args[0];
-	gic_data.args[2] = irq_data->args[1];
+
+	if (mscm_data->is_nvic) {
+		gic_data.args_count = 1;
+		gic_data.args[0] = irq_data->args[0];
+	} else {
+		gic_data.args_count = 3;
+		gic_data.args[0] = GIC_SPI;
+		gic_data.args[1] = irq_data->args[0];
+		gic_data.args[2] = irq_data->args[1];
+	}
+
 	return irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, &gic_data);
 }
 
@@ -171,6 +187,9 @@ static int __init vf610_mscm_of_init(struct device_node *node,
 		goto out_unmap;
 	}
 
+	if (of_device_is_compatible(domain->parent->of_node, "arm,armv7m-nvic"))
+		mscm_data->is_nvic = true;
+
 	mscm_data->cpu_mask = 0x1 << readl_relaxed(mscm_data->mscm_base + MSCM_CPxNUM);
 
 	cpu_pm_register_notifier(&mscm_notifier_block);
-- 
2.2.1

