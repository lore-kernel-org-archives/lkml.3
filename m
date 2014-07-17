Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbaGQOGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:06:03 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49998 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbaGQOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:06:00 -0400
Date: Thu, 17 Jul 2014 23:04:40 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: minchan@kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH v2] zram: auto add/del devices on demand
Message-ID: <20140717140440.GA1275@swordfish>
References: <53C7C131.1060306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C7C131.1060306@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (07/17/14 15:27), Timofey Titovets wrote:
> This add supporting of autochange count of zram devices on demand, like loop
> devices;
> This working by following rules:
> 	- Always save minimum devices count specified by num_device (can be
> specified while kernel module loading)
> 	- if last device already using add new device;
> 	- if last and prelast devices is free - delete last zram device;
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> 
> From v1 -> v2:
> Delete useless variable 'ret', added documentation for explain new zram
> behaviour
> 
> Please pull from:
> https://github.com/Nefelim4ag/linux.git
> ---
> Tested on 3.15.5-2-ARCH, can be applied on any kernel version
> after this patch 'zram: add LZ4 compression support' - https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=6e76668e415adf799839f0ab205142ad7002d260
> ---
> diff --git a/Documentation/blockdev/zram.txt
> b/Documentation/blockdev/zram.txt
> index 0595c3f..7f5c921 100644
> --- a/Documentation/blockdev/zram.txt
> +++ b/Documentation/blockdev/zram.txt
> @@ -18,9 +18,19 @@ Following shows a typical sequence of steps for using
> zram.
> 
>  1) Load Module:
>  	modprobe zram num_devices=4
> -	This creates 4 devices: /dev/zram{0,1,2,3}
> +	This pre creates 4 devices: /dev/zram{0,1,2,3}
>  	(num_devices parameter is optional. Default: 1)
> 
> +	Kernel dynamically changes number of zram devices by demand
> +	(between num_devices and 31)
> +	If set disk size(4) for last device
> +	kernel automatically adds new zram device
> +	If last two devices have zero disk size after reset(8),
> +	kernel will destroy last device
> +
> +	Summing up all features, comes one simple rule:
> +	"The last zram device is always free for use"

I can't understand what is the real benefit?


>  2) Set max number of compression streams
>  	Compression backend may use up to max_comp_streams compression streams,
>  	thus allowing up to max_comp_streams concurrent compression operations.
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 089e72c..9b2fc89 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -42,6 +42,10 @@ static const char *default_compressor = "lzo";
> 
>  /* Module params (documentation at end) */
>  static unsigned int num_devices = 1;
> +static unsigned int last_created_dev = 1;
> +
> +static void zram_add_dev(void);
> +static void zram_del_dev(void);
>  #define ZRAM_ATTR_RO(name)						\
>  static ssize_t zram_attr_##name##_show(struct device *d,		\
> @@ -168,6 +172,7 @@ static ssize_t comp_algorithm_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t len)
>  {
>  	struct zram *zram = dev_to_zram(dev);
> +
>  	down_write(&zram->init_lock);
>  	if (init_done(zram)) {
>  		up_write(&zram->init_lock);
> @@ -239,6 +244,7 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
>  {
>  	size_t num_pages;
>  	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
> +
>  	if (!meta)
>  		goto out;
> 
> @@ -374,6 +380,7 @@ static int zram_bvec_read(struct zram *zram, struct
> bio_vec *bvec,
>  	struct page *page;
>  	unsigned char *user_mem, *uncmem = NULL;
>  	struct zram_meta *meta = zram->meta;
> +
>  	page = bvec->bv_page;
> 
>  	read_lock(&meta->tb_lock);
> @@ -607,6 +614,7 @@ static void zram_reset_device(struct zram *zram, bool
> reset_capacity)
>  	/* Free all pages that are still in this zram device */
>  	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>  		unsigned long handle = meta->table[index].handle;
> +
>  		if (!handle)
>  			continue;
> 
> @@ -668,6 +676,7 @@ static ssize_t disksize_store(struct device *dev,
>  	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
>  	revalidate_disk(zram->disk);
>  	up_write(&zram->init_lock);
> +	zram_add_dev();
>  	return len;
> 
>  out_destroy_comp:
> @@ -712,6 +721,7 @@ static ssize_t reset_store(struct device *dev,
>  	bdput(bdev);
> 
>  	zram_reset_device(zram, true);
> +	zram_del_dev();
>  	return len;
> 
>  out:
> @@ -954,6 +964,41 @@ static void destroy_device(struct zram *zram)
>  	blk_cleanup_queue(zram->queue);
>  }
> 
> +/* remove last free device, if last and prelast dev a free */
> +static void zram_del_dev(void)
> +{
> +	if (last_created_dev < num_devices)
> +		return;
> +
> +	if (zram_devices[last_created_dev].disksize == 0 &&
> +		zram_devices[last_created_dev-1].disksize == 0
> +		) {

racy?

> +		destroy_device(&zram_devices[last_created_dev]);
> +		last_created_dev--;
> +		pr_info("Deleted zram%u device\n", last_created_dev);
> +	}
> +}
> +
> +/* Auto add empty zram device, if last device in use */
> +static void zram_add_dev(void)
> +{
> +	if (last_created_dev+1 > max_num_devices) {
> +		pr_warn("Can't add zram%u, max device number reached\n",
> +			num_devices);
> +		return;
> +	}

racy?

> +	if (&zram_devices[last_created_dev].disksize > 0) {
> +		last_created_dev++;
> +		if (create_device(&zram_devices[last_created_dev], last_created_dev)) {
> +			destroy_device(&zram_devices[last_created_dev]);
> +			last_created_dev--;

racy?


	-ss


> +			return;
> +		}
> +		pr_info("Created zram%u device\n", last_created_dev);
> +	}
> +}
> +
>  static int __init zram_init(void)
>  {
>  	int ret, dev_id;
> @@ -972,18 +1017,20 @@ static int __init zram_init(void)
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
>  			goto free_devices;
>  	}
> +	last_created_dev = num_devices-1;
> 
>  	pr_info("Created %u device(s) ...\n", num_devices);
> 
> @@ -1004,7 +1051,7 @@ static void __exit zram_exit(void)
>  	int i;
>  	struct zram *zram;
> 
> -	for (i = 0; i < num_devices; i++) {
> +	for (i = 0; i < last_created_dev+1; i++) {
>  		zram = &zram_devices[i];
> 
>  		destroy_device(zram);
> @@ -1025,7 +1072,7 @@ module_init(zram_init);
>  module_exit(zram_exit);
> 
>  module_param(num_devices, uint, 0);
> -MODULE_PARM_DESC(num_devices, "Number of zram devices");
> +MODULE_PARM_DESC(num_devices, "Number of pre created  zram devices");
> 
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
> 
