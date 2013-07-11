Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3GKInM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:43:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12109 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3GKInJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:43:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 11 Jul 2013 01:42:59 -0700
Message-ID: <51DE6FD9.8080206@nvidia.com>
Date: Thu, 11 Jul 2013 16:42:01 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) split set&show temp as common codes
References: <1373455539-2831-1-git-send-email-wni@nvidia.com> <1373455539-2831-2-git-send-email-wni@nvidia.com> <20130710182154.GC22430@roeck-us.net>
In-Reply-To: <20130710182154.GC22430@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 02:21 AM, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 07:25:37PM +0800, Wei Ni wrote:
>> Split set&show temp codes as common functions, so we can use it directly when
>> implement linux thermal framework.
>>
>> Signed-off-by: Wei Ni <wni@nvidia.com>
>> ---
>>  drivers/hwmon/lm90.c |  118 ++++++++++++++++++++++++++++++++------------------
>>  1 file changed, 75 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
>> index 8eeb141..2cb7f8e 100644
>> --- a/drivers/hwmon/lm90.c
>> +++ b/drivers/hwmon/lm90.c
>> @@ -702,29 +702,37 @@ static u16 temp_to_u16_adt7461(struct lm90_data *data, long val)
>>   * Sysfs stuff
>>   */
>>
>> -static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
>> -                       char *buf)
>> +static int read_temp8(struct device *dev, int index)
>>  {
>> -     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> -     struct lm90_data *data = lm90_update_device(dev);
>>       int temp;
>> +     struct lm90_data *data = lm90_update_device(dev);
>>
> Why this reordering of variables ?

Oh, I didn't noticed it yet, thanks for your review, I will change it.

> 
>>       if (data->kind == adt7461)
>> -             temp = temp_from_u8_adt7461(data, data->temp8[attr->index]);
>> +             temp = temp_from_u8_adt7461(data, data->temp8[index]);
>>       else if (data->kind == max6646)
>> -             temp = temp_from_u8(data->temp8[attr->index]);
>> +             temp = temp_from_u8(data->temp8[index]);
>>       else
>> -             temp = temp_from_s8(data->temp8[attr->index]);
>> +             temp = temp_from_s8(data->temp8[index]);
>>
>>       /* +16 degrees offset for temp2 for the LM99 */
>> -     if (data->kind == lm99 && attr->index == 3)
>> +     if (data->kind == lm99 && index == 3)
>>               temp += 16000;
>>
>> +     return temp;
>> +}
>> +
>> +static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
>> +                       char *buf)
>> +{
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     int temp;
>> +
>> +     temp = read_temp8(dev, attr->index);
>> +
>>       return sprintf(buf, "%d\n", temp);
> 
> Might as well simplify with
>         return sprintf(buf, "%d\n", read_temp8(dev, attr->index));

Ok, I will update it.

> 
>>  }
>>
>> -static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>> -                      const char *buf, size_t count)
>> +static void write_temp8(struct device *dev, int index, long val)
>>  {
>>       static const u8 reg[8] = {
>>               LM90_REG_W_LOCAL_LOW,
>> @@ -737,60 +745,76 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>>               MAX6659_REG_W_REMOTE_EMERG,
>>       };
>>
>> -     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>>       struct i2c_client *client = to_i2c_client(dev);
>>       struct lm90_data *data = i2c_get_clientdata(client);
>> -     int nr = attr->index;
>> -     long val;
>> -     int err;
>> -
>> -     err = kstrtol(buf, 10, &val);
>> -     if (err < 0)
>> -             return err;
>>
>>       /* +16 degrees offset for temp2 for the LM99 */
>> -     if (data->kind == lm99 && attr->index == 3)
>> +     if (data->kind == lm99 && index == 3)
>>               val -= 16000;
>>
>>       mutex_lock(&data->update_lock);
>>       if (data->kind == adt7461)
>> -             data->temp8[nr] = temp_to_u8_adt7461(data, val);
>> +             data->temp8[index] = temp_to_u8_adt7461(data, val);
>>       else if (data->kind == max6646)
>> -             data->temp8[nr] = temp_to_u8(val);
>> +             data->temp8[index] = temp_to_u8(val);
>>       else
>> -             data->temp8[nr] = temp_to_s8(val);
>> +             data->temp8[index] = temp_to_s8(val);
>>
>> -     lm90_select_remote_channel(client, data, nr >= 6);
>> -     i2c_smbus_write_byte_data(client, reg[nr], data->temp8[nr]);
>> +     lm90_select_remote_channel(client, data, index >= 6);
>> +     i2c_smbus_write_byte_data(client, reg[index], data->temp8[index]);
>>       lm90_select_remote_channel(client, data, 0);
>>
>>       mutex_unlock(&data->update_lock);
>> +}
>> +
>> +static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>> +                      const char *buf, size_t count)
>> +{
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     int index = attr->index;
>> +     long val;
>> +     int err;
>> +
>> +     err = kstrtol(buf, 10, &val);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     write_temp8(dev, index, val);
>> +
>>       return count;
>>  }
>>
>> -static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
>> -                        char *buf)
>> +static int read_temp11(struct device *dev, int index)
>>  {
>> -     struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>> -     struct lm90_data *data = lm90_update_device(dev);
>>       int temp;
>> +     struct lm90_data *data = lm90_update_device(dev);
>>
> Another unnecessary variable reorder.
> 
>>       if (data->kind == adt7461)
>> -             temp = temp_from_u16_adt7461(data, data->temp11[attr->index]);
>> +             temp = temp_from_u16_adt7461(data, data->temp11[index]);
>>       else if (data->kind == max6646)
>> -             temp = temp_from_u16(data->temp11[attr->index]);
>> +             temp = temp_from_u16(data->temp11[index]);
>>       else
>> -             temp = temp_from_s16(data->temp11[attr->index]);
>> +             temp = temp_from_s16(data->temp11[index]);
>>
>>       /* +16 degrees offset for temp2 for the LM99 */
>> -     if (data->kind == lm99 &&  attr->index <= 2)
>> +     if (data->kind == lm99 &&  index <= 2)
>>               temp += 16000;
>>
>> +     return temp;
>> +}
>> +
>> +static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
>> +                        char *buf)
>> +{
>> +     struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>> +     int temp;
>> +
>> +     temp = read_temp11(dev, attr->index);
>> +
>>       return sprintf(buf, "%d\n", temp);
> 
> Same simplification as above.
> 
>>  }
>>
>> -static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>> -                       const char *buf, size_t count)
>> +static void write_temp11(struct device *dev, int nr, int index, long val)
>>  {
>>       struct {
>>               u8 high;
>> @@ -804,17 +828,8 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>>               { LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 1 }
>>       };
>>
>> -     struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>>       struct i2c_client *client = to_i2c_client(dev);
>>       struct lm90_data *data = i2c_get_clientdata(client);
>> -     int nr = attr->nr;
>> -     int index = attr->index;
>> -     long val;
>> -     int err;
>> -
>> -     err = kstrtol(buf, 10, &val);
>> -     if (err < 0)
>> -             return err;
>>
>>       /* +16 degrees offset for temp2 for the LM99 */
>>       if (data->kind == lm99 && index <= 2)
>> @@ -839,6 +854,23 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>>       lm90_select_remote_channel(client, data, 0);
>>
>>       mutex_unlock(&data->update_lock);
>> +}
>> +
>> +static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>> +                       const char *buf, size_t count)
>> +{
>> +     struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>> +     int nr = attr->nr;
>> +     int index = attr->index;
>> +     long val;
>> +     int err;
>> +
>> +     err = kstrtol(buf, 10, &val);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     write_temp11(dev, nr, index, val);
>> +
>>       return count;
>>  }
>>
>> --
>> 1.7.9.5
>>
>>

