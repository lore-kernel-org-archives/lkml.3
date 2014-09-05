Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaIEWNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:13:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaIEWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:13:15 -0400
Date: Fri, 5 Sep 2014 15:13:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] device coredump: add new device coredump class
Message-ID: <20140905221314.GA1533@kroah.com>
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:50:54AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Many devices run firmware and/or complex hardware, and most of that
> can have bugs. When it misbehaves, however, it is often much harder
> to debug than software running on the host.
> 
> Introduce a "device coredump" mechanism to allow dumping internal
> device/firmware state through a generalized mechanism. As devices
> are different and information needed can vary accordingly, this
> doesn't prescribe a file format - it just provides mechanism to
> get data to be able to capture it in a generalized way (e.g. in
> distributions.)
> 
> Note that generalized capturing of such data may result in privacy
> issues, so users generally need to be involved. In order to allow
> certain users/system integrators/... to disable the feature at all,
> introduce a Kconfig option to override the drivers that would like
> to have the feature.
> 
> For now, this provides two ways of dumping data:
>  1) with a vmalloc'ed area, that is then given to the subsystem
>     and freed after retrieval or timeout
>  2) with a generalized reader/free function method
> 
> We could/should add more options, e.g. a list of pages, since the
> vmalloc area is very limited on some architectures.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  MAINTAINERS                 |   7 ++
>  drivers/base/Kconfig        |  21 ++++
>  drivers/base/Makefile       |   1 +
>  drivers/base/devcoredump.c  | 256 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/devcoredump.h |  35 ++++++
>  5 files changed, 320 insertions(+)
>  create mode 100644 drivers/base/devcoredump.c
>  create mode 100644 include/linux/devcoredump.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2f85f55c8fb8..8e31d053fb14 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2847,6 +2847,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>  S:	Maintained
>  F:	drivers/usb/dwc3/
>  
> +DEVICE COREDUMP (DEV_COREDUMP)
> +M:	Johannes Berg <johannes@sipsolutions.net>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	drivers/base/devcoredump.c
> +F:	include/linux/devcoredump.h
> +
>  DEVICE FREQUENCY (DEVFREQ)
>  M:	MyungJoo Ham <myungjoo.ham@samsung.com>
>  M:	Kyungmin Park <kyungmin.park@samsung.com>
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 4e7f0ff83ae7..134f763d90fd 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -165,6 +165,27 @@ config FW_LOADER_USER_HELPER_FALLBACK
>  
>  	  If you are unsure about this, say N here.
>  
> +config WANT_DEV_COREDUMP
> +	bool
> +	help
> +	  Drivers should "select" this option if they desire to use the
> +	  device coredump mechanism.
> +
> +config DISABLE_DEV_COREDUMP
> +	bool "Disable device coredump" if EXPERT
> +	help
> +	  Disable the device coredump mechanism despite drivers wanting to
> +	  use it; this allows for more sensitive systems or systems that
> +	  don't want to ever access the information to not have the code,
> +	  nor keep any data.
> +
> +	  If unsure, say N.
> +
> +config DEV_COREDUMP
> +	bool
> +	default y if WANT_DEV_COREDUMP
> +	depends on !DISABLE_DEV_COREDUMP
> +
>  config DEBUG_DRIVER
>  	bool "Driver Core verbose debug messages"
>  	depends on DEBUG_KERNEL
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 4aab26ec0292..6922cd6850a2 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
>  obj-$(CONFIG_REGMAP)	+= regmap/
>  obj-$(CONFIG_SOC_BUS) += soc.o
>  obj-$(CONFIG_PINCTRL) += pinctrl.o
> +obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
>  
>  ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
>  
> diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
> new file mode 100644
> index 000000000000..d6ecf13a5903
> --- /dev/null
> +++ b/drivers/base/devcoredump.c
> @@ -0,0 +1,256 @@
> +/*
> + * This file is provided under the GPLv2 license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * Copyright(c) 2014 Intel Mobile Communications GmbH
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * The full GNU General Public License is included in this distribution
> + * in the file called COPYING.
> + *
> + * Contact Information:
> + *  Intel Linux Wireless <ilw@linux.intel.com>
> + * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
> + */
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/devcoredump.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/fs.h>
> +#include <linux/workqueue.h>
> +
> +MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
> +MODULE_DESCRIPTION("Device Coredump support");
> +MODULE_LICENSE("GPL");

As you only allow Y or N as build options, it's not really a "module" :)

