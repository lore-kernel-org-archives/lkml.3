Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab3B1VbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:31:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40476 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3B1VbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:31:13 -0500
Message-ID: <512FCC90.5000604@ti.com>
Date: Thu, 28 Feb 2013 17:30:56 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Durgadoss R <durgadoss.r@intel.com>
CC: <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hongbo.zhang@linaro.org>,
        <wni@nvidia.com>
Subject: Re: [PATCH 5/8] Thermal: Create Thermal map sysfs attributes for
 a zone
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com> <1360061183-14137-6-git-send-email-durgadoss.r@intel.com>
In-Reply-To: <1360061183-14137-6-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Durga,


On 05-02-2013 06:46, Durgadoss R wrote:
> This patch creates a thermal map sysfs node under
> /sys/class/thermal/zoneX/. This contains
> entries named mapY_trip_type, mapY_sensor_name,
> mapY_cdev_name, mapY_trip_mask, mapY_weights.


Some of the previous comments apply here as well, specially wrt to 
devm_, snprintf and strlcpy. Also the documentation for the exported 
functions are welcome.

>
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>   drivers/thermal/thermal_sys.c |  221 ++++++++++++++++++++++++++++++++++++++++-
>   include/linux/thermal.h       |   25 +++++
>   2 files changed, 244 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 69a60a4..e284b67 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -525,6 +525,44 @@ static void remove_cdev_from_zone(struct thermal_zone *tz,
>   	tz->cdev_indx--;
>   }
>
> +static inline void __remove_map_entry(struct thermal_zone *tz, int indx)
> +{
> +	int i;
> +	struct thermal_map_attr *attr = tz->map_attr[indx];
> +
> +	for (i = 0; i < NUM_MAP_ATTRS; i++)
> +		device_remove_file(&tz->device, &attr->attrs[i].attr);
> +
> +	kfree(tz->map_attr[indx]);
> +	tz->map[indx] = NULL;
> +}
> +
> +static void remove_sensor_map_entry(struct thermal_zone *tz,
> +				struct thermal_sensor *ts)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_MAPS_PER_ZONE; i++) {
> +		if (tz->map[i] && !strnicmp(ts->name, tz->map[i]->sensor_name,
> +						THERMAL_NAME_LENGTH)) {
> +			__remove_map_entry(tz, i);
> +		}
> +	}
> +}
> +
> +static void remove_cdev_map_entry(struct thermal_zone *tz,
> +				struct thermal_cooling_device *cdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_MAPS_PER_ZONE; i++) {
> +		if (tz->map[i] && !strnicmp(cdev->type, tz->map[i]->cdev_name,
> +						THERMAL_NAME_LENGTH)) {
> +			__remove_map_entry(tz, i);
> +		}
> +	}
> +}
> +
>   /* sys I/F for thermal zone */
>
>   #define to_thermal_zone(_dev) \
> @@ -917,6 +955,107 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
>   }
>
>   static ssize_t
> +map_ttype_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	char *trip;
> +	int indx;
> +	struct thermal_zone *tz = to_zone(dev);
> +
> +	if (!sscanf(attr->attr.name, "map%d_trip_type", &indx))
> +		return -EINVAL;
> +
> +	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
> +		return -EINVAL;
> +
> +	if (!tz->map[indx])
> +		return sprintf(buf, "<Unavailable>\n");

Is this condition possible? If yes, we probably need to change the code 
so that if the map is not present, the sysfs files are also removed.

> +
> +	trip = (tz->map[indx]->trip_type == THERMAL_TRIP_ACTIVE) ?
> +						"active" : "passive";
> +	return sprintf(buf, "%s\n", trip);
> +}
> +
> +static ssize_t map_ts_name_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int indx;
> +	struct thermal_zone *tz = to_zone(dev);
> +
> +	if (!sscanf(attr->attr.name, "map%d_sensor_name", &indx))
> +		return -EINVAL;
> +
> +	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
> +		return -EINVAL;
> +
> +	if (!tz->map[indx])
> +		return sprintf(buf, "<Unavailable>\n");

ditto

