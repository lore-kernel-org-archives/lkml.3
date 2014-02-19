Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaBSGPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:15:20 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53702 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaBSGPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:15:18 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-c2-53044bf373ac
Date: Wed, 19 Feb 2014 15:15:22 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 0/4] add compressing abstraction and multi stream
 support
Message-ID: <20140219061522.GC1129@bbox>
References: <1392313402-5728-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20140218060425.GA26133@bbox>
 <20140218193818.GA2182@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218193818.GA2182@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:38:18PM +0300, Sergey Senozhatsky wrote:
> On (02/18/14 15:04), Minchan Kim wrote:
> [..]
> > 1.8.5.3
> > 
> > As you can see, your patch made zram too much regressed when it
> > used one stream buffer. The reason I guessed is overhead of
> > scheduling by sleep/wakeup when others couldn't find a idle stream
> > so I had an experiment with below simple patch to restore old behavior
> > so it works well again. The reason old behaivor was really good is
> > it uses mutex with spin_on_owner so that it could avoid frequent
> > sleep/wakeup.
> > 
> > A solution I could think is that we could grow up the number of
> > buffer dynamically up to max_buffers(ex, 2 * number of CPU) so we
> > could grab a idle stream easily for each CPU while we could release
> > buffers by shrinker when the memory pressure is severe.
> > Of course, we should keep one buffer to work.
> > 
> > Another solution I can imagaine is to define CONFIG_ZRAM_MULTI_STREAM
> > and CONFIG_ZRAM_SINGLE_STREAM(ie, default) so we couldn't break good
> > performance for old cases and new users who want write parallel
> > could use ZRAM_MULTI which should be several streams at a default
> > rather than a stream. And we could ehhacne it further by dynamic control
> > as I mentioned.
> > 
> > Thoughts?
> >
> 
> like the following one (this patch limits the number of streams to
> num_online_cpus(). I really don't mind to limit zstrm to
> N * num_online_cpus() where N could be 2)
> 
> 	iozone -t 3 -R -r 16K -s 60M -I +Z
> 
> write test:
> (old core i5 laptop, 2 cpus + 2 HyperThreading)
> 
>                        base            multi buffer
> 
> "  Initial write "   574938.14           716623.64
> "        Rewrite "   573541.22          1499074.62
> "   Random write "   587016.14          1393996.66
> "         Pwrite "   595616.45           711028.70
> "         Fwrite "  1482843.62          1493398.12
> 

I guess you tested it for zram-block, not zram-swap.
If we use it as zram-swap and happens parallel swapout,
write performance would be dropped due to frequent sleep/wakeup.

