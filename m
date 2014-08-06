Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaHFXHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 19:07:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:5477 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbaHFXHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 19:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,814,1400050800"; 
   d="scan'208";a="554827838"
Message-ID: <1407366387.2869.3.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 3/4] brd: Fix all partitions BUGs
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Wed, 06 Aug 2014 17:06:27 -0600
In-Reply-To: <53E2127B.1020805@plexistor.com>
References: <53E21125.9080308@plexistor.com>
	 <53E2127B.1020805@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 14:33 +0300, Boaz Harrosh wrote:
> This patch fixes up brd's partitions scheme, now enjoying all worlds.
> 
> The MAIN fix here is that currently if one fdisks some partitions,
> a BAD bug will make all partitions point to the same start-end sector
> ie: 0 - brd_size And an mkfs of any partition would trash the partition
> table and the other partition.
> 
> Another fix is that "mount -U uuid" did not work, because of the
> GENHD_FL_SUPPRESS_PARTITION_INFO flag.
> 
> So NOW the logic goes like this:
> * max_part - Just says how many minors to reserve between devices
>   But in any way, there can be as many partition as requested.
>   If minors between devices ends, then dynamic 259-major ids will
>   be allocated on the fly.
>   The default is now max_part=1, which means all partitions devt
>   will be from the dynamic major-range.
>   (If persistent partition minors is needed use max_part=)
> 
> * Creation of new devices on the fly still/always work:
>   mknod /path/devnod b 1 X
>   fdisk -l /path/devnod
>   Will create a new device if (X / max_part) was not already
>   created before. (Just as before)
> 
>   partitions on the dynamically created device will work as well
>   Same logic applies with minors as with the pre-created ones.
> 
> TODO: dynamic grow of device size, maybe through sysfs. So each
>       device can have it's own size.

With this patch we end up in what feels like a weird place where we're half
using the old scheme of major/minor allocation, and half in the world of
dynamic major/minors.  Devices have a major of 1 and minors that increment by
1, but partitions have a major of 259 (BLOCK_EXT_MAJOR):

	brw-rw---- 1 root disk   1, 0 Aug  6 14:10 /dev/ram0
	brw-rw---- 1 root disk   1, 1 Aug  6 14:13 /dev/ram1
	brw-rw---- 1 root disk 259, 0 Aug  6 14:14 /dev/ram1p1
	brw-rw---- 1 root disk 259, 1 Aug  6 14:13 /dev/ram1p2
	brw-rw---- 1 root disk 259, 2 Aug  6 14:14 /dev/ram1p51

For NVMe and PRD you get a major of 259 all around:

	brw-rw---- 1 root disk 259, 0 Aug  6 16:55 /dev/pmem0
	brw-rw---- 1 root disk 259, 2 Aug  6 16:55 /dev/pmem0p1
	brw-rw---- 1 root disk 259, 3 Aug  6 16:55 /dev/pmem0p2
	brw-rw---- 1 root disk 259, 1 Aug  6 16:54 /dev/pmem1

It could be that this is fine, but it just smells fishy to me I guess.

Also, it looks like you can still create a new device with this patch, but you
can't create partitions on that device.  Not sure if this is just what you get
when you dynamically create a device on the fly, or if it's a symptom of
something larger.

- Ross

> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/brd.c | 93 +++++++++++++++++++++--------------------------------
>  1 file changed, 36 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 3f07cb4..9673704 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -447,16 +447,18 @@ static const struct block_device_operations brd_fops = {
>  /*
>   * And now the modules code and kernel interface.
>   */
> -static int rd_nr;
> -int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> -static int max_part;
> -static int part_shift;
> +static int rd_nr = CONFIG_BLK_DEV_RAM_COUNT;
>  module_param(rd_nr, int, S_IRUGO);
>  MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
> +
> +int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
>  module_param(rd_size, int, S_IRUGO);
>  MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
> +
> +static int max_part = 1;
>  module_param(max_part, int, S_IRUGO);
> -MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
> +MODULE_PARM_DESC(max_part, "Num Minors to reserve between devices");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
>  MODULE_ALIAS("rd");
> @@ -502,15 +504,15 @@ static struct brd_device *brd_alloc(int i)
>  	brd->brd_queue->limits.discard_zeroes_data = 1;
>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
>  
> -	disk = brd->brd_disk = alloc_disk(1 << part_shift);
> +	disk = brd->brd_disk = alloc_disk(max_part);
>  	if (!disk)
>  		goto out_free_queue;
>  	disk->major		= RAMDISK_MAJOR;
> -	disk->first_minor	= i << part_shift;
> +	disk->first_minor	= i * max_part;
>  	disk->fops		= &brd_fops;
>  	disk->private_data	= brd;
>  	disk->queue		= brd->brd_queue;
> -	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
> +	disk->flags		= GENHD_FL_EXT_DEVT;
>  	sprintf(disk->disk_name, "ram%d", i);
>  	set_capacity(disk, rd_size * 2);
>  
> @@ -532,10 +534,11 @@ static void brd_free(struct brd_device *brd)
>  	kfree(brd);
>  }
>  
> -static struct brd_device *brd_init_one(int i)
> +static struct brd_device *brd_init_one(int i, bool *new)
>  {
>  	struct brd_device *brd;
>  
> +	*new = false;
>  	list_for_each_entry(brd, &brd_devices, brd_list) {
>  		if (brd->brd_number == i)
>  			goto out;
> @@ -546,6 +549,7 @@ static struct brd_device *brd_init_one(int i)
>  		add_disk(brd->brd_disk);
>  		list_add_tail(&brd->brd_list, &brd_devices);
>  	}
> +	*new = true;
>  out:
>  	return brd;
>  }
> @@ -561,70 +565,46 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
>  {
>  	struct brd_device *brd;
>  	struct kobject *kobj;
> +	bool new;
>  
>  	mutex_lock(&brd_devices_mutex);
> -	brd = brd_init_one(MINOR(dev) >> part_shift);
> +	brd = brd_init_one(MINOR(dev) / max_part, &new);
>  	kobj = brd ? get_disk(brd->brd_disk) : NULL;
>  	mutex_unlock(&brd_devices_mutex);
>  
> -	*part = 0;
> +	if (new)
> +		*part = 0;
> +
>  	return kobj;
>  }
>  
>  static int __init brd_init(void)
>  {
> -	int i, nr;
> -	unsigned long range;
>  	struct brd_device *brd, *next;
> +	int i;
>  
>  	/*
>  	 * brd module now has a feature to instantiate underlying device
>  	 * structure on-demand, provided that there is an access dev node.
> -	 * However, this will not work well with user space tool that doesn't
> -	 * know about such "feature".  In order to not break any existing
> -	 * tool, we do the following:
>  	 *
> -	 * (1) if rd_nr is specified, create that many upfront, and this
> -	 *     also becomes a hard limit.
> -	 * (2) if rd_nr is not specified, create CONFIG_BLK_DEV_RAM_COUNT
> -	 *     (default 16) rd device on module load, user can further
> -	 *     extend brd device by create dev node themselves and have
> -	 *     kernel automatically instantiate actual device on-demand.
> +	 * (1) if rd_nr is specified, create that many upfront. else
> +	 *     it defaults to CONFIG_BLK_DEV_RAM_COUNT
> +	 * (2) User can further extend brd devices by create dev node themselves
> +	 *     and have kernel automatically instantiate actual device
> +	 *     on-demand. Example:
> +	 *		mknod /path/devnod_name b 1 X	# 1 is the rd major
> +	 *		fdisk -l /path/devnod_name
> +	 *	If (X / max_part) was not already created it will be created
> +	 *	dynamically.
>  	 */
>  
> -	part_shift = 0;
> -	if (max_part > 0) {
> -		part_shift = fls(max_part);
> -
> -		/*
> -		 * Adjust max_part according to part_shift as it is exported
> -		 * to user space so that user can decide correct minor number
> -		 * if [s]he want to create more devices.
> -		 *
> -		 * Note that -1 is required because partition 0 is reserved
> -		 * for the whole disk.
> -		 */
> -		max_part = (1UL << part_shift) - 1;
> -	}
> -
> -	if ((1UL << part_shift) > DISK_MAX_PARTS)
> -		return -EINVAL;
> -
> -	if (rd_nr > 1UL << (MINORBITS - part_shift))
> -		return -EINVAL;
> -
> -	if (rd_nr) {
> -		nr = rd_nr;
> -		range = rd_nr << part_shift;
> -	} else {
> -		nr = CONFIG_BLK_DEV_RAM_COUNT;
> -		range = 1UL << MINORBITS;
> -	}
> -
>  	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
>  		return -EIO;
>  
> -	for (i = 0; i < nr; i++) {
> +	if (unlikely(!max_part))
> +		max_part = 1;
> +
> +	for (i = 0; i < rd_nr; i++) {
>  		brd = brd_alloc(i);
>  		if (!brd)
>  			goto out_free;
> @@ -636,7 +616,7 @@ static int __init brd_init(void)
>  	list_for_each_entry(brd, &brd_devices, brd_list)
>  		add_disk(brd->brd_disk);
>  
> -	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), range,
> +	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS,
>  				  THIS_MODULE, brd_probe, NULL, NULL);
>  
>  	printk(KERN_INFO "brd: module loaded\n");
> @@ -649,21 +629,20 @@ out_free:
>  	}
>  	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
>  
> +	printk(KERN_INFO "brd: module NOT loaded !!!\n");
>  	return -ENOMEM;
>  }
>  
>  static void __exit brd_exit(void)
>  {
> -	unsigned long range;
>  	struct brd_device *brd, *next;
>  
> -	range = rd_nr ? rd_nr << part_shift : 1UL << MINORBITS;
> -
>  	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
>  		brd_del_one(brd);
>  
> -	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), range);
> +	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS);
>  	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
> +	printk(KERN_INFO "brd: module unloaded\n");
>  }
>  
>  module_init(brd_init);




