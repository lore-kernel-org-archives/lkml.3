Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaGUIE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:04:29 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:52732 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaGUIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:04:27 -0400
Date: Mon, 21 Jul 2014 09:04:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        RTC-LINUX <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Support Opensource <support.opensource@diasemi.com>
Subject: Re: [RFC V1] mfd: da9063: Add support for AD silicon variant
Message-ID: <20140721080420.GU30888@lee--X1>
References: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014, Opensource [Steve Twiss] wrote:
> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> Add register definitions for DA9063 AD (0x3) silicon variant ID
> and Kconfig support to choose the silicon variant at compile time.
> This patch also adds RTC support for the AD silicon changes.
> 
> It adds AD support as a compile-time flag under a new menu item in
> Kconfig called 'Support DA9063 AD silicon variant ID'. This allows
> the user to choose AD support, or to leave blank and choose support
> for the newer silicon variant ID, but not both at the same time.
> 
> This extra option for supporting AD will only appear if the main 'Dialog
> Semiconductor DA9063 PMIC Support' option is chosen. The AD support
> boolean will be defaulted to false (unchecked) until the user
> modifies it. This means that AD support is not turned on by default.
> 
> The DA9063 probe function has been modified to use the compile time
> directive CONFIG_MFD_DA9063_AD. This configuration option will allow
> AD support only if this boolean is true, otherwise it will default to
> support BB (or greater) silicon.
> 
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> ---

[...]

> --- a/drivers/mfd/da9063-core.c
> +++ b/drivers/mfd/da9063-core.c

[...]

> -	if (variant_code != PMIC_DA9063_BB) {
> -		dev_err(da9063->dev, "Unknown chip variant code: 0x%02X\n",
> -				variant_code);
> +#ifdef CONFIG_MFD_DA9063_AD
> +	if (variant_code != PMIC_DA9063_AD) {
> +		dev_err(da9063->dev,
> +			"Only AD (0x3) silicon is supported in this configuration: 0x%02X\n",
> +			variant_code);
>  		return -ENODEV;
>  	}
> +#else
> +	if (variant_code < PMIC_DA9063_BB) {
> +		dev_err(da9063->dev,
> +			"Cannot support variant code < BB (0x5): 0x%02X\n",
> +			variant_code);
> +		return -ENODEV;
> +	}
> +#endif

[...]

> diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
> index 5953930..66c3073 100644
> --- a/drivers/rtc/rtc-da9063.c
> +++ b/drivers/rtc/rtc-da9063.c

[...]

> +#ifdef CONFIG_MFD_DA9063_AD
> +	data[RTC_SEC] = 0;
> +	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_ALARM_MI,
> +			       &data[RTC_MIN], RTC_ALARM_DATA_LEN);
> +#else
>  	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_ALARM_S,
>  			       &data[RTC_SEC], RTC_DATA_LEN);
> +#endif

This isn't how we normally do things.  You need to create local
variables for the differences and populated them in a switch statement
based on variant ID.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
