Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3KTJg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:36:29 -0500
Received: from mdfmta005.mxout.tch.inty.net ([91.221.169.46]:52506 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668Ab3KTJgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:36:21 -0500
Message-ID: <528C8290.8020101@lougher.demon.co.uk>
Date: Wed, 20 Nov 2013 09:36:16 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] Squashfs: add multi-threaded decompression using
 percpu variables (V2)
References: <1384912091-11092-1-git-send-email-phillip@squashfs.org.uk> <1384912091-11092-3-git-send-email-phillip@squashfs.org.uk> <20131120083322.GA4407@bbox>
In-Reply-To: <20131120083322.GA4407@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/13 08:33, Minchan Kim wrote:
> On Wed, Nov 20, 2013 at 01:48:06AM +0000, Phillip Lougher wrote:
>> Add a multi-threaded decompression implementation which uses
>> percpu variables.
>>
>> Using percpu variables has advantages and disadvantages over
>> implementations which do not use percpu variables.
>>
>> Advantages:
>>    * the nature of percpu variables ensures decompression is
>>      load-balanced across the multiple cores.
>>    * simplicity.
>>
>> Disadvantages: it limits decompression to one thread per core.
>>
>> V2:
>>    * squashfs_decompressor_create: improve error handling path, re freeing
>>      of decompressors and comp_opts
>>    * decompressor_multi_percpu.c: include percpu.h header
>>    * Kconfig: indentation
>>
>> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
>> ---
>>   fs/squashfs/Kconfig                     | 57 ++++++++++++++-----
>>   fs/squashfs/Makefile                    | 10 +---
>>   fs/squashfs/decompressor_multi_percpu.c | 98 +++++++++++++++++++++++++++++++++
>>   3 files changed, 145 insertions(+), 20 deletions(-)
>>   create mode 100644 fs/squashfs/decompressor_multi_percpu.c
>>
>> diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
>> index 1c6d340..159bd66 100644
>> --- a/fs/squashfs/Kconfig
>> +++ b/fs/squashfs/Kconfig
>> @@ -25,6 +25,50 @@ config SQUASHFS
>>
>>   	  If unsure, say N.
>>
>> +choice
>> +	prompt "Decompressor parallelisation options"
>
> Nitpick:
> How about adding default explicitly?
>
>          default SQUASHFS_DECOMP_SINGLE

I initially did that :-) .... only to get an error
returned from kbuild that defaults on choices were
not supported.   PITA.

>
>> +	depends on SQUASHFS
>> +	help
>> +	  Squashfs now supports three parallelisation options for
>> +	  decompression.  Each one exhibits various trade-offs between
>> +	  decompression performance and CPU and memory usage.
>> +
>> +	  If in doubt, select "Single threaded compression"
>> +
>> +config SQUASHFS_DECOMP_SINGLE
>> +	bool "Single threaded compression"
>> +	help
>> +	  Traditionally Squashfs has used single-threaded decompression.
>> +	  Only one block (data or metadata) can be decompressed at any
>> +	  one time.  This limits CPU and memory usage to a minimum.
>> +
>> +config SQUASHFS_DECOMP_MULTI
>> +	bool "Use multiple decompressors for parallel I/O"
>> +	help
>> +	  By default Squashfs uses a single decompressor but it gives
>> +	  poor performance on parallel I/O workloads when using multiple CPU
>> +	  machines due to waiting on decompressor availability.
>> +
>> +	  If you have a parallel I/O workload and your system has enough memory,
>> +	  using this option may improve overall I/O performance.
>> +
>> +	  This decompressor implementation uses up to two parallel
>> +	  decompressors per core.  It dynamically allocates decompressors
>> +	  on a demand basis.
>> +
>> +config SQUASHFS_DECOMP_MULTI_PERCPU
>> +	bool "Use percpu multiple decompressors for parallel I/O"
>> +	help
>> +	  By default Squashfs uses a single decompressor but it gives
>> +	  poor performance on parallel I/O workloads when using multiple CPU
>> +	  machines due to waiting on decompressor availability.
>> +
>> +	  This decompressor implementation uses a maximum of one
>> +	  decompressor per core.  It uses percpu variables to ensure
>
> Minor:
>                                   ^
>                                   unnecessary white space.

