Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaEKWka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 18:40:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50185 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbaEKWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 18:40:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <536FFC55.2080009@roeck-us.net>
Date: Sun, 11 May 2014 15:40:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atx.name>, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc1412
References: <20140511130023.GA501@dashie>
In-Reply-To: <20140511130023.GA501@dashie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 06:00 AM, Josef Gajdusek wrote:
> Adds support for emc1412.
>
It is customary to explain the difference to already supported chips
and what changes were made to support the new chip(s).

> ---
> diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
> index 90ec117..47a98a7 100644
> --- a/drivers/hwmon/emc1403.c
> +++ b/drivers/hwmon/emc1403.c
> @@ -40,7 +40,7 @@
>
>   struct thermal_data {
>   	struct i2c_client *client;
> -	const struct attribute_group *groups[3];
> +	const struct attribute_group *groups[2];

The purpose of having more than one group is to simplify support for optional
features while at the same time avoiding duplication. This is why there used to be
two groups (plus an unused entry for list termination).

Separating and duplicating all attributes into one group per supported chip
type defeats that purpose. Please don't do that, and revert the related changes.

This should not be reduced to two entries, but increased to four or even five;
see below.

>   	struct mutex mutex;
>   	/*
>   	 * Cache the hyst value so we don't keep re-reading it. In theory
> @@ -252,6 +252,28 @@ static SENSOR_DEVICE_ATTR(temp4_crit_hyst, S_IRUGO | S_IWUSR,
>   static SENSOR_DEVICE_ATTR_2(power_state, S_IRUGO | S_IWUSR,
>   	show_bit, store_bit, 0x03, 0x40);
>
> +
> +static struct attribute *emc1412_attrs[] = {
> +	&sensor_dev_attr_temp1_min.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	&sensor_dev_attr_temp1_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
> +
> +	&sensor_dev_attr_temp2_min.dev_attr.attr,
> +	&sensor_dev_attr_temp2_max.dev_attr.attr,
> +	&sensor_dev_attr_temp2_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp2_input.dev_attr.attr,
> +	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
> +
> +	&sensor_dev_attr_power_state.dev_attr.attr,
> +	NULL
> +};
> +
This should become the core attribute group, ie the list of attributes supported
by all chips.

The EMC1412 does support alarms, so I would suggest to add another optional
group for EMC1412 alarms (needed because the alarm register and bits are not
compatible to the registers/bits used by other chips supported by this driver).

> +static const struct attribute_group emc1412_group = {
> +		.attrs = emc1412_attrs,
> +};
> +
>   static struct attribute *emc1403_attrs[] = {
>   	&sensor_dev_attr_temp1_min.dev_attr.attr,
>   	&sensor_dev_attr_temp1_max.dev_attr.attr,
> @@ -261,6 +283,7 @@ static struct attribute *emc1403_attrs[] = {
>   	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
> +
>   	&sensor_dev_attr_temp2_min.dev_attr.attr,
>   	&sensor_dev_attr_temp2_max.dev_attr.attr,
>   	&sensor_dev_attr_temp2_crit.dev_attr.attr,
> @@ -269,6 +292,7 @@ static struct attribute *emc1403_attrs[] = {
>   	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
> +
>   	&sensor_dev_attr_temp3_min.dev_attr.attr,
>   	&sensor_dev_attr_temp3_max.dev_attr.attr,
>   	&sensor_dev_attr_temp3_crit.dev_attr.attr,
> @@ -277,6 +301,7 @@ static struct attribute *emc1403_attrs[] = {
>   	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
> +
>   	&sensor_dev_attr_power_state.dev_attr.attr,
>   	NULL
>   };

Modify this group to list the attributes only supported by EMC1403
and compatible chips (on top of the core or emc1412 group).

> @@ -286,6 +311,33 @@ static const struct attribute_group emc1403_group = {
>   };
>
>   static struct attribute *emc1404_attrs[] = {
> +	&sensor_dev_attr_temp1_min.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	&sensor_dev_attr_temp1_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp1_crit_hyst.dev_attr.attr,
> +
> +	&sensor_dev_attr_temp2_min.dev_attr.attr,
> +	&sensor_dev_attr_temp2_max.dev_attr.attr,
> +	&sensor_dev_attr_temp2_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp2_input.dev_attr.attr,
> +	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp2_crit_hyst.dev_attr.attr,
> +
> +	&sensor_dev_attr_temp3_min.dev_attr.attr,
> +	&sensor_dev_attr_temp3_max.dev_attr.attr,
> +	&sensor_dev_attr_temp3_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp3_input.dev_attr.attr,
> +	&sensor_dev_attr_temp3_min_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
> +
This is exactly what you don't want to do; it is unnecessary duplication.
There was a reason for having the second group on top of the first one,
as explained above.

>   	&sensor_dev_attr_temp4_min.dev_attr.attr,
>   	&sensor_dev_attr_temp4_max.dev_attr.attr,
>   	&sensor_dev_attr_temp4_crit.dev_attr.attr,
> @@ -294,6 +346,8 @@ static struct attribute *emc1404_attrs[] = {
>   	&sensor_dev_attr_temp4_max_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp4_crit_alarm.dev_attr.attr,
>   	&sensor_dev_attr_temp4_crit_hyst.dev_attr.attr,
> +
> +	&sensor_dev_attr_power_state.dev_attr.attr,
>   	NULL
>   };
>
> @@ -301,11 +355,13 @@ static const struct attribute_group emc1404_group = {
>   	.attrs = emc1404_attrs,
>   };
>
> +
> +

Unnecessary empty lines and unnecessary whitespace change.

>   static int emc1403_detect(struct i2c_client *client,
>   			struct i2c_board_info *info)
>   {
>   	int id;
> -	/* Check if thermal chip is SMSC and EMC1403 or EMC1423 */
> +	/* Check whether the chip is SMSC and get its type */

This change makes the comment pretty much worthless. It used to describe
what the function is doing, which is no longer the case after your change.

>
>   	id = i2c_smbus_read_byte_data(client, THERMAL_SMSC_ID_REG);
>   	if (id != 0x5d)
> @@ -313,6 +369,9 @@ static int emc1403_detect(struct i2c_client *client,
>
>   	id = i2c_smbus_read_byte_data(client, THERMAL_PID_REG);
>   	switch (id) {
> +	case 0x20:
> +		strlcpy(info->type, "emc1412", I2C_NAME_SIZE);
> +		break;
>   	case 0x21:
>   		strlcpy(info->type, "emc1403", I2C_NAME_SIZE);
>   		break;
> @@ -330,9 +389,9 @@ static int emc1403_detect(struct i2c_client *client,
>   	}
>
>   	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
> -	if (id != 0x01)
> +	if (id != 0x01 && id != 0x04) {
>   		return -ENODEV;

This should be a separate patch, as it applies to emc1403/emc1404 as well,
so we can backport it into -stable.

> -
> +	}
>   	return 0;
>   }
>
> @@ -351,9 +410,17 @@ static int emc1403_probe(struct i2c_client *client,
>   	mutex_init(&data->mutex);
>   	data->hyst_valid = jiffies - 1;		/* Expired */
>
> -	data->groups[0] = &emc1403_group;
> -	if (id->driver_data)
> -		data->groups[1] = &emc1404_group;
> +	switch (id->driver_data) {
> +	case 0:
> +		data->groups[0] = &emc1412_group;
> +		break;
> +	case 1:
> +		data->groups[0] = &emc1403_group;
> +		break;
> +	case 2:
> +		data->groups[0] = &emc1404_group;
> +		break;
> +	}
>
Not acceptable. Again, there is a reason for having multiple attribute groups.

>   	hwmon_dev = hwmon_device_register_with_groups(&client->dev,
>   						      client->name, data,
> @@ -366,14 +433,19 @@ static int emc1403_probe(struct i2c_client *client,
>   }
>
>   static const unsigned short emc1403_address_list[] = {
> -	0x18, 0x29, 0x4c, 0x4d, I2C_CLIENT_END
> +	/* emc1403/emc1404/emc1423/emc1424 */
> +	0x4c, 0x4d, 0x18, 0x29,
> +	/* emc1412 */
> +	0x5c, 0x4c, 0x6c, 0x1c, 0x3c, I2C_CLIENT_END

No duplication of addresses, and addresses are by convention in order.
Jean, any addresses which should not be scanned ?

>   };
>
> +/* Last number in name indicates the amount of channels */
>   static const struct i2c_device_id emc1403_idtable[] = {
> -	{ "emc1403", 0 },
> -	{ "emc1404", 1 },
> -	{ "emc1423", 0 },
> -	{ "emc1424", 1 },
> +	{ "emc1412", 0 },
> +	{ "emc1403", 1 },
> +	{ "emc1423", 1 },
> +	{ "emc1404", 2 },
> +	{ "emc1424", 2 },

It may be time to introduce an enum for supported chip variants.
Also, the list is by custom in alphabetical order.

Guenter

