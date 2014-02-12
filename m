Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaBLHIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:08:35 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64624 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBLHId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:08:33 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-f8-52fb1df01313
Date: Wed, 12 Feb 2014 16:08:32 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/4] zram: introduce compressing backend abstraction
Message-ID: <20140212070832.GC19818@bbox>
References: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392157266-13488-2-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392157266-13488-2-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:21:03AM +0300, Sergey Senozhatsky wrote:
> ZRAM performs direct LZO compression algorithm calls, making it the one
> and only option. Introduce abstract struct zram_comp in order to support
> multiple compression algorithms. struct zram_comp defines the following
> set of compressing backend operations:
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
> because, otherwise, concurrent write() can overwrite data. At the same
> time, zram_meta must be aware of a) specific compression algorithm
> memory requirements and b) necessary locking to protect compression
> buffers. Besides, zram holds buffer_lock almost through the whole write()
> function, making parallel compression impossible. To remove requirement
> a) new struct zcomp_workmem introduced, which contain buffers required by
> compression algorithm. While struct zram_comp implements workmem handling
> and locking by means of get() and put() semantics and removes requirement
> b) from zram meta. zram_comp ->create() and ->destroy(), respectively,
> allocate and deallocate algorithm specific zcomp_workmem `private' buffer.
> 
> Every zram_comp has a list of idle workmem buffers (at least 1 workmem),
> spinlock to protect idle list and wait queue, making it possible to perform
> parallel compressions. Each time zram issues a zcomp_workmem_get() call, the
> following set of operations performed:
> - spin lock buffer_lock
> - if idle list is not empty, remove workmem from idle list, spin
>   unlock and return workmem pointer
> - if idle list is empty, current adds itself to wait queue. it will be
>   awaken by zcomp_workmem_put() caller.
> 
> zcomp_workmem_put():
> - spin lock buffer_lock
> - add workmem to idle list
> - spin unlock, wake up sleeper (if any)
> 
> In other words, zcomp_workmem_get() turns caller into exclusive user of workmem
> and zcomp_workem_put() makes a particular workmem available.
> 
> Usage examples.
> 
> To initialize compressing backend:
> 	comp = zcomp_create(NAME) /* NAME e.g. lzo */
> 
> which initialises compressing backend if requested algorithm is supported.
> 
> Compress:
> 	wm = zcomp_workmem_get(comp)
> 	zcomp_compress(comp, wm, src, src_len, &dst_len)
> 	[..] /* copy compressed data */
> 	zcomp_workmem_put(comp, wm)
> 
> Decompress:
> 	zcomp_decompress(comp, src, src_len, dst, &dst_len);
> 
> Free compessing backend and its workmem:
> 	zcomp_destroy(comp)
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zcomp_lzo.c |  33 +++++++++
>  drivers/block/zram/zram_comp.c | 147 +++++++++++++++++++++++++++++++++++++++++
>  drivers/block/zram/zram_comp.h |  58 ++++++++++++++++
>  3 files changed, 238 insertions(+)
>  create mode 100644 drivers/block/zram/zcomp_lzo.c
>  create mode 100644 drivers/block/zram/zram_comp.c
>  create mode 100644 drivers/block/zram/zram_comp.h
> 
> diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
> new file mode 100644
> index 0000000..bbde74e
> --- /dev/null
> +++ b/drivers/block/zram/zcomp_lzo.c
> @@ -0,0 +1,33 @@
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
> +#include "zram_comp.h"
> +
> +static void * lzo_create(void)
> +{
> +	return kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> +}
> +
> +static void lzo_destroy(void *workmem)
> +{
> +	kfree(workmem);
> +}
> +
> +extern struct zram_comp_backend zcomp_lzo;
> +struct zram_comp_backend zcomp_lzo = {
> +	.compress = lzo1x_1_compress,
> +	.decompress = lzo1x_decompress_safe,
> +	.create = lzo_create,
> +	.destroy = lzo_destroy,
> +	.name = "lzo",
> +};
> diff --git a/drivers/block/zram/zram_comp.c b/drivers/block/zram/zram_comp.c
> new file mode 100644
> index 0000000..139a468
> --- /dev/null
> +++ b/drivers/block/zram/zram_comp.c
> @@ -0,0 +1,147 @@
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
> +#include <linux/vmalloc.h>
> +#include <linux/wait.h>
> +#include <linux/sched.h>
> +
> +#include "zram_comp.h"
> +
> +extern struct zram_comp_backend zcomp_lzo;
> +
> +static void workmem_free(struct zram_comp *comp, struct zcomp_workmem *workmem)
> +{
> +	comp->backend->destroy(workmem->private);
> +	free_pages((unsigned long)workmem->buffer, 1);
> +	kfree(workmem);
> +}
> +
> +/* allocate new workmem structure with ->mem of requested size,
> + * return NULL on error */
> +static struct zcomp_workmem *workmem_alloc(struct zram_comp *comp)
> +{
> +	struct zcomp_workmem *workmem = kmalloc(sizeof(*workmem), GFP_NOFS);


One more thing, pz, say why we need GFP_NOFS in here.

-- 
Kind regards,
Minchan Kim
