Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaJYVvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:51:12 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:36433 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbaJYVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:51:09 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] genirq: Add support for priority-drop/deactivate interrupt controllers
Date: Sat, 25 Oct 2014 12:06:53 +0100
Message-Id: <1414235215-10468-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com>
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: tglx@linutronix.de, jason@lakedaemon.net, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moderately recent ARM interrupt controllers can use a "split mode" EOI,
where instead of just using a single write to notify the controller of
the end of interrupt, uses the following:
- priority-drop: the interrupt is still active, but other interrupts can
  now be taken
- deactivate: the interrupt is not active anymore, and can be taken again.

This makes it very useful for threaded interrupts, as it avoids the usual
mask/unmask dance (and has the potential of being more efficient on ARM,
as it is using the CPU interface instead of the global distributor).

To implement this, a new optional irqchip method is added (irq_priority_drop).
The usual irq_eoi is expected to implement the deactivate method.

Non threaded interrupts are using these two callbacks back to back, but threaded
ones only perform the irq_priority_drop call in the interrupt context, leaving
the irq_eoi call to the thread context (which are expected to use the
IRQCHIP_EOI_THREADED flag).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irq.h |  1 +
 kernel/irq/chip.c   | 53 +++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 257d59a..64d3756 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -330,6 +330,7 @@ struct irq_chip {
 	void		(*irq_mask)(struct irq_data *data);
 	void		(*irq_mask_ack)(struct irq_data *data);
 	void		(*irq_unmask)(struct irq_data *data);
+	void		(*irq_priority_drop)(struct irq_data *data);
 	void		(*irq_eoi)(struct irq_data *data);
 
 	int		(*irq_set_affinity)(struct irq_data *data, const struct cpumask *dest, bool force);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index e5202f0..cf9d001 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -272,12 +272,25 @@ void mask_irq(struct irq_desc *desc)
 	}
 }
 
+static void mask_threaded_irq(struct irq_desc *desc)
+{
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	/* If we can do priority drop, then masking comes for free */
+	if (chip->irq_priority_drop)
+		irq_state_set_masked(desc);
+	else
+		mask_irq(desc);
+}
+
 void unmask_irq(struct irq_desc *desc)
 {
-	if (desc->irq_data.chip->irq_unmask) {
-		desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	if (chip->irq_unmask && !chip->irq_priority_drop)
+		chip->irq_unmask(&desc->irq_data);
+	if (chip->irq_unmask || chip->irq_priority_drop)
 		irq_state_clr_masked(desc);
-	}
 }
 
 void unmask_threaded_irq(struct irq_desc *desc)
@@ -287,10 +300,7 @@ void unmask_threaded_irq(struct irq_desc *desc)
 	if (chip->flags & IRQCHIP_EOI_THREADED)
 		chip->irq_eoi(&desc->irq_data);
 
-	if (chip->irq_unmask) {
-		chip->irq_unmask(&desc->irq_data);
-		irq_state_clr_masked(desc);
-	}
+	unmask_irq(desc);
 }
 
 /*
@@ -470,12 +480,24 @@ static inline void preflow_handler(struct irq_desc *desc)
 static inline void preflow_handler(struct irq_desc *desc) { }
 #endif
 
+static void eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
+{
+	if (chip->irq_priority_drop)
+		chip->irq_priority_drop(&desc->irq_data);
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
+}
+
 static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
 {
 	if (!(desc->istate & IRQS_ONESHOT)) {
-		chip->irq_eoi(&desc->irq_data);
+		eoi_irq(desc, chip);
 		return;
 	}
+
+	if (chip->irq_priority_drop)
+		chip->irq_priority_drop(&desc->irq_data);
+
 	/*
 	 * We need to unmask in the following cases:
 	 * - Oneshot irq which did not wake the thread (caused by a
@@ -485,7 +507,8 @@ static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
 	if (!irqd_irq_disabled(&desc->irq_data) &&
 	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
 		chip->irq_eoi(&desc->irq_data);
-		unmask_irq(desc);
+		if (!chip->irq_priority_drop)
+			unmask_irq(desc);
 	} else if (!(chip->flags & IRQCHIP_EOI_THREADED)) {
 		chip->irq_eoi(&desc->irq_data);
 	}
@@ -525,7 +548,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	}
 
 	if (desc->istate & IRQS_ONESHOT)
-		mask_irq(desc);
+		mask_threaded_irq(desc);
 
 	preflow_handler(desc);
 	handle_irq_event(desc);
@@ -536,7 +559,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	return;
 out:
 	if (!(chip->flags & IRQCHIP_EOI_IF_HANDLED))
-		chip->irq_eoi(&desc->irq_data);
+		eoi_irq(desc, chip);
 	raw_spin_unlock(&desc->lock);
 }
 EXPORT_SYMBOL_GPL(handle_fasteoi_irq);
@@ -655,7 +678,7 @@ void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc)
 		 !irqd_irq_disabled(&desc->irq_data));
 
 out_eoi:
-	chip->irq_eoi(&desc->irq_data);
+	eoi_irq(desc, chip);
 	raw_spin_unlock(&desc->lock);
 }
 #endif
@@ -679,8 +702,7 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 
 	handle_irq_event_percpu(desc, desc->action);
 
-	if (chip->irq_eoi)
-		chip->irq_eoi(&desc->irq_data);
+	eoi_irq(desc, chip);
 }
 
 /**
@@ -711,8 +733,7 @@ void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
 	res = action->handler(irq, dev_id);
 	trace_irq_handler_exit(irq, action, res);
 
-	if (chip->irq_eoi)
-		chip->irq_eoi(&desc->irq_data);
+	eoi_irq(desc, chip);
 }
 
 void
-- 
2.1.0

