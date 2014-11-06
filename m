Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaKFN5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:57:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:53891 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKFN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:57:51 -0500
Date: Thu, 6 Nov 2014 13:57:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141106135740.GC19702@e104818-lin.cambridge.arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
 <20141029194738.GA29911@arm.com>
 <20141104142955.GA24816@e104818-lin.cambridge.arm.com>
 <CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com>
Thread-Topic: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 04:08:27PM +0000, Linus Torvalds wrote:
> On Tue, Nov 4, 2014 at 6:29 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > This would work on arm64 but is the PAGE_SIZE range enough for all
> > architectures even when we flush a huge page or a pmd/pud table entry?
> 
> It pretty much had *better* be.

Thanks for confirming.

> For things like page tables caches (ie caching addresses "inside" the
> page tables, like x86 does), for legacy reasons, flushing an
> individual page had better flush the page table caches behind it. This
> is definitely how x86 works, for example. And if you have an
> architected non-legacy page table cache (which I'm not aware of
> anybody actually doing), you're going to have some architecturally
> explicit flushing for that, likely *separate* from a regular TLB entry
> flush, and thus you'd need more than just some range expansion..

On arm64 we have two types of TLB invalidation instructions, the
standard one which flushes a pte entry together with the corresponding
upper level page table cache and a "leaf" operation only for the pte. We
don't use the latter in Linux (yet) but in theory it's more efficient.

Anyway, even without special "leaf" operations, it would be useful to
make the distinction between unmap_vmas() and free_pgtables() with
regards to the ranges tracked by mmu_gather. For the former, tlb_flush()
needs to flush the range in PAGE_SIZE increments (assuming a mix of
small and huge pages). For the latter, PMD_SIZE increments would be
enough.

With RCU_TABLE_FREE, I think checking tlb->local.next would do the trick
but for x86 we can keep mmu_gather.need_flush only for pte clearing
and remove need_flush = 1 from p*_free_tlb() functions. The arch
specific tlb_flush() can take need_flush into account to change the
range flushing increment or even ignore the second tlb_flush() triggered
by tlb_finish_mmu() (after free_pgtables(), the ptes have been flushed
via tlb_end_vma()).

-- 
Catalin
