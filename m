Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbaHZNvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:51:22 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53363 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbaHZNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:51:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53FC90D6.9000603@roeck-us.net>
Date: Tue, 26 Aug 2014 06:51:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, jdelvare@suse.de
Subject: Re: [PATCH] hwmon: ntc_thermistor: Add ntc thermistor to thermal
 subsystem as a sensor.
References: <1409031220-25922-1-git-send-email-jonghwa3.lee@samsung.com> <53FC5D7B.4040506@samsung.com>
In-Reply-To: <53FC5D7B.4040506@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 03:12 AM, Chanwoo Choi wrote:
> Hi Jonghwa,
>
> On 08/26/2014 02:33 PM, Jonghwa Lee wrote:
>> To get more comprehensive and integrated thermal management, it adds ntc
>> thermistor to thermal framework as a thermal sensor. It's governed thermal
>> susbsystem only if it is described in DT node. Otherwise, it just notifies
>> temperature to userspace via sysfs as it used to be.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>   .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
>>   drivers/hwmon/ntc_thermistor.c                     |   26 ++++++++++++++++++++
>>   2 files changed, 29 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> index 2391e5c..fcca8e7 100644
>> --- a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> +++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> @@ -25,6 +25,9 @@ Requires node properties:
>>   - "io-channels"	Channel node of ADC to be used for
>>   		conversion.
>>
>> +Optional node properties:
>> +- "#thermal-sensor-cells" Used to expose itself to thermal fw.
>> +
>>   Read more about iio bindings at
>>   	Documentation/devicetree/bindings/iio/iio-bindings.txt
>>
>> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
>> index bd41072..369dc8c 100644
>> --- a/drivers/hwmon/ntc_thermistor.c
>> +++ b/drivers/hwmon/ntc_thermistor.c
>> @@ -38,6 +38,7 @@
>>
>>   #include <linux/hwmon.h>
>>   #include <linux/hwmon-sysfs.h>
>> +#include <linux/thermal.h>
>>
>>   struct ntc_compensation {
>>   	int		temp_c;
>> @@ -182,6 +183,7 @@ struct ntc_data {
>>   	struct device *dev;
>>   	int n_comp;
>>   	char name[PLATFORM_NAME_SIZE];
>> +	struct thermal_zone_device *tz;
>>   };
>>
>>   #if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
>> @@ -428,6 +430,20 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>>   	return -EINVAL;
>>   }
>>
>> +static int ntc_read_temp(void *dev, long *temp)
>> +{
>> +	struct ntc_data *data = dev_get_drvdata(dev);
>> +	int ohm;
>> +
>> +	ohm = ntc_thermistor_get_ohm(data);
>> +	if (ohm < 0)
>> +		return ohm;
>> +
>> +	*temp = get_temp_mc(data, ohm);
>> +
>> +	return 0;
>> +}
>> +
>>   static ssize_t ntc_show_name(struct device *dev,
>>   		struct device_attribute *attr, char *buf)
>>   {
>> @@ -562,6 +578,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>>   	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
>>   								pdev_id->name);
>>
>> +	data->tz = thermal_zone_of_sensor_register(data->dev, 0, data->dev,
>> +						ntc_read_temp, NULL);
>> +	if (IS_ERR(data->tz)) {
>> +		dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
>> +		data->tz = NULL;
>> +	}
>> +
>>   	return 0;
>>   err_after_sysfs:
>>   	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>> @@ -578,6 +601,9 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
>>   	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>>   	ntc_iio_channel_release(pdata);
>>
>> +	if (data->tz)
>> +		thermal_zone_of_sensor_unregister(data->dev, data->tz);
>
> thermal_zone_of_sensor_unregister just return without operation if data->tz is NULL.
> So, don't need to check the value of data->tz with if statement.
>

On a side note, devm_thermal_zone_of_sensor_register would be quite useful to have.

Guenter

