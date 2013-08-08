Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233Ab3HHLXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:23:03 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60519 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab3HHLXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:23:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52037F9A.7070802@roeck-us.net>
Date: Thu, 08 Aug 2013 04:23:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-2-git-send-email-wni@nvidia.com> <520359E9.1000600@roeck-us.net> <52036920.4050808@nvidia.com>
In-Reply-To: <52036920.4050808@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 02:47 AM, Wei Ni wrote:
> On 08/08/2013 04:42 PM, Guenter Roeck wrote:
>> On 08/07/2013 11:56 PM, Wei Ni wrote:
>>> The device lm90 can be controlled by the vdd rail.
>>> Adding the power control support to power on/off the vdd rail.
>>> And make sure that power is enabled before accessing the device.
>>>
>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>> ---
>>>    drivers/hwmon/lm90.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 49 insertions(+)
>>>
>>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>>> index cdff742..306a348 100644
>>> --- a/drivers/hwmon/lm90.c
>>> +++ b/drivers/hwmon/lm90.c
>>> @@ -89,6 +89,7 @@
>>>    #include <linux/err.h>
>>>    #include <linux/mutex.h>
>>>    #include <linux/sysfs.h>
>>> +#include <linux/regulator/consumer.h>
>>>
>>>    /*
>>>     * Addresses to scan
>>> @@ -302,6 +303,7 @@ static const struct lm90_params lm90_params[] = {
>>>    struct lm90_data {
>>>    	struct device *hwmon_dev;
>>>    	struct mutex update_lock;
>>> +	struct regulator *lm90_reg;
>>>    	char valid; /* zero until following fields are valid */
>>>    	unsigned long last_updated; /* in jiffies */
>>>    	int kind;
>>> @@ -1391,6 +1393,32 @@ static void lm90_init_client(struct i2c_client *client)
>>>    		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
>>>    }
>>>
>>> +static void lm90_power_control(struct i2c_client *client, bool is_enable)
>>> +{
>>> +	struct lm90_data *data = i2c_get_clientdata(client);
>>> +	int ret;
>>> +
>>> +	if (!data->lm90_reg)
>>> +		return;
>>> +
>>> +	mutex_lock(&data->update_lock);
>>> +
>>
>> This is only called during probe and remove, so the mutex is unnecessary.
>
> I considered that we may call this function in suspend/resume routine,
> so I add this mutex.
> But as you said, currently we doesn't have these routine yet, the mutex
> is unnecessary, so I will remove it.
>
In that case, you can call
	mutex_lock()
	regulator_enable() / regulator_disable()
	mutex_unlock()

directly in those functions. Again no need for the additional function.

>>
>>> +	if (is_enable)
>>> +		ret = regulator_enable(data->lm90_reg);
>>> +	else
>>> +		ret = regulator_disable(data->lm90_reg);
>>> +
>>> +	if (ret < 0)
>>> +		dev_err(&client->dev,
>>> +			"Error in %s rail vdd, error %d\n",
>>> +			(is_enable) ? "enabling" : "disabling", ret);
>>> +	else
>>> +		dev_info(&client->dev, "success in %s rail vdd\n",
>>> +			 (is_enable) ? "enabling" : "disabling");
>>> +
>> which reduces the function to (pretty much unnecessary) messages and an if statement
>> which you only need because you have the function.
>>
>> You should just call regulator_enable in probe and regulator_disable in remove.
>
> Ok, I will remove these messages and this function.
>
>>
>> Guenter
>>
>>> +	mutex_unlock(&data->update_lock);
>>> +}
>>> +
>>>    static int lm90_probe(struct i2c_client *client,
>>>    		      const struct i2c_device_id *id)
>>>    {
>>> @@ -1406,6 +1434,20 @@ static int lm90_probe(struct i2c_client *client,
>>>    	i2c_set_clientdata(client, data);
>>>    	mutex_init(&data->update_lock);
>>>
>>> +	data->lm90_reg = regulator_get(&client->dev, "vdd");
>>
>> You should use devm_regulator_get(). Then you also don't need the call to regulator_put().
>
> Oh, yes, you are right, I will do it.
>
>>
>>> +	if (IS_ERR_OR_NULL(data->lm90_reg)) {
>>
>> The function never returns NULL except if the regulator subsystem is not configured,
>> so IS_ERR() is more appropriate.
>>
>> If the regulator subsystem is not configured, you especially don't need or want
>> to pollute the log with an error message.
>>
>>> +		if (PTR_ERR(data->lm90_reg) == -ENODEV)
>>> +			dev_info(&client->dev,
>>> +				 "No regulator found for vdd. Assuming vdd is always powered.");
>>> +		else
>>> +			dev_warn(&client->dev,
>>> +				 "Error [%ld] in getting the regulator handle for vdd.\n",
>>> +				 PTR_ERR(data->lm90_reg));
>>
>> I consider the messages unnecessary and confusing. You are polluting the log
>> of pretty much every PC user who has one of the supported chips in the system,
>> and of everyone else not using regulators for this chip.
>
> Ok, I will remove these codes.
> So I will write something like:
> if (!IS_ERR(data->lm90_reg)) {
>      ret = regulator_enable(data->lm90_reg);
>      if (ret < 0) {
>          dev_err();
>          return ret;
>      }
> } else {

Handle the error in the if case.

>      if (PTR_ERR(data->lm90_reg) == -EPROBE_DEFER)
>          return -EPRPBE_DEFER;
>
>          data->lm90_reg = !!IS_ERR(data->lm90_reg);

You know that IS_ERR is true here. Unless I am missing something, this would assign "1" to lm90_reg.

> }
>
>>
>>> +		data->lm90_reg = NULL;
>>
>> As pointed out, this is unnecessary, and you should handle -EPROBE_DEFER correctly.
>
> I think get_regulator() will return error values, not only
> -EPROBE_DEFER, so we should set data->lm90_reg to NULL to handle other
> error values.
>
Matter of opinion if you want to check for IS_ERR or NULL later on.

>>
>>> +	}
>>> +
>>> +	lm90_power_control(client, true);
>>> +
>>>    	/* Set the device type */
>>>    	data->kind = id->driver_data;
>>>    	if (data->kind == adm1032) {
>>> @@ -1473,6 +1515,10 @@ exit_remove_files:
>>>    	lm90_remove_files(client, data);
>>>    exit_restore:
>>>    	lm90_restore_conf(client, data);
>>> +	lm90_power_control(client, false);
>>> +	if (data->lm90_reg)
>>> +		regulator_put(data->lm90_reg);
>>> +
>>>    	return err;
>>>    }
>>>
>>> @@ -1483,6 +1529,9 @@ static int lm90_remove(struct i2c_client *client)
>>>    	hwmon_device_unregister(data->hwmon_dev);
>>>    	lm90_remove_files(client, data);
>>>    	lm90_restore_conf(client, data);
>>> +	lm90_power_control(client, false);
>>> +	if (data->lm90_reg)
>>> +		regulator_put(data->lm90_reg);
>>>
>>>    	return 0;
>>>    }
>>>
>>
>
>
>

