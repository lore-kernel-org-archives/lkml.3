Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaDOKML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:12:11 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56220 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaDOKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:12:07 -0400
Date: Tue, 15 Apr 2014 11:12:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] regulator: arizona-ldo1: Move setup processing from
 arizona-core
Message-ID: <20140415101200.GC27091@lee--X1>
References: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1396340845-24060-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396340845-24060-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014, Charles Keepax wrote:

> It is more idiomatic to process things relating to the regulator in its
> driver. This patch moves both processing of device tree relating to the
> regulator and checking if the regulator is external from arizona-core
> into the regulator driver.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c       |   12 +++---------
>  drivers/regulator/arizona-ldo1.c |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 9 deletions(-)

[...]

> diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
> index b1033d3..211af83 100644
> --- a/drivers/regulator/arizona-ldo1.c
> +++ b/drivers/regulator/arizona-ldo1.c
> @@ -178,6 +178,22 @@ static const struct regulator_init_data arizona_ldo1_default = {
>  	.num_consumer_supplies = 1,
>  };
>  
> +#ifdef CONFIG_OF
> +static int arizona_ldo1_of_get_pdata(struct arizona *arizona)
> +{
> +	struct arizona_pdata *pdata = &arizona->pdata;
> +
> +	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
> +
> +	return 0;
> +}
> +#else
> +static inline int arizona_ldo1_of_get_pdata(struct arizona *arizona)
> +{
> +	return 0;
> +}
> +#endif
> +

I think "if (IS_ENABLED(CONFIG_OF))" is preferred now, but I guess
that's up to Mark.

>  static int arizona_ldo1_probe(struct platform_device *pdev)
>  {
>  	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
> @@ -186,6 +202,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
>  	struct arizona_ldo1 *ldo1;
>  	int ret;
>  
> +	arizona->external_dcvdd = false;
> +
>  	ldo1 = devm_kzalloc(&pdev->dev, sizeof(*ldo1), GFP_KERNEL);
>  	if (!ldo1)
>  		return -ENOMEM;
> @@ -216,6 +234,13 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
>  	config.dev = arizona->dev;
>  	config.driver_data = ldo1;
>  	config.regmap = arizona->regmap;
> +
> +	if (!dev_get_platdata(arizona->dev)) {
      
Here ^

> +		ret = arizona_ldo1_of_get_pdata(arizona);
> +		if (ret < 0)
> +			return ret;
> +	}
> +

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

Mark,
  Post acceptance, I'd prefer to create an IB for this patch-set.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
