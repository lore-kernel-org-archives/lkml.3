Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab3JOK15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:27:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:61130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273Ab3JOK1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:27:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="393122169"
Message-ID: <1381832870.2080.42.camel@rzhang1-mobl4>
Subject: Re: [PATCHv4 4/9] Thermal: Add APIs to bind cdev to new zone
 structure
From: Zhang Rui <rui.zhang@intel.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com,
        wni@nvidia.com
Date: Tue, 15 Oct 2013 18:27:50 +0800
In-Reply-To: <1380652688-5787-5-git-send-email-durgadoss.r@intel.com>
References: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
	 <1380652688-5787-5-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 00:08 +0530, Durgadoss R wrote:
> This patch creates new APIs to add/remove a
> cdev to/from a zone. This patch does not change
> the old cooling device implementation.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
I'm okay with this patch except the API naming.

thanks,
rui
> ---
>  drivers/thermal/thermal_core.c |  136 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h        |    9 +++
>  2 files changed, 145 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index a053b60..3c4ef62 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -58,6 +58,7 @@ static LIST_HEAD(thermal_governor_list);
>  static DEFINE_MUTEX(thermal_list_lock);
>  static DEFINE_MUTEX(sensor_list_lock);
>  static DEFINE_MUTEX(zone_list_lock);
> +static DEFINE_MUTEX(cdev_list_lock);
>  static DEFINE_MUTEX(thermal_governor_lock);
>  
>  #define for_each_thermal_sensor(pos) \
> @@ -86,6 +87,9 @@ static DEFINE_MUTEX(thermal_governor_lock);
>  	ret;						\
>  })
>  
> +#define for_each_cdev(pos) \
> +	list_for_each_entry(pos, &thermal_cdev_list, node)
> +
>  static struct thermal_governor *__find_governor(const char *name)
>  {
>  	struct thermal_governor *pos;
> @@ -511,6 +515,27 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
>  	mutex_unlock(&tz->lock);
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
> +	mutex_lock(&tz->lock);
> +
> +	/* Shift the entries in the tz->cdevs array */
> +	for (j = indx; j < MAX_CDEVS_PER_ZONE - 1; j++)
> +		tz->cdevs[j] = tz->cdevs[j + 1];
> +
> +	tz->cdev_indx--;
> +	mutex_unlock(&tz->lock);
> +}
> +
>  /* sys I/F for thermal zone */
>  
>  #define to_thermal_zone(_dev) \
> @@ -1555,6 +1580,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
>  	int i;
>  	const struct thermal_zone_params *tzp;
>  	struct thermal_zone_device *tz;
> +	struct thermal_zone *tmp_tz;
>  	struct thermal_cooling_device *pos = NULL;
>  
>  	if (!cdev)
> @@ -1592,6 +1618,13 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
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
> @@ -1873,6 +1906,7 @@ void remove_thermal_zone(struct thermal_zone *tz)
>  {
>  	struct thermal_zone *pos, *next;
>  	struct thermal_sensor *ts;
> +	struct thermal_cooling_device *cdev;
>  	bool found = false;
>  
>  	if (!tz)
> @@ -1894,6 +1928,9 @@ void remove_thermal_zone(struct thermal_zone *tz)
>  	for_each_thermal_sensor(ts)
>  		remove_sensor_from_zone(tz, ts);
>  
> +	for_each_cdev(cdev)
> +		remove_cdev_from_zone(tz, cdev);
> +
>  	device_remove_file(&tz->device, &dev_attr_zone_name);
>  
>  	mutex_destroy(&tz->lock);
> @@ -1909,6 +1946,47 @@ exit:
>  EXPORT_SYMBOL(remove_thermal_zone);
>  
>  /**
> + * get_cdev_by_name() - search for a cdev and returns its reference
> + * @name: cooling device name to fetch the reference
> + *
> + * On success returns a reference to an unique cdev with
> + * the name matching that of @name, an ERR_PTR otherwise:
> + * -EINVAL for invalid paramenters
> + * -ENODEV for cdev not found
> + * -EEXIST for multiple matches
> + */
> +struct thermal_cooling_device *get_cdev_by_name(const char *name)
> +{
> +	int found = 0;
> +	struct thermal_cooling_device *pos;
> +	struct thermal_cooling_device *cdev = ERR_PTR(-EINVAL);
> +
> +	if (!name)
> +		return cdev;
> +
> +	mutex_lock(&cdev_list_lock);
> +	for_each_cdev(pos) {
> +		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
> +			found++;
> +			cdev = pos;
> +		}
> +	}
> +	mutex_unlock(&cdev_list_lock);
> +
> +	/*
> +	 * Nothing has been found; return an error code for it.
> +	 * Return success only when an unique cdev is found.
> +	 */
> +	if (found == 0)
> +		cdev = ERR_PTR(-ENODEV);
> +	else if (found > 1)
> +		cdev = ERR_PTR(-EEXIST);
> +
> +	return cdev;
> +}
> +EXPORT_SYMBOL(get_cdev_by_name);
> +
> +/**
>   * get_sensor_by_name() - search for a sensor and returns its reference
>   * @name: thermal sensor name to fetch the reference
>   *
> @@ -2003,6 +2081,64 @@ exit_zone:
>  EXPORT_SYMBOL(add_sensor_to_zone);
>  
>  /**
> + * add_cdev_to_zone - Add @cdev to thermal zone @tz
> + * @tz:		Thermal zone reference
> + * @cdev:	Cooling device reference
> + *
> + * Returns 0 on success, otherwise
> + * -EINVAL for invalid paramenters
> + * -EINVAL when trying to add more cdevs than MAX_CDEVS_PER_ZONE
> + * -EEXIST when trying add existing cdev again
> + */
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
> +	/* Protect against 'cdev' being unregistered */
> +	mutex_lock(&cdev_list_lock);
> +
> +	ret = sysfs_create_link(&tz->device.kobj, &cdev->device.kobj,
> +				kobject_name(&cdev->device.kobj));
> +	if (ret)
> +		goto exit_cdev;
> +
> +	mutex_lock(&tz->lock);
> +
> +	if (tz->cdev_indx >= MAX_CDEVS_PER_ZONE - 1) {
> +		dev_err(&tz->device, "Only %d cdevs allowed per zone\n",
> +					MAX_CDEVS_PER_ZONE);
> +		sysfs_remove_link(&tz->device.kobj,
> +				kobject_name(&cdev->device.kobj));
> +		ret = -EINVAL;
> +		goto exit_indx_check;
> +	}
> +
> +	tz->cdevs[tz->cdev_indx++] = cdev;
> +
> +exit_indx_check:
> +	mutex_unlock(&tz->lock);
> +exit_cdev:
> +	mutex_unlock(&cdev_list_lock);
> +exit_zone:
> +	mutex_unlock(&zone_list_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(add_cdev_to_zone);
> +
> +/**
>   * thermal_sensor_register - register a new thermal sensor
>   * @name:	name of the thermal sensor
>   * @count:	Number of thresholds supported by hardware
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 2e12321..da7520c 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -60,6 +60,8 @@
>  
>  #define MAX_SENSORS_PER_ZONE		5
>  
> +#define MAX_CDEVS_PER_ZONE		5
> +
>  struct thermal_sensor;
>  struct thermal_zone_device;
>  struct thermal_cooling_device;
> @@ -223,6 +225,10 @@ struct thermal_zone {
>  	/* Sensor level information */
>  	int sensor_indx; /* index into 'sensors' array */
>  	struct thermal_sensor *sensors[MAX_SENSORS_PER_ZONE];
> +
> +	/* cdev level information */
> +	int cdev_indx; /* index into 'cdevs' array */
> +	struct thermal_cooling_device *cdevs[MAX_CDEVS_PER_ZONE];
>  };
>  
>  /* Structure that holds thermal governor information */
> @@ -300,6 +306,9 @@ void remove_thermal_zone(struct thermal_zone *);
>  int add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
>  struct thermal_sensor *get_sensor_by_name(const char *);
>  
> +int add_cdev_to_zone(struct thermal_zone *, struct thermal_cooling_device *);
> +struct thermal_cooling_device *get_cdev_by_name(const char *);
> +
>  #ifdef CONFIG_NET
>  extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
>  						enum events event);


