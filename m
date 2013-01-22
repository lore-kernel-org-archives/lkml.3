Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3AVDUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:20:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:48464 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab3AVDUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:20:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="276776859"
Message-ID: <1358824804.2607.31.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/2] thermal: sysfs: Add a new sysfs node emul_temp
From: Zhang Rui <rui.zhang@intel.com>
To: amit kachhap <amit.kachhap@gmail.com>
Cc: linux-pm@vger.kernel.org, jonghwa3.lee@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Durgadoss <durgadoss.r@intel.com>
Date: Tue, 22 Jan 2013 11:20:04 +0800
In-Reply-To: <CADGdYn4CWscQf0y6dmgYUsKB8u25BOmLYq+T64haBKpwnZ3KBQ@mail.gmail.com>
References: <1357517296-31402-1-git-send-email-amit.daniel@samsung.com>
	 <1358321601.2252.36.camel@rzhang1-mobl4>
	 <CADGdYn4CWscQf0y6dmgYUsKB8u25BOmLYq+T64haBKpwnZ3KBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 11:30 -0800, amit kachhap wrote:
> Hi Rui,
> 
> Thanks for the review comments,
> On Tue, Jan 15, 2013 at 11:33 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> > Hi, Amit,
> >
> > On Sun, 2013-01-06 at 16:08 -0800, Amit Daniel Kachhap wrote:
> >> This patch adds support to set the emulated temperature method in
> >> thermal zone (sensor). After setting this feature thermal zone must
> >> report this temperature and not the actual temperature. The actual
> >> implementation of this emulated temperature is based on sensor
> >> capability or platform specific. This is useful in debugging different
> >> temperature threshold and its associated cooling action. Writing 0 on
> >> this node should disable emulation.
> >
> > Question:
> > will this bring hardware issue? Say, critical temperature reached while
> > in emulation mode?
> No emulation does cause any h/w issue.
> >
> > As this is for debug purpose, I'd prefer to have a seperate Kconfig
> > option for this feature.
> Yes agreed. Will re-submit with kconfig option.
> >
> >> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >> ---
> >>  Documentation/thermal/sysfs-api.txt |   14 ++++++++++++++
> >>  drivers/thermal/thermal_sys.c       |   26 ++++++++++++++++++++++++++
> >>  include/linux/thermal.h             |    1 +
> >>  3 files changed, 41 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
> >> index 88c0233..e8f2ee4 100644
> >> --- a/Documentation/thermal/sysfs-api.txt
> >> +++ b/Documentation/thermal/sysfs-api.txt
> >> @@ -55,6 +55,8 @@ temperature) and throttle appropriate devices.
> >>       .get_trip_type: get the type of certain trip point.
> >>       .get_trip_temp: get the temperature above which the certain trip point
> >>                       will be fired.
> >> +     .set_emul_temp: set the emulation temperature which helps in debugging
> >> +                     different threshold temperature points.
> >>
> >>  1.1.2 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
> >>
> >> @@ -153,6 +155,7 @@ Thermal zone device sys I/F, created once it's registered:
> >>      |---trip_point_[0-*]_temp:       Trip point temperature
> >>      |---trip_point_[0-*]_type:       Trip point type
> >>      |---trip_point_[0-*]_hyst:       Hysteresis value for this trip point
> >> +    |---emul_temp:           Emulated temperature set node
> >>
> >>  Thermal cooling device sys I/F, created once it's registered:
> >>  /sys/class/thermal/cooling_device[0-*]:
> >> @@ -252,6 +255,17 @@ passive
> >>       Valid values: 0 (disabled) or greater than 1000
> >>       RW, Optional
> >>
> >> +emul_temp
> >> +     Interface to set the emulated temperature method in thermal zone
> >> +     (sensor). After setting this feature thermal zone must report
> >> +     this temperature and not the actual temperature. The actual
> >> +     implementation of this emulated temperature is platform specific.
> >
> > can we have a pure software temperature emulation method?
> > say, the generic thermal layer caches the emulated temperature value,
> > and hook it in update_temperature()?
> > This is also useful for testing in polling mode, and it does not require
> > platform specific callback support. I mean thermal_ops->set_emul_temp is
> > optional, but thermal emulation is always available for all platforms.
> Yes It makes sense and we can have pure software emulation and use the
> cached temperature when no platform call is registered. In my case I
> needed this in h/w so to have the same sensor trigger interrupts
> behaviour.
> 
> So the code flow can be like this,
> 
> #ifdef CONFIG_THERMAL_EMULATION
> if (thermal_ops->set_emul_temp)
> then pass emul_temp to platform and use the normal platform
> thermal_ops->get_temp
> else
> Store it locally and use emul_temp  instead of calling platform
> thermal_ops->get_temp
> #endif
> 
No.
We should not support emulation is CONFIG_THERMAL_EMULATION is cleared.
And further more, for pure software emulation, we should check if the
real temperature reaches critical trip point.