> +
> +	return sprintf(buf, "%s\n", tz->map[indx]->sensor_name);
> +}
> +
> +static ssize_t map_cdev_name_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int indx;
> +	struct thermal_zone *tz = to_zone(dev);
> +
> +	if (!sscanf(attr->attr.name, "map%d_cdev_name", &indx))
> +		return -EINVAL;
> +
> +	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
> +		return -EINVAL;
> +
> +	if (!tz->map[indx])
> +		return sprintf(buf, "<Unavailable>\n");

ditto

> +
> +	return sprintf(buf, "%s\n", tz->map[indx]->cdev_name);
> +}
> +
> +static ssize_t map_trip_mask_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int indx;
> +	struct thermal_zone *tz = to_zone(dev);
> +
> +	if (!sscanf(attr->attr.name, "map%d_trip_mask", &indx))
> +		return -EINVAL;
> +
> +	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
> +		return -EINVAL;
> +
> +	if (!tz->map[indx])
> +		return sprintf(buf, "<Unavailable>\n");

ditto

> +
> +	return sprintf(buf, "0x%x\n", tz->map[indx]->trip_mask);
> +}
> +
> +static ssize_t map_weights_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int i, indx, ret = 0;
> +	struct thermal_map *map;
> +	struct thermal_zone *tz = to_zone(dev);
> +
> +	if (!sscanf(attr->attr.name, "map%d_weights", &indx))
> +		return -EINVAL;
> +
> +	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
> +		return -EINVAL;
> +
> +	if (!tz->map[indx])
> +		return sprintf(buf, "<Unavailable>\n");
> +

ditto

> +	map = tz->map[indx];
> +
> +	ret += sprintf(buf, "%d", map->weights[0]);
> +	for (i = 1; i < map->num_weights; i++)
> +		ret += sprintf(buf + ret, " %d", map->weights[i]);
> +
> +	ret += sprintf(buf + ret, "\n");
> +	return ret;

this function violates sysfs rules.

