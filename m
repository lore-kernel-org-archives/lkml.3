Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaBTPav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:30:51 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55770 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbaBTPas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:30:48 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] dt: platform driver: Fill the resources before probe and defer if needed
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, gregkh@linuxfoundation.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
In-Reply-To: <1392285429-9325-1-git-send-email-jjhiblot@traphandler.com>
References: <1392285429-9325-1-git-send-email-jjhiblot@traphandler.com>
Date: Thu, 20 Feb 2014 15:30:42 +0000
Message-Id: <20140220153042.DF053C4050F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 10:57:09 +0100, Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
> The goal of this patch is to allow drivers to be probed even if at the time of
> the DT parsing some of their ressources are not available yet.
> 
> In the current situation, the resource of a platform device are filled from the
> DT at the time the device is created (of_device_alloc()). The drawbackof this
> is that a device sitting close to the top of the DT (ahb for example) but
> depending on ressources that are initialized later (IRQ domain dynamically
> created for example)  will fail to probe because the ressources don't exist
> at this time.
> 
> This patch fills the resource structure only before the device is probed and
> will defer the probe if the resource are not available yet.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Hi Jean-Jacques. Thanks for looking at this, it is a longstanding
problem. However, I'm leary of this approach because it makes failed
probes (which are intended to be cheap) into an expensive operation. If
a device goes through multiple rounds of deferred probe, then every time
it will attempt to decode the needed resources. Parsing 'reg' isn't too
bad, but parsing the interrupts may not be. I think it needs to be more
nuanced and only recalculate the resources that failed in previous
attempts...

...however, the other argument that correctness is more important than
efficiency here and it would be better to completely teardown the
resources table, or at least the interrupt entries, after a failed
probe or driver removal to handle the case where the interrupt
controller is re-bound to its driver and gets a new set of interrupt
numbers...

I think this patch can be reworked into something better though...

> ---
>  drivers/base/platform.c     |  6 ++++
>  drivers/of/platform.c       | 71 +++++++++++++++++++++++++++++----------------
>  include/linux/of_platform.h | 10 +++++++
>  3 files changed, 62 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index bc78848..8e37d8b 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -481,6 +481,12 @@ static int platform_drv_probe(struct device *_dev)
>  	struct platform_device *dev = to_platform_device(_dev);
>  	int ret;
>  
> +	if (_dev->of_node) {
> +		ret = of_platform_device_populate_resources(dev);
> +		if (ret < 0)
> +			return drv->prevent_deferred_probe ? ret : -EPROBE_DEFER;
> +	}
> +

Get rid of the _dev->of_node() test. It should be embedded in the
function. Also, rename it to: of_platform_device_prepare()

