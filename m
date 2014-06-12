Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbaFLNjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:39:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64420 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755866AbaFLNj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:39:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX193nWsfVt6NexwNW9wJkRvaI/snVo31I/w=
X-DKIM: OpenDKIM Filter v2.0.1 titan 21CD158DDE4
Date: Thu, 12 Jun 2014 09:39:17 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 12/19] irqchip: crossbar: return proper error value
Message-ID: <20140612133917.GY8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-13-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402574007-13987-13-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:23:20PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> crossbar_of_init always returns -ENOMEM in case of errors, return proper
> error results in case of failures.

Please describe what the other possible failures are and how the changes
are more correct.

> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/irqchip/irq-crossbar.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index fea3e5d..524e6e9 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -140,20 +140,26 @@ static const struct irq_domain_ops routable_irq_domain_ops = {
>  static int __init crossbar_of_init(struct device_node *node,
>  				   const struct crossbar_data *data)
>  {
> -	int i, size, max, reserved = 0, entry, safe_map;
> +	int i, size, max = 0, reserved = 0, entry, safe_map;
>  	const __be32 *irqsr;
>  	const int *irqsk = NULL;
> +	int ret = -ENOMEM;
>  
>  	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
>  
>  	if (!cb)
> -		return -ENOMEM;
> +		return ret;
>  
>  	cb->crossbar_base = of_iomap(node, 0);
>  	if (!cb->crossbar_base)
>  		goto err1;
>  
>  	of_property_read_u32(node, "ti,max-irqs", &max);
> +	if (!max) {
> +		pr_err("missing 'ti,max-irqs' property\n");
> +		ret = -EINVAL;
> +		goto err2;
> +	}
>  	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
>  	if (!cb->irq_map)
>  		goto err2;
> @@ -174,6 +180,7 @@ static int __init crossbar_of_init(struct device_node *node,
>  						   i, &entry);
>  			if (entry > max) {
>  				pr_err("Invalid reserved entry\n");
> +				ret = -EINVAL;
>  				goto err3;
>  			}
>  			cb->irq_map[entry] = IRQ_RESERVED;
> @@ -198,6 +205,7 @@ static int __init crossbar_of_init(struct device_node *node,
>  		break;
>  	default:
>  		pr_err("Invalid reg-size property\n");
> +		ret = -EINVAL;
>  		goto err4;
>  		break;
>  	}
> @@ -225,6 +233,7 @@ static int __init crossbar_of_init(struct device_node *node,
>  
>  			if (entry > max) {
>  				pr_err("Invalid skip entry\n");
> +				ret = -EINVAL;
>  				goto err4;
>  			}
>  			cb->irq_map[entry] = IRQ_SKIP;
> @@ -250,7 +259,7 @@ err2:
>  	iounmap(cb->crossbar_base);
>  err1:
>  	kfree(cb);
> -	return -ENOMEM;
> +	return ret;
>  }

So, where is the change to the successful initialization?  Shouldn't it
now set ret = 0?

This whole function seems to be a hodge-podge of different error
handling styles, which led to the memory leak fixed earlier in this
series.

Please go over this function, choose sane labels, and consolidate _all_
returns to the end of the function.

thx,

Jason.
