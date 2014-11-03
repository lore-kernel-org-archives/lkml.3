Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaKCRzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:55:44 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37181 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaKCRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:55:39 -0500
Date: Mon, 3 Nov 2014 17:55:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 14/47] mfd: tps80031: Register with kernel power-off
 handler
Message-ID: <20141103175529.GO12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-15-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-15-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - Use define to specify poweroff handler priority
> - Use dev_warn instead of dev_err
> 
>  drivers/mfd/tps80031.c       | 30 ++++++++++++++++++------------
>  include/linux/mfd/tps80031.h |  2 ++
>  2 files changed, 20 insertions(+), 12 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
> index ed6c5b0..6504959 100644
> --- a/drivers/mfd/tps80031.c
> +++ b/drivers/mfd/tps80031.c
> @@ -147,7 +147,6 @@ static const struct tps80031_pupd_data tps80031_pupds[] = {
>  	[TPS80031_CTLI2C_SCL]		= PUPD_DATA(4, 0,	BIT(2)),
>  	[TPS80031_CTLI2C_SDA]		= PUPD_DATA(4, 0,	BIT(3)),
>  };
> -static struct tps80031 *tps80031_power_off_dev;
>  
>  int tps80031_ext_power_req_config(struct device *dev,
>  		unsigned long ext_ctrl_flag, int preq_bit,
> @@ -209,11 +208,17 @@ int tps80031_ext_power_req_config(struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(tps80031_ext_power_req_config);
>  
> -static void tps80031_power_off(void)
> +static int tps80031_power_off(struct notifier_block *this,
> +			      unsigned long unused1, void *unused2)
>  {
> -	dev_info(tps80031_power_off_dev->dev, "switching off PMU\n");
> -	tps80031_write(tps80031_power_off_dev->dev, TPS80031_SLAVE_ID1,
> -				TPS80031_PHOENIX_DEV_ON, TPS80031_DEVOFF);
> +	struct tps80031 *tps80031 = container_of(this, struct tps80031,
> +						 power_off_nb);
> +
> +	dev_info(tps80031->dev, "switching off PMU\n");
> +	tps80031_write(tps80031->dev, TPS80031_SLAVE_ID1,
> +		       TPS80031_PHOENIX_DEV_ON, TPS80031_DEVOFF);
> +
> +	return NOTIFY_DONE;
>  }
>  
>  static void tps80031_pupd_init(struct tps80031 *tps80031,
> @@ -501,9 +506,13 @@ static int tps80031_probe(struct i2c_client *client,
>  		goto fail_mfd_add;
>  	}
>  
> -	if (pdata->use_power_off && !pm_power_off) {
> -		tps80031_power_off_dev = tps80031;
> -		pm_power_off = tps80031_power_off;
> +	if (pdata->use_power_off) {
> +		tps80031->power_off_nb.notifier_call = tps80031_power_off;
> +		tps80031->power_off_nb.priority = POWER_OFF_PRIORITY_LOW;
> +		ret = register_power_off_handler(&tps80031->power_off_nb);
> +		if (ret)
> +			dev_warn(&client->dev,
> +				 "Failed to register power-off handler\n");
>  	}
>  	return 0;
>  
> @@ -523,10 +532,7 @@ static int tps80031_remove(struct i2c_client *client)
>  	struct tps80031 *tps80031 = i2c_get_clientdata(client);
>  	int i;
>  
> -	if (tps80031_power_off_dev == tps80031) {
> -		tps80031_power_off_dev = NULL;
> -		pm_power_off = NULL;
> -	}
> +	unregister_power_off_handler(&tps80031->power_off_nb);
>  
>  	mfd_remove_devices(tps80031->dev);
>  
> diff --git a/include/linux/mfd/tps80031.h b/include/linux/mfd/tps80031.h
> index 2c75c9c..2c6afc2 100644
> --- a/include/linux/mfd/tps80031.h
> +++ b/include/linux/mfd/tps80031.h
> @@ -24,6 +24,7 @@
>  #define __LINUX_MFD_TPS80031_H
>  
>  #include <linux/device.h>
> +#include <linux/notifier.h>
>  #include <linux/regmap.h>
>  
>  /* Pull-ups/Pull-downs */
> @@ -513,6 +514,7 @@ struct tps80031 {
>  	struct i2c_client	*clients[TPS80031_NUM_SLAVES];
>  	struct regmap		*regmap[TPS80031_NUM_SLAVES];
>  	struct regmap_irq_chip_data *irq_data;
> +	struct notifier_block	power_off_nb;
>  };
>  
>  struct tps80031_pupd_init_data {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
