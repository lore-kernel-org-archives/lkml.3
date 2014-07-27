Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaG0DcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 23:32:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaG0DcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 23:32:21 -0400
Date: Sat, 26 Jul 2014 20:31:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk
Subject: Re: [PATCH 1/1] Managed Devices devres_debugfs file system
Message-ID: <20140727033155.GA3760@kroah.com>
References: <1406215081-15113-1-git-send-email-rob.jones@codethink.co.uk>
 <1406215081-15113-2-git-send-email-rob.jones@codethink.co.uk>
 <20140724155912.GA14956@kroah.com>
 <53D23B68.8080401@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D23B68.8080401@codethink.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 12:11:36PM +0100, Rob Jones wrote:
> 
> 
> On 24/07/14 16:59, Greg KH wrote:
> >On Thu, Jul 24, 2014 at 04:18:01PM +0100, Rob Jones wrote:
> >>Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> >>Suggested-by: Ben Dooks <ben.dooks@codethink.co.uk>
> >>Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> >>---
> >>  Documentation/driver-model/devres-debugfs.txt |  140 +++++++++
> >>  drivers/base/Kconfig                          |   18 ++
> >>  drivers/base/devres.c                         |  387 +++++++++++++++++++++++++
> >>  3 files changed, 545 insertions(+)
> >>  create mode 100644 Documentation/driver-model/devres-debugfs.txt
> >>
> >>diff --git a/Documentation/driver-model/devres-debugfs.txt b/Documentation/driver-model/devres-debugfs.txt
> >>new file mode 100644
> >>index 0000000..7004ebd
> >>--- /dev/null
> >>+++ b/Documentation/driver-model/devres-debugfs.txt
> >>@@ -0,0 +1,140 @@
> >>+
> >>+Introduction
> >>+============
> >>+
> >>+This document describes a file system that can be enabled to assist
> >>+with the debugging of devices that use managed reources
> >>+
> >>+Outline of Operation
> >>+====================
> >>+
> >>+Setting the flag DEVRES_DEBUGFS (depends on DEBUG_DEVRES) enables a
> >>+debug facility for device managed resources. This takes the form of
> >>+a directory in the debugfs file system which is a pseudo file system
> >>+(typically mounted at /sys/kernel/debug) similar in concept to sysfs
> >>+but with no restrictions on the format of the data read from a file.
> >>+
> >>+The directory (devres/) is created the first time a managed resource
> >>+is allocated for any device.
> >>+
> >>+The first time a managed resource is allocated for a device, a file
> >>+with the same name as the device is created in devres/.
> >>+
> >>+The file is read only and can be read by normal userspace utilities
> >>+(such as cat).
> >>+
> >>+The data returned is in ASCII text format and has one header line for
> >>+the device followed by one line per allocated resource.
> >>+
> >>+It is possible to seek to a given line within the file: position 0
> >>+(zero) goes directly to the device line, position 1 goes to the first
> >>+resource line and so on. Attempting to seek to a line that does not
> >>+exist returns EOF.
> >>+
> >>+If opened and read sequentially, a file will initially give Line 0 (see
> >>+below) and then each subsequent read will give a Resource Line until
> >>+EOF. Note that the data may change on the fly (see Notes below).
> >>+
> >>+Data Format
> >>+===========
> >>+
> >>+Device Line (Line 0)
> >>+--------------------
> >>+
> >>+dev: <address> <name>
> >>+
> >>+There is a single space between each field.
> >>+
> >>+dev: = literal text identifying this as a device line.
> >>+
> >>+<address> = the address in kernel memory of the device data structure.
> >>+The layout of "struct device" can be found in include/linux/device.h.
> >>+This value is displayed in hexadecimal format using the "%p" format
> >>+specifier and thus will vary in length depending on the word size of
> >>+the kernel, e.g. 8 characters for a 32 bit kernel.
> >>+
> >>+<name> = the name of the device. This should be the same as the file
> >>+name, it is included to facilitate identification when multiple
> >>+devices are being listed. The length of this field can vary.
> >>+
> >>+Resource Line (Line 1 et seq.)
> >>+------------------------------
> >>+
> >>+res: <address> <length> <data> <name>
> >>+
> >>+There is a single space between each field.
> >>+
> >>+res: = literal text identifying this as a resource line.
> >>+
> >>+<address> = the address in kernel memory of the resource data. The
> >>+structure pointed to can vary depending on the type of resource.
> >>+This field is encoded in hexadecimal format using the "%p" format
> >>+specifier and thus will vary in length depending on the word size of
> >>+the kernel, e.g. 8 characters for a 32 bit kernel.
> >>+
> >>+<length> = the length of the resource data. This field is encoded
> >>+in decimal format, right justified, space filled and is always 9
> >>+characters long.
> >>+
> >>+<data> = a hexadecimal display of the first 16 (or <length> if less)
> >>+bytes of data starting for location <address>. If <length> is less
> >>+than 16, this field is padded with spaces on the right to the full
> >>+32 characters.
> >>+
> >>+<name> = a string indentifying the resource type. This is often a
> >>+string containing the name of the function to be used to free the
> >>+resource. Typical examples are "devm_kzalloc_release" which identifies
> >>+a memory resource and "devm_gpio_release" which identifies a gpio
> >>+resource. The length of this field can vary.
> >>+
> >>+Notes
> >>+=====
> >>+
> >>+1. Once created, a file persists until the device is removed even
> >>+   if all allocated resources are freed. This means that the existence
> >>+   of the file is confirmation that at least one resource has been
> >>+   allocated at some point, even if the device now has none allocated.
> >>+
> >>+2. Opening a file and holding it open will prevent the freeing up of
> >>+   of the device - the final removal is held off until the file is
> >>+   closed. Managed resources can still be freed if, say, a driver is
> >>+   removed.
> >>+
> >>+3. Resources can, in principle, be allocated and freed on the fly so
> >>+   it should not be assumed in general that seeking to a particular
> >>+   resource line will always return the same resource. However, that is
> >>+   a function of the device driver concerned and it may be a valid
> >>+   assumption for some drivers, e.g. one that only allocates resources
> >>+   during its .probe function.
> >>+
> >>+4. The device's list of resources is traversed from its base to the
> >>+   requested item each time the file is read. During this scan resources
> >>+   are spinlocked, which may have implications if resources can be
> >>+   allocated during time critical code at the same time as a read is
> >>+   taking place.
> >>+
> >>+5. A copy is taken of (up to) 16 bytes of resource data while the
> >>+   spinlock (see note 4, above) is still in place and so can be relied
> >>+   upon as an accurate snapshot at the time of the read but it must be
> >>+   remembered that resources may change dynamically (see note 3, above)
> >>+   so the memory may have changed subsequently.
> >>+
> >>+Sample Output
> >>+=============
> >>+
> >>+root@arm:~# cat /sys/kernel/debug/devres/mmc0
> >>+dev: ed980008 mmc0
> >>+res: ed95a618        50 000000004884e8800001000039a695ed devm_kzalloc_release
> >>+res: ed95cc58         4 02000000                         devm_gpio_release
> >>+res: ed95cc98         8 a2000000000098ed                 devm_irq_release
> >>+root@arm:~#
> >>+
> >>+This shows three managed resources allocated to device "mmc0".
> >>+
> >>+1. A block of memory 50 bytes long (the first 16 byte are displayed).
> >>+2. A GPIO.
> >>+3. An IRQ.
> >>+
> >>+If 16 bytes of data is insufficient, you can try using other debugging
> >>+tools to examine the data.
> >
> >Why did you pick 16 bytes?  What can I do with that information?
> 
> I chose 16 bytes simply because that occupies 32 columns and usually
> fits on a single line with the rest of the information output.
> 
> For some resources, such as GPIOs and IRQs, it can be enough to give
> you useful information without risking dumping shedloads of data.

