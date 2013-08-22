Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3HVFxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:53:02 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:48806 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3HVFxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:53:00 -0400
Date: Thu, 22 Aug 2013 07:52:54 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kprobes: add new dma insn slot cache for s390
Message-ID: <20130822055254.GA4293@osiris>
References: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com>
 <521575C2.7050504@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521575C2.7050504@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082205-0542-0000-0000-0000063592B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

> (2013/08/21 21:01), Heiko Carstens wrote:
> > The current kpropes insn caches allocate memory areas for insn slots with
> > module_alloc(). The assumption is that the kernel image and module area
> > are both within the same +/- 2GB memory area.
> > This however is not true for s390 where the kernel image resides within
> > the first 2GB (DMA memory area), but the module area is far away in the
> > vmalloc area, usually somewhere close below the 4TB area.
> > 
> > For new pc relative instructions s390 needs insn slots that are within
> > +/- 2GB of each area. That way we can patch displacements of pc-relative
> > instructions within the insn slots just like x86 and powerpc.
> > 
> > The module area works already with the normal insn slot allocator, however
> > there is currently no way to get insn slots that are within the first 2GB
> > on s390 (aka DMA area).
> 
> The reason why we allocate instruction buffers from module area is
> to execute a piece of code on the buffer, which should be executable.
> I'm not good for s390, is that allows kernel to execute the code
> on such DMA buffer?

Yes, the kernel image itself resides in DMA capable memory and it is all
executable.

> > Therefore this patch set introduces a third insn slot cache besides the
> > normal insn and optinsn slot caches: the dmainsn slot cache. Slots can be
> > allocated and freed with get_dmainsn_slot() and free_dmainsn_slot().
> 
> OK, but it seems that your patch introduced unneeded complexity. Perhaps,
> you just have to introduce 2 weak functions to allocate/release such
> executable and jump-able buffers, like below,
> 
> void * __weak arch_allocate_executable_page(void)
> {
> 	return module_alloc(PAGE_SIZE);
> }
> 
> void __weak arch_free_executable_page(void *page)
> {
> 	module_free(NULL, page);
> }
> 
> Thus, all you need to do is implementing dmaalloc() version of above
> functions on s390. No kconfig, no ifdefs are needed. :)

Hm, I don't see how that can work, or maybe I just don't get your idea ;)
Or maybe my intention was not clear? So let me try again:

If the to be probed instruction resides within the first 2GB of memory
(aka DMA memory, aka kernel image) the insn slot must be within the first
2GB as well, otherwise I can't patch pc-relative instructions.

On the other hand if the to be probed instruction resides in a module
(aka part of the vmalloc area), the insn slot must reside within the same
2GB area as well.

Therefore I need to different insn slot caches, where the slots are either
allocated with __get_free_page(GFP_KERNEL | GFP_DMA) (for the kernel image)
or module_alloc(PAGE_SIZE) for modules.

I can't have a single cache which satifies both areas.

