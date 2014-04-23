Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaDWNwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:52:04 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53088 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaDWNv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:51:58 -0400
Date: Wed, 23 Apr 2014 14:51:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2] mfd: sec-core: Remove duplicated device type from
 sec_pmic_dev
Message-ID: <20140423135151.GA6264@lee--X1>
References: <1398156970-9360-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398156970-9360-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Krzysztof Kozlowski wrote:

> The device type was stored in sec_pmic_dev state container twice:
>  - unsigned long type (initialized from of_device_id or i2c_device_id)
>  - int device_type (initialized as above or from board files when there
>    is no DTS)
> 
> The 'type' field was never used outside of probe so it can be safely
> removed.
> 
> Change also the device_type in sec_pmic_dev and sec_platform_data to
> unsigned long to avoid any casts.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Changes since v1:
>  - Change device_type field of sec_platform_data from int to unsigned long.
>  - Update commit msg.
> ---
>  drivers/mfd/sec-core.c           | 5 +++--
>  drivers/mfd/sec-irq.c            | 2 +-
>  include/linux/mfd/samsung/core.h | 3 +--
>  3 files changed, 5 insertions(+), 5 deletions(-)

What upstream commit are these patches based on? They don't seem to
apply to v3.15-rc2. Could you rebase and resend with my Ack applied
please?

> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index d4682c6cbff5..09fd256abcf6 100644
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
>  
>  	if (sec_pmic->dev->of_node) {
>  		pdata = sec_pmic_i2c_parse_dt_pdata(sec_pmic->dev);
> @@ -270,7 +271,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  			ret = PTR_ERR(pdata);
>  			return ret;
>  		}
> -		pdata->device_type = sec_pmic->type;
> +		pdata->device_type = device_type;
>  	}
>  	if (pdata) {
>  		sec_pmic->device_type = pdata->device_type;
> diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
> index 64e7913aadc6..654e2c1dbf7a 100644
> --- a/drivers/mfd/sec-irq.c
> +++ b/drivers/mfd/sec-irq.c
> @@ -385,7 +385,7 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
>  				  &sec_pmic->irq_data);
>  		break;
>  	default:
> -		dev_err(sec_pmic->dev, "Unknown device type %d\n",
> +		dev_err(sec_pmic->dev, "Unknown device type %lu\n",
>  			sec_pmic->device_type);
>  		return -EINVAL;
>  	}
> diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> index 84aaf6c25794..e7e12ebacb9b 100644
> --- a/include/linux/mfd/samsung/core.h
> +++ b/include/linux/mfd/samsung/core.h
> @@ -43,13 +43,12 @@ struct sec_pmic_dev {
>  	struct regmap *regmap_pmic;
>  	struct i2c_client *i2c;
>  
> -	int device_type;
> +	unsigned long device_type;
>  	int irq_base;
>  	int irq;
>  	struct regmap_irq_chip_data *irq_data;
>  
>  	int ono;
> -	unsigned long type;
>  	bool wakeup;
>  	bool wtsr_smpl;
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
