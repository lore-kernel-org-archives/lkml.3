Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab3D2XK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:10:26 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49206 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967Ab3D2XKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:10:22 -0400
Date: Mon, 29 Apr 2013 16:10:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH 1/3 RFC] Driver core: Add offline/online device operations
Message-ID: <20130429231019.GB1333@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
 <1989524.p5J87p9Tnl@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1989524.p5J87p9Tnl@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 02:26:56PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> In some cases, graceful hot-removal of devices is not possible,
> although in principle the devices in question support hotplug.
> For example, that may happen for the last CPU in the system or
> for memory modules holding kernel memory.
> 
> In those cases it is nice to be able to check if the given device
> can be safely hot-removed before triggering a removal procedure
> that cannot be aborted or reversed.  Unfortunately, however, the
> kernel currently doesn't provide any support for that.
> 
> To address that deficiency, introduce support for offline and
> online operations that can be performed on devices, respectively,
> before a hot-removal and in case when it is necessary (or convenient)
> to put a device back online after a successful offline (that has not
> been followed by removal).  The idea is that the offline will fail
> whenever the given device cannot be gracefully removed from the
> system and it will not be allowed to use the device after a
> successful offline (until a subsequent online) in analogy with the
> existing CPU offline/online mechanism.
> 
> For now, the offline and online operations are introduced at the
> bus type level, as that should be sufficient for the most urgent use
> cases (CPUs and memory modules).  In the future, however, the
> approach may be extended to cover some more complicated device
> offline/online scenarios involving device drivers etc.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-devices-online |   19 +++
>  drivers/base/core.c                            |  134 +++++++++++++++++++++++++
>  include/linux/device.h                         |   21 +++
>  3 files changed, 174 insertions(+)
> 
> Index: linux-pm/include/linux/device.h
> ===================================================================
> --- linux-pm.orig/include/linux/device.h
> +++ linux-pm/include/linux/device.h
> @@ -70,6 +70,10 @@ extern void bus_remove_file(struct bus_t
>   *		the specific driver's probe to initial the matched device.
>   * @remove:	Called when a device removed from this bus.
>   * @shutdown:	Called at shut-down time to quiesce the device.
> + *
> + * @online:	Called to put the device back online (after offlining it).
> + * @offline:	Called to put the device offline for hot-removal. May fail.
> + *
>   * @suspend:	Called when a device on this bus wants to go to sleep mode.
>   * @resume:	Called to bring a device on this bus out of sleep mode.
>   * @pm:		Power management operations of this bus, callback the specific
> @@ -103,6 +107,9 @@ struct bus_type {
>  	int (*remove)(struct device *dev);
>  	void (*shutdown)(struct device *dev);
>  
> +	int (*online)(struct device *dev);
> +	int (*offline)(struct device *dev);
> +
>  	int (*suspend)(struct device *dev, pm_message_t state);
>  	int (*resume)(struct device *dev);
>  
> @@ -646,6 +653,8 @@ struct acpi_dev_node {
>   * @release:	Callback to free the device after all references have
>   * 		gone away. This should be set by the allocator of the
>   * 		device (i.e. the bus driver that discovered the device).
> + * @offline_disabled: If set, the device is permanently online.
> + * @offline:	Set after successful invocation of bus type's .offline().
>   *
>   * At the lowest level, every device in a Linux system is represented by an
>   * instance of struct device. The device structure contains the information
> @@ -718,6 +727,9 @@ struct device {
>  
>  	void	(*release)(struct device *dev);
>  	struct iommu_group	*iommu_group;
> +
> +	bool			offline_disabled:1;
> +	bool			offline:1;
>  };
>  
>  static inline struct device *kobj_to_dev(struct kobject *kobj)
> @@ -853,6 +865,15 @@ extern const char *device_get_devnode(st
>  extern void *dev_get_drvdata(const struct device *dev);
>  extern int dev_set_drvdata(struct device *dev, void *data);
>  
> +static inline bool device_supports_offline(struct device *dev)
> +{
> +	return dev->bus && dev->bus->offline && dev->bus->online;

Wouldn't it be easier for us to also check offline_disabled here as
well?  That would save the extra check when we go to create the sysfs
file.


> +}
> +
> +extern void lock_device_offline(void);
> +extern void unlock_device_offline(void);
> +extern int device_offline(struct device *dev);
> +extern int device_online(struct device *dev);
>  /*
>   * Root device objects for grouping under /sys/devices
>   */
> Index: linux-pm/drivers/base/core.c
> ===================================================================
> --- linux-pm.orig/drivers/base/core.c
> +++ linux-pm/drivers/base/core.c
> @@ -397,6 +397,40 @@ static ssize_t store_uevent(struct devic
>  static struct device_attribute uevent_attr =
>  	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
>  
> +static ssize_t show_online(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	bool ret;
> +
> +	lock_device_offline();
> +	ret = !dev->offline;
> +	unlock_device_offline();
> +	return sprintf(buf, "%u\n", ret);
> +}
> +
> +static ssize_t store_online(struct device *dev, struct device_attribute *attr,
> +			    const char *buf, size_t count)
> +{
> +	int ret;
> +
> +	lock_device_offline();
> +	switch (buf[0]) {
> +	case '0':
> +		ret = device_offline(dev);
> +		break;
> +	case '1':
> +		ret = device_online(dev);
> +		break;

Should we also accept 'y', 'Y', 'n', and 'N', like most boolean sysfs
files do?  I think we even have a kernel helper function for it
somewhere...

> +	default:
> +		ret = -EINVAL;
> +	}
> +	unlock_device_offline();
> +	return ret < 0 ? ret : count;
> +}
> +
> +static struct device_attribute online_attr =
> +	__ATTR(online, S_IRUGO | S_IWUSR, show_online, store_online);
> +
>  static int device_add_attributes(struct device *dev,
>  				 struct device_attribute *attrs)
>  {
> @@ -510,6 +544,12 @@ static int device_add_attrs(struct devic
>  	if (error)
>  		goto err_remove_type_groups;
>  
> +	if (device_supports_offline(dev) && !dev->offline_disabled) {
> +		error = device_create_file(dev, &online_attr);
> +		if (error)
> +			goto err_remove_type_groups;
> +	}
> +
>  	return 0;
>  
>   err_remove_type_groups:
> @@ -530,6 +570,7 @@ static void device_remove_attrs(struct d
>  	struct class *class = dev->class;
>  	const struct device_type *type = dev->type;
>  
> +	device_remove_file(dev, &online_attr);
>  	device_remove_groups(dev, dev->groups);
>  
>  	if (type)
> @@ -1415,6 +1456,99 @@ EXPORT_SYMBOL_GPL(put_device);
>  EXPORT_SYMBOL_GPL(device_create_file);
>  EXPORT_SYMBOL_GPL(device_remove_file);
>  
> +static DEFINE_MUTEX(device_offline_lock);
> +
> +void lock_device_offline(void)
> +{
> +	mutex_lock(&device_offline_lock);
> +}
> +
> +void unlock_device_offline(void)
> +{
> +	mutex_unlock(&device_offline_lock);
> +}

Why have functions?  Why not just do the mutex_lock/unlock instead
everywhere?

> +static int device_check_offline(struct device *dev, void *not_used)
> +{
> +	int ret;
> +
> +	ret = device_for_each_child(dev, NULL, device_check_offline);
> +	if (ret)
> +		return ret;
> +
> +	return device_supports_offline(dev) && !dev->offline ? -EBUSY : 0;
> +}
> +
> +/**
> + * device_offline - Prepare the device for hot-removal.
> + * @dev: Device to be put offline.
> + *
> + * Execute the device bus type's .offline() callback, if present, to prepare
> + * the device for a subsequent hot-removal.  If that succeeds, the device must
> + * not be used until either it is removed or its bus type's .online() callback
> + * is executed.
> + *
> + * Call under device_offline_lock.
> + */
> +int device_offline(struct device *dev)
> +{
> +	int ret;
> +
> +	if (dev->offline_disabled)
> +		return -EPERM;
> +
> +	ret = device_for_each_child(dev, NULL, device_check_offline);
> +	if (ret)
> +		return ret;
> +
> +	device_lock(dev);
> +	if (device_supports_offline(dev)) {
> +		if (dev->offline) {
> +			ret = 1;
> +		} else {
> +			ret = dev->bus->offline(dev);
> +			if (!ret) {
> +				kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> +				dev->offline = true;
> +			}
> +		}
> +	}
> +	device_unlock(dev);
> +
> +	return ret;
> +}
> +
> +/**
> + * device_online - Put the device back online after successful device_offline().
> + * @dev: Device to be put back online.
> + *
> + * If device_offline() has been successfully executed for @dev, but the device
> + * has not been removed subsequently, execute its bus type's .online() callback
> + * to indicate that the device can be used again.
> + *
> + * Call under device_offline_lock.
> + */
> +int device_online(struct device *dev)
> +{
> +	int ret = 0;
> +
> +	device_lock(dev);
> +	if (device_supports_offline(dev)) {
> +		if (dev->offline) {
> +			ret = dev->bus->online(dev);
> +			if (!ret) {
> +				kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> +				dev->offline = false;
> +			}
> +		} else {
> +			ret = 1;
> +		}
> +	}
> +	device_unlock(dev);
> +
> +	return ret;
> +}

We don't grab the offline lock for when we go offline/online?  I like
the device_lock() call.  I don't understand what the offline locking is
supposed to be protecting as you don't use it here.  Will it make more
sense in the rest of the patches?

thanks,

greg k-h
