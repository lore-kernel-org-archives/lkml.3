Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab3G3HLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:11:21 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:38255 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab3G3HLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:11:19 -0400
Message-ID: <1375168228.1956.71.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH] drivers: power: reset: add msm restart support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Abhimanyu Kapur <abhimany@codeaurora.org>
Cc: Anton Vorontsov <anton@enomsg.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org
Date: Tue, 30 Jul 2013 10:10:28 +0300
In-Reply-To: <1375136906-22501-1-git-send-email-abhimany@codeaurora.org>
References: <1375136906-22501-1-git-send-email-abhimany@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Mon, 2013-07-29 at 15:28 -0700, Abhimanyu Kapur wrote:
> Add support for restart and poweroff functionality present on MSM
> chipsets with the MPM2 ps-hold hardware.
> 
> Signed-off-by: Abhimanyu Kapur <abhimany@codeaurora.org>
> ---
>  .../bindings/power_supply/msm-poweroff.txt         | 17 +++++
>  drivers/power/reset/Kconfig                        |  6 ++
>  drivers/power/reset/Makefile                       |  1 +
>  drivers/power/reset/msm-poweroff.c                 | 73 ++++++++++++++++++++++
>  4 files changed, 97 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
>  create mode 100644 drivers/power/reset/msm-poweroff.c

Thank you for this. I was not aware how important is the reboot command
until I get board which did not have reset button :-)

> 
> diff --git a/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt b/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
> new file mode 100644
> index 0000000..de08480
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
> @@ -0,0 +1,17 @@
> +MSM Poweroff Driver
> +
> +A power supply hold (ps-hold) bit is set to power the msm chipsets.
> +Clearing that bit enables us to restart/poweroff. The difference
> +between poweroff and restart is determined by unique power manager IC
> +settings.
> +
> +Required Properties:
> +-compatible: "qcom,pshold"
> +-reg: Specifies the physical address of the ps-hold register
> +
> +Example:
> +
> +	restart@800820 {
> +		compatible = "qcom,pshold";
> +		reg = <0x00800820 0x4>;

It will be nice if this address could be used straight a way. 
If I use this address module can not be loaded, because:

"can't request region for resource [mem 0x00800820-0x00800823]"

Not sure, but when address is 0xfa107000 my 8074 based
dragonboard perform reboot successfully.

> +	};
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index 349e9ae..fa6178f 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -37,3 +37,9 @@ config POWER_RESET_VEXPRESS
>  	help
>  	  Power off and reset support for the ARM Ltd. Versatile
>  	  Express boards.
> +
> +config POWER_RESET_MSM
> +	bool "Qualcomm MSM power-off driver"
> +	depends on POWER_RESET && ARCH_MSM
> +	help
> +	  Power off and restart support for Qualcomm boards.
> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> index 372807f..b82288e 100644
> --- a/drivers/power/reset/Makefile
> +++ b/drivers/power/reset/Makefile
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
> +obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
>  obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
>  obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
>  obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
> diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
> new file mode 100644
> index 0000000..0d33d18
> --- /dev/null
> +++ b/drivers/power/reset/msm-poweroff.c
> @@ -0,0 +1,73 @@
> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>

missing #include <linux/module.h>

> +
> +#include <asm/system_misc.h>
> +
> +static void __iomem *msm_ps_hold;
> +
> +static void do_msm_restart(char mode, const char *cmd)

the right prototype is:

void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd)

Regards,
Ivan

> +{
> +	writel(0, msm_ps_hold);
> +	mdelay(10000);
> +}
> +
> +static void do_msm_poweroff(void)
> +{
> +	/* TODO: Add poweroff capability */
> +
> +	do_msm_restart('p', NULL);
> +}
> +
> +static int msm_restart_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *mem;
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	msm_ps_hold = devm_ioremap_resource(dev, mem);
> +	if (IS_ERR(msm_ps_hold))
> +		return PTR_ERR(msm_ps_hold);
> +
> +	pm_power_off = do_msm_poweroff;
> +	arm_pm_restart = do_msm_restart;
> +	return 0;
> +}
> +
> +static const struct of_device_id of_msm_restart_match[] = {
> +	{ .compatible = "qcom,pshold", },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, of_msm_restart_match);
> +
> +static struct platform_driver msm_restart_driver = {
> +	.probe = msm_restart_probe,
> +	.driver = {
> +		.name = "msm-restart",
> +		.of_match_table = of_match_ptr(of_msm_restart_match),
> +	},
> +};
> +
> +static int __init msm_restart_init(void)
> +{
> +	return platform_driver_register(&msm_restart_driver);
> +}
> +device_initcall(msm_restart_init);


