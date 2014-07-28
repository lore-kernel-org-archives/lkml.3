Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaG1MLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:11:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:39946 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaG1MLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:11:47 -0400
Date: Mon, 28 Jul 2014 14:11:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH, v2]
In-Reply-To: <3337421.bsfMykWVnZ@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1407281350550.23352@nanos>
References: <20140724212620.GO3935@laptop> <1663327.PISiM9sMHC@vostro.rjw.lan> <3637397.iCmFpOsayO@vostro.rjw.lan> <3337421.bsfMykWVnZ@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Rafael J. Wysocki wrote:
> On Sunday, July 27, 2014 05:53:07 PM Rafael J. Wysocki wrote:
>  irqreturn_t
> +do_irqaction(struct irq_desc *desc, struct irqaction *action,
> +	     unsigned int irq, void *dev_id)
> +{
> +	irqreturn_t ret;
> +
> +	if (unlikely((desc->istate & IRQS_SHARED_SUSPENDED) &&
> +		     !(action->flags & IRQF_NO_SUSPEND)))
> +		return IRQ_NONE;

I really want to avoid that conditional. We burden it on every
interrupt just to deal with this nonsense.

A simple solution for this is to add irq_desc::action_suspended and
move the shared actions which are not flagged NO_SUSPEND over and
bring them back on resume.

> Index: linux-pm/kernel/irq/spurious.c
> ===================================================================
> --- linux-pm.orig/kernel/irq/spurious.c
> +++ linux-pm/kernel/irq/spurious.c
> @@ -275,6 +275,8 @@ try_misrouted_irq(unsigned int irq, stru
>  void note_interrupt(unsigned int irq, struct irq_desc *desc,
>  		    irqreturn_t action_ret)
>  {
> +	int misrouted;
> +
>  	if (desc->istate & IRQS_POLL_INPROGRESS ||
>  	    irq_settings_is_polled(desc))
>  		return;
> @@ -384,6 +386,9 @@ void note_interrupt(unsigned int irq, st
>  		}
>  	}
>  
> +	misrouted = unlikely(try_misrouted_irq(irq, desc, action_ret)) ?
> +			misrouted_irq(irq) : 0;

If the system is suspended, why would we try misrouted irqs at all?
All non wakeup irqs are disabled, so we just spend a gazillion of
cycles for nothing.

Thanks,

	tglx
