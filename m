Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaCLPRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:17:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44126 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaCLPRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:17:41 -0400
Date: Wed, 12 Mar 2014 16:17:20 +0100
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 3/4] devfreq: exynos4: Add ppmu's clock control and code
 clean about regulator control
In-reply-to: <1394624882-2989-4-git-send-email-cw00.choi@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Message-id: <1783132.ayF9Dpflf1@amdc1032>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7Bit
X-AuditID: cbfee61b-b7f456d000006dfd-47-53207a93bc6a
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd3JVQrBBv93aVhc//Kc1eJs0xt2
	i+4f2RaXd81hs/jce4TR4nbjCjaLNz/OMlk8XvGW3YHDY/Gel0wefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujJObZ7EULDau6P6xmbmB8axGFyMnh4SAicSFCb9YIGwxiQv31rN1
	MXJxCAlMZ5SY3XkOymlhkjh/+R5YFZuAlcTE9lWMILaIgIbEzL9XGEGKmAX2MEpM7fvFCpIQ
	FsiReP1/PpjNIqAq0djYyQxi8wpoSlw/+AusWVTAU2LH9pVsIDangKvE885Wpi5GDqBt9RL9
	j4shygUlfkyG2MssIC+xb/9UVghbR2J/6zS2CYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5
	RnrFibnFpXnpesn5uZsYwUH+THoH46oGi0OMAhyMSjy8CzXlg4VYE8uKK3MPMUpwMCuJ8D4t
	VAgW4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwGitbrt8
	5YP85a7BfByJ72Xnb2T5WPCz7P8W7Zyzz49zajPbGDlcr+5VMLY9uc8hTP2cfcjtNM/dBjJZ
	LEvSd93qudOW3T5PM3nmsgWfmDkjSqfsKpr3+BXz+Ulz/yrr3uOfGcKZ0R63YofX5B75pyyq
	tYEib8RnqV/Pc+c8zsts+IYrs3PLGiWW4oxEQy3mouJEAIJYu+huAgAA
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
 <1394624882-2989-4-git-send-email-cw00.choi@samsung.com>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, March 12, 2014 08:48:01 PM Chanwoo Choi wrote:
> There are not the clock controller of ppmudmc0/1. This patch control the clock
> of ppmudmc0/1 which is used for monitoring memory bus utilization.
> 
> Also, this patch code clean about regulator control and free resource
> when calling exit/remove function.
> 
> For example,
> busfreq@106A0000 {
> 	compatible = "samsung,exynos4x12-busfreq";
> 
> 	/* Clock for PPMUDMC0/1 */
> 	clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
> 	clock-names = "ppmudmc0", "ppmudmc1";
> 
> 	/* Regulator for MIF/INT block */
> 	vdd_mif-supply = <&buck1_reg>;
> 	vdd_int-supply = <&buck3_reg>;
> };

This should be in Documentation/devicetree/bindings/ documentation.

> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/exynos/exynos4_bus.c | 107 ++++++++++++++++++++++++++++++-----
>  1 file changed, 93 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
> index 16fb3cb..0c5b99e 100644
> --- a/drivers/devfreq/exynos/exynos4_bus.c
> +++ b/drivers/devfreq/exynos/exynos4_bus.c
> @@ -62,6 +62,11 @@ enum exynos_ppmu_idx {
>  	PPMU_END,
>  };
>  
> +static const char *exynos_ppmu_clk_name[] = {
> +	[PPMU_DMC0]	= "ppmudmc0",
> +	[PPMU_DMC1]	= "ppmudmc1",
> +};
> +
>  #define EX4210_LV_MAX	LV_2
>  #define EX4x12_LV_MAX	LV_4
>  #define EX4210_LV_NUM	(LV_2 + 1)
> @@ -86,6 +91,7 @@ struct busfreq_data {
>  	struct regulator *vdd_mif; /* Exynos4412/4212 only */
>  	struct busfreq_opp_info curr_oppinfo;
>  	struct exynos_ppmu ppmu[PPMU_END];
> +	struct clk *clk_ppmu[PPMU_END];
>  
>  	struct notifier_block pm_notifier;
>  	struct mutex lock;
> @@ -722,8 +728,26 @@ static int exynos4_bus_get_dev_status(struct device *dev,
>  static void exynos4_bus_exit(struct device *dev)
>  {
>  	struct busfreq_data *data = dev_get_drvdata(dev);
> +	int i;
>  
> -	devfreq_unregister_opp_notifier(dev, data->devfreq);
> +	/*
> +	 * Un-map memory man and disable regulator/clocks
> +	 * to prevent power leakage.
> +	 */
> +	regulator_disable(data->vdd_int);
> +	if (data->type == TYPE_BUSF_EXYNOS4x12)
> +		regulator_disable(data->vdd_mif);
> +
> +	for (i = 0; i < PPMU_END; i++) {
> +		if (data->clk_ppmu[i])
> +			clk_disable_unprepare(data->clk_ppmu[i]);
> +	}
> +
> +	for (i = 0; i < PPMU_END; i++) {
> +		if (data->ppmu[i].hw_base)
> +			iounmap(data->ppmu[i].hw_base);
> +
> +	}
>  }
>  
>  static struct devfreq_dev_profile exynos4_devfreq_profile = {
> @@ -987,6 +1011,7 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
>  {
>  	struct device *dev = data->dev;
>  	struct device_node *np = dev->of_node;
> +	const char **clk_name = exynos_ppmu_clk_name;
>  	int i, ret;
>  
>  	if (!np) {
> @@ -1005,8 +1030,67 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
>  		}
>  	}
>  
> +	/*
> +	 * Get PPMU's clocks to control them. But, if PPMU's clocks
> +	 * is default 'pass' state, this driver don't need control
> +	 * PPMU's clock.
> +	 */
> +	for (i = 0; i < PPMU_END; i++) {
> +		data->clk_ppmu[i] = devm_clk_get(dev, clk_name[i]);
> +		if (IS_ERR_OR_NULL(data->clk_ppmu[i])) {
> +			dev_warn(dev, "Cannot get %s clock\n", clk_name[i]);
> +			data->clk_ppmu[i] = NULL;
> +		}
> +
> +		ret = clk_prepare_enable(data->clk_ppmu[i]);
> +		if (ret < 0) {
> +			dev_warn(dev, "Cannot enable %s clock\n", clk_name[i]);
> +			data->clk_ppmu[i] = NULL;
> +			goto err_clocks;
> +		}
> +	}
> +
> +
> +	/* Get regulators to control voltage of int/mif block */
> +	data->vdd_int = devm_regulator_get(dev, "vdd_int");
> +	if (IS_ERR(data->vdd_int)) {
> +		dev_err(dev, "Failed to get the regulator of vdd_int\n");
> +		ret = PTR_ERR(data->vdd_int);
> +		goto err_clocks;
> +	}
> +	ret = regulator_enable(data->vdd_int);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to enable regulator of vdd_int\n");
> +		goto err_clocks;
> +	}
> +
> +	switch (data->type) {
> +	case TYPE_BUSF_EXYNOS4x12:
> +		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
> +		if (IS_ERR(data->vdd_mif)) {
> +			dev_err(dev, "Failed to get the regulator vdd_mif\n");
> +			ret = PTR_ERR(data->vdd_mif);
> +			goto err_clocks;

This won't disable vdd_int regulator.

> +		}
> +		ret = regulator_enable(data->vdd_mif);
> +		if (ret < 0) {
> +			dev_err(dev, "Failed to enable regulator of vdd_mif\n");
> +			goto err_clocks;

ditto

> +		}
> +		break;
> +	case TYPE_BUSF_EXYNOS4210:
> +	default:
> +		dev_err(data->dev, "Unknown device type\n");
> +		return -EINVAL;

This looks very wrong for Exynos4210.

> +	};
> +
>  	return 0;
>  
> +err_clocks:
> +	for (i = 0; i < PPMU_END; i++) {
> +		if (data->clk_ppmu[i])
> +			clk_disable_unprepare(data->clk_ppmu[i]);
> +	}
>  err_iomap:
>  	for (i = 0; i < PPMU_END; i++) {
>  		if (data->ppmu[i].hw_base)
> @@ -1068,19 +1152,6 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>  	if (err)
>  		return err;
>  
> -	data->vdd_int = devm_regulator_get(dev, "vdd_int");
> -	if (IS_ERR(data->vdd_int)) {
> -		dev_err(dev, "Cannot get the regulator \"vdd_int\"\n");
> -		return PTR_ERR(data->vdd_int);
> -	}
> -	if (data->type == TYPE_BUSF_EXYNOS4x12) {
> -		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
> -		if (IS_ERR(data->vdd_mif)) {
> -			dev_err(dev, "Cannot get the regulator \"vdd_mif\"\n");
> -			return PTR_ERR(data->vdd_mif);
> -		}
> -	}
> -
>  	rcu_read_lock();
>  	opp = dev_pm_opp_find_freq_floor(dev,
>  					 &exynos4_devfreq_profile.initial_freq);
> @@ -1133,6 +1204,11 @@ err_notifier_opp:
>  	devfreq_remove_device(data->devfreq);
>  err_opp:

Disabling of regulators on failure is missing here.

>  	for (i = 0; i < PPMU_END; i++) {
> +		if (data->clk_ppmu[i])
> +			clk_disable_unprepare(data->clk_ppmu[i]);
> +	}
> +
> +	for (i = 0; i < PPMU_END; i++) {
>  		if (data->ppmu[i].hw_base)
>  			iounmap(data->ppmu[i].hw_base);
>  	}
> @@ -1144,7 +1220,10 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
>  {
>  	struct busfreq_data *data = platform_get_drvdata(pdev);
>  
> +	/* Unregister all of notifier chain */
>  	unregister_pm_notifier(&data->pm_notifier);
> +	devfreq_unregister_opp_notifier(data->dev, data->devfreq);
> +
>  	devfreq_remove_device(data->devfreq);
>  
>  	return 0;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

