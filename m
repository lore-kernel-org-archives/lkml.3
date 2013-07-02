Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3GBGT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:19:58 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50451 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3GBGT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:19:57 -0400
Message-ID: <51D27044.6050604@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 11:46:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] metag: cpu hotplug: route_irq: preserve irq mask
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-6-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1372694659-30176-6-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070206-5816-0000-0000-000008B8C67D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 09:34 PM, James Hogan wrote:
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
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

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
> 

