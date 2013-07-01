Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3GAVvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:51:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:57388 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3GAVvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:51:47 -0400
Date: Mon, 1 Jul 2013 23:51:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] metag: cpu hotplug: route_irq: preserve irq mask
In-Reply-To: <1372694659-30176-6-git-send-email-james.hogan@imgtec.com>
Message-ID: <alpine.DEB.2.02.1307012351370.4013@ionos.tec.linutronix.de>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-6-git-send-email-james.hogan@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Jul 2013, James Hogan wrote:

> The route_irq() function needs to preserve the irq mask by using the
> _irqsave/irqrestore variants of raw spin lock functions instead of the
> _irq variants. This is because it is called from __cpu_disable() (via
> migrate_irqs()), which is called with IRQs disabled, so using the _irq
> variants re-enables IRQs.
> 
> This appears to have been causing occasional hits of the
> BUG_ON(!irqs_disabled()) in __irq_work_run() during CPU hotplug soak
> testing:
>   BUG: failure at kernel/irq_work.c:122/__irq_work_run()!
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/metag/kernel/irq.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/metag/kernel/irq.c b/arch/metag/kernel/irq.c
> index d91b1e9..2a2c9d5 100644
> --- a/arch/metag/kernel/irq.c
> +++ b/arch/metag/kernel/irq.c
> @@ -279,11 +279,12 @@ static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	struct irq_chip *chip = irq_data_get_irq_chip(data);
> +	unsigned long flags;
>  
> -	raw_spin_lock_irq(&desc->lock);
> +	raw_spin_lock_irqsave(&desc->lock, flags);
>  	if (chip->irq_set_affinity)
>  		chip->irq_set_affinity(data, cpumask_of(cpu), false);
> -	raw_spin_unlock_irq(&desc->lock);
> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
>  }
>  
>  /*
> -- 
> 1.8.1.2
> 
> 
> 
