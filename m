Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbaJ3OPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:15:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37888 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbaJ3OPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:15:38 -0400
Message-ID: <54524804.4080501@arm.com>
Date: Thu, 30 Oct 2014 14:15:32 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Add support for priority-drop/deactivate
 interrupt controllers
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252144170.5308@nanos> <544E67D8.3020504@arm.com> <alpine.DEB.2.11.1410272158160.5308@nanos> <544FF183.9030705@arm.com> <alpine.DEB.2.11.1410282054490.5308@nanos> <5450BD61.10102@arm.com> <alpine.DEB.2.11.1410291115310.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410291115310.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 30 Oct 2014 14:15:33.0458 (UTC) FILETIME=[F7D35320:01CFF44B]
X-MC-Unique: 114103014153509701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/14 10:26, Thomas Gleixner wrote:
> On Wed, 29 Oct 2014, Marc Zyngier wrote:
>> On 28/10/14 20:14, Thomas Gleixner wrote:
>>> irq_enable() calls chip->irq_unmask(), i.e. DIR. So that clears the
>>> ACTIVE bit and then the IRQ either gets resent by hardware (in case of
>>> level as the device interrupt is still active) or retriggered by the
>>> irq_retrigger() callback.
>>
>> The problem I see here is for an interrupt that has been flagged as
>> disabled with irq_disabled(), but that hasn't fired. We'd end up doing a
>> DIR on something that hasn't had an EOI first. I think that's the only
>> wrinkle in this scheme.
> 
> Right. So the untested patch below should do the trick and prevent
> irq_enable() to invoke irq_unmask() if the interrupt is not flagged
> masked. And it only can be flagged masked if it was masked in the
> handler. The startup callback will make sure that irq_enable() is not
> invoked at startup time.
> 
> Thanks,
> 
> 	tglx
> 
> ------------------
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index e5202f00cabc..9c0f73e1994a 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -182,7 +182,7 @@ int irq_startup(struct irq_desc *desc, bool resend)
>  		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
>  		irq_state_clr_masked(desc);
>  	} else {
> -		irq_enable(desc);
> +		irq_enable(desc, false);
>  	}
>  	if (resend)
>  		check_irq_resend(desc, desc->irq_data.irq);
> @@ -202,13 +202,14 @@ void irq_shutdown(struct irq_desc *desc)
>  	irq_state_set_masked(desc);
>  }
>  
> -void irq_enable(struct irq_desc *desc)
> +void irq_enable(struct irq_desc *desc, bool ifmasked)
>  {
>  	irq_state_clr_disabled(desc);
> -	if (desc->irq_data.chip->irq_enable)
> +	if (desc->irq_data.chip->irq_enable) {
>  		desc->irq_data.chip->irq_enable(&desc->irq_data);
> -	else
> +	} else if (!ifmasked || irqd_irq_masked(&desc->irq_data)) {
>  		desc->irq_data.chip->irq_unmask(&desc->irq_data);
> +	}
>  	irq_state_clr_masked(desc);
>  }
>  
> diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
> index 4332d766619d..6eff2678cf6d 100644
> --- a/kernel/irq/internals.h
> +++ b/kernel/irq/internals.h
> @@ -68,7 +68,7 @@ extern void __enable_irq(struct irq_desc *desc, unsigned int irq);
>  
>  extern int irq_startup(struct irq_desc *desc, bool resend);
>  extern void irq_shutdown(struct irq_desc *desc);
> -extern void irq_enable(struct irq_desc *desc);
> +extern void irq_enable(struct irq_desc *desc, bool ifmasked);
>  extern void irq_disable(struct irq_desc *desc);
>  extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
>  extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 0a9104b4608b..d8c474608c2d 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -448,7 +448,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq)
>  			goto err_out;
>  		/* Prevent probing on this irq: */
>  		irq_settings_set_noprobe(desc);
> -		irq_enable(desc);
> +		irq_enable(desc, true);
>  		check_irq_resend(desc, irq);
>  		/* fall-through */
>  	}
> 

So I actually implemented this, and did hit another snag: per cpu interrupts.
They don't use the startup/shutdown methods, and reproducing the above logic
on a per-cpu basis is not very pretty.

In order to make some progress, I went on a slightly different path, which
is to use enable/disable instead of startup/shutdown. As far as I can see,
the only thing we loose by doing so is the lazy disable, but the code
becomes very straightforward (see below). I gave it a go on an ARMv7 box,
and it even survived.

Thoughts?

	M.

>From fee4719e3bd82536bf72a62aab619b873ed1b6f0 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Thu, 23 Oct 2014 09:25:47 +0100
Subject: [PATCH] genirq: Add support for priority-drop/deactivate interrupt
 controllers

