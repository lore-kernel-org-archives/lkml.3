Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab3LIQN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:13:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab3LIQN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:13:57 -0500
Message-ID: <52A5EC3E.2050301@redhat.com>
Date: Mon, 09 Dec 2013 11:13:50 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/18] mm: numa: Defer TLB flush for THP migration as
 long as possible
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-13-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-13-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:09 AM, Mel Gorman wrote:

> diff --git a/mm/migrate.c b/mm/migrate.c
> index cfb4190..5372521 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1759,6 +1759,12 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
>  		goto out_fail;
>  	}
>  
> +	/* PTL provides a memory barrier with change_protection_range */
> +	ptl = pmd_lock(mm, pmd);
> +	if (tlb_flush_pending(mm))
> +		flush_tlb_range(vma, mmun_start, mmun_end);
> +	spin_unlock(ptl);
> +
>  	/* Prepare a page as a migration target */
>  	__set_page_locked(new_page);
>  	SetPageSwapBacked(new_page);

I don't think there is a need for that extra memory barrier.

On the "set_tlb_flush_pending, turn ptes into NUMA ones" side, we
have a barrier in the form of the page table lock.

We only end up in this code path if the pte/pmd already is a NUMA
one, and we take several spinlocks along the way to doing this test.
That provides for the memory barrier in this code path.

-- 
All rights reversed
