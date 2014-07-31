Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaGaIbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:31:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:25176 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116AbaGaIbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:31:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578103217"
Message-ID: <1406795457.10148.17.camel@rzhang1-toshiba>
Subject: Re: [PATCH] thermal: tell cooling devices when a trip_point changes
From: Zhang Rui <rui.zhang@intel.com>
To: Matt Longnecker <mlongnecker@nvidia.com>
Cc: Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 31 Jul 2014 16:30:57 +0800
In-Reply-To: <53D97B70.1050305@nvidia.com>
References: <53D97B70.1050305@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 16:10 -0700, Matt Longnecker wrote:
> Some hardware can react autonomously at a programmed temperature.

if you have a temperature sensor, then you should have a thermal zone
device driver for it, right?

> For example, an SoC might implement a last ditch throttle or a
> hardware thermal shutdown.

And it should be handled by the thermal zone driver, who has the
knowledge of when to do throttle/shutdown.

>  The driver for such a device can
> register itself as a cooling_device with the thermal framework.
> 
cooling device just exports its cooling ability for thermal framework to
use. It never makes any decision about thermal control.

> With this change, the thermal framework notifies such a driver
> when userspace alters the relevant trip temperature so that
> the driver can reprogram its hardware
> 
When user space alters the trip temperature, the thermal zone device
driver is aware is this change, and it can optionally program the
hardware.

thanks,
rui
> Signed-off-by: Matt Longnecker <mlongnecker@nvidia.com>
> ---
>  drivers/thermal/thermal_core.c |   30 ++++++++++++++++++++++++++++++
>  include/linux/thermal.h        |    2 ++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 71b0ec0..f25272e 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -597,6 +597,7 @@ trip_point_temp_store(struct device *dev, struct device_attribute *attr,
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
>  	int trip, ret;
>  	unsigned long temperature;
> +	struct thermal_instance *pos = NULL;
>  
>  	if (!tz->ops->set_trip_temp)
>  		return -EPERM;
> @@ -609,6 +610,20 @@ trip_point_temp_store(struct device *dev, struct device_attribute *attr,
>  
>  	ret = tz->ops->set_trip_temp(tz, trip, temperature);
>  
> +	/*
> +	 * Notify bound cooling devices that this trip point changed.
> +	 * This is useful for cooling devices which represent a behavior
> +	 * which trips in hardware (e.g. catastrophic shutdown)
> +	 */
> +	list_for_each_entry(pos, &tz->thermal_instances, tz_node) {
> +		if (pos->tz == tz && pos->trip == trip && pos->cdev) {
> +			if (pos->cdev->ops->trip_point_changed)
> +				pos->cdev->ops->trip_point_changed(pos->cdev,
> +								   pos->tz,
> +								   trip);
> +		}
> +	}
> +
>  	return ret ? ret : count;
>  }
>  
> @@ -641,6 +656,7 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
>  	int trip, ret;
>  	unsigned long temperature;
> +	struct thermal_instance *pos = NULL;
>  
>  	if (!tz->ops->set_trip_hyst)
>  		return -EPERM;
> @@ -658,6 +674,20 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
>  	 */
>  	ret = tz->ops->set_trip_hyst(tz, trip, temperature);
>  
> +	/*
> +	 * Notify bound cooling devices that this trip point changed.
> +	 * This is useful for cooling devices which represent a behavior
> +	 * which trips in hardware (e.g. catastrophic shutdown)
> +	 */
> +	list_for_each_entry(pos, &tz->thermal_instances, tz_node) {
> +		if (pos->tz == tz && pos->trip == trip && pos->cdev) {
> +			if (pos->cdev->ops->trip_point_changed)
> +				pos->cdev->ops->trip_point_changed(pos->cdev,
> +								   pos->tz,
> +								   trip);
> +		}
> +	}
> +
>  	return ret ? ret : count;
>  }
>  
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7..7da7fc5 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -138,6 +138,8 @@ struct thermal_cooling_device_ops {
>  	int (*get_max_state) (struct thermal_cooling_device *, unsigned long *);
>  	int (*get_cur_state) (struct thermal_cooling_device *, unsigned long *);
>  	int (*set_cur_state) (struct thermal_cooling_device *, unsigned long);
> +	void (*trip_point_changed) (struct thermal_cooling_device *,
> +				    struct thermal_zone_device *, int);
>  };
>  
>  struct thermal_cooling_device {


