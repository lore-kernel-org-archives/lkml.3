Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030744AbaLLQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:53:41 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:40263 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082AbaLLQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:53:39 -0500
Date: Fri, 12 Dec 2014 08:53:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v6 1/5] hwmon: ina2xx: reinitialize the chip in case it's
 been reset
Message-ID: <20141212165335.GA12712@roeck-us.net>
References: <1418395075-16850-1-git-send-email-bgolaszewski@baylibre.com>
 <1418395075-16850-2-git-send-email-bgolaszewski@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418395075-16850-2-git-send-email-bgolaszewski@baylibre.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.548B1D93.00D0,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 03:37:51PM +0100, Bartosz Golaszewski wrote:
> Chips from the ina family don't like to be uninitialized. In case the power
> is cut-off and restored again the calibration register will be reset
> to 0 and both the power and current registers will remain at 0.
> 
> Check the calibration register in ina2xx_update_device() and reinitialize
> the chip if needed.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/hwmon/ina2xx.c | 90 ++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 65 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index e01feba..4c5c9ab 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -35,6 +35,7 @@
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/jiffies.h>
>  #include <linux/of.h>
> +#include <linux/delay.h>
>  
>  #include <linux/platform_data/ina2xx.h>
>  
> @@ -64,6 +65,9 @@
>  
>  /* worst case is 68.10 ms (~14.6Hz, ina219) */
>  #define INA2XX_CONVERSION_RATE		15
> +#define INA2XX_MAX_DELAY		69 /* worst case delay in ms */
> +
> +#define INA2XX_RSHUNT_DEFAULT		10000
>  
>  enum ina2xx_ids { ina219, ina226 };
>  
> @@ -81,6 +85,8 @@ struct ina2xx_data {
>  	struct i2c_client *client;
>  	const struct ina2xx_config *config;
>  
> +	long rshunt;
> +
>  	struct mutex update_lock;
>  	bool valid;
>  	unsigned long last_updated;
> @@ -110,6 +116,28 @@ static const struct ina2xx_config ina2xx_config[] = {
>  	},
>  };
>  
> +/*
> + * Initialize the configuration and calibration registers.
> + */
> +static int ina2xx_init(struct ina2xx_data *data)
> +{
> +	struct i2c_client *client = data->client;
> +	int ret;
> +
> +	/* device configuration */
> +	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
> +					   data->config->config_default);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Set current LSB to 1mA, shunt is in uOhms
> +	 * (equation 13 in datasheet).
> +	 */
> +	return i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
> +			data->config->calibration_factor / data->rshunt);
> +}
> +
>  static struct ina2xx_data *ina2xx_update_device(struct device *dev)
>  {
>  	struct ina2xx_data *data = dev_get_drvdata(dev);
> @@ -121,19 +149,45 @@ static struct ina2xx_data *ina2xx_update_device(struct device *dev)
>  	if (time_after(jiffies, data->last_updated +
>  		       HZ / INA2XX_CONVERSION_RATE) || !data->valid) {
>  
> -		int i;
> +		int i, rv;
>  
>  		dev_dbg(&client->dev, "Starting ina2xx update\n");
>  
> +again:
>  		/* Read all registers */
>  		for (i = 0; i < data->config->registers; i++) {
> -			int rv = i2c_smbus_read_word_swapped(client, i);
> +			rv = i2c_smbus_read_word_swapped(client, i);
>  			if (rv < 0) {
>  				ret = ERR_PTR(rv);
>  				goto abort;
>  			}
>  			data->regs[i] = rv;
>  		}
> +
> +		/*
> +		 * If the current value in the calibration register is 0, the
> +		 * power and current registers will also remain at 0. In case
> +		 * the chip has been reset let's check the calibration
> +		 * register and reinitialize if needed.
> +		 */
> +		if (data->regs[INA2XX_CALIBRATION] == 0) {
> +			/* Reinitialize the chip */
> +			dev_warn(dev, "chip not calibrated, reinitializing\n");
> +
> +			rv = ina2xx_init(data);
> +			if (rv < 0) {
> +				ret = ERR_PTR(rv);
> +				goto abort;
> +			}
> +
> +			/*
> +			 * Let's make sure the power and current registers
> +			 * have been updated before trying again.
> +			 */
> +			mdelay(INA2XX_MAX_DELAY);

That should be msleep() or usleep_range().

> +			goto again;

That is not a good idea. We'll have to have a retry count to handle this case
to avoid an endless loop. Sure, that should be unlikely but would be easy to
trigger by instantiating the driver on some different chip which always
returns 0 when reading the calibration register.

I would suggest to implement a retry loop. Possibly add a helper function
to handle the actual update to avoid deep indentation.

Thanks,
Guenter

> +		}
> +
>  		data->last_updated = jiffies;
>  		data->valid = 1;
>  	}
> @@ -221,7 +275,6 @@ static int ina2xx_probe(struct i2c_client *client,
>  	struct device *dev = &client->dev;
>  	struct ina2xx_data *data;
>  	struct device *hwmon_dev;
> -	long shunt = 10000; /* default shunt value 10mOhms */
>  	u32 val;
>  	int ret;
>  
> @@ -234,41 +287,28 @@ static int ina2xx_probe(struct i2c_client *client,
>  
>  	if (dev_get_platdata(dev)) {
>  		pdata = dev_get_platdata(dev);
> -		shunt = pdata->shunt_uohms;
> +		data->rshunt = pdata->shunt_uohms;
>  	} else if (!of_property_read_u32(dev->of_node,
>  					 "shunt-resistor", &val)) {
> -		shunt = val;
> +		data->rshunt = val;
> +	} else {
> +		data->rshunt = INA2XX_RSHUNT_DEFAULT;
>  	}
>  
> -	if (shunt <= 0)
> -		return -ENODEV;
> -
>  	/* set the device type */
>  	data->kind = id->driver_data;
>  	data->config = &ina2xx_config[data->kind];
> +	data->client = client;
>  
> -	/* device configuration */
> -	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
> -					   data->config->config_default);
> -	if (ret < 0) {
> -		dev_err(dev,
> -			"error writing to the config register: %d", ret);
> +	if (data->rshunt <= 0)
>  		return -ENODEV;
> -	}
>  
> -	/*
> -	 * Set current LSB to 1mA, shunt is in uOhms
> -	 * (equation 13 in datasheet).
> -	 */
> -	ret = i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
> -				data->config->calibration_factor / shunt);
> +	ret = ina2xx_init(data);
>  	if (ret < 0) {
> -		dev_err(dev,
> -			"error writing to the calibration register: %d", ret);
> +		dev_err(dev, "error configuring the device: %d\n", ret);
>  		return -ENODEV;
>  	}
>  
> -	data->client = client;
>  	mutex_init(&data->update_lock);
>  
>  	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
> @@ -277,7 +317,7 @@ static int ina2xx_probe(struct i2c_client *client,
>  		return PTR_ERR(hwmon_dev);
>  
>  	dev_info(dev, "power monitor %s (Rshunt = %li uOhm)\n",
> -		 id->name, shunt);
> +		 id->name, data->rshunt);
>  
>  	return 0;
>  }
> -- 
> 2.1.3
> 
