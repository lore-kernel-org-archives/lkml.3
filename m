Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbaKRPlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:41:15 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:58443 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbaKRPlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:41:12 -0500
Date: Tue, 18 Nov 2014 15:41:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linus.walleij@linaro.org, gnurou@gmail.com, broonie@kernel.org,
        tiwai@suse.de, perex@perex.cz, sameo@linux.intel.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/6] mfd: arizona: add support for WM8280/WM8281
Message-ID: <20141118154102.GA13959@x1>
References: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
 <1415901046-3391-2-git-send-email-rf@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415901046-3391-2-git-send-email-rf@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Richard Fitzgerald wrote:

> This adds support for the Wolfson Microelectronics
> WM8280 and WM8281 codecs.
> 
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/Kconfig              |    5 +++--
>  drivers/mfd/arizona-core.c       |   14 ++++++++++++--
>  drivers/mfd/arizona-i2c.c        |    2 ++
>  drivers/mfd/arizona-irq.c        |    1 +
>  drivers/mfd/arizona-spi.c        |    2 ++
>  include/linux/mfd/arizona/core.h |    1 +
>  6 files changed, 21 insertions(+), 4 deletions(-)

Patch looks fine.  Can I just take it?

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index abef204..e00a90f 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1236,10 +1236,11 @@ config MFD_WM5102
>  	  Support for Wolfson Microelectronics WM5102 low power audio SoC
>  
>  config MFD_WM5110
> -	bool "Wolfson Microelectronics WM5110"
> +	bool "Wolfson Microelectronics WM5110 and WM8280/WM8281"
>  	depends on MFD_ARIZONA
>  	help
> -	  Support for Wolfson Microelectronics WM5110 low power audio SoC
> +	  Support for Wolfson Microelectronics WM5110 and WM8280/WM8281
> +	  low power audio SoC
>  
>  config MFD_WM8997
>  	bool "Wolfson Microelectronics WM8997"
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index bce7c07..6e6b732 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -567,6 +567,7 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  const struct of_device_id arizona_of_match[] = {
>  	{ .compatible = "wlf,wm5102", .data = (void *)WM5102 },
>  	{ .compatible = "wlf,wm5110", .data = (void *)WM5110 },
> +	{ .compatible = "wlf,wm8280", .data = (void *)WM8280 },
>  	{ .compatible = "wlf,wm8997", .data = (void *)WM8997 },
>  	{},
>  };
> @@ -671,6 +672,7 @@ int arizona_dev_init(struct arizona *arizona)
>  	switch (arizona->type) {
>  	case WM5102:
>  	case WM5110:
> +	case WM8280:
>  	case WM8997:
>  		for (i = 0; i < ARRAY_SIZE(wm5102_core_supplies); i++)
>  			arizona->core_supplies[i].supply
> @@ -834,11 +836,18 @@ int arizona_dev_init(struct arizona *arizona)
>  #endif
>  #ifdef CONFIG_MFD_WM5110
>  	case 0x5110:
> -		type_name = "WM5110";
> -		if (arizona->type != WM5110) {
> +		switch (arizona->type) {
> +		case WM5110:
> +			type_name = "WM5110";
> +			break;
> +		case WM8280:
> +			type_name = "WM8280";
> +			break;
> +		default:
>  			dev_err(arizona->dev, "WM5110 registered as %d\n",
>  				arizona->type);
>  			arizona->type = WM5110;
> +			break;
>  		}
>  		apply_patch = wm5110_patch;
>  		break;
> @@ -1010,6 +1019,7 @@ int arizona_dev_init(struct arizona *arizona)
>  				      ARRAY_SIZE(wm5102_devs), NULL, 0, NULL);
>  		break;
>  	case WM5110:
> +	case WM8280:
>  		ret = mfd_add_devices(arizona->dev, -1, wm5110_devs,
>  				      ARRAY_SIZE(wm5110_devs), NULL, 0, NULL);
>  		break;
> diff --git a/drivers/mfd/arizona-i2c.c b/drivers/mfd/arizona-i2c.c
> index 9d4156f..ff782a5 100644
> --- a/drivers/mfd/arizona-i2c.c
> +++ b/drivers/mfd/arizona-i2c.c
> @@ -44,6 +44,7 @@ static int arizona_i2c_probe(struct i2c_client *i2c,
>  #endif
>  #ifdef CONFIG_MFD_WM5110
>  	case WM5110:
> +	case WM8280:
>  		regmap_config = &wm5110_i2c_regmap;
>  		break;
>  #endif
> @@ -87,6 +88,7 @@ static int arizona_i2c_remove(struct i2c_client *i2c)
>  static const struct i2c_device_id arizona_i2c_id[] = {
>  	{ "wm5102", WM5102 },
>  	{ "wm5110", WM5110 },
> +	{ "wm8280", WM8280 },
>  	{ "wm8997", WM8997 },
>  	{ }
>  };
> diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> index 3a3fe7c..d063b94 100644
> --- a/drivers/mfd/arizona-irq.c
> +++ b/drivers/mfd/arizona-irq.c
> @@ -211,6 +211,7 @@ int arizona_irq_init(struct arizona *arizona)
>  #endif
>  #ifdef CONFIG_MFD_WM5110
>  	case WM5110:
> +	case WM8280:
>  		aod = &wm5110_aod;
>  
>  		switch (arizona->rev) {
> diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
> index 5145d78..721b93f 100644
> --- a/drivers/mfd/arizona-spi.c
> +++ b/drivers/mfd/arizona-spi.c
> @@ -44,6 +44,7 @@ static int arizona_spi_probe(struct spi_device *spi)
>  #endif
>  #ifdef CONFIG_MFD_WM5110
>  	case WM5110:
> +	case WM8280:
>  		regmap_config = &wm5110_spi_regmap;
>  		break;
>  #endif
> @@ -82,6 +83,7 @@ static int arizona_spi_remove(struct spi_device *spi)
>  static const struct spi_device_id arizona_spi_ids[] = {
>  	{ "wm5102", WM5102 },
>  	{ "wm5110", WM5110 },
> +	{ "wm8280", WM8280 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(spi, arizona_spi_ids);
> diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
> index 910e3aa..f970105 100644
> --- a/include/linux/mfd/arizona/core.h
> +++ b/include/linux/mfd/arizona/core.h
> @@ -24,6 +24,7 @@ enum arizona_type {
>  	WM5102 = 1,
>  	WM5110 = 2,
>  	WM8997 = 3,
> +	WM8280 = 4,
>  };
>  
>  #define ARIZONA_IRQ_GP1                    0

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
