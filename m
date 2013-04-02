Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713Ab3DBJpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:45:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761070Ab3DBJp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:45:27 -0400
Date: Tue, 2 Apr 2013 11:45:24 +0200
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
Message-ID: <20130402094524.GF24345@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87boa69z6j.fsf@linux.vnet.ibm.com>
 <20130327135250.GI16579@dhcp22.suse.cz>
 <874nfqesut.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nfqesut.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-04-13 10:43:14, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko@suse.cz> writes:
> 
> > On Tue 26-03-13 16:59:40, Aneesh Kumar K.V wrote:
> >> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> > [...]
> >> > diff --git v3.9-rc3.orig/mm/memory-failure.c v3.9-rc3/mm/memory-failure.c
> >> > index df0694c..4e01082 100644
> >> > --- v3.9-rc3.orig/mm/memory-failure.c
> >> > +++ v3.9-rc3/mm/memory-failure.c
> >> > @@ -1467,6 +1467,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
> >> >  	int ret;
> >> >  	unsigned long pfn = page_to_pfn(page);
> >> >  	struct page *hpage = compound_head(page);
> >> > +	LIST_HEAD(pagelist);
> >> >
> >> >  	/*
> >> >  	 * This double-check of PageHWPoison is to avoid the race with
> >> > @@ -1482,12 +1483,20 @@ static int soft_offline_huge_page(struct page *page, int flags)
> >> >  	unlock_page(hpage);
> >> >
> >> >  	/* Keep page count to indicate a given hugepage is isolated. */
> >> > -	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL,
> >> > -				MIGRATE_SYNC);
> >> > -	put_page(hpage);
> >> > +	list_move(&hpage->lru, &pagelist);
> >> 
> >> we use hpage->lru to add the hpage to h->hugepage_activelist. This will
> >> break a hugetlb cgroup removal isn't it ?
> >
> > This particular part will not break removal because
> > hugetlb_cgroup_css_offline loops until hugetlb_cgroup_have_usage is 0.
> >
> 
> But we still need to hold hugetlb_lock around that right ?

Right. Racing hugetlb_cgroup_move_parent and hugetlb_cgroup_migrate could
lead to newpage pointing to NULL cgroup. That could be fixed by checking
old page cgroup for NULL inside hugetlb_lock and using
list_for_each_safe in hugetlb_cgroup_css_offline no?
-- 
Michal Hocko
SUSE Labs
