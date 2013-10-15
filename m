Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab3JOJpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:45:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:4176 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3JOJpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:45:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="374895990"
Message-ID: <1381830300.2080.36.camel@rzhang1-mobl4>
Subject: RE: [PATCHv4 2/9] Thermal: Create sensor level APIs
From: Zhang Rui <rui.zhang@intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@freescale.com" <hongbo.zhang@freescale.com>,
        "wni@nvidia.com" <wni@nvidia.com>
Date: Tue, 15 Oct 2013 17:45:00 +0800
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59DADB0B@BGSMSX101.gar.corp.intel.com>
References: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
	 <1380652688-5787-3-git-send-email-durgadoss.r@intel.com>
	 <1381742769.2034.26.camel@rzhang1-mobl4>
	 <4D68720C2E767A4AA6A8796D42C8EB59DADB0B@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 10:21 -0600, R, Durgadoss wrote:
> Hi Rui,
> 
> > -----Original Message-----
> > From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> > owner@vger.kernel.org] On Behalf Of Zhang Rui
> > Sent: Monday, October 14, 2013 2:56 PM
> > To: R, Durgadoss
> > Cc: eduardo.valentin@ti.com; linux-pm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; hongbo.zhang@freescale.com; wni@nvidia.com
> > Subject: Re: [PATCHv4 2/9] Thermal: Create sensor level APIs
> > 
> > On Wed, 2013-10-02 at 00:08 +0530, Durgadoss R wrote:
> > > This patch creates sensor level APIs, in the
> > > generic thermal framework.
> > >
> > > A Thermal sensor is a piece of hardware that can report
> > > temperature of the spot in which it is placed. A thermal
> > > sensor driver reads the temperature from this sensor
> > > and reports it out. This kind of driver can be in
> > > any subsystem. If the sensor needs to participate
> > > in platform thermal management, the corresponding
> > > driver can use the APIs introduced in this patch, to
> > > register(or unregister) with the thermal framework.
> > >
> > > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> > > ---
> > >  drivers/thermal/thermal_core.c |  284
> > ++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/thermal.h        |   29 ++++
> > >  2 files changed, 313 insertions(+)
> > >
> > > diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> > > index 8c5131d..8c46567 100644
> > > --- a/drivers/thermal/thermal_core.c
> > > +++ b/drivers/thermal/thermal_core.c
> > > @@ -45,13 +45,16 @@ MODULE_LICENSE("GPL v2");
> > >
> > >  static DEFINE_IDR(thermal_tz_idr);
> > >  static DEFINE_IDR(thermal_cdev_idr);
> > > +static DEFINE_IDR(thermal_sensor_idr);
> > >  static DEFINE_MUTEX(thermal_idr_lock);
> > >
> > >  static LIST_HEAD(thermal_tz_list);
> > > +static LIST_HEAD(thermal_sensor_list);
> > >  static LIST_HEAD(thermal_cdev_list);
> > >  static LIST_HEAD(thermal_governor_list);
> > >
> > >  static DEFINE_MUTEX(thermal_list_lock);
> > > +static DEFINE_MUTEX(sensor_list_lock);
> > >  static DEFINE_MUTEX(thermal_governor_lock);
> > >
> > >  static struct thermal_governor *__find_governor(const char *name)
> > > @@ -463,6 +466,103 @@ static void thermal_zone_device_check(struct
> > work_struct *work)
> > >  #define to_thermal_zone(_dev) \
> > >  	container_of(_dev, struct thermal_zone_device, device)
> > >
> > > +#define to_thermal_sensor(_dev) \
> > > +	container_of(_dev, struct thermal_sensor, device)
> > > +
> > > +static ssize_t
> > > +sensor_name_show(struct device *dev, struct device_attribute *attr, char
> > *buf)
> > > +{
> > > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > > +
> > > +	return sprintf(buf, "%s\n", ts->name);
> > > +}
> > > +
> > > +static ssize_t
> > > +sensor_temp_show(struct device *dev, struct device_attribute *attr, char
> > *buf)
> > > +{
> > > +	int ret;
> > > +	long val;
> > > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > > +
> > > +	ret = ts->ops->get_temp(ts, &val);
> > > +
> > > +	return ret ? ret : sprintf(buf, "%ld\n", val);
> > > +}
> > > +
> > > +static ssize_t
> > > +hyst_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > +{
> > > +	int indx, ret;
> > > +	long val;
> > > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > > +
> > > +	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
> > > +		return -EINVAL;
> > > +
> > > +	ret = ts->ops->get_hyst(ts, indx, &val);
> > > +
> > > +	return ret ? ret : sprintf(buf, "%ld\n", val);
> > > +}
> > > +
> > > +static ssize_t
> > > +hyst_store(struct device *dev, struct device_attribute *attr,
> > > +				   const char *buf, size_t count)
> > > +{
> > > +	int indx, ret;
> > > +	long val;
> > > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > > +
> > > +	if (!ts->ops->set_hyst)
> > > +		return -EPERM;
> > > +
> > > +	if (!sscanf(attr->attr.name, "threshold%d_hyst", &indx))
> > > +		return -EINVAL;
> > > +
> > > +	if (kstrtol(buf, 10, &val))
> > > +		return -EINVAL;
> > > +
> > > +	ret = ts->ops->set_hyst(ts, indx, val);
> > > +
> > > +	return ret ? ret : count;
> > > +}
> > > +
> > > +static ssize_t
> > > +threshold_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > +{
> > > +	int indx, ret;
> > > +	long val;
> > > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > > +
> > > +	if (!sscanf(attr->attr.name, "threshold%d", &indx))
> > > +		return -EINVAL;
> > > +
> > > +	ret = ts->ops->get_threshold(ts, indx, &val);
> > > +
> > > +	return ret ? ret : sprintf(buf, "%ld\n", val);
> > > +}
> > > +
> > > +static ssize_t
> > > +threshold_store(struct device *dev, struct device_attribute *attr,
> > > +				   const char *buf, size_t count)
> > > +{
> > > +	int indx, ret;
> > > +	long val;
> > > +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> > > +
> > > +	if (!ts->ops->set_threshold)
> > > +		return -EPERM;
> > > +
> > > +	if (!sscanf(attr->attr.name, "threshold%d", &indx))
> > > +		return -EINVAL;
> > > +
> > > +	if (kstrtol(buf, 10, &val))
> > > +		return -EINVAL;
> > > +
> > > +	ret = ts->ops->set_threshold(ts, indx, val);
> > > +
> > > +	return ret ? ret : count;
> > > +}
> > > +
> > >  static ssize_t
> > >  type_show(struct device *dev, struct device_attribute *attr, char *buf)
> > >  {
> > > @@ -772,6 +872,10 @@ static DEVICE_ATTR(mode, 0644, mode_show,
> > mode_store);
> > >  static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show,
> > passive_store);
> > >  static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
> > >
> > > +/* Thermal sensor attributes */
> > > +static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
> > 
> > this attribute is under sensorX/ directory, thus I think "name" is clear
> > enough.
> > what do you think?
> 
> Yes. That makes sense. I will give this a try in next version.
> 
> > 
> > > +static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
> > > +
> > what about "temp"? to be consistent with the current naming.
> 
> I think I tried this, but we already had a 'temp' attribute. So, was compelled
> to give another name.
> 
> I will try this one again and let you know.
> 
> > 
> > >  /* sys I/F for cooling device */
> > >  #define to_cooling_device(_dev)	\
> > >  	container_of(_dev, struct thermal_cooling_device, device)
> > > @@ -1585,6 +1689,186 @@ static void remove_trip_attrs(struct
> > thermal_zone_device *tz)
> > >  	kfree(tz->trip_hyst_attrs);
> > >  }
> > >
> > > + /**
> > > + * enable_sensor_thresholds - create sysfs nodes for thresholdX
> > IMO, this name is confusing. It looks like that you are enabling the
> > sensor hardware here.
> > so why not "thermal_sensor_sysfs_add", and you can add the "name" and
> > "temp" attribute in this function as well.
> 
> Okay. Will do.
> 
> > 
> > > + * @ts:		the thermal sensor
> > > + * @count:	Number of thresholds supported by sensor hardware
> > > + *
> > > + * 'Thresholds' are temperatures programmed into the sensor hardware,
> > > + * on crossing which the sensor can generate an interrupt.
> > > + */
> > > +static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
> > > +{
> > > +	int i;
> > > +	int size = sizeof(struct thermal_attr) * count;
> > > +
> > > +	ts->thresh_attrs = devm_kzalloc(&ts->device, size, GFP_KERNEL);
> > > +	if (!ts->thresh_attrs)
> > > +		return -ENOMEM;
> > > +
> > > +	if (ts->ops->get_hyst) {
> > > +		ts->hyst_attrs = devm_kzalloc(&ts->device, size, GFP_KERNEL);
> > > +		if (!ts->hyst_attrs)
> > > +			return -ENOMEM;
> > > +	}
> > > +
> > I do not think you can use devm_kzalloc here.
> 
> Any specific reason ?
> I thought this memory will be freed when we do device_unregister on 'ts'.
> Please enlighten me if this is not the case.
> 
yes, you're right. It is me misunderstood your code.
Sorry about the noise.

thanks,
rui



