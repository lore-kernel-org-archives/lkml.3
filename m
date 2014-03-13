Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaCMOb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:31:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:51198 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaCMOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:31:57 -0400
Date: Thu, 13 Mar 2014 15:32:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Carlo Caione <carlo.caione@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flagq 
In-Reply-To: <20140313133707.GA24821@linutronix.de>
Message-ID: <alpine.DEB.2.02.1403131442480.18573@ionos.tec.linutronix.de>
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de> <20140313133707.GA24821@linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Sebastian Andrzej Siewior wrote:
> One side note: Since we need to specify IRQCHIP_EOI_THREADED and
> handle_fasteoi_late_irq() as the handler, would it be easily doable to use
> the handle_fasteoi_irq() handler and skip the EOI in the threaded mode?
> But if it creates a mess then leave it as it is.

Yeah, I was looking into that already. Patch below.

To resemble the late version you need to add IRQCHIP_EOI_THREADED and
IRQCHIP_EOI_IF_HANDLED to your irq chip.

Thanks,

	tglx

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -355,6 +355,8 @@ struct irq_chip {
  * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
  *				when irq enabled
  * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
+ * IRQCHIP_ONESHOT_SAFE:	One shot does not require mask/unmask
+ * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -363,6 +365,7 @@ enum {
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
 	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
+	IRQCHIP_EOI_THREADED		= (1 <<  6),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
Index: tip/kernel/irq/chip.c
===================================================================
--- tip.orig/kernel/irq/chip.c
+++ tip/kernel/irq/chip.c
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
@@ -435,6 +448,27 @@ static inline void preflow_handler(struc
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
@@ -448,6 +482,8 @@ static inline void preflow_handler(struc
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
+	struct irq_chip *chip = desc->irq_data.chip;
+
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
@@ -473,18 +509,14 @@ handle_fasteoi_irq(unsigned int irq, str
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
Index: tip/kernel/irq/internals.h
===================================================================
--- tip.orig/kernel/irq/internals.h
+++ tip/kernel/irq/internals.h
@@ -74,6 +74,7 @@ extern void irq_percpu_enable(struct irq
 extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
 extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
+extern void unmask_threaded_irq(struct irq_desc *desc);
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
@@ -748,7 +748,7 @@ again:
 
 	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
 	    irqd_irq_masked(&desc->irq_data))
-		unmask_irq(desc);
+		unmask_threaded_irq(desc);
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);

