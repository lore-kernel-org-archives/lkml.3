Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaKEUXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:23:10 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47799 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaKEUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:23:06 -0500
Date: Wed, 5 Nov 2014 12:23:03 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Rodrigo Freire <rfreire@redhat.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        linux-mtd@lists.infradead.org, Felix Fietkau <nbd@openwrt.org>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Herton Krzesinski <hkrzesin@redhat.com>
Subject: Re: [PATCH V2] mtd: block2mtd: Present block2mtd timely on boot time
Message-ID: <20141105202303.GN23619@ld-irv-0074>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com>
 <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com>
 <20140909170231.GA14429@logfs.org>
 <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 04:28:03PM -0400, Rodrigo Freire wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> mtd: block2mtd: Ensure that block2mtd is presented in a timely fashion
> 
> Currently, a block MTD device is not presented to the system on time, in
> order to start mounting the filesystems. This patch ensures that block2mtd
> is presented at the right time, so filesystems can be mounted on boot time.
> This issue was seen on BCM2835 (Raspberry Pi) systems when mounting JFFS2
> block2mtd filesystems.

This still seems like a bad idea (using a block device + block2mtd +
JFFS2). Why are you doing this? See comments here:

  http://www.linux-mtd.infradead.org/faq/jffs2.html#L_hdd_jffs2

> This patchset also adds a MTD device name and a timeout option to the driver.
> Original patchset:
> https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/440-block2mtd_init.patch?rev=40444
> https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/441-block2mtd_probe.patch?rev=40444

You're stating right up front that this patch is doing several different
things. Please split these up into separate commits which get their own
description.

> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
> Signed-off-by: Herton Krzesinski <herton@redhat.com>
> ---
> V2: Uses kstrdup, removed PAGE_MASK.

You have several checkpatch warnings. Please fix them.

WARNING:LONG_LINE: line over 80 characters
#57: FILE: drivers/mtd/devices/block2mtd.c:221:
+static struct block2mtd_dev *add_device(char *devname, int erase_size, const char *mtdname, int timeout)

WARNING:SPACING: space prohibited between function name and open parenthesis '('
#111: FILE: drivers/mtd/devices/block2mtd.c:286:
+	name = kstrdup (mtdname, GFP_KERNEL);

WARNING:LONG_LINE: line over 80 characters
#150: FILE: drivers/mtd/devices/block2mtd.c:385:
+	char buf[80 + 12 + 80 + 8]; /* 80 for device, 12 for erase size, 80 for name, 8 for timeout */

total: 0 errors, 3 warnings, 164 lines checked

> --- a/drivers/mtd/devices/block2mtd.c	2014-09-16 21:38:12.543952627 -0300
> +++ b/drivers/mtd/devices/block2mtd.c	2014-09-17 17:43:21.424944394 -0300
> @@ -9,7 +9,15 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +/*
> +* When the first attempt at device initialization fails, we may need to
> +* wait a little bit and retry. This timeout, by default 3 seconds, gives
> +* device time to start up. Required on BCM2708 and a few other chipsets.
> +*/
> +#define MTD_DEFAULT_TIMEOUT	3
> +
>  #include <linux/module.h>
> +#include <linux/delay.h>
>  #include <linux/fs.h>
>  #include <linux/blkdev.h>
>  #include <linux/bio.h>
> @@ -17,6 +25,7 @@
>  #include <linux/list.h>
>  #include <linux/init.h>
>  #include <linux/mtd/mtd.h>
> +#include <linux/mtd/partitions.h>
>  #include <linux/mutex.h>
>  #include <linux/mount.h>
>  #include <linux/slab.h>
> @@ -209,12 +218,14 @@ static void block2mtd_free_device(struct
>  }
>  
>  
> -static struct block2mtd_dev *add_device(char *devname, int erase_size)
> +static struct block2mtd_dev *add_device(char *devname, int erase_size, const char *mtdname, int timeout)

The addition of this name parameter should definitely be its own patch.

