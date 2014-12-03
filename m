Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaLCQSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:18:47 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44187 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaLCQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:18:43 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Bjorn Andersson <bjorn@kryo.se>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 3/3] irqchip: GICv3: Add support for irq_{get,set}_irqchip_state
Date: Wed,  3 Dec 2014 16:18:23 +0000
Message-Id: <1417623503-30261-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417623503-30261-1-git-send-email-marc.zyngier@arm.com>
References: <1417623503-30261-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the required hooks for the internal state of an interrupt
to be exposed to other subsystems.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c | 83 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 1a146cc..6e73846 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -195,6 +195,19 @@ static void gic_enable_redist(bool enable)
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
@@ -223,6 +236,61 @@ static void gic_unmask_irq(struct irq_data *d)
 	gic_poke_irq(d, GICD_ISENABLER);
 }
 
+static int gic_irq_set_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which, bool val)
+{
+	u32 reg;
+
+	if (d->hwirq >= gic_data.irq_nr) /* PPI/SPI only */
+		return -EINVAL;
+
+	switch (which) {
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
+		return -EINVAL;
+	}
+
+	gic_poke_irq(d, reg);
+	return 0;
+}
+
+static int gic_irq_get_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which, bool *val)
+{
+	if (d->hwirq >= gic_data.irq_nr) /* PPI/SPI only */
+		return -EINVAL;
+
+	switch (which) {
+	case IRQCHIP_STATE_PENDING:
+		*val = gic_peek_irq(d, GICD_ISPENDR);
+		break;
+
+	case IRQCHIP_STATE_ACTIVE:
+		*val = gic_peek_irq(d, GICD_ISACTIVER);
+		break;
+
+	case IRQCHIP_STATE_MASKED:
+		*val = !gic_peek_irq(d, GICD_ISENABLER);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void gic_eoi_irq(struct irq_data *d)
 {
 	gic_write_eoir(gic_irq(d));
@@ -418,19 +486,6 @@ static void gic_cpu_init(void)
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
@@ -597,6 +652,8 @@ static struct irq_chip gic_chip = {
 	.irq_eoi		= gic_eoi_irq,
 	.irq_set_type		= gic_set_type,
 	.irq_set_affinity	= gic_set_affinity,
+	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
+	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
 };
 
 #define GIC_ID_NR		(1U << gic_data.rdists.id_bits)
-- 
2.1.3