If you know the binary format here, right?

> For example, a quick look into kernel/irq/devres.c tells me that the
> third resource for mmc0, in the example above, is IRQ 0xa2.

/proc/interrupts ?

> I'm sure I don't need to explain that, when you are debugging, being
> able to rapidly answer questions such as "Am I getting the right IRQ?"

Again, we have a proc file for that :)

> or "How much memory have I allocated?" can save a lot of time.

I've _never_ needed to know that, and I've written a few drivers...

> For known structures it could be expanded to decode the structure.

Then you are embedding a debugger into the kernel :)

> >>diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> >>index 8fa8dea..6a2f125 100644
> >>--- a/drivers/base/Kconfig
> >>+++ b/drivers/base/Kconfig
> >>@@ -177,6 +177,24 @@ config DEBUG_DEVRES
> >>
> >>  	  If you are unsure about this, Say N here.
> >>
> >>+config DEVRES_DEBUGFS
> >>+	bool "Managed device resources debugfs file system"
> >>+	depends on DEBUG_DEVRES
> >>+	help
> >>+	  This option enables a debugfs file system related to Managed
> >>+	  Resources. When a device allocates a managed resource, with
> >>+	  this option enabled, a read-only file with the same name as
> >>+	  the device is created in the file system. Reading this file
> >>+	  provides some basic debug information about the managed
> >>+	  resources allocated to the device.
> >>+
> >>+	  The overhead caused by enabling this option is quite small.
> >>+	  Specifically, a small memory overhead for each device and a
> >>+	  small time overhead at each resource allocation and
> >>+	  de-allocation.
> >>+
> >>+	  If you are unsure about this, Say N here.
> >>+
> >>  config SYS_HYPERVISOR
> >>  	bool
> >>  	default n
> >>diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> >>index 5c88a27..41b6465 100644
> >>--- a/drivers/base/devres.c
> >>+++ b/drivers/base/devres.c
> >>@@ -7,9 +7,13 @@
> >>   * This file is released under the GPLv2.
> >>   */
> >>
> >>+#include <linux/debugfs.h>
> >>  #include <linux/device.h>
> >>  #include <linux/module.h>
> >>+#include <linux/seq_file.h>
> >>  #include <linux/slab.h>
> >>+#include <linux/spinlock.h>
> >>+#include <linux/uaccess.h>
> >
> >why not just make this a separate file, that would remove the #ifdef
> >from this file, right?
> 
> Do you mean create a new module? Or as a file to be included?

