Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3LJSrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:47:46 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:62214 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3LJSrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:47:45 -0500
Date: Tue, 10 Dec 2013 10:47:40 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 01/36] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
Message-ID: <20131210184740.GZ27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:18:50PM +0000, Lee Jones wrote:
> --- /dev/null
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -0,0 +1,111 @@
> +/*
> + * st_spi_fsm.c	Support for ST Serial Flash Controller
> + *
> + * Author: Angus Clark <angus.clark@st.com>
> + *
> + * Copyright (C) 2010-2013 STicroelectronics Limited

Should be STMicrolectronics? :)

> + *
> + * JEDEC probe based on drivers/mtd/devices/m25p80.c
> + *
> + * This code is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/sched.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +
> +#include <asm/io.h>
> +
> +#include "st_spi_fsm.h"

I agree with Srinivas. Unless you think this header can be used in
another file, it should probably be part of this .c file. It also lends
itself to some strange usage of 'static' functions declared (but not
defined) in the header. But I'll comment when I get to those patches.

> +
> +static int stfsm_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct resource *res;
> +	struct stfsm *fsm;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "No DT found\n");
> +		return -EINVAL;
> +	}
> +
> +	fsm = devm_kzalloc(&pdev->dev, sizeof(*fsm), GFP_KERNEL);
> +	if (!fsm)
> +		return -ENOMEM;
> +
> +	fsm->dev = &pdev->dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "Resource not found\n");
> +		return -ENODEV;
> +	}
> +
> +	fsm->region = devm_request_mem_region(&pdev->dev, res->start,
> +					      resource_size(res), pdev->name);
> +	if (!fsm->region) {
> +		dev_err(&pdev->dev,
> +			"Failed to reserve memory region [0x%08x-0x%08x]\n",

Use the special %pr or %pR format specifier? See
Documentation/printk-formats.txt

> +			res->start, res->end);
> +		return -EBUSY;
> +	}
> +
> +	fsm->base = devm_ioremap_nocache(&pdev->dev,
> +					 res->start, resource_size(res));
> +	if (!fsm->base) {
> +		dev_err(&pdev->dev, "Failed to ioremap [0x%08x]\n", res->start);

Also %pr or %pR?

> +		return -EINVAL;
> +	}
> +
> +	mutex_init(&fsm->lock);
> +
> +	platform_set_drvdata(pdev, fsm);
> +
> +	fsm->mtd.dev.parent	= &pdev->dev;
> +	fsm->mtd.type		= MTD_NORFLASH;
> +	fsm->mtd.writesize	= 4;
> +	fsm->mtd.writebufsize	= fsm->mtd.writesize;
> +	fsm->mtd.flags		= MTD_CAP_NORFLASH;
> +
> +	return mtd_device_parse_register(&fsm->mtd, NULL, NULL, NULL, 0);
> +}
> +
> +static int stfsm_remove(struct platform_device *pdev)
> +{
> +	struct stfsm *fsm = platform_get_drvdata(pdev);
> +	int err;
> +
> +	err = mtd_device_unregister(&fsm->mtd);
> +	if (err)
> +		return err;
> +
> +	return 0;

Simplify to the following?

	return mtd_device_unregister(&fsm->mtd);

> +}

[...]

Brian
