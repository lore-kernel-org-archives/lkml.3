Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351Ab3D3Lvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:51:44 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50658 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848Ab3D3Lvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:51:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH 1/3 RFC] Driver core: Add offline/online device operations
Date: Tue, 30 Apr 2013 13:59:55 +0200
Message-ID: <5539501.dHzXXAKYJ9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130429231019.GB1333@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <1989524.p5J87p9Tnl@vostro.rjw.lan> <20130429231019.GB1333@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 29, 2013 04:10:19 PM Greg Kroah-Hartman wrote:
> On Mon, Apr 29, 2013 at 02:26:56PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > In some cases, graceful hot-removal of devices is not possible,
> > although in principle the devices in question support hotplug.
> > For example, that may happen for the last CPU in the system or
> > for memory modules holding kernel memory.
> > 
> > In those cases it is nice to be able to check if the given device
> > can be safely hot-removed before triggering a removal procedure
> > that cannot be aborted or reversed.  Unfortunately, however, the
> > kernel currently doesn't provide any support for that.
> > 
> > To address that deficiency, introduce support for offline and
> > online operations that can be performed on devices, respectively,
> > before a hot-removal and in case when it is necessary (or convenient)
> > to put a device back online after a successful offline (that has not
> > been followed by removal).  The idea is that the offline will fail
> > whenever the given device cannot be gracefully removed from the
> > system and it will not be allowed to use the device after a
> > successful offline (until a subsequent online) in analogy with the
> > existing CPU offline/online mechanism.
> > 
> > For now, the offline and online operations are introduced at the
> > bus type level, as that should be sufficient for the most urgent use
> > cases (CPUs and memory modules).  In the future, however, the
> > approach may be extended to cover some more complicated device
> > offline/online scenarios involving device drivers etc.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  Documentation/ABI/testing/sysfs-devices-online |   19 +++
> >  drivers/base/core.c                            |  134 +++++++++++++++++++++++++
> >  include/linux/device.h                         |   21 +++
> >  3 files changed, 174 insertions(+)
> > 
> > Index: linux-pm/include/linux/device.h
> > ===================================================================
> > --- linux-pm.orig/include/linux/device.h
> > +++ linux-pm/include/linux/device.h
> > @@ -70,6 +70,10 @@ extern void bus_remove_file(struct bus_t
> >   *		the specific driver's probe to initial the matched device.
> >   * @remove:	Called when a device removed from this bus.
> >   * @shutdown:	Called at shut-down time to quiesce the device.
> > + *
> > + * @online:	Called to put the device back online (after offlining it).
> > + * @offline:	Called to put the device offline for hot-removal. May fail.
> > + *
> >   * @suspend:	Called when a device on this bus wants to go to sleep mode.
> >   * @resume:	Called to bring a device on this bus out of sleep mode.
> >   * @pm:		Power management operations of this bus, callback the specific
> > @@ -103,6 +107,9 @@ struct bus_type {
> >  	int (*remove)(struct device *dev);
> >  	void (*shutdown)(struct device *dev);
> >  
> > +	int (*online)(struct device *dev);
> > +	int (*offline)(struct device *dev);
> > +
> >  	int (*suspend)(struct device *dev, pm_message_t state);
> >  	int (*resume)(struct device *dev);
> >  
> > @@ -646,6 +653,8 @@ struct acpi_dev_node {
> >   * @release:	Callback to free the device after all references have
> >   * 		gone away. This should be set by the allocator of the
> >   * 		device (i.e. the bus driver that discovered the device).
> > + * @offline_disabled: If set, the device is permanently online.
> > + * @offline:	Set after successful invocation of bus type's .offline().
> >   *
> >   * At the lowest level, every device in a Linux system is represented by an
> >   * instance of struct device. The device structure contains the information
> > @@ -718,6 +727,9 @@ struct device {
> >  
> >  	void	(*release)(struct device *dev);
> >  	struct iommu_group	*iommu_group;
> > +
> > +	bool			offline_disabled:1;
> > +	bool			offline:1;
> >  };
> >  
> >  static inline struct device *kobj_to_dev(struct kobject *kobj)
> > @@ -853,6 +865,15 @@ extern const char *device_get_devnode(st
> >  extern void *dev_get_drvdata(const struct device *dev);
> >  extern int dev_set_drvdata(struct device *dev, void *data);
> >  
> > +static inline bool device_supports_offline(struct device *dev)
> > +{
> > +	return dev->bus && dev->bus->offline && dev->bus->online;
> 
> Wouldn't it be easier for us to also check offline_disabled here as
> well?  That would save the extra check when we go to create the sysfs
> file.

Yes, it would, but I want device_offline() to return an error in case
when offline_disabled is set while the above returns 'true'.  If that check
were folded into device_supports_offline(), device_offline() would return 0
in that case.

> > +}
> > +
> > +extern void lock_device_offline(void);
> > +extern void unlock_device_offline(void);
> > +extern int device_offline(struct device *dev);
> > +extern int device_online(struct device *dev);
> >  /*
> >   * Root device objects for grouping under /sys/devices
> >   */
> > Index: linux-pm/drivers/base/core.c
> > ===================================================================
> > --- linux-pm.orig/drivers/base/core.c
> > +++ linux-pm/drivers/base/core.c
> > @@ -397,6 +397,40 @@ static ssize_t store_uevent(struct devic
> >  static struct device_attribute uevent_attr =
> >  	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
> >  
> > +static ssize_t show_online(struct device *dev, struct device_attribute *attr,
> > +			   char *buf)
> > +{
> > +	bool ret;
> > +
> > +	lock_device_offline();
> > +	ret = !dev->offline;
> > +	unlock_device_offline();
> > +	return sprintf(buf, "%u\n", ret);
> > +}
> > +
> > +static ssize_t store_online(struct device *dev, struct device_attribute *attr,
> > +			    const char *buf, size_t count)
> > +{
> > +	int ret;
> > +
> > +	lock_device_offline();
> > +	switch (buf[0]) {
> > +	case '0':
> > +		ret = device_offline(dev);
> > +		break;
> > +	case '1':
> > +		ret = device_online(dev);
> > +		break;
> 
> Should we also accept 'y', 'Y', 'n', and 'N', like most boolean sysfs
> files do?  I think we even have a kernel helper function for it
> somewhere...

Yes, we do, but it doesn't accept '0' as false. :-)

Well, I suppose I can modify that function and use it here.  What do you think?

> > +	default:
> > +		ret = -EINVAL;
> > +	}
> > +	unlock_device_offline();
> > +	return ret < 0 ? ret : count;
> > +}
> > +
> > +static struct device_attribute online_attr =
> > +	__ATTR(online, S_IRUGO | S_IWUSR, show_online, store_online);
> > +
> >  static int device_add_attributes(struct device *dev,
> >  				 struct device_attribute *attrs)
> >  {
> > @@ -510,6 +544,12 @@ static int device_add_attrs(struct devic
> >  	if (error)
> >  		goto err_remove_type_groups;
> >  
> > +	if (device_supports_offline(dev) && !dev->offline_disabled) {
> > +		error = device_create_file(dev, &online_attr);
> > +		if (error)
> > +			goto err_remove_type_groups;
> > +	}
> > +
> >  	return 0;
> >  
> >   err_remove_type_groups:
> > @@ -530,6 +570,7 @@ static void device_remove_attrs(struct d
> >  	struct class *class = dev->class;
> >  	const struct device_type *type = dev->type;
> >  
> > +	device_remove_file(dev, &online_attr);
> >  	device_remove_groups(dev, dev->groups);
> >  
> >  	if (type)
> > @@ -1415,6 +1456,99 @@ EXPORT_SYMBOL_GPL(put_device);
> >  EXPORT_SYMBOL_GPL(device_create_file);
> >  EXPORT_SYMBOL_GPL(device_remove_file);
> >  
> > +static DEFINE_MUTEX(device_offline_lock);
> > +
> > +void lock_device_offline(void)
> > +{
> > +	mutex_lock(&device_offline_lock);
> > +}
> > +
> > +void unlock_device_offline(void)
> > +{
> > +	mutex_unlock(&device_offline_lock);
> > +}
> 
> Why have functions?  Why not just do the mutex_lock/unlock instead
> everywhere?

Ah, that's something I forgot to write about in the changelog.

Patch [3/3] depends on that, because it has to take device_offline_lock around
a larger piece of code.  Specifically, it needs to put acpi_bus_trim() under
that lock too to avoid situations in which a previously offlined device would
be onlined from user space right before (or worse yet during) acpi_bus_trim()
(which would then remove it without offlining).

It is not necessary in [1/3], so I can move it to [3/3] if that's better.

> > +static int device_check_offline(struct device *dev, void *not_used)
> > +{
> > +	int ret;
> > +
> > +	ret = device_for_each_child(dev, NULL, device_check_offline);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return device_supports_offline(dev) && !dev->offline ? -EBUSY : 0;
> > +}
> > +
> > +/**
> > + * device_offline - Prepare the device for hot-removal.
> > + * @dev: Device to be put offline.
> > + *
> > + * Execute the device bus type's .offline() callback, if present, to prepare
> > + * the device for a subsequent hot-removal.  If that succeeds, the device must
> > + * not be used until either it is removed or its bus type's .online() callback
> > + * is executed.
> > + *
> > + * Call under device_offline_lock.
> > + */
> > +int device_offline(struct device *dev)
> > +{
> > +	int ret;
> > +
> > +	if (dev->offline_disabled)
> > +		return -EPERM;
> > +
> > +	ret = device_for_each_child(dev, NULL, device_check_offline);
> > +	if (ret)
> > +		return ret;
> > +
> > +	device_lock(dev);
> > +	if (device_supports_offline(dev)) {
> > +		if (dev->offline) {
> > +			ret = 1;
> > +		} else {
> > +			ret = dev->bus->offline(dev);
> > +			if (!ret) {
> > +				kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> > +				dev->offline = true;
> > +			}
> > +		}
> > +	}
> > +	device_unlock(dev);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * device_online - Put the device back online after successful device_offline().
> > + * @dev: Device to be put back online.
> > + *
> > + * If device_offline() has been successfully executed for @dev, but the device
> > + * has not been removed subsequently, execute its bus type's .online() callback
> > + * to indicate that the device can be used again.
> > + *
> > + * Call under device_offline_lock.
> > + */
> > +int device_online(struct device *dev)
> > +{
> > +	int ret = 0;
> > +
> > +	device_lock(dev);
> > +	if (device_supports_offline(dev)) {
> > +		if (dev->offline) {
> > +			ret = dev->bus->online(dev);
> > +			if (!ret) {
> > +				kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> > +				dev->offline = false;
> > +			}
> > +		} else {
> > +			ret = 1;
> > +		}
> > +	}
> > +	device_unlock(dev);
> > +
> > +	return ret;
> > +}
> 
> We don't grab the offline lock for when we go offline/online?  I like
> the device_lock() call.  I don't understand what the offline locking is
> supposed to be protecting as you don't use it here.  Will it make more
> sense in the rest of the patches?

Yes, like I said above, it's only needed by patch [3/3], so I can move it
there.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
