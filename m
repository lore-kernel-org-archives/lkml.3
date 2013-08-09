Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031377Ab3HIW2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:28:49 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43700 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031355Ab3HIW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:28:48 -0400
Date: Fri, 9 Aug 2013 15:23:54 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] power_supply: Add charger control properties
Message-ID: <20130809222353.GI12638@lizard.sbx05730.santaca.wayport.net>
References: <1373823466-2581-1-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1373823466-2581-1-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 11:07:45PM +0530, Jenny TC wrote:
> The battery charger needs to have control path along
> with the reporting charger properties. In existing solutions
> this is implemented using regulator framework. A regulator
> framework doesn't fit a charger driver requirement because of the
> following reason
> Charger needs support two paths - charger path (charger to platform)
> and charging (charger to battery).Disabling the charging path alone
> (eg over battery temperature) will allow the platform to work with
> power from charger without discharging the battery. And the charger
> may need to be disabled completely based on the charger temperature
> or the platform temperature. Charger has more than one pair of
> voltage/current to control (CC,CV,INLMT).These features will not
> directly fit in the regulator framework. Since the charger driver
> sits in the power supply subsystem it make sense to add the properties
> to control the charger.
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---

The patch is missing Documentation/ part for the new properties...

>  drivers/power/power_supply_sysfs.c |    8 ++++++++
>  include/linux/power_supply.h       |    8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 29178f7..643971c 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -167,6 +167,7 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(constant_charge_voltage_max),
>  	POWER_SUPPLY_ATTR(charge_control_limit),
>  	POWER_SUPPLY_ATTR(charge_control_limit_max),
> +	POWER_SUPPLY_ATTR(input_cur_limit),
>  	POWER_SUPPLY_ATTR(energy_full_design),
>  	POWER_SUPPLY_ATTR(energy_empty_design),
>  	POWER_SUPPLY_ATTR(energy_full),
> @@ -178,6 +179,8 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(capacity_alert_max),
>  	POWER_SUPPLY_ATTR(capacity_level),
>  	POWER_SUPPLY_ATTR(temp),
> +	POWER_SUPPLY_ATTR(max_temp),
> +	POWER_SUPPLY_ATTR(min_temp),
>  	POWER_SUPPLY_ATTR(temp_alert_min),
>  	POWER_SUPPLY_ATTR(temp_alert_max),
>  	POWER_SUPPLY_ATTR(temp_ambient),
> @@ -189,6 +192,11 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(time_to_full_avg),
>  	POWER_SUPPLY_ATTR(type),
>  	POWER_SUPPLY_ATTR(scope),
> +	POWER_SUPPLY_ATTR(charge_term_cur),
> +	POWER_SUPPLY_ATTR(enable_charging),
> +	POWER_SUPPLY_ATTR(enable_charger),
> +	POWER_SUPPLY_ATTR(cable_type),
> +	POWER_SUPPLY_ATTR(priority),
>  	/* Properties of type `const char *' */
>  	POWER_SUPPLY_ATTR(model_name),
>  	POWER_SUPPLY_ATTR(manufacturer),
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 804b906..1265131 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -118,6 +118,7 @@ enum power_supply_property {
>  	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
>  	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT,
>  	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX,
> +	POWER_SUPPLY_PROP_INLMT,

Kinda cryptic...

You wrote a great explanation here:

http://lkml.indiana.edu/hypermail/linux/kernel/1207.0/00050.html

Why don't just copy-paste it into Documentation? :)

>  	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
>  	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
>  	POWER_SUPPLY_PROP_ENERGY_FULL,
> @@ -129,6 +130,8 @@ enum power_supply_property {
>  	POWER_SUPPLY_PROP_CAPACITY_ALERT_MAX, /* in percents! */
>  	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
>  	POWER_SUPPLY_PROP_TEMP,
> +	POWER_SUPPLY_PROP_MAX_TEMP,
> +	POWER_SUPPLY_PROP_MIN_TEMP,
>  	POWER_SUPPLY_PROP_TEMP_ALERT_MIN,
>  	POWER_SUPPLY_PROP_TEMP_ALERT_MAX,
>  	POWER_SUPPLY_PROP_TEMP_AMBIENT,
> @@ -140,6 +143,11 @@ enum power_supply_property {
>  	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
>  	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
>  	POWER_SUPPLY_PROP_SCOPE,
> +	POWER_SUPPLY_PROP_CHARGE_TERM_CUR,
> +	POWER_SUPPLY_PROP_ENABLE_CHARGING,
> +	POWER_SUPPLY_PROP_ENABLE_CHARGER,
> +	POWER_SUPPLY_PROP_CABLE_TYPE,
> +	POWER_SUPPLY_PROP_PRIORITY,
>  	/* Properties of type `const char *' */
>  	POWER_SUPPLY_PROP_MODEL_NAME,
>  	POWER_SUPPLY_PROP_MANUFACTURER,
> -- 
> 1.7.9.5
