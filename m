Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaKDOaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:30:08 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:52851 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaKDOaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:30:02 -0500
Date: Tue, 4 Nov 2014 14:29:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141104142955.GA24816@e104818-lin.cambridge.arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
 <20141029194738.GA29911@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029194738.GA29911@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(catching up with email after holiday)

On Wed, Oct 29, 2014 at 07:47:39PM +0000, Will Deacon wrote:
>     mmu_gather: move minimal range calculations into generic code
>     
>     On architectures with hardware broadcasting of TLB invalidation messages
>     , it makes sense to reduce the range of the mmu_gather structure when
>     unmapping page ranges based on the dirty address information passed to
>     tlb_remove_tlb_entry.
>     
>     arm64 already does this by directly manipulating the start/end fields
>     of the gather structure, but this confuses the generic code which
>     does not expect these fields to change and can end up calculating
>     invalid, negative ranges when forcing a flush in zap_pte_range.
>     
>     This patch moves the minimal range calculation out of the arm64 code
>     and into the generic implementation, simplifying zap_pte_range in the
>     process (which no longer needs to care about start/end, since they will
>     point to the appropriate ranges already).
>     
>     Signed-off-by: Will Deacon <will.deacon@arm.com>

Nice to see this clean-up for arm64, however I have a question below.

> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 5672d7ea1fa0..340bc5c5ca2d 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -128,6 +128,46 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
>  		tlb_flush_mmu(tlb);
>  }
>  
> +static inline void __tlb_adjust_range(struct mmu_gather *tlb,
> +				      unsigned long address)
> +{
> +	if (!tlb->fullmm) {
> +		tlb->start = min(tlb->start, address);
> +		tlb->end = max(tlb->end, address + PAGE_SIZE);
> +	}
> +}

Here __tlb_adjust_range() assumes end to be (start + PAGE_SIZE) always.

> @@ -152,12 +193,14 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
>  #define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)		\
>  	do {							\
>  		tlb->need_flush = 1;				\
> +		__tlb_adjust_range(tlb, address);		\
>  		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);	\
>  	} while (0)

[...]

>  #define pmd_free_tlb(tlb, pmdp, address)			\
>  	do {							\
>  		tlb->need_flush = 1;				\
> +		__tlb_adjust_range(tlb, address);		\
>  		__pmd_free_tlb(tlb, pmdp, address);		\
>  	} while (0)

This would work on arm64 but is the PAGE_SIZE range enough for all
architectures even when we flush a huge page or a pmd/pud table entry?
The approach Peter Z took with his patches was to use pmd_addr_end(addr,
TASK_SIZE) and change __tlb_adjust_range() to take start/end arguments:

https://lkml.org/lkml/2011/3/7/302

-- 
Catalin
