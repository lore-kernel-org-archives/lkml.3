Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3J0Lvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:51:36 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42232 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3J0Lve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:51:34 -0400
Date: Sun, 27 Oct 2013 19:51:15 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, gmbnomis@gmail.com,
        catalin.marinas@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: ARM/kirkwood: v3.12-rc6: kernel BUG at mm/util.c:390!
Message-ID: <20131027195115.208f40f3@tom-ThinkPad-T410>
In-Reply-To: <20131026143617.GA14034@mudshark.cambridge.arm.com>
References: <20131024200730.GB17447@blackmetal.musicnaut.iki.fi>
	<20131026143617.GA14034@mudshark.cambridge.arm.com>
Organization: Ming
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013 15:36:17 +0100
Will Deacon <will.deacon@arm.com> wrote:

> On Thu, Oct 24, 2013 at 09:07:30PM +0100, Aaro Koskinen wrote:
> 
> > [   36.477203] Backtrace:
> > [   36.535603] [<c009237c>] (page_mapping+0x0/0x50) from [<c0010dd8>] (flush_kernel_dcache_page+0x14/0x98)
> > [   36.661070] [<c0010dc4>] (flush_kernel_dcache_page+0x0/0x98) from [<c0172b60>] (sg_miter_stop+0xc8/0x10c)
> > [   36.792813]  r4:df8a9a64 r3:00000003
> > [   36.857524] [<c0172a98>] (sg_miter_stop+0x0/0x10c) from [<c0172f20>] (sg_miter_next+0x14/0x13c)
> 
> ... assumedly for scatter/gather DMA. How is your block driver allocating
> its buffers? If you're using the DMA API, I can't see how this would happen.

Lots of SCSI commands(inquiry, ...) pass kmalloc buffer to block layer,
then the sg buffer copy helpers and flush_kernel_dcache_page() may see
slab page.

That has been here from commit b1adaf65ba03( [SCSI] block: add sg buffer copy
helper functions).

So how about letting below patch to workaround the issue?

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a685c8a..eea8806 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -577,7 +577,7 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 		miter->__offset += miter->consumed;
 		miter->__remaining -= miter->consumed;
 
-		if (miter->__flags & SG_MITER_TO_SG)
+		if ((miter->__flags & SG_MITER_TO_SG) && !PageSlab(page))
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {



Thanks,
-- 
Ming Lei
