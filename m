Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaAFHfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:35:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45313 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaAFHfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:35:42 -0500
X-AuditID: 9c930197-b7c4aae000003d84-6d-52ca5ccbbc00
Date: Mon, 6 Jan 2014 16:35:49 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@iki.fi>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix crash when using XFS on loopback
Message-ID: <20140106073549.GA25771@lge.com>
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 12:45:45PM -0500, Mikulas Patocka wrote:
> The patch 8456a648cf44f14365f1f44de90a3da2526a4776 causes crash in the
> LVM2 testsuite on PA-RISC (the crashing test is fsadm.sh). The testsuite
> doesn't crash on 3.12, crashes on 3.13-rc1 and later.
> 
>  Bad Address (null pointer deref?): Code=15 regs=000000413edd89a0 (Addr=000006202224647d)
>  CPU: 3 PID: 24008 Comm: loop0 Not tainted 3.13.0-rc6 #5
>  task: 00000001bf3c0048 ti: 000000413edd8000 task.ti: 000000413edd8000
> 
>       YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
>  PSW: 00001000000001101111100100001110 Not tainted
>  r00-03  000000ff0806f90e 00000000405c8de0 000000004013e6c0 000000413edd83f0
>  r04-07  00000000405a95e0 0000000000000200 00000001414735f0 00000001bf349e40
>  r08-11  0000000010fe3d10 0000000000000001 00000040829c7778 000000413efd9000
>  r12-15  0000000000000000 000000004060d800 0000000010fe3000 0000000010fe3000
>  r16-19  000000413edd82a0 00000041078ddbc0 0000000000000010 0000000000000001
>  r20-23  0008f3d0d83a8000 0000000000000000 00000040829c7778 0000000000000080
>  r24-27  00000001bf349e40 00000001bf349e40 202d66202224640d 00000000405a95e0
>  r28-31  202d662022246465 000000413edd88f0 000000413edd89a0 0000000000000001
>  sr00-03  000000000532c000 0000000000000000 0000000000000000 000000000532c000
>  sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> 
>  IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000401fe42c 00000000401fe430
>   IIR: 539c0030    ISR: 00000000202d6000  IOR: 000006202224647d
>   CPU:        3   CR30: 000000413edd8000 CR31: 0000000000000000
>   ORIG_R28: 00000000405a95e0
>   IAOQ[0]: vma_interval_tree_iter_first+0x14/0x48
>   IAOQ[1]: vma_interval_tree_iter_first+0x18/0x48
>   RP(r2): flush_dcache_page+0x128/0x388
>  Backtrace:
>   [<000000004013e6c0>] flush_dcache_page+0x128/0x388
>   [<0000000010fe6ca0>] lo_splice_actor+0x90/0x148 [loop]
>   [<00000000402579b0>] splice_from_pipe_feed+0xc0/0x1d0
>   [<00000000402580a4>] __splice_from_pipe+0xac/0xc0
>   [<0000000010fe6bbc>] lo_direct_splice_actor+0x1c/0x70 [loop]
>   [<000000004025854c>] splice_direct_to_actor+0xec/0x228
>   [<0000000010fe63ac>] lo_receive+0xe4/0x298 [loop]
>   [<0000000010fe69d8>] loop_thread+0x478/0x640 [loop]
>   [<000000004018975c>] kthread+0x134/0x168
>   [<000000004012c020>] end_fault_vector+0x20/0x28
>   [<00000000115e0098>] xfs_setsize_buftarg+0x0/0x90 [xfs]
> 
>  Kernel panic - not syncing: Bad Address (null pointer deref?)
> 
> The patch 8456a648cf44f14365f1f44de90a3da2526a4776 changes the page
> structure so that the slab subsystem reuses the page->mapping field.
> 
> The crash happens in the following way:
> * XFS allocates some memory from slab and issues a bio to read data into
>   it.
> * the bio is sent to the loopback device.
> * lo_receive creates an actor and calls splice_direct_to_actor.
> * lo_splice_actor copies data to the target page.
> * lo_splice_actor calls flush_dcache_page because the page may be mapped
>   by userspace. In that case we need to flush the kernel cache.
> * flush_dcache_page asks for the list of userspace mappings, however that
>   page->mapping field is reused by the slab subsystem for a different
>   purpose. This causes the crash.
> 
> Note that other architectures without coherent caches (sparc, arm, mips)
> also call page_mapping from flush_dcache_page, so they may crash in the
> same way.
> 
> This patch fixes this bug by testing if the page is a slab page in
> page_mapping and returning NULL if it is.
> 
> 
> The patch also fixes VM_BUG_ON(PageSlab(page)) that could happen in
> earlier kernels in the same scenario on architectures without cache
> coherence when CONFIG_DEBUG_VM is enabled - so it should be backported to
> stable kernels.
> 
> 
> In the old kernels, the function page_mapping is placed in
> include/linux/mm.h, so you should modify the patch accordingly when
> backporting it.
> 
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  mm/util.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-3.13-rc6/mm/util.c
> ===================================================================
> --- linux-3.13-rc6.orig/mm/util.c	2014-01-04 00:06:07.000000000 +0100
> +++ linux-3.13-rc6/mm/util.c	2014-01-04 00:24:42.000000000 +0100
> @@ -390,7 +390,10 @@ struct address_space *page_mapping(struc
>  {
>  	struct address_space *mapping = page->mapping;
>  
> -	VM_BUG_ON(PageSlab(page));
> +	/* This happens if someone calls flush_dcache_page on slab page */
> +	if (unlikely(PageSlab(page)))
> +		return NULL;
> +
>  	if (unlikely(PageSwapCache(page))) {
>  		swp_entry_t entry;
>  
> --

Hello,

I'm surprised that this VM_BUG_ON() has not been triggered until now. It was
introduced in 2007 by commit (b5fab14). Maybe there is no person who test
with CONFIG_DEBUG_VM.

There is one more bug report same as this.
* possible regression on 3.13 when calling flush_dcache_page
  (lkml.org/lkml/2013/12/12/255)

As mentioned in the description of commit (b5fab14), slab object may not be
properly aligned and use of page oriented function to this object can be
dangerous. I searched the XFS code and found that they only try to allocate
multiple of 512 bytes, so there is no problem for now. But, IMHO, it is better
not to use slab objects for this purpose.

And I rapidly searched every callsites of page_mapping() and, IMHO, this patch
would work correctly. But possibly reverting original commit is better solution.

Hello, Pekka and Christoph.
Could you teach me which direction we have to go?

Thanks.
