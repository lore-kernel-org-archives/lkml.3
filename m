Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaBZEfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:35:16 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:37452 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaBZEfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:35:13 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 26 Feb 2014 13:35:45 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 5/7] zram: enable multi stream compression support in
 zram
Message-ID: <20140226043545.GD4606@bbox>
References: <1393328073-12313-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1393328073-12313-6-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393328073-12313-6-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:34:31PM +0300, Sergey Senozhatsky wrote:
> 1) Introduce zram device attribute max_comp_streams to show and store
> current zcomp's max number of zcomp streams (num_strm).
> 
> 2) Extend zcomp zcomp_create() with `num_strm' parameter. `num_strm'
> limits the number of zcomp_strm structs in compression backend's idle
> list (max_comp_streams).
> 
> max_comp_streams used during initialisation as follows:
> -- passing to zcomp_create() num_strm equals to 1 will initialise zcomp
> using single compression stream zcomp_strm_single (mutex-based locking).
> -- passing to zcomp_create() num_strm greater than 1 will initialise zcomp
> using multi compression stream zcomp_strm_multi (spinlock-based locking).
> 
> default max_comp_streams value is 1, meaning that zram with single stream
> will be initialised.
> 
> Later patch will introduce configuration knob to change max_comp_streams
> on already initialised and used zcomp.
> 
> iozone -t 3 -R -r 16K -s 60M -I +Z
> 
>        test           base       1 strm (mutex)     3 strm (spinlock)
> -----------------------------------------------------------------------
>  Initial write      589286.78       583518.39          718011.05
>        Rewrite      604837.97       596776.38         1515125.72
>   Random write      584120.11       595714.58         1388850.25
>         Pwrite      535731.17       541117.38          739295.27
>         Fwrite     1418083.88      1478612.72         1484927.06
> 
> Usage example:
> set max_comp_streams to 4
>         echo 4 > /sys/block/zram0/max_comp_streams
> 
> show current max_comp_streams (default value is 1).
>         cat /sys/block/zram0/max_comp_streams
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zcomp.c    |  9 +++++++--
>  drivers/block/zram/zcomp.h    |  2 +-
>  drivers/block/zram/zram_drv.c | 42 +++++++++++++++++++++++++++++++++++++++++-
>  drivers/block/zram/zram_drv.h |  2 +-
>  4 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 6f238f5..1bcb70e 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -258,8 +258,9 @@ void zcomp_destroy(struct zcomp *comp)
>   * if requested algorithm is not supported or in case
>   * of init error
>   */
> -struct zcomp *zcomp_create(const char *compress)
> +struct zcomp *zcomp_create(const char *compress, int num_strm)

Let's use max_strm.

>  {
> +	int ret;

No need.

>  	struct zcomp *comp;
>  	struct zcomp_backend *backend;
>  
> @@ -272,7 +273,11 @@ struct zcomp *zcomp_create(const char *compress)
>  		return NULL;
>  
>  	comp->backend = backend;
> -	if (zcomp_strm_single_create(comp) != 0) {
> +	if (num_strm > 1)
> +		ret = zcomp_strm_multi_create(comp, num_strm);
> +	else
> +		ret = zcomp_strm_single_create(comp);
> +	if (ret != 0) {
>  		zcomp_destroy(comp);
>  		return NULL;
>  	}
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 861e04d..5514509 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -42,7 +42,7 @@ struct zcomp {
>  	void (*destroy)(struct zcomp *comp);
>  };
>  
> -struct zcomp *zcomp_create(const char *comp);
> +struct zcomp *zcomp_create(const char *comp, int num_strm);
>  void zcomp_destroy(struct zcomp *comp);
>  
>  struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 569ff58..42b9c7f 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -108,6 +108,40 @@ static ssize_t mem_used_total_show(struct device *dev,
>  	return sprintf(buf, "%llu\n", val);
>  }
>  
> +static ssize_t max_comp_streams_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int val;
> +	struct zram *zram = dev_to_zram(dev);
> +
> +	down_read(&zram->init_lock);
> +	val = zram->max_comp_streams;
> +	up_read(&zram->init_lock);
> +
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t max_comp_streams_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	int num;
> +	struct zram *zram = dev_to_zram(dev);
> +
> +	if (kstrtoint(buf, 0, &num))
> +		return -EINVAL;
> +	if (num < 1)
> +		return -EINVAL;
> +	down_write(&zram->init_lock);
> +	if (init_done(zram)) {
> +		up_write(&zram->init_lock);
> +		pr_info("Can't set max_comp_streams for initialized device\n");
> +		return -EBUSY;
> +	}
> +	zram->max_comp_streams = num;
> +	up_write(&zram->init_lock);
> +	return len;
> +}
> +
>  /* flag operations needs meta->tb_lock */
>  static int zram_test_flag(struct zram_meta *meta, u32 index,
>  			enum zram_pageflags flag)
> @@ -502,6 +536,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	}
>  
>  	zcomp_destroy(zram->comp);
> +	zram->max_comp_streams = 1;
> +
>  	zram_meta_free(zram->meta);
>  	zram->meta = NULL;
>  	/* Reset stats */
> @@ -530,7 +566,7 @@ static ssize_t disksize_store(struct device *dev,
>  		return -EBUSY;
>  	}
>  
> -	zram->comp = zcomp_create(default_compressor);
> +	zram->comp = zcomp_create(default_compressor, zram->max_comp_streams);
>  	if (!zram->comp) {
>  		up_write(&zram->init_lock);
>  		pr_info("Cannot initialise %s compressing backend\n",
> @@ -693,6 +729,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
>  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
>  static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
>  static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
> +static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
> +		max_comp_streams_show, max_comp_streams_store);
>  
>  ZRAM_ATTR_RO(num_reads);
>  ZRAM_ATTR_RO(num_writes);
> @@ -717,6 +755,7 @@ static struct attribute *zram_disk_attrs[] = {
>  	&dev_attr_orig_data_size.attr,
>  	&dev_attr_compr_data_size.attr,
>  	&dev_attr_mem_used_total.attr,
> +	&dev_attr_max_comp_streams.attr,
>  	NULL,
>  };
>  
> @@ -779,6 +818,7 @@ static int create_device(struct zram *zram, int device_id)
>  	}
>  
>  	zram->meta = NULL;
> +	zram->max_comp_streams = 1;
>  	return 0;
>  
>  out_free_disk:
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 45e04f7..ccf36d1 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -99,7 +99,7 @@ struct zram {
>  	 * we can store in a disk.
>  	 */
>  	u64 disksize;	/* bytes */
> -
> +	int max_comp_streams;
>  	struct zram_stats stats;
>  };
>  #endif
> -- 
> 1.9.0.291.g027825b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
