Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaAWORd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:17:33 -0500
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:59985 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209AbaAWOR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:17:28 -0500
Message-ID: <52E12434.7030000@st.com>
Date: Thu, 23 Jan 2014 15:16:20 +0100
From: Ludovic Barre <ludovic.barre@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <linus.walleij@linaro.org>, <dwmw2@infradead.org>,
        <linux-mtd@lists.infradead.org>, <computersforpeace@gmail.com>,
        <Angus.Clark@st.com>, <DCG_UPD_stlinux_kernel@list.st.com>,
        <olivier.clergeaud@st.com>
Subject: Re: [PATCH RESEND v4 01/37] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org> <1390473085-24626-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1390473085-24626-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.121]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 11:30 AM, Lee Jones wrote:
> This is a new driver. It's used to communicate with a special type of
> optimised Serial Flash Controller called the FSM. The FSM uses a subset
> of the SPI protocol to communicate with supported NOR-Flash devices.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/mtd/devices/Kconfig      |   8 +++
>   drivers/mtd/devices/Makefile     |   1 +
>   drivers/mtd/devices/st_spi_fsm.c | 109 +++++++++++++++++++++++++++++++++++++++
>   drivers/mtd/devices/st_spi_fsm.h |  27 ++++++++++
>   4 files changed, 145 insertions(+)
>   create mode 100644 drivers/mtd/devices/st_spi_fsm.c
>   create mode 100644 drivers/mtd/devices/st_spi_fsm.h
>
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 74ab4b7..0cf48ac 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -217,6 +217,14 @@ config MTD_DOCG3
>   	  M-Systems and now Sandisk. The support is very experimental,
>   	  and doesn't give access to any write operations.
>
> +config MTD_ST_SPI_FSM
> +	tristate "ST Microelectronics SPI FSM Serial Flash Controller"
> +	depends on ARM || SH
> +	help
> +	  This provides an MTD device driver for the ST Microelectronics
> +	  SPI FSM Serial Flash Controller and support for a subset of
> +	  connected Serial Flash devices.
> +
>   if MTD_DOCG3
>   config BCH_CONST_M
>   	default 14
> diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
> index d83bd73..c68868f 100644
> --- a/drivers/mtd/devices/Makefile
> +++ b/drivers/mtd/devices/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_MTD_NAND_OMAP_BCH)	+= elm.o
>   obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
>   obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
>   obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
> +obj-$(CONFIG_MTD_ST_SPI_FSM)    += st_spi_fsm.o
>
>
>   CFLAGS_docg3.o			+= -I$(src)
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> new file mode 100644
> index 0000000..fe66342
> --- /dev/null
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -0,0 +1,109 @@
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
> +	fsm->region = devm_request_mem_region(&pdev->dev, res->start,
> +					      resource_size(res), pdev->name);
> +	if (!fsm->region) {
> +		dev_err(&pdev->dev,
> +			"Failed to reserve memory region [0x%08x-0x%08x]\n",
> +			res->start, res->end);
> +		return -EBUSY;
> +	}
> +
> +	fsm->base = devm_ioremap_nocache(&pdev->dev,
> +					 res->start, resource_size(res));
> +	if (!fsm->base) {
> +		dev_err(&pdev->dev, "Failed to ioremap [0x%08x]\n", res->start);
> +		return -EINVAL;
> +	}
> +
you can replace  "devm_request_mem_region" & "devm_ioremap_nocache" by 
"devm_ioremap_resource"

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
>

