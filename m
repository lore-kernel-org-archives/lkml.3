Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3GJSZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:25:13 -0400
Received: from mail-pb0-f65.google.com ([209.85.160.65]:32946 "EHLO
	mail-pb0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:10 -0400
Date: Wed, 10 Jul 2013 11:25:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, swarren@wwwdotorg.org, thierry.reding@gmail.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 3/3] hwmon: (lm90) use enums for the indexes of temp8
 and temp11
Message-ID: <20130710182508.GD22430@roeck-us.net>
References: <1373455539-2831-1-git-send-email-wni@nvidia.com>
 <1373455539-2831-4-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373455539-2831-4-git-send-email-wni@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 07:25:39PM +0800, Wei Ni wrote:
> Using enums for the indexes and nrs of temp8 and temp11.
> This make the code much more readable.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>

I don't really have a strong opinion on this one. Nice, but is it really worth it ? 
Jean, any comments ?

Guenter

> ---
>  drivers/hwmon/lm90.c |  179 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 114 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 88ff362..14e0b5b 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -310,6 +310,59 @@ static const struct lm90_params lm90_params[] = {
>  };
>  
>  /*
> + * TEMP8 register index
> + */
> +enum lm90_temp8_reg_index {
> +	TEMP8_LOCAL_LOW = 0,	/* 0: local low limit */
> +	TEMP8_LOCAL_HIGH,	/* 1: local high limit */
> +	TEMP8_LOCAL_CRIT,	/* 2: local critical limit */
> +	TEMP8_REMOTE_CRIT,	/* 3: remote critical limit */
> +	TEMP8_LOCAL_EMERG,	/* 4: local emergency limit
> +				 * (max6659 and max6695/96)
> +				 */
> +	TEMP8_REMOTE_EMERG,	/* 5: remote emergency limit
> +				 * (max6659 and max6695/96)
> +				 */
> +	TEMP8_REMOTE2_CRIT,	/* 6: remote 2 critical limit
> +				 * (max6695/96 only)
> +				 */
> +	TEMP8_REMOTE2_EMERG,	/* 7: remote 2 emergency limit
> +				 * (max6695/96 only)
> +				 */
> +	TEMP8_REG_NUM
> +};
> +
> +/*
> + * TEMP11 register index
> + */
> +enum lm90_temp11_reg_index {
> +	TEMP11_REMOTE_TEMP = 0,	/* 0: remote input */
> +	TEMP11_REMOTE_LOW,	/* 1: remote low limit */
> +	TEMP11_REMOTE_HIGH,	/* 2: remote high limit */
> +	TEMP11_REMOTE_OFFSET,	/* 3: remote offset
> +				 * (except max6646, max6657/58/59,
> +				 *  and max6695/96)
> +				 */
> +	TEMP11_LOCAL_TEMP,	/* 4: local input */
> +	TEMP11_REMOTE2_TEMP,	/* 5: remote 2 input (max6695/96 only) */
> +	TEMP11_REMOTE2_LOW,	/* 6: remote 2 low limit (max6695/96 only) */
> +	TEMP11_REMOTE2_HIGH,	/* 7: remote 2 high limit (max6695/96 only) */
> +	TEMP11_REG_NUM
> +};
> +
> +/*
> + * TEMP11 register NR
> + */
> +enum lm90_temp11_reg_nr {
> +	NR_CHAN_0_REMOTE_LOW = 0,	/* 0: channel 0, remote low limit */
> +	NR_CHAN_0_REMOTE_HIGH,		/* 1: channel 0, remote high limit */
> +	NR_CHAN_0_REMOTE_OFFSET,	/* 2: channel 0, remote offset */
> +	NR_CHAN_1_REMOTE_LOW,		/* 3: channel 1, remote low limit */
> +	NR_CHAN_1_REMOTE_HIGH,		/* 4: channel 1, remote high limit */
> +	NR_NUM				/* number of the NRs for temp11 */
> +};
> +
> +/*
>   * Client data (each client gets its own)
>   */
>  
> @@ -331,25 +384,8 @@ struct lm90_data {
>  	u8 reg_local_ext;	/* local extension register offset */
>  
>  	/* registers values */
> -	s8 temp8[8];	/* 0: local low limit
> -			 * 1: local high limit
> -			 * 2: local critical limit
> -			 * 3: remote critical limit
> -			 * 4: local emergency limit (max6659 and max6695/96)
> -			 * 5: remote emergency limit (max6659 and max6695/96)
> -			 * 6: remote 2 critical limit (max6695/96 only)
> -			 * 7: remote 2 emergency limit (max6695/96 only)
> -			 */
> -	s16 temp11[8];	/* 0: remote input
> -			 * 1: remote low limit
> -			 * 2: remote high limit
> -			 * 3: remote offset (except max6646, max6657/58/59,
> -			 *		     and max6695/96)
> -			 * 4: local input
> -			 * 5: remote 2 input (max6695/96 only)
> -			 * 6: remote 2 low limit (max6695/96 only)
> -			 * 7: remote 2 high limit (max6695/96 only)
> -			 */
> +	s8 temp8[TEMP8_REG_NUM];
> +	s16 temp11[TEMP11_REG_NUM];
>  	u8 temp_hyst;
>  	u16 alarms; /* bitvector (upper 8 bits for max6695/96) */
>  };
> @@ -491,37 +527,42 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>  		u8 alarms;
>  
>  		dev_dbg(&client->dev, "Updating lm90 data.\n");
> -		lm90_read_reg(client, LM90_REG_R_LOCAL_LOW, &data->temp8[0]);
> -		lm90_read_reg(client, LM90_REG_R_LOCAL_HIGH, &data->temp8[1]);
> -		lm90_read_reg(client, LM90_REG_R_LOCAL_CRIT, &data->temp8[2]);
> -		lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT, &data->temp8[3]);
> +		lm90_read_reg(client, LM90_REG_R_LOCAL_LOW,
> +				&data->temp8[TEMP8_LOCAL_LOW]);
> +		lm90_read_reg(client, LM90_REG_R_LOCAL_HIGH,
> +				&data->temp8[TEMP8_LOCAL_HIGH]);
> +		lm90_read_reg(client, LM90_REG_R_LOCAL_CRIT,
> +				&data->temp8[TEMP8_LOCAL_CRIT]);
> +		lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT,
> +				&data->temp8[TEMP8_REMOTE_CRIT]);
>  		lm90_read_reg(client, LM90_REG_R_TCRIT_HYST, &data->temp_hyst);
>  
>  		if (data->reg_local_ext) {
>  			lm90_read16(client, LM90_REG_R_LOCAL_TEMP,
>  				    data->reg_local_ext,
> -				    &data->temp11[4]);
> +				    &data->temp11[TEMP11_LOCAL_TEMP]);
>  		} else {
>  			if (lm90_read_reg(client, LM90_REG_R_LOCAL_TEMP,
>  					  &h) == 0)
> -				data->temp11[4] = h << 8;
> +				data->temp11[TEMP11_LOCAL_TEMP] = h << 8;
>  		}
>  		lm90_read16(client, LM90_REG_R_REMOTE_TEMPH,
> -			    LM90_REG_R_REMOTE_TEMPL, &data->temp11[0]);
> +			LM90_REG_R_REMOTE_TEMPL,
> +			&data->temp11[TEMP11_REMOTE_TEMP]);
>  
>  		if (lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH, &h) == 0) {
> -			data->temp11[1] = h << 8;
> +			data->temp11[TEMP11_REMOTE_LOW] = h << 8;
>  			if ((data->flags & LM90_HAVE_REM_LIMIT_EXT)
>  			 && lm90_read_reg(client, LM90_REG_R_REMOTE_LOWL,
>  					  &l) == 0)
> -				data->temp11[1] |= l;
> +				data->temp11[TEMP11_REMOTE_LOW] |= l;
>  		}
>  		if (lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHH, &h) == 0) {
> -			data->temp11[2] = h << 8;
> +			data->temp11[TEMP11_REMOTE_HIGH] = h << 8;
>  			if ((data->flags & LM90_HAVE_REM_LIMIT_EXT)
>  			 && lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHL,
>  					  &l) == 0)
> -				data->temp11[2] |= l;
> +				data->temp11[TEMP11_REMOTE_HIGH] |= l;
>  		}
>  
>  		if (data->flags & LM90_HAVE_OFFSET) {
> @@ -529,13 +570,14 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>  					  &h) == 0
>  			 && lm90_read_reg(client, LM90_REG_R_REMOTE_OFFSL,
>  					  &l) == 0)
> -				data->temp11[3] = (h << 8) | l;
> +				data->temp11[TEMP11_REMOTE_OFFSET] =
> +								(h << 8) | l;
>  		}
>  		if (data->flags & LM90_HAVE_EMERGENCY) {
>  			lm90_read_reg(client, MAX6659_REG_R_LOCAL_EMERG,
> -				      &data->temp8[4]);
> +				      &data->temp8[TEMP8_LOCAL_EMERG]);
>  			lm90_read_reg(client, MAX6659_REG_R_REMOTE_EMERG,
> -				      &data->temp8[5]);
> +				      &data->temp8[TEMP8_REMOTE_EMERG]);
>  		}
>  		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
>  		data->alarms = alarms;	/* save as 16 bit value */
> @@ -543,15 +585,16 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>  		if (data->kind == max6696) {
>  			lm90_select_remote_channel(client, data, 1);
>  			lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT,
> -				      &data->temp8[6]);
> +				      &data->temp8[TEMP8_REMOTE2_CRIT]);
>  			lm90_read_reg(client, MAX6659_REG_R_REMOTE_EMERG,
> -				      &data->temp8[7]);
> +				      &data->temp8[TEMP8_REMOTE2_EMERG]);
>  			lm90_read16(client, LM90_REG_R_REMOTE_TEMPH,
> -				    LM90_REG_R_REMOTE_TEMPL, &data->temp11[5]);
> +					LM90_REG_R_REMOTE_TEMPL,
> +					&data->temp11[TEMP11_REMOTE2_TEMP]);
>  			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH, &h))
> -				data->temp11[6] = h << 8;
> +				data->temp11[TEMP11_REMOTE2_LOW] = h << 8;
>  			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHH, &h))
> -				data->temp11[7] = h << 8;
> +				data->temp11[TEMP11_REMOTE2_HIGH] = h << 8;
>  			lm90_select_remote_channel(client, data, 0);
>  
>  			if (!lm90_read_reg(client, MAX6696_REG_R_STATUS2,
> @@ -748,7 +791,7 @@ static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
>  
>  static void write_temp8(struct device *dev, int index, long val)
>  {
> -	static const u8 reg[8] = {
> +	static const u8 reg[TEMP8_REG_NUM] = {
>  		LM90_REG_W_LOCAL_LOW,
>  		LM90_REG_W_LOCAL_HIGH,
>  		LM90_REG_W_LOCAL_CRIT,
> @@ -834,7 +877,7 @@ static void write_temp11(struct device *dev, int nr, int index, long val)
>  		u8 high;
>  		u8 low;
>  		int channel;
> -	} reg[5] = {
> +	} reg[NR_NUM] = {
>  		{ LM90_REG_W_REMOTE_LOWH, LM90_REG_W_REMOTE_LOWL, 0 },
>  		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 0 },
>  		{ LM90_REG_W_REMOTE_OFFSH, LM90_REG_W_REMOTE_OFFSL, 0 },
> @@ -925,11 +968,12 @@ static ssize_t set_temphyst(struct device *dev, struct device_attribute *dummy,
>  
>  	mutex_lock(&data->update_lock);
>  	if (data->kind == adt7461)
> -		temp = temp_from_u8_adt7461(data, data->temp8[2]);
> +		temp = temp_from_u8_adt7461(data,
> +					data->temp8[TEMP8_LOCAL_CRIT]);
>  	else if (data->kind == max6646)
> -		temp = temp_from_u8(data->temp8[2]);
> +		temp = temp_from_u8(data->temp8[TEMP8_LOCAL_CRIT]);
>  	else
> -		temp = temp_from_s8(data->temp8[2]);
> +		temp = temp_from_s8(data->temp8[TEMP8_LOCAL_CRIT]);
>  
>  	data->temp_hyst = hyst_to_reg(temp - val);
>  	i2c_smbus_write_byte_data(client, LM90_REG_W_TCRIT_HYST,
> @@ -983,25 +1027,28 @@ static ssize_t set_update_interval(struct device *dev,
>  	return count;
>  }
>  
> -static SENSOR_DEVICE_ATTR_2(temp1_input, S_IRUGO, show_temp11, NULL, 0, 4);
> -static SENSOR_DEVICE_ATTR_2(temp2_input, S_IRUGO, show_temp11, NULL, 0, 0);
> +static SENSOR_DEVICE_ATTR_2(temp1_input, S_IRUGO, show_temp11, NULL,
> +	NR_CHAN_0_REMOTE_LOW, TEMP11_LOCAL_TEMP);
> +static SENSOR_DEVICE_ATTR_2(temp2_input, S_IRUGO, show_temp11, NULL,
> +	NR_CHAN_0_REMOTE_LOW, TEMP11_REMOTE_TEMP);
>  static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 0);
> +	set_temp8, TEMP8_LOCAL_LOW);
>  static SENSOR_DEVICE_ATTR_2(temp2_min, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 0, 1);
> +	set_temp11, NR_CHAN_0_REMOTE_LOW, TEMP11_REMOTE_LOW);
>  static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 1);
> +	set_temp8, TEMP8_LOCAL_HIGH);
>  static SENSOR_DEVICE_ATTR_2(temp2_max, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 1, 2);
> +	set_temp11, NR_CHAN_0_REMOTE_HIGH, TEMP11_REMOTE_HIGH);
>  static SENSOR_DEVICE_ATTR(temp1_crit, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 2);
> +	set_temp8, TEMP8_LOCAL_CRIT);
>  static SENSOR_DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 3);
> +	set_temp8, TEMP8_REMOTE_CRIT);
>  static SENSOR_DEVICE_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO, show_temphyst,
> -	set_temphyst, 2);
> -static SENSOR_DEVICE_ATTR(temp2_crit_hyst, S_IRUGO, show_temphyst, NULL, 3);
> +	set_temphyst, TEMP8_LOCAL_CRIT);
> +static SENSOR_DEVICE_ATTR(temp2_crit_hyst, S_IRUGO, show_temphyst, NULL,
> +	TEMP8_REMOTE_CRIT);
>  static SENSOR_DEVICE_ATTR_2(temp2_offset, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 2, 3);
> +	set_temp11, NR_CHAN_0_REMOTE_OFFSET, TEMP11_REMOTE_OFFSET);
>  
>  /* Individual alarm files */
>  static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL, 0);
> @@ -1049,13 +1096,13 @@ static const struct attribute_group lm90_group = {
>   * Additional attributes for devices with emergency sensors
>   */
>  static SENSOR_DEVICE_ATTR(temp1_emergency, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 4);
> +	set_temp8, TEMP8_LOCAL_EMERG);
>  static SENSOR_DEVICE_ATTR(temp2_emergency, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 5);
> +	set_temp8, TEMP8_REMOTE_EMERG);
>  static SENSOR_DEVICE_ATTR(temp1_emergency_hyst, S_IRUGO, show_temphyst,
> -			  NULL, 4);
> +			  NULL, TEMP8_LOCAL_EMERG);
>  static SENSOR_DEVICE_ATTR(temp2_emergency_hyst, S_IRUGO, show_temphyst,
> -			  NULL, 5);
> +			  NULL, TEMP8_REMOTE_EMERG);
>  
>  static struct attribute *lm90_emergency_attributes[] = {
>  	&sensor_dev_attr_temp1_emergency.dev_attr.attr,
> @@ -1085,18 +1132,20 @@ static const struct attribute_group lm90_emergency_alarm_group = {
>  /*
>   * Additional attributes for devices with 3 temperature sensors
>   */
> -static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp11, NULL, 0, 5);
> +static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp11, NULL,
> +	NR_CHAN_0_REMOTE_LOW, TEMP11_REMOTE2_TEMP);
>  static SENSOR_DEVICE_ATTR_2(temp3_min, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 3, 6);
> +	set_temp11, NR_CHAN_1_REMOTE_LOW, TEMP11_REMOTE2_LOW);
>  static SENSOR_DEVICE_ATTR_2(temp3_max, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 4, 7);
> +	set_temp11, NR_CHAN_1_REMOTE_HIGH, TEMP11_REMOTE2_HIGH);
>  static SENSOR_DEVICE_ATTR(temp3_crit, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 6);
> -static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL, 6);
> +	set_temp8, TEMP8_REMOTE2_CRIT);
> +static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL,
> +	TEMP8_REMOTE2_CRIT);
>  static SENSOR_DEVICE_ATTR(temp3_emergency, S_IWUSR | S_IRUGO, show_temp8,
> -	set_temp8, 7);
> +	set_temp8, TEMP8_REMOTE2_EMERG);
>  static SENSOR_DEVICE_ATTR(temp3_emergency_hyst, S_IRUGO, show_temphyst,
> -			  NULL, 7);
> +			  NULL, TEMP8_REMOTE2_EMERG);
>  
>  static SENSOR_DEVICE_ATTR(temp3_crit_alarm, S_IRUGO, show_alarm, NULL, 9);
>  static SENSOR_DEVICE_ATTR(temp3_fault, S_IRUGO, show_alarm, NULL, 10);
> -- 
> 1.7.9.5
> 
> 
