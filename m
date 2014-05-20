Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbaETVQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:16:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56908 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750699AbaETVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:16:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/4] ACPI / LPSS: custom power domain for LPSS
Date: Tue, 20 May 2014 23:33:09 +0200
Message-ID: <3202918.AHHS8JP9gx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400161226-24067-3-git-send-email-heikki.krogerus@linux.intel.com>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com> <1400161226-24067-3-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2014 04:40:24 PM Heikki Krogerus wrote:
> A power domain where we save the context of the additional
> LPSS registers. We need to do this or all LPSS devices are
> left in reset state when resuming from D3 on some Baytrails.
> The devices with the fractional clock divider also have
> zeros for N and M values after resuming unless they are
> reset.
> 
> Li Aubrey found the root cause for the issue. The idea of
> using power domain for LPSS came from Mika Westerberg.
> 
> Reported-by: Jin Yao <yao.jin@linux.intel.com>
> Suggested-by: Li Aubrey <aubrey.li@linux.intel.com>
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/acpi/acpi_lpss.c | 133 ++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 126 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 69e29f4..24e49a5 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -19,6 +19,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/clk-lpss.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/delay.h>
>  
>  #include "internal.h"
>  
> @@ -43,6 +44,8 @@ ACPI_MODULE_NAME("acpi_lpss");
>  #define LPSS_TX_INT			0x20
>  #define LPSS_TX_INT_MASK		BIT(1)
>  
> +#define LPSS_PRV_REG_COUNT		9
> +
>  struct lpss_shared_clock {
>  	const char *name;
>  	unsigned long rate;
> @@ -58,6 +61,7 @@ struct lpss_device_desc {
>  	unsigned int prv_offset;
>  	size_t prv_size_override;
>  	bool clk_gate;
> +	bool save_ctx;
>  	struct lpss_shared_clock *shared_clock;
>  	void (*setup)(struct lpss_private_data *pdata);
>  };
> @@ -72,6 +76,7 @@ struct lpss_private_data {
>  	resource_size_t mmio_size;
>  	struct clk *clk;
>  	const struct lpss_device_desc *dev_desc;
> +	u32 prv_reg_ctx[LPSS_PRV_REG_COUNT];
>  };
>  
>  static void lpss_uart_setup(struct lpss_private_data *pdata)
> @@ -116,6 +121,7 @@ static struct lpss_shared_clock pwm_clock = {
>  
>  static struct lpss_device_desc byt_pwm_dev_desc = {
>  	.clk_required = true,
> +	.save_ctx = true,
>  	.shared_clock = &pwm_clock,
>  };
>  
> @@ -128,6 +134,7 @@ static struct lpss_device_desc byt_uart_dev_desc = {
>  	.clk_required = true,
>  	.prv_offset = 0x800,
>  	.clk_gate = true,
> +	.save_ctx = true,
>  	.shared_clock = &uart_clock,
>  	.setup = lpss_uart_setup,
>  };
> @@ -141,6 +148,7 @@ static struct lpss_device_desc byt_spi_dev_desc = {
>  	.clk_required = true,
>  	.prv_offset = 0x400,
>  	.clk_gate = true,
> +	.save_ctx = true,
>  	.shared_clock = &spi_clock,
>  };
>  
> @@ -156,6 +164,7 @@ static struct lpss_shared_clock i2c_clock = {
>  static struct lpss_device_desc byt_i2c_dev_desc = {
>  	.clk_required = true,
>  	.prv_offset = 0x800,
> +	.save_ctx = true,
>  	.shared_clock = &i2c_clock,
>  };
>  
> @@ -449,6 +458,102 @@ static void acpi_lpss_set_ltr(struct device *dev, s32 val)
>  	}
>  }
>  
> +#ifdef CONFIG_PM

It would be good to add a kerneldoc explaining what's being saved here and why.

> +static void acpi_lpss_save_ctx(struct device *dev)
> +{
> +	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
> +	int i;
> +
> +	for (i = 0; i < LPSS_PRV_REG_COUNT; i++) {
> +		pdata->prv_reg_ctx[i] = __lpss_reg_read(pdata, i * sizeof(u32));
> +		dev_dbg(dev, "saving 0x%08x from LPSS reg at offset 0x%02x\n",
> +			pdata->prv_reg_ctx[i], (unsigned int)(i * sizeof(u32)));
> +	}
> +}
> +
> +static void acpi_lpss_restore_ctx(struct device *dev)
> +{
> +	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
> +	int i;
> +
> +	/* PCI spec expects 10ms delay when resuming from D3 to D0 */
> +	msleep(10);

Two questions here.

First, is the 10 ms sleep really necessary?  I'd expect the AML to take care of
such delays (this is not a PCI device formally).

And because this is not a PCI device formally, why is the comment talking about
the PCI spec?  Why is PCI relevant in any way here?

> +
> +	for (i = 0; i < LPSS_PRV_REG_COUNT; i++) {
> +		__lpss_reg_write(pdata->prv_reg_ctx[i], pdata, i * sizeof(u32));
> +		dev_dbg(dev, "restoring 0x%08x to LPSS reg at offset 0x%02x\n",
> +			pdata->prv_reg_ctx[i], (unsigned int)(i * sizeof(u32)));
> +	}
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int acpi_lpss_suspend_late(struct device *dev)
> +{
> +	int ret = pm_generic_suspend_late(dev);
> +
> +	if (ret)
> +		return ret;
> +
> +	acpi_lpss_save_ctx(dev);
> +	return acpi_dev_suspend_late(dev);
> +}
> +
> +static int acpi_lpss_restore_early(struct device *dev)
> +{
> +	int ret = acpi_dev_resume_early(dev);
> +
> +	if (ret)
> +		return ret;
> +
> +	acpi_lpss_restore_ctx(dev);
> +	return pm_generic_resume_early(dev);
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +#ifdef CONFIG_PM_RUNTIME
> +static int acpi_lpss_runtime_suspend(struct device *dev)
> +{
> +	int ret = pm_generic_runtime_suspend(dev);
> +
> +	if (ret)
> +		return ret;
> +
> +	acpi_lpss_save_ctx(dev);
> +	return acpi_dev_runtime_suspend(dev);
> +}
> +
> +static int acpi_lpss_runtime_resume(struct device *dev)
> +{
> +	int ret = acpi_dev_runtime_resume(dev);
> +
> +	if (ret)
> +		return ret;
> +
> +	acpi_lpss_restore_ctx(dev);
> +	return pm_generic_runtime_resume(dev);
> +}
> +#endif /* CONFIG_PM_RUNTIME */
> +#endif /* CONFIG_PM */
> +
> +static struct dev_pm_domain acpi_lpss_pm_domain = {
> +	.ops = {
> +#ifdef CONFIG_PM_SLEEP
> +		.suspend_late = acpi_lpss_suspend_late,
> +		.restore_early = acpi_lpss_restore_early,
> +		.prepare = acpi_subsys_prepare,
> +		.suspend = acpi_subsys_suspend,
> +		.resume_early = acpi_subsys_resume_early,
> +		.freeze = acpi_subsys_freeze,
> +		.poweroff = acpi_subsys_suspend,
> +		.poweroff_late = acpi_subsys_suspend_late,
> +#endif
> +#ifdef CONFIG_PM_RUNTIME
> +		.runtime_suspend = acpi_lpss_runtime_suspend,
> +		.runtime_resume = acpi_lpss_runtime_resume,
> +#endif
> +	},
> +};
> +
>  static int acpi_lpss_platform_notify(struct notifier_block *nb,
>  				     unsigned long action, void *data)
>  {
> @@ -456,7 +561,6 @@ static int acpi_lpss_platform_notify(struct notifier_block *nb,
>  	struct lpss_private_data *pdata;
>  	struct acpi_device *adev;
>  	const struct acpi_device_id *id;
> -	int ret = 0;
>  
>  	id = acpi_match_device(acpi_lpss_device_ids, &pdev->dev);
>  	if (!id || !id->driver_data)
> @@ -466,7 +570,7 @@ static int acpi_lpss_platform_notify(struct notifier_block *nb,
>  		return 0;
>  
>  	pdata = acpi_driver_data(adev);
> -	if (!pdata || !pdata->mmio_base || !pdata->dev_desc->ltr_required)
> +	if (!pdata || !pdata->mmio_base)
>  		return 0;
>  
>  	if (pdata->mmio_size < pdata->dev_desc->prv_offset + LPSS_LTR_SIZE) {
> @@ -474,12 +578,27 @@ static int acpi_lpss_platform_notify(struct notifier_block *nb,
>  		return 0;
>  	}
>  
> -	if (action == BUS_NOTIFY_ADD_DEVICE)
> -		ret = sysfs_create_group(&pdev->dev.kobj, &lpss_attr_group);
> -	else if (action == BUS_NOTIFY_DEL_DEVICE)
> -		sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
> +	switch (action) {
> +	case BUS_NOTIFY_BOUND_DRIVER:
> +		if (pdata->dev_desc->save_ctx)
> +			pdev->dev.pm_domain = &acpi_lpss_pm_domain;
> +		break;
> +	case BUS_NOTIFY_UNBOUND_DRIVER:
> +		if (pdata->dev_desc->save_ctx)
> +			pdev->dev.pm_domain = NULL;
> +		break;
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		if (pdata->dev_desc->ltr_required)
> +			return sysfs_create_group(&pdev->dev.kobj,
> +						  &lpss_attr_group);
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		if (pdata->dev_desc->ltr_required)
> +			sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
> +	default:
> +		break;
> +	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static struct notifier_block acpi_lpss_nb = {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
