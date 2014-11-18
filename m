Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaKRKg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:36:27 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11710 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaKRKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:36:25 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-0d-546b21266d29
Message-id: <546B2123.7060406@samsung.com>
Date: Tue, 18 Nov 2014 11:36:19 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.drivers.devicetree,gmane.linux.ports.arm.kernel,gmane.linux.ports.ppc64.devel
To: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] of/platform: Move platform devices under
 /sys/devices/platform
References: <1415097920-30014-1-git-send-email-grant.likely@linaro.org>
In-reply-to: <1415097920-30014-1-git-send-email-grant.likely@linaro.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xK7pqitkhBmsbOSz+TjrGbvGhqZXZ
	Yv6Rc6wWB/7sYLRoXryezWLT42usFpd3zWGz+P39H6tF694j7A6cHr9/TWL06HnTwuqxaVUn
	m8eda3vYPPbPXcPusXlJvcf5GQsZPT5vkgvgiOKySUnNySxLLdK3S+DK+DdvDUvBO4mK57vm
	MTUwfhLpYuTkkBAwkXj0cD0rhC0mceHeerYuRi4OIYGljBJNqx8wQTifGCVWtF5n7GLk4OAV
	0JL40GkH0sAioCqxadpiFhCbTUBT4u/mm2wgtqhAhMSVNXMYQWxeAUGJH5PvgdXwCVRJvDv2
	ix1kpojAWkaJ9f33GUEcZoHVjBLbp/wFqxIWCJVYe3oiM4gtJOAuMfnOATCbU8BD4uTOiSwg
	RzAL6Encv6gFEmYWkJfYvOYt8wRGwVlI9s1CqJqFpGoBI/MqRtHU0uSC4qT0XCO94sTc4tK8
	dL3k/NxNjJBo+bqDcekxq0OMAhyMSjy8DRuzQoRYE8uKK3MPMUpwMCuJ8J7rBgrxpiRWVqUW
	5ccXleakFh9iZOLglGpg5A6aq//o1ArVe8E88/l2fGxlk9U03BgyN+mN+Ywjj/a2XP27/X5T
	1WdpwW3v1v3lPyly7ue/p07mPI6W9jvc/+zl7phz4k/NTfHJHnnLHUpKXQv7RR1lvSsOJ0h5
	H7u7/HnQ2TxtwTj/iOjEP5eTprOYMVx5ldG//9XTZsZjpgVXNi7Zm1Dsr8RSnJFoqMVcVJwI
	AGCXNqd0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 11:45 AM, Grant Likely wrote:
> Currently the devices created by drivers/of/platform.c get created at
> the root of /sys/devices. This goes against the typical pattern for
> sysfs where the top level /sys/devices structure contains categories of
> devices, and the structure of devices is placed below that. To fix this,
> make the code in drivers/of/platform.c follow the drivers/base/platform.c
> behaviour, and use &platform_bus as the default parent for all new
> platform_devices and amba_devices.
> 
> This change has been discussed for a long time, but nobody has actually
> acted on it. Userspace code that expects to find devices under a fixed
> /sys/devices/... path will be affected. It isn't /supposed/ to do that,
> but if anyone complains then I'll add a default-off workaround option to
> put them back into the root.

One of side effects of this change is that platform drivers registering
other platform drivers or devices in their probe callback can deadlock
due to double device_lock on platform device. This is for example case
of exynos_drm driver[1]. I guess it could/should be fixed in exynos_drm.
Anyway it can affect other drivers as well. At least grep shows few
possible candidates:

$ git grep -p platform_driver_register | grep -A1 -P '_probe\(struct
platform_device'

drivers/gpu/drm/exynos/exynos_drm_drv.c=static int
exynos_drm_platform_probe(struct platform_device *pdev)
drivers/gpu/drm/exynos/exynos_drm_drv.c:	ret =
platform_driver_register(&fimd_driver);
--
drivers/gpu/drm/sti/sti_drm_drv.c=static int
sti_drm_platform_probe(struct platform_device *pdev)
drivers/gpu/drm/sti/sti_drm_drv.c:
platform_driver_register(&sti_drm_master_driver);
--
drivers/mtd/nand/atmel_nand.c=static int atmel_nand_probe(struct
platform_device *pdev)
drivers/mtd/nand/atmel_nand.c:	res =
platform_driver_register(&atmel_nand_nfc_driver);


[1]: http://permalink.gmane.org/gmane.comp.video.dri.devel/117727

Regards
Andrzej


> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  drivers/of/platform.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 3b64d0bf5bba..7c6771986c06 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -138,7 +138,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  	}
>  
>  	dev->dev.of_node = of_node_get(np);
> -	dev->dev.parent = parent;
> +	dev->dev.parent = parent ? : &platform_bus;
>  
>  	if (bus_id)
>  		dev_set_name(&dev->dev, "%s", bus_id);
> @@ -291,7 +291,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  
>  	/* setup generic device info */
>  	dev->dev.of_node = of_node_get(node);
> -	dev->dev.parent = parent;
> +	dev->dev.parent = parent ? : &platform_bus;
>  	dev->dev.platform_data = platform_data;
>  	if (bus_id)
>  		dev_set_name(&dev->dev, "%s", bus_id);
> 

