Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbaDWRjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:39:49 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46242 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932169AbaDWRjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:39:47 -0400
Date: Wed, 23 Apr 2014 18:38:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
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
Message-ID: <20140423173854.GI24070@n2100.arm.linux.org.uk>
References: <1395413185-29763-3-git-send-email-jjhiblot@traphandler.com> <CAL_Jsq+aU+rs28gV=Gesb_-Dy6Ht7zuKrRA6_hmqp94Uun23Yg@mail.gmail.com> <20140418205213.GA21823@atomide.com> <CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com> <20140418215848.GD21823@atomide.com> <20140418230335.GI24070@n2100.arm.linux.org.uk> <20140418232407.GQ21823@atomide.com> <CAL_JsqLvLTJwgsB-m0W72WxSUoTV4ubMdvM_a784J4k2eiK9AQ@mail.gmail.com> <20140421155424.GD23945@atomide.com> <53556AF1.2030608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53556AF1.2030608@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 02:01:05PM -0500, Rob Herring wrote:
> Ah, right. Except for those drivers you need to work with deferred probe
> would have to use platform_get_irq. That fact makes this solution quite
> a bit easier.
> 
> Something like this is what you had in mind?

The below is what I had in mind... :)  This moves it to the right place
for deferred probing to work - the alternative is we need some way to
"register" a device which can't be probed immediately, track it's
resources, have some way for it to be notified when those resources
become available (or poll for them becoming available... eg at the
same time as the deferred probing trigger) and then make it properly
available to drivers.  That brings up all sorts of questions about
whether it should be registered in sysfs, what if another device with
the same name comes along, etc.

So the solution below is very much a simple and nice solution to the
problem - it makes full use of our existing infrastructure to deal with
the problem.

> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index e714709..5b47210 100644
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
> @@ -87,7 +88,11 @@ int platform_get_irq(struct platform_device *dev,
> unsigned int num)
>  		return -ENXIO;
>  	return dev->archdata.irqs[num];
>  #else
> -	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> +	struct resource *r;
> +	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
> +		return of_irq_get(dev->dev.of_node, num);
> +
> +	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> 
>  	return r ? r->start : -ENXIO;
>  #endif
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 7d3184f..30449ad 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -400,6 +400,26 @@ int of_irq_to_resource(struct device_node *dev, int
> index, struct resource *r)
>  EXPORT_SYMBOL_GPL(of_irq_to_resource);
> 
>  /**
> + * of_irq_get - Decode a node's IRQ and return it as a Linux irq number
> + * @dev: pointer to device tree node
> + * @index: zero-based index of the irq
> + *
> + * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
> + * is not yet created.
> + *
> + */
> +int of_irq_get(struct device_node *dev, int index)
> +{
> +	int irq = irq_of_parse_and_map(dev, index);
> +
> +	if (!irq && of_find_irq_domain(dev, index) == NULL)
> +		return -EPROBE_DEFER;
> +
> +	return irq;
> +}
> +EXPORT_SYMBOL_GPL(of_irq_get);
> +
> +/**
>   * of_irq_count - Count the number of IRQs a node uses
>   * @dev: pointer to device tree node
>   */

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
