Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaFPNDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:03:13 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:64388 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaFPNDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:03:12 -0400
Date: Mon, 16 Jun 2014 14:03:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, k.kozlowski@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/3] mfd: sec-core: Add support for S2MPU02 device
Message-ID: <20140616130306.GU14323@lee--X1>
References: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
 <1402893757-18957-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402893757-18957-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Chanwoo Choi wrote:

> Add support for Samsung S2MPU02 PMIC device to the MFD sec-core driver.
> The S2MPU02 device includes PMIC/RTC/Clock devices.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c           | 19 +++++++++
>  drivers/mfd/sec-irq.c            | 88 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/samsung/core.h |  1 +
>  include/linux/mfd/samsung/irq.h  | 24 +++++++++++
>  4 files changed, 132 insertions(+)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index be06d0a..5e8784b 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -89,6 +89,17 @@ static const struct mfd_cell s2mpa01_devs[] = {
>  	},
>  };
>  
> +static const struct mfd_cell s2mpu02_devs[] = {
> +	{
> +		.name = "s2mpu02-pmic",
> +	}, {
> +		.name = "s2mpu02-rtc",

Make these two one liners, so:

  { .name = "s2mpu02-pmic" },
  { .name = "s2mpu02-rtc" ),

> +	}, {
> +		.name = "s2mpu02-clk",
> +		.of_compatible = "samsung,s2mpu02-clk",
> +	}
> +};
> +
>  #ifdef CONFIG_OF
>  static const struct of_device_id sec_dt_match[] = {
>  	{	.compatible = "samsung,s5m8767-pmic",
> @@ -103,6 +114,9 @@ static const struct of_device_id sec_dt_match[] = {
>  		.compatible = "samsung,s2mpa01-pmic",
>  		.data = (void *)S2MPA01,
>  	}, {
> +		.compatible = "samsung,s2mpu02-pmic",
> +		.data = (void *)S2MPU02,
> +	}, {
>  		/* Sentinel */
>  	},
>  };
> @@ -342,6 +356,11 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps14_devs,
>  				      ARRAY_SIZE(s2mps14_devs), NULL, 0, NULL);
>  		break;
> +	case S2MPU02:
> +		ret = mfd_add_devices(sec_pmic->dev, -1, s2mpu02_devs,
> +				      ARRAY_SIZE(s2mpu02_devs), NULL, 0, NULL);
> +		break;

This is a bit bonkers.  Instead of passing S2MPU02, why don't you pass
a new container which holds s2mpu02_devs and s2mpu02_irq_chip, then
you won't need new mfd_add_devices() and regmap_add_irq_chip() calls
for every device you want to support.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
