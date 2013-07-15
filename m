Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3GOGGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:06:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9232 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3GOGGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:06:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 14 Jul 2013 23:05:02 -0700
Message-ID: <51E39114.505@nvidia.com>
Date: Mon, 15 Jul 2013 14:05:08 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "linux@roeck-us.net" <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-2-git-send-email-wni@nvidia.com> <20130712152615.23464a6b@endymion.delvare>
In-Reply-To: <20130712152615.23464a6b@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 09:26 PM, Jean Delvare wrote:
> Hi Wei, Guenter,
> 
> Guenter, thanks for reviewing the previous version of this patch.
> 
> Wei, thanks for incorporating review feedback and posting updated
> patches so quickly, this is very appreciated, even though I'm too busy
> these days to be that fast on my end, sorry about that.
> 
> On Fri, 12 Jul 2013 15:48:04 +0800, Wei Ni wrote:
>> Split set&show temp codes as common functions, so we can use it directly when
>> implement linux thermal framework.
> 
> Can I see a recent version of the code which will need this change? It
> makes no sense to apply this first part which makes the code more
> complex with no benefit, without the second part which needs it, so
> they should be applied together or not at all.

In my RFC patches, there had many codes about thermal fw, which need
this patch, so I put them together.
And now I split the RFC patches, this series is preparing to use the
thermal fw.
As you said, I want to register lm90 as the thermal zone device, it need
to hook some callback, such as .get_temp. if apply this patch, I can
write the .get_temp simply, something like:

+static int lm90_read_temp2_temp(struct thermal_zone_device *thz,
unsigned long *temp)
+{
+        struct lm90_data *data = thz->devdata;
+        struct i2c_client *client = to_i2c_client(data->hwmon_dev->parent);
+        struct device *dev = &client->dev;+
+
+        *temp = (long)read_temp11(dev, TEMP11_REMOTE_TEMP);
+
+        return 0;
+}
+
+static struct thermal_zone_device_ops remote_ops = {
+        .get_temp = lm90_read_temp2_temp,
+};

If without this patch, I have to rewrite the lm90_read_temp2_temp(),
which almost same as the show_temp11(), I think it's not good. When use
this patch and following 3/3 patch, the code will be more readable and
clear.

Anyway, if you want, I can send this patch as a separate one. :)

