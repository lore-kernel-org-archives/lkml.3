Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaLDAKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:10:00 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45673 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLDAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:09:58 -0500
Date: Wed, 3 Dec 2014 16:09:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 2/9] mm: replace ACCESS_ONCE with READ_ONCE or barriers
Message-ID: <20141204000952.GY25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
 <1417645821-54731-3-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417645821-54731-3-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120400-0033-0000-0000-000002E30316
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:30:14PM +0100, Christian Borntraeger wrote:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> 
> Let's change the code to access the page table elements with
> READ_ONCE that does implicit scalar accesses.
> 
> mm_find_pmd is tricky, because m68k and sparc(32bit) define pmd_t
> as array of longs. This code requires just that the pmd_present
> and pmd_trans_huge check are done on the same value, so a barrier
> is sufficent.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  mm/gup.c    | 2 +-
>  mm/memory.c | 2 +-
>  mm/rmap.c   | 3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index cd62c8c..f2305de 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -917,7 +917,7 @@ static int gup_pud_range(pgd_t *pgdp, unsigned long addr, unsigned long end,
> 
>  	pudp = pud_offset(pgdp, addr);
>  	do {
> -		pud_t pud = ACCESS_ONCE(*pudp);
> +		pud_t pud = READ_ONCE(*pudp);
> 
>  		next = pud_addr_end(addr, end);
>  		if (pud_none(pud))
> diff --git a/mm/memory.c b/mm/memory.c
> index 3e50383..9e0c84e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3202,7 +3202,7 @@ static int handle_pte_fault(struct mm_struct *mm,
>  	pte_t entry;
>  	spinlock_t *ptl;
> 
> -	entry = ACCESS_ONCE(*pte);
> +	entry = READ_ONCE(*pte);
>  	if (!pte_present(entry)) {
>  		if (pte_none(entry)) {
>  			if (vma->vm_ops) {
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 19886fb..1e54274 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -581,7 +581,8 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
>  	 * without holding anon_vma lock for write.  So when looking for a
>  	 * genuine pmde (in which to find pte), test present and !THP together.
>  	 */
> -	pmde = ACCESS_ONCE(*pmd);
> +	pmde = *pmd;
> +	barrier();
>  	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
>  		pmd = NULL;
>  out:
> -- 
> 1.9.3
> 

