Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3HGHP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:15:58 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19429 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3HGHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:15:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Aug 2013 00:15:56 -0700
Message-ID: <5201F42B.5040308@nvidia.com>
Date: Wed, 7 Aug 2013 15:15:55 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwmon: (lm90) Add power control
References: <1375858358-15070-1-git-send-email-wni@nvidia.com> <1375858358-15070-2-git-send-email-wni@nvidia.com> <5201F138.3080906@roeck-us.net>
In-Reply-To: <5201F138.3080906@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:03 PM, Guenter Roeck wrote:
> On 08/06/2013 11:52 PM, Wei Ni wrote:
>> The device lm90 can be controlled by the vdd rail.
>> Adding the power control support to power on/off the vdd rail.
>> And make sure that power is enabled before accessing the device.
>>
>> Signed-off-by: Wei Ni <wni@nvidia.com>
>> ---
>>   drivers/hwmon/lm90.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 52 insertions(+)
>>
>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>> index cdff742..eeb0115 100644
>> --- a/drivers/hwmon/lm90.c
>> +++ b/drivers/hwmon/lm90.c
>> @@ -89,6 +89,8 @@
>>   #include <linux/err.h>
>>   #include <linux/mutex.h>
>>   #include <linux/sysfs.h>
>> +#include <linux/delay.h>
>> +#include <linux/regulator/consumer.h>
>>
>>   /*
>>    * Addresses to scan
>> @@ -179,6 +181,8 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
>>   #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
>>   #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
>>
>> +#define POWER_ON_DELAY 20 /*ms*/
>> +
>>   /*
>>    * Driver data (common to all clients)
>>    */
>> @@ -302,6 +306,7 @@ static const struct lm90_params lm90_params[] = {
>>   struct lm90_data {
>>   	struct device *hwmon_dev;
>>   	struct mutex update_lock;
>> +	struct regulator *lm90_reg;
>>   	char valid; /* zero until following fields are valid */
>>   	unsigned long last_updated; /* in jiffies */
>>   	int kind;
>> @@ -1391,6 +1396,48 @@ static void lm90_init_client(struct i2c_client *client)
>>   		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
>>   }
>>
>> +static int lm90_power_control(struct i2c_client *client, bool is_enable)
>> +{
>> +	struct lm90_data *data = i2c_get_clientdata(client);
>> +	int ret;
>> +
>> +	mutex_lock(&data->update_lock);
>> +
>> +	if (!data->lm90_reg) {
>> +		data->lm90_reg = regulator_get(&client->dev, "vdd");
>> +		if (IS_ERR_OR_NULL(data->lm90_reg)) {
>> +			if (PTR_ERR(data->lm90_reg) == -ENODEV)
>> +				dev_info(&client->dev,
>> +					 "No regulator found for vdd. Assuming vdd is always powered.");
>> +			else
>> +				dev_warn(&client->dev,
>> +					 "Error [%ld] in getting the regulator handle for vdd.\n",
>> +					 PTR_ERR(data->lm90_reg));
>> +			data->lm90_reg = NULL;
>> +			mutex_unlock(&data->update_lock);
>> +			return -ENODEV;
> 
> I don't think it is acceptable to have the driver fail on pretty much all PCs.

Yes, you are right, I didn't consider it carefully, I will fix it.
I think it's better to move these codes to the probe() directly.

> 
> Also, I dislike that - even if the calling code doesn't fail - the above message would be displayed on unload as well.
> 
> In general, the 'unload' flag seems unnecessary. You could just call
> 
> 	if (data->lm90_reg)
> 		regulator_disable();
> 
> in the remove function. In addition to that, shouldn't you call regulator_put() on exit ?

Oh, sorry, I miss the regulator_put(), I will fix it.

> Also, I am missing error handling in the probe function; if something else fails,
> the regulator is neither disabled nor released.

It looks this patch have many problems, I will fix them.
Thanks for your comments.

> 
> Guenter
> 
>> +		}
>> +	}
>> +	if (is_enable) {
>> +		ret = regulator_enable(data->lm90_reg);
>> +		msleep(POWER_ON_DELAY);
>> +	} else {
>> +		ret = regulator_disable(data->lm90_reg);
>> +	}
>> +
>> +	if (ret < 0)
>> +		dev_err(&client->dev,
>> +			"Error in %s rail vdd, error %d\n",
>> +			(is_enable) ? "enabling" : "disabling", ret);
>> +	else
>> +		dev_info(&client->dev, "success in %s rail vdd\n",
>> +			 (is_enable) ? "enabling" : "disabling");
>> +
>> +	mutex_unlock(&data->update_lock);
>> +
>> +	return ret;
>> +}
>> +
>>   static int lm90_probe(struct i2c_client *client,
>>   		      const struct i2c_device_id *id)
>>   {
>> @@ -1406,6 +1453,10 @@ static int lm90_probe(struct i2c_client *client,
>>   	i2c_set_clientdata(client, data);
>>   	mutex_init(&data->update_lock);
>>
>> +	err = lm90_power_control(client, true);
>> +	if (err < 0)
>> +		return err;
>> +
>>   	/* Set the device type */
>>   	data->kind = id->driver_data;
>>   	if (data->kind == adm1032) {
>> @@ -1483,6 +1534,7 @@ static int lm90_remove(struct i2c_client *client)
>>   	hwmon_device_unregister(data->hwmon_dev);
>>   	lm90_remove_files(client, data);
>>   	lm90_restore_conf(client, data);
>> +	lm90_power_control(client, false);
>>
>>   	return 0;
>>   }
>>
> 

