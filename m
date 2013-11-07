Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3KGIAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:00:13 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60790 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3KGIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:00:01 -0500
In-Reply-To: <alpine.DEB.2.02.1311061149250.23353@ionos.tec.linutronix.de>
References: <20130131002344.1161E360095@xplor.waratah.dyndns.org> <CAMuHMdUFuNpiZzTr=86Yi2yx73xh_qv8S6PnT0hp9U8x86vskw@mail.gmail.com> <CAMuHMdXB1LNGXkz=_eCQ+i+tu18ffbCA9dP_LRrF1CUBv-q-uQ@mail.gmail.com> <alpine.DEB.2.02.1311061149250.23353@ionos.tec.linutronix.de>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <65b9e5f265b02af3b316e59e55450385@gmail.com>
Content-Transfer-Encoding: 7bit
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 09/17] [m68k] IRQ: add handle_polled_irq() for timer based soft interrupts
Date: Thu, 7 Nov 2013 20:59:40 +1300
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

>>>> This is a temporary hack to allow timer based polling of the
>>>> Atari ROM port network and USB cards only. Suggestions on how to
>>>> properly handle this in the normal interrupt framework are most
>>>> welcome.
>
> So you're polling devices which have no hardware interrupt from the
> timer interrupt. Of course if there is no interrupt pending on one of
> these devices, this will trigger the spurious detector. By setting the
> POLL_INPROGRESS flag, you're preventing that.

That's the general idea, yes. I am aware I abuse the flag somewhat. 
This was
the least invasive fix I came up with (i.e. no risk to cause 
regressions elsewhere).
Adding a new IRQ flag would have been my preference, but that seemed a 
bit
bold at the time.

> Reading the demultiplex handler it seems you have no way to figure out
> which of the sub interrupts actually triggered the mfptimer_handler,
> right?

Correct.

> I'm not too happy about the POLL flag "abuse". I'd rather have such

Precisely why I asked for this to be reviewed, thanks,

> interrupts explicitely marked as polled by some other interrupt. That
> also excludes such interrupts from the spurious mechanism completely.
>
> Does the following patch solve the problem? You need to call
>
>      irq_set_status_flags(irq, IRQ_IS_POLLED);
>
> when setting up the interrupt controller for those polled interrupt
> lines.

This should do the trick, from what I can see. I have tried to test it, 
but recent changes
to the m68k vmlinux.lds have thrown a monkey wrench in the works, it 
seems (kernels
just won't boot at all). I'll sort that out with Geert and report back.

Much obliged,

	Michael


>
> Thanks,
>
> 	tglx
> -----------------
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 56bb0dc..7dc1003 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -70,6 +70,9 @@ typedef	void (*irq_preflow_handler_t)(struct 
> irq_data *data);
>   * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
>   * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
>   * IRQ_PER_CPU_DEVID		- Dev_id is a per-cpu variable
> + * IRQ_IS_POLLED		- Always polled by another interrupt. Exclude
> + *				  it from the spurious interrupt detection
> + *				  mechanism and from core side polling.
>   */
>  enum {
>  	IRQ_TYPE_NONE		= 0x00000000,
> @@ -94,12 +97,14 @@ enum {
>  	IRQ_NESTED_THREAD	= (1 << 15),
>  	IRQ_NOTHREAD		= (1 << 16),
>  	IRQ_PER_CPU_DEVID	= (1 << 17),
> +	IRQ_IS_POLLED		= (1 << 18),
>  };
>
>  #define IRQF_MODIFY_MASK	\
>  	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
>  	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
> -	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NOTHREAD | IRQ_PER_CPU_DEVID)
> +	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NOTHREAD | IRQ_PER_CPU_DEVID 
> | \
> +	 IRQ_IS_POLLED)
>
>  #define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
>
> diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
> index 1162f10..3320b84 100644
> --- a/kernel/irq/settings.h
> +++ b/kernel/irq/settings.h
> @@ -14,6 +14,7 @@ enum {
>  	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
>  	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
>  	_IRQ_PER_CPU_DEVID	= IRQ_PER_CPU_DEVID,
> +	_IRQ_IS_POLLED		= IRQ_IS_POLLED,
>  	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
>  };
>
> @@ -26,6 +27,7 @@ enum {
>  #define IRQ_NOAUTOEN		GOT_YOU_MORON
>  #define IRQ_NESTED_THREAD	GOT_YOU_MORON
>  #define IRQ_PER_CPU_DEVID	GOT_YOU_MORON
> +#define IRQ_IS_POLLED		GOT_YOU_MORON
>  #undef IRQF_MODIFY_MASK
>  #define IRQF_MODIFY_MASK	GOT_YOU_MORON
>
> @@ -147,3 +149,8 @@ static inline bool 
> irq_settings_is_nested_thread(struct irq_desc *desc)
>  {
>  	return desc->status_use_accessors & _IRQ_NESTED_THREAD;
>  }
> +
> +static inline bool irq_settings_is_polled(struct irq_desc *desc)
> +{
> +	return desc->status_use_accessors & _IRQ_IS_POLLED;
> +}
> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> index 7b5f012..a1d8cc6 100644
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -67,8 +67,13 @@ static int try_one_irq(int irq, struct irq_desc 
> *desc, bool force)
>
>  	raw_spin_lock(&desc->lock);
>
> -	/* PER_CPU and nested thread interrupts are never polled */
> -	if (irq_settings_is_per_cpu(desc) || 
> irq_settings_is_nested_thread(desc))
> +	/*
> +	 * PER_CPU, nested thread interrupts and interrupts explicitely
> +	 * marked polled are excluded from polling.
> +	 */
> +	if (irq_settings_is_per_cpu(desc) ||
> +	    irq_settings_is_nested_thread(desc) ||
> +	    irq_settings_is_polled(desc))
>  		goto out;
>
>  	/*
> @@ -268,7 +273,8 @@ try_misrouted_irq(unsigned int irq, struct 
> irq_desc *desc,
>  void note_interrupt(unsigned int irq, struct irq_desc *desc,
>  		    irqreturn_t action_ret)
>  {
> -	if (desc->istate & IRQS_POLL_INPROGRESS)
> +	if (desc->istate & IRQS_POLL_INPROGRESS ||
> +	    irq_settings_is_polled(desc))
>  		return;
>
>  	/* we get here again via the threaded handler */
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

