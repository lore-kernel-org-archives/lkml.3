Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaK1G7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:59:13 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48348 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaK1G7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:59:11 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 28 Nov 2014 16:02:20 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Drake <drake@endlessm.com>, Minchan Kim <minchan@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [regression] Boot crash with: f7426b983a6a ("mm: cma: adjust
 address limit to avoid hitting low/high memory boundary")
Message-ID: <20141128070220.GA11802@js1304-P5Q-DELUXE>
References: <20141117163903.GA17801@gmail.com>
 <20141127130556.GA4074@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127130556.GA4074@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:05:56PM +0100, Ingo Molnar wrote:
> 
> Any replies to this regression after 10 days, or should I send a 
> revert patch?

Hello, Ingo.

I can reproduce your problem and find root cause.
If CONFIG_DEBUG_VIRTUAL is enabled, __pa() checks whether virtual
address is valid or not. Because high_memory is not direct mapped
address, error occurs. IMO, physical address of high_memory is
useful to check phycal address of highmem boundary so do following
workaround to avoid validation is reasonable. But, if there is
a better solution, please let me know. I think that Marek will be
better than me in this area.

Please check following change to fix your problem.
If you agree following change, I will send it to Andrew with
proper description.

Thanks.

------->8-------------
diff --git a/mm/cma.c b/mm/cma.c
index ee3c3e0..45cd0a6 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -227,7 +227,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
 			bool fixed, struct cma **res_cma)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
-	phys_addr_t highmem_start = __pa(high_memory);
+	phys_addr_t highmem_start = __pa_nodebug(high_memory);
 	int ret = 0;
 
 	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",

> 
> Thanks,
> 
> 	Ingo
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > In x86 randconfig boot testing on a generic whitebox PC I started 
> > seeing the following new early boot crash, starting in this merge 
> > window:
> > 
> > ...
> > init_memory_mapping: [mem 0x37c00000-0x37d33fff]
> >  [mem 0x37c00000-0x37d33fff] page 4k
> > BRK [0x02a36000, 0x02a36fff] PGTABLE
> > BUG: Int 6: CR2 00f06f53
> >      EDI   (null)  ESI 0665b000  EBP c1ed7edc  EBX 40000000
> >      ESP c1ed7ed8   ES 0000007b   DS 0000007b
> >      EDX c2022c18  ECX 37d34000  EAX   (null)
> >      vec 00000006  err   (null)  EIP c102b62e   CS 00000060  flg 00210013
> > Stack:   (null) c1ed7f1c c1fccd26   (null)   (null)   (null)   (null) 00134000
> >          (null) 37c00000 37d34000   (null)   (null) 3fff0000 c2a09600 0665b000
> >          (null) c1ed7f3c c1fe9b6e   (null)   (null)   (null) c2a09600 0665b000
> > CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0+ #241217
> > Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
> >  00000000 00000000 c1ed7e88 c1902dfd 40000000 c1ed7edc c1fad1f7 c2023431
> >  00000006 00f06f53 00000000 0665b000 c1ed7edc 40000000 c1ed7ed8 0000007b
> >  0000007b c2022c18 37d34000 00000000 00000006 00000000 c102b62e 00000060
> > Call Trace:
> >  [<c1902dfd>] dump_stack+0x41/0x52
> >  [<c1fad1f7>] early_idt_handler+0x6b/0x6b
> >  [<c102b62e>] ? __phys_addr+0x16/0x68
> >  [<c1fccd26>] cma_declare_contiguous+0x33/0x212
> >  [<c1fe9b6e>] dma_contiguous_reserve_area+0x31/0x4e
> >  [<c1fe9ca8>] dma_contiguous_reserve+0x11d/0x125
> >  [<c1faf2c8>] ? setup_real_mode+0x98/0xa3
> >  [<c1fb00c8>] setup_arch+0x7b5/0xb63
> >  [<c1fad802>] start_kernel+0xb8/0x3e6
> >  [<c1fad2cb>] i386_start_kernel+0x79/0x7d
> > Press any key to enter the menu
> > 
> > and bisected it down to:
> > 
> >  f7426b983a6a353cf21e5733e84458219c4a817e is the first bad commit
> >  commit f7426b983a6a353cf21e5733e84458219c4a817e
> >  Author: Marek Szyprowski <m.szyprowski@samsung.com>
> >  Date:   Thu Oct 9 15:26:47 2014 -0700
> > 
> >     mm: cma: adjust address limit to avoid hitting low/high memory boundary
> > 
> >     Russell King recently noticed that limiting default CMA region only to low
> >     memory on ARM architecture causes serious memory management issues with
> >     machines having a lot of memory (which is mainly available as high
> >     memory).  More information can be found the following thread:
> >     http://thread.gmane.org/gmane.linux.ports.arm.kernel/348441/
> > 
> >     Those two patches removes this limit letting kernel to put default CMA
> >     region into high memory when this is possible (there is enough high memory
> >     available and architecture specific DMA limit fits).
> > 
> >     [...]
> > 
> > The offending commit does not revert cleanly.
> > 
