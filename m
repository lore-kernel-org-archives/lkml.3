Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbaGXP7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:59:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaGXP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:59:38 -0400
Date: Thu, 24 Jul 2014 08:59:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk
Subject: Re: [PATCH 1/1] Managed Devices devres_debugfs file system
Message-ID: <20140724155912.GA14956@kroah.com>
References: <1406215081-15113-1-git-send-email-rob.jones@codethink.co.uk>
 <1406215081-15113-2-git-send-email-rob.jones@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406215081-15113-2-git-send-email-rob.jones@codethink.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:18:01PM +0100, Rob Jones wrote:
> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> Suggested-by: Ben Dooks <ben.dooks@codethink.co.uk>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
>  Documentation/driver-model/devres-debugfs.txt |  140 +++++++++
>  drivers/base/Kconfig                          |   18 ++
>  drivers/base/devres.c                         |  387 +++++++++++++++++++++++++
>  3 files changed, 545 insertions(+)
>  create mode 100644 Documentation/driver-model/devres-debugfs.txt
> 
> diff --git a/Documentation/driver-model/devres-debugfs.txt b/Documentation/driver-model/devres-debugfs.txt
> new file mode 100644
> index 0000000..7004ebd
> --- /dev/null
> +++ b/Documentation/driver-model/devres-debugfs.txt
> @@ -0,0 +1,140 @@
> +
> +Introduction
> +============
> +
> +This document describes a file system that can be enabled to assist
> +with the debugging of devices that use managed reources
> +
> +Outline of Operation
> +====================
> +
> +Setting the flag DEVRES_DEBUGFS (depends on DEBUG_DEVRES) enables a
> +debug facility for device managed resources. This takes the form of
> +a directory in the debugfs file system which is a pseudo file system
> +(typically mounted at /sys/kernel/debug) similar in concept to sysfs
> +but with no restrictions on the format of the data read from a file.
> +
> +The directory (devres/) is created the first time a managed resource
> +is allocated for any device.
> +
> +The first time a managed resource is allocated for a device, a file
> +with the same name as the device is created in devres/.
> +
> +The file is read only and can be read by normal userspace utilities
> +(such as cat).
> +
> +The data returned is in ASCII text format and has one header line for
> +the device followed by one line per allocated resource.
> +
> +It is possible to seek to a given line within the file: position 0
> +(zero) goes directly to the device line, position 1 goes to the first
> +resource line and so on. Attempting to seek to a line that does not
> +exist returns EOF.
> +
> +If opened and read sequentially, a file will initially give Line 0 (see
> +below) and then each subsequent read will give a Resource Line until
> +EOF. Note that the data may change on the fly (see Notes below).
> +
> +Data Format
> +===========
> +
> +Device Line (Line 0)
> +--------------------
> +
> +dev: <address> <name>
> +
> +There is a single space between each field.
> +
> +dev: = literal text identifying this as a device line.
> +
> +<address> = the address in kernel memory of the device data structure.
> +The layout of "struct device" can be found in include/linux/device.h.
> +This value is displayed in hexadecimal format using the "%p" format
> +specifier and thus will vary in length depending on the word size of
> +the kernel, e.g. 8 characters for a 32 bit kernel.
> +
> +<name> = the name of the device. This should be the same as the file
> +name, it is included to facilitate identification when multiple
> +devices are being listed. The length of this field can vary.
> +
> +Resource Line (Line 1 et seq.)
> +------------------------------
> +
> +res: <address> <length> <data> <name>
> +
> +There is a single space between each field.
> +
> +res: = literal text identifying this as a resource line.
> +
> +<address> = the address in kernel memory of the resource data. The
> +structure pointed to can vary depending on the type of resource.
> +This field is encoded in hexadecimal format using the "%p" format
> +specifier and thus will vary in length depending on the word size of
> +the kernel, e.g. 8 characters for a 32 bit kernel.
> +
> +<length> = the length of the resource data. This field is encoded
> +in decimal format, right justified, space filled and is always 9
> +characters long.
> +
> +<data> = a hexadecimal display of the first 16 (or <length> if less)
> +bytes of data starting for location <address>. If <length> is less
> +than 16, this field is padded with spaces on the right to the full
> +32 characters.
> +
> +<name> = a string indentifying the resource type. This is often a
> +string containing the name of the function to be used to free the
> +resource. Typical examples are "devm_kzalloc_release" which identifies
> +a memory resource and "devm_gpio_release" which identifies a gpio
> +resource. The length of this field can vary.
> +
> +Notes
> +=====
> +
> +1. Once created, a file persists until the device is removed even
> +   if all allocated resources are freed. This means that the existence
> +   of the file is confirmation that at least one resource has been
> +   allocated at some point, even if the device now has none allocated.
> +
> +2. Opening a file and holding it open will prevent the freeing up of
> +   of the device - the final removal is held off until the file is
> +   closed. Managed resources can still be freed if, say, a driver is
> +   removed.
> +
> +3. Resources can, in principle, be allocated and freed on the fly so
> +   it should not be assumed in general that seeking to a particular
> +   resource line will always return the same resource. However, that is
> +   a function of the device driver concerned and it may be a valid
> +   assumption for some drivers, e.g. one that only allocates resources
> +   during its .probe function.
> +
> +4. The device's list of resources is traversed from its base to the
> +   requested item each time the file is read. During this scan resources
> +   are spinlocked, which may have implications if resources can be
> +   allocated during time critical code at the same time as a read is
> +   taking place.
> +
> +5. A copy is taken of (up to) 16 bytes of resource data while the
> +   spinlock (see note 4, above) is still in place and so can be relied
> +   upon as an accurate snapshot at the time of the read but it must be
> +   remembered that resources may change dynamically (see note 3, above)
> +   so the memory may have changed subsequently.
> +
> +Sample Output
> +=============
> +
> +root@arm:~# cat /sys/kernel/debug/devres/mmc0
> +dev: ed980008 mmc0
> +res: ed95a618        50 000000004884e8800001000039a695ed devm_kzalloc_release
> +res: ed95cc58         4 02000000                         devm_gpio_release
> +res: ed95cc98         8 a2000000000098ed                 devm_irq_release
> +root@arm:~#
> +
> +This shows three managed resources allocated to device "mmc0".
> +
> +1. A block of memory 50 bytes long (the first 16 byte are displayed).
> +2. A GPIO.
> +3. An IRQ.
> +
> +If 16 bytes of data is insufficient, you can try using other debugging
> +tools to examine the data.

