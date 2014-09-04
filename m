Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaIDIlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:41:06 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57265 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaIDIlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:41:02 -0400
Date: Thu, 4 Sep 2014 09:40:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: da9052: Avoid setting read_flag_mask for da9052-i2c
 driver
Message-ID: <20140904084056.GA29612@lee--X1>
References: <1408195420.21225.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408195420.21225.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2014, Axel Lin wrote:

> Current code init regmap with &da9052_regmap_config for both da9052-spi and
> da9052-i2c drivers. da9052-spi sets the read_flag_mask.
> The same setting may be applied for da9052-i2c if da9052-spi driver is loaded
> first because they actually use the same regmap_config setting.
> Fix this issue by using a local variable for regmap_config in da9052-spi driver,
> so the settings in spi driver won't impact the settings in i2c driver.
> Also makes da9052_regmap_config const to avoid similar issue.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Adam and Steve,

Applied with Adam's Ack.

> Any chance to test this patch?
> 
> Thanks,
> Axel
>  drivers/mfd/da9052-core.c         | 2 +-
>  drivers/mfd/da9052-spi.c          | 7 ++++---
>  include/linux/mfd/da9052/da9052.h | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
> index e8af816..52a0c2f 100644
> --- a/drivers/mfd/da9052-core.c
> +++ b/drivers/mfd/da9052-core.c
> @@ -522,7 +522,7 @@ static const struct mfd_cell da9052_subdev_info[] = {
>  	},
>  };
>  
> -struct regmap_config da9052_regmap_config = {
> +const struct regmap_config da9052_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  
> diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
> index 17666b4..45ae0b7 100644
> --- a/drivers/mfd/da9052-spi.c
> +++ b/drivers/mfd/da9052-spi.c
> @@ -23,6 +23,7 @@
>  
>  static int da9052_spi_probe(struct spi_device *spi)
>  {
> +	struct regmap_config config;
>  	int ret;
>  	const struct spi_device_id *id = spi_get_device_id(spi);
>  	struct da9052 *da9052;
> @@ -40,10 +41,10 @@ static int da9052_spi_probe(struct spi_device *spi)
>  
>  	spi_set_drvdata(spi, da9052);
>  
> -	da9052_regmap_config.read_flag_mask = 1;
> -	da9052_regmap_config.write_flag_mask = 0;
> +	config = da9052_regmap_config;
> +	config.read_flag_mask = 1;
>  
> -	da9052->regmap = devm_regmap_init_spi(spi, &da9052_regmap_config);
> +	da9052->regmap = devm_regmap_init_spi(spi, &config);
>  	if (IS_ERR(da9052->regmap)) {
>  		ret = PTR_ERR(da9052->regmap);
>  		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
> diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
> index bba65f5..c18a4c1 100644
> --- a/include/linux/mfd/da9052/da9052.h
> +++ b/include/linux/mfd/da9052/da9052.h
> @@ -211,7 +211,7 @@ static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
>  int da9052_device_init(struct da9052 *da9052, u8 chip_id);
>  void da9052_device_exit(struct da9052 *da9052);
>  
> -extern struct regmap_config da9052_regmap_config;
> +extern const struct regmap_config da9052_regmap_config;
>  
>  int da9052_irq_init(struct da9052 *da9052);
>  int da9052_irq_exit(struct da9052 *da9052);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
