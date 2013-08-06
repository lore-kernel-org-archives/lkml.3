Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3HFKMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:12:50 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11096 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3HFKMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:12:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 Aug 2013 03:11:08 -0700
Message-ID: <5200CC1C.1080000@nvidia.com>
Date: Tue, 6 Aug 2013 18:12:44 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4] hwmon: (lm90) split set&show temp as common codes
References: <1375783603-16747-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1375783603-16747-1-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I made a mistake, please ignore this patch.

Wei.

On 08/06/2013 06:06 PM, Wei Ni wrote:
> Split set&show temp codes as common functions, so we can use it directly when
> implement linux thermal framework.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/hwmon/lm90.c |  112 +++++++++++++++++++++++++++++++-------------------
>  1 file changed, 69 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index cdff742..8153b36 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -702,29 +702,34 @@ static u16 temp_to_u16_adt7461(struct lm90_data *data, long val)
>   * Sysfs stuff
>   */
>  
> -static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
> -			  char *buf)
> +static int read_temp8(struct device *dev, int index)
>  {
> -	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>  	struct lm90_data *data = lm90_update_device(dev);
>  	int temp;
>  
>  	if (data->kind == adt7461)
> -		temp = temp_from_u8_adt7461(data, data->temp8[attr->index]);
> +		temp = temp_from_u8_adt7461(data, data->temp8[index]);
>  	else if (data->kind == max6646)
> -		temp = temp_from_u8(data->temp8[attr->index]);
> +		temp = temp_from_u8(data->temp8[index]);
>  	else
> -		temp = temp_from_s8(data->temp8[attr->index]);
> +		temp = temp_from_s8(data->temp8[index]);
>  
>  	/* +16 degrees offset for temp2 for the LM99 */
> -	if (data->kind == lm99 && attr->index == 3)
> +	if (data->kind == lm99 && index == 3)
>  		temp += 16000;
>  
> -	return sprintf(buf, "%d\n", temp);
> +	return temp;
>  }
>  
> -static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
> -			 const char *buf, size_t count)
> +static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
> +			  char *buf)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +
> +	return sprintf(buf, "%d\n", read_temp8(dev, attr->index));
> +}
> +
> +static void write_temp8(struct device *dev, int index, long val)
>  {
>  	static const u8 reg[8] = {
>  		LM90_REG_W_LOCAL_LOW,
> @@ -737,60 +742,73 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>  		MAX6659_REG_W_REMOTE_EMERG,
>  	};
>  
> -	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct lm90_data *data = i2c_get_clientdata(client);
> -	int nr = attr->index;
> -	long val;
> -	int err;
> -
> -	err = kstrtol(buf, 10, &val);
> -	if (err < 0)
> -		return err;
>  
>  	/* +16 degrees offset for temp2 for the LM99 */
> -	if (data->kind == lm99 && attr->index == 3)
> +	if (data->kind == lm99 && index == 3)
>  		val -= 16000;
>  
>  	mutex_lock(&data->update_lock);
>  	if (data->kind == adt7461)
> -		data->temp8[nr] = temp_to_u8_adt7461(data, val);
> +		data->temp8[index] = temp_to_u8_adt7461(data, val);
>  	else if (data->kind == max6646)
> -		data->temp8[nr] = temp_to_u8(val);
> +		data->temp8[index] = temp_to_u8(val);
>  	else
> -		data->temp8[nr] = temp_to_s8(val);
> +		data->temp8[index] = temp_to_s8(val);
>  
> -	lm90_select_remote_channel(client, data, nr >= 6);
> -	i2c_smbus_write_byte_data(client, reg[nr], data->temp8[nr]);
> +	lm90_select_remote_channel(client, data, index >= 6);
> +	i2c_smbus_write_byte_data(client, reg[index], data->temp8[index]);
>  	lm90_select_remote_channel(client, data, 0);
>  
>  	mutex_unlock(&data->update_lock);
> +}
> +
> +static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
> +			 const char *buf, size_t count)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	int index = attr->index;
> +	long val;
> +	int err;
> +
> +	err = kstrtol(buf, 10, &val);
> +	if (err < 0)
> +		return err;
> +
> +	write_temp8(dev, index, val);
> +
>  	return count;
>  }
>  
> -static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
> -			   char *buf)
> +static int read_temp11(struct device *dev, int index)
>  {
> -	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>  	struct lm90_data *data = lm90_update_device(dev);
>  	int temp;
>  
>  	if (data->kind == adt7461)
> -		temp = temp_from_u16_adt7461(data, data->temp11[attr->index]);
> +		temp = temp_from_u16_adt7461(data, data->temp11[index]);
>  	else if (data->kind == max6646)
> -		temp = temp_from_u16(data->temp11[attr->index]);
> +		temp = temp_from_u16(data->temp11[index]);
>  	else
> -		temp = temp_from_s16(data->temp11[attr->index]);
> +		temp = temp_from_s16(data->temp11[index]);
>  
>  	/* +16 degrees offset for temp2 for the LM99 */
> -	if (data->kind == lm99 &&  attr->index <= 2)
> +	if (data->kind == lm99 &&  index <= 2)
>  		temp += 16000;
>  
> -	return sprintf(buf, "%d\n", temp);
> +	return temp;
>  }
>  
> -static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
> -			  const char *buf, size_t count)
> +static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
> +			   char *buf)
> +{
> +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
> +
> +	return sprintf(buf, "%d\n", read_temp11(dev, attr->index));
> +}
> +
> +static void write_temp11(struct device *dev, int nr, int index, long val)
>  {
>  	struct {
>  		u8 high;
> @@ -804,17 +822,8 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 1 }
>  	};
>  
> -	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct lm90_data *data = i2c_get_clientdata(client);
> -	int nr = attr->nr;
> -	int index = attr->index;
> -	long val;
> -	int err;
> -
> -	err = kstrtol(buf, 10, &val);
> -	if (err < 0)
> -		return err;
>  
>  	/* +16 degrees offset for temp2 for the LM99 */
>  	if (data->kind == lm99 && index <= 2)
> @@ -839,6 +848,23 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  	lm90_select_remote_channel(client, data, 0);
>  
>  	mutex_unlock(&data->update_lock);
> +}
> +
> +static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
> +			  const char *buf, size_t count)
> +{
> +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
> +	int nr = attr->nr;
> +	int index = attr->index;
> +	long val;
> +	int err;
> +
> +	err = kstrtol(buf, 10, &val);
> +	if (err < 0)
> +		return err;
> +
> +	write_temp11(dev, nr, index, val);
> +
>  	return count;
>  }
>  
> 

