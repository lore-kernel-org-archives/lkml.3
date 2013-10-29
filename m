Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3J2M5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:57:44 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34463 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3J2M5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:57:42 -0400
Date: Tue, 29 Oct 2013 13:57:37 +0100
From: Simon Baatz <gmbnomis@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] lib/scatterlist.c: don't flush_kernel_dcache_page on
 slab page
Message-ID: <20131029125737.GA3643@schnuecks.de>
References: <1382977205-26268-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382977205-26268-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:20:05AM +0800, Ming Lei wrote:
> Commit b1adaf65ba03([SCSI] block: add sg buffer copy helper functions)
> introduces two sg buffer copy helpers, and calls flush_kernel_dcache_page()
> on pages in SG list after these pages are written to.
> 
> Unfortunately, the commit may introduce a potential bug:
> 
> 	- Before sending some SCSI commands, kmalloc() buffer may be
> 	passed to block layper, so flush_kernel_dcache_page() can
> 	see a slab page finally
> 
> 	- According to cachetlb.txt, flush_kernel_dcache_page() is
> 	only called on "a user page", which surely can't be a slab page.
> 
> 	- ARCH's implementation of flush_kernel_dcache_page() may
> 	use page mapping information to do optimization so page_mapping()
> 	will see the slab page, then VM_BUG_ON() is triggered.
> 
> Aaro Koskinen reported the bug on ARM/kirkwood when DEBUG_VM is enabled,
> and this patch fixes the bug by adding test of '!PageSlab(miter->page)'
> before calling flush_kernel_dcache_page().
> 
> Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Simon Baatz <gmbnomis@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  lib/scatterlist.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index a685c8a..d16fa29 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -577,7 +577,8 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
>  		miter->__offset += miter->consumed;
>  		miter->__remaining -= miter->consumed;
>  
> -		if (miter->__flags & SG_MITER_TO_SG)
> +		if ((miter->__flags & SG_MITER_TO_SG) &&
> +		    !PageSlab(miter->page))
>  			flush_kernel_dcache_page(miter->page);
>  
>  		if (miter->__flags & SG_MITER_ATOMIC) {
> -- 
> 1.7.9.5
> 

Tested-by: Simon Baatz <gmbnomis@gmail.com>

on top of 3.12-rc7 on Kirkwood with DEBUG_VM enabled.

- Simon
