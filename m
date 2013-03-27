Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3C0Nwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:52:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab3C0Nww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:52:52 -0400
Date: Wed, 27 Mar 2013 14:52:50 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] soft-offline: use migrate_pages() instead of
 migrate_huge_page()
Message-ID: <20130327135250.GI16579@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87boa69z6j.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87boa69z6j.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-03-13 16:59:40, Aneesh Kumar K.V wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
[...]
> > diff --git v3.9-rc3.orig/mm/memory-failure.c v3.9-rc3/mm/memory-failure.c
> > index df0694c..4e01082 100644
> > --- v3.9-rc3.orig/mm/memory-failure.c
> > +++ v3.9-rc3/mm/memory-failure.c
> > @@ -1467,6 +1467,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
> >  	int ret;
> >  	unsigned long pfn = page_to_pfn(page);
> >  	struct page *hpage = compound_head(page);
> > +	LIST_HEAD(pagelist);
> >
> >  	/*
> >  	 * This double-check of PageHWPoison is to avoid the race with
> > @@ -1482,12 +1483,20 @@ static int soft_offline_huge_page(struct page *page, int flags)
> >  	unlock_page(hpage);
> >
> >  	/* Keep page count to indicate a given hugepage is isolated. */
> > -	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL,
> > -				MIGRATE_SYNC);
> > -	put_page(hpage);
> > +	list_move(&hpage->lru, &pagelist);
> 
> we use hpage->lru to add the hpage to h->hugepage_activelist. This will
> break a hugetlb cgroup removal isn't it ?

This particular part will not break removal because
hugetlb_cgroup_css_offline loops until hugetlb_cgroup_have_usage is 0.

Little bit offtopic:
Btw. hugetlb migration breaks to charging even before this patchset
AFAICS. The above put_page should remove the last reference and then it
will uncharge it but I do not see anything that would charge a new page.
This is all because regula LRU pages are uncharged when they are
unmapped. But this a different story not related to this series.

[...]
-- 
Michal Hocko
SUSE Labs
