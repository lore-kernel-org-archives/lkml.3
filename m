Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3CAFIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:08:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:38351 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab3CAFIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:08:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,759,1355126400"; 
   d="scan'208";a="262970517"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 1/8] Thermal: Create sensor level APIs
Thread-Topic: [PATCH 1/8] Thermal: Create sensor level APIs
Thread-Index: AQHOA47fUTh8eaYnjUCCH+SxflpMBJiPZ+aAgAEDrHA=
Date: Fri, 1 Mar 2013 05:08:20 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59292A12@BGSMSX101.gar.corp.intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
 <1360061183-14137-2-git-send-email-durgadoss.r@intel.com>
 <512FA8DB.6000704@ti.com>
In-Reply-To: <512FA8DB.6000704@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> -----Original Message-----
> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> Sent: Friday, March 01, 2013 12:29 AM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 1/8] Thermal: Create sensor level APIs
> 
> Durga,
> 
> On 05-02-2013 06:46, Durgadoss R wrote:
> > This patch creates sensor level APIs, in the
> > generic thermal framework.
> >
> > A Thermal sensor is a piece of hardware that can report
> > temperature of the spot in which it is placed. A thermal
> > sensor driver reads the temperature from this sensor
> > and reports it out. This kind of driver can be in
> > any subsystem. If the sensor needs to participate
> > in platform thermal management, the corresponding
> > driver can use the APIs introduced in this patch, to
> > register(or unregister) with the thermal framework.
> 
> At first glance, patch seams reasonable. But I have one major concern as
> follows inline, apart from several minor comments.
> 
> >
> > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> > ---
> >   drivers/thermal/thermal_sys.c |  280
> +++++++++++++++++++++++++++++++++++++++++
> >   include/linux/thermal.h       |   29 +++++
> >   2 files changed, 309 insertions(+)
> >
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> > index 0a1bf6b..cb94497 100644
> > --- a/drivers/thermal/thermal_sys.c
> > +++ b/drivers/thermal/thermal_sys.c
> > @@ -44,13 +44,16 @@ MODULE_LICENSE("GPL");
> >
> >   static DEFINE_IDR(thermal_tz_idr);
> >   static DEFINE_IDR(thermal_cdev_idr);
> > +static DEFINE_IDR(thermal_sensor_idr);
> >   static DEFINE_MUTEX(thermal_idr_lock);
> >
> >   static LIST_HEAD(thermal_tz_list);
> > +static LIST_HEAD(thermal_sensor_list);
> >   static LIST_HEAD(thermal_cdev_list);
> >   static LIST_HEAD(thermal_governor_list);
> >
> >   static DEFINE_MUTEX(thermal_list_lock);
> > +static DEFINE_MUTEX(sensor_list_lock);
> >   static DEFINE_MUTEX(thermal_governor_lock);
> >
> >   static struct thermal_governor *__find_governor(const char *name)
> > @@ -423,6 +426,103 @@ static void thermal_zone_device_check(struct
> work_struct *work)
> >   #define to_thermal_zone(_dev) \
> >   	container_of(_dev, struct thermal_zone_device, device)
> >
> > +#define to_thermal_sensor(_dev) \
> > +	container_of(_dev, struct thermal_sensor, device)
> > +
> > +static ssize_t
> > +sensor_name_show(struct device *dev, struct device_attribute *attr,
> char *buf)
> > +{
> > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > +
> > +	return sprintf(buf, "%s\n", ts->name);
> 
> For security reasons:
> s/sprintf/snprintf
> 
> > +}
> > +
> > +static ssize_t
> > +sensor_temp_show(struct device *dev, struct device_attribute *attr,
> char *buf)
> > +{
> > +	int ret;
> > +	long val;
> > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > +
> > +	ret = ts->ops->get_temp(ts, &val);
> > +
> > +	return ret ? ret : sprintf(buf, "%ld\n", val);
> 
> ditto.
> 
> > +}
> > +
> > +static ssize_t
> > +hyst_show(struct device *dev, struct device_attribute *attr, char *buf)
> > +{
> > +	int indx, ret;
> > +	long val;
> > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > +
> > +	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
> 
> I'd rather check if it returns 1.
> 
> > +		return -EINVAL;
> > +
> > +	ret = ts->ops->get_hyst(ts, indx, &val);
> 
>  From your probe, you won't check for devices registered with
> ops.get_hyst == NULL. This may lead to a NULL pointer access above.

if ops.get_hyst is NULL, we don't even create these sysfs interfaces.
This check is in enable_sensor_thresholds function.

> 
> > +
> > +	return ret ? ret : sprintf(buf, "%ld\n", val);
> 
> snprintf.
> 
> > +}
> > +
> > +static ssize_t
> > +hyst_store(struct device *dev, struct device_attribute *attr,
> > +				   const char *buf, size_t count)
> > +{
> > +	int indx, ret;
> > +	long val;
> > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > +
> > +	if (!ts->ops->set_hyst)
> > +		return -EPERM;
> > +
> > +	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
> > +		return -EINVAL;
> > +
> > +	if (kstrtol(buf, 10, &val))
> > +		return -EINVAL;
> > +
> > +	ret = ts->ops->set_hyst(ts, indx, val);
> 
>  From your probe, you won't check for devices registered with
> ops.set_hyst == NULL. This may lead to a NULL pointer access above.
> 
> > +
> > +	return ret ? ret : count;
> > +}
> > +
> > +static ssize_t
> > +threshold_show(struct device *dev, struct device_attribute *attr, char
> *buf)
> > +{
> > +	int indx, ret;
> > +	long val;
> > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > +
> > +	if (!sscanf(attr->attr.name, "threshold%d", &indx))
> > +		return -EINVAL;
> > +
> > +	ret = ts->ops->get_threshold(ts, indx, &val);
>  From your probe, you won't check for devices registered with
> ops.get_threshold == NULL. This may lead to a NULL pointer access above.

It checks for ops.get_threshold, but not for the setter method.
Will take of that in next version.

> 
> > +
> > +	return ret ? ret : sprintf(buf, "%ld\n", val);
> > +}
> > +
> > +static ssize_t
> > +threshold_store(struct device *dev, struct device_attribute *attr,
> > +				   const char *buf, size_t count)
> > +{
> > +	int indx, ret;
> > +	long val;
> > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > +
> > +	if (!ts->ops->set_threshold)
> > +		return -EPERM;
> > +
> > +	if (!sscanf(attr->attr.name, "threshold%d", &indx))
> > +		return -EINVAL;
> > +
> > +	if (kstrtol(buf, 10, &val))
> > +		return -EINVAL;
> > +
> > +	ret = ts->ops->set_threshold(ts, indx, val);
> > +
> > +	return ret ? ret : count;
> > +}
> > +
> 
> One may be careful with the above functions. Userland having control on
> these properties may lead to spurious events, depending on the
> programming sequence / value changing order. I believe, it would be
> wiser to disable the interrupt generation prior to changing the thresholds.

