Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaJADMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 23:12:22 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:49131 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJADMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 23:12:20 -0400
Message-ID: <542B70D4.8040001@roeck-us.net>
Date: Tue, 30 Sep 2014 20:11:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Feng Kan <fkan@apm.com>, dbaryshkov@gmail.com, catalin.marinas@arm.com,
        dwmw2@infradead.org, arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com, linux-pm@vger.kernel.org, will.deacon@arm.com
Subject: Re: [PATCH RESEND V9 1/6] power: reset: Add generic SYSCON register
 mapped reset
References: <1412119508-22864-1-git-send-email-fkan@apm.com> <1412119508-22864-2-git-send-email-fkan@apm.com>
In-Reply-To: <1412119508-22864-2-git-send-email-fkan@apm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.542B7114.0077,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 04:25 PM, Feng Kan wrote:
> Add a generic SYSCON register mapped reset mechanism.
>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>   drivers/power/reset/Kconfig         |  5 ++
>   drivers/power/reset/Makefile        |  1 +
>   drivers/power/reset/syscon-reboot.c | 96 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 102 insertions(+)
>   create mode 100644 drivers/power/reset/syscon-reboot.c
>
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index 1915dde..a863fa1 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -143,4 +143,9 @@ config POWER_RESET_KEYSTONE
>   	help
>   	  Reboot support for the KEYSTONE SoCs.
>
> +config POWER_RESET_SYSCON
> +	bool "Generic SYSCON regmap reset driver"
> +	depends on POWER_RESET && MFD_SYSCON && OF

Other drivers have
	select MFD_SYSCON

> +	help
> +	  Reboot support for generic SYSCON mapped register reset.
>   endif
> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> index 01e401d..76ce1c5 100644
> --- a/drivers/power/reset/Makefile
> +++ b/drivers/power/reset/Makefile
> @@ -16,3 +16,4 @@ obj-$(CONFIG_POWER_RESET_VERSATILE) += arm-versatile-reboot.o
>   obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
>   obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
>   obj-$(CONFIG_POWER_RESET_KEYSTONE) += keystone-reset.o
> +obj-$(CONFIG_POWER_RESET_SYSCON) += syscon-reboot.o
> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
> new file mode 100644
> index 0000000..948e0ee
> --- /dev/null
> +++ b/drivers/power/reset/syscon-reboot.c
> @@ -0,0 +1,96 @@
> +/*
> + * Generic Syscon Reboot Driver
> + *
> + * Copyright (c) 2013, Applied Micro Circuits Corporation
> + * Author: Feng Kan <fkan@apm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/io.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/notifier.h>

alphabetic order of include files ?

> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +#include <linux/reboot.h>
> +
> +struct syscon_reboot_context {
> +	struct regmap *map;
> +	u32 offset;
> +	u32 mask;
> +	struct notifier_block restart_handler;
> +};
> +
> +static struct syscon_reboot_context *syscon_reboot_ctx;
> +
> +static int syscon_restart_handle(struct notifier_block *this,
> +					unsigned long mode, void *cmd)
> +{
> +	struct syscon_reboot_context *ctx = syscon_reboot_ctx;

Since restart_handler is part of syscon_reboot_context, you
do not need a static variable. You can use
	struct syscon_reboot_context *ctx = container_of(ctx, struct syscon_reboot_context, restart_handler);
instead.

> +	unsigned long timeout;
> +
> +	/* Issue the reboot */
> +	if (ctx->map)
> +		regmap_write(ctx->map, ctx->offset, ctx->mask);
> +
The check for ctx->map is not needed. If the restart handler is installed,
it will always be valid.

> +	timeout = jiffies + HZ;
> +	while (time_before(jiffies, timeout))
> +		cpu_relax();
> +
jiffies won't work here, and nothing else is expected to happen.
Just use mdelay(1000);

> +	pr_emerg("Unable to restart system\n");
> +	return NOTIFY_DONE;
> +}
> +
> +static int syscon_reboot_probe(struct platform_device *pdev)
> +{
> +	struct syscon_reboot_context *ctx;
> +	struct device *dev = &pdev->dev;
> +	int err;
> +
> +	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->map = syscon_regmap_lookup_by_phandle(dev->of_node, "regmap");
> +	if (IS_ERR(ctx->map))
> +		return PTR_ERR(ctx->map);
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "offset", &ctx->offset))
> +		return -EINVAL;
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
> +		return -EINVAL;
> +
> +	ctx->restart_handler.notifier_call = syscon_restart_handle;
> +	ctx->restart_handler.priority = 128;
> +	err = register_restart_handler(&ctx->restart_handler);
> +	if (err)
> +		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
> +
> +	syscon_reboot_ctx = ctx;
> +
> +	return 0;
> +}
> +
> +static struct of_device_id syscon_reboot_of_match[] = {
> +	{ .compatible = "syscon-reboot" },
> +	{}
> +};
> +
> +static struct platform_driver syscon_reboot_driver = {
> +	.probe = syscon_reboot_probe,
> +	.driver = {
> +		.name = "syscon-reboot",
> +		.of_match_table = syscon_reboot_of_match,
> +	},
> +};
> +module_platform_driver(syscon_reboot_driver);
>

