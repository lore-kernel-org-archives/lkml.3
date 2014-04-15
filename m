Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaDOTCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:02:00 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45662 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaDOTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:01:56 -0400
Date: Tue, 15 Apr 2014 12:01:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        Eric Ernst <eric.ernst@intel.com>
Subject: Re: [PATCH v3 1/2] watchdog: add Intel MID watchdog driver support
Message-ID: <20140415190149.GA7940@roeck-us.net>
References: <1397249407-5417-1-git-send-email-david.a.cohen@linux.intel.com>
 <1397587272-31152-1-git-send-email-david.a.cohen@linux.intel.com>
 <1397587272-31152-2-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397587272-31152-2-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:41:11AM -0700, David Cohen wrote:
> Add initial Intel MID watchdog driver support.
> 
> This driver is an initial implementation of generic Intel MID watchdog
> driver. Currently it supports Intel Merrifield platform.
> 
> Signed-off-by: Eric Ernst <eric.ernst@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/watchdog/Kconfig         |  13 +++
>  drivers/watchdog/Makefile        |   1 +
>  drivers/watchdog/intel-mid_wdt.c | 187 +++++++++++++++++++++++++++++++++++++++
>  include/linux/intel-mid_wdt.h    |  20 +++++

include/linux/platform_data/intel-mid_wdt.h ?

>  4 files changed, 221 insertions(+)
>  create mode 100644 drivers/watchdog/intel-mid_wdt.c
>  create mode 100644 include/linux/intel-mid_wdt.h
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 79d25894343a..0e110c37aa5c 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -643,6 +643,19 @@ config INTEL_SCU_WATCHDOG
>  
>  	  To compile this driver as a module, choose M here.
>  
> +config INTEL_MID_WATCHDOG
> +	tristate "Intel MID Watchdog Timer"
> +	depends on X86_INTEL_MID
> +	select WATCHDOG_CORE
> +	---help---
> +	  Watchdog timer driver built into the Intel SCU for Intel MID
> +	  Platforms.
> +
> +	  This driver currently supports only the watchdog evolution
> +	  implementation in SCU, available for Merrifield generation.
> +
> +	  To compile this driver as a module, choose M here.
> +
>  config ITCO_WDT
>  	tristate "Intel TCO Timer/Watchdog"
>  	depends on (X86 || IA64) && PCI
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 985a66cda76f..b927e7496eb4 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -113,6 +113,7 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
>  obj-$(CONFIG_MACHZ_WDT) += machzwd.o
>  obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
>  obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
> +obj-$(CONFIG_INTEL_MID_WATCHDOG) += intel-mid_wdt.o
>  
>  # M32R Architecture
>  
> diff --git a/drivers/watchdog/intel-mid_wdt.c b/drivers/watchdog/intel-mid_wdt.c
> new file mode 100644
> index 000000000000..d8bf3c3cd2b7
> --- /dev/null
> +++ b/drivers/watchdog/intel-mid_wdt.c
> @@ -0,0 +1,187 @@
> +/*
> + *      intel-mid_wdt: generic Intel MID SCU watchdog driver
> + *
> + *      Platforms supported so far:
> + *      - Merrifield only
> + *
> + *      Copyright (C) 2014 Intel Corporation. All rights reserved.
> + *      Contact: David Cohen <david.a.cohen@linux.intel.com>
> + *
> + *      This program is free software; you can redistribute it and/or
> + *      modify it under the terms of version 2 of the GNU General
> + *      Public License as published by the Free Software Foundation.
> + */
> +
> +#include <linux/intel-mid_wdt.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/nmi.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +
> +#include <asm/intel_scu_ipc.h>
> +#include <asm/intel-mid.h>
> +
> +#define IPC_WATCHDOG 0xf8
> +
> +#define MID_WDT_PRETIMEOUT		15
> +#define MID_WDT_TIMEOUT_MIN		(1 + MID_WDT_PRETIMEOUT)
> +#define MID_WDT_TIMEOUT_MAX		170
> +#define MID_WDT_DEFAULT_TIMEOUT		90
> +
> +/* SCU watchdog messages */
> +enum {
> +	SCU_WATCHDOG_START = 0,
> +	SCU_WATCHDOG_STOP,
> +	SCU_WATCHDOG_KEEPALIVE,
> +};
> +
> +static inline int wdt_command(int sub, u32 *in, int inlen)
> +{
> +	return intel_scu_ipc_command(IPC_WATCHDOG, sub, in, inlen, NULL, 0);
> +}
> +
> +static int wdt_start(struct watchdog_device *wd)
> +{
> +	int ret, in_size;
> +	int timeout = wd->timeout;
> +	struct ipc_wd_start {
> +		u32 pretimeout;
> +		u32 timeout;
> +	} ipc_wd_start = { timeout - MID_WDT_PRETIMEOUT, timeout };
> +
> +	/*
> +	 * SCU expects the input size for watchdog IPC to
> +	 * be based on double-word
> +	 */
> +	in_size = (sizeof(ipc_wd_start) + 3) / 4;
> +
DIV_ROUND_UP ?

Not sure how "double-word" matches the calculation. What is a "double-word" ?
4 bytes ?

> +	ret = wdt_command(SCU_WATCHDOG_START, (u32 *)&ipc_wd_start, in_size);
> +	if (ret) {
> +		struct device *dev = watchdog_get_drvdata(wd);
> +		dev_crit(dev, "error starting watchdog: %d\n", ret);
> +		return -EIO;

I am quite sure sparse is going to complain about this ...
Why not just return ret ? This would result in a more detailed
error code/reason.

> +	}
> +
> +	return 0;
> +}
> +
> +static int wdt_ping(struct watchdog_device *wd)
> +{
> +	int ret;
> +
> +	ret = wdt_command(SCU_WATCHDOG_KEEPALIVE, NULL, 0);
> +	if (ret) {
> +		struct device *dev = watchdog_get_drvdata(wd);
> +		dev_crit(dev, "Error executing keepalive: 0x%x\n", ret);
> +		return -EIO;

Same here.

> +	}
> +
> +	return 0;
> +}
> +
> +static int wdt_stop(struct watchdog_device *wd)
> +{
> +	int ret;
> +
> +	ret = wdt_command(SCU_WATCHDOG_STOP, NULL, 0);
> +	if (ret) {
> +		struct device *dev = watchdog_get_drvdata(wd);
> +		dev_crit(dev, "Error stopping watchdog: 0x%x\n", ret);
> +		return -EIO;

Same here.

> +	}
> +
> +	return 0;
> +}
> +
> +static irqreturn_t mid_wdt_warning_irq(int irq, void *dev_id)