Why did you pick 16 bytes?  What can I do with that information?


> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 8fa8dea..6a2f125 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -177,6 +177,24 @@ config DEBUG_DEVRES
>  
>  	  If you are unsure about this, Say N here.
>  
> +config DEVRES_DEBUGFS
> +	bool "Managed device resources debugfs file system"
> +	depends on DEBUG_DEVRES
> +	help
> +	  This option enables a debugfs file system related to Managed
> +	  Resources. When a device allocates a managed resource, with
> +	  this option enabled, a read-only file with the same name as
> +	  the device is created in the file system. Reading this file
> +	  provides some basic debug information about the managed
> +	  resources allocated to the device.
> +
> +	  The overhead caused by enabling this option is quite small.
> +	  Specifically, a small memory overhead for each device and a
> +	  small time overhead at each resource allocation and
> +	  de-allocation.
> +
> +	  If you are unsure about this, Say N here.
> +
>  config SYS_HYPERVISOR
>  	bool
>  	default n
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index 5c88a27..41b6465 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -7,9 +7,13 @@
>   * This file is released under the GPLv2.
>   */
>  
> +#include <linux/debugfs.h>
>  #include <linux/device.h>
>  #include <linux/module.h>
> +#include <linux/seq_file.h>
>  #include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/uaccess.h>

why not just make this a separate file, that would remove the #ifdef
from this file, right?


