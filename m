Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3CKMrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:47:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63470 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3CKMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:47:02 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 11 Mar 2013 05:46:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree-discuss@lists.ozlabs.org, khali@linux-fr.org,
        dianders@chromium.org, naveenkrishna.ch@gmail.com,
        dg77.kim@samsung.com
Subject: Re: [PATCH 2/2] hwmon: NTC: add IIO get channel and read support
Message-ID: <20130311124658.GB30159@roeck-us.net>
References: <1362967787-22557-1-git-send-email-ch.naveen@samsung.com>
 <1362967787-22557-2-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362967787-22557-2-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 07:39:47AM +0530, Naveen Krishna Chatradhi wrote:
> This patch adds the support to work as a iio device.
> iio_get_channel and iio_raw_read works.
> 
> During the probe ntc driver gets the respective channels of ADC
> and uses iio_raw_read calls to get the ADC converted value.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> 
> Still not sure about the read_uV function parameter change and placement.
> 
Me not either. Is the parameter change really necessary ? There was a good
reason to pass pdev, as it lets the called function deal with the device, eg for
error messages.

> There were a few CamelCase warnings during checkpatch run.
> I can clean them if anyone insists.
> 
I actually have a patch sitting somewhere doing just that. Might make sense if I
send it out for review and you rebase your patches on top of it.

>  drivers/hwmon/ntc_thermistor.c               |   36 +++++++++++++++++++++++++-
>  include/linux/platform_data/ntc_thermistor.h |    7 ++++-
>  2 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
> index cfedbd3..1d31260 100644
> --- a/drivers/hwmon/ntc_thermistor.c
> +++ b/drivers/hwmon/ntc_thermistor.c
> @@ -30,6 +30,11 @@
>  
>  #include <linux/platform_data/ntc_thermistor.h>
>  
> +#include <linux/iio/iio.h>
> +#include <linux/iio/machine.h>
> +#include <linux/iio/driver.h>
> +#include <linux/iio/consumer.h>
> +

One problem with this change is that the driver now mandates the existence of
the IIO subsystem, even if not needed (ie if CONFIG_OF is not defined. We'll
have to limit that impact. I would suggest to keep all the ioo code in the
#ifdef CONFIG_OF block. also, you'll have to add a conditional dependency to
Kconfig.

>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
>  
> @@ -162,6 +167,28 @@ struct ntc_data {
>  	char name[PLATFORM_NAME_SIZE];
>  };
>  
> +static int ntc_adc_read(struct ntc_thermistor_platform_data *pdata)
> +{

Better name it ntc_adc_iio_read.

> +	struct iio_channel *channel = pdata->chan;
> +	unsigned int result;
> +	int val, ret;
> +
> +	if (!channel)
> +		return -EINVAL;
> +
You should check this earlier (see below).

> +	ret = iio_read_channel_raw(channel, &val);
> +	if (ret < 0) {
> +		pr_err("read channel() error: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* unit: mV */
> +	result = pdata->pullup_uV * (s64) val;
> +	result >>= 12;
> +
> +	return result;
> +}
> +
>  #ifdef CONFIG_OF
>  static void ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
>  							struct device_node *np)
> @@ -173,6 +200,8 @@ static void ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
>  		pdata->connect = NTC_CONNECTED_POSITIVE;
>  	else /* status change should be possible if not always on. */
>  		pdata->connect = NTC_CONNECTED_GROUND;
> +
> +	pdata->read_uV = ntc_adc_read;
>  }
>  #else
>  static void
> @@ -317,7 +346,7 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>  		return data->pdata->read_ohm(data->pdev);
>  
>  	if (data->pdata->read_uV) {
> -		read_uV = data->pdata->read_uV(data->pdev);
> +		read_uV = data->pdata->read_uV(data->pdata);

I am really not happy with this parameter change.
you should be able to get the pointer to pdata with
		data = platform_get_drvdata(pdev);
		pdata = data->pdata;

>  		if (read_uV < 0)
>  			return read_uV;
>  		return get_ohm_of_thermistor(data, read_uV);
> @@ -417,6 +446,8 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>  	if (!data)
>  		return -ENOMEM;
>  
> +	pdata->chan = iio_channel_get(&pdev->dev, NULL);
> +
I think this should be assigned together with read_uV in ntc_thermistor_parse_dt,
and bail out if it returns an error. It does not make sense to instantiate
the driver otherwise if OF is used to construct pdata.

Also, iio_channel_get can return an error, so you have to check the returned
value for an error return with IS_ERR. This error can be EDEFER, so make
sure it is returned to the caller to cause the probe t be called again later.

>  	data->dev = &pdev->dev;
>  	data->pdev = pdev;
>  	data->pdata = pdata;
> @@ -457,15 +488,18 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>  	return 0;
>  err_after_sysfs:
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> +	iio_channel_release(pdata->chan);

That will crash nicely if pdata->chan is not set or has an error.

>  	return ret;
>  }
>  
>  static int ntc_thermistor_remove(struct platform_device *pdev)
>  {
>  	struct ntc_data *data = platform_get_drvdata(pdev);
> +	struct ntc_thermistor_platform_data *pdata = data->pdata;
>  
>  	hwmon_device_unregister(data->hwmon_dev);
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> +	iio_channel_release(pdata->chan);

Same here - you'll have to make sure pdata->chan is valid.

>  	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
> diff --git a/include/linux/platform_data/ntc_thermistor.h b/include/linux/platform_data/ntc_thermistor.h
> index 18f3c3a..671d056 100644
> --- a/include/linux/platform_data/ntc_thermistor.h
> +++ b/include/linux/platform_data/ntc_thermistor.h
> @@ -34,19 +34,24 @@ struct ntc_thermistor_platform_data {
>  	 *
>  	 * pullup_uV, pullup_ohm, pulldown_ohm, and connect are required to use
>  	 * read_uV()
> +	 * takes the platform data structure as the parameter

Please undo this change.

>  	 *
>  	 * How to setup pullup_ohm, pulldown_ohm, and connect is
>  	 * described at Documentation/hwmon/ntc_thermistor
>  	 *
>  	 * pullup/down_ohm: 0 for infinite / not-connected
> +	 *
> +	 * iio_channel to communicate with the ADC which the
> +	 * thermistor is using for conversion of the analog values.
>  	 */
> -	int (*read_uV)(struct platform_device *);
> +	int (*read_uV)(struct ntc_thermistor_platform_data *);

Please undo this change.

>  	int (*read_ohm)(struct platform_device *);
>  	unsigned int pullup_uV;
>  
>  	unsigned int pullup_ohm;
>  	unsigned int pulldown_ohm;
>  	enum { NTC_CONNECTED_POSITIVE, NTC_CONNECTED_GROUND } connect;
> +	struct iio_channel *chan;
>  };
>  
>  #endif /* _LINUX_NTC_H */
> -- 
> 1.7.9.5
> 
> 