Valid case. We call set_threshold from the framework layer, and leave it to the
sensor driver to take care of rest of the things.

> 
> >   static ssize_t
> >   type_show(struct device *dev, struct device_attribute *attr, char *buf)
> >   {
> > @@ -707,6 +807,10 @@ static DEVICE_ATTR(mode, 0644, mode_show,
> mode_store);
> >   static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show,
> passive_store);
> >   static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show,
> policy_store);
> >
> > +/* Thermal sensor attributes */
> > +static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
> > +static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
> > +
> >   /* sys I/F for cooling device */
> >   #define to_cooling_device(_dev)	\
> >   	container_of(_dev, struct thermal_cooling_device, device)
> > @@ -1493,6 +1597,182 @@ static void remove_trip_attrs(struct
> thermal_zone_device *tz)
> >   }
> >
> >   /**
> > + * enable_sensor_thresholds - create sysfs nodes for thresholdX
> > + * @ts:		the thermal sensor
> > + * @count:	Number of thresholds supported by sensor hardware
> > + *
> > + * 'Thresholds' are temperatures programmed into the sensor hardware,
> > + * on crossing which the sensor generates an interrupt. 'Trip points'
> > + * are temperatures which the thermal manager/governor thinks, some
> > + * action should be taken when the sensor reaches the value.
> > + */
> > +static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
> > +{
> > +	int i;
> > +	int size = sizeof(struct thermal_attr) * count;
> > +
> > +	ts->thresh_attrs = kzalloc(size, GFP_KERNEL);
> 
> how about using devm_ helpers?

Yes, I will use.

> 
> > +	if (!ts->thresh_attrs)
> > +		return -ENOMEM;
> > +
> > +	if (ts->ops->get_hyst) {
> > +		ts->hyst_attrs = kzalloc(size, GFP_KERNEL);
> > +		if (!ts->hyst_attrs) {
> > +			kfree(ts->thresh_attrs);
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +
> > +	ts->thresholds = count;
> > +
> > +	/* Create threshold attributes */
> > +	for (i = 0; i < count; i++) {
> > +		snprintf(ts->thresh_attrs[i].name,
> THERMAL_NAME_LENGTH,
> > +						 "threshold%d", i);
> > +
> > +		sysfs_attr_init(&ts->thresh_attrs[i].attr.attr);
> > +		ts->thresh_attrs[i].attr.attr.name = ts->thresh_attrs[i].name;
> > +		ts->thresh_attrs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
> > +		ts->thresh_attrs[i].attr.show = threshold_show;
> > +		ts->thresh_attrs[i].attr.store = threshold_store;
> > +
> > +		device_create_file(&ts->device, &ts->thresh_attrs[i].attr);
> > +
> > +		/* Create threshold_hyst attributes */
> > +		if (!ts->ops->get_hyst)
> > +			continue;
> > +
> > +		snprintf(ts->hyst_attrs[i].name, THERMAL_NAME_LENGTH,
> > +						 "threshold%d_hyst", i);
> > +
> > +		sysfs_attr_init(&ts->hyst_attrs[i].attr.attr);
> > +		ts->hyst_attrs[i].attr.attr.name = ts->hyst_attrs[i].name;
> > +		ts->hyst_attrs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
> > +		ts->hyst_attrs[i].attr.show = hyst_show;
> > +		ts->hyst_attrs[i].attr.store = hyst_store;
> > +
> > +		device_create_file(&ts->device, &ts->hyst_attrs[i].attr);
> > +	}
> > +	return 0;
> > +}
> > +
> 
> 
> I know there are people who is in favor of having the thermal policy
> controlled in userland.
> Depending on which thermal zone we are talking about, I'd even consider
> it a valid approach.

agreed.

> On the other hand there are thermal zones that controls silicon junction
> temperature which
> does not depend on any input from userland (like which kind of use case
> one may be running).
> 
> 
> That said, I believe we may want to segregate which sensors we want to
> expose the write access
> from userspace to their hyst and threshold values. Exposing all of them
> may lead to easy security leak.

If the sensor driver does not want this hysteresis to be writeable,
it can provide a NULL pointer in ops.set_hyst. 

Most of sprintf, strcpy I used them for consistency, as rest of the
framework code is already using these APIs.
We can do a separate clean up patch for these functions, IMHO.

That said, I also get hurt by static checkers on these :-)So, I agree with
you that these should be fixed, but not in this series.

Thanks,
Durga
