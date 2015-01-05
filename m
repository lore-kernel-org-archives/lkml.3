Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbbAEUKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:10:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41017 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbbAEUKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:10:42 -0500
Message-ID: <54AAEFA6.3080603@ti.com>
Date: Mon, 5 Jan 2015 14:10:14 -0600
From: Dave Gerlach <d-gerlach@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/3] remoteproc: wkup_m3: Add wkup_m3 remote proc driver
References: <1420228319-41085-1-git-send-email-d-gerlach@ti.com> <1420228319-41085-4-git-send-email-d-gerlach@ti.com> <20150102200424.GD4920@saruman>
In-Reply-To: <20150102200424.GD4920@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,
On 01/02/2015 02:04 PM, Felipe Balbi wrote:
> On Fri, Jan 02, 2015 at 01:51:59PM -0600, Dave Gerlach wrote:
>> Add a remoteproc driver to load the firmware for and boot the wkup_m3
>> present on am33xx. The wkup_m3 is an integrated Cortex M3 that allows
>> the SoC to enter the lowest possible power state by taking control from
>> the MPU after it has gone into its own low power state and shutting off
>> any additional peripherals.
>>
>> The driver expects a resource table to be present in the wkup_m3
>> firmware to define the required memory resources needed by the wkup_m3,
>> at least the data memory so that the firmware can be copied to the proper
>> place for execution.
>>
>> Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
>> ---
>>  drivers/remoteproc/Kconfig         |  12 +++
>>  drivers/remoteproc/Makefile        |   1 +
>>  drivers/remoteproc/wkup_m3_rproc.c | 175 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 188 insertions(+)
>>  create mode 100644 drivers/remoteproc/wkup_m3_rproc.c
>>
>> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
>> index 5e343ba..7fbdb53 100644
>> --- a/drivers/remoteproc/Kconfig
>> +++ b/drivers/remoteproc/Kconfig
>> @@ -41,6 +41,18 @@ config STE_MODEM_RPROC
>>  	  This can be either built-in or a loadable module.
>>  	  If unsure say N.
>>  
>> +config WKUP_M3_RPROC
>> +	bool "AM33xx wkup-m3 remoteproc support"
> 
> it would be nicer if this could be a loadable module.

Do we really want that though? This is required for core PM functionality like
CPUIdle and Suspend/resume, I feel that it should always be built in for am335x.
I had been taking this approach with all of the PM dependencies.

