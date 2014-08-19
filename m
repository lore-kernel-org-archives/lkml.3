Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaHSMtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:49:36 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43020 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHSMte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:49:34 -0400
MIME-Version: 1.0
In-Reply-To: <1405001928-12697-6-git-send-email-javi.merino@arm.com>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
	<1405001928-12697-6-git-send-email-javi.merino@arm.com>
Date: Tue, 19 Aug 2014 08:49:32 -0400
Message-ID: <CAC-25o8mcFXXykms5Ro+bLCztRKda3yg7BQHAg0+oZNT_Ym++w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 05/10] thermal: let governors have private data for
 each thermal zone
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Punit Agrawal <punit.agrawal@arm.com>, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javi,

On Thu, Jul 10, 2014 at 10:18 AM, Javi Merino <javi.merino@arm.com> wrote:
> A governor may need to store its current state between calls to
> throttle().  That state depends on the thermal zone, so store it as
> private data in struct thermal_zone_device.
>
> The governors may have two new ops: bind_to_tz() and unbind_from_tz().
> When provided, these functions let governors do some initialization
> and teardown when they are bound/unbound to a tz and possibly store that
> information in the governor_data field of the struct
> thermal_zone_device.
>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  drivers/thermal/thermal_core.c | 83 ++++++++++++++++++++++++++++++++++++++----
>  include/linux/thermal.h        |  9 +++++
>  2 files changed, 84 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 71b0ec0c370d..3da99dd80ad5 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -72,6 +72,58 @@ static struct thermal_governor *__find_governor(const char *name)
>         return NULL;
>  }
>
> +/**
> + * bind_previous_governor() - bind the previous governor of the thermal zone
> + * @tz:                a valid pointer to a struct thermal_zone_device
> + * @failed_gov_name:   the name of the governor that failed to register
> + *
> + * Register the previous governor of the thermal zone after a new
> + * governor has failed to be bound.
> + */
> +static void bind_previous_governor(struct thermal_zone_device *tz,
> +                               const char *failed_gov_name)
> +{
> +       if (tz->governor && tz->governor->bind_to_tz) {
> +               if (tz->governor->bind_to_tz(tz)) {
> +                       dev_warn(&tz->device,
> +                               "governor %s failed to bind and the previous one (%s) failed to register again, thermal zone %s has no governor\n",
> +                               failed_gov_name, tz->governor->name, tz->type);

The above must be a dev_err(), not warn. Besides, I would prefer if
you could improve the message. What is the difference between register
and bind?

> +                       tz->governor = NULL;
> +               }
> +       }
> +}
> +
> +/**
> + * thermal_set_governor() - Switch to another governor
> + * @tz:                a valid pointer to a struct thermal_zone_device
> + * @new_gov:   pointer to the new governor
> + *
> + * Change the governor of thermal zone @tz.
> + *
> + * Return: 0 on success, an error if the new governor's bind_to_tz() failed.
> + */
> +static int thermal_set_governor(struct thermal_zone_device *tz,
> +                               struct thermal_governor *new_gov)
> +{
> +       int ret = 0;
> +
> +       if (tz->governor && tz->governor->unbind_from_tz)
> +               tz->governor->unbind_from_tz(tz);
> +
> +       if (new_gov && new_gov->bind_to_tz) {
> +               ret = new_gov->bind_to_tz(tz);
> +               if (ret) {
> +                       bind_previous_governor(tz, new_gov->name);
> +
> +                       return ret;
> +               }
> +       }
> +
> +       tz->governor = new_gov;
> +
> +       return ret;
> +}
> +
>  int thermal_register_governor(struct thermal_governor *governor)
>  {
>         int err;
> @@ -104,8 +156,15 @@ int thermal_register_governor(struct thermal_governor *governor)
>
>                 name = pos->tzp->governor_name;
>
> -               if (!strnicmp(name, governor->name, THERMAL_NAME_LENGTH))
> -                       pos->governor = governor;
> +               if (!strnicmp(name, governor->name, THERMAL_NAME_LENGTH)) {
> +                       int ret;
> +
> +                       ret = thermal_set_governor(pos, governor);
> +                       if (ret)
> +                               dev_warn(&pos->device,
> +                                       "Failed to set governor %s for thermal zone %s: %d\n",
> +                                       governor->name, pos->type, ret);

dev_err here too.

> +               }
>         }
>
>         mutex_unlock(&thermal_list_lock);
> @@ -131,7 +190,7 @@ void thermal_unregister_governor(struct thermal_governor *governor)
>         list_for_each_entry(pos, &thermal_tz_list, node) {
>                 if (!strnicmp(pos->governor->name, governor->name,
>                                                 THERMAL_NAME_LENGTH))
> -                       pos->governor = NULL;
> +                       thermal_set_governor(pos, NULL);
>         }
>
>         mutex_unlock(&thermal_list_lock);
> @@ -756,8 +815,9 @@ policy_store(struct device *dev, struct device_attribute *attr,
>         if (!gov)
>                 goto exit;
>
> -       tz->governor = gov;
> -       ret = count;
> +       ret = thermal_set_governor(tz, gov);
> +       if (!ret)
> +               ret = count;
>
>  exit:
>         mutex_unlock(&thermal_governor_lock);
> @@ -1452,6 +1512,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
>         int result;
>         int count;
>         int passive = 0;
> +       struct thermal_governor *governor;
>
>         if (type && strlen(type) >= THERMAL_NAME_LENGTH)
>                 return ERR_PTR(-EINVAL);
> @@ -1542,9 +1603,15 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
>         mutex_lock(&thermal_governor_lock);
>
>         if (tz->tzp)
> -               tz->governor = __find_governor(tz->tzp->governor_name);
> +               governor = __find_governor(tz->tzp->governor_name);
>         else
> -               tz->governor = def_governor;
> +               governor = def_governor;
> +
> +       result = thermal_set_governor(tz, governor);
> +       if (result) {
> +               mutex_unlock(&thermal_governor_lock);
> +               goto unregister;
> +       }
>
>         mutex_unlock(&thermal_governor_lock);
>
> @@ -1634,7 +1701,7 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
>                 device_remove_file(&tz->device, &dev_attr_mode);
>         device_remove_file(&tz->device, &dev_attr_policy);
>         remove_trip_attrs(tz);
> -       tz->governor = NULL;
> +       thermal_set_governor(tz, NULL);
>
>         thermal_remove_hwmon_sysfs(tz);
>         release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 0305cde21a74..1124b7a9358a 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -187,6 +187,7 @@ struct thermal_attr {
>   * @ops:       operations this &thermal_zone_device supports
>   * @tzp:       thermal zone parameters
>   * @governor:  pointer to the governor for this thermal zone
> + * @governor_data:     private pointer for governor data
>   * @thermal_instances: list of &struct thermal_instance of this thermal zone
>   * @idr:       &struct idr to generate unique id for this zone's cooling
>   *             devices
> @@ -213,6 +214,7 @@ struct thermal_zone_device {
>         struct thermal_zone_device_ops *ops;
>         const struct thermal_zone_params *tzp;
>         struct thermal_governor *governor;
> +       void *governor_data;
>         struct list_head thermal_instances;
>         struct idr idr;
>         struct mutex lock;
> @@ -223,12 +225,19 @@ struct thermal_zone_device {
>  /**
>   * struct thermal_governor - structure that holds thermal governor information
>   * @name:      name of the governor
> + * @bind_to_tz: callback called when binding to a thermal zone.  If it
> + *             returns 0, the governor is bound to the thermal zone,
> + *             otherwise it fails.
> + * @unbind_from_tz:    callback called when a governor is unbound from a
> + *                     thermal zone.
>   * @throttle:  callback called for every trip point even if temperature is
>   *             below the trip point temperature
>   * @governor_list:     node in thermal_governor_list (in thermal_core.c)
>   */
>  struct thermal_governor {
>         char name[THERMAL_NAME_LENGTH];
> +       int (*bind_to_tz)(struct thermal_zone_device *tz);
> +       void (*unbind_from_tz)(struct thermal_zone_device *tz);
>         int (*throttle)(struct thermal_zone_device *tz, int trip);
>         struct list_head        governor_list;
>  };
> --
> 1.9.1
>
>



-- 
Eduardo Bezerra Valentin
