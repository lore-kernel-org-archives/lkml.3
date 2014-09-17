Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041AbaIQEK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:10:56 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50096 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaIQEKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:10:54 -0400
Message-ID: <54190983.9030906@roeck-us.net>
Date: Tue, 16 Sep 2014 21:09:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
CC: jdelvare@suse.de
Subject: Re: [PATCH RESEND v2] hwmon: ntc_thermistor: Add ntc thermistor to
 thermal subsystem as a sensor.
References: <1410921693-3291-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1410921693-3291-1-git-send-email-jonghwa3.lee@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.541909CE.0006,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On 09/16/2014 07:41 PM, Jonghwa Lee wrote:
> To get more comprehensive and integrated thermal management, it adds ntc
> thermistor to thermal framework as a thermal sensor. It's governed thermal
> susbsystem only if it is described in DT node. Otherwise, it just notifies
> temperature to userspace via sysfs as it used to be.
>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---

As has been pointed out, with

CONFIG_OF=y
CONFIG_THERMAL=m
CONFIG_SENSORS_NTC_THERMISTOR=y

this patch results in

drivers/built-in.o: In function `ntc_thermistor_probe':
ntc_thermistor.c:(.text+0xfff52): undefined reference to `thermal_zone_of_sensor_register'
drivers/built-in.o: In function `ntc_thermistor_remove':
ntc_thermistor.c:(.text+0xfffc5): undefined reference to `thermal_zone_of_sensor_unregister'
make: *** [vmlinux] Error 1

Resending the patch without changes does not fix the problem.
Please submit a fixed version.

Thanks,
Guenter


> Updates in v2
>   - Remove NULL pointer checking already done by thermal_zone_of_sensor_unregister().
>
>   .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
>   drivers/hwmon/ntc_thermistor.c                     |   25 ++++++++++++++++++++
>   2 files changed, 28 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> index 2391e5c..fcca8e7 100644
> --- a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> +++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> @@ -25,6 +25,9 @@ Requires node properties:
>   - "io-channels"	Channel node of ADC to be used for
>   		conversion.
>
> +Optional node properties:
> +- "#thermal-sensor-cells" Used to expose itself to thermal fw.
> +
>   Read more about iio bindings at
>   	Documentation/devicetree/bindings/iio/iio-bindings.txt
>
> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
> index bd41072..4ff89b2 100644
> --- a/drivers/hwmon/ntc_thermistor.c
> +++ b/drivers/hwmon/ntc_thermistor.c
> @@ -38,6 +38,7 @@
>
>   #include <linux/hwmon.h>
>   #include <linux/hwmon-sysfs.h>
> +#include <linux/thermal.h>
>
>   struct ntc_compensation {
>   	int		temp_c;
> @@ -182,6 +183,7 @@ struct ntc_data {
>   	struct device *dev;
>   	int n_comp;
>   	char name[PLATFORM_NAME_SIZE];
> +	struct thermal_zone_device *tz;
>   };
>
>   #if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
> @@ -428,6 +430,20 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>   	return -EINVAL;
>   }
>
> +static int ntc_read_temp(void *dev, long *temp)
> +{
> +	struct ntc_data *data = dev_get_drvdata(dev);
> +	int ohm;
> +
> +	ohm = ntc_thermistor_get_ohm(data);
> +	if (ohm < 0)
> +		return ohm;
> +
> +	*temp = get_temp_mc(data, ohm);
> +
> +	return 0;
> +}
> +
>   static ssize_t ntc_show_name(struct device *dev,
>   		struct device_attribute *attr, char *buf)
>   {
> @@ -562,6 +578,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>   	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
>   								pdev_id->name);
>
> +	data->tz = thermal_zone_of_sensor_register(data->dev, 0, data->dev,
> +						ntc_read_temp, NULL);
> +	if (IS_ERR(data->tz)) {
> +		dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
> +		data->tz = NULL;
> +	}
> +
>   	return 0;
>   err_after_sysfs:
>   	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> @@ -578,6 +601,8 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
>   	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>   	ntc_iio_channel_release(pdata);
>
> +	thermal_zone_of_sensor_unregister(data->dev, data->tz);
> +
>   	return 0;
>   }
>
>