Two spaces after the full stop, starting a new sentence?  As a kid back
in the 1970s and early 80s that's what I was taught.  Maybe it's become old
fashioned and I've not noticed.

http://www.rednovalabs.com/generation-gap-one-space-or-two-after-a-period/

>
>> +	  decompression is load-balanced across the cores.
>
> Actually, I am not sure it's good idea to mention percpu in description.
> Normal people wouldn't know that and I think what they can want to know
> is what's benefit compared to SQUASHFS_DECOMP_MULTI.

The people who have asked me for the percpu implementation will know :-)

Some people want to have the percpu implementation.  Some don't.

Some people who want the percpu implementation *only* want the percpu
implementation.

Some people who don't want the percpu implementation *only* want the non-percpu
implementation.

People are different, and try as I might, that's not going to go away anytime
soon.

I have spent more time arguing over this 90 odd lines of code than anything else.
Should I call the percpu implementation the new "bike shed"?  Because that's
how it seems to me at the moment.

Life's too short to get hung up about this.  I'm adding both implementations
because that keeps more people happy than the alternative.

Maybe I should just drop both implementations for this merge window, and
invite everyone else to fight it out over which single implementation
they want, and I'll take a ring side seat while it happens.

>
> How about this?
>
> 	  This decompressor implementation uses a maximum of one
> 	  decompressor per core and the decompressor is allocated
>            statically so memory footprint is small and limited
>            and I/O cannot be fluctuated by not failing decompressor
>            dynamic allocation compared to SQUAHSDS_DECOMP_MULTI.
>
> And I'd like to see what's your point about "decompression is load-balanced
> across the cores".
>
> If scheduler assigns process A, B, C into a core, it couldn't be load-balanced.
> If scheduler assign process A, B, C into each core, it could be load-balanced.
> And it's same with SQUSHFS_DECOMP_MULTI.
>
> Could you elaborate it a bit?

Taking an percpu variable is an exclusive lock on that core.  Whilst that
percpu variable is held it ensures nothing else can be scheduled on that
core.  Any other parallel decompressions will by definition be guaranteed
to be scheduled on another core.

Without percpu variables, and parallel threads it is entirely up to
the scheduler whether it schedules them on different cores, or schedules
both threads on the same core.

Phillip

