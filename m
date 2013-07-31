Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3GaFh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:37:56 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45001 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3GaFhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:37:55 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-b7-51f8a2b194ea
Date: Wed, 31 Jul 2013 14:37:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH 17/18] mm, hugetlb: retry if we fail to allocate a
 hugepage with use_reserve
Message-ID: <20130731053753.GM2548@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-18-git-send-email-iamjoonsoo.kim@lge.com>
 <20130729072823.GD29970@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729072823.GD29970@voom.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Mon, Jul 29, 2013 at 05:28:23PM +1000, David Gibson wrote:
> On Mon, Jul 29, 2013 at 02:32:08PM +0900, Joonsoo Kim wrote:
> > If parallel fault occur, we can fail to allocate a hugepage,
> > because many threads dequeue a hugepage to handle a fault of same address.
> > This makes reserved pool shortage just for a little while and this cause
> > faulting thread who is ensured to have enough reserved hugepages
> > to get a SIGBUS signal.
> 
> It's not just about reserved pages.  The same race can happen
> perfectly well when you're really, truly allocating the last hugepage
> in the system.

Yes, you are right.
This is a critical comment to this patchset :(

IIUC, the case you mentioned is about tasks which have a mapping
with MAP_NORESERVE. Should we ensure them to allocate the last hugepage?
They map a region with MAP_NORESERVE, so don't assume that their requests
always succeed.

> 
> > 
> > To solve this problem, we already have a nice solution, that is,
> > a hugetlb_instantiation_mutex. This blocks other threads to dive into
> > a fault handler. This solve the problem clearly, but it introduce
> > performance degradation, because it serialize all fault handling.
> > 
> > Now, I try to remove a hugetlb_instantiation_mutex to get rid of
> > performance degradation. A prerequisite is that other thread should
> > not get a SIGBUS if they are ensured to have enough reserved pages.
> > 
> > For this purpose, if we fail to allocate a new hugepage with use_reserve,
> > we return just 0, instead of VM_FAULT_SIGBUS. use_reserve
> > represent that this user is legimate one who are ensured to have enough
> > reserved pages. This prevent these thread not to get a SIGBUS signal and
> > make these thread retrying fault handling.
> 
> Not sufficient, since it can happen without reserved pages.

Ditto.

> 
> Also, I think there are edge cases where even reserved mappings can
> run out, in particular with the interaction between MAP_PRIVATE,
> fork() and reservations.  In this case, when you have a genuine out of
> memory condition, you will spin forever on the fault.

If there are edge cases, we can fix it. It doesn't matter.
If you find it, please tell me in more detail.

Thanks.

> 
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 6a9ec69..909075b 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -2623,7 +2623,10 @@ retry_avoidcopy:
> >  			WARN_ON_ONCE(1);
> >  		}
> >  
> > -		ret = VM_FAULT_SIGBUS;
> > +		if (use_reserve)
> > +			ret = 0;
> > +		else
> > +			ret = VM_FAULT_SIGBUS;
> >  		goto out_lock;
> >  	}
> >  
> > @@ -2741,7 +2744,10 @@ retry:
> >  
> >  		page = alloc_huge_page(vma, address, use_reserve);
> >  		if (IS_ERR(page)) {
> > -			ret = VM_FAULT_SIGBUS;
> > +			if (use_reserve)
> > +				ret = 0;
> > +			else
> > +				ret = VM_FAULT_SIGBUS;
> >  			goto out;
> >  		}
> >  		clear_huge_page(page, address, pages_per_huge_page(h));
> 
> -- 
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson


