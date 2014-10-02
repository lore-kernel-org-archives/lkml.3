Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaJBT7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:59:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:58224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJBT7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:59:08 -0400
Date: Thu, 2 Oct 2014 21:59:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: mempolicy: Skip inaccessible VMAs when setting
 MPOL_MF_LAZY
Message-ID: <20141002195903.GE10583@worktop.programming.kicks-ass.net>
References: <20141002191703.GN17501@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002191703.GN17501@suse.de>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 08:17:03PM +0100, Mel Gorman wrote:
> PROT_NUMA VMAs are skipped to avoid problems distinguishing between
> present, prot_none and special entries. MPOL_MF_LAZY is not visible from
> userspace since commit a720094ded8c ("mm: mempolicy: Hide MPOL_NOOP and
> MPOL_MF_LAZY from userspace for now") but it should still skip VMAs the
> same way task_numa_work does.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: Peter Zijlstra <peterz@infradead.org>

> ---
>  mm/mempolicy.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 8f5330d..a5877ce 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -683,7 +683,9 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
>  		}
>  
>  		if (flags & MPOL_MF_LAZY) {
> -			change_prot_numa(vma, start, endvma);
> +			/* Similar to task_numa_work, skip inaccessible VMAs */
> +			if (vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
> +				change_prot_numa(vma, start, endvma);
>  			goto next;
>  		}
>  
