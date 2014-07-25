Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbaGYJkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:40:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:55689 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaGYJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:40:52 -0400
Date: Fri, 25 Jul 2014 11:40:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
In-Reply-To: <20140724212620.GO3935@laptop>
Message-ID: <alpine.DEB.2.10.1407251135590.23352@nanos>
References: <20140724212620.GO3935@laptop>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Peter Zijlstra wrote:
> @@ -29,14 +29,20 @@ void suspend_device_irqs(void)
>  	for_each_irq_desc(irq, desc) {
>  		unsigned long flags;
>  
> +		/*
> +		 * Ideally this would be a global state, but we cannot
> +		 * for the trainwreck that is IRQD_WAKEUP_STATE.
> +		 */
>  		raw_spin_lock_irqsave(&desc->lock, flags);
> -		__disable_irq(desc, irq, true);
> +		if (!irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> +			desc->istate |= IRQS_SUSPENDED;
>  		raw_spin_unlock_irqrestore(&desc->lock, flags);
>  	}
>  
> -	for_each_irq_desc(irq, desc)
> +	for_each_irq_desc(irq, desc) {
>  		if (desc->istate & IRQS_SUSPENDED)
>  			synchronize_irq(irq);
> +	}
>  }

So, instead of disabling the interrupt you just mark it
suspended. Good luck with level triggered interrupt lines then.

Assume the interrupt fires after you marked it suspended. Then the
flow handler will call handle_irq_event() which will do nothing and
return handled. So the flow handler will reenable the interrupt line,
which will cause the interrupt to fire immediately again after the
RETI. Guess how much progress the system is going to make when that
happens.

Thanks,

	tglx


