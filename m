Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037Ab3BHILk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:11:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:49976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432Ab3BHILi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:11:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="282529494"
Message-ID: <1360311092.2242.28.camel@rzhang1-mobl4>
Subject: Re: [PATCH 2/8] Thermal: Create zone level APIs
From: Zhang Rui <rui.zhang@intel.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        eduardo.valentin@ti.com, hongbo.zhang@linaro.org, wni@nvidia.com
Date: Fri, 08 Feb 2013 16:11:32 +0800
In-Reply-To: <1360061183-14137-3-git-send-email-durgadoss.r@intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-3-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> This patch adds a new thermal_zone structure to
> thermal.h. Also, adds zone level APIs to the thermal
> framework.
> 
> A thermal zone is a hot spot on the platform, which
> can have one or more sensors and cooling devices attached
> to it. These sensors can be mapped to a set of cooling
> devices, which when throttled, can help to bring down
> the temperature of the hot spot.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  drivers/thermal/thermal_sys.c |  196 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h       |   22 +++++
>  2 files changed, 218 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index cb94497..838d4fb 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -43,19 +43,46 @@ MODULE_DESCRIPTION("Generic thermal management sysfs support");
>  MODULE_LICENSE("GPL");
>  
>  static DEFINE_IDR(thermal_tz_idr);
> +static DEFINE_IDR(thermal_zone_idr);
>  static DEFINE_IDR(thermal_cdev_idr);
>  static DEFINE_IDR(thermal_sensor_idr);
>  static DEFINE_MUTEX(thermal_idr_lock);
>  
>  static LIST_HEAD(thermal_tz_list);
>  static LIST_HEAD(thermal_sensor_list);
> +static LIST_HEAD(thermal_zone_list);
>  static LIST_HEAD(thermal_cdev_list);
>  static LIST_HEAD(thermal_governor_list);
>  
>  static DEFINE_MUTEX(thermal_list_lock);
>  static DEFINE_MUTEX(sensor_list_lock);
> +static DEFINE_MUTEX(zone_list_lock);
>  static DEFINE_MUTEX(thermal_governor_lock);
>  
> +#define for_each_thermal_sensor(pos) \
> +	list_for_each_entry(pos, &thermal_sensor_list, node)
> +
> +#define for_each_thermal_zone(pos) \
> +	list_for_each_entry(pos, &thermal_zone_list, node)
> +
> +#define GET_INDEX(tz, ptr, type)			\
> +({							\
> +	int i, ret = -EINVAL;				\
> +	do {						\
> +		if (!tz || !ptr)			\
> +			break;				\
> +		mutex_lock(&type##_list_lock);		\
> +		for (i = 0; i < tz->type##_indx; i++) {	\
> +			if (tz->type##s[i] == ptr) {	\
> +				ret = i;		\
> +				break;			\
> +			}				\
> +		}					\
> +		mutex_unlock(&type##_list_lock);	\
> +	} while (0);					\
> +	ret;						\
> +})
> +
>  static struct thermal_governor *__find_governor(const char *name)
>  {
>  	struct thermal_governor *pos;
> @@ -421,15 +448,44 @@ static void thermal_zone_device_check(struct work_struct *work)
>  	thermal_zone_device_update(tz);
>  }
>  
> +static void remove_sensor_from_zone(struct thermal_zone *tz,
> +				struct thermal_sensor *ts)
> +{
> +	int j, indx;
> +
> +	indx = GET_INDEX(tz, ts, sensor);
> +	if (indx < 0)
> +		return;
> +
> +	sysfs_remove_link(&tz->device.kobj, kobject_name(&ts->device.kobj));
> +
> +	/* Shift the entries in the tz->sensors array */
> +	for (j = indx; j < MAX_SENSORS_PER_ZONE - 1; j++)
> +		tz->sensors[j] = tz->sensors[j + 1];
> +
> +	tz->sensor_indx--;
> +}
> +
>  /* sys I/F for thermal zone */
>  
>  #define to_thermal_zone(_dev) \
>  	container_of(_dev, struct thermal_zone_device, device)
>  
> +#define to_zone(_dev) \
> +	container_of(_dev, struct thermal_zone, device)
> +
>  #define to_thermal_sensor(_dev) \
>  	container_of(_dev, struct thermal_sensor, device)
>  
>  static ssize_t
> +zone_name_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct thermal_zone *tz = to_zone(dev);
> +
> +	return sprintf(buf, "%s\n", tz->name);
> +}
> +
> +static ssize_t
>  sensor_name_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct thermal_sensor *ts = to_thermal_sensor(dev);
> @@ -811,6 +867,8 @@ static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
>  static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
>  static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
>  
> +static DEVICE_ATTR(zone_name, 0444, zone_name_show, NULL);
> +
>  /* sys I/F for cooling device */
>  #define to_cooling_device(_dev)	\
>  	container_of(_dev, struct thermal_cooling_device, device)
> @@ -1656,6 +1714,136 @@ static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
>  	return 0;
>  }
>  
> +struct thermal_zone *create_thermal_zone(const char *name, void *devdata)
> +{
> +	struct thermal_zone *tz;
> +	int ret;
> +
> +	if (!name || (name && strlen(name) >= THERMAL_NAME_LENGTH))
> +		return ERR_PTR(-EINVAL);
> +
> +	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
> +	if (!tz)
> +		return ERR_PTR(-ENOMEM);
> +
> +	idr_init(&tz->idr);
> +	ret = get_idr(&thermal_zone_idr, &thermal_idr_lock, &tz->id);
> +	if (ret)
> +		goto exit_free;
> +
> +	strcpy(tz->name, name);
> +	tz->devdata = devdata;
> +	tz->device.class = &thermal_class;
> +
> +	dev_set_name(&tz->device, "zone%d", tz->id);
> +	ret = device_register(&tz->device);
> +	if (ret)
> +		goto exit_idr;
> +
> +	ret = device_create_file(&tz->device, &dev_attr_zone_name);
> +	if (ret)
> +		goto exit_unregister;
> +
> +	/* Add this zone to the global list of thermal zones */
> +	mutex_lock(&zone_list_lock);
> +	list_add_tail(&tz->node, &thermal_zone_list);
> +	mutex_unlock(&zone_list_lock);
> +	return tz;
> +
> +exit_unregister:
> +	device_unregister(&tz->device);
> +exit_idr:
> +	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
> +exit_free:
> +	kfree(tz);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL(create_thermal_zone);
> +
> +void remove_thermal_zone(struct thermal_zone *tz)
> +{
> +	struct thermal_zone *pos, *next;
> +	bool found = false;
> +
> +	if (!tz)
> +		return;
> +
> +	mutex_lock(&zone_list_lock);
> +
> +	list_for_each_entry_safe(pos, next, &thermal_zone_list, node) {
> +		if (pos == tz) {
> +			list_del(&tz->node);
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (!found)
> +		goto exit;
> +
> +	device_remove_file(&tz->device, &dev_attr_zone_name);
> +
> +	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
> +	idr_destroy(&tz->idr);
> +
> +	device_unregister(&tz->device);
> +	kfree(tz);
> +exit:
> +	mutex_unlock(&zone_list_lock);
> +	return;
> +}
> +EXPORT_SYMBOL(remove_thermal_zone);
> +
> +struct thermal_sensor *get_sensor_by_name(const char *name)
> +{
> +	struct thermal_sensor *pos;
> +	struct thermal_sensor *ts = NULL;
> +
> +	mutex_lock(&sensor_list_lock);
> +	for_each_thermal_sensor(pos) {
> +		if (!strnicmp(pos->name, name, THERMAL_NAME_LENGTH)) {
> +			ts = pos;
> +			break;

this function depends on the assumption that all the sensor names are
unique.
thus I prefer to go through all the list and return -EINVAL if duplicate
names found, because in this case, the pointer returned may be not the
sensor we want to get.

thanks,
rui
> +		}
> +	}
> +	mutex_unlock(&sensor_list_lock);
> +	return ts;
> +}
> +EXPORT_SYMBOL(get_sensor_by_name);
> +
> +int add_sensor_to_zone(struct thermal_zone *tz, struct thermal_sensor *ts)
> +{
> +	int ret;
> +
> +	if (!tz || !ts)
> +		return -EINVAL;
> +
> +	mutex_lock(&zone_list_lock);
> +
> +	/* Ensure we are not adding the same sensor again!! */
> +	ret = GET_INDEX(tz, ts, sensor);
> +	if (ret >= 0) {
> +		ret = -EEXIST;
> +		goto exit_zone;
> +	}
> +
> +	mutex_lock(&sensor_list_lock);
> +
> +	ret = sysfs_create_link(&tz->device.kobj, &ts->device.kobj,
> +				kobject_name(&ts->device.kobj));
> +	if (ret)
> +		goto exit_sensor;
> +
> +	tz->sensors[tz->sensor_indx++] = ts;
> +
> +exit_sensor:
> +	mutex_unlock(&sensor_list_lock);
> +exit_zone:
> +	mutex_unlock(&zone_list_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(add_sensor_to_zone);
> +
>  /**
>   * thermal_sensor_register - register a new thermal sensor
>   * @name:	name of the thermal sensor
> @@ -1732,6 +1920,7 @@ EXPORT_SYMBOL(thermal_sensor_register);
>  void thermal_sensor_unregister(struct thermal_sensor *ts)
>  {
>  	int i;
> +	struct thermal_zone *tz;
>  	struct thermal_sensor *pos, *next;
>  	bool found = false;
>  
> @@ -1751,6 +1940,13 @@ void thermal_sensor_unregister(struct thermal_sensor *ts)
>  	if (!found)
>  		return;
>  
> +	mutex_lock(&zone_list_lock);
> +
> +	for_each_thermal_zone(tz)
> +		remove_sensor_from_zone(tz, ts);
> +
> +	mutex_unlock(&zone_list_lock);
> +
>  	for (i = 0; i < ts->thresholds; i++) {
>  		device_remove_file(&ts->device, &ts->thresh_attrs[i].attr);
>  		if (ts->ops->get_hyst) {
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 5470dae..2194519 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -55,6 +55,8 @@
>  #define DEFAULT_THERMAL_GOVERNOR       "user_space"
>  #endif
>  
> +#define MAX_SENSORS_PER_ZONE		5
> +
>  struct thermal_sensor;
>  struct thermal_zone_device;
>  struct thermal_cooling_device;
> @@ -202,6 +204,21 @@ struct thermal_zone_device {
>  	struct delayed_work poll_queue;
>  };
>  
> +struct thermal_zone {
> +	char name[THERMAL_NAME_LENGTH];
> +	int id;
> +	void *devdata;
> +	struct thermal_zone *ops;
> +	struct thermal_governor *governor;
> +	struct idr idr;
> +	struct device device;
> +	struct list_head node;
> +
> +	/* Sensor level information */
> +	int sensor_indx; /* index into 'sensors' array */
> +	struct thermal_sensor *sensors[MAX_SENSORS_PER_ZONE];
> +};
> +
>  /* Structure that holds thermal governor information */
>  struct thermal_governor {
>  	char name[THERMAL_NAME_LENGTH];
> @@ -274,6 +291,11 @@ struct thermal_sensor *thermal_sensor_register(const char *, int,
>  				struct thermal_sensor_ops *, void *);
>  void thermal_sensor_unregister(struct thermal_sensor *);
>  
> +struct thermal_zone *create_thermal_zone(const char *, void *);
> +void remove_thermal_zone(struct thermal_zone *);
> +int add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
> +struct thermal_sensor *get_sensor_by_name(const char *);
> +
>  #ifdef CONFIG_NET
>  extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
>  						enum events event);


