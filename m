Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab3GaC1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:27:54 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55347 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3GaC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:27:53 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-26-51f87627b60a
Date: Wed, 31 Jul 2013 11:27:51 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 01/18] mm, hugetlb: protect reserved pages when
 softofflining requests the pages
Message-ID: <20130731022751.GA2548@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-2-git-send-email-iamjoonsoo.kim@lge.com>
 <CAJd=RBCUJg5GJEQ2_heCt8S9LZzedGLbvYvivFkmvfMChPqaCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCUJg5GJEQ2_heCt8S9LZzedGLbvYvivFkmvfMChPqaCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 03:24:46PM +0800, Hillf Danton wrote:
> On Mon, Jul 29, 2013 at 1:31 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > alloc_huge_page_node() use dequeue_huge_page_node() without
> > any validation check, so it can steal reserved page unconditionally.
> 
> Well, why is it illegal to use reserved page here?

Hello, Hillf.

If we use reserved page here, other processes which are promised to use
enough hugepages cannot get enough hugepages and can die. This is
unexpected result to them.

Thanks.

> 
> > To fix it, check the number of free_huge_page in alloc_huge_page_node().
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 6782b41..d971233 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -935,10 +935,11 @@ static struct page *alloc_buddy_huge_page(struct hstate *h, int nid)
> >   */
> >  struct page *alloc_huge_page_node(struct hstate *h, int nid)
> >  {
> > -       struct page *page;
> > +       struct page *page = NULL;
> >
> >         spin_lock(&hugetlb_lock);
> > -       page = dequeue_huge_page_node(h, nid);
> > +       if (h->free_huge_pages - h->resv_huge_pages > 0)
> > +               page = dequeue_huge_page_node(h, nid);
> >         spin_unlock(&hugetlb_lock);
> >
> >         if (!page)
> > --
> > 1.7.9.5
> >
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
