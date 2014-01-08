Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbaAHQZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:25:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbaAHQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:25:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references late
Date: Wed, 8 Jan 2014 17:25:17 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org
References: <20140108011957.GK5074@atomide.com> <6734073.GzLvMSsKrR@wuerfel> <20140108155855.GA22984@ulmo.nvidia.com>
In-Reply-To: <20140108155855.GA22984@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401081725.17876.arnd@arndb.de>
X-Provags-ID: V02:K0:pr10d4dKNUfXDUu+h8mCSatcHpxauECVVdNSrpGmsfl
 awZoAmSzVGdN9GHKbejTxdYRfbZM4WtMVZ0kx7iE8yKvR4KUOr
 IM2NjZ3ubCSSTX3WCYddHdupsXcxToAuyLQxNAwuKiOb3tJH8r
 /6RyckIVS2xPubhTiHA66zIHIQGWYxfUwPPG4CYVdLqGY7mEf/
 WMhojklp6iefqlA5x8t8wRdQYXBb5XT2e7OoXtE5Kk6SxTfWCK
 sUw3CpC3TJgq99omTU2jTPOObIX45Ryjs2EjHcHekJeXP4mYfX
 U3fFclwF+44BproB8UN6OJIUskoXwYXz8oQ8jcJ+KwxTW4MGaQ
 y4lGjMxJH987W4qeHvVI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014, Thierry Reding wrote:
> On Wed, Jan 08, 2014 at 04:11:08PM +0100, Arnd Bergmann wrote:
> > On Wednesday 08 January 2014 15:55:27 Thierry Reding wrote:
> > > It stands to reason that if they push back on the IOMMU variant of what
> > > is essentially the same thing, they will push back on the IRQ variant as
> > > well. One alternative I proposed was to, just as you suggested earlier,
> > > move the code into platform_drv_probe() or rather a function called from
> > > it. That proposal never got any replies, though.
> > > 
> > > 	https://lkml.org/lkml/2013/12/14/39
> > 
> > I guess putting it into the platform_drv_probe function seems reasonable,
> > I would be more scared of the implications of a notifier based method.
> 
> I fully agree. Of course if we decide against moving things into the
> core and in favour of a more generic API that drivers should use, then
> this issue goes away silently at least for resources that the driver
> needs to use explicitly (memory-mapped regions, interrupts, ...).
> 
> The issue remains for IOMMU which is meant to be used transparently
> through the DMA API. Perhaps a good compromise would be to have some
> sort of generic helper that can be called to initialize IOMMU support
> for a particular device and support probe deferral on error. Something
> like this perhaps:
> 
> 	int iommu_attach(struct device *dev);
> 	int iommu_detach(struct device *dev);
> 
> I still don't like very much how that needs to be done in each driver
> explicitly, but if we can't do it in the core, then the only other clean
> way to handle it would be to treat it like any other sort of resource
> and handle it explicitly. Perhaps handing out some sort of cookie would
> be preferable to just an error code?

The more I think about the iommu case, the more I am convinced that it
does belong into the core, in whatever form we can find. As far as I
can tell from the little reliable information I have on the topic, I
would assume that we can keep it in the DT probing code, as there won't
be a need for multiple arbitrary IOMMUs with ACPI or with board files.

> > > One downside of that approach is that, while it maps well to platform
> > > devices or generic devices that have some sort of firmware interface
> > > such as OF or ACPI, I don't see how it can be made to work with an I2C
> > > client that's registered from board setup code for example. Well, I
> > > suppose that problem could be solved by throwing another lookup table at
> > > it, just like we do for clocks, regulators, PWMs and GPIOs.
> > 
> > Wouldn't you still be able to attach resources in the traditional
> > way for those, but use the same new interface to get at them?
> 
> I wouldn't know how. For instance platform devices store the IRQ number
> within a struct resource of type IORESOURCE_IRQ, whereas I2C clients
> store them in the struct i2c_client's .irq field.

Good point, I forgot about the special case for i2c_client->irq.
I looked now and noticed that very few i2c devices actually use this
field, but larger number uses platform_data, which has a similar
problem.

> So without actually introspecting the struct device (possibly using the
> .bus field for example) and upcasting you won't know how to get at the
> resources. One possibility to remedy that would be to try and unify the
> resources within struct device. But that doesn't feel right.
> 
> One other thing I had considered at one point was to extend the bus_type
> structure and give it a way to obtain resources in a bus-specific way,
> but that feel even more wrong.
> 
> Perhaps I'm missing something obvious, though, and this is actually much
> more trivial to solve.

No trivial solution that I can see. I think we can deal with the case
where platform code uses platform_device->resources, and everything else
comes down to having multiple code branches in the driver, as we already
have to deal with platform_data and DT properties describing stuff that
doesn't fit in the resources.

	Arnd
