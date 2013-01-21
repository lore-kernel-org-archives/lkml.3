Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3AUK0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:26:42 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47825 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3AUK0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:26:41 -0500
Date: Mon, 21 Jan 2013 02:26:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 01/33] lib: devres: Introduce devm_ioremap_resource()
Message-ID: <20130121102638.GA13784@core.coreip.homeip.net>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-2-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358762966-20791-2-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:08:54AM +0100, Thierry Reding wrote:
> The devm_request_and_ioremap() function is very useful and helps avoid a
> whole lot of boilerplate. However, one issue that keeps popping up is
> its lack of a specific error code to determine which of the steps that
> it performs failed. Furthermore, while the function gives an example and
> suggests what error code to return on failure, a wide variety of error
> codes are used throughout the tree.
> 
> In an attempt to fix these problems, this patch adds a new function that
> drivers can transition to. The devm_ioremap_resource() returns a pointer
> to the remapped I/O memory on success or an ERR_PTR() encoded error code
> on failure. Callers can check for failure using IS_ERR() and determine
> its cause by extracting the error code using PTR_ERR().
> 
> devm_request_and_ioremap() is implemented as a wrapper around the new
> API and return NULL on failure as before. This ensures that backwards
> compatibility is maintained until all users have been converted to the
> new API, at which point the old devm_request_and_ioremap() function
> should be removed. To help prevent new users from being added in the
> meantime, devm_request_and_ioremap() is marked __deprecated.
> 
> A semantic patch is included which can be used to convert from the old
> devm_request_and_ioremap() API to the new devm_ioremap_resource() API.
> Some non-trivial cases may require manual intervention, though.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

