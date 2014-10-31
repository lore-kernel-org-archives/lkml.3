Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaJaJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:28:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967AbaJaJ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:28:14 -0400
Date: Fri, 31 Oct 2014 10:28:12 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC patch] mm: hugetlb: fix __unmap_hugepage_range
Message-ID: <20141031092812.GB16840@dhcp22.suse.cz>
References: <028701cff4c2$3e9e2ca0$bbda85e0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <028701cff4c2$3e9e2ca0$bbda85e0$@alibaba-inc.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing people involved in 24669e58477e2]

On Fri 31-10-14 12:22:12, Hillf Danton wrote:
> First, after flushing TLB, we have no need to scan pte from start again.
> Second, before bail out loop, the address is forwarded one step.

I can imagine a more comprehensive wording here. It is not immediately
clear whether this is just an optimization or a bug fix as well
(especially the second part).

Anyway the optimization looks good to me.

> Signed-off-by: Hillf Danton <hillf.zj@alibaba-inc.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
> 
> --- a/mm/hugetlb.c	Fri Oct 31 11:47:25 2014
> +++ b/mm/hugetlb.c	Fri Oct 31 11:52:42 2014
> @@ -2641,8 +2641,9 @@ void __unmap_hugepage_range(struct mmu_g
>  
>  	tlb_start_vma(tlb, vma);
>  	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
> +	address = start;
>  again:
> -	for (address = start; address < end; address += sz) {
> +	for (; address < end; address += sz) {
>  		ptep = huge_pte_offset(mm, address);
>  		if (!ptep)
>  			continue;
> @@ -2689,6 +2690,7 @@ again:
>  		page_remove_rmap(page);
>  		force_flush = !__tlb_remove_page(tlb, page);
>  		if (force_flush) {
> +			address += sz;
>  			spin_unlock(ptl);
>  			break;
>  		}
> --
> 
> 

-- 
Michal Hocko
SUSE Labs
