Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3KHCmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:42:09 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48378 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3KHCmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:42:06 -0500
X-AuditID: 9c93017e-b7c9fae00000057d-47-527c4f7bb67e
Date: Fri, 8 Nov 2013 11:42:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] Squashfs: add multi-threaded decompression using
 percpu variables
Message-ID: <20131108024210.GB21064@bbox>
References: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk>
 <1383855865-4683-4-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383855865-4683-4-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Phillip,

On Thu, Nov 07, 2013 at 08:24:22PM +0000, Phillip Lougher wrote:
> Add a multi-threaded decompression implementation which uses
> percpu variables.
> 
> Using percpu variables has advantages and disadvantages over
> implementations which do not use percpu variables.
> 
> Advantages: the nature of percpu variables ensures decompression is
> load-balanced across the multiple cores.
> 
> Disadvantages: it limits decompression to one thread per core.

At a glance, I understand your concern but I don't see benefit to
make this feature as separate new config because we can modify the
number of decompressor per core in the future.
I don't want to create new config SQUASHFS_DECOMP_MULTI_3,
SQUASHFS_DECOMP_MULTI_4 and so on. :)

How about this?

1. Let's make CONFIG_DECOMPRESSOR_MAX which could be tuned by admin
   in Kconfig. default is CPU *2 or CPU, Otherwise, we can put it
   to sysfs so user can tune it in rumtime.

2. put decompressor shrink logic by slab shrinker so if system has
   memory pressure, we could catch the event and free some of decompressor
   but memory pressure is not severe again in the future, we can create
   new decompressor until reaching threadhold user define.
   We could know system memory is enough by GFP_NOWAIT, not GFP_KERNEL
   in get_decomp_stream's allocation indirectly.

In short, let's make decompressor_multi as dynamically tuned system
and user can limit the max.


> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
> ---
>  fs/squashfs/Kconfig                     |   57 +++++++++++++----
>  fs/squashfs/Makefile                    |   10 +--
>  fs/squashfs/decompressor_multi_percpu.c |  105 +++++++++++++++++++++++++++++++
>  3 files changed, 152 insertions(+), 20 deletions(-)
>  create mode 100644 fs/squashfs/decompressor_multi_percpu.c
> 
> diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
> index 1c6d340..c92c75f 100644
> --- a/fs/squashfs/Kconfig
> +++ b/fs/squashfs/Kconfig
> @@ -25,6 +25,50 @@ config SQUASHFS
>  
>  	  If unsure, say N.
>  
> +choice
> +	prompt "Decompressor parallelisation options"
> +	depends on SQUASHFS
> +	help
> +	  Squashfs now supports three parallelisation options for
> +	  decompression.  Each one exhibits various trade-offs between
> +	  decompression performance and CPU and memory usage.
> +
> +	  If in doubt, select "Single threaded compression"
> +
> +config SQUASHFS_DECOMP_SINGLE
> +	bool "Single threaded compression"
> +	help
> +	  Traditionally Squashfs has used single-threaded decompression.
> +	  Only one block (data or metadata) can be decompressed at any
> +	  one time.  This limits CPU and memory usage to a minimum.
> +
> +config SQUASHFS_DECOMP_MULTI
> +	bool "Use multiple decompressors for parallel I/O"
> +	help
> +	  By default Squashfs uses a single decompressor but it gives
> +	  poor performance on parallel I/O workloads when using multiple CPU
> +	  machines due to waiting on decompressor availability.
> +
> +	  If you have a parallel I/O workload and your system has enough memory,
> +	  using this option may improve overall I/O performance.
> +
> +	  This decompressor implementation uses up to two parallel
> +	  decompressors per core.  It dynamically allocates decompressors
> +	  on a demand basis.

I'm not sure it's good idea to write how many of parallel decompressor
per core. IMO, It's implementation stuff and user don't need to know internal.
And we could modify it in the future.

> +
> +config SQUASHFS_DECOMP_MULTI_PERCPU
> +       bool "Use percpu multiple decompressors for parallel I/O"
> +	help

Indentation.

