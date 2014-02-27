Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaB0XSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:18:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaB0XSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:18:50 -0500
Date: Thu, 27 Feb 2014 15:18:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 1/6] zram: introduce compressing backend abstraction
Message-Id: <20140227151848.e2e0b136757414d0f87e7d8b@linux-foundation.org>
In-Reply-To: <1393417679-13657-2-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
	<1393417679-13657-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 15:27:54 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> ZRAM performs direct LZO compression algorithm calls, making it the one and
> only option. Introduce compressing backend abstraction zcomp in order to
> support multiple compression algorithms with the following set of operations:

Well...  why?  Presumably because other compression schemes have
compelling advantages over LZO, otherwise there's no point in the
patch!

Please describe this in some detail, so that others can judge the
desirability of the patch.

>         .create
>         .destroy
>         .compress
>         .decompress
> 
> Schematically zram write() usually contains the following steps:
> 0) preparation (decompression of partioal IO, etc.)
> 1) lock buffer_lock mutex (protects meta compress buffers)
> 2) compress (using meta compress buffers)
> 3) alloc and map zs_pool object
> 4) copy compressed data (from meta compress buffers) to object allocated by 3)
> 5) free previous pool page, assign a new one
> 6) unlock buffer_lock mutex
> 
> As we can see, compressing buffers must remain untouched from 1) to 4),
> because, otherwise, concurrent write() can overwrite data. At the same time,
> zram_meta must be aware of a) specific compression algorithm memory requirements
> and b) necessary locking to protect compression buffers. To remove requirement
> a) new struct zcomp_strm introduced, which contains a compress/decompress
> `buffer' and compression algorithm `private' part. While struct zcomp implements
> zcomp_strm stream handling and locking by means of get() and put() semantics and
> removes requirement b) from zram meta. zcomp ->create() and ->destroy(),
> respectively, allocate and deallocate algorithm specific zcomp_strm `private'
> part.
> 
> Every zcomp has zcomp stream and mutex to protect its compression stream. Stream
> usage semantics remains the same -- only one write can hold stream lock and use
> its buffers. zcomp_strm_get() turns caller into exclusive user of a stream
> (holding stream mutex until zram put stream), and zcomp_strm_put() makes zcomp
> stream available (unlock the stream mutex). Hence no concurrent write
> (compression) operations possible at the moment.
> 
> iozone -t 3 -R -r 16K -s 60M -I +Z
> 
>        test            base           patched
> --------------------------------------------------
>   Initial write      597992.91       591660.58
>         Rewrite      609674.34       616054.97
>            Read     2404771.75      2452909.12
>         Re-read     2459216.81      2470074.44
>    Reverse Read     1652769.66      1589128.66
>     Stride read     2202441.81      2202173.31
>     Random read     2236311.47      2276565.31
>  Mixed workload     1423760.41      1709760.06
>    Random write      579584.08       615933.86
>          Pwrite      597550.02       594933.70
>           Pread     1703672.53      1718126.72
>          Fwrite     1330497.06      1461054.00
>           Fread     3922851.00      3957242.62
> 
> Usage examples:
> 
> 	comp = zcomp_create(NAME) /* NAME e.g. "lzo" */
> 
> which initialises compressing backend if requested algorithm is supported.
> 
> Compress:
> 	zstrm = zcomp_strm_get(comp)
> 	zcomp_compress(comp, zstrm, src, &dst_len)
> 	[..] /* copy compressed data */
> 	zcomp_strm_put(comp, zstrm)
> 
> Decompress:
> 	zcomp_decompress(comp, src, src_len, dst);
> 
> Free compessing backend and its zcomp stream:
> 	zcomp_destroy(comp)
> 
> ...
>
> --- /dev/null
> +++ b/drivers/block/zram/zcomp.c
> @@ -0,0 +1,116 @@
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

This should be in a header file please.  So we know that the definition
site and all users agree on the type.

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
> +struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
> +{
> +	mutex_lock(&comp->strm_lock);
> +	return comp->zstrm;
> +}
> +
> +void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> +{
> +	mutex_unlock(&comp->strm_lock);
> +}

These are poorly named.  When we see "get" and "put" we expect that
they will increment-refcount and decrement-refcount-free-on-zero.  But
these function do not implement such a pattern.

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
> +	zcomp_strm_free(comp, comp->zstrm);
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
> +
> +	backend = find_backend(compress);
> +	if (!backend)
> +		return NULL;
> +
> +	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
> +	if (!comp)
> +		return NULL;
> +
> +	comp->backend = backend;
> +	mutex_init(&comp->strm_lock);
> +
> +	comp->zstrm = zcomp_strm_alloc(comp);
> +	if (!comp->zstrm) {
> +		kfree(comp);
> +		return NULL;
> +	}
> +	return comp;
> +}
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> new file mode 100644
> index 0000000..5106f8e
> --- /dev/null
> +++ b/drivers/block/zram/zcomp.h
> @@ -0,0 +1,53 @@
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
> +#include <linux/mutex.h>
> +
> +struct zcomp_strm {
> +	void *buffer;     /* compression/decompression buffer */
> +	void *private;

Document this?

> +	struct list_head list;

What does this do and what lock protects it?

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
> +	void *(*create)(void);
> +	void (*destroy)(void *private);
> +
> +	const char *name;
> +};
> +
> +/* dynamic per-device compression frontend */
> +struct zcomp {
> +	struct mutex strm_lock;
> +	struct zcomp_strm *zstrm;
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

This is unneeded, should be in the header file.

> +struct zcomp_backend zcomp_lzo = {
> +	.compress = lzo_compress,
> +	.decompress = lzo_decompress,
> +	.create = lzo_create,
> +	.destroy = lzo_destroy,
> +	.name = "lzo",
> +};