> +}
> +
> +static ssize_t
>   active_show(struct device *dev, struct device_attribute *attr, char *buf)
>   {
>   	int i, indx, ret = 0;
> @@ -1655,8 +1794,10 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
>
>   	mutex_lock(&zone_list_lock);
>
> -	for_each_thermal_zone(tmp_tz)
> +	for_each_thermal_zone(tmp_tz) {
>   		remove_cdev_from_zone(tmp_tz, cdev);
> +		remove_cdev_map_entry(tmp_tz, cdev);
> +	}
>
>   	mutex_unlock(&zone_list_lock);
>
> @@ -1994,6 +2135,9 @@ void remove_thermal_zone(struct thermal_zone *tz)
>   				kobject_name(&tz->cdevs[i]->device.kobj));
>   	}
>
> +	for (i = 0; i < MAX_MAPS_PER_ZONE; i++)
> +		__remove_map_entry(tz, i);
> +
>   	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
>   	idr_destroy(&tz->idr);
>
> @@ -2039,6 +2183,77 @@ struct thermal_sensor *get_sensor_by_name(const char *name)
>   }
>   EXPORT_SYMBOL(get_sensor_by_name);
>
> +static int create_map_attrs(struct thermal_zone *tz, int indx)
> +{
> +	int ret, i;
> +	struct thermal_map_attr *attr = tz->map_attr[indx];
> +
> +	static const char *const names[NUM_MAP_ATTRS] = { "map%d_trip_type",
> +			"map%d_sensor_name", "map%d_cdev_name",
> +			"map%d_trip_mask", "map%d_weights" };
> +	static ssize_t (*const rd_ptr[NUM_MAP_ATTRS]) (struct device *dev,
> +			struct device_attribute *devattr, char *buf) = {
> +			map_ttype_show, map_ts_name_show, map_cdev_name_show,
> +			map_trip_mask_show, map_weights_show };
> +
> +	for (i = 0; i < NUM_MAP_ATTRS; i++) {
> +		snprintf(attr->attrs[i].name,
> +			THERMAL_NAME_LENGTH, names[i], indx);
> +		attr->attrs[i].attr.attr.name = attr->attrs[i].name;
> +		attr->attrs[i].attr.attr.mode = S_IRUGO;
> +		attr->attrs[i].attr.show = rd_ptr[i];
> +		sysfs_attr_init(&attr->attrs[i].attr);
> +
> +		ret = device_create_file(&tz->device, &attr->attrs[i].attr);
> +		if (ret)
> +			goto exit_free;
> +	}
> +	return 0;
> +exit_free:
> +	while (--i >= 0)
> +		device_remove_file(&tz->device, &attr->attrs[i].attr);
> +	return ret;
> +}
> +
> +int add_map_entry(struct thermal_zone *tz, struct thermal_map *map)
> +{
> +	int ret, indx;
> +
> +	if (!tz || !map)
> +		return -EINVAL;
> +
> +	mutex_lock(&zone_list_lock);
> +
> +	for (indx = 0; indx < MAX_MAPS_PER_ZONE; indx++) {
> +		if (tz->map[indx] == NULL)
> +			break;
> +	}
> +
> +	if (indx >= MAX_MAPS_PER_ZONE) {
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	tz->map_attr[indx] = kzalloc(sizeof(struct thermal_map_attr),
> +						GFP_KERNEL);
> +	if (!tz->map_attr[indx]) {
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	ret = create_map_attrs(tz, indx);
> +	if (ret) {
> +		kfree(tz->map_attr[indx]);
> +		goto exit;
> +	}
> +
> +	tz->map[indx] = map;

userland must be aware that a file named:
/sys/class/thermal/zoneX/mapY_trip_type not aways refer to the same map. 
This is because one may add a map, it will create say:
/sys/class/thermal/zoneX/map0_trip_type

then for some odd reason that map gets removed. And for some other odd 
reason, one decides to add yet another map. It will reuse the number. 
But it is not the same map!

This must be well documented, otherwise things may get confusing.

I'd suggest using a unique id..

> +exit:
> +	mutex_unlock(&zone_list_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(add_map_entry);
> +
>   int add_sensor_to_zone(struct thermal_zone *tz, struct thermal_sensor *ts)
>   {
>   	int ret;
> @@ -2243,8 +2458,10 @@ void thermal_sensor_unregister(struct thermal_sensor *ts)
>
>   	mutex_lock(&zone_list_lock);
>
> -	for_each_thermal_zone(tz)
> +	for_each_thermal_zone(tz) {
>   		remove_sensor_from_zone(tz, ts);
> +		remove_sensor_map_entry(tz, ts);
> +	}
>
>   	mutex_unlock(&zone_list_lock);
>
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 2f68018..4389599 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -60,6 +60,11 @@
>
>   #define MAX_CDEVS_PER_ZONE		5
>
> +#define NUM_MAP_ATTRS			5
> +
> +/* If we map each sensor with every possible cdev for a zone */
> +#define MAX_MAPS_PER_ZONE	(MAX_SENSORS_PER_ZONE * MAX_CDEVS_PER_ZONE)
> +
>   struct thermal_sensor;
>   struct thermal_zone_device;
>   struct thermal_cooling_device;
> @@ -167,6 +172,20 @@ struct thermal_attr {
>   	char name[THERMAL_NAME_LENGTH];
>   };
>
> +struct thermal_map {
> +	enum thermal_trip_type trip_type;
> +	char cdev_name[THERMAL_NAME_LENGTH];
> +	char sensor_name[THERMAL_NAME_LENGTH];
> +
> +	int trip_mask;
> +	int num_weights;
> +	int *weights;
> +};
> +
> +struct thermal_map_attr {
> +	struct thermal_attr attrs[NUM_MAP_ATTRS];
> +};
> +
>   /*
>    * This structure defines the trip points for a sensor.
>    * The actual values for these trip points come from
> @@ -256,6 +275,10 @@ struct thermal_zone {
>   	/* Thermal sensors trip information */
>   	struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
>   	struct thermal_trip_attr *trip_attr[MAX_SENSORS_PER_ZONE];
> +
> +	/* Thermal map information */
> +	struct thermal_map *map[MAX_MAPS_PER_ZONE];
> +	struct thermal_map_attr *map_attr[MAX_MAPS_PER_ZONE];
>   };
>
>   /* Structure that holds thermal governor information */
> @@ -341,6 +364,8 @@ struct thermal_cooling_device *get_cdev_by_name(const char *);
>   int add_sensor_trip_info(struct thermal_zone *, struct thermal_sensor *,
>   			struct thermal_trip_point *);
>
> +int add_map_entry(struct thermal_zone *, struct thermal_map *);
> +
>   #ifdef CONFIG_NET
>   extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
>   						enum events event);
>

