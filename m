Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbaFUCdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:33:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64100 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbaFUCdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:33:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ukcDUqfBb2aenXxD1dKyV626sUmPGiLI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 59CB65950E0
Date: Fri, 20 Jun 2014 22:33:02 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, joe@perches.com
Subject: Re: [PATCH V3 03/16] irqchip: crossbar: introduce ti,irqs-skip to
 skip
Message-ID: <20140621023302.GE21711@titan.lakedaemon.net>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
 <1402917796-31574-4-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402917796-31574-4-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sricharan,

Your subject line seems truncated:

  "irqchip: crossbar: introduce ti,irqs-skip to skip"

maybe "... Introduce DT property to skip hardwired irqs" ?

Also note that you need to correct the subject line for *every* patch in
the series wrt capitalization.

I don't mind correcting it when I apply it, provided that:

 - the patch is otherwise ready
 - I only have to do it once or twice for the series
 - I never had a chance to ask since you created a rockstar patch series
   the first time out of the gate (except for capitalization).

Once I've looked over the whole series, please resend with the subject
lines corrected.

On Mon, Jun 16, 2014 at 04:53:03PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> When, in the system due to varied reasons, interrupts might be unusable
> due to hardware behavior, but register maps do exist, then those interrupts
> should be skipped while mapping irq to crossbars.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
> [V3] introduced ti,irqs-skip dt property to list the
>      irqs to be skipped.
> 
>  .../devicetree/bindings/arm/omap/crossbar.txt      |    4 ++++
>  drivers/irqchip/irq-crossbar.c                     |   20 ++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> index fb88585..cfcbd52 100644
> --- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> @@ -17,6 +17,10 @@ Required properties:
>  		 so crossbar bar driver should not consider them as free
>  		 lines.
>  
> +Optional properties:
> +- ti,irqs-skip: This is similar to "ti,irqs-reserved", but are irq mappings
> +  which are not supposed to be used for errata or other reasons(virtualization).

I would specifically mention SoC-specific hard-wiring of irqs here.
Also the fact that the hardwiring unexpectedly bypasses the crossbar.

> +
>  Examples:
>  		crossbar_mpu: @4a020000 {
>  			compatible = "ti,irq-crossbar";

Please include a ti,irqs-skip example here.

> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index 51d4b87..27049de 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -18,6 +18,7 @@
>  
>  #define IRQ_FREE	-1
>  #define IRQ_RESERVED	-2
> +#define IRQ_SKIP	-3
>  #define GIC_IRQ_START	32
>  
>  /*
> @@ -160,6 +161,25 @@ static int __init crossbar_of_init(struct device_node *node)
>  		}
>  	}
>  
> +	/* Skip the ones marked as skip */

This comment is redundant, perhaps "Skip irqs hardwired to bypass the
crossbar."?

> +	irqsr = of_get_property(node, "ti,irqs-skip", &size);
> +	if (irqsr) {
> +		size /= sizeof(__be32);
> +
> +		for (i = 0; i < size; i++) {
> +			of_property_read_u32_index(node,
> +						   "ti,irqs-skip",
> +						   i, &entry);
> +			if (entry > max) {
> +				pr_err("Invalid skip entry\n");
> +				ret = -EINVAL;
> +				goto err3;
> +			}
> +			cb->irq_map[entry] = IRQ_SKIP;
> +		}
> +	}
> +
> +
>  	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
>  	if (!cb->register_offsets)
>  		goto err3;

thx,

Jason.
