Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab3BHI2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:28:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:55447 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759842Ab3BHI2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:28:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="288206225"
Message-ID: <1360312127.2242.38.camel@rzhang1-mobl4>
Subject: Re: [PATCH 3/8] Thermal: Add APIs to bind cdev to new zone structure
From: Zhang Rui <rui.zhang@intel.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        eduardo.valentin@ti.com, hongbo.zhang@linaro.org, wni@nvidia.com
Date: Fri, 08 Feb 2013 16:28:47 +0800
In-Reply-To: <1360061183-14137-4-git-send-email-durgadoss.r@intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-4-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> This patch creates new APIs to add/remove a
> cdev to/from a zone. This patch does not change
> the old cooling device implementation.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  drivers/thermal/thermal_sys.c |   80 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h       |    9 +++++
>  2 files changed, 89 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 838d4fb..bf703b1 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -57,6 +57,7 @@ static LIST_HEAD(thermal_governor_list);
>  static DEFINE_MUTEX(thermal_list_lock);
>  static DEFINE_MUTEX(sensor_list_lock);
>  static DEFINE_MUTEX(zone_list_lock);
> +static DEFINE_MUTEX(cdev_list_lock);
>  static DEFINE_MUTEX(thermal_governor_lock);
>  
>  #define for_each_thermal_sensor(pos) \
> @@ -83,6 +84,9 @@ static DEFINE_MUTEX(thermal_governor_lock);
>  	ret;						\
>  })
>  
> +#define for_each_cdev(pos) \
> +	list_for_each_entry(pos, &thermal_cdev_list, node)
> +
>  static struct thermal_governor *__find_governor(const char *name)
>  {
>  	struct thermal_governor *pos;
> @@ -466,6 +470,24 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
>  	tz->sensor_indx--;
>  }
>  
> +static void remove_cdev_from_zone(struct thermal_zone *tz,
> +				struct thermal_cooling_device *cdev)
> +{
> +	int j, indx;
> +
> +	indx = GET_INDEX(tz, cdev, cdev);
> +	if (indx < 0)
> +		return;
> +
> +	sysfs_remove_link(&tz->device.kobj, kobject_name(&cdev->device.kobj));
> +
> +	/* Shift the entries in the tz->cdevs array */
> +	for (j = indx; j < MAX_CDEVS_PER_ZONE - 1; j++)
> +		tz->cdevs[j] = tz->cdevs[j + 1];
> +
> +	tz->cdev_indx--;
> +}
> +
>  /* sys I/F for thermal zone */
>  
>  #define to_thermal_zone(_dev) \
> @@ -1462,6 +1484,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
>  	int i;
>  	const struct thermal_zone_params *tzp;
>  	struct thermal_zone_device *tz;
> +	struct thermal_zone *tmp_tz;
>  	struct thermal_cooling_device *pos = NULL;
>  
>  	if (!cdev)
> @@ -1499,6 +1522,13 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
>  
>  	mutex_unlock(&thermal_list_lock);
>  
> +	mutex_lock(&zone_list_lock);
> +
> +	for_each_thermal_zone(tmp_tz)
> +		remove_cdev_from_zone(tmp_tz, cdev);
> +
> +	mutex_unlock(&zone_list_lock);
> +
>  	if (cdev->type[0])
>  		device_remove_file(&cdev->device, &dev_attr_cdev_type);
>  	device_remove_file(&cdev->device, &dev_attr_max_state);
> @@ -1794,6 +1824,23 @@ exit:
>  }
>  EXPORT_SYMBOL(remove_thermal_zone);
>  
> +struct thermal_cooling_device *get_cdev_by_name(const char *name)
> +{
> +	struct thermal_cooling_device *pos;
> +	struct thermal_cooling_device *cdev = NULL;
> +
> +	mutex_lock(&cdev_list_lock);
> +	for_each_cdev(pos) {
> +		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
> +			cdev = pos;
> +			break;
the same comments as the Patch 2/8.

> +		}
> +	}
> +	mutex_unlock(&cdev_list_lock);
> +	return cdev;
> +}
> +EXPORT_SYMBOL(get_cdev_by_name);
> +
>  struct thermal_sensor *get_sensor_by_name(const char *name)
>  {
>  	struct thermal_sensor *pos;
> @@ -1844,6 +1891,39 @@ exit_zone:
>  }
>  EXPORT_SYMBOL(add_sensor_to_zone);
>  
> +int add_cdev_to_zone(struct thermal_zone *tz,
> +			struct thermal_cooling_device *cdev)
> +{
> +	int ret;
> +
> +	if (!tz || !cdev)
> +		return -EINVAL;
> +
> +	mutex_lock(&zone_list_lock);
> +
> +	/* Ensure we are not adding the same cdev again!! */
> +	ret = GET_INDEX(tz, cdev, cdev);
> +	if (ret >= 0) {
> +		ret = -EEXIST;
> +		goto exit_zone;
> +	}
> +
> +	mutex_lock(&cdev_list_lock);
> +	ret = sysfs_create_link(&tz->device.kobj, &cdev->device.kobj,
> +				kobject_name(&cdev->device.kobj));
> +	if (ret)
> +		goto exit_cdev;
> +
> +	tz->cdevs[tz->cdev_indx++] = cdev;
> +
> +exit_cdev:
> +	mutex_unlock(&cdev_list_lock);
> +exit_zone:
> +	mutex_unlock(&zone_list_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(add_cdev_to_zone);
> +
Hmmm,
I'd prefer to see the code organized in this way:
/* thermal zone APIs/
thermal_zone_device_register()
thermal_zone_device_unregister()
add_thermal_zone()
remove_thermal_zone()

/* sensor APIs */
thermal_sensor_register()
thermal_sensor_unregister()
add_sensor_to_zone()
remove_sensor_from_zone()

/* cdev APIs */
thermal_cooling_device_register()
thermal_cooling_device_unregister()
add_cdev_to_zone()
remove_cdev_from_zone()

/* helper APIs */
get_sensor_by_name()
get_cdev_by_name()

but if this makes your rebase MUCH more difficult, I think we can
generate an incremental cleanup patch instead.

thanks,
rui


