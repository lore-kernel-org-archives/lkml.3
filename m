Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaKTJVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:21:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39307 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbaKTJVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:21:49 -0500
Message-ID: <546DB29E.2030308@ti.com>
Date: Thu, 20 Nov 2014 14:51:34 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Vivek Gautam <gautam.vivek@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <andrew.kim@intel.com>
Subject: Re: [PATCHv5 6/7] base: platform: name the device already during
 allocation
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com> <1416410903-162369-7-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1416410903-162369-7-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday 19 November 2014 08:58 PM, Heikki Krogerus wrote:
> The device name is usually required when assigning resources
> like clocks to platform devices. The problem is that the
> device name is not know before platform_device_add is called
> and that can be too late as the drivers may have already
> requested the resources when the function returns. By naming
> the device already in platform_device_alloc, the resources
> can be assigned before platform_device_add is called.
> 
> This change allows different kinds of probe drivers to pass
> forward their resources to the actual driver. The first
> place where we need it is dwc3 controllers host glue code
> (drivers/usb/dwc3/host.c) to pass the phy's to xhci.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Are you fine with this change? Can it come via linux-phy tree?

Thanks
Kishon
> ---
>  drivers/base/platform.c | 69 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 41 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index cdb6c07..d2217f3 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -195,11 +195,41 @@ void platform_device_put(struct platform_device *pdev)
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
>  						  pdev.dev);
>  
> +	if (pa->pdev.id_auto)
> +		ida_simple_remove(&platform_devid_ida, pa->pdev.id);
> +
>  	of_device_node_put(&pa->pdev.dev);
>  	kfree(pa->pdev.dev.platform_data);
>  	kfree(pa->pdev.mfd_cell);
> @@ -228,6 +258,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
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
> @@ -308,28 +342,6 @@ int platform_device_add(struct platform_device *pdev)
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
> @@ -372,7 +384,6 @@ int platform_device_add(struct platform_device *pdev)
>  			release_resource(r);
>  	}
>  
> - err_out:
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(platform_device_add);
> @@ -392,11 +403,6 @@ void platform_device_del(struct platform_device *pdev)
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
> @@ -414,8 +420,15 @@ EXPORT_SYMBOL_GPL(platform_device_del);
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
