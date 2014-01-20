Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822AbaATFRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:17:24 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61083 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaATFRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:17:21 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-9f-52dcb15f1dac
Date: Mon, 20 Jan 2014 14:18:25 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] zram: list and select compression algorithms
Message-ID: <20140120051825.GD8155@bbox>
References: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389956657-5486-4-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389956657-5486-4-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 02:04:17PM +0300, Sergey Senozhatsky wrote:
> Add compressor device attr that allows to list and select
> compression algorithms.
> 
> Define and make available for selection LZ4 compressor ops.
> 
> usage example:
> List available compression algorithms (currently selected
> one is LZO):
>   cat /sys/block/zram0/compressor
>   <lzo> lz4
> 
> Change compression algorithm to LZ4:
>   echo lz4 > /sys/block/zram0/compressor
>   cat /sys/block/zram0/compressor
>   lzo <lz4>

Interface looks good to me.

> 
> Update documentation with "Select compression algorithm" section
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  Documentation/blockdev/zram.txt | 23 ++++++++++++++++-----
>  drivers/block/zram/Kconfig      |  2 ++
>  drivers/block/zram/zram_drv.c   | 46 +++++++++++++++++++++++++++++++++++++----
>  3 files changed, 62 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
> index 393541be..af90d29 100644
> --- a/Documentation/blockdev/zram.txt
> +++ b/Documentation/blockdev/zram.txt
> @@ -21,7 +21,20 @@ Following shows a typical sequence of steps for using zram.
>  	This creates 4 devices: /dev/zram{0,1,2,3}
>  	(num_devices parameter is optional. Default: 1)
>  
> -2) Set Disksize
> +2) Select compression algorithm
> +'compressor' sysfs node allows to see available, currently used
> +and change compression algorithms.
> +In order to list available compression algorithms (currently selected
> +one is LZO):
> +	cat /sys/block/zram0/compressor
> +	<lzo> lz4
> +
> +Change compression algorithm to LZ4:
> +	echo lz4 > /sys/block/zram0/compressor
> +	cat /sys/block/zram0/compressor
> +	lzo <lz4>
> +
> +3) Set Disksize
>          Set disk size by writing the value to sysfs node 'disksize'.
>          The value can be either in bytes or you can use mem suffixes.
>          Examples:
> @@ -38,14 +51,14 @@ There is little point creating a zram of greater than twice the size of memory
>  since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
>  size of the disk when not in use so a huge zram is wasteful.
>  
> -3) Activate:
> +4) Activate:
>  	mkswap /dev/zram0
>  	swapon /dev/zram0
>  
>  	mkfs.ext4 /dev/zram1
>  	mount /dev/zram1 /tmp
>  
> -4) Stats:
> +5) Stats:
>  	Per-device statistics are exported as various nodes under
>  	/sys/block/zram<id>/
>  		disksize
> @@ -59,11 +72,11 @@ size of the disk when not in use so a huge zram is wasteful.
>  		compr_data_size
>  		mem_used_total
>  
> -5) Deactivate:
> +6) Deactivate:
>  	swapoff /dev/zram0
>  	umount /dev/zram1
>  
> -6) Reset:
> +7) Reset:
>  	Write any positive value to 'reset' sysfs node
>  	echo 1 > /sys/block/zram0/reset
>  	echo 1 > /sys/block/zram1/reset
> diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> index 3450be8..09dacd6 100644
> --- a/drivers/block/zram/Kconfig
> +++ b/drivers/block/zram/Kconfig
> @@ -3,6 +3,8 @@ config ZRAM
>  	depends on BLOCK && SYSFS && ZSMALLOC
>  	select LZO_COMPRESS
>  	select LZO_DECOMPRESS
> +	select LZ4_COMPRESS
> +	select LZ4_DECOMPRESS

But user should select what kinds of compressor then want
some user want only lzo while others want lzo, lz2 and zlib all.


