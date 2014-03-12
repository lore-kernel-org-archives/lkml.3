Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaCLRI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbaCLRI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:08:26 -0400
Message-ID: <53209475.2040805@redhat.com>
Date: Wed, 12 Mar 2014 18:08:05 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Carlo Caione <carlo.caione@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/12/2014 11:38 AM, Thomas Gleixner wrote:
> On Wed, 12 Mar 2014, Hans de Goede wrote:

<snip>

> And how is that different from the non threaded case?
> 
>     mask()
>     ack()	<-- irq line is still active
>     handle()	<-- irq line goes inactive. So this happens
>     		     after the ack as above
>     unmask()
> 

Right as I already said in my own reply to my patch, my initial analysis
was wrong.

>> Note that things work fine without this patch, the purpose of this patch is
>> soley to avoid the second unneeded interrupt.
>>
>> This patch uses an interrupt flag for this and not an irqchip flag because
>> the need for ack before unmask is based on the device and not on the irqchip.
>  
> No, it's not a device property. Its an irq chip property.

Agreed.

<snip>

> If the interrupt chip has this behaviour then handle_level_irq as the
> flow handler is the wrong thing to start with because it always acks
> before calling the handler.
> 
> Due to the fact that we run the primary handler with interrupts
> disabled, we should avoid the mask/unmask dance for the non threaded
> case completely. handle_fasteoi_irq does that, except that it does not
> provide the eoi() before unmask in the threaded case and it has an
> extra eoi() even in the masked case which is pointless for interrupt
> chips like the one you are dealing with.
> 
> Untested patch below.

Thanks, I've just finished testing this, and it works as advertised.

This indeed seems the best solution. I'm going to send a v2
of my sun4i irq patch-set with this patch included with 2 fixes added:

1) Export the prototype for the new handle_fasteoi_late_irq function
2) Fix the minor issue Russell noticed

I've only one minor nitpick wrt this patch, for ONESHOT
to work properly the irq_chip for an irq_desc using
handle_fasteoi_late_irq must set the IRQCHIP_EOI_THREADED, but
this is not enforced anywhere.

Maybe add a BUG_ON to the irq mapping code checking this ?

Thanks & Regards,

Hans


> 
> Thanks,
> 
> 	tglx
> 
> ---------------->
> 
> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -349,6 +349,8 @@ struct irq_chip {
>   * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
>   *				when irq enabled
>   * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
> + * IRQCHIP_ONESHOT_SAFE:	One shot does not require mask/unmask
> + * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
>   */
>  enum {
>  	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
> @@ -357,6 +359,7 @@ enum {
>  	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
>  	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
>  	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
> +	IRQCHIP_EOI_THREADED		= (1 <<  6),
>  };
>  
>  /* This include will go away once we isolated irq_desc usage to core code */
> Index: linux-2.6/kernel/irq/chip.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/chip.c
> +++ linux-2.6/kernel/irq/chip.c
> @@ -281,6 +281,19 @@ void unmask_irq(struct irq_desc *desc)
>  	}
>  }
>  
> +void unmask_threaded_irq(struct irq_desc *desc)
> +{
> +	struct irq_chip *chip = desc->irq_data.chip;
> +
> +	if (chip->flags & IRQCHIP_EOI_THREADED)
> +		chip->irq_eoi(&desc->irq_data);
> +
> +	if (chip->irq_unmask) {
> +		desc->irq_data.chip->irq_unmask(&desc->irq_data);
> +		irq_state_clr_masked(desc);
> +	}
> +}
> +
>  /*
>   *	handle_nested_irq - Handle a nested irq from a irq thread
>   *	@irq:	the interrupt number
> @@ -487,6 +500,67 @@ out:
>  	goto out_unlock;
>  }
>  
> +static void cond_unmask_and_eoi_irq(struct irq_desc *desc)
> +{
> +	if (!(desc->istate & IRQS_ONESHOT)) {
> +		desc->irq_data.chip->irq_eoi(&desc->irq_data);
> +		return;
> +	}
> +	/*
> +	 * We need to unmask in the following cases:
> +	 * - Oneshot irq which did not wake the thread (caused by a
> +	 *   spurious interrupt or a primary handler handling it
> +	 *   completely).
> +	 */
> +	if (!irqd_irq_disabled(&desc->irq_data) &&
> +	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
> +		desc->irq_data.chip->irq_eoi(&desc->irq_data);
> +		unmask_irq(desc);
> +	}
> +}
> +
> +/**
> + *	handle_fasteoi_late_irq - irq handler for transparent controllers
> + *	@irq:	the interrupt number
> + *	@desc:	the interrupt description structure for this irq
> + *
> + *	Only a single callback will be issued to the chip: an ->eoi()
> + *	call when the interrupt has been serviced. Same as above, but
> + *	we avoid the eoi when the interrupt is masked due to a
> + *	threaded handler. The eoi will be issued right before the unmask.
> + */
> +void handle_fasteoi_late_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +	raw_spin_lock(&desc->lock);
> +
> +	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
> +		if (!irq_check_poll(desc))
> +			goto out;
> +
> +	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
> +	kstat_incr_irqs_this_cpu(irq, desc);
> +
> +	/*
> +	 * If its disabled or no action available
> +	 * then mask it and get out of here:
> +	 */
> +	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
> +		desc->istate |= IRQS_PENDING;
> +		mask_irq(desc);
> +		goto out;
> +	}
> +
> +	if (desc->istate & IRQS_ONESHOT)
> +		mask_irq(desc);
> +
> +	handle_irq_event(desc);
> +
> +	cond_unmask_and_eoi_irq(desc);
> +out:
> +	raw_spin_unlock(&desc->lock);
> +	return;
> +}
> +
>  /**
>   *	handle_edge_irq - edge type IRQ handler
>   *	@irq:	the interrupt number
> Index: linux-2.6/kernel/irq/internals.h
> ===================================================================
> --- linux-2.6.orig/kernel/irq/internals.h
> +++ linux-2.6/kernel/irq/internals.h
> @@ -73,6 +73,7 @@ extern void irq_percpu_enable(struct irq
>  extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
>  extern void mask_irq(struct irq_desc *desc);
>  extern void unmask_irq(struct irq_desc *desc);
> +extern void unmask_threaded_irq(struct irq_desc *desc);
>  
>  extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
>  
> Index: linux-2.6/kernel/irq/manage.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/manage.c
> +++ linux-2.6/kernel/irq/manage.c
> @@ -718,7 +718,7 @@ again:
>  
>  	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
>  	    irqd_irq_masked(&desc->irq_data))
> -		unmask_irq(desc);
> +		unmask_threaded_irq(desc);
>  
>  out_unlock:
>  	raw_spin_unlock_irq(&desc->lock);
> 