thanks,
rui
> I will re-submit with this change.
> 
> Thanks,
> Amit
> >
> > thanks,
> > rui
> >> +     This is useful in debugging different temperature threshold and its
> >> +     associated cooling action. Writing 0 on this node should disable
> >> +     emulation.
> >> +     Unit: millidegree Celsius
> >> +     WO, Optional
> >> +
> >>  *****************************
> >>  * Cooling device attributes *
> >>  *****************************
> >> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> >> index 8c8ce80..ecdfc7d 100644
> >> --- a/drivers/thermal/thermal_sys.c
> >> +++ b/drivers/thermal/thermal_sys.c
> >> @@ -700,11 +700,31 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
> >>       return sprintf(buf, "%s\n", tz->governor->name);
> >>  }
> >>
> >> +static ssize_t
> >> +emul_temp_store(struct device *dev, struct device_attribute *attr,
> >> +                  const char *buf, size_t count)
> >> +{
> >> +     struct thermal_zone_device *tz = to_thermal_zone(dev);
> >> +     int ret;
> >> +     unsigned long temperature;
> >> +
> >> +     if (!tz->ops->set_emul_temp)
> >> +             return -EPERM;
> >> +
> >> +     if (kstrtoul(buf, 10, &temperature))
> >> +             return -EINVAL;
> >> +
> >> +     ret = tz->ops->set_emul_temp(tz, temperature);
> >> +
> >> +     return ret ? ret : count;
> >> +}
> >> +
> >>  static DEVICE_ATTR(type, 0444, type_show, NULL);
> >>  static DEVICE_ATTR(temp, 0444, temp_show, NULL);
> >>  static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
> >>  static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
> >>  static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
> >> +static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
> >>
> >>  /* sys I/F for cooling device */
> >>  #define to_cooling_device(_dev)      \
> >> @@ -1592,6 +1612,12 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
> >>                       goto unregister;
> >>       }
> >>
> >> +     if (ops->set_emul_temp) {
> >> +             result = device_create_file(&tz->device, &dev_attr_emul_temp);
> >> +             if (result)
> >> +                     goto unregister;
> >> +     }
> >> +
> >>       /* Create policy attribute */
> >>       result = device_create_file(&tz->device, &dev_attr_policy);
> >>       if (result)
> >> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> >> index 883bcda..fbb87d4 100644
> >> --- a/include/linux/thermal.h
> >> +++ b/include/linux/thermal.h
> >> @@ -123,6 +123,7 @@ struct thermal_zone_device_ops {
> >>       int (*set_trip_hyst) (struct thermal_zone_device *, int,
> >>                             unsigned long);
> >>       int (*get_crit_temp) (struct thermal_zone_device *, unsigned long *);
> >> +     int (*set_emul_temp) (struct thermal_zone_device *, unsigned long);
> >>       int (*get_trend) (struct thermal_zone_device *, int,
> >>                         enum thermal_trend *);
> >>       int (*notify) (struct thermal_zone_device *, int,
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


