Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3FNIh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:37:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60250 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab3FNIhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:37:24 -0400
Message-ID: <51BAD611.1070306@ti.com>
Date: Fri, 14 Jun 2013 14:06:33 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <benoit.cousson@linaro.org>,
        <anish198519851985@gmail.com>, <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2] extcon: Add an API to get extcon device from dt node
References: <1370276020-17446-2-git-send-email-kishon@ti.com> <1371194146-17260-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1371194146-17260-1-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 14 June 2013 12:45 PM, Chanwoo Choi wrote:
> From: Kishon Vijay Abraham I <kishon@ti.com>
>
> Added an API of_extcon_get_extcon_dev() to be used by drivers to get
> extcon device in the case of dt boot (this can be used instead of
> extcon_get_extcon_dev()).
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
> Changes since v1:
> - If edev->name is NULL, dev_name(dev) is used as edev->name.
> - Change filename from of-extcon.* to of_extcon.*
> - Fix build error when CONFIG_OF is not set
> - Add header file(linux/err.h) to of_extcon.c
>
>   drivers/extcon/Makefile          |  2 ++
>   drivers/extcon/extcon-class.c    |  3 +-
>   drivers/extcon/of_extcon.c       | 64 ++++++++++++++++++++++++++++++++++++++++
>   include/linux/extcon/of_extcon.h | 30 +++++++++++++++++++
>   4 files changed, 98 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/extcon/of_extcon.c
>   create mode 100644 include/linux/extcon/of_extcon.h
>
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index 540e2c3..83468f7 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -2,6 +2,8 @@
>   # Makefile for external connector class (extcon) devices
>   #
>
> +obj-$(CONFIG_OF)		+= of_extcon.o
> +
>   obj-$(CONFIG_EXTCON)		+= extcon-class.o
>   obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
>   obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-adc-jack.o
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 23f11ea..08509ea 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -602,7 +602,8 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
>   	edev->dev->class = extcon_class;
>   	edev->dev->release = extcon_dev_release;
>
> -	dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
> +	edev->name = edev->name ? edev->name : dev_name(dev);
> +	dev_set_name(edev->dev, edev->name);
>
>   	if (edev->max_supported) {
>   		char buf[10];
> diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
> new file mode 100644
> index 0000000..72173ec
> --- /dev/null
> +++ b/drivers/extcon/of_extcon.c
> @@ -0,0 +1,64 @@
> +/*
> + * OF helpers for External connector (extcon) framework
> + *
> + * Copyright (C) 2013 Texas Instruments, Inc.
> + * Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * Copyright (C) 2013 Samsung Electronics
> + * Chanwoo Choi <cw00.choi@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/extcon.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/extcon/of_extcon.h>
> +
> +/*
> + * of_extcon_get_extcon_dev - Get the name of extcon device from devicetree
> + * @dev - instance to the given device
> + * @index - index into list of extcon_dev
> + *
> + * return the instance of extcon device
> + */
> +struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
> +{
> +	struct device_node *node;
> +	struct extcon_dev *edev;
> +	struct platform_device *extcon_parent_dev;
> +
> +	if (!dev->of_node) {
> +		dev_dbg(dev, "device does not have a device node entry\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	node = of_parse_phandle(dev->of_node, "extcon", index);
> +	if (!node) {
> +		dev_dbg(dev, "failed to get phandle in %s node\n",
> +			dev->of_node->full_name);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	extcon_parent_dev = of_find_device_by_node(node);
> +	if (!extcon_parent_dev) {
> +		dev_dbg(dev, "unable to find device by node\n");
> +		return ERR_PTR(-EPROBE_DEFER);
> +	}
> +
> +	edev = extcon_get_extcon_dev(dev_name(&extcon_parent_dev->dev));
> +	if (!edev) {
> +		dev_dbg(dev, "unable to get extcon device : %s\n",
> +				dev_name(&extcon_parent_dev->dev));
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	return edev;
> +}
> +EXPORT_SYMBOL_GPL(of_extcon_get_extcon_dev);
> diff --git a/include/linux/extcon/of_extcon.h b/include/linux/extcon/of_extcon.h
> new file mode 100644
> index 0000000..462f071
> --- /dev/null
> +++ b/include/linux/extcon/of_extcon.h
> @@ -0,0 +1,30 @@
> +/*
> + * OF helpers for External connector (extcon) framework
> + *
> + * Copyright (C) 2013 Texas Instruments, Inc.
> + * Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * Copyright (C) 2013 Samsung Electronics
> + * Chanwoo Choi <cw00.choi@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __LINUX_OF_EXTCON_H
> +#define __LINUX_OF_EXTCON_H
> +
> +#if defined(CONFIG_OF) && defined(CONFIG_EXTCON)
> +extern struct extcon_dev
> +	*of_extcon_get_extcon_dev(struct device *dev, int index);
> +#else
> +static inline struct extcon_dev
> +	*of_extcon_get_extcon_dev(struct device *dev, int index)
> +{
> +	return NULL;

Can we have some error value returned here instead of NULL?
ERR_PTR(-ENOSYS)?

Thanks
Kishon