>  	if (ACPI_HANDLE(_dev))
>  		acpi_dev_pm_attach(_dev, true);
>  
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..64a8eb8 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -141,36 +141,11 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  				  struct device *parent)
>  {
>  	struct platform_device *dev;
> -	int rc, i, num_reg = 0, num_irq;
> -	struct resource *res, temp_res;
>  
>  	dev = platform_device_alloc("", -1);
>  	if (!dev)
>  		return NULL;
>  
> -	/* count the io and irq resources */
> -	if (of_can_translate_address(np))
> -		while (of_address_to_resource(np, num_reg, &temp_res) == 0)
> -			num_reg++;
> -	num_irq = of_irq_count(np);
> -
> -	/* Populate the resource table */
> -	if (num_irq || num_reg) {
> -		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
> -		if (!res) {
> -			platform_device_put(dev);
> -			return NULL;
> -		}
> -
> -		dev->num_resources = num_reg + num_irq;
> -		dev->resource = res;
> -		for (i = 0; i < num_reg; i++, res++) {
> -			rc = of_address_to_resource(np, i, res);
> -			WARN_ON(rc);
> -		}
> -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
> -	}
> -
>  	dev->dev.of_node = of_node_get(np);
>  #if defined(CONFIG_MICROBLAZE)
>  	dev->dev.dma_mask = &dev->archdata.dma_mask;
> @@ -233,6 +208,52 @@ static struct platform_device *of_platform_device_create_pdata(
>  	return dev;
>  }
>  
> +int of_platform_device_populate_resources(struct platform_device *dev)
> +{
> +	struct device_node *np;
> +	int rc = 0, i, nreg = 0, nirq;
> +
> +	np = dev->dev.of_node;
> +
> +	/* count the io and irq resources */
> +	if (of_can_translate_address(np)) {
> +		struct resource temp_res;
> +		while (of_address_to_resource(np, nreg, &temp_res) == 0)
> +			nreg++;
> +	}

The above snippet should be encapsulated in an of_reg_count() helper function.

> +	nirq = of_irq_count(np);
> +
> +	/* Populate the resource table */
> +	if (nirq || nreg) {
> +		struct resource *res;
> +
> +		res = krealloc(dev->resource, sizeof(*res) * (nirq + nreg),
> +			       GFP_KERNEL);
> +		if (!res) {
> +			kfree(dev->resource);
> +			dev->resource = NULL;
> +			return -ENOMEM;
> +		}
> +		memset(res, 0, sizeof(*res) * (nirq + nreg));
> +		dev->resource = res;
> +		dev->num_resources = nreg + nirq;
> +
> +		if (!rc && of_irq_to_resource_table(np, res, nirq) != nirq) {
> +			rc = -ENOENT;
> +			WARN_ON(rc);
> +		}
> +	}
> +	return rc;
> +}

Reallocation is not necessary. We can know exactly how many tuples are
in the reg and interrupts properties. Once allocated the array will be
the right size. (may need to fix of_irq_count() though).

Also, the reg resources will always be correct. They don't need to be
recalculated each time through. IRQs however are the problem area. A
simplistic implementation which is still better than current mainline
would be the following:

	if (!nirq && !nreg)
		return 0;

	if (!dev->resource) {
		res = kzalloc(dev->resource, sizeof(*res) * (nirq + nreg),
			       GFP_KERNEL);
		if (!res)
			return -ENOMEM;

		for (i = 0; i < nreg; i++, res++) {
			rc = of_address_to_resource(np, i, res);
			if (WARN_ON(rc)) {
				/* THIS IS BAD; don't try to defer probing */
				kfree(res);
				return rc;
			}
		}

		dev->resource = res;
		dev->num_resources = nreg + nirq;

		if (of_irq_to_resource_table(np, dev->resource, nirq) != nirq)
			return -EPROBE_DEFER;

		return 0;
	}

	/* See which IRQ resources need to be redone */
	for (i = 0, res = &dev->resource[nreg]; i < nirq; i++, res++)
		if (!res->flags && !of_irq_to_resource(np, i, res))
			return -EPROBE_DEFER;

	return 0;

It isn't optimal because it cannot handle irq controllers being
replugged, but still better than the current code.

Can you respin and let me know if the above works for you?

Thanks,
g.

> +EXPORT_SYMBOL(of_platform_device_populate_resources);
> +
>  /**
>   * of_platform_device_create - Alloc, initialize and register an of_device
>   * @np: pointer to node to create device for
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index 05cb4a9..315e1e3 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -53,6 +53,16 @@ struct of_dev_auxdata {
>  
>  extern const struct of_device_id of_default_bus_match_table[];
>  
> +/* Populate the resource for a platform device */
> +#ifdef CONFIG_OF
> +int of_platform_device_populate_resources(struct platform_device *dev);
> +#else
> +static inline int of_platform_device_populate_resources(
> +	struct platform_device *)
> +{
> +	return -ENOSYS;
> +}
> +#endif
>  /* Platform drivers register/unregister */
>  extern struct platform_device *of_device_alloc(struct device_node *np,
>  					 const char *bus_id,
> -- 
> 1.8.5.3
> 

