Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaBXXwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:52:51 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43997 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaBXXwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:52:49 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-f7-530bdb4fda1e
Date: Tue, 25 Feb 2014 08:53:15 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 5/6] zram: enalbe multi stream compression support in
 zram
Message-ID: <20140224235315.GE24325@bbox>
References: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392983443-9807-6-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392983443-9807-6-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 02:50:42PM +0300, Sergey Senozhatsky wrote:
> 1) Add ZRAM_MULTI_STREAM configuration option and make multi stream
> zcomp support available.
> 
> 2) Introduce zram device attribute max_comp_streams to show and store
> current zcomp's max number of zcomp streams (num_strm).
> 
> 3) Extend zcomp zcomp_create() with `num_strm' parameter. `num_strm'
> limits the number of zcomp_strm structs in compression backend's idle
> list (max_comp_streams).
> 
> If ZRAM_MULTI_STREAM option selected:
> -- user can change max number of compression streams (max_comp_streams),
>    otherwise, attempt to change its default value (1) will be ignored.
> -- passing to zcomp_create() num_strm equals to 1 will initialise zcomp
>    using single compression stream zcomp_strm_single (mutex-based locking)
> -- passing to zcomp_create() num_strm greater than 1 will initialise zcomp
>    using multi compression stream zcomp_strm_multi (spinlock-based locking)
> 
> If ZRAM_MULTI_STREAM has not been selected, only single compression stream
> support available.
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
>  drivers/block/zram/Kconfig    | 10 ++++++++++
>  drivers/block/zram/zcomp.c    | 13 +++++++++++--
>  drivers/block/zram/zcomp.h    |  2 +-
>  drivers/block/zram/zram_drv.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  drivers/block/zram/zram_drv.h |  2 +-
>  5 files changed, 65 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> index 3450be8..a2ba9a9 100644
> --- a/drivers/block/zram/Kconfig
> +++ b/drivers/block/zram/Kconfig
> @@ -15,6 +15,16 @@ config ZRAM
>  
>  	  See zram.txt for more information.
>  
> +config ZRAM_MULTI_STREAM
> +	bool "Multi stream compression support"
> +	depends on ZRAM
> +	default n
> +	help
> +	  This option adds additional functionality to ZRAM, that enables
> +	  multi compression stream support and provides ability to control
> +	  maximum number of parallel compressions using max_comp_streams
> +	  device attribute.
> +
>  config ZRAM_DEBUG
>  	bool "Compressed RAM block device debug support"
>  	depends on ZRAM
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 41325ed..7faa6bd 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -240,8 +240,9 @@ void zcomp_destroy(struct zcomp *comp)
>   * if requested algorithm is not supported or in case
>   * of init error
>   */
> -struct zcomp *zcomp_create(const char *compress)
> +struct zcomp *zcomp_create(const char *compress, int num_strm)
>  {
> +	int ret;
>  	struct zcomp *comp;
>  	struct zcomp_backend *backend;
>  
> @@ -254,7 +255,15 @@ struct zcomp *zcomp_create(const char *compress)
>  		return NULL;
>  
>  	comp->backend = backend;
> -	if (zcomp_strm_single_create(comp) != 0) {
> +#ifdef CONFIG_ZRAM_MULTI_STREAM
> +	if (num_strm > 1)
> +		ret = zcomp_strm_multi_create(comp, num_strm);
> +	else
> +		ret = zcomp_strm_single_create(comp);
> +#else
> +	ret = zcomp_strm_single_create(comp);
> +#endif
> +	if (ret != 0) {
>  		zcomp_destroy(comp);
>  		return NULL;
>  	}
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 8dc1d7f..d7e1229 100644
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
> index 200c12a..c147e6f 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -107,6 +107,42 @@ static ssize_t mem_used_total_show(struct device *dev,
>  	return sprintf(buf, "%llu\n", val);
>  }
>  
> +static ssize_t max_comp_streams_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	long val;

Why 'long'?

> +	struct zram *zram = dev_to_zram(dev);
> +
> +	down_read(&zram->init_lock);
> +	val = zram->max_comp_streams;
> +	up_read(&zram->init_lock);
> +
> +	return sprintf(buf, "%ld\n", val);
> +}
> +
> +static ssize_t max_comp_streams_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t len)
> +{
> +#ifdef CONFIG_ZRAM_MULTI_STREAM
> +	long num;
> +	struct zram *zram = dev_to_zram(dev);
> +
> +	if (kstrtol(buf, 0, &num))
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

If user decrease max stream in runtime, who care of freeing streams?

> +#endif
> +	return len;
> +}
> +
>  /* flag operations needs meta->tb_lock */
>  static int zram_test_flag(struct zram_meta *meta, u32 index,
>  			enum zram_pageflags flag)
> @@ -503,6 +539,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  
>  	zcomp_destroy(zram->comp);
>  	zram->comp = NULL;
> +	zram->max_comp_streams = 1;
>  
>  	zram_meta_free(zram->meta);
>  	zram->meta = NULL;
> @@ -532,7 +569,7 @@ static ssize_t disksize_store(struct device *dev,
>  		return -EBUSY;
>  	}
>  
> -	zram->comp = zcomp_create(default_compressor);
> +	zram->comp = zcomp_create(default_compressor, zram->max_comp_streams);
>  	if (!zram->comp) {
>  		up_write(&zram->init_lock);
>  		pr_info("Cannot initialise compressing backend\n");
> @@ -695,6 +732,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
>  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
>  static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
>  static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
> +static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
> +		max_comp_streams_show, max_comp_streams_store);
>  
>  ZRAM_ATTR_RO(num_reads);
>  ZRAM_ATTR_RO(num_writes);
> @@ -719,6 +758,7 @@ static struct attribute *zram_disk_attrs[] = {
>  	&dev_attr_orig_data_size.attr,
>  	&dev_attr_compr_data_size.attr,
>  	&dev_attr_mem_used_total.attr,
> +	&dev_attr_max_comp_streams.attr,
>  	NULL,
>  };
>  
> @@ -782,6 +822,7 @@ static int create_device(struct zram *zram, int device_id)
>  
>  	zram->meta = NULL;
>  	zram->comp = NULL;
> +	zram->max_comp_streams = 1;
>  	return 0;
>  
>  out_free_disk:
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 45e04f7..8dccb22 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -99,7 +99,7 @@ struct zram {
>  	 * we can store in a disk.
>  	 */
>  	u64 disksize;	/* bytes */
> -
> +	long max_comp_streams;
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