This isn't really a warning, so the function name is a bit misleading.

> +{
> +	panic("Kernel Watchdog");
> +
> +	/* This code should not be reached */
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct watchdog_info mid_wdt_info = {
> +	.identity = "Intel MID SCU watchdog",
> +	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
> +};
> +
> +static const struct watchdog_ops mid_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = wdt_start,
> +	.stop = wdt_stop,
> +	.ping = wdt_ping,
> +};
> +
> +static int mid_wdt_probe(struct platform_device *pdev)
> +{
> +	struct watchdog_device *wdt_dev;
> +	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
> +	int ret;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "missing platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (pdata->probe) {
> +		ret = pdata->probe();

Sure you don't want to pass the platform device as parameter ?
May not be needed today, but it might be better than to rely on the assumption
that the called code gets it from a static variable or structure (if needed).

This would enable you, for example, to use dev_warn() instead of pr_warn()
in the platform code.

> +		if (ret)
> +			return ret;
> +	}
> +
> +	wdt_dev = devm_kzalloc(&pdev->dev, sizeof(*wdt_dev), GFP_KERNEL);
> +	if (!wdt_dev)
> +		return -ENOMEM;
> +
> +	wdt_dev->info = &mid_wdt_info;
> +	wdt_dev->ops = &mid_wdt_ops;
> +	wdt_dev->min_timeout = MID_WDT_TIMEOUT_MIN;
> +	wdt_dev->max_timeout = MID_WDT_TIMEOUT_MAX;
> +	wdt_dev->timeout = MID_WDT_DEFAULT_TIMEOUT;
> +
> +	watchdog_set_drvdata(wdt_dev, &pdev->dev);
> +	platform_set_drvdata(pdev, wdt_dev);
> +
> +	ret = devm_request_irq(&pdev->dev, pdata->irq, mid_wdt_warning_irq,
> +			       IRQF_SHARED | IRQF_NO_SUSPEND, "watchdog",
> +			       wdt_dev);

If irq is mandatory, it might make sense to check if it is valid.

> +	if (ret) {
> +		dev_err(&pdev->dev, "error requesting warning irq %d\n",
> +			pdata->irq);
> +		return ret;
> +	}
> +
> +	ret = watchdog_register_device(wdt_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "error registering watchdog device\n");
> +		return ret;
> +	}
> +
> +	dev_info(&pdev->dev, "Intel MID watchdog device probed\n");
> +
> +	return 0;
> +}
> +
> +static int mid_wdt_remove(struct platform_device *pdev)
> +{
> +	struct watchdog_device *wd = platform_get_drvdata(pdev);
> +	watchdog_unregister_device(wd);
> +	return 0;
> +}
> +
> +static struct platform_driver mid_wdt_driver = {
> +	.probe		= mid_wdt_probe,
> +	.remove		= mid_wdt_remove,
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= "intel_mid_wdt",
> +	},
> +};
> +
> +module_platform_driver(mid_wdt_driver);
> +
> +MODULE_AUTHOR("David Cohen <david.a.cohen@linux.intel.com>");
> +MODULE_DESCRIPTION("Watchdog Driver for Intel MID platform");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/intel-mid_wdt.h b/include/linux/intel-mid_wdt.h
> new file mode 100644
> index 000000000000..705dff1c62f8
> --- /dev/null
> +++ b/include/linux/intel-mid_wdt.h
> @@ -0,0 +1,20 @@
> +/*
> + *      intel-mid_wdt: generic Intel MID SCU watchdog driver
> + *
> + *      Copyright (C) 2014 Intel Corporation. All rights reserved.
> + *      Contact: David Cohen <david.a.cohen@linux.intel.com>
> + *
> + *      This program is free software; you can redistribute it and/or
> + *      modify it under the terms of version 2 of the GNU General
> + *      Public License as published by the Free Software Foundation.
> + */
> +
> +#ifndef __INTEL_MID_WDT_H__
> +#define __INTEL_MID_WDT_H__
> +
> +struct intel_mid_wdt_pdata {
> +	int irq;
> +	int (*probe)(void);
> +};
> +
> +#endif /*__INTEL_MID_WDT_H__*/
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
