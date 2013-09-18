Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3IRBTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:19:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45591 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3IRBTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:19:09 -0400
Message-ID: <5238FF3A.2070500@oracle.com>
Date: Wed, 18 Sep 2013 09:17:46 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>
CC: Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC PATCH RESEND] mm: munlock: Prevent walking off the end of
 a pagetable in no-pmd configuration
References: <52385A59.2080304@suse.cz> <1379427739-31451-1-git-send-email-vbabka@suse.cz>
In-Reply-To: <1379427739-31451-1-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 10:22 PM, Vlastimil Babka wrote:
> The function __munlock_pagevec_fill() introduced in commit 7a8010cd3
> ("mm: munlock: manual pte walk in fast path instead of follow_page_mask()")
> uses pmd_addr_end() for restricting its operation within current page table.
> This is insufficient on architectures/configurations where pmd is folded
> and pmd_addr_end() just returns the end of the full range to be walked. In
> this case, it allows pte++ to walk off the end of a page table resulting in
> unpredictable behaviour.
> 
> This patch fixes the function by using pgd_addr_end() and pud_addr_end()
> before pmd_addr_end(), which will yield correct page table boundary on all
> configurations. This is similar to what existing page walkers do when walking
> each level of the page table.
> 
> Additionaly, the patch clarifies a comment for get_locked_pte() call in the
> function.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Jörn Engel <joern@logfs.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mlock.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index d638026..758c0fc 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -379,10 +379,14 @@ static unsigned long __munlock_pagevec_fill(struct pagevec *pvec,
>  
>  	/*
>  	 * Initialize pte walk starting at the already pinned page where we
> -	 * are sure that there is a pte.
> +	 * are sure that there is a pte, as it was pinned under the same
> +	 * mmap_sem write op.
>  	 */
>  	pte = get_locked_pte(vma->vm_mm, start,	&ptl);
> -	end = min(end, pmd_addr_end(start, end));
> +	/* Make sure we do not cross the page table boundary */
> +	end = pgd_addr_end(start, end);
> +	end = pud_addr_end(start, end);
> +	end = pmd_addr_end(start, end);
>  

Nitpick, how about unfolding pmd_addr_end(start, end) directly? Like:

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -376,13 +376,14 @@ static unsigned long __munlock_pagevec_fill(struct
pagevec *pvec,
 {
        pte_t *pte;
        spinlock_t *ptl;
+       unsigned long pmd_end = (start + PMD_SIZE) & PMD_MASK;
+       end = (pmd_end - 1 < end - 1) ? pmd_end : end;

        /*
         * Initialize pte walk starting at the already pinned page where we
         * are sure that there is a pte.
         */
        pte = get_locked_pte(vma->vm_mm, start, &ptl);
-       end = min(end, pmd_addr_end(start, end));

        /* The page next to the pinned page is the first we will try to
get */
        start += PAGE_SIZE;

Anyway,
Reviewed-by: Bob Liu <bob.liu@oracle.com>

-- 
Regards,
-Bob
