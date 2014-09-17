Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaIQLMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:12:31 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:62745 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaIQLM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:12:29 -0400
Date: Wed, 17 Sep 2014 13:10:05 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Robin Gong <b38343@freescale.com>
Cc: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <sre@kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] power: reset: imx-snvs-poweroff: add power off
 driver for i.mx6
Message-ID: <20140917131005.7d8ab95c@ipc1.ka-ro>
In-Reply-To: <1410947881-7345-3-git-send-email-b38343@freescale.com>
References: <1410947881-7345-1-git-send-email-b38343@freescale.com>
	<1410947881-7345-3-git-send-email-b38343@freescale.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Robin Gong wrote:
> This driver register pm_power_off with snvs power off function. If
> your boards NOT use PMIC_ON_REQ to turn on/off external pmic, or use
> other pin to do, please disable the driver in dts, otherwise, your
> pm_power_off maybe overwrote by this driver.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  .../bindings/power_supply/imx-snvs-poweroff.txt    |   23 +++++++
>  drivers/power/reset/Kconfig                        |    9 +++
>  drivers/power/reset/Makefile                       |    1 +
>  drivers/power/reset/imx-snvs-poweroff.c            |   66 ++++++++++++++++++++
>  4 files changed, 99 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
>  create mode 100644 drivers/power/reset/imx-snvs-poweroff.c
> 
[...]
> diff --git a/drivers/power/reset/imx-snvs-poweroff.c b/drivers/power/reset/imx-snvs-poweroff.c
> new file mode 100644
> index 0000000..d726ac4
> --- /dev/null
> +++ b/drivers/power/reset/imx-snvs-poweroff.c
> @@ -0,0 +1,66 @@
> +/* Power off driver for i.mx6
> + * Copyright (c) 2014, FREESCALE CORPORATION.  All rights reserved.
> + *
> + * based on msm-poweroff.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +
> +static void __iomem *snvs_base;
> +
> +static void do_imx_poweroff(void)
> +{
> +	u32 value = readl(snvs_base);
> +
> +	/* set TOP and DP_EN bit */
> +	writel(value | 0x60, snvs_base);
> +}
> +
> +static int imx_poweroff_probe(struct platform_device *pdev)
> +{
> +	snvs_base = of_iomap(pdev->dev.of_node, 0);
> +	if (!snvs_base) {
> +		dev_err(&pdev->dev, "failed to get memory\n");
> +		return -EIO;
>
I don't think EIO is an appropriate return code here. There was no I/O
in progress that had an error. IMO ENODEV would be more appropriate
here.

> +static const struct of_device_id of_imx_poweroff_match[] = {
> +	{ .compatible = "fsl,sec-v4.0-poweroff", },
> +	{},
>
useless comma after terminating NULL element of array.
You never want any patch to add an entry after this one.
Without the comma doing so (e.g. because of a badly resolved merge
conflict) would lead to a compile error.


> +};
> +MODULE_DEVICE_TABLE(of, of_imx_poweroff_match);
> +
> +static struct platform_driver imx_poweroff_driver = {
> +	.probe = imx_poweroff_probe,
> +	.driver = {
> +		.name = "imx-snvs-poweroff",
> +		.of_match_table = of_match_ptr(of_imx_poweroff_match),
>
useless use of of_match_ptr()


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
