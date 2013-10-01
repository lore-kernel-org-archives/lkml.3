Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3JABPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 21:15:37 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45438 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3JABPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 21:15:36 -0400
X-AuditID: 9c93017e-b7ca5ae0000013bb-84-524a2236f654
Date: Tue, 1 Oct 2013 10:16:30 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] mm, hugetlb: correct missing private flag clearing
Message-ID: <20131001011630.GA21009@lge.com>
References: <1380527985-18499-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130930143514.63fc5b2b4316caed33e1c1b1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930143514.63fc5b2b4316caed33e1c1b1@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 02:35:14PM -0700, Andrew Morton wrote:
> On Mon, 30 Sep 2013 16:59:44 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > We should clear the page's private flag when returing the page to
> > the page allocator or the hugepage pool. This patch fixes it.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> > Hello, Andrew.
> > 
> > I sent the new version of commit ('07443a8') before you did pull request,
> > but it isn't included. It may be losted :)
> > So I send this fix. IMO, this is good for v3.12.
> > 
> > Thanks.
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index b49579c..691f226 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -653,6 +653,7 @@ static void free_huge_page(struct page *page)
> >  	BUG_ON(page_count(page));
> >  	BUG_ON(page_mapcount(page));
> >  	restore_reserve = PagePrivate(page);
> > +	ClearPagePrivate(page);
> >  
> 
> You describe it as a fix, but what does it fix?  IOW, what are the
> user-visible effects of the change?
> 
> update_and_free_page() already clears PG_private, but afaict the bit
> remains unaltered if free_huge_page() takes the enqueue_huge_page()
> route.

Yes, you are right.
I attach another version having more explanation.
Please refer this and merge it.

Thanks.
------------------------->8---------------------------------
>From 9d2ead1800de6e1192824e11dafe68bed7b78cce Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 30 Sep 2013 11:51:54 +0900
Subject: [PATCH] mm, hugetlb: correct missing private flag clearing

We should clear the page's private flag when returing the page to
the hugepage pool. Otherwise, marked hugepage can be allocated to
the user who tries to allocate the non-reserved hugepage. If this user
fail to map this hugepage, he would try to return the page to the
hugepage pool. Since this page has a private flag, resv_huge_pages would
mistakenly increase. This patch fixes this situation.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b49579c..691f226 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -653,6 +653,7 @@ static void free_huge_page(struct page *page)
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
 	restore_reserve = PagePrivate(page);
+	ClearPagePrivate(page);
 
 	spin_lock(&hugetlb_lock);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
-- 
1.7.9.5

