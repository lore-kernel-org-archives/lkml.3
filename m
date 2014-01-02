Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaABC7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:59:17 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15566 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaABC7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:59:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 01 Jan 2014 18:59:42 -0800
Message-ID: <52C4D612.2090808@nvidia.com>
Date: Thu, 2 Jan 2014 10:59:30 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>
CC: <wni@nvidia.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 03:46 AM, Eduardo Valentin wrote:
> ...
> +
> +/**
> + * of_parse_thermal_zones - parse device tree thermal data
> + *
> + * Initialization function that can be called by machine initialization
> + * code to parse thermal data and populate the thermal framework
> + * with hardware thermal zones info. This function only parses thermal zones.
> + * Cooling devices and sensor devices nodes are supposed to be parsed
> + * by their respective drivers.
> + *
> + * Return: 0 on success, proper error code otherwise
> + *
> + */
> +int __init of_parse_thermal_zones(void)
> +{
> +	struct device_node *np, *child;
> +	struct __thermal_zone *tz;
> +	struct thermal_zone_device_ops *ops;
> +
> +	np = of_find_node_by_name(NULL, "thermal-zones");
> +	if (!np) {
> +		pr_debug("unable to find thermal zones\n");
> +		return 0; /* Run successfully on systems without thermal DT */
> +	}
> +
> +	for_each_child_of_node(np, child) {
> +		struct thermal_zone_device *zone;
> +		struct thermal_zone_params *tzp;
> +
> +		tz = thermal_of_build_thermal_zone(child);
> +		if (IS_ERR(tz)) {
> +			pr_err("failed to build thermal zone %s: %ld\n",
> +			       child->name,
> +			       PTR_ERR(tz));
> +			continue;
> +		}
> +
> +		ops = kmemdup(&of_thermal_ops, sizeof(*ops), GFP_KERNEL);
> +		if (!ops)
> +			goto exit_free;
> +
> +		tzp = kzalloc(sizeof(*tzp), GFP_KERNEL);
> +		if (!tzp) {
> +			kfree(ops);
> +			goto exit_free;
> +		}
> +
> +		/* No hwmon because there might be hwmon drivers registering */
> +		tzp->no_hwmon = true;
I think the platform driver may set governor for the thermal zone,
so how about to add a property named as "governor",
and parse it to tzp->governor_name,
something like:
                ret = of_property_read_string(child, "governor", &str);
                if (ret == 0)
                        if (strlen(str) < THERMAL_NAME_LENGTH)
                                strcpy(tzp->governor_name, str);

Thanks.
Wei.
> +
> +		zone = thermal_zone_device_register(child->name, tz->ntrips,
> +						    0, tz,
> +						    ops, tzp,
> +						    tz->passive_delay,
> +						    tz->polling_delay);
> +		if (IS_ERR(zone)) {
> +			pr_err("Failed to build %s zone %ld\n", child->name,
> +			       PTR_ERR(zone));
> +			kfree(tzp);
> +			kfree(ops);
> +			of_thermal_free_zone(tz);
> +			/* attempting to build remaining zones still */
> +		}
> +	}
> +
> +	return 0;
> +
> +exit_free:
> +	of_thermal_free_zone(tz);
> +
> +	/* no memory available, so free what we have built */
> +	of_thermal_destroy_zones();
> +
> +	return -ENOMEM;
> +}
> +
> +/**
> + * of_thermal_destroy_zones - remove all zones parsed and allocated resources
> + *
> + * Finds all zones parsed and added to the thermal framework and remove them
> + * from the system, together with their resources.
> + *
> + */
> +void __exit of_thermal_destroy_zones(void)
> +{
> +	struct device_node *np, *child;
> +
> +	np = of_find_node_by_name(NULL, "thermal-zones");
> +	if (!np) {
> +		pr_err("unable to find thermal zones\n");
> +		return;
> +	}
> +
> +	for_each_child_of_node(np, child) {
> +		struct thermal_zone_device *zone;
> +
> +		zone = thermal_zone_get_zone_by_name(child->name);
> +		if (IS_ERR(zone))
> +			continue;
> +
> +		thermal_zone_device_unregister(zone);
> +		kfree(zone->tzp);
> +		kfree(zone->ops);
> +		of_thermal_free_zone(zone->devdata);
> +	}
> +}
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index f4c9021..aba68dc 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1373,7 +1373,7 @@ static void remove_trip_attrs(struct thermal_zone_device *tz)
>   */
>  struct thermal_zone_device *thermal_zone_device_register(const char *type,
>  	int trips, int mask, void *devdata,
> -	const struct thermal_zone_device_ops *ops,
> +	struct thermal_zone_device_ops *ops,
>  	const struct thermal_zone_params *tzp,
>  	int passive_delay, int polling_delay)
>  {
> @@ -1753,8 +1753,14 @@ static int __init thermal_init(void)
>  	if (result)
>  		goto unregister_class;
>  
> +	result = of_parse_thermal_zones();
> +	if (result)
> +		goto exit_netlink;
> +
>  	return 0;
>  
> +exit_netlink:
> +	genetlink_exit();
>  unregister_governors:
>  	thermal_unregister_governors();
>  unregister_class:
> @@ -1770,6 +1776,7 @@ error:
>  
>  static void __exit thermal_exit(void)
>  {
> +	of_thermal_destroy_zones();
>  	genetlink_exit();
>  	class_unregister(&thermal_class);
>  	thermal_unregister_governors();
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
> index 7cf2f66..3db339f 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -77,4 +77,13 @@ static inline int thermal_gov_user_space_register(void) { return 0; }
>  static inline void thermal_gov_user_space_unregister(void) {}
>  #endif /* CONFIG_THERMAL_GOV_USER_SPACE */
>  
> +/* device tree support */
> +#ifdef CONFIG_THERMAL_OF
> +int of_parse_thermal_zones(void);
> +void of_thermal_destroy_zones(void);
> +#else
> +static inline int of_parse_thermal_zones(void) { return 0; }
> +static inline void of_thermal_destroy_zones(void) { }
> +#endif
> +
>  #endif /* __THERMAL_CORE_H__ */
> diff --git a/include/dt-bindings/thermal/thermal.h b/include/dt-bindings/thermal/thermal.h
> new file mode 100644
> index 0000000..59822a9
> --- /dev/null
> +++ b/include/dt-bindings/thermal/thermal.h
> @@ -0,0 +1,17 @@
> +/*
> + * This header provides constants for most thermal bindings.
> + *
> + * Copyright (C) 2013 Texas Instruments
> + *	Eduardo Valentin <eduardo.valentin@ti.com>
> + *
> + * GPLv2 only
> + */
> +
> +#ifndef _DT_BINDINGS_THERMAL_THERMAL_H
> +#define _DT_BINDINGS_THERMAL_THERMAL_H
> +
> +/* On cooling devices upper and lower limits */
> +#define THERMAL_NO_LIMIT		(-1UL)
> +
> +#endif
> +
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index b268d3c..b780c5b 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -143,6 +143,7 @@ struct thermal_cooling_device {
>  	int id;
>  	char type[THERMAL_NAME_LENGTH];
>  	struct device device;
> +	struct device_node *np;
>  	void *devdata;
>  	const struct thermal_cooling_device_ops *ops;
>  	bool updated; /* true if the cooling device does not need update */
> @@ -172,7 +173,7 @@ struct thermal_zone_device {
>  	int emul_temperature;
>  	int passive;
>  	unsigned int forced_passive;
> -	const struct thermal_zone_device_ops *ops;
> +	struct thermal_zone_device_ops *ops;
>  	const struct thermal_zone_params *tzp;
>  	struct thermal_governor *governor;
>  	struct list_head thermal_instances;
> @@ -242,8 +243,31 @@ struct thermal_genl_event {
>  };
>  
>  /* Function declarations */
> +#ifdef CONFIG_THERMAL_OF
> +struct thermal_zone_device *
> +thermal_zone_of_sensor_register(struct device *dev, int id,
> +				void *data, int (*get_temp)(void *, long *),
> +				int (*get_trend)(void *, long *));
> +void thermal_zone_of_sensor_unregister(struct device *dev,
> +				       struct thermal_zone_device *tz);
> +#else
> +static inline struct thermal_zone_device *
> +thermal_zone_of_sensor_register(struct device *dev, int id,
> +				void *data, int (*get_temp)(void *, long *),
> +				int (*get_trend)(void *, long *))
> +{
> +	return NULL;
> +}
> +
> +static inline
> +void thermal_zone_of_sensor_unregister(struct device *dev,
> +				       struct thermal_zone_device *tz)
> +{
> +}
> +
> +#endif
>  struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
> -		void *, const struct thermal_zone_device_ops *,
> +		void *, struct thermal_zone_device_ops *,
>  		const struct thermal_zone_params *, int, int);
>  void thermal_zone_device_unregister(struct thermal_zone_device *);
>  