> +	  By default Squashfs uses a single decompressor but it gives
> +	  poor performance on parallel I/O workloads when using multiple CPU
> +	  machines due to waiting on decompressor availability.
> +
> +	  This decompressor implementation uses a maximum of one
> +	  decompressor per core.  It uses percpu variables to ensure
> +	  decompression is load-balanced across the cores.
> +
> +endchoice
> +
>  config SQUASHFS_XATTR
>  	bool "Squashfs XATTR support"
>  	depends on SQUASHFS
> @@ -63,19 +107,6 @@ config SQUASHFS_LZO
>  
>  	  If unsure, say N.
>  
> -config SQUASHFS_MULTI_DECOMPRESSOR
> -	bool "Use multiple decompressors for handling parallel I/O"
> -	depends on SQUASHFS
> -	help
> -	  By default Squashfs uses a single decompressor but it gives
> -	  poor performance on parallel I/O workloads when using multiple CPU
> -	  machines due to waiting on decompressor availability.
> -
> -	  If you have a parallel I/O workload and your system has enough memory,
> -	  using this option may improve overall I/O performance.
> -
> -	  If unsure, say N.
> -
>  config SQUASHFS_XZ
>  	bool "Include support for XZ compressed file systems"
>  	depends on SQUASHFS
> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
> index dfebc3b..5833b96 100644
> --- a/fs/squashfs/Makefile
> +++ b/fs/squashfs/Makefile
> @@ -5,14 +5,10 @@
>  obj-$(CONFIG_SQUASHFS) += squashfs.o
>  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
>  squashfs-y += namei.o super.o symlink.o decompressor.o
> -
> +squashfs-$(CONFIG_SQUASHFS_DECOMP_SINGLE) += decompressor_single.o
> +squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI) += decompressor_multi.o
> +squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU) += decompressor_multi_percpu.o
>  squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
>  squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
>  squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
>  squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
> -
> -ifdef CONFIG_SQUASHFS_MULTI_DECOMPRESSOR
> -	squashfs-y		+= decompressor_multi.o
> -else
> -	squashfs-y		+= decompressor_single.o
> -endif
> diff --git a/fs/squashfs/decompressor_multi_percpu.c b/fs/squashfs/decompressor_multi_percpu.c
> new file mode 100644
> index 0000000..b5598ab
> --- /dev/null
> +++ b/fs/squashfs/decompressor_multi_percpu.c
> @@ -0,0 +1,105 @@
> +/*
> + * Copyright (c) 2013
> + * Phillip Lougher <phillip@squashfs.org.uk>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2. See
> + * the COPYING file in the top-level directory.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/buffer_head.h>
> +
> +#include "squashfs_fs.h"
> +#include "squashfs_fs_sb.h"
> +#include "decompressor.h"
> +#include "squashfs.h"
> +
> +/*
> + * This file implements multi-threaded decompression using percpu
> + * variables, one thread per cpu core.
> + */
> +
> +struct squashfs_stream {
> +	void		*stream;
> +};
> +
> +void *squashfs_decompressor_create(struct squashfs_sb_info *msblk,
> +						void *comp_opts)
> +{
> +	struct squashfs_stream *stream;
> +	struct squashfs_stream __percpu *percpu;
> +	int err, cpu, cpu0;
> +
> +	percpu = alloc_percpu(struct squashfs_stream);
> +	if (percpu == NULL) {
> +		err = -ENOMEM;
> +		goto out2;
> +	}
> +
> +	for_each_possible_cpu(cpu) {
> +		stream = per_cpu_ptr(percpu, cpu);
> +		stream->stream = msblk->decompressor->init(msblk, comp_opts);
> +		if (IS_ERR(stream->stream)) {
> +			err = PTR_ERR(stream->stream);
> +			goto out;
> +		}
> +	}
> +
> +	kfree(comp_opts);

squashfs_decompressor_setup free comp_opts.

> +	return (__force void *) percpu;
> +
> +out:
> +	for_each_possible_cpu(cpu0) {
> +		if (cpu0 == cpu)

Just nit so you could ignore easily. :)

this cpu variable comparing is tricky to me.
I'm not sure what happens if CPU hotplug happens between above two loop
I guess your code is but I couldn't find such usecase in other code.

alloc_percpu semantic is that "Allocate zero-filled percpu area"
so how about using it instead of cpu index comparing?

for_each_possbile_cpu(cpu) {
        stream = per_cpu_ptr(percpu, cpu0);
        if (stream)
                msblk->decompressor->free(stream->stream);
}

It's never hot path and not fragile to change CPU hotplug, IMHO.


> +			break;
> +		stream = per_cpu_ptr(percpu, cpu0);
> +		msblk->decompressor->free(stream->stream);
> +	}
> +	free_percpu(percpu);
> +out2:
> +	kfree(comp_opts);

We can throw away, either.


> +	return ERR_PTR(err);
> +}
> +
> +void squashfs_decompressor_destroy(struct squashfs_sb_info *msblk)
> +{
> +	struct squashfs_stream __percpu *percpu =
> +			(struct squashfs_stream __percpu *) msblk->stream;
> +	struct squashfs_stream *stream;
> +	int cpu;
> +
> +	if (msblk->stream) {
> +		for_each_possible_cpu(cpu) {
> +			stream = per_cpu_ptr(percpu, cpu);
> +			msblk->decompressor->free(stream->stream);
> +		}
> +		free_percpu(percpu);
> +	}
> +}
> +
> +int squashfs_decompress(struct squashfs_sb_info *msblk,
> +	void **buffer, struct buffer_head **bh, int b, int offset, int length,
> +	int srclength, int pages)
> +{
> +	int res;
> +	struct squashfs_stream __percpu *percpu =
> +			(struct squashfs_stream __percpu *) msblk->stream;
> +	struct squashfs_stream *stream = get_cpu_ptr(percpu);
> +
> +	res = msblk->decompressor->decompress(msblk, stream->stream, buffer,
> +		bh, b, offset, length, srclength, pages);
> +	put_cpu_ptr(stream);
> +
> +	if (res < 0)
> +		ERROR("%s decompression failed, data probably corrupt\n",
> +			msblk->decompressor->name);
> +
> +	return res;
> +}
> +
> +int squashfs_max_decompressors(void)
> +{
> +	return num_possible_cpus();
> +}
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
