Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3ATJvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 04:51:41 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:41987 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304Ab3ATJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 04:51:39 -0500
Message-ID: <50FBBE7D.7040102@metafoo.de>
Date: Sun, 20 Jan 2013 10:53:01 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: bq27x00_battery: Export all battery registers
 via sysfs
References: <1358604104-7667-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1358604104-7667-1-git-send-email-pali.rohar@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2013 03:01 PM, Pali Rohár wrote:
> bq27xxx batteries have a lot of properties, more than power_supply interface.
> Some of them can be usefull for userspace applications (like CI bit) but
> does not make sense to add bq specified property to power_supply interface.
> When bq27x00_battery is not loaded userspace application (like i2cget) can
> use /dev/i2c-* interface for raw access. But when kernel module is attached
> to i2c device, userspace applications cannot access it via /dev/i2c-*.

You can still access it if you use the I2C_SLAVE_FORCE flag. This is a bit
ugly, but I'd rather see an ugly hack in userspace than in kernel space.

> Also it is not usefull for userspace to unload module before reading values
> form /dev/i2c-* and then load it again.
> 
> This patch exporting all battery registers to sysfs entry "registers" in
> battery power_supply directory. Format is "register=value" on separate line.
> Because length of registers are different for each bq battery more for loops
> are needed.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/power/bq27x00_battery.c |   98 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 95 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 7087d0d..af0f68f 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -690,6 +690,90 @@ static void bq27x00_external_power_changed(struct power_supply *psy)
>  	schedule_delayed_work(&di->work, 0);
>  }
>  
> +/* code for register device access via sysfs */
> +
> +static ssize_t bq27x00_battery_sysfs_print_reg(struct bq27x00_device_info *di,
> +					u8 reg, bool single, char *buf)
> +{
> +	int ret = bq27x00_read(di, reg, single);
> +	if (ret < 0)
> +		return sprintf(buf, "%#.2x=error %d\n", reg, ret);
> +	else
> +		return sprintf(buf, "%#.2x=%#.2x\n", reg, ret);
> +}
> +
> +static ssize_t bq27x00_battery_sysfs_show_registers(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	struct bq27x00_device_info *di = container_of(psy,
> +						struct bq27x00_device_info,
> +						bat);
> +	u8 reg;
> +	ssize_t ret = 0;
> +
> +	switch (di->chip) {
> +
> +	case BQ27000:
> +		for (reg=0x00; reg<=0x01; reg+=1)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
> +		for (reg=0x02; reg<=0x08; reg+=2)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
> +		for (reg=0x0A; reg<=0x0B; reg+=1)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
> +		for (reg=0x0C; reg<=0x2A; reg+=2)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
> +		for (reg=0x2C; reg<=0x7F; reg+=1)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
> +		break;
> +
> +	case BQ27500:
> +		for (reg=0x00; reg<=0x2C; reg+=2)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
> +		for (reg=0x2E; reg<=0x3B; reg+=1)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
> +		for (reg=0x3C; reg<=0x3C; reg+=2)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
> +		for (reg=0x3E; reg<=0x7F; reg+=1)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
> +		break;
> +
> +	case BQ27425:
> +		for (reg=0x00; reg<=0x3C; reg+=2)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
> +		for (reg=0x3E; reg<=0x7F; reg+=1)
> +			ret += bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
> +		break;
> +
> +	}
> +
> +	return ret;
> +}
> +
> +static DEVICE_ATTR(registers, S_IRUGO,
> +		bq27x00_battery_sysfs_show_registers, NULL);
> +
> +static struct attribute *bq27x00_battery_sysfs_attributes[] = {
> +	&dev_attr_registers.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group bq27x00_battery_sysfs_attr_group = {
> +	.attrs = bq27x00_battery_sysfs_attributes,
> +};
> +
> +static int bq27x00_battery_sysfs_init(struct bq27x00_device_info *di)
> +{
> +	return sysfs_create_group(&di->bat.dev->kobj,
> +			&bq27x00_battery_sysfs_attr_group);
> +}
> +
> +static void bq27x00_battery_sysfs_exit(struct bq27x00_device_info *di)
> +{
> +	sysfs_remove_group(&di->bat.dev->kobj,
> +			&bq27x00_battery_sysfs_attr_group);
> +}
> +
>  static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
>  {
>  	int ret;
> @@ -705,15 +789,22 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
>  	di->bat.get_property = bq27x00_battery_get_property;
>  	di->bat.external_power_changed = bq27x00_external_power_changed;
>  
> -	INIT_DELAYED_WORK(&di->work, bq27x00_battery_poll);
> -	mutex_init(&di->lock);
> -
>  	ret = power_supply_register(di->dev, &di->bat);
>  	if (ret) {
>  		dev_err(di->dev, "failed to register battery: %d\n", ret);
>  		return ret;
>  	}
>  
> +	ret = bq27x00_battery_sysfs_init(di);
> +	if (ret) {
> +		dev_err(di->dev, "failed to register battery: %d\n", ret);
> +		power_supply_unregister(&di->bat);
> +		return ret;
> +	}
> +
> +	INIT_DELAYED_WORK(&di->work, bq27x00_battery_poll);
> +	mutex_init(&di->lock);
> +
>  	dev_info(di->dev, "support ver. %s enabled\n", DRIVER_VERSION);
>  
>  	bq27x00_update(di);
> @@ -733,6 +824,7 @@ static void bq27x00_powersupply_unregister(struct bq27x00_device_info *di)
>  
>  	cancel_delayed_work_sync(&di->work);
>  
> +	bq27x00_battery_sysfs_exit(di);
>  	power_supply_unregister(&di->bat);
>  
>  	mutex_destroy(&di->lock);

