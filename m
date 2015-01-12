Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbbALNXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:23:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbbALNXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:23:03 -0500
Message-ID: <54B3CA8E.8050100@redhat.com>
Date: Mon, 12 Jan 2015 07:22:22 -0600
From: Mark Langsdorf <mlangsdo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Laszlo Ersek <lersek@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>, dave@sr71.net
Subject: Re: Linux 3.19-rc3
References: <20150109121348.GD12942@leverpostej> <CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com> <54AFE53A.4020004@redhat.com> <20150109175702.GA27787@leverpostej> <54B01FF0.3020900@arm.com> <20150109194333.GA23028@arm.com> <54B09CA3.1060501@redhat.com> <CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com> <20150110133742.GA6999@arm.com> <CA+55aFxBA6F4Kr89iZwPPeBnkiRO4GnrbUSd0CqVG-LD6ZQyiw@mail.gmail.com> <20150112124256.GB13360@arm.com>
In-Reply-To: <20150112124256.GB13360@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 06:42 AM, Will Deacon wrote:
> On Sat, Jan 10, 2015 at 07:51:03PM +0000, Linus Torvalds wrote:
>> I can revert the commit that causes problems, but considering the
>> performance impact on x86 (it would be a regression since 3.18), I
>> would *really* like to fix the arm64 problem instead. So I'll wait
>> with the revert for at least a week, I think, hoping that the arm64
>> people figure this out. Sound reasonable?
>
> Sure. I've put together the following patch which:
>
>    (1) Uses tlb->end != 0 only as the predicate for TLB invalidation
>
>    (2) Uses tlb->local.nr as the predicate for page freeing in
>        tlb_flush_mmu_free
>
>    (3) Ensures tlb->end != 0 for the fullmm case (I think this was a
>        benign change introduced by my original patch, but this puts us
>        back to 3.18 behaviour)
>
> Since this effectively reverts f045bbb9fa1b, I've added Dave to Cc. It
> should fix the leak without reintroducing the performance regression.
>
> Linus: this moves the tlb->end check back into tlb_flush_mmu_tlbonly.
> How much do you hate that?
>
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 08848050922e..db284bff29dc 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -136,8 +136,12 @@ static inline void __tlb_adjust_range(struct mmu_gather *tlb,
>
>   static inline void __tlb_reset_range(struct mmu_gather *tlb)
>   {
> -	tlb->start = TASK_SIZE;
> -	tlb->end = 0;
> +	if (tlb->fullmm) {
> +		tlb->start = tlb->end = ~0;
> +	} else {
> +		tlb->start = TASK_SIZE;
> +		tlb->end = 0;
> +	}
>   }
>
>   /*
> diff --git a/mm/memory.c b/mm/memory.c
> index c6565f00fb38..54f3a9b00956 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -235,6 +235,9 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long
>
>   static void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
>   {
> +	if (!tlb->end)
> +		return;
> +
>   	tlb_flush(tlb);
>   	mmu_notifier_invalidate_range(tlb->mm, tlb->start, tlb->end);
>   #ifdef CONFIG_HAVE_RCU_TABLE_FREE
> @@ -247,7 +250,7 @@ static void tlb_flush_mmu_free(struct mmu_gather *tlb)
>   {
>   	struct mmu_gather_batch *batch;
>
> -	for (batch = &tlb->local; batch; batch = batch->next) {
> +	for (batch = &tlb->local; batch && batch->nr; batch = batch->next) {
>   		free_pages_and_swap_cache(batch->pages, batch->nr);
>   		batch->nr = 0;
>   	}
> @@ -256,9 +259,6 @@ static void tlb_flush_mmu_free(struct mmu_gather *tlb)
>
>   void tlb_flush_mmu(struct mmu_gather *tlb)
>   {
> -	if (!tlb->end)
> -		return;
> -
>   	tlb_flush_mmu_tlbonly(tlb);
>   	tlb_flush_mmu_free(tlb);
>   }
>

This fixes the originally reported problem. I have no opinion on
moving the tlb->end check back into tlb_flush_mmu_tlbonly.

Tested-by: Mark Langsdorf <mlangsdo@redhat.com>
