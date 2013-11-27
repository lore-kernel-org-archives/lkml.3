Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3K0P4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:56:38 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:39195 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3K0P4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:56:36 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when populating interrupts
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20131125094954.GF22043@ulmo.nvidia.com>
References: <20131123004334.GJ10023@atomide.com> <20131124213651.59750C402C3 @trevor.secretlab.ca> <20131125092549.GD22043@ulmo.nvidia.com> < 20131125094954.GF22043@ulmo.nvidia.com>
Date: Wed, 27 Nov 2013 15:56:29 +0000
Message-Id: <20131127155629.DB612C404EC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013 10:49:55 +0100, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Mon, Nov 25, 2013 at 10:25:50AM +0100, Thierry Reding wrote:
> > On Sun, Nov 24, 2013 at 09:36:51PM +0000, Grant Likely wrote:
> > > On Fri, 22 Nov 2013 16:43:35 -0800, Tony Lindgren <tony@atomide.com> wrote:
> > > > Currently we get the following kind of errors if we try to use
> > > > interrupt phandles to irqchips that have not yet initialized:
> > > > 
> > > > irq: no irq domain found for /ocp/pinmux@48002030 !
> > > > WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
> > > > Modules linked in:
> > > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> > > > (show_stack+0x14/0x1c)
> > > > (dump_stack+0x6c/0xa0)
> > > > (warn_slowpath_common+0x64/0x84)
> > > > (warn_slowpath_null+0x1c/0x24)
> > > > (of_device_alloc+0x144/0x184)
> > > > (of_platform_device_create_pdata+0x44/0x9c)
> > > > (of_platform_bus_create+0xd0/0x170)
> > > > (of_platform_bus_create+0x12c/0x170)
> > > > (of_platform_populate+0x60/0x98)
> > > > ...
> > > > 
> > > > This is because we're wrongly trying to populate resources that are not
> > > > yet available. It's perfectly valid to create irqchips dynamically,
> > > > so let's fix up the issue by populating the interrupt resources based
> > > > on a notifier call instead.
> > > > 
> > > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > > > 
> > > > ---
> > > > 
> > > > Rob & Grant, care to merge this for the -rc if this looks OK to you?
> > > > 
> > > > These happen for example when using interrupts-extended for omap
> > > > wake-up interrupts where the irq domain is created by pinctrl-single.c
> > > > at module_init time.
> > > > 
> > > > --- a/drivers/of/platform.c
> > > > +++ b/drivers/of/platform.c
> > > > @@ -130,6 +130,56 @@ void of_device_make_bus_id(struct device *dev)
> > > >  	dev_set_name(dev, "%s.%d", node->name, magic - 1);
> > > >  }
> > > >  
> > > > +/*
> > > > + * The device interrupts are not necessarily available for all
> > > > + * irqdomains initially so we need to populate them using a
> > > > + * notifier.
> > > > + */
> > > > +static int of_device_resource_notify(struct notifier_block *nb,
> > > > +				     unsigned long event, void *dev)
> > > > +{
> > > > +	struct platform_device *pdev = to_platform_device(dev);
> > > > +	struct device_node *np = pdev->dev.of_node;
> > > > +	struct resource *res = pdev->resource;
> > > > +	struct resource *irqr = NULL;
> > > > +	int num_irq, i, found = 0;
> > > > +
> > > > +	if (event != BUS_NOTIFY_BIND_DRIVER)
> > > > +		return 0;
> > > > +
> > > > +	if (!np)
> > > > +		goto out;
> > > > +
> > > > +	num_irq = of_irq_count(np);
> > > > +	if (!num_irq)
> > > > +		goto out;
> > > > +
> > > > +	for (i = 0; i < pdev->num_resources; i++, res++) {
> > > > +		if (res->flags != IORESOURCE_IRQ ||
> > > > +		    res->start != -EPROBE_DEFER ||
> > > > +		    res->end != -EPROBE_DEFER)
> > > > +			continue;
> > > > +
> > > > +		if (!irqr)
> > > > +			irqr = res;
> > > > +		found++;
> > > > +	}
> > > > +
> > > > +	if (!found)
> > > > +		goto out;
> > > > +
> > > > +	if (found != num_irq) {
> > > > +		dev_WARN(dev, "error populating irq resources: %i != %i\n",
> > > > +			 found, num_irq);
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	WARN_ON(of_irq_to_resource_table(np, irqr, num_irq) != num_irq);
> > > > +
> > > > +out:
> > > > +	return NOTIFY_DONE;
> > > > +}
> > > > +
> > > >  /**
> > > >   * of_device_alloc - Allocate and initialize an of_device
> > > >   * @np: device node to assign to device
> > > > @@ -168,7 +218,13 @@ struct platform_device *of_device_alloc(struct device_node *np,
> > > >  			rc = of_address_to_resource(np, i, res);
> > > >  			WARN_ON(rc);
> > > >  		}
> > > > -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
> > > > +
> > > > +		/* See of_device_resource_notify for populating interrupts */
> > > > +		for (i = 0; i < num_irq; i++, res++) {
> > > > +			res->flags = IORESOURCE_IRQ;
> > > > +			res->start = -EPROBE_DEFER;
> > > > +			res->end = -EPROBE_DEFER;
> > > > +		}
> > > 
> > > I actually like the idea of completely allocating the resource structure
> > > but leaving some entries empty. However, I agree with rmk that putting
> > > garbage into a resource structure is a bad idea. What about changing the
> > > value of flags to 0 or some other value to be obviously an empty
> > > property and give the follow up parsing some context about which ones it
> > > needs to attempt to recalculate?
> > 
> > When I worked on this a while back I came to the same conclusion. It's
> > nice to allocate all the resources at once, because the number of them
> > doesn't change, only their actually values.
> 
> I should maybe add: one issue that was raised during review of my
> initial patch series was that we'll also need to cope with situations
> like the following:
> 
> 	1) device's interrupt parent is probed (assigned IRQ base X)
> 	2) device is probed (interrupt parent there, therefore gets
> 	   assigned IRQ (X + z)
> 	3) device in removed
> 	4) device's interrupt parent is removed
> 	5) device is probed (deferred because interrupt parent isn't
> 	   there)
> 	6) device's interrupt parent is probed (assigned IRQ base Y)
> 	7) device is probed, gets assigned IRQ (Y + z)
> 
> So not only do we have to track which resources are interrupt resources,
> but we also need to have them reassigned everytime the device is probed,
> therefore interrupt mappings need to be properly disposed and the values
> invalidated when probing is deferred or the device removed.

Yes, that is a problem, but the only way to handle that is to always
recalcuate all resource references at probe time. I don't feel good
about handling that in the core. I'd rather move drivers away from
referencing the resources table directly and instead use an API. Then
the resources table could be missing entirely.

g.

