Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaG2DAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:00:22 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:57672 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaG2DAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:00:20 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 29 Jul 2014 12:00:21 +0900
From: Minchan Kim <minchan@kernel.org>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH v3 RESEND] zram: auto add new devices on demand
Message-ID: <20140729030021.GA22707@bbox>
References: <53CCEF76.4040002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53CCEF76.4040002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Timofey,

Sorry for late response and thanks for suggesting new feature.

First of all, I'd like to know your usecase.

I don't mean I am against this feature and I tend to agree it would
be good if we can make new device dynamically but until now, I don't
hear any requirement like that. So we need compelling usecase to
justify maintainance overhead.

On Mon, Jul 21, 2014 at 01:46:14PM +0300, Timofey Titovets wrote:
> From: Timofey Titovets <nefelim4ag@gmail.com>
> 
> This add supporting of auto allocate new zram devices on demand,
> like loop devices
> 
> This working by following rules:
> 	- Pre create zram devices specified by num_device
> 	- if all device already in use -> add new free device
> 
> From v1 -> v2:
> Delete useless variable 'ret', added documentation for explain new
> zram behavior
> 
> From v2 -> v3
> Delete logic to destroy not used devices, for avoid concurrency issues
> Code refactoring for made patch small and clean as possible
> Patch can pass the test:
> 
> #!/bin/sh
> modprobe zram
> while true; do
>                 echo 10485760 > /sys/block/zram0/disksize&
>                 echo 1 > /sys/block/zram0/reset&
> done
> 
> Can be pulled from:
> https://github.com/Nefelim4ag/linux.git
> 
> Tested on 3.15.5-2-ARCH, can be applied on any kernel version
> after this patch 'zram: add LZ4 compression support' - https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=6e76668e415adf799839f0ab205142ad7002d260
> 
> ---
> 
> diff --git a/Documentation/blockdev/zram.txt
> b/Documentation/blockdev/zram.txt
> index 0595c3f..a090ac7 100644
> --- a/Documentation/blockdev/zram.txt
> +++ b/Documentation/blockdev/zram.txt
> @@ -21,6 +21,9 @@ Following shows a typical sequence of steps for
> using zram.
>  	This creates 4 devices: /dev/zram{0,1,2,3}
>  	(num_devices parameter is optional. Default: 1)
> 
> +	If all device in use kernel will create new zram device
> +	(between num_devices and 31)
> +
>  2) Set max number of compression streams
>  	Compression backend may use up to max_comp_streams compression streams,
>  	thus allowing up to max_comp_streams concurrent compression operations.
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 089e72c..cc78779 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -43,6 +43,8 @@ static const char *default_compressor = "lzo";
>  /* Module params (documentation at end) */
>  static unsigned int num_devices = 1;
> 
> +static inline int zram_add_dev(void);
> +
>  #define ZRAM_ATTR_RO(name)						\
>  static ssize_t zram_attr_##name##_show(struct device *d,		\
>  				struct device_attribute *attr, char *b)	\
> @@ -168,6 +170,7 @@ static ssize_t comp_algorithm_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t len)
>  {
>  	struct zram *zram = dev_to_zram(dev);
> +

unnecessary change

>  	down_write(&zram->init_lock);
>  	if (init_done(zram)) {
>  		up_write(&zram->init_lock);
> @@ -239,6 +242,7 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
>  {
>  	size_t num_pages;
>  	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
> +

Ditto

>  	if (!meta)
>  		goto out;
> 
> @@ -374,6 +378,7 @@ static int zram_bvec_read(struct zram *zram,
> struct bio_vec *bvec,
>  	struct page *page;
>  	unsigned char *user_mem, *uncmem = NULL;
>  	struct zram_meta *meta = zram->meta;
> +

Ditto

>  	page = bvec->bv_page;
> 
>  	read_lock(&meta->tb_lock);
> @@ -607,6 +612,7 @@ static void zram_reset_device(struct zram *zram,
> bool reset_capacity)
>  	/* Free all pages that are still in this zram device */
>  	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>  		unsigned long handle = meta->table[index].handle;
> +

Ditto

>  		if (!handle)
>  			continue;
> 
> @@ -667,6 +673,7 @@ static ssize_t disksize_store(struct device *dev,
>  	zram->disksize = disksize;
>  	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
>  	revalidate_disk(zram->disk);
> +	zram_add_dev();

Why do you add new device unconditionally?
Maybe we need new konb on sysfs or ioctl for adding new device?
Any thought, guys?


>  	up_write(&zram->init_lock);
>  	return len;
> 
> @@ -954,6 +961,34 @@ static void destroy_device(struct zram *zram)
>  	blk_cleanup_queue(zram->queue);
>  }
> 
> +/*
> + * Automatically add empty zram device,
> + * if all created devices already initialized
> + */
> +static inline int zram_add_dev(void)
> +{
> +	int dev_id;
> +
> +	for (dev_id = 0; dev_id < num_devices; dev_id++) {
> +		if (!zram_devices[dev_id].disksize)
> +			return 0;
> +	}
> +
> +	if (max_num_devices <= num_devices) {
> +		pr_warn("Can't add zram%u, max device number reached\n", num_devices);
> +		return 1;
> +	}
> +
> +	if (create_device(&zram_devices[num_devices], num_devices)) {
> +		destroy_device(&zram_devices[num_devices]);
> +		return 1;
> +	}
> +	pr_info("Created zram%u device\n", num_devices);
> +	num_devices++;

Who protects num_devices race?

> +
> +	return 0;
> +}

There is only adding function. Where is removing function?

Sorry, I am on vacation tomorrow so pz, understand my late response.

> +
>  static int __init zram_init(void)
>  {
>  	int ret, dev_id;
> @@ -972,13 +1007,14 @@ static int __init zram_init(void)
>  		goto out;
>  	}
> 
> -	/* Allocate the device array and initialize each one */
> -	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
> +	/* Allocate the device array */
> +	zram_devices = kcalloc(max_num_devices, sizeof(struct zram), GFP_KERNEL);
>  	if (!zram_devices) {
>  		ret = -ENOMEM;
>  		goto unregister;
>  	}
> 
> +	/* Initialise zram{0..num_devices} */
>  	for (dev_id = 0; dev_id < num_devices; dev_id++) {
>  		ret = create_device(&zram_devices[dev_id], dev_id);
>  		if (ret)
> @@ -1025,7 +1061,7 @@ module_init(zram_init);
>  module_exit(zram_exit);
> 
>  module_param(num_devices, uint, 0);
> -MODULE_PARM_DESC(num_devices, "Number of zram devices");
> +MODULE_PARM_DESC(num_devices, "Number of pre created  zram devices");
> 
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
