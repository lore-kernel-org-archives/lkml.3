Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaC2LIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 07:08:41 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47712 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaC2LIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 07:08:38 -0400
Message-ID: <5336A9F9.4080504@kernel.org>
Date: Sat, 29 Mar 2014 11:09:45 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Marek Belisko <marek@goldelico.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv2 1/2] rx51_battery: convert to iio consumer
References: <1393375569-21751-1-git-send-email-sre@debian.org> <1393705366-32420-1-git-send-email-sre@debian.org> <1393705366-32420-2-git-send-email-sre@debian.org>
In-Reply-To: <1393705366-32420-2-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/14 20:22, Sebastian Reichel wrote:
> Update rx51-battery driver to use the new IIO API of
> twl4030-madc and add DT support.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
This looks fine to me.  I'd love to see a more generic solution, but
we can work on that another time.

Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>   drivers/power/rx51_battery.c | 90 ++++++++++++++++++++++++++++++++------------
>   1 file changed, 66 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
> index 1bc5857..d5a2acf 100644
> --- a/drivers/power/rx51_battery.c
> +++ b/drivers/power/rx51_battery.c
> @@ -24,34 +24,27 @@
>   #include <linux/power_supply.h>
>   #include <linux/slab.h>
>   #include <linux/i2c/twl4030-madc.h>
> -
> -/* RX51 specific channels */
> -#define TWL4030_MADC_BTEMP_RX51	TWL4030_MADC_ADCIN0
> -#define TWL4030_MADC_BCI_RX51	TWL4030_MADC_ADCIN4
> +#include <linux/iio/consumer.h>
> +#include <linux/of.h>
>
>   struct rx51_device_info {
>   	struct device *dev;
>   	struct power_supply bat;
> +	struct iio_channel *channel_temp;
> +	struct iio_channel *channel_bsi;
> +	struct iio_channel *channel_vbat;
>   };
>
>   /*
>    * Read ADCIN channel value, code copied from maemo kernel
>    */
> -static int rx51_battery_read_adc(int channel)
> +static int rx51_battery_read_adc(struct iio_channel *channel)
>   {
> -	struct twl4030_madc_request req;
> -
> -	req.channels = channel;
> -	req.do_avg = 1;
> -	req.method = TWL4030_MADC_SW1;
> -	req.func_cb = NULL;
> -	req.type = TWL4030_MADC_WAIT;
> -	req.raw = true;
> -
> -	if (twl4030_madc_conversion(&req) <= 0)
> -		return -ENODATA;
> -
> -	return req.rbuf[ffs(channel) - 1];
> +	int val, err;
> +	err = iio_read_channel_average_raw(channel, &val);
> +	if (err < 0)
> +		return err;
> +	return val;
>   }
>
>   /*
> @@ -60,10 +53,12 @@ static int rx51_battery_read_adc(int channel)
>    */
>   static int rx51_battery_read_voltage(struct rx51_device_info *di)
>   {
> -	int voltage = rx51_battery_read_adc(TWL4030_MADC_VBAT);
> +	int voltage = rx51_battery_read_adc(di->channel_vbat);
>
> -	if (voltage < 0)
> +	if (voltage < 0) {
> +		dev_err(di->dev, "Could not read ADC: %d\n", voltage);
>   		return voltage;
> +	}
>
>   	return 1000 * (10000 * voltage / 1705);
>   }
> @@ -112,7 +107,10 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
>   {
>   	int min = 0;
>   	int max = ARRAY_SIZE(rx51_temp_table2) - 1;
> -	int raw = rx51_battery_read_adc(TWL4030_MADC_BTEMP_RX51);
> +	int raw = rx51_battery_read_adc(di->channel_temp);
> +
> +	if (raw < 0)
> +		dev_err(di->dev, "Could not read ADC: %d\n", raw);
>
>   	/* Zero and negative values are undefined */
>   	if (raw <= 0)
> @@ -146,10 +144,12 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
>    */
>   static int rx51_battery_read_capacity(struct rx51_device_info *di)
>   {
> -	int capacity = rx51_battery_read_adc(TWL4030_MADC_BCI_RX51);
> +	int capacity = rx51_battery_read_adc(di->channel_bsi);
>
> -	if (capacity < 0)
> +	if (capacity < 0) {
> +		dev_err(di->dev, "Could not read ADC: %d\n", capacity);
>   		return capacity;
> +	}
>
>   	return 1280 * (1200 * capacity)/(1024 - capacity);
>   }
> @@ -213,17 +213,46 @@ static int rx51_battery_probe(struct platform_device *pdev)
>
>   	platform_set_drvdata(pdev, di);
>
> +	di->dev = &pdev->dev;
>   	di->bat.name = dev_name(&pdev->dev);
>   	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
>   	di->bat.properties = rx51_battery_props;
>   	di->bat.num_properties = ARRAY_SIZE(rx51_battery_props);
>   	di->bat.get_property = rx51_battery_get_property;
>
> +	di->channel_temp = iio_channel_get(di->dev, "temp");
> +	if (IS_ERR(di->channel_temp)) {
> +		ret = PTR_ERR(di->channel_temp);
> +		goto error;
> +	}
> +
> +	di->channel_bsi  = iio_channel_get(di->dev, "bsi");
> +	if (IS_ERR(di->channel_bsi)) {
> +		ret = PTR_ERR(di->channel_bsi);
> +		goto error_channel_temp;
> +	}
> +
> +	di->channel_vbat = iio_channel_get(di->dev, "vbat");
> +	if (IS_ERR(di->channel_vbat)) {
> +		ret = PTR_ERR(di->channel_vbat);
> +		goto error_channel_bsi;
> +	}
> +
>   	ret = power_supply_register(di->dev, &di->bat);
>   	if (ret)
> -		return ret;
> +		goto error_channel_vbat;
>
>   	return 0;
> +
> +error_channel_vbat:
> +	iio_channel_release(di->channel_vbat);
> +error_channel_bsi:
> +	iio_channel_release(di->channel_bsi);
> +error_channel_temp:
> +	iio_channel_release(di->channel_temp);
> +error:
> +
> +	return ret;
>   }
>
>   static int rx51_battery_remove(struct platform_device *pdev)
> @@ -232,15 +261,28 @@ static int rx51_battery_remove(struct platform_device *pdev)
>
>   	power_supply_unregister(&di->bat);
>
> +	iio_channel_release(di->channel_vbat);
> +	iio_channel_release(di->channel_bsi);
> +	iio_channel_release(di->channel_temp);
> +
>   	return 0;
>   }
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id n900_battery_of_match[] = {
> +	{.compatible = "nokia,n900-battery", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, n900_battery_of_match);
> +#endif
> +
>   static struct platform_driver rx51_battery_driver = {
>   	.probe = rx51_battery_probe,
>   	.remove = rx51_battery_remove,
>   	.driver = {
>   		.name = "rx51-battery",
>   		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(n900_battery_of_match),
>   	},
>   };
>   module_platform_driver(rx51_battery_driver);
>

