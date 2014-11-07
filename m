Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaKGQuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:50:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54740 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaKGQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:50:30 -0500
Date: Fri, 7 Nov 2014 16:50:04 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141107165003.GG29148@e104818-lin.cambridge.arm.com>
References: <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
 <20141029194738.GA29911@arm.com>
 <20141104142955.GA24816@e104818-lin.cambridge.arm.com>
 <CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com>
 <20141106135740.GC19702@e104818-lin.cambridge.arm.com>
 <CA+55aFzQM-yvvXYENiviLBm0=jiZoO7xPmz5mLowuTb-Pb8e6Q@mail.gmail.com>
 <20141106183808.GH19702@e104818-lin.cambridge.arm.com>
 <CA+55aFwE847pZgOpcLuZah6qhMDPV1v8oUpTV1_ROQNTtWhZKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwE847pZgOpcLuZah6qhMDPV1v8oUpTV1_ROQNTtWhZKQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:29:54PM +0000, Linus Torvalds wrote:
> On Thu, Nov 6, 2014 at 10:38 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Thu, Nov 06, 2014 at 05:53:58PM +0000, Linus Torvalds wrote:
> >
> > Sorry, I wasn't clear enough about the "increments" part. I agreed with
> > not using end = start + PMD_SIZE/PAGE_SIZE from your previous email
> > already.
> 
> Ahh, I misunderstood. You're really just after the granularity of tlb flushes.

Yes. The granularity would also help when tearing down page tables as
the granule would be PMD_SIZE.

> That's fine. That makes sense. In fact, how about adding "granularity"
> to the mmu_gather structure, and then doing:\
> 
>  - in __tlb_reset_range(), setting it to ~0ul
> 
>  - add "granularity" to __tlb_adjust_range(), and make it do something like
> 
>        if (!tlb->fullmm) {
>                tlb->granularity = min(tlb->granularity, granularity);
>                tlb->start = min(tlb->start, address);
>                tlb->end = max(tlb->end, address+1);
>        }
> 
> and then the TLB flush logic would basically do
> 
>    address = tlb->start;
>    do {
>         flush(address);
>         if (address + tlb->granularity < address)
>                 break;
>         address = address + tlb->granularity;
>    } while (address < tlb->end);
> 
> or something like that.

Indeed. We'll come up with a patch after Will's clean-up.

> Now, if you unmap mixed ranges of large-pages and regular pages, you'd
> still have that granularity of one page, but quite frankly, if you do
> that, you probably deserve it. The common case is almost certainly
> going to be just "unmap large pages" or "unmap normal pages".

I think this could only happen with transparent huge pages that replaced
small pages in an anonymous mapping. I don't think munmap'ing them
happens very often.

Thanks.

-- 
Catalin