A separate file.

> I preferred to keep this patch entirely within devres.c, as it feels
> less intrusive that way.

Really?

> If it's in the way, It could as easily go at the end of the file, then
> it would only need a function prototype at the top of the file but it
> could easily be put in another file, the only externals needed would be
> devres_debugfs_create_file() and devres_remove_debugfs_file().

Why not try it as a separate file.

> >>+	if (debugfsdir)
> >>+		/* Create file, n.b. dev goes into inode->i_private */
> >>+		debugfsfile = debugfs_create_file(dev_name(dev), 0444,
> >>+						  debugfsdir, dev,
> >>+						  &devres_dbgfs_seq_fops);
> >
> >I worry about this, as there is no reason that devices have to have
> >"unique" names in the system.  Odds are, there's lots of conflicts,
> >which is why sysfs is a tree, not a flat heirachy.
> 
> I don't know for sure about the incidence of repeated device names but
> the code is, I think, safe: if the file already exists, the create
> will fail and no further action will be taken for this device. Any
> subsequent read of the file will just return details of the first
> device.

Then the file will be useless as you don't know which one it really is
for.

On your system, how many different files are listed here?  How many were
not able to be listed due to duplicated names?

> If this is common, I could, for example, implement a directory per
> device name. I didn't do it in the first instance to reduce complexity.

Then you are back to the whole sysfs tree, in debugfs, you don't want to
do that :)

> I was reluctant to add a suffix to the device name as that would have
> too high a chance of conflict where there are collections of similar
> devices.

A full "pathname" would be better, but really, I still fail to see the
usefulness of this.  How would getting the information here help a user
report to a developer?  How would I as a developer ever need the info
here?  What situations has this helped you debug, that a "simple" printk
in your code wouldn't have found?

thanks,

greg k-h