This looks good to me.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  Documentation/driver-model/devres.txt              |  3 +-
>  include/linux/device.h                             |  3 +-
>  lib/devres.c                                       | 57 ++++++++++----
>  scripts/coccinelle/api/devm_ioremap_resource.cocci | 90 ++++++++++++++++++++++
>  4 files changed, 138 insertions(+), 15 deletions(-)
>  create mode 100644 scripts/coccinelle/api/devm_ioremap_resource.cocci
> 
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 43cff70..25240fc 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -266,7 +266,8 @@ IOMAP
>    devm_ioremap()
>    devm_ioremap_nocache()
>    devm_iounmap()
> -  devm_request_and_ioremap() : checks resource, requests region, ioremaps
> +  devm_ioremap_resource() : checks resource, requests memory region, ioremaps
> +  devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()
>    pcim_iomap()
>    pcim_iounmap()
>    pcim_iomap_table()	: array of mapped addresses indexed by BAR
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 43dcda9..558c405 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -573,8 +573,9 @@ extern int devres_release_group(struct device *dev, void *id);
>  extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
>  extern void devm_kfree(struct device *dev, void *p);
>  
> +void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
>  void __iomem *devm_request_and_ioremap(struct device *dev,
> -			struct resource *res);
> +			struct resource *res) __deprecated;
>  
>  struct device_dma_parameters {
>  	/*
> diff --git a/lib/devres.c b/lib/devres.c
> index 80b9c76..9c76b3a 100644
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -86,22 +86,24 @@ void devm_iounmap(struct device *dev, void __iomem *addr)
>  EXPORT_SYMBOL(devm_iounmap);
>  
>  /**
> - * devm_request_and_ioremap() - Check, request region, and ioremap resource
> - * @dev: Generic device to handle the resource for
> + * devm_ioremap_resource() - check, request region, and ioremap resource
> + * @dev: generic device to handle the resource for
>   * @res: resource to be handled
>   *
> - * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
> - * everything is undone on driver detach. Checks arguments, so you can feed
> - * it the result from e.g. platform_get_resource() directly. Returns the
> - * remapped pointer or NULL on error. Usage example:
> + * Checks that a resource is a valid memory region, requests the memory region
> + * and ioremaps it either as cacheable or as non-cacheable memory depending on
> + * the resource's flags. All operations are managed and will be undone on
> + * driver detach.
> + *
> + * Returns a pointer to the remapped memory or an ERR_PTR() encoded error code
> + * on failure. Usage example:
>   *
>   *	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> - *	base = devm_request_and_ioremap(&pdev->dev, res);
> - *	if (!base)
> - *		return -EADDRNOTAVAIL;
> + *	base = devm_ioremap_resource(&pdev->dev, res);
> + *	if (IS_ERR(base))
> + *		return PTR_ERR(base);
>   */
> -void __iomem *devm_request_and_ioremap(struct device *dev,
> -			struct resource *res)
> +void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
>  {
>  	resource_size_t size;
>  	const char *name;
> @@ -111,7 +113,7 @@ void __iomem *devm_request_and_ioremap(struct device *dev,
>  
>  	if (!res || resource_type(res) != IORESOURCE_MEM) {
>  		dev_err(dev, "invalid resource\n");
> -		return NULL;
> +		return ERR_PTR(-EINVAL);
>  	}
>  
>  	size = resource_size(res);
> @@ -119,7 +121,7 @@ void __iomem *devm_request_and_ioremap(struct device *dev,
>  
>  	if (!devm_request_mem_region(dev, res->start, size, name)) {
>  		dev_err(dev, "can't request region for resource %pR\n", res);
> -		return NULL;
> +		return ERR_PTR(-EBUSY);
>  	}
>  
>  	if (res->flags & IORESOURCE_CACHEABLE)
> @@ -130,10 +132,39 @@ void __iomem *devm_request_and_ioremap(struct device *dev,
>  	if (!dest_ptr) {
>  		dev_err(dev, "ioremap failed for resource %pR\n", res);
>  		devm_release_mem_region(dev, res->start, size);
> +		dest_ptr = ERR_PTR(-ENOMEM);
>  	}
>  
>  	return dest_ptr;
>  }
> +EXPORT_SYMBOL(devm_ioremap_resource);
> +
> +/**
> + * devm_request_and_ioremap() - Check, request region, and ioremap resource
> + * @dev: Generic device to handle the resource for
> + * @res: resource to be handled
> + *
> + * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
> + * everything is undone on driver detach. Checks arguments, so you can feed
> + * it the result from e.g. platform_get_resource() directly. Returns the
> + * remapped pointer or NULL on error. Usage example:
> + *
> + *	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> + *	base = devm_request_and_ioremap(&pdev->dev, res);
> + *	if (!base)
> + *		return -EADDRNOTAVAIL;
> + */
> +void __iomem *devm_request_and_ioremap(struct device *device,
> +				       struct resource *res)
> +{
> +	void __iomem *dest_ptr;
> +
> +	dest_ptr = devm_ioremap_resource(device, res);
> +	if (IS_ERR(dest_ptr))
> +		return NULL;
> +
> +	return dest_ptr;
> +}
>  EXPORT_SYMBOL(devm_request_and_ioremap);
>  
>  #ifdef CONFIG_HAS_IOPORT
> diff --git a/scripts/coccinelle/api/devm_ioremap_resource.cocci b/scripts/coccinelle/api/devm_ioremap_resource.cocci
> new file mode 100644
> index 0000000..495daa3
> --- /dev/null
> +++ b/scripts/coccinelle/api/devm_ioremap_resource.cocci
> @@ -0,0 +1,90 @@
> +virtual patch
> +virtual report
> +
> +@depends on patch@
> +expression base, dev, res;
> +@@
> +
> +-base = devm_request_and_ioremap(dev, res);
> ++base = devm_ioremap_resource(dev, res);
> + ...
> + if (
> +-base == NULL
> ++IS_ERR(base)
> + || ...) {
> +<...
> +-	return ...;
> ++	return PTR_ERR(base);
> +...>
> + }
> +
> +@depends on patch@
> +expression e, E, ret;
> +identifier l;
> +@@
> +
> + e = devm_ioremap_resource(...);
> + ...
> + if (IS_ERR(e) || ...) {
> + 	... when any
> +-	ret = E;
> ++	ret = PTR_ERR(e);
> + 	...
> +(
> + 	return ret;
> +|
> + 	goto l;
> +)
> + }
> +
> +@depends on patch@
> +expression e;
> +@@
> +
> + e = devm_ioremap_resource(...);
> + ...
> + if (IS_ERR(e) || ...) {
> + 	...
> +-	\(dev_dbg\|dev_err\|pr_debug\|pr_err\|DRM_ERROR\)(...);
> + 	...
> + }
> +
> +@depends on patch@
> +expression e;
> +identifier l;
> +@@
> +
> + e = devm_ioremap_resource(...);
> + ...
> + if (IS_ERR(e) || ...)
> +-{
> +(
> + 	return ...;
> +|
> + 	goto l;
> +)
> +-}
> +
> +@r depends on report@
> +expression e;
> +identifier l;
> +position p1;
> +@@
> +
> +*e = devm_request_and_ioremap@p1(...);
> + ...
> + if (e == NULL || ...) {
> + 	...
> +(
> + 	return ...;
> +|
> + 	goto l;
> +)
> + }
> +
> +@script:python depends on r@
> +p1 << r.p1;
> +@@
> +
> +msg = "ERROR: deprecated devm_request_and_ioremap() API used on line %s" % (p1[0].line)
> +coccilib.report.print_report(p1[0], msg)
> -- 
> 1.8.1.1
> 

-- 
Dmitry
