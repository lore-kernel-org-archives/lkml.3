Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaDVDFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:05:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39745 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaDVDFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:05:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+HHQ2Awt1xjnKBOjDGDrm
Date: Mon, 21 Apr 2014 20:05:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
Message-ID: <20140422030528.GB26554@atomide.com>
References: <CAL_Jsq+aU+rs28gV=Gesb_-Dy6Ht7zuKrRA6_hmqp94Uun23Yg@mail.gmail.com>
 <20140418205213.GA21823@atomide.com>
 <CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com>
 <20140418215848.GD21823@atomide.com>
 <20140418230335.GI24070@n2100.arm.linux.org.uk>
 <20140418232407.GQ21823@atomide.com>
 <CAL_JsqLvLTJwgsB-m0W72WxSUoTV4ubMdvM_a784J4k2eiK9AQ@mail.gmail.com>
 <20140421155424.GD23945@atomide.com>
 <53556AF1.2030608@gmail.com>
 <20140421202546.GA26554@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421202546.GA26554@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140421 13:26]:
> * Rob Herring <robherring2@gmail.com> [140421 12:01]:
> > On Mon, Apr 21, 2014 at 10:54 AM, Tony Lindgren <tony@atomide.com> wrote:
> > > * Rob Herring <robherring2@gmail.com> [140421 06:47]:
> > >> On Fri, Apr 18, 2014 at 6:24 PM, Tony Lindgren <tony@atomide.com> wrote:
> > >> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [140418 16:04]:
> > >> >> On Fri, Apr 18, 2014 at 02:58:48PM -0700, Tony Lindgren wrote:
> > >> >> > Oh come on, let's stop pretending it's not broken. And it's way worse with
> > >> >> > device tree as there's nothing making sure the resources for a driver
> > >> >> > are set up before the driver probes. And we've been unable to fix just
> > >> >> > this issue alone for about six months now. It's also broken beyond that.
> > >> >> > It's called of_platform_bus yet it won't even pass the platform_data
> > >> >> > as auxdata to the devices on a sub-bus instantatiated like I2C.
> > >> >>
> > >> >> Isn't there a much simpler solution to the platform device IRQ problem?
> > >> >>
> > >> >> Rather than trying to fix it at the point where the resources are
> > >> >> created, why not just *not* have DT create the IRQ resources in the
> > >> >> first place, and instead have platform_get_irq() (which is the function
> > >> >> which should be used to get an IRQ) be the actor to do whatever is
> > >> >> necessary to return the IRQ(s) ?
> > >> >
> > >> > Yeah why not. I don't see why we would need to do all this of_* special
> > >> > trickery for much anything beyond parsing the binding.
> > >>
> > >> That can work, but it will still need something like
> > >> of_find_irq_domain() to determine whether to return -EPROBE_DEFER or
> > >> not.
> > >
> > > Right. Naturally let's do whatever it takes to first fix this issue
> > > in a minimal way first for the -rc cycle so we can do the longer term
> > > changes needed.
> > 
> > I'm not really convinced there is a simple and safe enough solution for
> > 3.15. We should also be willing to tag a solution for stable if we take
> > it for -rc (although that decision could be deferred).
> 
> Yes the fix needs to also go to stable. And this is a regression
> between legacy booting and DT based booting so we do have good
> reasons to fix this for the -rc cycle. Who knows how many people are
> hitting this and are tinkering with the driver initcall levels to
> work around it. Ideally the fix, even if intrusive, would already
> get us a little bit into the right direction.
> 
> > >> You could also go in the other direction and don't create the device
> > >> until the resources can be resolved. Unlike any of the other
> > >> solutions, that would work for amba bus as well although we may never
> > >> have a case where we need this with the amba bus. This would require
> > >> making of_platform_populate be callable multiple times, but there are
> > >> already some other reasons for wanting to do that. Specifically, I
> > >> would like the core code to call of_platform_populate with default
> > >> options and then only platforms with non-default options need a call
> > >> to of_platform_populate.
> > >
> > > I like this idea as this would also probably remove the the numerous
> > > dmesg errors we are currently getting for drivers reprobing with
> > > -EPROBE_DEFER.
> > 
> > One issue with my proposal is with supporting modules. IIUC, deferred
> > probe will continue trying forever and loading modules can cause probe
> > to succeed. If devices are not created and on the deferred probe list,
> > then they will not get probed when a module load fixes the dependency.
> > 
> > > In the long term we should have platform bus just call a set of
> > > standardized functions implemented by whatever the data source might
> > > be. That way we can limit the use of of_* functions in device drivers
> > > to just parsing of custom bindings in the drivers and use bus specific
> > > functions for everything else.
> > >
> > >> >> Yes, I know we have some drivers which use platform_get_resources() with
> > >> >> IORESOURCE_IRQ, but they should really use the right accessor.  And those
> > >> >> who just dereference the resource array directly... get what's coming
> > >> >> (though of course they have to be fixed.)
> > >> >
> > >> > $ git grep IORESOURCE_IRQ drivers/ | grep platform_get_resource | wc -l
> > >> > 179
> > >>
> > >> Certainly, this is worthwhile clean-up no matter what the solution.
> > >
> > > Yeah agreed. But let's also consider the IORESOURCE_IRQ as just another
> > > source for for the bus or driver data in addition to the DT parsed data.
> > > Both sources of data should work just fine with platform_bus even
> > > without cleaning up the drivers
> > 
> > Ah, right. Except for those drivers you need to work with deferred probe
> > would have to use platform_get_irq. That fact makes this solution quite
> > a bit easier.
> 
> Yes fixing up the known broken drivers is also doable for the -rc
> cycle.
>  
> > Something like this is what you had in mind?
> > 
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index e714709..5b47210 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/string.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/of_device.h>
> > +#include <linux/of_irq.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> >  #include <linux/dma-mapping.h>
> > @@ -87,7 +88,11 @@ int platform_get_irq(struct platform_device *dev,
> > unsigned int num)
> >  		return -ENXIO;
> >  	return dev->archdata.irqs[num];
> >  #else
> > -	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> > +	struct resource *r;
> > +	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
> > +		return of_irq_get(dev->dev.of_node, num);
> > +
> > +	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> > 
> >  	return r ? r->start : -ENXIO;
> >  #endif
> > diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> > index 7d3184f..30449ad 100644
> > --- a/drivers/of/irq.c
> > +++ b/drivers/of/irq.c
> > @@ -400,6 +400,26 @@ int of_irq_to_resource(struct device_node *dev, int
> > index, struct resource *r)
> >  EXPORT_SYMBOL_GPL(of_irq_to_resource);
> > 
> >  /**
> > + * of_irq_get - Decode a node's IRQ and return it as a Linux irq number
> > + * @dev: pointer to device tree node
> > + * @index: zero-based index of the irq
> > + *
> > + * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
> > + * is not yet created.
> > + *
> > + */
> > +int of_irq_get(struct device_node *dev, int index)
> > +{
> > +	int irq = irq_of_parse_and_map(dev, index);
> > +
> > +	if (!irq && of_find_irq_domain(dev, index) == NULL)
> > +		return -EPROBE_DEFER;
> > +
> > +	return irq;
> > +}
> 
> Yeah something like that. That might also work as a pretty
> minimal fix as long as we fix the known broken drivers to use
> platform_get_irq().

Actually, the above code for of_irq_get() won't help as we're still
calling irq_of_parse_and_map() before we should. So the nasty warnings
are still there if the irqdomain is not yet found.
 
> But for the long run, how about we define some kind of Linux
> generic bus ops:
> 
> struct bus_ops {
> 	struct resource *	(*get_resource)(struct device *dev, unsigned int type, unsigned int num);
> 	int			(get_irq)(struct device *dev, unsigned int num);
> 	...
> };
> 
> And then DT code would register static of_irq_get() as a get_irq()
> for the platform_bus. And naturally we'd implement these functions
> for legacy resources too. And that way platform_bus code stays clear
> of implementation details and just goes through the list of
> registered data sources. It may even make sense to do it for the
> fix to keep the of_* functions private to drivers/of/*.c and the
> bus code generic.
> 
> > +EXPORT_SYMBOL_GPL(of_irq_get);
> 
> Probably no need to export this? I don't think we want other
> code to use this directly..
> 
> Regards,
> 
> Tony
