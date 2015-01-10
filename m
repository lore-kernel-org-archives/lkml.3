Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbbAJNhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 08:37:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59334 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbAJNhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 08:37:51 -0500
Date: Sat, 10 Jan 2015 13:37:42 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laszlo Ersek <lersek@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150110133742.GA6999@arm.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
 <54AE7D53.2020305@redhat.com>
 <20150109121348.GD12942@leverpostej>
 <CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>
 <54AFE53A.4020004@redhat.com>
 <20150109175702.GA27787@leverpostej>
 <54B01FF0.3020900@arm.com>
 <20150109194333.GA23028@arm.com>
 <54B09CA3.1060501@redhat.com>
 <CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Laszlo,

On Sat, Jan 10, 2015 at 04:39:05AM +0000, Linus Torvalds wrote:
> On Fri, Jan 9, 2015 at 7:29 PM, Laszlo Ersek <lersek@redhat.com> wrote:
> > I've bisected this issue to

Thanks for bisecting this!

> .. commit f045bbb9fa1b ("mmu_gather: fix over-eager
> tlb_flush_mmu_free() calling")
> 
> Hmm. That commit literally just undoes something that commit
> fb7332a9fedf ("mmu_gather: move minimal range calculations into
> generic code") changed, and that was very wrong on x86.
> 
> But arm64 did have very different TLB flushing logic, so there may be
> some ARM64 reason that Will did that change originally, and then he
> forgot that reason when he ack'ed commit f045bbb9fa1b that undid it.
> 
> Will?

I'm wondering if this is now broken in the fullmm case, because tlb->end
will be zero and we won't actually free any of the pages being unmapped
on task exit. Does that sound plausible?

> Before your mmu_gather range calculations commit, we used to have
> 
> In tlb_flush_mmu_tlbonly():
> 
>      tlb->need_flush = 0;
> 
> and in tlb_flush_mmu():
> 
>     if (!tlb->need_flush)
>                 return;
> 
> and your commit changed the rule to be
> 
>     !tlb->need_flush == !tlb->end
> 
> so in the current tree we have
> 
>  In tlb_flush_mmu_tlbonly():
> 
>     __tlb_reset_range(tlb);   // replaces "tlb->need_flush = 0;"
> 
> and in tlb_flush_mmu():
> 
>     if (!tlb->end)    // replaces if (!tlb->need_flush)
>         return;
> 
> so we seem to do exactly the same as 3.18.
> 
> But in your original patch, you moved that "if (!tlb->end) return;"
> check from tlb_flush_mmu() into tlb_flush_mmu_tlbonly(), and that
> apparently is actually needed on arm64. But *why*?

My hunch is that when a task exits and sets fullmm, end is zero and so the
old need_flush cases no longer run. With my original patch, we skipped the
TLB invalidation (since the task is exiting and we will invalidate the TLB
for that ASID before the ASID is reallocated) but still did the freeing.
With the current code, we skip the freeing too, which causes us to leak
pages on exit.

> Also, looking at that commit fb7332a9fedf, I note that some of the
> "need_flush" setting was simply removed. See for example
> arch/powerpc/mm/hugetlbpage.c, and also in mm/memory.c:
> tlb_remove_table(). Is there something non-obvious that sets tlb->end
> there?

I figured that need_flush was already set in these cases, so the additional
setting was redundant:

  https://lkml.org/lkml/2014/11/10/340

> The other need_flush removals seem to all be paired with adding a
> __tlb_adjust_range() call, which will set ->end.
> 
> I'm starting to suspect that you moved the need_flush test into
> tlbonly exactly because you removed that
> 
>         tlb->need_flush = 1;
> 
> from mm/memory.c: tlb_remove_table().
> 
> x86 doesn't care, because x86 doesn't *use* tlb_remove_table(). But
> arm64 does, at least with the RCU freeing.
> 
> Any ideas?

I guess we can either check need_flush as well as end, or we could set both
start == end == some_nonzero_value in __tlb_adjust_range when need_flush is
set. Unfortunately, I'm away from my h/w right now, so it's not easy to test
this.

What do you reckon?

Will