>  {
>  	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
> -	struct block_device *bdev;
> +	struct block_device *bdev = ERR_PTR(-ENODEV);
>  	struct block2mtd_dev *dev;
> +	struct mtd_partition *part;
>  	char *name;
> +	int i;

This variable produces a warning when built as a module:

   drivers/mtd/devices/block2mtd.c: In function ‘add_device’:
   drivers/mtd/devices/block2mtd.c:228:6: warning: unused variable ‘i’ [-Wunused-variable]
     int i;
         ^

>  
>  	if (!devname)
>  		return NULL;
> @@ -225,15 +236,28 @@ static struct block2mtd_dev *add_device(
>  
>  	/* Get a handle on the device */
>  	bdev = blkdev_get_by_path(devname, mode, dev);
> -#ifndef MODULE
> -	if (IS_ERR(bdev)) {
>  
> -		/* We might not have rootfs mounted at this point. Try
> -		   to resolve the device name by other means. */
> -
> -		dev_t devt = name_to_dev_t(devname);
> -		if (devt)
> -			bdev = blkdev_get_by_dev(devt, mode, dev);
> +#ifndef MODULE
> +/*
> +* We might not have the root device mounted at this point.
> +* Try to resolve the device name by other means.
> +*/

These lines should start with a space, so the asterisks line up.

> +	for (i = 0; IS_ERR(bdev) && i <= timeout; i++) {
> +		dev_t devt;
> +
> +		if (i)
> +			/*
> +			 * Calling wait_for_device_probe in the first loop 
> +			 * was not enough, sleep for a bit in subsequent
> +			 * go-arounds.
> +			*/
> +			msleep(1000);
> +		wait_for_device_probe();
> +
> +		devt = name_to_dev_t(devname);
> +		if (!devt)
> +			continue;
> +		bdev = blkdev_get_by_dev(devt, mode, dev);
>  	}
>  #endif
>  
> @@ -257,13 +281,14 @@ static struct block2mtd_dev *add_device(
>  
>  	/* Setup the MTD structure */
>  	/* make the name contain the block device in */
> -	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
> +	if (!mtdname)
> +		mtdname = devname;
> +	name = kstrdup (mtdname, GFP_KERNEL);
>  	if (!name)
>  		goto err_destroy_mutex;
>  
>  	dev->mtd.name = name;
> -
> -	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
> +	dev->mtd.size = dev->blkdev->bd_inode->i_size & ~(erase_size - 1);

This deserves its own patch, or at least some explanation of why you're
doing this. I guess you're seeing cases where the provided erasesize is
not aligned with the size of the block device?

>  	dev->mtd.erasesize = erase_size;
>  	dev->mtd.writesize = 1;
>  	dev->mtd.writebufsize = PAGE_SIZE;
> @@ -276,15 +301,19 @@ static struct block2mtd_dev *add_device(
>  	dev->mtd.priv = dev;
>  	dev->mtd.owner = THIS_MODULE;
>  
> -	if (mtd_device_register(&dev->mtd, NULL, 0)) {
> +	part = kzalloc(sizeof(struct mtd_partition), GFP_KERNEL);
> +	part->name = name;
> +	part->offset = 0;
> +	part->size = dev->mtd.size;

Why are you doing this? This also does not fit the description of this
patch. And what's wrong with using the default partitioning options?
Won't we (if not specified in some other way) default to an
unpartitioned MTD, which covers the entire device?

> +	if (mtd_device_register(&dev->mtd, part, 1)) {
>  		/* Device didn't get added, so free the entry */
>  		goto err_destroy_mutex;
>  	}
> +
>  	list_add(&dev->list, &blkmtd_device_list);
>  	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
>  		dev->mtd.index,
> -		dev->mtd.name + strlen("block2mtd: "),
> -		dev->mtd.erasesize >> 10, dev->mtd.erasesize);
> +		mtdname, dev->mtd.erasesize >> 10, dev->mtd.erasesize);
>  	return dev;
>  
>  err_destroy_mutex:
> @@ -353,11 +382,12 @@ static char block2mtd_paramline[80 + 12]
>  
>  static int block2mtd_setup2(const char *val)
>  {
> -	char buf[80 + 12]; /* 80 for device, 12 for erase size */
> +	char buf[80 + 12 + 80 + 8]; /* 80 for device, 12 for erase size, 80 for name, 8 for timeout */
>  	char *str = buf;
> -	char *token[2];
> +	char *token[4];
>  	char *name;
>  	size_t erase_size = PAGE_SIZE;
> +	unsigned long timeout = MTD_DEFAULT_TIMEOUT;
>  	int i, ret;
>  
>  	if (strnlen(val, sizeof(buf)) >= sizeof(buf)) {
> @@ -368,7 +398,7 @@ static int block2mtd_setup2(const char *
>  	strcpy(str, val);
>  	kill_final_newline(str);
>  
> -	for (i = 0; i < 2; i++)
> +	for (i = 0; i < 4; i++)
>  		token[i] = strsep(&str, ",");
>  
>  	if (str) {
> @@ -395,7 +425,13 @@ static int block2mtd_setup2(const char *
>  		}
>  	}
>  
> -	add_device(name, erase_size);
> +	if (token[2] && (strlen(token[2]) + 1 > 80))
> +		pr_err("mtd device name too long");
> +
> +
> +	if (token[3] && kstrtoul(token[3], 0, &timeout))
> +		pr_err("invalid timeout");
> +	add_device(name, erase_size, token[2], timeout);
>  
>  	return 0;
>  }
> @@ -429,7 +465,7 @@ static int block2mtd_setup(const char *v
>  
>  
>  module_param_call(block2mtd, block2mtd_setup, NULL, NULL, 0200);
> -MODULE_PARM_DESC(block2mtd, "Device to use. \"block2mtd=<dev>[,<erasesize>]\"");
> +MODULE_PARM_DESC(block2mtd, "Device to use. \"block2mtd=<dev>[,<erasesize>[,<name>[,<timeout>]]]\"");
>  
>  static int __init block2mtd_init(void)
>  {
> @@ -463,8 +499,7 @@ static void block2mtd_exit(void)
>  	}
>  }
>  
> -
> -module_init(block2mtd_init);
> +late_initcall(block2mtd_init);
>  module_exit(block2mtd_exit);
>  
>  MODULE_LICENSE("GPL");

Brian
