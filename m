Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3CYGKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:10:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:26601 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662Ab3CYGKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:10:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,902,1355126400"; 
   d="scan'208";a="306944298"
Message-ID: <1364191837.2465.7.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/2] thermal: introduce thermal_zone_lookup_temperature
 helper function
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 14:10:37 +0800
In-Reply-To: <1363986787-28147-2-git-send-email-eduardo.valentin@ti.com>
References: <1363986787-28147-1-git-send-email-eduardo.valentin@ti.com>
	 <1363986787-28147-2-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 17:13 -0400, Eduardo Valentin wrote:
> This patch adds a helper function to get temperature of
> a thermal zone, based on the zone type name.
> 
> It will perform a zone name lookup and return the last
> sensor temperature reading. In case the zone is not found
> or if the required parameters are invalid, it will return
> the corresponding error code.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/thermal_sys.c |   32 ++++++++++++++++++++++++++++++++
>  include/linux/thermal.h       |    1 +
>  2 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 5bd95d4..f0caa13 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -1790,6 +1790,38 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
>  }
>  EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
>  
> +/**
> + * thermal_lookup_temperature - search for a zone and returns its temperature
> + * @name: thermal zone name to fetch the temperature
> + * @temperature: pointer to store the zone temperature, in case it is found
> + *
> + * When the zone is found, updates @temperature and returns 0.
> + *
> + * Return: -EINVAL in case of wrong parameters, -ENODEV in case the zone
> + * is not found and 0 when it is successfully found.
> + */
> +int thermal_zone_lookup_temperature(const char *name, int *temperature)
> +{
> +	struct thermal_zone_device *pos = NULL;
> +	bool found = false;
> +
> +	if (!name || !temperature)
> +		return -EINVAL;
> +
> +	mutex_lock(&thermal_list_lock);
> +	list_for_each_entry(pos, &thermal_tz_list, node)
> +		if (!strcmp(pos->type, name)) {
> +			found = true;
> +			break;
> +		}
> +	if (found)
> +		*temperature = pos->last_temperature;
> +	mutex_unlock(&thermal_list_lock);
> +
> +	return found ? 0 : -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(thermal_zone_lookup_temperature);
> +
please do not use thermal zone type as the parameter because unique
thermal zone type string is not a hard rule.
If this is really needed, I'd prefer two APIs instead
1. struct thermal_zone_device * thermal_zone_get_zone_by_name(char
*name);
2. int thermal_zone_get_temperature(struct thermal_zone_device *, int
*temperature);

And in thermal_zone_get_zone_by_name(), you should parse all the thermal
zone list and return an error code instead if multiple zones are found.

thanks,
rui
>  #ifdef CONFIG_NET
>  static struct genl_family thermal_event_genl_family = {
>  	.id = GENL_ID_GENERATE,
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 542a39c..2b2f902 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -237,6 +237,7 @@ void thermal_zone_device_update(struct thermal_zone_device *);
>  struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
>  		const struct thermal_cooling_device_ops *);
>  void thermal_cooling_device_unregister(struct thermal_cooling_device *);
> +int thermal_zone_lookup_temperature(const char *name, int *temperature);
>  
>  int thermal_zone_trend_get(struct thermal_zone_device *, int);
>  struct thermal_instance *thermal_instance_get(struct thermal_zone_device *,


