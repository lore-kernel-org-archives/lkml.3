Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbaDQI0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:26:38 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35215 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbaDQI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:26:33 -0400
Date: Thu, 17 Apr 2014 09:26:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/2] mfd: sec-core: Remove duplicated device type from
 sec_pmic
Message-ID: <20140417082628.GG28725@lee--X1>
References: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The device type was stored in sec_pmic state container twice:
>  - unsigned long type
>  - int device_type

Can you explain that one of them is in the main container and the
other is stored in pdata, which in turn is located in the main
container, as this implies that both of them are located in the same
place, which is not quite true.

> The 'type' field was never used outside of probe so it can be safely
> removed.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c           | 5 +++--
>  include/linux/mfd/samsung/core.h | 1 -
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index d4682c6cbff5..fccfd71f8abd 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -251,6 +251,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
>  	const struct regmap_config *regmap;
>  	struct sec_pmic_dev *sec_pmic;
> +	unsigned long device_type;
>  	int ret;
>  
>  	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
> @@ -262,7 +263,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  	sec_pmic->dev = &i2c->dev;
>  	sec_pmic->i2c = i2c;
>  	sec_pmic->irq = i2c->irq;
> -	sec_pmic->type = sec_i2c_get_driver_data(i2c, id);
> +	device_type = sec_i2c_get_driver_data(i2c, id);

Better to change the return type of 'sec_i2c_get_driver_data()' than
to rely on a cast later on.

>  	if (sec_pmic->dev->of_node) {
>  		pdata = sec_pmic_i2c_parse_dt_pdata(sec_pmic->dev);
> @@ -270,7 +271,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  			ret = PTR_ERR(pdata);
>  			return ret;
>  		}
> -		pdata->device_type = sec_pmic->type;
> +		pdata->device_type = (int)device_type;
>  	}
>  	if (pdata) {
>  		sec_pmic->device_type = pdata->device_type;
> diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> index 84aaf6c25794..2633083262ea 100644
> --- a/include/linux/mfd/samsung/core.h
> +++ b/include/linux/mfd/samsung/core.h
> @@ -49,7 +49,6 @@ struct sec_pmic_dev {
>  	struct regmap_irq_chip_data *irq_data;
>  
>  	int ono;
> -	unsigned long type;
>  	bool wakeup;
>  	bool wtsr_smpl;
>  };
> -- 
> 1.8.3.2
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
