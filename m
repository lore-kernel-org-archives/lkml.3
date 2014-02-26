Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaBZEeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:34:24 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:37152 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaBZEeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:34:23 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 26 Feb 2014 13:34:53 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 3/7] zram: factor out single stream compression
Message-ID: <20140226043453.GB4606@bbox>
References: <1393328073-12313-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1393328073-12313-4-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393328073-12313-4-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

On Tue, Feb 25, 2014 at 02:34:29PM +0300, Sergey Senozhatsky wrote:
> This is preparation patch to add multi stream support to zcomp.
> 
> Introduce struct zcomp_strm_single and a set of functions to manage zcomp_strm
> stream access. zcomp_strm_single implements single compession stream, same way
> as current zcomp implementation. This moves zcomp_strm stream control and
> locking from zcomp, so compressing backend zcomp is not aware of required
> locking (single and multi streams require different locking schemes).

Please, add why we need different locking scheme in here so that
some people understand why we need this via git log in future.

> 
> The following set of functions added:
> - zcomp_strm_single_get()/zcomp_strm_single_put()
>   get and put compression stream, implement required locking
> - zcomp_strm_single_create()/zcomp_strm_single_destroy()
>   create and destroy zcomp_strm_single
> 
> New ->strm_get() and ->strm_put() callbacks added to zcomp, which are set to
> zcomp_strm_single_get() and zcomp_strm_single_put() during initialisation.
> Instead of direct locking and zcomp_strm access from zcomp_strm_get() and
> zcomp_strm_put(), zcomp now calls ->strm_get() and ->strm_put()
> correspondingly.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zcomp.c | 65 +++++++++++++++++++++++++++++++++++++++-------
>  drivers/block/zram/zcomp.h |  7 +++--
>  2 files changed, 61 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 947efe3..e20054b 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -15,6 +15,14 @@
>  
>  #include "zcomp.h"
>  
> +/*
> + * single zcomp_strm backend
> + */
> +struct zcomp_strm_single {
> +	struct mutex strm_lock;
> +	struct zcomp_strm *zstrm;
> +};
> +
>  extern struct zcomp_backend zcomp_lzo;
>  
>  static struct zcomp_backend *find_backend(const char *compress)
> @@ -55,17 +63,58 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
>  	return zstrm;
>  }
>  
> +static struct zcomp_strm *zcomp_strm_single_get(struct zcomp *comp)
> +{
> +	struct zcomp_strm_single *zs = comp->stream;
> +	mutex_lock(&zs->strm_lock);
> +	return zs->zstrm;
> +}
> +
> +static void zcomp_strm_single_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> +{
> +	struct zcomp_strm_single *zs = comp->stream;
> +	mutex_unlock(&zs->strm_lock);
> +}
> +
> +static void zcomp_strm_single_destroy(struct zcomp *comp)
> +{
> +	struct zcomp_strm_single *zs = comp->stream;
> +	zcomp_strm_free(comp, zs->zstrm);
> +	kfree(zs);
> +}
> +
> +static int zcomp_strm_single_create(struct zcomp *comp)
> +{
> +	struct zcomp_strm_single *zs;
> +
> +	comp->destroy = zcomp_strm_single_destroy;
> +	comp->strm_get = zcomp_strm_single_get;
> +	comp->strm_put = zcomp_strm_single_put;
> +	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
> +	comp->stream = zs;
> +	if (!zs)
> +		return -ENOMEM;

Firstly check zs nullness and then assign zs to the comp->stream.
Yeb. your code doesn't have any problem but let's follow normal
convention.

> +
> +	mutex_init(&zs->strm_lock);
> +	zs->zstrm = zcomp_strm_alloc(comp);
> +	if (!zs->zstrm) {
> +		zcomp_strm_single_destroy(comp);

Let's just call kfree in here instead of xxx_destroy.
such pair function call is more clear to me rather than using wrapping
function.


> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
>  struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
>  {
> -	mutex_lock(&comp->strm_lock);
> -	return comp->zstrm;
> +	return comp->strm_get(comp);
>  }
>  
>  void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
>  {
> -	mutex_unlock(&comp->strm_lock);
> +	comp->strm_put(comp, zstrm);
>  }
>  
> +/* compress page */

Function name is clear so I think we don't need a comment.
If we need such comment, it should introduce previous patches, not this one.

>  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
>  		const unsigned char *src, size_t *dst_len)
>  {
> @@ -73,6 +122,7 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
>  			zstrm->private);
>  }
>  
> +/* decompress page */
>  int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
>  		size_t src_len, unsigned char *dst)
>  {
> @@ -81,7 +131,7 @@ int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
>  
>  void zcomp_destroy(struct zcomp *comp)
>  {
> -	zcomp_strm_free(comp, comp->zstrm);
> +	comp->destroy(comp);
>  	kfree(comp);
>  }
>  
> @@ -105,11 +155,8 @@ struct zcomp *zcomp_create(const char *compress)
>  		return NULL;
>  
>  	comp->backend = backend;
> -	mutex_init(&comp->strm_lock);
> -
> -	comp->zstrm = zcomp_strm_alloc(comp);
> -	if (!comp->zstrm) {
> -		kfree(comp);
> +	if (zcomp_strm_single_create(comp) != 0) {
> +		zcomp_destroy(comp);

Let's use just kfree.
If zcomp_strm_single_create fails, it should tidy up all memory
allocated by itself so caller should just free thing allocate by
itself.

>  		return NULL;
>  	}
>  	return comp;
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 5106f8e..861e04d 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -34,9 +34,12 @@ struct zcomp_backend {
>  
>  /* dynamic per-device compression frontend */
>  struct zcomp {
> -	struct mutex strm_lock;
> -	struct zcomp_strm *zstrm;
> +	void *stream;
>  	struct zcomp_backend *backend;
> +
> +	struct zcomp_strm *(*strm_get)(struct zcomp *comp);
> +	void (*strm_put)(struct zcomp *comp, struct zcomp_strm *zstrm);
> +	void (*destroy)(struct zcomp *comp);
>  };
>  
>  struct zcomp *zcomp_create(const char *comp);
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
