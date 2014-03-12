Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaCLRTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbaCLRRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:17:39 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 1/4] irq: Add handle_fasteoi_late_irq irq handler
Date: Wed, 12 Mar 2014 18:17:04 +0100
Message-Id: <1394644627-12315-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394644627-12315-1-git-send-email-hdegoede@redhat.com>
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Add an irq handler for transparent controllers

Only a single callback will be issued to the chip: an ->eoi() call when
the interrupt has been serviced. Same as handle_fasteoi_irq, but
we avoid the eoi when the interrupt is masked due to a
threaded handler. The eoi will be issued right before the unmask.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> In some cases we want to do an ack right before the unmask of an irq.
>
> A typical example of such a case is having an i2c device which uses a level
> interrupt. Such devices usually have an interrupt status register with
> write to clear status bits. This means that the interrupt handler needs to
> sleep to do i2c transfers to read / write the interrupt status register.
>
> This means using a threaded interrupt handler and IRQF_ONESHOT so that the
> interrupt does not re-trigger while the interrupt handler is waiting for the
> i2c transfer.
>
> Without ack-before-unmask the sequence of a single interrupt in this setup
> looks like this:
>
> i2c-device raises interrupt line
> interrupt gets triggered
> interrupt gets masked
> interrupt gets acked
> interrupt handling thread starts running
> interrupt handling thread does its stuff, write-clears irq-status register
>  in i2c-device
> i2c-device lowers interrupt line (note this happens after the ack!)
> interrupt handling thread is done
> interrupt gets unmasked
> interrupt immediately retriggers again, because the line has been high
>  after the ack
> interrupt gets masked
> interrupt gets acked
> interrupt handling thread starts running
> interrupt handling thread reads irq-status register, has nothing todo
> interrupt handling thread is done
> interrupt gets unmasked
>
> So in essence we get and handle 2 interrupts for what is 1 interrupt from
> the i2c-device pov. By doing an ack before the unmask, the second interrupt
> is avoided since at the point of the unmask the irq-thread has done its
> job and cleared the interrupt source.

And how is that different from the non threaded case?

    mask()
    ack()	<-- irq line is still active
    handle()	<-- irq line goes inactive. So this happens
    		     after the ack as above
    unmask()

> Note that things work fine without this patch, the purpose of this patch is
> soley to avoid the second unneeded interrupt.
>
> This patch uses an interrupt flag for this and not an irqchip flag because
> the need for ack before unmask is based on the device and not on the irqchip.

No, it's not a device property. Its an irq chip property. There are
interrupt chips which handle that case fine and making this a device
property might even break such interrupt chips. e.g. ioapic handles
that nicely but it would use ack_edge() on a level interrupt when the
device driver requests that. And the edge and level mode of the ioapic
are substantially different. Go figure.

The general policy is that device drivers should be oblivious of the
underlying interrupt controller implementation as much as possible.

If the interrupt chip has this behaviour then handle_level_irq as the
flow handler is the wrong thing to start with because it always acks
before calling the handler.

Due to the fact that we run the primary handler with interrupts
disabled, we should avoid the mask/unmask dance for the non threaded
case completely. handle_fasteoi_irq does that, except that it does not
provide the eoi() before unmask in the threaded case and it has an
extra eoi() even in the masked case which is pointless for interrupt
chips like the one you are dealing with.

Untested patch below.

Thanks,

	tglx

---------------->
---
 include/linux/irq.h    |  4 +++
 kernel/irq/chip.c      | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/internals.h |  1 +
 kernel/irq/manage.c    |  2 +-
 4 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..51c199e 100644
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
@@ -412,6 +415,7 @@ static inline int irq_set_parent(int irq, int parent_irq)
  */
 extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_fasteoi_late_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c16..bc3c099 100644
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
@@ -487,6 +500,66 @@ out:
 	goto out_unlock;
 }
 
+static void cond_unmask_and_eoi_irq(struct irq_desc *desc)
+{
+	if (!(desc->istate & IRQS_ONESHOT)) {
+		desc->irq_data.chip->irq_eoi(&desc->irq_data);
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
+		desc->irq_data.chip->irq_eoi(&desc->irq_data);
+		unmask_irq(desc);
+	}
+}
+
+/**
+ *	handle_fasteoi_late_irq - irq handler for transparent controllers
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq
+ *
+ *	Only a single callback will be issued to the chip: an ->eoi()
+ *	call when the interrupt has been serviced. Same as above, but
+ *	we avoid the eoi when the interrupt is masked due to a
+ *	threaded handler. The eoi will be issued right before the unmask.
+ */
+void handle_fasteoi_late_irq(unsigned int irq, struct irq_desc *desc)
+{
+	raw_spin_lock(&desc->lock);
+
+	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
+		if (!irq_check_poll(desc))
+			goto out;
+
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	/*
+	 * If its disabled or no action available
+	 * then mask it and get out of here:
+	 */
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
+		mask_irq(desc);
+		goto out;
+	}
+
+	if (desc->istate & IRQS_ONESHOT)
+		mask_irq(desc);
+
+	handle_irq_event(desc);
+
+	cond_unmask_and_eoi_irq(desc);
+out:
+	raw_spin_unlock(&desc->lock);
+}
+
 /**
  *	handle_edge_irq - edge type IRQ handler
  *	@irq:	the interrupt number
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

