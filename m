Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaDDWDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:03:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaDDWDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:03:47 -0400
Date: Fri, 4 Apr 2014 15:03:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, andi@firstfloor.org,
        sasha.levin@oracle.com, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.vnet.ibm.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm/hugetlb.c: add NULL check of return value of
 huge_pte_offset
Message-Id: <20140404150345.92400430db3111fe21df7c7f@linux-foundation.org>
In-Reply-To: <533efd68.435fe00a.6936.ffffa5e7SMTPIN_ADDED_BROKEN@mx.google.com>
References: <533efd68.435fe00a.6936.ffffa5e7SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2014 14:43:33 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> huge_pte_offset() could return NULL, so we need NULL check to avoid
> potential NULL pointer dereferences.
> 
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2662,7 +2662,8 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  				BUG_ON(huge_pte_none(pte));
>  				spin_lock(ptl);
>  				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
> -				if (likely(pte_same(huge_ptep_get(ptep), pte)))
> +				if (likely(ptep &&
> +					   pte_same(huge_ptep_get(ptep), pte)))
>  					goto retry_avoidcopy;
>  				/*
>  				 * race occurs while re-acquiring page table
> @@ -2706,7 +2707,7 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  	 */
>  	spin_lock(ptl);
>  	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
> -	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
> +	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
>  		ClearPagePrivate(new_page);
>  
>  		/* Break COW */

Has anyone been hitting oopses here or was this from code inspection?