> 
> zcomp_strm_get() and zcomp_strm_put() were updated.
> zcomp keeps the number allocated and still active (not freed)
> streams (atomic_t). zcomp performs zstrm free() only if
> current number of streams exceeds the number of online
> cpus (cpu went offline).
> 
> 
> not a properly `aligned' patch, just to demonstrate the idea.
> 
> thoughts?
> 
> thanks.
> 
> ---
> 
> >From 0e16f26480933d22339675ca938049dfb21557e2 Mon Sep 17 00:00:00 2001
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date: Tue, 11 Feb 2014 00:28:46 +0300
> Subject: [PATCH] zram: multi stream compressing backend abstraction
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zcomp.c     | 174 +++++++++++++++++++++++++++++++++++++++++
>  drivers/block/zram/zcomp.h     |  58 ++++++++++++++
>  drivers/block/zram/zcomp_lzo.c |  48 ++++++++++++
>  3 files changed, 280 insertions(+)
>  create mode 100644 drivers/block/zram/zcomp.c
>  create mode 100644 drivers/block/zram/zcomp.h
>  create mode 100644 drivers/block/zram/zcomp_lzo.c
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> new file mode 100644
> index 0000000..6bf49fc
> --- /dev/null
> +++ b/drivers/block/zram/zcomp.c
> @@ -0,0 +1,174 @@
> +/*
> + * Copyright (C) 2014 Sergey Senozhatsky.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/wait.h>
> +#include <linux/sched.h>
> +
> +#include "zcomp.h"
> +
> +extern struct zcomp_backend zcomp_lzo;
> +
> +static struct zcomp_backend *find_backend(const char *compress)
> +{
> +	if (strncmp(compress, "lzo", 3) == 0)
> +		return &zcomp_lzo;
> +	return NULL;
> +}
> +
> +static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
> +{
> +	if (zstrm->private)
> +		comp->backend->destroy(zstrm->private);
> +	free_pages((unsigned long)zstrm->buffer, 1);
> +	kfree(zstrm);
> +}
> +
> +/*
> + * allocate new zcomp_strm structure with ->private initialized by
> + * backend, return NULL on error
> + */
> +static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
> +{
> +	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_KERNEL);
> +	if (!zstrm)
> +		return NULL;
> +
> +	zstrm->private = comp->backend->create();
> +	/*
> +	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
> +	 * case when compressed size is larger than the original one
> +	 */
> +	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
> +	if (!zstrm->private || !zstrm->buffer) {
> +		zcomp_strm_free(comp, zstrm);
> +		zstrm = NULL;
> +	}
> +	return zstrm;
> +}
> +
> +/*
> + * get available idle stream or allocate a new one
> + */
> +struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
> +{
> +	struct zcomp_strm *zstrm;
> +
> +	while (1) {
> +		spin_lock(&comp->strm_lock);
> +		if (!list_empty(&comp->idle_strm)) {
> +			zstrm = list_entry(comp->idle_strm.next,
> +					struct zcomp_strm, list);
> +			list_del(&zstrm->list);
> +			spin_unlock(&comp->strm_lock);
> +			return zstrm;
> +		}
> +
> +		if (atomic_read(&comp->num_strm) >= num_online_cpus()) {
> +			spin_unlock(&comp->strm_lock);
> +			wait_event(comp->strm_wait,
> +					!list_empty(&comp->idle_strm));
> +			continue;
> +		}
> +
> +		atomic_inc(&comp->num_strm);
> +		spin_unlock(&comp->strm_lock);
> +
> +		zstrm = zcomp_strm_alloc(comp);
> +		if (!zstrm) {
> +			atomic_dec(&comp->num_strm);
> +			wait_event(comp->strm_wait,
> +					!list_empty(&comp->idle_strm));
> +			continue;
> +		}
> +		break;
> +	}
> +	return zstrm;
> +}
> +
> +/*
> + * put zstrm back to idle list and wake up waiters or free it if
> + * current number of streams is above the limit
> + */
> +void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> +{
> +	spin_lock(&comp->strm_lock);
> +	if (atomic_read(&comp->num_strm) <= num_online_cpus()) {
> +		list_add(&zstrm->list, &comp->idle_strm);
> +		spin_unlock(&comp->strm_lock);
> +	} else {
> +		atomic_dec(&comp->num_strm);
> +		spin_unlock(&comp->strm_lock);
> +		zcomp_strm_free(comp, zstrm);
> +	}
> +
> +	wake_up(&comp->strm_wait);
> +}
> +
> +int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +		const unsigned char *src, size_t *dst_len)
> +{
> +	return comp->backend->compress(src, zstrm->buffer, dst_len,
> +			zstrm->private);
> +}
> +
> +int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> +		size_t src_len, unsigned char *dst)
> +{
> +	return comp->backend->decompress(src, src_len, dst);
> +}
> +
> +void zcomp_destroy(struct zcomp *comp)
> +{
> +	struct zcomp_strm *zstrm;
> +	while (!list_empty(&comp->idle_strm)) {
> +		zstrm = list_entry(comp->idle_strm.next,
> +				struct zcomp_strm, list);
> +		list_del(&zstrm->list);
> +		zcomp_strm_free(comp, zstrm);
> +	}
> +	kfree(comp);
> +}
> +
> +/*
> + * search available compressors for requested algorithm.
> + * allocate new zcomp and initialize it. return NULL
> + * if requested algorithm is not supported or in case
> + * of init error
> + */
> +struct zcomp *zcomp_create(const char *compress)
> +{
> +	struct zcomp *comp;
> +	struct zcomp_backend *backend;
> +	struct zcomp_strm *zstrm;
> +
> +	backend = find_backend(compress);
> +	if (!backend)
> +		return NULL;
> +
> +	comp = kmalloc(sizeof(struct zcomp), GFP_KERNEL);
> +	if (!comp)
> +		return NULL;
> +
> +	comp->backend = backend;
> +	spin_lock_init(&comp->strm_lock);
> +	INIT_LIST_HEAD(&comp->idle_strm);
> +	init_waitqueue_head(&comp->strm_wait);
> +	atomic_set(&comp->num_strm, 1);
> +
> +	zstrm = zcomp_strm_alloc(comp);
> +	if (!zstrm) {
> +		zcomp_destroy(comp);
> +		return NULL;
> +	}
> +	list_add(&zstrm->list, &comp->idle_strm);
> +	return comp;
> +}
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> new file mode 100644
> index 0000000..fd3871d
> --- /dev/null
> +++ b/drivers/block/zram/zcomp.h
> @@ -0,0 +1,58 @@
> +/*
> + * Copyright (C) 2014 Sergey Senozhatsky.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifndef _ZCOMP_H_
> +#define _ZCOMP_H_
> +
> +#include <linux/spinlock.h>
> +
> +struct zcomp_strm {
> +	void *buffer;     /* compression/decompression buffer */
> +	void *private;
> +	struct list_head list;
> +};
> +
> +/* static compression backend */
> +struct zcomp_backend {
> +	int (*compress)(const unsigned char *src, unsigned char *dst,
> +			size_t *dst_len, void *private);
> +
> +	int (*decompress)(const unsigned char *src, size_t src_len,
> +			unsigned char *dst);
> +
> +	void * (*create)(void);
> +	void (*destroy)(void *private);
> +
> +	const char *name;
> +};
> +
> +/* dynamic per-device compression frontend */
> +struct zcomp {
> +	/* protect strm list */
> +	spinlock_t strm_lock;
> +	/* list of available strms */
> +	struct list_head idle_strm;
> +	wait_queue_head_t strm_wait;
> +	/* number of allocated strms */
> +	atomic_t num_strm;
> +	struct zcomp_backend *backend;
> +};
> +
> +struct zcomp *zcomp_create(const char *comp);
> +void zcomp_destroy(struct zcomp *comp);
> +
> +struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
> +void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm);
> +
> +int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +		const unsigned char *src, size_t *dst_len);
> +
> +int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> +		size_t src_len, unsigned char *dst);
> +#endif /* _ZCOMP_H_ */
> diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
> new file mode 100644
> index 0000000..b7722a2
> --- /dev/null
> +++ b/drivers/block/zram/zcomp_lzo.c
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (C) 2014 Sergey Senozhatsky.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/lzo.h>
> +
> +#include "zcomp.h"
> +
> +static void *lzo_create(void)
> +{
> +	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> +}
> +
> +static void lzo_destroy(void *private)
> +{
> +	kfree(private);
> +}
> +
> +static int lzo_compress(const unsigned char *src, unsigned char *dst,
> +		size_t *dst_len, void *private)
> +{
> +	int ret = lzo1x_1_compress(src, PAGE_SIZE, dst, dst_len, private);
> +	return ret == LZO_E_OK ? 0 : ret;
> +}
> +
> +static int lzo_decompress(const unsigned char *src, size_t src_len,
> +		unsigned char *dst)
> +{
> +	size_t dst_len = PAGE_SIZE;
> +	int ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
> +	return ret == LZO_E_OK ? 0 : ret;
> +}
> +
> +extern struct zcomp_backend zcomp_lzo;
> +struct zcomp_backend zcomp_lzo = {
> +	.compress = lzo_compress,
> +	.decompress = lzo_decompress,
> +	.create = lzo_create,
> +	.destroy = lzo_destroy,
> +	.name = "lzo",
> +};
> -- 
> 1.9.0.279.gdc9e3eb
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
