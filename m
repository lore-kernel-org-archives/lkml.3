Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3GWH30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:29:26 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43605 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3GWH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:29:25 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-7d-51ee30d309b7
Date: Tue, 23 Jul 2013 16:29:28 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] mm, hugetlb: clean-up alloc_huge_page()
Message-ID: <20130723072928.GB2266@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1373881967-16153-4-git-send-email-iamjoonsoo.kim@lge.com>
 <20130722145150.GF24400@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722145150.GF24400@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 04:51:50PM +0200, Michal Hocko wrote:
> On Mon 15-07-13 18:52:41, Joonsoo Kim wrote:
> > We can unify some codes for succeed allocation.
> > This makes code more readable.
> > There is no functional difference.
> 
> "This patch unifies successful allocation paths to make the code more
> readable. There are no functional changes."
> 
> Better?

Better :)

Thanks.

> 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index d21a33a..0067cf4 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1144,29 +1144,25 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
> >  		hugepage_subpool_put_pages(spool, chg);
> >  		return ERR_PTR(-ENOSPC);
> >  	}
> > +
> >  	spin_lock(&hugetlb_lock);
> >  	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
> > -	if (page) {
> > -		/* update page cgroup details */
> > -		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
> > -					     h_cg, page);
> > -		spin_unlock(&hugetlb_lock);
> > -	} else {
> > +	if (!page) {
> >  		spin_unlock(&hugetlb_lock);
> >  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
> >  		if (!page) {
> >  			hugetlb_cgroup_uncharge_cgroup(idx,
> > -						       pages_per_huge_page(h),
> > -						       h_cg);
> > +						pages_per_huge_page(h), h_cg);
> >  			hugepage_subpool_put_pages(spool, chg);
> >  			return ERR_PTR(-ENOSPC);
> >  		}
> > +
> >  		spin_lock(&hugetlb_lock);
> > -		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
> > -					     h_cg, page);
> >  		list_move(&page->lru, &h->hugepage_activelist);
> > -		spin_unlock(&hugetlb_lock);
> > +		/* Fall through */
> >  	}
> > +	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
> > +	spin_unlock(&hugetlb_lock);
> >  
> >  	set_page_private(page, (unsigned long)spool);
> >  
> > -- 
> > 1.7.9.5
> > 
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