>  	default n
>  	help
>  	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 4f2c748..f1434f8 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -31,6 +31,7 @@
>  #include <linux/string.h>
>  #include <linux/vmalloc.h>
>  #include <linux/lzo.h>
> +#include <linux/lz4.h>
>  
>  #include "zram_drv.h"
>  
> @@ -47,6 +48,12 @@ static struct zram_compress_ops lzo_compressor = {
>  	.decompress = lzo1x_decompress_safe,
>  };
>  
> +static struct zram_compress_ops lz4_compressor = {
> +	.workmem_sz = LZ4_MEM_COMPRESS,
> +	.compress = lz4_compress,
> +	.decompress = lz4_decompress_unknownoutputsize,
> +};
> +
>  #define ZRAM_ATTR_RO(name)						\
>  static ssize_t zram_attr_##name##_show(struct device *d,		\
>  				struct device_attribute *attr, char *b)	\
> @@ -113,6 +120,34 @@ static ssize_t mem_used_total_show(struct device *dev,
>  	return sprintf(buf, "%llu\n", val);
>  }
>  
> +static ssize_t compressor_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct zram *zram = dev_to_zram(dev);
> +	if (zram->ops == &lzo_compressor)
> +		return sprintf(buf, "<lzo> lz4\n");
> +	return sprintf(buf, "lzo <lz4>\n");
> +}
> +
> +static ssize_t compressor_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct zram *zram = dev_to_zram(dev);
> +
> +	down_write(&zram->init_lock);
> +	if (init_done(zram)) {
> +		up_write(&zram->init_lock);
> +		pr_info("Cannot change compressor for initialized device\n");
> +		return -EBUSY;
> +	}
> +	if (strncmp(buf, "lzo", 3) == 0)
> +		zram->ops = &lzo_compressor;
> +	else
> +		zram->ops = &lz4_compressor;
> +	up_write(&zram->init_lock);
> +	return len;
> +}

Changing compressow should be allowed only when zram was created or
reset. IOW, there should be no datacompressed by old compressor in memory.

> +
>  /* flag operations needs meta->tb_lock */
>  static int zram_test_flag(struct zram_meta *meta, u32 index,
>  			enum zram_pageflags flag)
> @@ -285,7 +320,7 @@ static void zram_free_page(struct zram *zram, size_t index)
>  
>  static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  {
> -	int ret = LZO_E_OK;
> +	int ret = 0;
>  	size_t clen = PAGE_SIZE;
>  	unsigned char *cmem;
>  	struct zram_meta *meta = zram->meta;
> @@ -311,7 +346,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  	read_unlock(&meta->tb_lock);
>  
>  	/* Should NEVER happen. Return bio error if it does. */
> -	if (unlikely(ret != LZO_E_OK)) {
> +	if (unlikely(ret)) {
>  		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
>  		atomic64_inc(&zram->stats.failed_reads);
>  		return ret;
> @@ -354,7 +389,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  
>  	ret = zram_decompress_page(zram, uncmem, index);
>  	/* Should NEVER happen. Return bio error if it does. */
> -	if (unlikely(ret != LZO_E_OK))
> +	if (unlikely(ret))
>  		goto out_cleanup;
>  
>  	if (is_partial_io(bvec))
> @@ -433,7 +468,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		uncmem = NULL;
>  	}
>  
> -	if (unlikely(ret != LZO_E_OK)) {
> +	if (unlikely(ret)) {
>  		pr_err("Compression failed! err=%d\n", ret);
>  		goto out;
>  	}
> @@ -705,6 +740,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
>  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
>  static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
>  static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
> +static DEVICE_ATTR(compressor, S_IRUGO | S_IWUSR,
> +		compressor_show, compressor_store);
>  
>  ZRAM_ATTR_RO(num_reads);
>  ZRAM_ATTR_RO(num_writes);
> @@ -719,6 +756,7 @@ static struct attribute *zram_disk_attrs[] = {
>  	&dev_attr_disksize.attr,
>  	&dev_attr_initstate.attr,
>  	&dev_attr_reset.attr,
> +	&dev_attr_compressor.attr,
>  	&dev_attr_num_reads.attr,
>  	&dev_attr_num_writes.attr,
>  	&dev_attr_failed_reads.attr,
> -- 
> 1.8.5.3.493.gb139ac2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
