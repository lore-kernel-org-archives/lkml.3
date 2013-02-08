Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946030Ab3BHHx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:53:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:22520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759676Ab3BHHx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:53:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="259497349"
Message-ID: <1360310031.2242.24.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/8] Thermal: Create sensor level APIs
From: Zhang Rui <rui.zhang@intel.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        eduardo.valentin@ti.com, hongbo.zhang@linaro.org, wni@nvidia.com
Date: Fri, 08 Feb 2013 15:53:51 +0800
In-Reply-To: <1360061183-14137-2-git-send-email-durgadoss.r@intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-2-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> This patch creates sensor level APIs, in the
> generic thermal framework.
> 
> A Thermal sensor is a piece of hardware that can report
> temperature of the spot in which it is placed. A thermal
> sensor driver reads the temperature from this sensor
> and reports it out. This kind of driver can be in
> any subsystem. If the sensor needs to participate
> in platform thermal management, the corresponding
> driver can use the APIs introduced in this patch, to
> register(or unregister) with the thermal framework.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  drivers/thermal/thermal_sys.c |  280 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h       |   29 +++++
>  2 files changed, 309 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 0a1bf6b..cb94497 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -44,13 +44,16 @@ MODULE_LICENSE("GPL");
>  
>  static DEFINE_IDR(thermal_tz_idr);
>  static DEFINE_IDR(thermal_cdev_idr);
> +static DEFINE_IDR(thermal_sensor_idr);
>  static DEFINE_MUTEX(thermal_idr_lock);
>  
>  static LIST_HEAD(thermal_tz_list);
> +static LIST_HEAD(thermal_sensor_list);
>  static LIST_HEAD(thermal_cdev_list);
>  static LIST_HEAD(thermal_governor_list);
>  
>  static DEFINE_MUTEX(thermal_list_lock);
> +static DEFINE_MUTEX(sensor_list_lock);
>  static DEFINE_MUTEX(thermal_governor_lock);
>  
>  static struct thermal_governor *__find_governor(const char *name)
> @@ -423,6 +426,103 @@ static void thermal_zone_device_check(struct work_struct *work)
>  #define to_thermal_zone(_dev) \
>  	container_of(_dev, struct thermal_zone_device, device)
>  
> +#define to_thermal_sensor(_dev) \
> +	container_of(_dev, struct thermal_sensor, device)
> +
> +static ssize_t
> +sensor_name_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> +
> +	return sprintf(buf, "%s\n", ts->name);
> +}
> +
> +static ssize_t
> +sensor_temp_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	long val;
> +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> +
> +	ret = ts->ops->get_temp(ts, &val);
> +
> +	return ret ? ret : sprintf(buf, "%ld\n", val);
> +}
> +
> +static ssize_t
> +hyst_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	int indx, ret;
> +	long val;
> +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> +
> +	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
> +		return -EINVAL;
> +
> +	ret = ts->ops->get_hyst(ts, indx, &val);
> +
> +	return ret ? ret : sprintf(buf, "%ld\n", val);
> +}
> +
> +static ssize_t
> +hyst_store(struct device *dev, struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	int indx, ret;
> +	long val;
> +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> +
> +	if (!ts->ops->set_hyst)
> +		return -EPERM;
> +
> +	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
> +		return -EINVAL;
> +
> +	if (kstrtol(buf, 10, &val))
> +		return -EINVAL;
> +
> +	ret = ts->ops->set_hyst(ts, indx, val);
> +
> +	return ret ? ret : count;
> +}
> +
> +static ssize_t
> +threshold_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	int indx, ret;
> +	long val;
> +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> +
> +	if (!sscanf(attr->attr.name, "threshold%d", &indx))
> +		return -EINVAL;
> +
> +	ret = ts->ops->get_threshold(ts, indx, &val);
> +
> +	return ret ? ret : sprintf(buf, "%ld\n", val);
> +}
> +
> +static ssize_t
> +threshold_store(struct device *dev, struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	int indx, ret;
> +	long val;
> +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> +
> +	if (!ts->ops->set_threshold)
> +		return -EPERM;
> +
> +	if (!sscanf(attr->attr.name, "threshold%d", &indx))
> +		return -EINVAL;
> +
> +	if (kstrtol(buf, 10, &val))
> +		return -EINVAL;
> +
> +	ret = ts->ops->set_threshold(ts, indx, val);
> +
> +	return ret ? ret : count;
> +}
> +
>  static ssize_t
>  type_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> @@ -707,6 +807,10 @@ static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
>  static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
>  static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
>  
> +/* Thermal sensor attributes */
> +static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
> +static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
> +
>  /* sys I/F for cooling device */
>  #define to_cooling_device(_dev)	\
>  	container_of(_dev, struct thermal_cooling_device, device)
> @@ -1493,6 +1597,182 @@ static void remove_trip_attrs(struct thermal_zone_device *tz)
>  }
>  
>  /**
> + * enable_sensor_thresholds - create sysfs nodes for thresholdX

this is a little confusing.
I'd prefer
thermal_sensor_sysfs_add() and create sensor_name and temp_input
attribute in this function as well, and thermal_sensor_sysfs_remove()
to remove the sysfs I/F.
And further more, we can do this for thermal zones and cooling devices.

others look okay to me.

thanks,
rui

