Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbaFZQvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:51:17 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:45605 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756813AbaFZQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAGb2v65mGXDGb8Y045kehKufpMZWnfBm4dBJarJeOa8j-3g0RQ@mail.gmail.com>
References: <1403737406-6474-1-git-send-email-fkan@apm.com>
	<1403737406-6474-2-git-send-email-fkan@apm.com>
	<CAGb2v65mGXDGb8Y045kehKufpMZWnfBm4dBJarJeOa8j-3g0RQ@mail.gmail.com>
Date: Thu, 26 Jun 2014 09:51:14 -0700
Message-ID: <CAL85gmCOzaT+dJf9e8Uj-w3v1nq8Qjg-EXfWDN5kdrU2k=kHJQ@mail.gmail.com>
Subject: Re: [PATCH V7 1/6] power: reset: Add generic SYSCON register mapped reset
From: Feng Kan <fkan@apm.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: dbaryshkov <dbaryshkov@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>, dwmw2 <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, patches <patches@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 6:38 PM, Chen-Yu Tsai <wens@csie.org> wrote:
> On Thu, Jun 26, 2014 at 7:03 AM, Feng Kan <fkan@apm.com> wrote:
>> Add a generic SYSCON register mapped reset mechanism.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>  drivers/power/reset/Kconfig         |  6 +++
>>  drivers/power/reset/Makefile        |  1 +
>>  drivers/power/reset/syscon-reboot.c | 91 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 98 insertions(+)
>>  create mode 100644 drivers/power/reset/syscon-reboot.c
>>
>> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
>> index bdcf517..7035236 100644
>> --- a/drivers/power/reset/Kconfig
>> +++ b/drivers/power/reset/Kconfig
>> @@ -80,3 +80,9 @@ config POWER_RESET_KEYSTONE
>>         help
>>           Reboot support for the KEYSTONE SoCs.
>>
>> +config POWER_RESET_SYSCON
>> +       bool "Generic SYSCON regmap reset driver"
>> +       depends on ARCH_XGENE
>
> If this is supposed to be generic, why are you depending on
> a certain platform?

Yes, the problem was that it was breaking the x86 build.

>
>
> ChenYu
>
>> +       depends on POWER_RESET && MFD_SYSCON
>> +       help
>> +         Reboot support for generic SYSCON mapped register reset.
>> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
>> index dde2e8b..b1b5ab3 100644
>> --- a/drivers/power/reset/Makefile
>> +++ b/drivers/power/reset/Makefile
>> @@ -8,3 +8,4 @@ obj-$(CONFIG_POWER_RESET_SUN6I) += sun6i-reboot.o
>>  obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
>>  obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
>>  obj-$(CONFIG_POWER_RESET_KEYSTONE) += keystone-reset.o
>> +obj-$(CONFIG_POWER_RESET_SYSCON) += syscon-reboot.o
>> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
>> new file mode 100644
>> index 0000000..9c15ba5
>> --- /dev/null
>> +++ b/drivers/power/reset/syscon-reboot.c
>> @@ -0,0 +1,91 @@
>> +/*
>> + * Generic Syscon Reboot Driver
>> + *
>> + * Copyright (c) 2013, Applied Micro Circuits Corporation
>> + * Author: Feng Kan <fkan@apm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation; either version 2 of
>> + * the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <linux/io.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/stat.h>
>> +#include <linux/slab.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
>> +#include <linux/reboot.h>
>> +#include <asm/system_misc.h>
>> +
>> +struct syscon_reboot_context {
>> +       struct regmap *map;
>> +       u32 offset;
>> +       u32 mask;
>> +};
>> +
>> +static struct syscon_reboot_context *syscon_reboot_ctx;
>> +
>> +static void syscon_restart(enum reboot_mode reboot_mode, const char *cmd)
>> +{
>> +       struct syscon_reboot_context *ctx = syscon_reboot_ctx;
>> +       unsigned long timeout;
>> +
>> +       /* Issue the reboot */
>> +       if (ctx->map)
>> +               regmap_write(ctx->map, ctx->offset, ctx->mask);
>> +
>> +       timeout = jiffies + HZ;
>> +       while (time_before(jiffies, timeout))
>> +               cpu_relax();
>> +
>> +       pr_emerg("Unable to restart system\n");
>> +}
>> +
>> +static int syscon_reboot_probe(struct platform_device *pdev)
>> +{
>> +       struct syscon_reboot_context *ctx;
>> +       struct device *dev = &pdev->dev;
>> +
>> +       ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
>> +       if (!ctx) {
>> +               dev_err(&pdev->dev, "out of memory for context\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       ctx->map = syscon_regmap_lookup_by_phandle(dev->of_node, "regmap");
>> +       if (IS_ERR(ctx->map))
>> +               return PTR_ERR(ctx->map);
>> +
>> +       if (of_property_read_u32(pdev->dev.of_node, "offset", &ctx->offset))
>> +               return -EINVAL;
>> +
>> +       if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
>> +               return -EINVAL;
>> +
>> +       arm_pm_restart = syscon_restart;
>> +       syscon_reboot_ctx = ctx;
>> +
>> +       return 0;
>> +}
>> +
>> +static struct of_device_id syscon_reboot_of_match[] = {
>> +       { .compatible = "syscon-reboot" },
>> +       {}
>> +};
>> +
>> +static struct platform_driver syscon_reboot_driver = {
>> +       .probe = syscon_reboot_probe,
>> +       .driver = {
>> +               .name = "syscon-reboot",
>> +               .of_match_table = syscon_reboot_of_match,
>> +       },
>> +};
>> +module_platform_driver(syscon_reboot_driver);
>> --
>> 1.9.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
