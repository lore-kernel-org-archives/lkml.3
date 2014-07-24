Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbaGXNq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:46:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:50887 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904AbaGXNq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:46:56 -0400
Date: Thu, 24 Jul 2014 15:46:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: Warn when shared interrupts do not match on
 NO_SUSPEND
In-Reply-To: <20140724133921.GY6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1407241544500.23352@nanos>
References: <20140724133921.GY6758@twins.programming.kicks-ass.net>
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

> Subject: irq: Warn when shared interrupts do not match on NO_SUSPEND
> 
> When suspend_device_irqs() iterates all descriptors, its pointless if
> one has NO_SUSPEND set while another has not.
> 
> Validate on request_irq() that NO_SUSPEND state maches for SHARED
> interrupts.

I'm happy to take that patch, but you are aware that it is going to
break a few things?

  25:  ....   PCI-MSI-edge      aerdrv, PCIe PME

Thanks,

	tglx
 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/irq/manage.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 88657d7bc9dd..27a1fe028afb 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1077,9 +1077,12 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  		 * set the trigger type must match. Also all must
>  		 * agree on ONESHOT.
>  		 */
> +
> +#define IRQF_MISMATCH \
> +	(IRQF_TRIGGER_MASK | IRQF_ONESHOT | IRQF_NO_SUSPEND)
> +
>  		if (!((old->flags & new->flags) & IRQF_SHARED) ||
> -		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
> -		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
> +		    ((old->flags ^ new->flags) & IRQF_MISMATCH))
>  			goto mismatch;
>  
>  		/* All handlers must agree on per-cpuness */
> 
