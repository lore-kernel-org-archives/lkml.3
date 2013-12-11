Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab3LKNqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:46:00 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:36141 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3LKNp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:45:58 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when populating interrupts
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20131128154622.GB23201@ulmo.nvidia.com>
References: <20131123004334.GJ10023@atomide.com> <20131124213651.59750C402C3 @trevor.secretlab.ca> <20131125092549.GD22043@ulmo.nvidia.com> < 20131125094954.GF22043@ulmo.nvidia.com> <20131127155629.DB612C404EC@trevor. secretlab.ca> <20131128154622.GB23201@ulmo.nvidia.com>
Date: Wed, 11 Dec 2013 13:45:53 +0000
Message-Id: <20131211134553.2E967C4061A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013 16:46:23 +0100, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Wed, Nov 27, 2013 at 03:56:29PM +0000, Grant Likely wrote:
> > On Mon, 25 Nov 2013 10:49:55 +0100, Thierry Reding <thierry.reding@gmail.com> wrote:
> > > 
> > > I should maybe add: one issue that was raised during review of my
> > > initial patch series was that we'll also need to cope with situations
> > > like the following:
> > > 
> > > 	1) device's interrupt parent is probed (assigned IRQ base X)
> > > 	2) device is probed (interrupt parent there, therefore gets
> > > 	   assigned IRQ (X + z)
> > > 	3) device in removed
> > > 	4) device's interrupt parent is removed
> > > 	5) device is probed (deferred because interrupt parent isn't
> > > 	   there)
> > > 	6) device's interrupt parent is probed (assigned IRQ base Y)
> > > 	7) device is probed, gets assigned IRQ (Y + z)
> > > 
> > > So not only do we have to track which resources are interrupt resources,
> > > but we also need to have them reassigned everytime the device is probed,
> > > therefore interrupt mappings need to be properly disposed and the values
> > > invalidated when probing is deferred or the device removed.
> > 
> > Yes, that is a problem, but the only way to handle that is to always
> > recalcuate all resource references at probe time. I don't feel good
> > about handling that in the core. I'd rather move drivers away from
> > referencing the resources table directly and instead use an API. Then
> > the resources table could be missing entirely.
> 
> Are you suggesting something like this?
> 
> ---
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 3a94b799f166..c894d1af3a5e 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -13,6 +13,7 @@
>  #include <linux/string.h>
>  #include <linux/platform_device.h>
>  #include <linux/of_device.h>
> +#include <linux/of_irq.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/dma-mapping.h>
> @@ -87,7 +88,12 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
>                 return -ENXIO;
>         return dev->archdata.irqs[num];
>  #else
> -       struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> +       struct resource *r;
> +
> +       if (IS_ENABLED(CONFIG_OF) && dev->dev.of_node)
> +               return irq_of_parse_and_map(dev->dev.of_node, num);
> +
> +       r = platform_get_resource(dev, IORESOURCE_IRQ, num);

Yes. Or even more generically we could have a device_get_irq() function:

int device_get_irq(struct device *dev, unsigned int num)
{
	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
		return irq_of_parse_and_map(dev->of_node, num);
	/* An ACPI hook could go here */
	return 0
}

It would be callable by any device driver, and platform_get_irq() could
call it too.

g.