> 
> One thing I am a little worried about (but maybe I'm wrong) is that I
> seem to understand you want to register every LM90-like chip as both a
> hwmon device and two thermal devices. I seem to recall that every
> thermal device is also exposed automatically as a virtual hwmon
> device, is that correct? If so we will be presenting the same values
> twice to libsensors, which would be confusing.
> 
>> Signed-off-by: Wei Ni <wni@nvidia.com>
>> ---
>>  drivers/hwmon/lm90.c |  112 +++++++++++++++++++++++++++++++-------------------
>>  1 file changed, 69 insertions(+), 43 deletions(-)
> 
> The code changes look good, however I have one suggestion for
> improvement (plus a minor cleanup request):
> 
>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>> index 8eeb141..5f30f90 100644
>> --- a/drivers/hwmon/lm90.c
>> +++ b/drivers/hwmon/lm90.c
>> (...)
>> -static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>> -			 const char *buf, size_t count)
>> (...)
>> +static void write_temp8(struct device *dev, int index, long val)
>>  {
>>  	static const u8 reg[8] = {
>>  		LM90_REG_W_LOCAL_LOW,
>> @@ -737,60 +742,73 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>>  		MAX6659_REG_W_REMOTE_EMERG,
>>  	};
>>  
>> -	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>>  	struct i2c_client *client = to_i2c_client(dev);
>>  	struct lm90_data *data = i2c_get_clientdata(client);
>> -	int nr = attr->index;
>> -	long val;
>> -	int err;
>> -
>> -	err = kstrtol(buf, 10, &val);
>> -	if (err < 0)
>> -		return err;
>>  
>>  	/* +16 degrees offset for temp2 for the LM99 */
>> -	if (data->kind == lm99 && attr->index == 3)
>> +	if (data->kind == lm99 && index == 3)
>>  		val -= 16000;
>>  
>>  	mutex_lock(&data->update_lock);
>>  	if (data->kind == adt7461)
>> -		data->temp8[nr] = temp_to_u8_adt7461(data, val);
>> +		data->temp8[index] = temp_to_u8_adt7461(data, val);
>>  	else if (data->kind == max6646)
>> -		data->temp8[nr] = temp_to_u8(val);
>> +		data->temp8[index] = temp_to_u8(val);
>>  	else
>> -		data->temp8[nr] = temp_to_s8(val);
>> +		data->temp8[index] = temp_to_s8(val);
>>  
>> -	lm90_select_remote_channel(client, data, nr >= 6);
>> -	i2c_smbus_write_byte_data(client, reg[nr], data->temp8[nr]);
>> +	lm90_select_remote_channel(client, data, index >= 6);
>> +	i2c_smbus_write_byte_data(client, reg[index], data->temp8[index]);
> 
> This write could fail. So far the lm90 driver has failed to handle
> register write errors at all, and I will take the blame for that. But
> if we want to integrate properly with the thermal subsystem, I suspect
> we will have to properly report errors. So it might be the right time
> to catch and return write errors here. Then set_temp8() below could
> return it to user-space (either in this patch or in a separate patch,
> as you prefer.)

Ok, I will add error handler in my next version.

> 
> And then as a next step, lm90_select_remote_channel should return
> errors as they happen as well, so that they can be transmitted to the
> caller.
> 
>>  	lm90_select_remote_channel(client, data, 0);
>>  
>>  	mutex_unlock(&data->update_lock);
>> +}
>> +
>> +static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>> +			 const char *buf, size_t count)
>> +{
>> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +	int index = attr->index;
>> +	long val;
>> +	int err;
>> +
>> +	err = kstrtol(buf, 10, &val);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	write_temp8(dev, index, val);
>> +
>>  	return count;
>>  }
>>  
>> -static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
>> -			   char *buf)
>> +static int read_temp11(struct device *dev, int index)
>>  {
>> -	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>>  	struct lm90_data *data = lm90_update_device(dev);
>>  	int temp;
>>  
>>  	if (data->kind == adt7461)
>> -		temp = temp_from_u16_adt7461(data, data->temp11[attr->index]);
>> +		temp = temp_from_u16_adt7461(data, data->temp11[index]);
>>  	else if (data->kind == max6646)
>> -		temp = temp_from_u16(data->temp11[attr->index]);
>> +		temp = temp_from_u16(data->temp11[index]);
>>  	else
>> -		temp = temp_from_s16(data->temp11[attr->index]);
>> +		temp = temp_from_s16(data->temp11[index]);
>>  
>>  	/* +16 degrees offset for temp2 for the LM99 */
>> -	if (data->kind == lm99 &&  attr->index <= 2)
>> +	if (data->kind == lm99 &&  index <= 2)
> 
> There's a doubled space on this line. It isn't added by your patch, it
> was already there before, but please fix it while you're here.

Oh, you are so carefully, I will fix it :)

> 
>>  		temp += 16000;
>>  
>> -	return sprintf(buf, "%d\n", temp);
>> +	return temp;
>>  }
>>  
>> -static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>> -			  const char *buf, size_t count)
>> (...)
>> +static void write_temp11(struct device *dev, int nr, int index, long val)
> 
> Here too I would suggest returning errors from the I2C layer, and
> handling them in set_temp11() now or later.
> 
>>  {
>>  	struct {
>>  		u8 high;
>> @@ -804,17 +822,8 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>>  		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 1 }
>>  	};
>>  
>> -	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>>  	struct i2c_client *client = to_i2c_client(dev);
>>  	struct lm90_data *data = i2c_get_clientdata(client);
>> -	int nr = attr->nr;
>> -	int index = attr->index;
>> -	long val;
>> -	int err;
>> -
>> -	err = kstrtol(buf, 10, &val);
>> -	if (err < 0)
>> -		return err;
>>  
>>  	/* +16 degrees offset for temp2 for the LM99 */
>>  	if (data->kind == lm99 && index <= 2)
>> @@ -839,6 +848,23 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>>  	lm90_select_remote_channel(client, data, 0);
>>  
>>  	mutex_unlock(&data->update_lock);
>> +}
>> +
>> +static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>> +			  const char *buf, size_t count)
>> +{
>> +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>> +	int nr = attr->nr;
>> +	int index = attr->index;
>> +	long val;
>> +	int err;
>> +
>> +	err = kstrtol(buf, 10, &val);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	write_temp11(dev, nr, index, val);
>> +
>>  	return count;
>>  }
>>  
> 

