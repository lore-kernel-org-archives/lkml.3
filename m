Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522AbaHZMRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:17:41 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:55652 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaHZMRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:17:39 -0400
Date: Tue, 26 Aug 2014 08:17:31 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, khali@linux-fr.org,
        linux@roeck-us.net, swarren@wwwdotorg.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
Message-ID: <20140826121729.GC15219@developer>
References: <1408948188-4181-1-git-send-email-wni@nvidia.com>
 <1408948188-4181-2-git-send-email-wni@nvidia.com>
 <53FB2AAA.30601@nvidia.com>
 <53FBF09F.8050502@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FBF09F.8050502@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 10:27:43AM +0800, Wei Ni wrote:
> On 08/25/2014 08:23 PM, Mikko Perttunen wrote:
> > FWIW, please fix the authorship information for next version.
> 
> Sorry, I didn't get your point, did you mean I should remove the line
> "From: lightning314 <wni@nvidia.com>" ? Yes I made a mistake on it, I
> will remove it in next version.

No Wei, don't remove the author line. Well, based on email, it is your
patch, so, removing may satisfy. 

But the point is you should use meaninful names in tags like From and
Signed off by. "lightning314" sounds quite cryptic or even a nick name.
You must use real names there, such as "Wei Ni".

> 
> Thanks.
> Wei.
> 
> > 
> > Cheers,
> > Mikko
> > 
> > On 25/08/14 09:29, Wei Ni wrote:
> >> From: lightning314 <wni@nvidia.com>
> >>
> >> Split set&show temp codes as common functions, so we can use it
> >> directly when implement linux thermal framework.
> >> And handle error return value for the lm90_select_remote_channel
> >> and write_tempx, then set_temp8 and set_temp11 could return it
> >> to user-space.
> >>
> >> Signed-off-by: Wei Ni <wni@nvidia.com>
> >> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> >> ---
> >>   drivers/hwmon/lm90.c | 164
> >> ++++++++++++++++++++++++++++++++++-----------------
> >>   1 file changed, 109 insertions(+), 55 deletions(-)
> >>
> >> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> >> index c9ff08d..cb33dcf 100644
> >> --- a/drivers/hwmon/lm90.c
> >> +++ b/drivers/hwmon/lm90.c
> >> @@ -473,20 +473,23 @@ static int lm90_read16(struct i2c_client
> >> *client, u8 regh, u8 regl, u16 *value)
> >>    * various registers have different meanings as a result of selecting a
> >>    * non-default remote channel.
> >>    */
> >> -static inline void lm90_select_remote_channel(struct i2c_client *client,
> >> -                          struct lm90_data *data,
> >> -                          int channel)
> >> +static inline int lm90_select_remote_channel(struct i2c_client *client,
> >> +                         struct lm90_data *data,
> >> +                         int channel)
> >>   {
> >>       u8 config;
> >> +    int err = 0;
> >>
> >>       if (data->kind == max6696) {
> >>           lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
> >>           config &= ~0x08;
> >>           if (channel)
> >>               config |= 0x08;
> >> -        i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
> >> -                      config);
> >> +        err = i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
> >> +                        config);
> >>       }
> >> +
> >> +    return err;
> >>   }
> >>
> >>   /*
> >> @@ -759,29 +762,34 @@ static u16 temp_to_u16_adt7461(struct lm90_data
> >> *data, long val)
> >>    * Sysfs stuff
> >>    */
> >>
> >> -static ssize_t show_temp8(struct device *dev, struct device_attribute
> >> *devattr,
> >> -              char *buf)
> >> +static int read_temp8(struct device *dev, int index)
> >>   {
> >> -    struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> >>       struct lm90_data *data = lm90_update_device(dev);
> >>       int temp;
> >>
> >>       if (data->kind == adt7461 || data->kind == tmp451)
> >> -        temp = temp_from_u8_adt7461(data, data->temp8[attr->index]);
> >> +        temp = temp_from_u8_adt7461(data, data->temp8[index]);
> >>       else if (data->kind == max6646)
> >> -        temp = temp_from_u8(data->temp8[attr->index]);
> >> +        temp = temp_from_u8(data->temp8[index]);
> >>       else
> >> -        temp = temp_from_s8(data->temp8[attr->index]);
> >> +        temp = temp_from_s8(data->temp8[index]);
> >>
> >>       /* +16 degrees offset for temp2 for the LM99 */
> >> -    if (data->kind == lm99 && attr->index == 3)
> >> +    if (data->kind == lm99 && index == 3)
> >>           temp += 16000;
> >>
> >> -    return sprintf(buf, "%d\n", temp);
> >> +    return temp;
> >>   }
> >>
> >> -static ssize_t set_temp8(struct device *dev, struct device_attribute
> >> *devattr,
> >> -             const char *buf, size_t count)
> >> +static ssize_t show_temp8(struct device *dev, struct device_attribute
> >> *devattr,
> >> +              char *buf)
> >> +{
> >> +    struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> >> +
> >> +    return sprintf(buf, "%d\n", read_temp8(dev, attr->index));
> >> +}
> >> +
> >> +static int write_temp8(struct device *dev, int index, long val)
> >>   {
> >>       static const u8 reg[TEMP8_REG_NUM] = {
> >>           LM90_REG_W_LOCAL_LOW,
> >> @@ -794,60 +802,79 @@ static ssize_t set_temp8(struct device *dev,
> >> struct device_attribute *devattr,
> >>           MAX6659_REG_W_REMOTE_EMERG,
> >>       };
> >>
> >> -    struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> >>       struct lm90_data *data = dev_get_drvdata(dev);
> >>       struct i2c_client *client = data->client;
> >> -    int nr = attr->index;
> >> -    long val;
> >>       int err;
> >>
> >> -    err = kstrtol(buf, 10, &val);
> >> -    if (err < 0)
> >> -        return err;
> >> -
> >>       /* +16 degrees offset for temp2 for the LM99 */
> >> -    if (data->kind == lm99 && attr->index == 3)
> >> +    if (data->kind == lm99 && index == 3)
> >>           val -= 16000;
> >>
> >>       mutex_lock(&data->update_lock);
> >>       if (data->kind == adt7461 || data->kind == tmp451)
> >> -        data->temp8[nr] = temp_to_u8_adt7461(data, val);
> >> +        data->temp8[index] = temp_to_u8_adt7461(data, val);
> >>       else if (data->kind == max6646)
> >> -        data->temp8[nr] = temp_to_u8(val);
> >> +        data->temp8[index] = temp_to_u8(val);
> >>       else
> >> -        data->temp8[nr] = temp_to_s8(val);
> >> -
> >> -    lm90_select_remote_channel(client, data, nr >= 6);
> >> -    i2c_smbus_write_byte_data(client, reg[nr], data->temp8[nr]);
> >> -    lm90_select_remote_channel(client, data, 0);
> >> +        data->temp8[index] = temp_to_s8(val);
> >>
> >> +    if ((err = lm90_select_remote_channel(client, data, index >= 6)) ||
> >> +        (err = i2c_smbus_write_byte_data(client, reg[index],
> >> +                         data->temp8[index])) ||
> >> +        (err = lm90_select_remote_channel(client, data, 0)))
> >> +        dev_err(dev, "write_temp8 failed, err %d\n", err);
> >>       mutex_unlock(&data->update_lock);
> >> +
> >> +    return err;
> >> +}
> >> +
> >> +static ssize_t set_temp8(struct device *dev, struct device_attribute
> >> *devattr,
> >> +             const char *buf, size_t count)
> >> +{
> >> +    struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> >> +    int index = attr->index;
> >> +    long val;
> >> +    int err;
> >> +
> >> +    err = kstrtol(buf, 10, &val);
> >> +    if (err < 0)
> >> +        return err;
> >> +
> >> +    err = write_temp8(dev, index, val);
> >> +    if (err < 0)
> >> +        return err;
> >> +
> >>       return count;
> >>   }
> >>
> >> -static ssize_t show_temp11(struct device *dev, struct
> >> device_attribute *devattr,
> >> -               char *buf)
> >> +static int read_temp11(struct device *dev, int index)
> >>   {
> >> -    struct sensor_device_attribute_2 *attr =
> >> to_sensor_dev_attr_2(devattr);
> >>       struct lm90_data *data = lm90_update_device(dev);
> >>       int temp;
> >>
> >>       if (data->kind == adt7461 || data->kind == tmp451)
> >> -        temp = temp_from_u16_adt7461(data, data->temp11[attr->index]);
> >> +        temp = temp_from_u16_adt7461(data, data->temp11[index]);
> >>       else if (data->kind == max6646)
> >> -        temp = temp_from_u16(data->temp11[attr->index]);
> >> +        temp = temp_from_u16(data->temp11[index]);
> >>       else
> >> -        temp = temp_from_s16(data->temp11[attr->index]);
> >> +        temp = temp_from_s16(data->temp11[index]);
> >>
> >>       /* +16 degrees offset for temp2 for the LM99 */
> >> -    if (data->kind == lm99 &&  attr->index <= 2)
> >> +    if (data->kind == lm99 && index <= 2)
> >>           temp += 16000;
> >>
> >> -    return sprintf(buf, "%d\n", temp);
> >> +    return temp;
> >>   }
> >>
> >> -static ssize_t set_temp11(struct device *dev, struct device_attribute
> >> *devattr,
> >> -              const char *buf, size_t count)
> >> +static ssize_t show_temp11(struct device *dev, struct
> >> device_attribute *devattr,
> >> +               char *buf)
> >> +{
> >> +    struct sensor_device_attribute_2 *attr =
> >> to_sensor_dev_attr_2(devattr);
> >> +
> >> +    return sprintf(buf, "%d\n", read_temp11(dev, attr->index));
> >> +}
> >> +
> >> +static int write_temp11(struct device *dev, int nr, int index, long val)
> >>   {
> >>       struct {
> >>           u8 high;
> >> @@ -861,18 +888,10 @@ static ssize_t set_temp11(struct device *dev,
> >> struct device_attribute *devattr,
> >>           { LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 1 }
> >>       };
> >>
> >> -    struct sensor_device_attribute_2 *attr =
> >> to_sensor_dev_attr_2(devattr);
> >>       struct lm90_data *data = dev_get_drvdata(dev);
> >>       struct i2c_client *client = data->client;
> >> -    int nr = attr->nr;
> >> -    int index = attr->index;
> >> -    long val;
> >>       int err;
> >>
> >> -    err = kstrtol(buf, 10, &val);
> >> -    if (err < 0)
> >> -        return err;
> >> -
> >>       /* +16 degrees offset for temp2 for the LM99 */
> >>       if (data->kind == lm99 && index <= 2)
> >>           val -= 16000;
> >> @@ -887,15 +906,50 @@ static ssize_t set_temp11(struct device *dev,
> >> struct device_attribute *devattr,
> >>       else
> >>           data->temp11[index] = temp_to_s8(val) << 8;
> >>
> >> -    lm90_select_remote_channel(client, data, reg[nr].channel);
> >> -    i2c_smbus_write_byte_data(client, reg[nr].high,
> >> -                  data->temp11[index] >> 8);
> >> -    if (data->flags & LM90_HAVE_REM_LIMIT_EXT)
> >> -        i2c_smbus_write_byte_data(client, reg[nr].low,
> >> -                      data->temp11[index] & 0xff);
> >> -    lm90_select_remote_channel(client, data, 0);
> >> +    err = lm90_select_remote_channel(client, data, reg[nr].channel);
> >> +    if (err)
> >> +        goto error;
> >> +
> >> +    err = i2c_smbus_write_byte_data(client, reg[nr].high,
> >> +                    data->temp11[index] >> 8);
> >> +    if (err)
> >> +        goto error;
> >> +
> >> +    if (data->flags & LM90_HAVE_REM_LIMIT_EXT) {
> >> +        err = i2c_smbus_write_byte_data(client, reg[nr].low,
> >> +                        data->temp11[index] & 0xff);
> >> +        if (err)
> >> +            goto error;
> >> +    }
> >> +
> >> +    err = lm90_select_remote_channel(client, data, 0);
> >> +
> >> +error:
> >> +    if (err)
> >> +        dev_err(dev, "write_temp11 failed, err %d\n", err);
> >>
> >>       mutex_unlock(&data->update_lock);
> >> +
> >> +    return err;
> >> +}
> >> +
> >> +static ssize_t set_temp11(struct device *dev, struct device_attribute
> >> *devattr,
> >> +              const char *buf, size_t count)
> >> +{
> >> +    struct sensor_device_attribute_2 *attr =
> >> to_sensor_dev_attr_2(devattr);
> >> +    int nr = attr->nr;
> >> +    int index = attr->index;
> >> +    long val;
> >> +    int err;
> >> +
> >> +    err = kstrtol(buf, 10, &val);
> >> +    if (err < 0)
> >> +        return err;
> >> +
> >> +    err = write_temp11(dev, nr, index, val);
> >> +    if (err < 0)
> >> +        return err;
> >> +
> >>       return count;
> >>   }
> >>
> >>
> 