> 
>> +	depends on SOC_AM33XX
>> +	select REMOTEPROC
>> +	help
>> +	  Say y here to support AM33xx wkup-m3.
>> +
>> +	  Required for Suspend-to-ram and CPUIdle on AM33xx. Allows for
>> +	  loading of firmware of CM3 PM coprocessor that is present
>> +	  on AM33xx family of SoCs
>> +	  If unsure say N.
>> +
>>  config DA8XX_REMOTEPROC
>>  	tristate "DA8xx/OMAP-L13x remoteproc support"
>>  	depends on ARCH_DAVINCI_DA8XX
>> diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
>> index ac2ff75..81b04d1 100644
>> --- a/drivers/remoteproc/Makefile
>> +++ b/drivers/remoteproc/Makefile
>> @@ -9,4 +9,5 @@ remoteproc-y				+= remoteproc_virtio.o
>>  remoteproc-y				+= remoteproc_elf_loader.o
>>  obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
>>  obj-$(CONFIG_STE_MODEM_RPROC)	 	+= ste_modem_rproc.o
>> +obj-$(CONFIG_WKUP_M3_RPROC)		+= wkup_m3_rproc.o
>>  obj-$(CONFIG_DA8XX_REMOTEPROC)		+= da8xx_remoteproc.o
>> diff --git a/drivers/remoteproc/wkup_m3_rproc.c b/drivers/remoteproc/wkup_m3_rproc.c
>> new file mode 100644
>> index 0000000..8686ca2
>> --- /dev/null
>> +++ b/drivers/remoteproc/wkup_m3_rproc.c
>> @@ -0,0 +1,175 @@
>> +/*
>> + * AMx3 Wkup M3 Remote Processor driver
>> + *
>> + * Copyright (C) 2014 Texas Instruments, Inc.
>> + *
>> + * Dave Gerlach <d-gerlach@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/kernel.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/of_device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/remoteproc.h>
>> +
>> +#include <linux/platform_data/wkup_m3.h>
>> +
>> +#include "remoteproc_internal.h"
>> +
>> +struct wkup_m3_rproc {
>> +	struct rproc *rproc;
>> +	struct platform_device *pdev;
>> +};
>> +
>> +static int wkup_m3_rproc_start(struct rproc *rproc)
>> +{
>> +	struct wkup_m3_rproc *m3_rproc = rproc->priv;
>> +	struct platform_device *pdev = m3_rproc->pdev;
>> +	struct device *dev = &pdev->dev;
>> +	struct wkup_m3_platform_data *pdata = dev->platform_data;
>> +	int ret;
>> +
>> +	ret = pdata->deassert_reset(pdev, pdata->reset_name);
> 
> looks like here you should assert, wait, deassert. What if soemthing
> else used wkup_m3 before this loads ?
> 

Hmm, that's unlikely but not impossible, and if the wkup_m3 is not properly
reset after firmware loading it won't boot, which kills all PM on am335x. I'll
look into doing that.

>> +	if (ret) {
>> +		dev_err(dev, "Unable to reset wkup_m3!\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int wkup_m3_rproc_stop(struct rproc *rproc)
>> +{
>> +	struct wkup_m3_rproc *m3_rproc = rproc->priv;
>> +	struct platform_device *pdev = m3_rproc->pdev;
>> +	struct device *dev = &pdev->dev;
>> +	struct wkup_m3_platform_data *pdata = dev->platform_data;
>> +	int ret;
>> +
>> +	ret = pdata->assert_reset(pdev, pdata->reset_name);
>> +	if (ret) {
>> +		dev_err(dev, "Unable to assert reset of wkup_m3!\n");
>> +		return -ENODEV;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static struct rproc_ops wkup_m3_rproc_ops = {
>> +	.start		= wkup_m3_rproc_start,
>> +	.stop		= wkup_m3_rproc_stop,
>> +};
>> +
>> +static const struct of_device_id wkup_m3_rproc_of_match[] = {
>> +	{
>> +		.compatible = "ti,am3353-wkup-m3",
>> +		.data = (void *)"am335x-pm-firmware.elf",
> 
> do you know of anybody else who might want to different firmware image
> name ? Otherwise why pass it as driver_data ?

I suppose we could pass the name in the devicetree. I do not know of any other
users of other firmware but it's probably better to keep things flexible.

> 
>> +	},
>> +	{},
>> +};
>> +
>> +static int wkup_m3_rproc_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	const char *fw_name;
>> +	struct wkup_m3_platform_data *pdata = dev->platform_data;
>> +	struct wkup_m3_rproc *m3_rproc;
>> +	const struct of_device_id *match;
>> +	struct rproc *rproc;
>> +	int ret;
>> +
>> +	if (!(pdata && pdata->deassert_reset && pdata->assert_reset &&
>> +	      pdata->reset_name)) {
>> +		dev_err(dev, "Platform data missing!\n");
>> +		return -ENODEV;
>> +	}
> 
> if pdata is missing, couldn't you assume the thing has been reset and
> try to load anyway ?

Probably not, we MUST reset after loading the firmware as that is what boots the
wkup_m3.

> 
>> +	match = of_match_device(wkup_m3_rproc_of_match, &pdev->dev);
>> +	if (!match)
>> +		return -ENODEV;
>> +	fw_name = (char *)match->data;
>> +
>> +	pm_runtime_enable(&pdev->dev);
>> +
>> +	ret = pm_runtime_get_sync(&pdev->dev);
>> +	if (IS_ERR_VALUE(ret)) {
>> +		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
>> +		return ret;
> 
> this is wrong for two reasons:
> 
> a) you need to pm_runtime_disable();
> b) even if pm_runtime_get*() fails, you _must_ call
> 	pm_runtime_put_sync();

Ok I will fix this and the following pm_runtime issues. Didn't realize you still
had to call put_sync after a failed get_sync.

> 
>> +	}
>> +
>> +	rproc = rproc_alloc(dev, "wkup_m3", &wkup_m3_rproc_ops,
>> +			    fw_name, sizeof(*m3_rproc));
>> +	if (!rproc)
>> +		return -ENOMEM;
>> +
>> +	m3_rproc = rproc->priv;
>> +	m3_rproc->rproc = rproc;
>> +	m3_rproc->pdev = pdev;
>> +
>> +	dev_set_drvdata(dev, rproc);
>> +
>> +	/* Register as a remoteproc device */
>> +	ret = rproc_add(rproc);
>> +	if (ret) {
>> +		dev_err(dev, "rproc_add failed\n");
>> +		goto err;
>> +	}
>> +
>> +	return 0;
>> +
>> +err:
>> +	rproc_put(rproc);
>> +	pm_runtime_put_sync(&pdev->dev);
> 
> missing pm_runtime_disable();
> 
>> +	return ret;
>> +}
>> +
>> +static int wkup_m3_rproc_remove(struct platform_device *pdev)
>> +{
>> +	struct rproc *rproc = platform_get_drvdata(pdev);
>> +
>> +	rproc_del(rproc);
>> +	rproc_put(rproc);
>> +	pm_runtime_put_sync(&pdev->dev);
> 
> missing pm_runtime_disable();
> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int wkup_m3_rpm_suspend(struct device *dev)
>> +{
>> +	return -EBUSY;
>> +}
> 
> looks like this is just coping with omap_device bogosity, no ?
>

Yes, without this omap_device shuts down ther wkup_m3 during suspend, which of
course prevents the wkup_m3 from finishing suspend process or waking SoC back
up. Haven't found a better solution for the problem than this.

>> +
>> +static int wkup_m3_rpm_resume(struct device *dev)
>> +{
>> +	return 0;
>> +}
>> +
>> +static const struct dev_pm_ops wkup_m3_rproc_pm_ops = {
>> +	SET_RUNTIME_PM_OPS(wkup_m3_rpm_suspend, wkup_m3_rpm_resume, NULL)
>> +};
>> +
>> +static struct platform_driver wkup_m3_rproc_driver = {
>> +	.probe = wkup_m3_rproc_probe,
>> +	.remove = wkup_m3_rproc_remove,
>> +	.driver = {
>> +		.name = "wkup_m3",
>> +		.of_match_table = wkup_m3_rproc_of_match,
>> +		.pm = &wkup_m3_rproc_pm_ops,
>> +	},
>> +};
>> +
>> +module_platform_driver(wkup_m3_rproc_driver);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_DESCRIPTION("wkup m3 remote processor control driver");
> 
> do you want to add MODULE_AUTHOR() ?
> 

Yes. Thanks for the comments.

Regards,
Dave

