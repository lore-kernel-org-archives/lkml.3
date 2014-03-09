Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaCIFdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 00:33:13 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52571 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaCIFdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 00:33:11 -0500
Date: Sat, 8 Mar 2014 21:33:06 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DCG_UPD_stlinux_kernel@list.st.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, Angus.Clark@st.com
Subject: Re: [PATCH 01/35] mtd: st_spi_fsm: Allocate resources and register
 with MTD framework
Message-ID: <20140309053306.GL31517@norris-Latitude-E6410>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
 <1392735362-1245-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392735362-1245-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

>From my very first glance here, it looks like there are several (mostly
minor) comments that still aren't addressed in this series. I'll point
at the ones I notice in this patch, but can you recheck my comments from
v2? I'll still try to take another pass at reading the next 34
patches...

On Tue, Feb 18, 2014 at 02:55:28PM +0000, Lee Jones wrote:
> This is a new driver. It's used to communicate with a special type of
> optimised Serial Flash Controller called the FSM. The FSM uses a subset

The question was asked earlier: what does FSM stand for? Perhaps include
the expansion in either the Kconfig or driver?

> of the SPI protocol to communicate with supported NOR-Flash devices.
> 
> Acked-by Angus Clark <angus.clark@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/devices/Kconfig      |   8 ++++
>  drivers/mtd/devices/Makefile     |   1 +
>  drivers/mtd/devices/st_spi_fsm.c | 101 +++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/devices/st_spi_fsm.h |  27 +++++++++++
>  4 files changed, 137 insertions(+)
>  create mode 100644 drivers/mtd/devices/st_spi_fsm.c
>  create mode 100644 drivers/mtd/devices/st_spi_fsm.h
> 
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 74ab4b7..0cf48ac 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -217,6 +217,14 @@ config MTD_DOCG3
>  	  M-Systems and now Sandisk. The support is very experimental,
>  	  and doesn't give access to any write operations.
>  
> +config MTD_ST_SPI_FSM
> +	tristate "ST Microelectronics SPI FSM Serial Flash Controller"
> +	depends on ARM || SH
> +	help
> +	  This provides an MTD device driver for the ST Microelectronics
> +	  SPI FSM Serial Flash Controller and support for a subset of
> +	  connected Serial Flash devices.
> +
>  if MTD_DOCG3
>  config BCH_CONST_M
>  	default 14
> diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
> index d83bd73..c68868f 100644
> --- a/drivers/mtd/devices/Makefile
> +++ b/drivers/mtd/devices/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_MTD_NAND_OMAP_BCH)	+= elm.o
>  obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
>  obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
>  obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
> +obj-$(CONFIG_MTD_ST_SPI_FSM)    += st_spi_fsm.o
>  
>  
>  CFLAGS_docg3.o			+= -I$(src)
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> new file mode 100644
> index 0000000..2f4ebb4
> --- /dev/null
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -0,0 +1,101 @@
> +/*
> + * st_spi_fsm.c	Support for ST Serial Flash Controller
> + *
> + * Author: Angus Clark <angus.clark@st.com>
> + *
> + * Copyright (C) 2010-2013 STicroelectronics Limited

I commented before:

s/STicro/STMicro/

This is in the header, too. I'm guessing that's just a typo. Maybe
update the year too?

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
> +#include "st_spi_fsm.h"
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
> +	fsm->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(fsm->base)) {
> +		dev_err(&pdev->dev,
> +			"Failed to reserve memory region [0x%08x-0x%08x]\n",
> +			res->start, res->end);

I'll repeat my comment:

Use the special %pr or %pR format specifier? See
Documentation/printk-formats.txt

> +		return PTR_ERR(fsm->base);
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

I'll repeat my comment: just make this

	return mtd_device_unregister(&fsm->mtd);

> +}
> +
> +static struct of_device_id stfsm_match[] = {
> +	{ .compatible = "st,spi-fsm", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, stfsm_match);
> +
> +static struct platform_driver stfsm_driver = {
> +	.probe		= stfsm_probe,
> +	.remove		= stfsm_remove,
> +	.driver		= {
> +		.name	= "st-spi-fsm",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = stfsm_match,
> +	},
> +};
> +module_platform_driver(stfsm_driver);
> +
> +MODULE_AUTHOR("Angus Clark <angus.clark@st.com>");
> +MODULE_DESCRIPTION("ST SPI FSM driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
> new file mode 100644
> index 0000000..df45e1a
> --- /dev/null
> +++ b/drivers/mtd/devices/st_spi_fsm.h

You add this header here, but (per my suggestions) you merge it back
into st_spi_fsm.c in patch 2. Perhaps you never should have created it?
Maybe this was a side effect of git-rebase over a few review cycles?

> @@ -0,0 +1,27 @@
> +/*
> + * st_spi_fsm.c	Support for ST Serial Flash Controller
> + *
> + * Author: Angus Clark <angus.clark@st.com>
> + *
> + * Copyright (C) 2010-2013 STicroelectronics Limited
> + *
> + * JEDEC probe based on drivers/mtd/devices/m25p80.c
> + *
> + * This code is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef ST_SPI_FSM_H
> +#define ST_SPI_FSM_H
> +
> +struct stfsm {
> +	struct device		*dev;
> +	void __iomem		*base;
> +	struct resource		*region;
> +	struct mtd_info		mtd;
> +	struct mutex		lock;
> +};
> +
> +#endif	/* ST_SPI_FSM_H */

Thanks,
Brian