Moderately recent ARM interrupt controllers can use a "split mode" EOI,
where instead of just using a single write to notify the controller of
the end of interrupt, uses the following:
- priority-drop: the interrupt is still active, but other interrupts can
  now be taken (basically the equivalent of a mask)
- deactivate: the interrupt is not active anymore, and can be taken again
  (equivalent to unmask+eoi).

This makes it very useful for threaded interrupts, as it avoids the usual
mask/unmask dance (and has the potential of being more efficient on ARM,
as it is using the CPU interface instead of the global distributor).

This patch implements a couple of new interrupt flows:
- handle_spliteoi_irq: this is the direct equivalent of handle_fasteoi_irq,
- handle_spliteoi_percpu_devid_irq: equivalent to handle_percpu_devid_irq.

It is expected that irqchip using these flows will implement something like:

	.irq_enable		= irqchip_unmask_irq,
	.irq_disable		= irqchip_mask_irq,
	.irq_mask		= irqchip_priority_drop_irq,
	.irq_unmask    		= irqchip_deactivate_irq,

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irq.h |  2 ++
 kernel/irq/chip.c   | 90 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 165fac0..0887634 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -444,11 +444,13 @@ static inline int irq_set_parent(int irq, int parent_irq)
  */
 extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_spliteoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_spliteoi_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index e5202f0..84d2162 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -542,6 +542,56 @@ out:
 EXPORT_SYMBOL_GPL(handle_fasteoi_irq);
 
 /**
+ *	handle_spliteoi_irq - irq handler for 2-phase-eoi controllers
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq
+ *
+ *	This relies on mask being a very cheap operation, and on
+ *	unmask performing both unmask+EOI. This avoids additional
+ *	operations for threaded interrupts (typically ARM's GICv2/v3).
+ */
+void
+handle_spliteoi_irq(unsigned int irq, struct irq_desc *desc)
+{
+	raw_spin_lock(&desc->lock);
+
+	if (!irq_may_run(desc))
+		goto out;
+
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	/* Mark the IRQ as in progress */
+	mask_irq(desc);
+
+	/*
+	 * If it's disabled or no action available
+	 * then just get out of here:
+	 */
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
+		goto out_unmask;
+	}
+
+	handle_irq_event(desc);
+
+	/* In case the handler itself disabled it */
+	if (irqd_irq_disabled(&desc->irq_data))
+		goto out_unmask;
+
+	/* If the thread is running, leave the IRQ in progress */
+	if (atomic_read(&desc->threads_active))
+		goto out;
+
+out_unmask:
+	/* Terminate the handling */
+	unmask_irq(desc);
+out:
+	raw_spin_unlock(&desc->lock);
+}
+EXPORT_SYMBOL_GPL(handle_spliteoi_irq);
+
+/**
  *	handle_edge_irq - edge type IRQ handler
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq
@@ -683,6 +733,19 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 		chip->irq_eoi(&desc->irq_data);
 }
 
+static void __handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct irqaction *action = desc->action;
+	void *dev_id = raw_cpu_ptr(action->percpu_dev_id);
+	irqreturn_t res;
+
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	trace_irq_handler_entry(irq, action);
+	res = action->handler(irq, dev_id);
+	trace_irq_handler_exit(irq, action, res);
+}
+
 /**
  * handle_percpu_devid_irq - Per CPU local irq handler with per cpu dev ids
  * @irq:	the interrupt number
@@ -698,23 +761,34 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
-	struct irqaction *action = desc->action;
-	void *dev_id = raw_cpu_ptr(action->percpu_dev_id);
-	irqreturn_t res;
-
-	kstat_incr_irqs_this_cpu(irq, desc);
 
 	if (chip->irq_ack)
 		chip->irq_ack(&desc->irq_data);
 
-	trace_irq_handler_entry(irq, action);
-	res = action->handler(irq, dev_id);
-	trace_irq_handler_exit(irq, action, res);
+	__handle_percpu_devid_irq(irq, desc);
 
 	if (chip->irq_eoi)
 		chip->irq_eoi(&desc->irq_data);
 }
 
+/**
+ * handle_spliteoi_percpu_devid_irq - Per CPU local irq handler with per cpu dev ids
+ * @irq:	the interrupt number
+ * @desc:	the interrupt description structure for this irq
+ *
+ * Per CPU interrupts on SMP machines without locking requirements.
+ * Same as handle_percpu_devid_irq() above, but using the 2-phase-eoi
+ * model for the handling.
+ */
+void handle_spliteoi_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
+{
+	mask_irq(desc);
+
+	__handle_percpu_devid_irq(irq, desc);
+
+	unmask_irq(desc);
+}
+
 void
 __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
-- 
2.0.4


-- 
Jazz is not dead. It just smells funny...

