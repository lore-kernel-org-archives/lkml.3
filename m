Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3FLGzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 02:55:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56300 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab3FLGzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 02:55:31 -0400
Message-ID: <51B81B50.10508@ti.com>
Date: Wed, 12 Jun 2013 12:25:12 +0530
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
Subject: Re: [PATCH] extcon: Add an API to get extcon device from dt node
References: <1370276020-17446-2-git-send-email-kishon@ti.com> <1371001149-16906-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1371001149-16906-1-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo Choi,

On Wednesday 12 June 2013 07:09 AM, Chanwoo Choi wrote:
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
>   drivers/extcon/Makefile          |  3 +++
>   drivers/extcon/of-extcon.c       | 56 ++++++++++++++++++++++++++++++++++++++++
>   include/linux/extcon/of-extcon.h | 30 +++++++++++++++++++++
>   3 files changed, 89 insertions(+)
>   create mode 100644 drivers/extcon/of-extcon.c
>   create mode 100644 include/linux/extcon/of-extcon.h
>
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index 540e2c3..39cdf95 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -2,9 +2,12 @@
>   # Makefile for external connector class (extcon) devices
>   #
>
> +obj-$(CONFIG_OF)		+= of-extcon.o
> +
>   obj-$(CONFIG_EXTCON)		+= extcon-class.o
>   obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
>   obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-adc-jack.o
> +
>   obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
>   obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>   obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
> diff --git a/drivers/extcon/of-extcon.c b/drivers/extcon/of-extcon.c
> new file mode 100644
> index 0000000..29f82b4
> --- /dev/null
> +++ b/drivers/extcon/of-extcon.c
> @@ -0,0 +1,56 @@
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
> +#include <linux/extcon.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/extcon/of-extcon.h>
> +
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

In order to get this working, I needed a small fix in extcon_dev_register

-       dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
+       edev->name = edev->name ? edev->name : dev_name(dev);
+       dev_set_name(edev->dev, edev->name);

Also using extcon_get_extcon_dev here requires the extcon driver not to 
set edev.name since we use *dev_name* here. Hence I recommend using my 
initial class iterative approach. Anyway its your call. Let me know if 
have to float a new version of the patch (either the iterative approach 
or having the fix I mentioned in extcon_dev_register).

Thanks
Kishon
