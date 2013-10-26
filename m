Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3JZLU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:20:29 -0400
Received: from smtp-out-128.synserver.de ([212.40.185.128]:1046 "EHLO
	smtp-out-128.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3JZLU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:20:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11595
Message-ID: <526BA578.3080306@metafoo.de>
Date: Sat, 26 Oct 2013 13:20:24 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 2/4] charger-manager: Use IIO subsystem to read battery
 temperature instead of legacy method
References: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com> <1382446317-32613-3-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1382446317-32613-3-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 02:51 PM, Chanwoo Choi wrote:
> This patch support charger-manager use IIO(Industrial I/O) subsystem to read
> current battery temperature instead of legacy methor about callback function.

How does this look in hardware? Do you have a general purpose ADC connected
to a temperature sensor that has a temperature dependent voltage output? And
at some point during the board design you measure the raw value of the ADC
both for the lower and the upper threshold temperatures?

> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/power/Kconfig                 |  1 +
>  drivers/power/charger-manager.c       | 88 +++++++++++++++++++++++++++++++++--
>  include/linux/power/charger-manager.h | 13 ++++++
>  3 files changed, 97 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index e6f92b4..6700191 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -309,6 +309,7 @@ config CHARGER_MANAGER
>  	bool "Battery charger manager for multiple chargers"
>  	depends on REGULATOR && RTC_CLASS
>  	select EXTCON
> +	select IIO

Are you sure you want to force select the IIO framework? It looks like we do
not stub out iio_channel_get() and friends yet if CONFIG_IIO is not
selected. But I think that will the better solution here.

>  	help
>            Say Y to enable charger-manager support, which allows multiple
>            chargers attached to a battery and multiple batteries attached to a
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index cc720f9..02a395c 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -26,6 +26,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/sysfs.h>
>  #include <linux/of.h>
> +#include <linux/iio/consumer.h>
>  
>  static const char * const default_event_names[] = {
>  	[CM_EVENT_UNKNOWN] = "Unknown",
> @@ -542,6 +543,50 @@ static int check_charging_duration(struct charger_manager *cm)
>  }
>  
>  /**
> + * read_battery_temperature - Read current battery temperature
> + * @cm: the Charger Manager representing the battery.
> + * @last_temp_mC: store current battery temperature
> + *
> + * Returns current state of temperature by using IIO or legacy method
> + * - CM_TEMP_NORMAL
> + * - CM_TEMP_OVERHEAT
> + * - CM_TEMP_COLD
> + */
> +static int read_battery_temperature(struct charger_manager *cm,
> +				    int *last_temp_mC)
> +{
> +	struct charger_desc *desc = cm->desc;
> +	int temp;
> +
> +	if (desc->channel) {
> +		temp = iio_read_channel_raw(desc->channel, last_temp_mC);
> +
> +		/*
> +		 * The charger-manager use IIO subsystem to read ADC raw data
> +		 * from IIO ADC device drvier. The each device driver has
> +		 * own non-standard ADC table. If user of charger-manager
> +		 * would like to get correct temperature value, have to convert
> +		 * 'last_temp_mC' variable according to proper calculation
> +		 * method and own ADC table.
> +		 */
> +
> +		if (*last_temp_mC >= desc->iio_adc_overheat)
> +			temp = CM_TEMP_NORMAL;	/* Overheat */

temp = CM_TEMP_OVERHEAT ?

> +		else if (*last_temp_mC <= desc->iio_adc_cold)
> +			temp = CM_TEMP_COLD;	/* Cold */
> +		else
> +			temp = CM_TEMP_NORMAL;	/* Normal */
> +
> +	} else if (desc->temperature_out_of_range) {
> +		temp = desc->temperature_out_of_range(last_temp_mC);
> +	} else {
> +		temp = INT_MAX;
> +	}
> +
> +	return temp;
> +}
> +
> +/**
>   * _cm_monitor - Monitor the temperature and return true for exceptions.
>   * @cm: the Charger Manager representing the battery.
>   *
> @@ -551,7 +596,7 @@ static int check_charging_duration(struct charger_manager *cm)
>  static bool _cm_monitor(struct charger_manager *cm)
>  {
>  	struct charger_desc *desc = cm->desc;
> -	int temp = desc->temperature_out_of_range(&cm->last_temp_mC);
> +	int temp = read_battery_temperature(cm, &cm->last_temp_mC);
>  
>  	dev_dbg(cm->dev, "monitoring (%2.2d.%3.3dC)\n",
>  		cm->last_temp_mC / 1000, cm->last_temp_mC % 1000);
> @@ -805,7 +850,7 @@ static int charger_get_property(struct power_supply *psy,
>  	case POWER_SUPPLY_PROP_TEMP:
>  		/* in thenth of centigrade */
>  		if (cm->last_temp_mC == INT_MIN)
> -			desc->temperature_out_of_range(&cm->last_temp_mC);
> +			read_battery_temperature(cm, &cm->last_temp_mC);

So this will now return the raw ADC value to userspace on a property that is
supposed to indicate milli-degree Celsius. That doesn't seem to be right.

>  		val->intval = cm->last_temp_mC / 100;
>  		if (!desc->meaure_battery_temp)
>  			ret = -ENODEV;
> @@ -813,7 +858,7 @@ static int charger_get_property(struct power_supply *psy,
>  	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
>  		/* in thenth of centigrade */
>  		if (cm->last_temp_mC == INT_MIN)
> -			desc->temperature_out_of_range(&cm->last_temp_mC);
> +			read_battery_temperature(cm, &cm->last_temp_mC);
>  		val->intval = cm->last_temp_mC / 100;
>  		if (desc->measure_battery_temp)
>  			ret = -ENODEV;
> @@ -1586,6 +1631,32 @@ static int charger_manager_dt_parse_regulator(struct device *dev,
>  	return 0;
>  }
>  
> +static int charger_manager_dt_parse_iio(struct device *dev,
> +					      struct charger_desc *desc)
> +{
> +	struct device_node *np = dev->of_node;
> +
> +	if (of_property_read_u32(np, "iio-adc-overheat",
> +				&desc->iio_adc_overheat)) {
> +		dev_warn(dev, "cannot get standard value for hot temperature\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(np, "iio-adc-cold",
> +				&desc->iio_adc_cold)) {
> +		dev_warn(dev, "cannot get standard value for cold temperature\n");
> +		return -EINVAL;
> +	}

iio-adc-overheat and iio-adc-cold are definitely not good names for
devicetree properties. The term IIO is really Linux specific and should not
appear in the devicetree. 'temperature-lower-threshold' and
'temperature-upper-threshold' might be better names.

> +
> +	desc->channel = iio_channel_get(dev, NULL);

You need to free the channel on the error paths in your probe function.

> +	if (IS_ERR(desc->channel)) {
> +		dev_err(dev, "cannot get iio channel\n");
> +		return PTR_ERR(desc->channel);
> +	}
> +
> +	return 0;
> +}