>
> Otherwise, looks good to me.
>
> Thanks!
>
>> +
>> +endchoice
>> +
>>   config SQUASHFS_XATTR
>>   	bool "Squashfs XATTR support"
>>   	depends on SQUASHFS
>> @@ -63,19 +107,6 @@ config SQUASHFS_LZO
>>
>>   	  If unsure, say N.
>>
>> -config SQUASHFS_MULTI_DECOMPRESSOR
>> -	bool "Use multiple decompressors for handling parallel I/O"
>> -	depends on SQUASHFS
>> -	help
>> -	  By default Squashfs uses a single decompressor but it gives
>> -	  poor performance on parallel I/O workloads when using multiple CPU
>> -	  machines due to waiting on decompressor availability.
>> -
>> -	  If you have a parallel I/O workload and your system has enough memory,
>> -	  using this option may improve overall I/O performance.
>> -
>> -	  If unsure, say N.
>> -
>>   config SQUASHFS_XZ
>>   	bool "Include support for XZ compressed file systems"
>>   	depends on SQUASHFS
>> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
>> index dfebc3b..5833b96 100644
>> --- a/fs/squashfs/Makefile
>> +++ b/fs/squashfs/Makefile
>> @@ -5,14 +5,10 @@
>>   obj-$(CONFIG_SQUASHFS) += squashfs.o
>>   squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
>>   squashfs-y += namei.o super.o symlink.o decompressor.o
>> -
>> +squashfs-$(CONFIG_SQUASHFS_DECOMP_SINGLE) += decompressor_single.o
>> +squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI) += decompressor_multi.o
>> +squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU) += decompressor_multi_percpu.o
>>   squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
>>   squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
>>   squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
>>   squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
>> -
>> -ifdef CONFIG_SQUASHFS_MULTI_DECOMPRESSOR
>> -	squashfs-y		+= decompressor_multi.o
>> -else
>> -	squashfs-y		+= decompressor_single.o
>> -endif
>> diff --git a/fs/squashfs/decompressor_multi_percpu.c b/fs/squashfs/decompressor_multi_percpu.c
>> new file mode 100644
>> index 0000000..0e7b679
>> --- /dev/null
>> +++ b/fs/squashfs/decompressor_multi_percpu.c
>> @@ -0,0 +1,98 @@
>> +/*
>> + * Copyright (c) 2013
>> + * Phillip Lougher <phillip@squashfs.org.uk>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2. See
>> + * the COPYING file in the top-level directory.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/slab.h>
>> +#include <linux/percpu.h>
>> +#include <linux/buffer_head.h>
>> +
>> +#include "squashfs_fs.h"
>> +#include "squashfs_fs_sb.h"
>> +#include "decompressor.h"
>> +#include "squashfs.h"
>> +
>> +/*
>> + * This file implements multi-threaded decompression using percpu
>> + * variables, one thread per cpu core.
>> + */
>> +
>> +struct squashfs_stream {
>> +	void		*stream;
>> +};
>> +
>> +void *squashfs_decompressor_create(struct squashfs_sb_info *msblk,
>> +						void *comp_opts)
>> +{
>> +	struct squashfs_stream *stream;
>> +	struct squashfs_stream __percpu *percpu;
>> +	int err, cpu;
>> +
>> +	percpu = alloc_percpu(struct squashfs_stream);
>> +	if (percpu == NULL)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		stream = per_cpu_ptr(percpu, cpu);
>> +		stream->stream = msblk->decompressor->init(msblk, comp_opts);
>> +		if (IS_ERR(stream->stream)) {
>> +			err = PTR_ERR(stream->stream);
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	kfree(comp_opts);
>> +	return (__force void *) percpu;
>> +
>> +out:
>> +	for_each_possible_cpu(cpu) {
>> +		stream = per_cpu_ptr(percpu, cpu);
>> +		if (!IS_ERR_OR_NULL(stream->stream))
>> +			msblk->decompressor->free(stream->stream);
>> +	}
>> +	free_percpu(percpu);
>> +	return ERR_PTR(err);
>> +}
>> +
>> +void squashfs_decompressor_destroy(struct squashfs_sb_info *msblk)
>> +{
>> +	struct squashfs_stream __percpu *percpu =
>> +			(struct squashfs_stream __percpu *) msblk->stream;
>> +	struct squashfs_stream *stream;
>> +	int cpu;
>> +
>> +	if (msblk->stream) {
>> +		for_each_possible_cpu(cpu) {
>> +			stream = per_cpu_ptr(percpu, cpu);
>> +			msblk->decompressor->free(stream->stream);
>> +		}
>> +		free_percpu(percpu);
>> +	}
>> +}
>> +
>> +int squashfs_decompress(struct squashfs_sb_info *msblk,
>> +	void **buffer, struct buffer_head **bh, int b, int offset, int length,
>> +	int srclength, int pages)
>> +{
>> +	struct squashfs_stream __percpu *percpu =
>> +			(struct squashfs_stream __percpu *) msblk->stream;
>> +	struct squashfs_stream *stream = get_cpu_ptr(percpu);
>> +	int res = msblk->decompressor->decompress(msblk, stream->stream, buffer,
>> +		bh, b, offset, length, srclength, pages);
>> +	put_cpu_ptr(stream);
>> +
>> +	if (res < 0)
>> +		ERROR("%s decompression failed, data probably corrupt\n",
>> +			msblk->decompressor->name);
>> +
>> +	return res;
>> +}
>> +
>> +int squashfs_max_decompressors(void)
>> +{
>> +	return num_possible_cpus();
>> +}
>> --
>> 1.8.3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

