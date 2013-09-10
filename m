Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3IJVyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:54:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3IJVx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:53:58 -0400
Date: Tue, 10 Sep 2013 17:53:29 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Message-ID: <1378850009-y4wd5ph0-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130910144109.GR22421@suse.de>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1376025702-14818-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130910144109.GR22421@suse.de>
Subject: Re: [PATCH 5/9] mbind: add hugepage migration code to mbind()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130910144109.GR22421@suse.de>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 03:41:09PM +0100, Mel Gorman wrote:
> On Fri, Aug 09, 2013 at 01:21:38AM -0400, Naoya Horiguchi wrote:
> > This patch extends do_mbind() to handle vma with VM_HUGETLB set.
> > We will be able to migrate hugepage with mbind(2) after
> > applying the enablement patch which comes later in this series.
> > 
> > ChangeLog v3:
> >  - revert introducing migrate_movable_pages
> >  - added alloc_huge_page_noerr free from ERR_VALUE
> > 
> > ChangeLog v2:
> >  - updated description and renamed patch title
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Acked-by: Andi Kleen <ak@linux.intel.com>
> > Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> > Acked-by: Hillf Danton <dhillf@gmail.com>
> > ---
> >  include/linux/hugetlb.h |  3 +++
> >  mm/hugetlb.c            | 14 ++++++++++++++
> >  mm/mempolicy.c          |  4 +++-
> >  3 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git v3.11-rc3.orig/include/linux/hugetlb.h v3.11-rc3/include/linux/hugetlb.h
> > index bc8d837..d1db007 100644
> > --- v3.11-rc3.orig/include/linux/hugetlb.h
> > +++ v3.11-rc3/include/linux/hugetlb.h
> > @@ -265,6 +265,8 @@ struct huge_bootmem_page {
> >  };
> >  
> >  struct page *alloc_huge_page_node(struct hstate *h, int nid);
> > +struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
> > +				unsigned long addr, int avoid_reserve);
> >  
> >  /* arch callback */
> >  int __init alloc_bootmem_huge_page(struct hstate *h);
> > @@ -378,6 +380,7 @@ static inline pgoff_t basepage_index(struct page *page)
> >  #else	/* CONFIG_HUGETLB_PAGE */
> >  struct hstate {};
> >  #define alloc_huge_page_node(h, nid) NULL
> > +#define alloc_huge_page_noerr(v, a, r) NULL
> >  #define alloc_bootmem_huge_page(h) NULL
> >  #define hstate_file(f) NULL
> >  #define hstate_sizelog(s) NULL
> > diff --git v3.11-rc3.orig/mm/hugetlb.c v3.11-rc3/mm/hugetlb.c
> > index 649771c..ee764b0 100644
> > --- v3.11-rc3.orig/mm/hugetlb.c
> > +++ v3.11-rc3/mm/hugetlb.c
> > @@ -1195,6 +1195,20 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
> >  	return page;
> >  }
> >  
> > +/*
> > + * alloc_huge_page()'s wrapper which simply returns the page if allocation
> > + * succeeds, otherwise NULL. This function is called from new_vma_page(),
> > + * where no ERR_VALUE is expected to be returned.
> > + */
> > +struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
> > +				unsigned long addr, int avoid_reserve)
> > +{
> > +	struct page *page = alloc_huge_page(vma, addr, avoid_reserve);
> > +	if (IS_ERR(page))
> > +		page = NULL;
> > +	return page;
> > +}
> > +
> >  int __weak alloc_bootmem_huge_page(struct hstate *h)
> >  {
> >  	struct huge_bootmem_page *m;
> > diff --git v3.11-rc3.orig/mm/mempolicy.c v3.11-rc3/mm/mempolicy.c
> > index d96afc1..4a03c14 100644
> > --- v3.11-rc3.orig/mm/mempolicy.c
> > +++ v3.11-rc3/mm/mempolicy.c
> > @@ -1183,6 +1183,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
> >  		vma = vma->vm_next;
> >  	}
> >  
> > +	if (PageHuge(page))
> > +		return alloc_huge_page_noerr(vma, address, 1);
> >  	/*
> >  	 * if !vma, alloc_page_vma() will use task or system default policy
> >  	 */
> 
> It's interesting to note that it will be tricky to configure a system to
> allow this sort of migration to succeed.
> 
> This call correctly uses avoid_reserve but that does mean that for it
> to work that there there must be free pages statically allocated in the
> hugepage pool of the destination node or hugepage dynamic pool resizing
> must be enabled. The former option is going to waste memory because pages
> allocated to the static pool cannot be used for any other purpose and
> using dynamic hugepage pool resizing may fail.

Yes, that's interesting because it's important to make page migration
more likely to succeed. I guess that dynamic pool resizing can affect
the pool configuration without administrators' knowing, so allocating
surplus hugepages directly from buddy seems more preferable.

> It makes me wonder how actually useful generic hugetlbfs page migration
> will be in practice. Are there really usecases where the system
> administrator is willing to create unused hugepage pools on each node
> just to enable migration?

Maybe most users don't want it.

Thanks,
Naoya Horiguchi

> > @@ -1293,7 +1295,7 @@ static long do_mbind(unsigned long start, unsigned long len,
> >  					(unsigned long)vma,
> >  					MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
> >  			if (nr_failed)
> > -				putback_lru_pages(&pagelist);
> > +				putback_movable_pages(&pagelist);
> >  		}
> >  
> >  		if (nr_failed && (flags & MPOL_MF_STRICT))
> > -- 
> > 1.8.3.1
> > 
> 
> -- 
> Mel Gorman
> SUSE Labs
>
