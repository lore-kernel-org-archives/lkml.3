Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaBMR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:56:16 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62371 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaBMR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:56:15 -0500
Date: Thu, 13 Feb 2014 20:52:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/4] zram: introduce compressing backend abstraction
Message-ID: <20140213175251.GA2247@swordfish>
References: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392233976-26473-3-git-send-email-sergey.senozhatsky@gmail.com>
 <20140213045329.GE26658@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213045329.GE26658@bbox>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Minchan,

thank you for review.

On (02/13/14 13:53), Minchan Kim wrote:
> 
> Hello Sergey,
> 
[..]
> > +			struct zcomp_strm, list);
> > +	list_del(&zstrm->list);
> > +	spin_unlock(&comp->buffer_lock);
> > +	return zstrm;
> > +}
> > +
> > +/* add zcomp_strm back to idle list and wake up waiter (if any) */
> > +void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> > +{
> > +	spin_lock(&comp->buffer_lock);
> > +	list_add_tail(&zstrm->list, &comp->idle_strm);
> 
> What I said "queue" in previous review is that I thougt stack might
> be more cache-freindly than queue so list_add is proper than list_add_tail.
> But it seems you have a reason to list_add_tail. If so, could you explain
> what you expect?

sure, 100% my mistake. agreed, using the most recently used zstrm is the
right thing to do. I was not attentive, sorry.

> > +	spin_unlock(&comp->buffer_lock);
> > +
> > +	wake_up(&comp->strm_wait);
> > +}
> > +
> > +int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > +		const unsigned char *src, size_t src_len, size_t *dst_len)
> > +{
> > +	return comp->backend->compress(src, src_len, zstrm->buffer,
> > +			dst_len, zstrm->private);
> > +}
> 
> We need src_len? it's always PAGE_SIZE.
> 
> > +
> > +int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> > +		size_t src_len, unsigned char *dst, size_t *dst_len)
> > +{
> > +	return comp->backend->decompress(src, src_len, dst, dst_len);
> 
> We need dst_len? It's always PAGE_SIZE, too.
> 

the only reason why I left src_len is partial IO, where
`bv_len (src_len) != PAGE_SIZE'. no reason to keep dst_len.



I've addressed your concerns and notes from this email, emails
"zram: document max_comp_streams" and "zram: use zcomp compressing backends"
in PATCH v5.

thank you once again.

	-ss

> > +}
> > +
> > +/* free allocated zcomp_strm buffers and zcomp */
> > +void zcomp_destroy(struct zcomp *comp)
> > +{
> > +	struct zcomp_strm *zstrm;
> > +	while (!list_empty(&comp->idle_strm)) {
> > +		zstrm = list_entry(comp->idle_strm.next,
> > +				struct zcomp_strm, list);
> > +		list_del(&zstrm->list);
> > +		zcomp_strm_free(comp, zstrm);
> > +	}
> > +	kfree(comp);
> > +}
> > +
> > +static struct zcomp_backend *find_backend(const char *compress)
> > +{
> > +	if (sysfs_streq(compress, "lzo"))
> > +		return &zcomp_lzo;
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * search available compressors for requested algorithm.
> > + * allocate new zcomp and initialize it. return NULL
> > + * if requested algorithm is not supported or in case
> > + * of init error
> > + */
> > +struct zcomp *zcomp_create(const char *compress)
> > +{
> > +	struct zcomp *comp;
> > +	struct zcomp_backend *backend;
> > +	struct zcomp_strm *zstrm;
> > +
> > +	backend = find_backend(compress);
> > +	if (!backend)
> > +		return NULL;
> > +
> > +	comp = kmalloc(sizeof(struct zcomp), GFP_KERNEL);
> > +	if (!comp)
> > +		return NULL;
> > +
> > +	comp->backend = backend;
> > +	spin_lock_init(&comp->buffer_lock);
> > +	INIT_LIST_HEAD(&comp->idle_strm);
> > +	init_waitqueue_head(&comp->strm_wait);
> > +
> > +	zstrm = zcomp_strm_alloc(comp);
> > +	if (!zstrm) {
> > +		zcomp_destroy(comp);
> > +		return NULL;
> > +	}
> > +	list_add_tail(&zstrm->list, &comp->idle_strm);
> 
> It's first adding to empty list so there is no difference
> between list_add and list_add_tail then, let's use list_add.
> 
> > +	return comp;
> > +}
> > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > new file mode 100644
> > index 0000000..213e503
> > --- /dev/null
> > +++ b/drivers/block/zram/zcomp.h
> > @@ -0,0 +1,57 @@
> > +/*
> > + * Copyright (C) 2014 Sergey Senozhatsky.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + */
> > +
> > +#ifndef _ZCOMP_H_
> > +#define _ZCOMP_H_
> > +
> > +#include <linux/types.h>
> > +#include <linux/spinlock.h>
> > +
> > +struct zcomp_strm {
> > +	void *buffer;     /* compression/decompression buffer */
> > +	void *private;      /* algorithm workmem */
> 
> Remove workmem.
> 
> > +	struct list_head list;
> > +};
> > +
> > +/* static compression backend */
> > +struct zcomp_backend {
> > +	int (*compress)(const unsigned char *src, size_t src_len,
> > +			unsigned char *dst, size_t *dst_len, void *wrkmem);
> 
> Rename wrkmem.
> 
> > +
> > +	int (*decompress)(const unsigned char *src, size_t src_len,
> > +			unsigned char *dst, size_t *dst_len);
> > +
> > +	void * (*create)(void);
> > +	void (*destroy)(void *private);
> > +
> > +	const char *name;
> > +};
> > +
> > +/* dynamic per-device compression frontend */
> > +struct zcomp {
> > +	/* protect strm list */
> > +	spinlock_t buffer_lock;
> 
> Pz, rename.
> 
> > +	/* list of available strms */
> > +	struct list_head idle_strm;
> > +	wait_queue_head_t strm_wait;
> > +	struct zcomp_backend *backend;
> > +};
> > +
> > +struct zcomp *zcomp_create(const char *comp);
> > +void zcomp_destroy(struct zcomp *comp);
> > +
> > +struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
> > +void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zsrtm);
>                                                               zstrm
> > +
> > +int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > +		const unsigned char *src, size_t src_len, size_t *dst_len);
> > +
> > +int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> > +		size_t src_len, unsigned char *dst, size_t *dst_len);
> > +#endif /* _ZCOMP_H_ */
> > diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
> > new file mode 100644
> > index 0000000..2b23771
> > --- /dev/null
> > +++ b/drivers/block/zram/zcomp_lzo.c
> > @@ -0,0 +1,33 @@
> > +/*
> > + * Copyright (C) 2014 Sergey Senozhatsky.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +#include <linux/lzo.h>
> > +
> > +#include "zcomp.h"
> > +
> > +static void * lzo_create(void)
> > +{
> > +	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> > +}
> > +
> > +static void lzo_destroy(void *private)
> > +{
> > +	kfree(private);
> > +}
> > +
> > +extern struct zcomp_backend zcomp_lzo;
> > +struct zcomp_backend zcomp_lzo = {
> > +	.compress = lzo1x_1_compress,
> > +	.decompress = lzo1x_decompress_safe,
> > +	.create = lzo_create,
> > +	.destroy = lzo_destroy,
> > +	.name = "lzo",
> > +};
> > -- 
> > 1.9.0.rc3.256.g4af3ebd
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Kind regards,
> Minchan Kim
> 
