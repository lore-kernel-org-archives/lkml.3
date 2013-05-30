Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab3E3FCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:02:36 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:38046 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3E3FC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:02:28 -0400
Message-ID: <51A6DD52.406@synopsys.com>
Date: Thu, 30 May 2013 10:32:10 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] mm: Fix the TLB range flushed when __tlb_remove_page()
 runs out of slots
References: <1369832173-15088-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1369832173-15088-1-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+alex.shi@intel.com]

On 05/29/2013 06:26 PM, Vineet Gupta wrote:
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
>  
>  	return addr;
> 

