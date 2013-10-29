Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3J2Kyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:54:46 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52184 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751237Ab3J2Kyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:54:44 -0400
Date: Tue, 29 Oct 2013 10:51:59 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Simon Baatz <gmbnomis@gmail.com>, Will Deacon <Will.Deacon@arm.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] lib/scatterlist.c: don't flush_kernel_dcache_page on
 slab page
Message-ID: <20131029105159.GB3472@arm.com>
References: <1382977205-26268-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382977205-26268-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 04:20:05PM +0000, Ming Lei wrote:
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

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
