Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaLIHwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:52:01 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60429 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaLIHv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:51:58 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 9 Dec 2014 16:55:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Drake <drake@endlessm.com>, Minchan Kim <minchan@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [regression] Boot crash with: f7426b983a6a ("mm: cma: adjust
 address limit to avoid hitting low/high memory boundary")
Message-ID: <20141209075541.GA7714@js1304-P5Q-DELUXE>
References: <20141117163903.GA17801@gmail.com>
 <20141127130556.GA4074@gmail.com>
 <20141128070220.GA11802@js1304-P5Q-DELUXE>
 <20141208105640.GA29431@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208105640.GA29431@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 11:56:40AM +0100, Ingo Molnar wrote:
> 
> * Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > On Thu, Nov 27, 2014 at 02:05:56PM +0100, Ingo Molnar wrote:
> > > 
> > > Any replies to this regression after 10 days, or should I send a 
> > > revert patch?
> > 
> > Hello, Ingo.
> > 
> > I can reproduce your problem and find root cause.
> > If CONFIG_DEBUG_VIRTUAL is enabled, __pa() checks whether virtual
> > address is valid or not. Because high_memory is not direct mapped
> > address, error occurs. IMO, physical address of high_memory is
> > useful to check phycal address of highmem boundary so do following
> > workaround to avoid validation is reasonable. But, if there is
> > a better solution, please let me know. I think that Marek will be
> > better than me in this area.
> > 
> > Please check following change to fix your problem.
> > If you agree following change, I will send it to Andrew with
> > proper description.
> > 
> > Thanks.
> > 
> > ------->8-------------
> > diff --git a/mm/cma.c b/mm/cma.c
> > index ee3c3e0..45cd0a6 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -227,7 +227,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
> >  			bool fixed, struct cma **res_cma)
> >  {
> >  	phys_addr_t memblock_end = memblock_end_of_DRAM();
> > -	phys_addr_t highmem_start = __pa(high_memory);
> > +	phys_addr_t highmem_start = __pa_nodebug(high_memory);
> >  	int ret = 0;
> >  
> >  	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
> 
> Looks like this patch solves my boot crash problem:
> 
>   Tested-by: Ingo Molnar <mingo@kernel.org>
> 
> I'll let you know if there's any problem left as I test it some 
> more. Consider the bug fixed!
> 

Hello, Andrew.

Could you manage this fix for above boot regression in x86?
Patch itself is so dirty, because __pa_nodebug() is implemented only
in x86. If someone knows better idea, please let me know.

Thanks.

--------------->8------------
>From 8d5de7c1acd6373e333c86058462c6046db8ca7d Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Tue, 9 Dec 2014 16:03:47 +0900
Subject: [PATCH] mm/CMA: fix boot regression due to physical address of
 high_memory

high_memory isn't direct mapped memory so retrieving it's physical
address isn't appropriate. But, it would be useful to check physical
address of highmem boundary so it's justfiable to get physical address
from it. In x86, there is a validation check if CONFIG_DEBUG_VIRTUAL
and it triggers following boot failure reported by Ingo.

...
BUG: Int 6: CR2 00f06f53
     EDI   (null)  ESI 0665b000  EBP c1ed7edc  EBX 40000000
     ESP c1ed7ed8   ES 0000007b   DS 0000007b
     EDX c2022c18  ECX 37d34000  EAX   (null)
     vec 00000006  err   (null)  EIP c102b62e   CS 00000060  flg 00210013
...
Call Trace:
 [<c1902dfd>] dump_stack+0x41/0x52
 [<c1fad1f7>] early_idt_handler+0x6b/0x6b
 [<c102b62e>] ? __phys_addr+0x16/0x68
 [<c1fccd26>] cma_declare_contiguous+0x33/0x212
 [<c1fe9b6e>] dma_contiguous_reserve_area+0x31/0x4e
 [<c1fe9ca8>] dma_contiguous_reserve+0x11d/0x125
 [<c1faf2c8>] ? setup_real_mode+0x98/0xa3
 [<c1fb00c8>] setup_arch+0x7b5/0xb63
 [<c1fad802>] start_kernel+0xb8/0x3e6
 [<c1fad2cb>] i386_start_kernel+0x79/0x7d

To fix boot regression, this patch implements workaround to avoid
validation check in x86 when retrieving physical address of high_memory.
__pa_nodebug() used by this patch is implemented only in x86 so
there is no choice but to use dirty #ifdef.

Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/cma.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index ee3c3e0..35c4787 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -227,9 +227,22 @@ int __init cma_declare_contiguous(phys_addr_t base,
 			bool fixed, struct cma **res_cma)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
-	phys_addr_t highmem_start = __pa(high_memory);
+	phys_addr_t highmem_start;
 	int ret = 0;
 
+#ifdef CONFIG_X86
+	/*
+	 * high_memory isn't direct mapped memory so retrieving it's
+	 * physical address isn't appropriate. But, it would be useful
+	 * to check physical address of highmem boundary so it's
+	 * justfiable to get physical address from it. In x86, there is
+	 * a validation check for this case, so following workaround is
+	 * needed to avoid it.
+	 */
+	highmem_start = __pa_nodebug(high_memory);
+#else
+	highmem_start = __pa(high_memory);
+#endif
 	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
 		__func__, &size, &base, &limit, &alignment);
 
-- 
1.7.9.5

