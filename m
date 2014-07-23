Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbaGWStv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:49:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:46194 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGWStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:49:50 -0400
Date: Wed, 23 Jul 2014 20:49:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
cc: linux-kernel@vger.kernel.org, jason@lakedaemon.net
Subject: Re: [PATCH v2] genirq: bug on inconstent flags and flow handler
In-Reply-To: <1406141136-19501-1-git-send-email-f.fainelli@gmail.com>
Message-ID: <alpine.DEB.2.10.1407232048240.23352@nanos>
References: <1406141136-19501-1-git-send-email-f.fainelli@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Florian Fainelli wrote:

> It is currently possible for a generic irq chip driver to set IRQ_LEVEL
> and have its irq flow handler be handle_edge_irq. Setting IRQ_LEVEL in
> such a case does not make sense, and will actually prevent e.g: the
> software resend logic from kicking, and potential other problems too.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> - replaced WARN_ON() with BUG_ON() since we really don't want to continue
>   as suggested by Jason Cooper

I disagree here. It's not a reason take the machine down. Its good
enough to WARN. That keeps the machine alive and lets us debug that
stuff.

Lemme find V1 ....

 
>  kernel/irq/chip.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index a2b28a2fd7b1..17a66b56cd96 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -749,8 +749,13 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
>  		irqd_set(&desc->irq_data, IRQD_PER_CPU);
>  	if (irq_settings_can_move_pcntxt(desc))
>  		irqd_set(&desc->irq_data, IRQD_MOVE_PCNTXT);
> -	if (irq_settings_is_level(desc))
> +	if (irq_settings_is_level(desc)) {
> +		/* Setting IRQD_LEVEL does not make sense on non-level
> +		 * sensitive interrupts
> +		 */
> +		BUG_ON(desc->handle_irq != handle_level_irq);
>  		irqd_set(&desc->irq_data, IRQD_LEVEL);
> +	}
>  
>  	irqd_set(&desc->irq_data, irq_settings_get_trigger_mask(desc));
>  
> -- 
> 1.9.1
> 
> 
