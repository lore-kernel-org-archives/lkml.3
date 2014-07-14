Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaGNGUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:20:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42062 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaGNGUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:20:01 -0400
Message-ID: <53C3767A.9000203@ti.com>
Date: Mon, 14 Jul 2014 11:49:38 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv2 5/6] base: platform: name the device already during
 allocation
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com> <1401972778-5880-6-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1401972778-5880-6-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Thursday 05 June 2014 06:22 PM, Heikki Krogerus wrote:
> This allows resources such as GPIOs and clocks, which can be
> matched based on the device name when requested, to be
> assigned even when PLATFORM_DEVID_AUTO is used.

Any comments on this patch?

Thanks
Kishon
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/platform.c | 77 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 47 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 9e9227e..e856bc4 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -177,11 +177,45 @@ struct platform_object {
>   */
>  void platform_device_put(struct platform_device *pdev)
>  {
> -	if (pdev)
> -		put_device(&pdev->dev);
> +	if (!pdev)
> +		return;
> +
> +	if (pdev->id_auto) {
> +		ida_simple_remove(&platform_devid_ida, pdev->id);
> +		pdev->id = PLATFORM_DEVID_AUTO;
> +	}
> +
> +	put_device(&pdev->dev);
>  }
>  EXPORT_SYMBOL_GPL(platform_device_put);
>  
> +static int pdev_set_name(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	switch (pdev->id) {
> +	default:
> +		return dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
> +	case PLATFORM_DEVID_NONE:
> +		return dev_set_name(&pdev->dev, "%s", pdev->name);
> +	case PLATFORM_DEVID_AUTO:
> +		/*
> +		 * Automatically allocated device ID. We mark it as such so
> +		 * that we remember it must be freed, and we append a suffix
> +		 * to avoid namespace collision with explicit IDs.
> +		 */
> +		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
> +		if (ret < 0)
> +			return ret;
> +		pdev->id = ret;
> +		pdev->id_auto = true;
> +		return dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name,
> +				    pdev->id);
> +	}
> +
> +	return 0;
> +}
> +
>  static void platform_device_release(struct device *dev)
>  {
>  	struct platform_object *pa = container_of(dev, struct platform_object,
> @@ -214,6 +248,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
>  		device_initialize(&pa->pdev.dev);
>  		pa->pdev.dev.release = platform_device_release;
>  		arch_setup_pdev_archdata(&pa->pdev);
> +		if (pdev_set_name(&pa->pdev)) {
> +			kfree(pa);
> +			return NULL;
> +		}
>  	}
>  
>  	return pa ? &pa->pdev : NULL;
> @@ -294,28 +332,6 @@ int platform_device_add(struct platform_device *pdev)
>  
>  	pdev->dev.bus = &platform_bus_type;
>  
> -	switch (pdev->id) {
> -	default:
> -		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
> -		break;
> -	case PLATFORM_DEVID_NONE:
> -		dev_set_name(&pdev->dev, "%s", pdev->name);
> -		break;
> -	case PLATFORM_DEVID_AUTO:
> -		/*
> -		 * Automatically allocated device ID. We mark it as such so
> -		 * that we remember it must be freed, and we append a suffix
> -		 * to avoid namespace collision with explicit IDs.
> -		 */
> -		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
> -		if (ret < 0)
> -			goto err_out;
> -		pdev->id = ret;
> -		pdev->id_auto = true;
> -		dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name, pdev->id);
> -		break;
> -	}
> -
>  	for (i = 0; i < pdev->num_resources; i++) {
>  		struct resource *p, *r = &pdev->resource[i];
>  
> @@ -358,7 +374,6 @@ int platform_device_add(struct platform_device *pdev)
>  			release_resource(r);
>  	}
>  
> - err_out:
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(platform_device_add);
> @@ -378,11 +393,6 @@ void platform_device_del(struct platform_device *pdev)
>  	if (pdev) {
>  		device_del(&pdev->dev);
>  
> -		if (pdev->id_auto) {
> -			ida_simple_remove(&platform_devid_ida, pdev->id);
> -			pdev->id = PLATFORM_DEVID_AUTO;
> -		}
> -
>  		for (i = 0; i < pdev->num_resources; i++) {
>  			struct resource *r = &pdev->resource[i];
>  			unsigned long type = resource_type(r);
> @@ -400,8 +410,15 @@ EXPORT_SYMBOL_GPL(platform_device_del);
>   */
>  int platform_device_register(struct platform_device *pdev)
>  {
> +	int ret;
> +
>  	device_initialize(&pdev->dev);
>  	arch_setup_pdev_archdata(pdev);
> +
> +	ret = pdev_set_name(pdev);
> +	if (ret)
> +		return ret;
> +
>  	return platform_device_add(pdev);
>  }
>  EXPORT_SYMBOL_GPL(platform_device_register);
> 
