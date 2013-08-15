Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab3HOSyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:54:44 -0400
Received: from canardo.mork.no ([148.122.252.1]:38303 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab3HOSyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:54:43 -0400
X-Greylist: delayed 1455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Aug 2013 14:54:42 EDT
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Tebulin <tebulin@googlemail.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please revert 53a59fc67!
Organization: m
References: <52050382.9060802@gmail.com> <520BB225.8030807@gmail.com>
	<20130814174039.GA24033@dhcp22.suse.cz>
	<CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com>
	<20130814182756.GD24033@dhcp22.suse.cz>
	<CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com>
	<520C9E78.2020401@gmail.com>
	<CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
	<CA+55aFxuUrcod=X2t2yqR_zJ4s1uaCsGB-p1oLTQrG+y+Z2PbA@mail.gmail.com>
Date: Thu, 15 Aug 2013 20:29:11 +0200
In-Reply-To: <CA+55aFxuUrcod=X2t2yqR_zJ4s1uaCsGB-p1oLTQrG+y+Z2PbA@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 15 Aug 2013 11:00:03 -0700")
Message-ID: <87ioz67qq0.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Comments? Especially s390, ARM, ia64, sh and um that I edited blindly...

I can see that :-)  You have a couple of "unsigned logn"s here.


Bjørn

> --- a/arch/arm64/include/asm/tlb.h
> +++ b/arch/arm64/include/asm/tlb.h
> @@ -35,6 +35,7 @@ struct mmu_gather {
>  	struct mm_struct	*mm;
>  	unsigned int		fullmm;
>  	struct vm_area_struct	*vma;
> +	unsigned long		start, end;
>  	unsigned long		range_start;
>  	unsigned long		range_end;
>  	unsigned int		nr;
> @@ -97,10 +98,12 @@ static inline void tlb_flush_mmu(struct mmu_gather *tlb)
>  }
>  
>  static inline void
> -tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int fullmm)
> +tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned logn end)

[..]

> diff --git a/arch/sh/include/asm/tlb.h b/arch/sh/include/asm/tlb.h
> index e61d43d9f689..47745b255721 100644
> --- a/arch/sh/include/asm/tlb.h
> +++ b/arch/sh/include/asm/tlb.h
> @@ -36,10 +36,12 @@ static inline void init_tlb_gather(struct mmu_gather *tlb)
>  }
>  
>  static inline void
> -tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
> +tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned long start, unsigned logn end)
