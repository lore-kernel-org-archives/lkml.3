Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936486Ab3DIL6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:58:30 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62839 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761639Ab3DIL62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:58:28 -0400
Date: Tue, 9 Apr 2013 12:58:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] mfd: db8500-prcmu: Support platform dependant device
 selection
Message-ID: <20130409115823.GD25316@gmail.com>
References: <1365071941-23475-1-git-send-email-lee.jones@linaro.org>
 <1365071941-23475-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365071941-23475-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Apr 2013, Lee Jones wrote:

> The main aim for this cycle is to have the u8540 booting to a
> console. However, the u8540 doesn't support all of the u8500
> platform devices yet. After this stage is complete we can then
> fill in the inadequacies, such as specific clock support at a
> later date. To achieve this we're placing devices supported by
> all platforms into a common device structure and the remaining
> ones into a platform specific one.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |   52 ++++++++++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 1c4edbf8..dec94d0 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -24,6 +24,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/bitops.h>
>  #include <linux/fs.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/uaccess.h>
>  #include <linux/irqchip/arm-gic.h>
> @@ -3107,19 +3108,7 @@ static struct ux500_wdt_data db8500_wdt_pdata = {
>  	.has_28_bits_resolution = true,
>  };
>  
> -static struct mfd_cell db8500_prcmu_devs[] = {
> -	{
> -		.name = "db8500-prcmu-regulators",
> -		.of_compatible = "stericsson,db8500-prcmu-regulator",
> -		.platform_data = &db8500_regulators,
> -		.pdata_size = sizeof(db8500_regulators),
> -	},
> -	{
> -		.name = "cpufreq-ux500",
> -		.of_compatible = "stericsson,cpufreq-ux500",
> -		.platform_data = &db8500_cpufreq_table,
> -		.pdata_size = sizeof(db8500_cpufreq_table),
> -	},
> +static struct mfd_cell common_prcmu_devs[] = {
>  	{
>  		.name = "ux500_wdt",
>  		.platform_data = &db8500_wdt_pdata,
> @@ -3135,6 +3124,21 @@ static struct mfd_cell db8500_prcmu_devs[] = {
>  	},
>  };
>  
> +static struct mfd_cell db8500_prcmu_devs[] = {
> +	{
> +		.name = "db8500-prcmu-regulators",
> +		.of_compatible = "stericsson,db8500-prcmu-regulator",
> +		.platform_data = &db8500_regulators,
> +		.pdata_size = sizeof(db8500_regulators),
> +	},
> +	{
> +		.name = "cpufreq-ux500",
> +		.of_compatible = "stericsson,cpufreq-ux500",
> +		.platform_data = &db8500_cpufreq_table,
> +		.pdata_size = sizeof(db8500_cpufreq_table),
> +	},
> +};
> +
>  static void db8500_prcmu_update_cpufreq(void)
>  {
>  	if (prcmu_has_arm_maxopp()) {
> @@ -3184,10 +3188,10 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
>  
>  	db8500_irq_init(np);
>  
> -	for (i = 0; i < ARRAY_SIZE(db8500_prcmu_devs); i++) {
> -		if (!strcmp(db8500_prcmu_devs[i].name, "ab8500-core")) {
> -			db8500_prcmu_devs[i].platform_data = pdata->ab_platdata;
> -			db8500_prcmu_devs[i].pdata_size = sizeof(struct ab8500_platform_data);
> +	for (i = 0; i < ARRAY_SIZE(common_prcmu_devs); i++) {
> +		if (!strcmp(common_prcmu_devs[i].name, "ab8500-core")) {
> +			common_prcmu_devs[i].platform_data = pdata->ab_platdata;
> +			common_prcmu_devs[i].pdata_size = sizeof(struct ab8500_platform_data);
>  		}
>  	}
>  
> @@ -3195,13 +3199,23 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
>  
>  	db8500_prcmu_update_cpufreq();
>  
> -	err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
> -			      ARRAY_SIZE(db8500_prcmu_devs), NULL, 0, NULL);
> +	err = mfd_add_devices(&pdev->dev, 0, common_prcmu_devs,
> +			      ARRAY_SIZE(common_prcmu_devs), NULL, 0, NULL);
>  	if (err) {
>  		pr_err("prcmu: Failed to add subdevices\n");
>  		return err;
>  	}
>  
> +	/* TODO: Remove restriction when clk definitions are available. */
> +	if (!of_machine_is_compatible("st-ericsson,u8540")) {
> +		err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
> +				      ARRAY_SIZE(db8500_prcmu_devs), NULL, 0, NULL);
> +		if (err) {
> +			pr_err("prcmu: Failed to add subdevices\n");
> +			return err;
> +		}
> +	}
> +
>  	pr_info("DB8500 PRCMU initialized\n");
>  
>  no_irq_return:

Did you see this one Sam?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
