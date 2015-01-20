Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbbATORo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:17:44 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:57091 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbATORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:17:14 -0500
Date: Tue, 20 Jan 2015 14:17:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2] mfd: max77686/802: Remove support for board files
Message-ID: <20150120141708.GR13701@x1>
References: <1419844156-20907-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419844156-20907-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2014, Krzysztof Kozlowski wrote:

> The driver is used only on Exynos based boards with DTS support.
> After removal of board file support from max77686 and max77802 regulator
> drivers, the MFD driver can be converted to DTS-only version. This
> simplifies a little the code:
> 1. No dead (unused) entries in platform_data structure.
> 2. More code removed.
> 3. Regulator driver does not depend on allocated memory
>    from MFD driver.
> 4. It makes also easier extending the regulator driver.
> 
> Add to the max77686 MFD driver dependency on CONFIG_OF because without
> DTS the regulator drivers (max77686 and max77802) won't bind.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> ---
> 
> This was a part of [1] patchset. Other patches from that patchset were
> merged so re-sending this without any changes.

Applied now, thanks.

> [1] https://lkml.org/lkml/2014/11/5/122
> ---
>  drivers/mfd/Kconfig                  |  1 +
>  drivers/mfd/max77686.c               | 23 -----------------------
>  include/linux/mfd/max77686-private.h |  1 -
>  include/linux/mfd/max77686.h         | 28 ----------------------------
>  4 files changed, 1 insertion(+), 52 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 2e6b7311fabc..4a1bb86ae27c 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -417,6 +417,7 @@ config MFD_MAX14577
>  config MFD_MAX77686
>  	bool "Maxim Semiconductor MAX77686/802 PMIC Support"
>  	depends on I2C=y
> +	depends on OF
>  	select MFD_CORE
>  	select REGMAP_I2C
>  	select REGMAP_IRQ
> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 929795eae9fc..3da237afacde 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -205,24 +205,10 @@ static const struct of_device_id max77686_pmic_dt_match[] = {
>  	{ },
>  };
>  
> -static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
> -								  *dev)
> -{
> -	struct max77686_platform_data *pd;
> -
> -	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> -	if (!pd)
> -		return NULL;
> -
> -	dev->platform_data = pd;
> -	return pd;
> -}
> -
>  static int max77686_i2c_probe(struct i2c_client *i2c,
>  			      const struct i2c_device_id *id)
>  {
>  	struct max77686_dev *max77686 = NULL;
> -	struct max77686_platform_data *pdata = dev_get_platdata(&i2c->dev);
>  	const struct of_device_id *match;
>  	unsigned int data;
>  	int ret = 0;
> @@ -233,14 +219,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  	const struct mfd_cell *cells;
>  	int n_devs;
>  
> -	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node && !pdata)
> -		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
> -
> -	if (!pdata) {
> -		dev_err(&i2c->dev, "No platform data found.\n");
> -		return -EINVAL;
> -	}
> -
>  	max77686 = devm_kzalloc(&i2c->dev,
>  				sizeof(struct max77686_dev), GFP_KERNEL);
>  	if (!max77686)
> @@ -259,7 +237,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  	max77686->dev = &i2c->dev;
>  	max77686->i2c = i2c;
>  
> -	max77686->wakeup = pdata->wakeup;
>  	max77686->irq = i2c->irq;
>  
>  	if (max77686->type == TYPE_MAX77686) {
> diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
> index 960b92ad450d..f5043490d67c 100644
> --- a/include/linux/mfd/max77686-private.h
> +++ b/include/linux/mfd/max77686-private.h
> @@ -447,7 +447,6 @@ struct max77686_dev {
>  	struct regmap_irq_chip_data *rtc_irq_data;
>  
>  	int irq;
> -	bool wakeup;
>  	struct mutex irqlock;
>  	int irq_masks_cur[MAX77686_IRQ_GROUP_NR];
>  	int irq_masks_cache[MAX77686_IRQ_GROUP_NR];
> diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
> index 553f7d09258a..bb995ab9a575 100644
> --- a/include/linux/mfd/max77686.h
> +++ b/include/linux/mfd/max77686.h
> @@ -119,12 +119,6 @@ enum max77802_regulators {
>  	MAX77802_REG_MAX,
>  };
>  
> -struct max77686_regulator_data {
> -	int id;
> -	struct regulator_init_data *initdata;
> -	struct device_node *of_node;
> -};
> -
>  enum max77686_opmode {
>  	MAX77686_OPMODE_NORMAL,
>  	MAX77686_OPMODE_LP,
> @@ -136,26 +130,4 @@ struct max77686_opmode_data {
>  	int mode;
>  };
>  
> -struct max77686_platform_data {
> -	int ono;
> -	int wakeup;
> -
> -	/* ---- PMIC ---- */
> -	struct max77686_regulator_data *regulators;
> -	int num_regulators;
> -
> -	struct max77686_opmode_data *opmode_data;
> -
> -	/*
> -	 * GPIO-DVS feature is not enabled with the current version of
> -	 * MAX77686 driver. Buck2/3/4_voltages[0] is used as the default
> -	 * voltage at probe. DVS/SELB gpios are set as OUTPUT-LOW.
> -	 */
> -	int buck234_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
> -	int buck234_gpio_selb[3]; /* [0]SELB2, [1]SELB3, [2]SELB4 */
> -	unsigned int buck2_voltage[8]; /* buckx_voltage in uV */
> -	unsigned int buck3_voltage[8];
> -	unsigned int buck4_voltage[8];
> -};
> -
>  #endif /* __LINUX_MFD_MAX77686_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
