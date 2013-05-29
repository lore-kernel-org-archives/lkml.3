Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966735Ab3E2OEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:04:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46249 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966606Ab3E2OED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:04:03 -0400
Date: Wed, 29 May 2013 15:03:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] mm: Fix the TLB range flushed when __tlb_remove_page()
 runs out of slots
Message-ID: <20130529140319.GK17767@MacBook-Pro.local>
References: <1369832173-15088-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369832173-15088-1-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 01:56:13PM +0100, Vineet Gupta wrote:
> zap_pte_range loops from @addr to @end. In the middle, if it runs out of
> batching slots, TLB entries needs to be flushed for @start to @interim,
> NOT @interim to @end.
> 
> Since ARC port doesn't use page free batching I can't test it myself but
> this seems like the right thing to do.
> Observed this when working on a fix for the issue at thread:
> 	http://www.spinics.net/lists/linux-arch/msg21736.html
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: linux-arch@vger.kernel.org <linux-arch@vger.kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  mm/memory.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6dc1882..d9d5fd9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1110,6 +1110,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  	spinlock_t *ptl;
>  	pte_t *start_pte;
>  	pte_t *pte;
> +	unsigned long range_start = addr;
>  
>  again:
>  	init_rss_vec(rss);
> @@ -1215,12 +1216,14 @@ again:
>  		force_flush = 0;
>  
>  #ifdef HAVE_GENERIC_MMU_GATHER
> -		tlb->start = addr;
> -		tlb->end = end;
> +		tlb->start = range_start;
> +		tlb->end = addr;
>  #endif
>  		tlb_flush_mmu(tlb);
> -		if (addr != end)
> +		if (addr != end) {
> +			range_start = addr;
>  			goto again;
> +		}
>  	}

Isn't this code only run if force_flush != 0? force_flush is set to
!__tlb_remove_page() and this function always returns 1 on (generic TLB)
UP since tlb_fast_mode() is 1. There is no batching on UP with the
generic TLB code.

-- 
Catalin
