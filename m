Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaFMNfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:35:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30623 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbaFMNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:34:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zLCjNvOxXFEzHyl6k6YXwAkiiiCGEhhs=
X-DKIM: OpenDKIM Filter v2.0.1 titan F0D7E58EC83
Date: Fri, 13 Jun 2014 09:34:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 03/19] irqchip: crossbar: Skip some irqs from
 getting mapped to crossbar
Message-ID: <20140613133446.GK8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-4-git-send-email-r.sricharan@ti.com>
 <20140612125134.GS8664@titan.lakedaemon.net>
 <5399A8D5.6070105@ti.com>
 <20140612140729.GD8664@titan.lakedaemon.net>
 <539A9C3D.3050407@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A9C3D.3050407@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:07:49PM +0530, Sricharan R wrote:
> Hi Jason,
> 
> On Thursday 12 June 2014 07:37 PM, Jason Cooper wrote:
> > On Thu, Jun 12, 2014 at 06:49:17PM +0530, Sricharan R wrote:
> >> Hi Jason,
> >>
> >> On Thursday 12 June 2014 06:21 PM, Jason Cooper wrote:
> >>> On Thu, Jun 12, 2014 at 05:23:11PM +0530, Sricharan R wrote:
> >>>> From: Nishanth Menon <nm@ti.com>
> >>>>
> >>>> When, in the system due to varied reasons, interrupts might be unusable
> >>>> due to hardware behavior, but register maps do exist, then those interrupts
> >>>> should be skipped while mapping irq to crossbars.
> >>>>
> >>>> Signed-off-by: Nishanth Menon <nm@ti.com>
> >>>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> >>>> Signed-off-by: Tony Lindgren <tony@atomide.com>
> >>>
> >>> Tony, have you applied these somewhere already?
> >>>
> >>>> ---
> >>>>  drivers/irqchip/irq-crossbar.c |   47 ++++++++++++++++++++++++++++++++++++----
> >>>>  1 file changed, 43 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> >>>> index 51d4b87..847f6e3 100644
> >>>> --- a/drivers/irqchip/irq-crossbar.c
> >>>> +++ b/drivers/irqchip/irq-crossbar.c
> >>>> @@ -13,11 +13,13 @@
> >>>>  #include <linux/io.h>
> >>>>  #include <linux/of_address.h>
> >>>>  #include <linux/of_irq.h>
> >>>> +#include <linux/of_device.h>
> >>>>  #include <linux/slab.h>
> >>>>  #include <linux/irqchip/arm-gic.h>
> >>>>  
> >>>>  #define IRQ_FREE	-1
> >>>>  #define IRQ_RESERVED	-2
> >>>> +#define IRQ_SKIP	-3
> >>>>  #define GIC_IRQ_START	32
> >>>>  
> >>>>  /*
> >>>> @@ -34,6 +36,16 @@ struct crossbar_device {
> >>>>  	void (*write) (int, int);
> >>>>  };
> >>>>  
> >>>> +/**
> >>>> + * struct crossbar_data: Platform specific data
> >>>> + * @irqs_unused: array of irqs that cannot be used because of hw erratas
> >>>> + * @size: size of the irqs_unused array
> >>>> + */
> >>>> +struct crossbar_data {
> >>>> +	const uint *irqs_unused;
> >>>> +	const uint size;
> >>>> +};
> >>>> +
> >>>>  static struct crossbar_device *cb;
> >>>>  
> >>>>  static inline void crossbar_writel(int irq_no, int cb_no)
> >>>> @@ -119,10 +131,12 @@ const struct irq_domain_ops routable_irq_domain_ops = {
> >>>>  	.xlate = crossbar_domain_xlate
> >>>>  };
> >>>>  
> >>>> -static int __init crossbar_of_init(struct device_node *node)
> >>>> +static int __init crossbar_of_init(struct device_node *node,
> >>>> +				   const struct crossbar_data *data)
> >>>>  {
> >>>>  	int i, size, max, reserved = 0, entry;
> >>>>  	const __be32 *irqsr;
> >>>> +	const int *irqsk = NULL;
> >>>>  
> >>>>  	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
> >>>>  
> >>>> @@ -194,6 +208,22 @@ static int __init crossbar_of_init(struct device_node *node)
> >>>>  		reserved += size;
> >>>>  	}
> >>>>  
> >>>> +	/* Skip the ones marked as unused */
> >>>> +	if (data) {
> >>>> +		irqsk = data->irqs_unused;
> >>>> +		size = data->size;
> >>>> +
> >>>> +		for (i = 0; i < size; i++) {
> >>>> +			entry = irqsk[i];
> >>>> +
> >>>> +			if (entry > max) {
> >>>> +				pr_err("Invalid skip entry\n");
> >>>> +				goto err3;
> >>>> +			}
> >>>> +			cb->irq_map[entry] = IRQ_SKIP;
> >>>> +		}
> >>>> +	}
> >>>> +
> >>>>  	register_routable_domain_ops(&routable_irq_domain_ops);
> >>>>  	return 0;
> >>>>  
> >>>> @@ -208,18 +238,27 @@ err1:
> >>>>  	return -ENOMEM;
> >>>>  }
> >>>>  
> >>>> +/* irq number 10 cannot be used because of hw bug */
> >>>> +int dra_irqs_unused[] = { 10 };
> >>>> +struct crossbar_data cb_dra_data = { dra_irqs_unused,
> >>>> +				     ARRAY_SIZE(dra_irqs_unused) };
> >>>> +
> >>>>  static const struct of_device_id crossbar_match[] __initconst = {
> >>>> -	{ .compatible = "ti,irq-crossbar" },
> >>>> +	{ .compatible = "ti,irq-crossbar", .data = &cb_dra_data },
> >>>>  	{}
> >>>>  };
> >>>
> >>> This is a bug in all implementations of this IP?  Or, a specific
> >>> SoC's implementation?  Would this be better expressed in the dts via a
> >>> property?  Can we expect future implementations to be fixed?
> >>>
> >>> thx,
> >>>
> >>> Jason.
> >>  Infact this and PATCH#10 should be merged. I will change that.
> >>
> >>  So in Socs's (2 so far) that do have a crossbar, some irqs are mapped
> >>  through a crossbar and some are directly wired to the irqchip.
> >>  These 'unused irqs' are those which are directly wired but they still
> >>  have a crossbar register. Their routing cannot be changed. So this
> >>  is not really expected usage of the crossbar hw ip. We initially thought
> >>  having a dts property separately for this, but took this path to avoid
> >>  loading the dts with additional bindings which may not be generic.
> > 
> > How do you plan to handle future SoCs with this IP and possibly
> > different hard-wired irqs?
>   Yes, that would require adding a new compatible in the above list and dts.
>   So if adding a new binding in the dts would be cleaner, then i will change
>   it that way.

Yes, unless the DT maintainers have shot the idea down, I'd prefer to
see a separate property.  With the method you currently have, we'll have
to change the compatible when the IP _hasn't_ changed, just because the
SoC was wired differently.

We could trigger on the SoC compatible and maintain a table, but that
seems overly hacky when the dt is supposed to describe the hardware.

thx,

Jason.