> +/* if data isn't read by userspace after 5 minutes then delete it */
> +#define DEVCD_TIMEOUT	(HZ * 60 * 5)
> +
> +struct devcd_entry {
> +	struct device devcd_dev;
> +	const void *data;
> +	size_t datalen;
> +	struct module *owner;
> +	ssize_t (*read)(char *buffer, loff_t offset, size_t count,
> +			const void *data, size_t datalen);
> +	void (*free)(const void *data);
> +	struct delayed_work del_wk;
> +	struct device *failing_dev;
> +};
> +
> +static struct devcd_entry *dev_to_devcd(struct device *dev)
> +{
> +	return container_of(dev, struct devcd_entry, devcd_dev);
> +}
> +
> +static void devcd_dev_release(struct device *dev)
> +{
> +	struct devcd_entry *devcd = dev_to_devcd(dev);
> +
> +	devcd->free(devcd->data);
> +	module_put(devcd->owner);
> +
> +	/*
> +	 * this seems racy, but I don't see a notifier or such on
> +	 * a struct device to know when it goes away?
> +	 */
> +	if (devcd->failing_dev->kobj.sd)
> +		sysfs_delete_link(&devcd->failing_dev->kobj, &dev->kobj,
> +				  "dev_coredump");

What is this link?  It should "just go away" if this:

> +	put_device(devcd->failing_dev);

was the last put_device() call on the failing_dev, right?  So you
shouldn't need to make this call to sysfs_delete_link().

> +	kfree(devcd);
> +}
> +
> +static void devcd_del(struct work_struct *wk)
> +{
> +	struct devcd_entry *devcd;
> +
> +	devcd = container_of(wk, struct devcd_entry, del_wk.work);
> +
> +	device_del(&devcd->devcd_dev);
> +	put_device(&devcd->devcd_dev);
> +}
> +
> +static ssize_t devcd_data_read(struct file *filp, struct kobject *kobj,
> +			       struct bin_attribute *bin_attr,
> +			       char *buffer, loff_t offset, size_t count)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct devcd_entry *devcd = dev_to_devcd(dev);
> +
> +	return devcd->read(buffer, offset, count, devcd->data, devcd->datalen);
> +}
> +
> +static ssize_t devcd_data_write(struct file *filp, struct kobject *kobj,
> +				struct bin_attribute *bin_attr,
> +				char *buffer, loff_t offset, size_t count)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct devcd_entry *devcd = dev_to_devcd(dev);
> +
> +	mod_delayed_work(system_wq, &devcd->del_wk, 0);
> +
> +	return count;
> +}
> +
> +static struct bin_attribute devcd_attr_data = {
> +	.attr = { .name = "data", .mode = S_IRUSR | S_IWUSR, },
> +	.size = 0,
> +	.read = devcd_data_read,
> +	.write = devcd_data_write,
> +};
> +
> +static struct bin_attribute *devcd_dev_bin_attrs[] = {
> +	&devcd_attr_data, NULL,
> +};
> +
> +static const struct attribute_group devcd_dev_group = {
> +	.bin_attrs = devcd_dev_bin_attrs,
> +};
> +
> +static const struct attribute_group *devcd_dev_groups[] = {
> +	&devcd_dev_group, NULL,
> +};
> +
> +static struct class devcd_class = {
> +	.name		= "devcoredump",
> +	.owner		= THIS_MODULE,
> +	.dev_release	= devcd_dev_release,
> +	.dev_groups	= devcd_dev_groups,
> +};
> +
> +static ssize_t devcd_readv(char *buffer, loff_t offset, size_t count,
> +			   const void *data, size_t datalen)
> +{
> +	if (offset > datalen)
> +		return -EINVAL;
> +
> +	if (offset + count > datalen)
> +		count = datalen - offset;
> +
> +	if (count)
> +		memcpy(buffer, ((u8 *)data) + offset, count);
> +
> +	return count;
> +}
> +
> +/**
> + * dev_coredumpv - create firmware coredump with vmalloc data
> + * @dev: the struct device for the crashed device
> + * @data: vmalloc data containing the firmware coredump
> + * @datalen: length of the data
> + * @gfp: allocation flags
> + */
> +void dev_coredumpv(struct device *dev, const void *data, size_t datalen,
> +		   gfp_t gfp)
> +{
> +	dev_coredumpm(dev, NULL, data, datalen, gfp, devcd_readv, vfree);
> +}
> +EXPORT_SYMBOL(dev_coredumpv);

driver core exports are all EXPORT_SYMBOL_GPL() please.

> +static int devcd_match_failing(struct device *dev, const void *failing)
> +{
> +	struct devcd_entry *devcd = dev_to_devcd(dev);
> +
> +	return devcd->failing_dev == failing;
> +}
> +
> +/**
> + * dev_coredumpm - create firmware coredump with read/free methods
> + * @dev: the struct device for the crashed device
> + * @data: data cookie for the @read/@free functions
> + * @datalen: length of the data
> + * @gfp: allocation flags
> + * @read: function to read from the given buffer
> + * @free: function to free the given buffer
> + */

You forgot @owner in this list.

> +void dev_coredumpm(struct device *dev, struct module *owner,
> +		   const void *data, size_t datalen, gfp_t gfp,
> +		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
> +				   const void *data, size_t datalen),
> +		   void (*free)(const void *data))
> +{
> +	static atomic_t devcd_count = ATOMIC_INIT(0);
> +	struct devcd_entry *devcd;
> +	struct device *existing;
> +
> +	existing = class_find_device(&devcd_class, NULL, dev,
> +				     devcd_match_failing);
> +	if (existing) {
> +		put_device(existing);
> +		return;
> +	}

I thought multiple dumps per "device" would throw away the older ones?
It's fine if you don't, but you might want to document this behavior in
the kerneldoc for the function.

Other than those very minor things, looks good to me, want to resend it
cleaned up and without the "RFC" in the Subject?

thanks,

greg k-h
