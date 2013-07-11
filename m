Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3GKLV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:21:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41608 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab3GKLV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:21:57 -0400
Date: Thu, 11 Jul 2013 13:21:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] mm: numa: Do not migrate or account for hinting
 faults on the zero page
Message-ID: <20130711112102.GF25631@dyad.programming.kicks-ass.net>
References: <1373536020-2799-1-git-send-email-mgorman@suse.de>
 <1373536020-2799-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373536020-2799-5-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 10:46:48AM +0100, Mel Gorman wrote:
> +++ b/mm/memory.c
> @@ -3560,8 +3560,13 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	set_pte_at(mm, addr, ptep, pte);
>  	update_mmu_cache(vma, addr, ptep);
>  
> +	/*
> +	 * Do not account for faults against the huge zero page. The read-only

s/huge //

> +	 * data is likely to be read-cached on the local CPUs and it is less
> +	 * useful to know about local versus remote hits on the zero page.
> +	 */
>  	page = vm_normal_page(vma, addr, pte);
> -	if (!page) {
> +	if (!page || is_zero_pfn(page_to_pfn(page))) {
>  		pte_unmap_unlock(ptep, ptl);
>  		return 0;
>  	}
> -- 
> 1.8.1.4
> 
