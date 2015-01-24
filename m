Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbbAXXiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 18:38:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:41465 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbAXXiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 18:38:09 -0500
Date: Sun, 25 Jan 2015 00:37:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH v2 2/5] irq: Allow interrupts to routed to NMI (or
 similar)
In-Reply-To: <1421859822-3621-3-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.11.1501242342370.5526@nanos>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org> <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org> <1421859822-3621-3-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Daniel Thompson wrote:
> @@ -307,6 +307,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
>   * @irq_eoi:		end of interrupt
>   * @irq_set_affinity:	set the CPU affinity on SMP machines
>   * @irq_retrigger:	resend an IRQ to the CPU
> + * @irq_set_nmi_routing:set whether interrupt can act like NMI

-ENOPARSE

> +int handle_nmi_irq_desc(unsigned int irq, struct irq_desc *desc);

And that's global for what?

> +int handle_nmi_irq(unsigned int irq);
> +
>  #endif
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 99793b9b6d23..876d01a6ad74 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -646,3 +646,51 @@ unsigned int kstat_irqs_usr(unsigned int irq)
>  	irq_unlock_sparse();
>  	return sum;
>  }
> +
> +/**
> + * handle_nmi_irq_desc - Call an NMI handler
> + * @irq:	the interrupt number
> + * @desc:	the interrupt description structure for this irq
> + *
> + * To the caller this function is similar in scope to generic_handle_irq_desc()
> + * but without any attempt to manage the handler flow. We assume that if the

We assume nothing. We set clear rules and if possible we enforce them.

> + * flow is complex then NMI routing is a bad idea; the caller is expected to
> + * handle the ack, clear, mask and unmask issues if necessary.

And the caller is supposed to do that in which way?

> + * Note that this function does not take any of the usual locks. Instead
> + * is relies on NMIs being prohibited from sharing interrupts (i.e.
> + * there will be exactly one irqaction) and that no call to free_irq()
> + * will be made whilst the handler is running.

And how do you guarantee that? Not at all AFAICT.

> + */
> +int handle_nmi_irq_desc(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct irqaction *action = desc->action;
> +
> +	BUG_ON(action->next);
> +
> +	return action->handler(irq, action->dev_id);
> +}
> +EXPORT_SYMBOL_GPL(handle_nmi_irq_desc);

You seem to have a strong determination to add EXPORT_SYMBOL_GPL to
everything and some more. How is a module supposed to call this?

> +/**
> + * handle_nmi - Call an NMI handler
> + * @irq:	the interrupt number
> + * @desc:	the interrupt description structure for this irq
> + *
> + * To the caller this function is similar in scope to generic_handle_irq(),
> + * see handle_nmi_irq_desc for more detail.

I don't see a detail here which connects that in any way to
generic_handle_irq().

> + */
> +int handle_nmi_irq(unsigned int irq)
> +{
> +	/*
> +	 * irq_to_desc is either simple arithmetic (no locking) or a radix
> +	 * tree lookup (RCU). Both are safe from NMI.
> +	 */
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	if (!desc)
> +		return -EINVAL;
> +	handle_nmi_irq_desc(irq, desc);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(handle_nmi_irq);

Sigh. Why would any low level entry handler live in a module?

> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 80692373abd6..96212a0493c0 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -571,6 +571,17 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
>  	return canrequest;
>  }

Of course, because the function you copied has no documentation, you are
supposed to omit it as well, right?
  
> +int __irq_set_nmi_routing(struct irq_desc *desc, unsigned int irq,

And irq is used for what? Just because the function you copied does
not use it either?

And why is it global? Just because the function you copied is global
as well?

> +			   unsigned int nmi)
> +{
> +	struct irq_chip *chip = desc->irq_data.chip;
> +
> +	if (!chip || !chip->irq_set_nmi_routing)
> +		return -EINVAL;
> +
> +	return chip->irq_set_nmi_routing(&desc->irq_data, nmi);
> +}
> +
>  int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
>  		      unsigned long flags)
>  {
> @@ -966,6 +977,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  
>  	if (desc->irq_data.chip == &no_irq_chip)
>  		return -ENOSYS;
> +
> +	if (new->flags & __IRQF_NMI) {
> +		if (new->flags & IRQF_SHARED)
> +			return -EINVAL;
> +
> +		ret = arch_filter_nmi_handler(new->handler);

See rant below.

> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	if (!try_module_get(desc->owner))
>  		return -ENODEV;
>  
> @@ -1153,6 +1174,19 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  
>  		init_waitqueue_head(&desc->wait_for_threads);
>  
> +		if (new->flags & __IRQF_NMI) {
> +			ret = __irq_set_nmi_routing(desc, irq, true);
> +			if (ret != 1)
> +				goto out_mask;

Another set of magic return values which are completely undocumented
and follow the windows programming style. What's wrong with 0 on success?

> +		} else {
> +			ret = __irq_set_nmi_routing(desc, irq, false);
> +			if (ret == 1) {
> +				pr_err("Failed to disable NMI routing for irq %d\n",
> +				       irq);

Can we add a bit more unreadable conditions here?

What's wrong with

      	ret = irq_setup_nmi(desc, new->flags & __IRQF_NMI);
      	if (ret) {
	        pr_err("some useful info for both cases");
		goto out;
	}

????

> +
> +/*
> + * Allows architectures to deny requests to set __IRQF_NMI.
> + *
> + * Typically this is used to restrict the use of NMI handlers that do not
> + * originate from arch code. However the default implementation is
> + * extremely permissive.
> + */
> +int __weak arch_filter_nmi_handler(irq_handler_t handler)

Your explanation above is completely useless and the default is wrong
as well.

What is this function going to solve? Nothing, AFAICT.

Why is handler a proper decision criteria? How are the decisions going
to look like?

Looking at your proposed ARM implementation just make me ROTFL. You
whitelist the perf handler. So any request for a random irq number
with the perf handler as a target will succeed as long as that irq
line can be switched to NMI mode.

Before you send another iteration of this, can you please sit down and
do a proper write up of the goals and the design to reach those
goals?

I'm certainly not going to waste my time and look at another cobbled
together 'works for me' hackery.

Thanks,

	tglx









