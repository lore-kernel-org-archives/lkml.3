Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaFYJ3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:29:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51390 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755469AbaFYJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:29:00 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, eric.auger@linaro.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 6/9] irqchip: GICv3: add support for forwarded interrupts
Date: Wed, 25 Jun 2014 10:28:47 +0100
Message-Id: <1403688530-23273-7-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've switched to EOImode == 1, prevent a forwarded interrupt
from being deactivated after its priority has been dropped.

Also add support for the interrupt state to be saved/restored.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   |  3 ++-
 drivers/irqchip/irq-gic-v3.c       | 29 ++++++++++++++++++++++++++++-
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 922f228..7c354ff 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -616,7 +616,8 @@ static void its_unmask_irq(struct irq_data *d)
 static void its_eoi_irq(struct irq_data *d)
 {
 	gic_write_eoir(d->hwirq);
-	gic_write_dir(d->hwirq);
+	if (!irqd_irq_forwarded(d))
+		gic_write_dir(d->hwirq);
 }
 
 static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 26a08ce..1f080d6 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -235,10 +235,35 @@ static void gic_unmask_irq(struct irq_data *d)
 	gic_poke_irq(d, GICD_ISENABLER);
 }
 
+static void gic_irq_set_fwd_state(struct irq_data *d, u32 val, u32 mask)
+{
+	if (mask & IRQ_FWD_STATE_PENDING)
+		gic_poke_irq(d, (val & IRQ_FWD_STATE_PENDING) ? GICD_ISPENDR : GICD_ICPENDR);
+	if (mask & IRQ_FWD_STATE_ACTIVE)
+		gic_poke_irq(d, (val & IRQ_FWD_STATE_ACTIVE) ? GICD_ISACTIVER : GICD_ICACTIVER);
+	if (mask & IRQ_FWD_STATE_MASKED)
+		gic_poke_irq(d, (val & IRQ_FWD_STATE_MASKED) ? GICD_ICENABLER : GICD_ISENABLER);
+}
+
+static u32 gic_irq_get_fwd_state(struct irq_data *d, u32 mask)
+{
+	u32 val = 0;
+
+	if ((mask & IRQ_FWD_STATE_PENDING) && gic_peek_irq(d, GICD_ISPENDR))
+		val |= IRQ_FWD_STATE_PENDING;
+	if ((mask & IRQ_FWD_STATE_ACTIVE) && gic_peek_irq(d, GICD_ISACTIVER))
+		val |= IRQ_FWD_STATE_ACTIVE;
+	if ((mask & IRQ_FWD_STATE_MASKED) && !gic_peek_irq(d, GICD_ISENABLER))
+		val |= IRQ_FWD_STATE_MASKED;
+
+	return val;
+}
+
 static void gic_eoi_irq(struct irq_data *d)
 {
 	gic_write_eoir(gic_irq(d));
-	gic_write_dir(gic_irq(d));
+	if (!irqd_irq_forwarded(d))
+		gic_write_dir(gic_irq(d));
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
@@ -598,6 +623,8 @@ static struct irq_chip gic_chip = {
 	.irq_eoi		= gic_eoi_irq,
 	.irq_set_type		= gic_set_type,
 	.irq_set_affinity	= gic_set_affinity,
+	.irq_get_fwd_state	= gic_irq_get_fwd_state,
+	.irq_set_fwd_state	= gic_irq_set_fwd_state,
 };
 
 static struct irq_chip *its_chip;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index a0bff2f..0e74c19 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -90,6 +90,8 @@
 #define GICR_SYNCR			0x00C0
 #define GICR_MOVLPIR			0x0100
 #define GICR_MOVALLR			0x0110
+#define GICR_ISACTIVER			GICD_ISACTIVER
+#define GICR_ICACTIVER			GICD_ICACTIVER
 #define GICR_IDREGS			GICD_IDREGS
 #define GICR_PIDR2			GICD_PIDR2
 
-- 
1.8.3.4

