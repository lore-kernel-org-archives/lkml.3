Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBZEfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:35:31 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59046 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaBZEf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:35:26 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-68-530d6f0b5f5f
Date: Wed, 26 Feb 2014 13:35:56 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 6/7] zram: add set_max_streams knob
Message-ID: <20140226043556.GE4606@bbox>
References: <1393328073-12313-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1393328073-12313-7-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393328073-12313-7-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:34:32PM +0300, Sergey Senozhatsky wrote:
> This patch allows to change max_comp_streams on initialised zcomp.
> 
> Introduce zcomp set_max_streams() knob, zcomp_strm_multi_set_max_streams()
> and zcomp_strm_single_set_max_streams() callbacks to change streams limit
> for zcomp_strm_multi and zcomp_strm_single, accordingly. set_max_streams
> for single steam zcomp does nothing.
> 
> If user has lowered the limit, then zcomp_strm_multi_set_max_streams()
> attempts to immediately free extra streams (as much as it can, depending
> on idle streams availability).
> 
> Note, this patch does not allow to change stream 'policy' from single to
> multi stream (or vice versa) on already initialised compression backend,
> this will be introduced later.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zcomp.c    | 39 +++++++++++++++++++++++++++++++++++++++
>  drivers/block/zram/zcomp.h    |  3 +++
>  drivers/block/zram/zram_drv.c |  7 ++-----
>  3 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 1bcb70e..adfbfee 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -135,6 +135,32 @@ static void zcomp_strm_multi_put(struct zcomp *comp, struct zcomp_strm *zstrm)
>  	wake_up(&zs->strm_wait);
>  }
>  
> +/* change max_strm limit */
> +static void zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> +{
> +	struct zcomp_strm_multi *zs = comp->stream;
> +
> +	/* single stream handled as a special case by zcomp_strm_single */
> +	if (num_strm < 2)
> +		return;

I doubt it's good idea. Just leave it as you want although it makes
performance hurt because user want to get more free memory and it
doesn't make any regression for single stream side.

Additionally, if we enhance it with adaptive lock scheme,
performance problem would be gone. :)

But if you want to limit it really, at least, need to notice to
user. Maybe pr_info?

> +
> +	spin_lock(&zs->strm_lock);
> +	zs->max_strm = num_strm;
> +	/*
> +	 * if user has lowered the limit and there are idle streams,
> +	 * immediately free as much streams (and memory) as we can.
> +	 */
> +	while (atomic_read(&zs->avail_strm) > num_strm &&
> +			!list_empty(&zs->idle_strm)) {
> +		struct zcomp_strm *zstrm = list_entry(zs->idle_strm.next,
> +				struct zcomp_strm, list);
> +		list_del(&zstrm->list);
> +		zcomp_strm_free(comp, zstrm);
> +		atomic_dec(&zs->avail_strm);
> +	}
> +	spin_unlock(&zs->strm_lock);
> +}
> +
>  static void zcomp_strm_multi_destroy(struct zcomp *comp)
>  {
>  	struct zcomp_strm_multi *zs = comp->stream;
> @@ -158,6 +184,7 @@ static int zcomp_strm_multi_create(struct zcomp *comp, int num_strm)
>  	comp->destroy = zcomp_strm_multi_destroy;
>  	comp->strm_get = zcomp_strm_multi_get;
>  	comp->strm_put = zcomp_strm_multi_put;
> +	comp->set_max_streams = zcomp_strm_multi_set_max_streams;
>  	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
>  	comp->stream = zs;
>  	if (!zs)
> @@ -193,6 +220,12 @@ static void zcomp_strm_single_put(struct zcomp *comp, struct zcomp_strm *zstrm)
>  	mutex_unlock(&zs->strm_lock);
>  }
>  
> +static void zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
> +{
> +	/* zcomp_strm_single support only max_comp_streams == 1 */

I hope we should notice to user.
Maybe this function returns true or false and caller should emit some message
with pr_info?


> +	return;
> +}
> +
>  static void zcomp_strm_single_destroy(struct zcomp *comp)
>  {
>  	struct zcomp_strm_single *zs = comp->stream;
> @@ -207,6 +240,7 @@ static int zcomp_strm_single_create(struct zcomp *comp)
>  	comp->destroy = zcomp_strm_single_destroy;
>  	comp->strm_get = zcomp_strm_single_get;
>  	comp->strm_put = zcomp_strm_single_put;
> +	comp->set_max_streams = zcomp_strm_single_set_max_streams;
>  	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
>  	comp->stream = zs;
>  	if (!zs)
> @@ -221,6 +255,11 @@ static int zcomp_strm_single_create(struct zcomp *comp)
>  	return 0;
>  }
>  
> +void zcomp_set_max_streams(struct zcomp *comp, int num_strm)
> +{
> +	comp->set_max_streams(comp, num_strm);
> +}
> +
>  struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
>  {
>  	return comp->strm_get(comp);
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 5514509..9645e16 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -39,6 +39,7 @@ struct zcomp {
>  
>  	struct zcomp_strm *(*strm_get)(struct zcomp *comp);
>  	void (*strm_put)(struct zcomp *comp, struct zcomp_strm *zstrm);
> +	void (*set_max_streams)(struct zcomp *comp, int num_strm);
>  	void (*destroy)(struct zcomp *comp);
>  };
>  
> @@ -53,4 +54,6 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
>  
>  int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
>  		size_t src_len, unsigned char *dst);
> +
> +void zcomp_set_max_streams(struct zcomp *comp, int num_strm);
>  #endif /* _ZCOMP_H_ */
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 42b9c7f..34a0921 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -132,12 +132,9 @@ static ssize_t max_comp_streams_store(struct device *dev,
>  	if (num < 1)
>  		return -EINVAL;
>  	down_write(&zram->init_lock);
> -	if (init_done(zram)) {
> -		up_write(&zram->init_lock);
> -		pr_info("Can't set max_comp_streams for initialized device\n");
> -		return -EBUSY;
> -	}
>  	zram->max_comp_streams = num;
> +	if (init_done(zram))
> +		zcomp_set_max_streams(zram->comp, num);
>  	up_write(&zram->init_lock);
>  	return len;
>  }
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
