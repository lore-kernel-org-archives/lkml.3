Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaCMSFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:05:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbaCMSE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:04:29 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 1/4] irq: Add a new IRQCHIP_EOI_THREADED flag
Date: Thu, 13 Mar 2014 19:03:51 +0100
Message-Id: <1394733834-26839-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This flag must be used in combination with handle_fasteoi_irq, when set
handle_fasteoi_irq will delay the calling of chip->irq_eoi until the threaded
handler has run.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 include/linux/irq.h    |  3 +++
 kernel/irq/chip.c      | 48 ++++++++++++++++++++++++++++++++++++++++--------
 kernel/irq/internals.h |  1 +
 kernel/irq/manage.c    |  2 +-
 4 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..0f036fb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -349,6 +349,8 @@ struct irq_chip {
  * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
  *				when irq enabled
  * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
+ * IRQCHIP_ONESHOT_SAFE:	One shot does not require mask/unmask
+ * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -357,6 +359,7 @@ enum {
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
 	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
+	IRQCHIP_EOI_THREADED		= (1 <<  6),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c16..6397df2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -281,6 +281,19 @@ void unmask_irq(struct irq_desc *desc)
 	}
 }
 
+void unmask_threaded_irq(struct irq_desc *desc)
+{
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	if (chip->flags & IRQCHIP_EOI_THREADED)
+		chip->irq_eoi(&desc->irq_data);
+
+	if (chip->irq_unmask) {
+		chip->irq_unmask(&desc->irq_data);
+		irq_state_clr_masked(desc);
+	}
+}
+
 /*
  *	handle_nested_irq - Handle a nested irq from a irq thread
  *	@irq:	the interrupt number
@@ -435,6 +448,27 @@ static inline void preflow_handler(struct irq_desc *desc)
 static inline void preflow_handler(struct irq_desc *desc) { }
 #endif
 
+static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
+{
+	if (!(desc->istate & IRQS_ONESHOT)) {
+		chip->irq_eoi(&desc->irq_data);
+		return;
+	}
+	/*
+	 * We need to unmask in the following cases:
+	 * - Oneshot irq which did not wake the thread (caused by a
+	 *   spurious interrupt or a primary handler handling it
+	 *   completely).
+	 */
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
+		chip->irq_eoi(&desc->irq_data);
+		unmask_irq(desc);
+	} else if (!(chip->flags & IRQCHIP_EOI_THREADED)) {
+		chip->irq_eoi(&desc->irq_data);
+	}
+}
+
 /**
  *	handle_fasteoi_irq - irq handler for transparent controllers
  *	@irq:	the interrupt number
@@ -448,6 +482,8 @@ static inline void preflow_handler(struct irq_desc *desc) { }
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
+	struct irq_chip *chip = desc->irq_data.chip;
+
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
@@ -473,18 +509,14 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	preflow_handler(desc);
 	handle_irq_event(desc);
 
-	if (desc->istate & IRQS_ONESHOT)
-		cond_unmask_irq(desc);
+	cond_unmask_eoi_irq(desc, chip);
 
-out_eoi:
-	desc->irq_data.chip->irq_eoi(&desc->irq_data);
-out_unlock:
 	raw_spin_unlock(&desc->lock);
 	return;
 out:
-	if (!(desc->irq_data.chip->flags & IRQCHIP_EOI_IF_HANDLED))
-		goto out_eoi;
-	goto out_unlock;
+	if (!(chip->flags & IRQCHIP_EOI_IF_HANDLED))
+		chip->irq_eoi(&desc->irq_data);
+	raw_spin_unlock(&desc->lock);
 }
 
 /**
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 001fa5b..e98bb56 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -73,6 +73,7 @@ extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
 extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
 extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
+extern void unmask_threaded_irq(struct irq_desc *desc);
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..9147fef 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -718,7 +718,7 @@ again:
 
 	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
 	    irqd_irq_masked(&desc->irq_data))
-		unmask_irq(desc);
+		unmask_threaded_irq(desc);
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
-- 
1.9.0

