Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3H0H53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:57:29 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49136 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3H0H52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:57:28 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-11-521c5be67557
Date: Tue, 27 Aug 2013 16:57:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v2 13/20] mm, hugetlb: mm, hugetlb: unify chg and
 avoid_reserve to use_reserve
Message-ID: <20130827075753.GB6795@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1376040398-11212-14-git-send-email-iamjoonsoo.kim@lge.com>
 <87y57od2eo.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y57od2eo.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 06:39:35PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > Currently, we have two variable to represent whether we can use reserved
> > page or not, chg and avoid_reserve, respectively. With aggregating these,
> > we can have more clean code. This makes no functinoal difference.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 22ceb04..8dff972 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -531,8 +531,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
> >
> >  static struct page *dequeue_huge_page_vma(struct hstate *h,
> >  				struct vm_area_struct *vma,
> > -				unsigned long address, int avoid_reserve,
> > -				long chg)
> > +				unsigned long address, bool use_reserve)
> >  {
> >  	struct page *page = NULL;
> >  	struct mempolicy *mpol;
> > @@ -546,12 +545,10 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
> >  	 * A child process with MAP_PRIVATE mappings created by their parent
> >  	 * have no page reserves. This check ensures that reservations are
> >  	 * not "stolen". The child may still get SIGKILLed
> > +	 * Or, when parent process do COW, we cannot use reserved page.
> > +	 * In this case, ensure enough pages are in the pool.
> >  	 */
> > -	if (chg && h->free_huge_pages - h->resv_huge_pages == 0)
> > -		return NULL;
> 
> This hunk would be much easier if you were changing. 
> 
> 	if (!vma_has_reserves(vma) &&
> 			h->free_huge_pages - h->resv_huge_pages == 0)
> 		goto err;
> 
> ie, !vma_has_reserves(vma) == !use_reserve.
> 
> So may be a patch rearragment would help ?. But neverthless. 

I think that current form is better since use_reserve is not same as
vma_has_reserves(). I changed the call site of vma_has_reserves() to chg in
previous patch. In this patch, use_reserve in alloc_huge_page is made
by chg and avoid_reserve and is passed to dequeue_huge_page_vma(). So changing
in dequeue_huge_page_vma() is trivial.

> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks!

