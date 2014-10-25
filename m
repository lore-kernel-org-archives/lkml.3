Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaJYVvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:51:16 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:46060 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbaJYVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:51:13 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Bjorn Andersson <bjorn@kryo.se>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] irqchip: GICv3: Add support for irq_{get,set}_irqchip_state
Date: Sat, 25 Oct 2014 11:14:57 +0100
Message-Id: <1414232097-4328-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: adharmap@codeaurora.org, pvo@apm.com, linus.walleij@linaro.org, tnhuynh@apm.com, yvo@apm.com, tglx@linutronix.de, toanle@apm.com, bjorn@kryo.se, arnd@arndb.de, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the required hooks for the internal state of an interrupt
to be exposed to other subsystems.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c | 78 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index aa17ae8..666c14e 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -193,6 +193,19 @@ static void gic_enable_redist(bool enable)
 /*
  * Routines to disable, enable, EOI and route interrupts
  */
+static int gic_peek_irq(struct irq_data *d, u32 offset)
+{
+	u32 mask = 1 << (gic_irq(d) % 32);
+	void __iomem *base;
+
+	if (gic_irq_in_rdist(d))
+		base = gic_data_rdist_sgi_base();
+	else
+		base = gic_data.dist_base;
+
+	return !!(readl_relaxed(base + offset + (gic_irq(d) / 32) * 4) & mask);
+}
+
 static void gic_poke_irq(struct irq_data *d, u32 offset)
 {
 	u32 mask = 1 << (gic_irq(d) % 32);
@@ -221,6 +234,56 @@ static void gic_unmask_irq(struct irq_data *d)
 	gic_poke_irq(d, GICD_ISENABLER);
 }
 
+static void gic_irq_set_irqchip_state(struct irq_data *d, int state, int val)
+{
+	u32 reg;
+
+	switch (state) {
+	case IRQCHIP_STATE_PENDING:
+		reg = val ? GICD_ISPENDR : GICD_ICPENDR;
+		break;
+
+	case IRQCHIP_STATE_ACTIVE:
+		reg = val ? GICD_ISACTIVER : GICD_ICACTIVER;
+		break;
+
+	case IRQCHIP_STATE_MASKED:
+		reg = val ? GICD_ICENABLER : GICD_ISENABLER;
+		break;
+
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	gic_poke_irq(d, reg);
+}
+
+static int gic_irq_get_irqchip_state(struct irq_data *d, int state)
+{
+	int val;
+
+	switch (state) {
+	case IRQCHIP_STATE_PENDING:
+		val = gic_peek_irq(d, GICD_ISPENDR);
+		break;
+
+	case IRQCHIP_STATE_ACTIVE:
+		val = gic_peek_irq(d, GICD_ISACTIVER);
+		break;
+
+	case IRQCHIP_STATE_MASKED:
+		val = !gic_peek_irq(d, GICD_ISENABLER);
+		break;
+
+	default:
+		WARN_ON(1);
+		val = 0;
+	}
+
+	return val;
+}
+
 static void gic_eoi_irq(struct irq_data *d)
 {
 	gic_write_eoir(gic_irq(d));
@@ -404,19 +467,6 @@ static void gic_cpu_init(void)
 }
 
 #ifdef CONFIG_SMP
-static int gic_peek_irq(struct irq_data *d, u32 offset)
-{
-	u32 mask = 1 << (gic_irq(d) % 32);
-	void __iomem *base;
-
-	if (gic_irq_in_rdist(d))
-		base = gic_data_rdist_sgi_base();
-	else
-		base = gic_data.dist_base;
-
-	return !!(readl_relaxed(base + offset + (gic_irq(d) / 32) * 4) & mask);
-}
-
 static int gic_secondary_init(struct notifier_block *nfb,
 			      unsigned long action, void *hcpu)
 {
@@ -583,6 +633,8 @@ static struct irq_chip gic_chip = {
 	.irq_eoi		= gic_eoi_irq,
 	.irq_set_type		= gic_set_type,
 	.irq_set_affinity	= gic_set_affinity,
+	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
+	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
 };
 
 static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
-- 
2.1.0

