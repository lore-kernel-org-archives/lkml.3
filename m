Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaBFFQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:16:20 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60202 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBFFQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:16:19 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-c4-52f31aa16c4b
Date: Thu, 6 Feb 2014 14:16:28 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] zram: introduce compressing backend abstraction
Message-ID: <20140206051628.GC3211@bbox>
References: <1391110088-14830-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1391110088-14830-2-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391110088-14830-2-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

Sorry for late response.

On Thu, Jan 30, 2014 at 10:28:07PM +0300, Sergey Senozhatsky wrote:
> ZRAM performs direct LZO compression algorithm calls, making it the one
> and only option. Introduce struct zram_comp in order to support multiple
> compression algorithms. struct zram_comp defines the following set of
> compressing backend operations:
> 	.create
> 	.destroy
> 	.compress
> 	.decompress
> 	.workmem_get
> 	.workmem_put
> 
> Schematically zram write() usually contains the following steps:
> 0) preparation (decompression of partioal IO, etc.)
> 1) lock buffer_lock mutex (protects meta compress buffers)
> 2) compress (using meta compress buffers)
> 3) alloc and map zs_pool object
> 4) copy compressed data (from meta compress buffers) to new object

                                                          object allocated by 3)
     
> 5) free previous pool page, assign a new one
> 6) unlock buffer_lock mutex
> 
> As we can see, compressing buffers must remain untouched from 1) to 4),
> because, otherwise, concurrent write() will overwrite data. At the same
> time, zram_meta must be aware of a) specific compression algorithm
> memory requirements and b) necessary locking to protect compression
> buffers. Besides, zram holds buffer_lock almost through the whole write()
> function, making parallel compression impossible. To remove requirement
> a) new struct zcomp_workmem (workmem is a common term used by lzo, lz4
> and zlib) contains buffers required by compression algorithm, while new
> struct zcomp_wm_policy implements workmem handling and locking by means
> of get() and put() semantics and removes requirement b) from zram meta.
> In general, workmem_get() turns caller into exclusive user of workmem
> and workem_put() makes a particular workmem available.
> 
> Each compressing backend may use a default workmem policy or provide
> custom implementation. Default workmem policy (struct zcomp_wm_policy)
> has a list of idle workmem buffers (at least 1 workmem), spinlock to
> protect idle list and wait queue, making it possible to have parallel
> compressions. Each time zram issues a workmem_get() call, the following
> set of operations performed:

I'm still really not sure why backend should know workmem policy.
I think it's matter of upper layer, not backend.
Yeb, surely, you have a reason but it's very hard for me to know it
by this patchset so I'd like to divide the patchset.
(You don't need to explain it in here and I expect it would be clear
if you separate it like I suggested below).
Pz, see below.

> - spin lock buffer_lock
> - if idle list is not empty, remove workmem from idle list, spin
>   unlock and return workmem pointer
> - if idle list is empty, current adds itself to wait queue. it will be
>   awaken by workmem_put() caller.
> 
> workmem_put():
> - spin lock buffer_lock
> - add workmem to idle list
> - spin unlock, wake up sleeper (if any)

Good.

> 
> zram_comp file contains array of supported compressing backends, which
> can be altered according to user selection.
> 
> Usage examples. To initialize compressing backend:
> 	comp = zcomp_create(NAME) /* NAME e.g. lzo, lz4 */
> 
> which performs NAME lookup in array of supported compressing backends
> and initialises compressing backend if requested algorithm is supported.
> Compressing:
> 	wm = comp->workmem_get(comp)
> 	comp->compress(...)
> 	[..] /* copy compressed data */
> 	comp->workmem_put(comp, wm)
> 
> Free compessing backend and all ot its workmem buffers:
> 	zcomp_destroy(comp)
> 
> The patch implements LZO and LZ4 backends. At this point zcomp_wm_policy
> keeps only one workmem in the idle list, support for multi workmem buffers
> will be introduced later.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zcomp_lz4.c |  49 ++++++++++
>  drivers/block/zram/zcomp_lz4.h |  18 ++++

Please don't include lz4 in this patch. It should be separated and
description of the patch surely should include the number to prove
lz4 is better than lzo in *what* workload so it should make
everybody easy to convince.

And let's separate this patchset following as

1. abstract compressor with zram_comp.
2. Support configurable compressor
3. support zcomp multi buffers
4. support lz4

Please don't add workmem policy in patch 1 because we still use only
a buffer until 3 so patch 1, 2 would be very simple.
Patch 3 might introduce wm policy. Then, it would be very clear
why we need it for zomp_multi so that it would make review easy.

If 1,2,3 have no problem and apparenlty lz4 has a benefit, patch 4
will be merged easily but If lz4 were rejected by some reason,
we could support another compression easily since patch 1,2,3 is
merged.

Thanks.

-- 
Kind regards,
Minchan Kim