> +/**
> + * devres_dbgfs_seq_show - seq file output routine for a devres debugfs file
> + * @s: pointer to seq file structure
> + * @v: pointer to private data set up by devres_dbgfs_seq_next().
> + *
> + * Static debug function called when the user reads from a device managed
> + * resources debugfs file. It outputs to the user buffer using seq_file
> + * function seq_printf();
> + *
> + * This function locks devres_lock in the device structure.
> + */
> +static int devres_dbgfs_seq_show(struct seq_file *s, void *v)
> +{
> +	struct devres_dbgfs_private *priv = v;
> +	struct device *dev = priv->dev;
> +	int size, i, pos = priv->pos;
> +	struct devres *dr;
> +	struct list_head *head;
> +	struct list_head *item;
> +	unsigned long flags;
> +	char data[16];
> +	char *dataptr;
> +
> +	if (pos == 0) {
> +		seq_printf(s, "dev: %p %s\n", dev, dev_name(dev));

%pK please for all kernel pointers.



> +/**
> + * devres_dbgfs_create_file - create debugfs file for a device
> + * @dev: device
> + *
> + * Static debug function that will automatically create a debugfs file
> + * with the same name as the supplied device IFF the said file has not
> + * already been created.
> + *
> + * This function locks devres_dbgfs_lock.
> + */
> +static void devres_dbgfs_create_file(struct device *dev)
> +{
> +	struct dentry *debugfsfile = NULL;
> +	struct devres_dbgfs_link *link;
> +	struct dentry *debugfsdir;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&devres_dbgfs_lock, flags);
> +
> +	link = devres_dbgfs_find_filelink(dev);
> +	if (link)
> +		goto out_unlock;
> +
> +	debugfsdir = devres_dbgfs_get_dir();
> +	if (debugfsdir)
> +		/* Create file, n.b. dev goes into inode->i_private */
> +		debugfsfile = debugfs_create_file(dev_name(dev), 0444,
> +						  debugfsdir, dev,
> +						  &devres_dbgfs_seq_fops);

I worry about this, as there is no reason that devices have to have
"unique" names in the system.  Odds are, there's lots of conflicts,
which is why sysfs is a tree, not a flat heirachy.


> +	if (!debugfsfile)
> +		goto out_unlock;

If debugfs is not enabled, this will not trigger, are you sure you want
that?


> +
> +	/* Success: now create filelink entry in linked list */
> +	link = kmalloc(sizeof(*link), GFP_KERNEL);
> +	if (!link) {
> +		debugfs_remove(debugfsfile);
> +		goto out_unlock;
> +	}
> +
> +	INIT_LIST_HEAD(&link->list);
> +	link->dev = dev;
> +	link->dp = debugfsfile;
> +	if (devres_dbgfs_lastused)
> +		list_add(&link->list, &devres_dbgfs_lastused->list);
> +	devres_dbgfs_lastused = link;
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&devres_dbgfs_lock, flags);
> +}
> +#endif /* CONFIG_DEVRES_DEBUGFS */
> +
>  /*
>   * Release functions for devres group.  These callbacks are used only
>   * for identification.
> @@ -220,6 +601,9 @@ void devres_add(struct device *dev, void *res)
>  	spin_lock_irqsave(&dev->devres_lock, flags);
>  	add_dr(dev, &dr->node);
>  	spin_unlock_irqrestore(&dev->devres_lock, flags);
> +#ifdef CONFIG_DEVRES_DEBUGFS
> +	devres_dbgfs_create_file(dev);
> +#endif /* CONFIG_DEVRES_DEBUGFS */

ifdefs like this are strongly discouraged.

Overall, I'm curious as to what this code is good for?  What use cases
will benifit for seeing all of this information?  Why would a developer
ever care about all of the resources that a specific device has created,
what could I do with that information?

It seems "neat", but not something I would ever actually care about, as
there's nothing to do with that info.  A device will never allocate
something it doesn't actually need, right?

thanks,

greg k-h
