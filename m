Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3GaCl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:41:27 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48235 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3GaCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:41:26 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-5a-51f879544a1a
Date: Wed, 31 Jul 2013 11:41:24 +0900
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
Subject: Re: [PATCH 05/18] mm, hugetlb: protect region tracking via newly
 introduced resv_map lock
Message-ID: <20130731024124.GC2548@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-6-git-send-email-iamjoonsoo.kim@lge.com>
 <CAJd=RBD6ySxfeX0ebzJ1jsTWnOfvwSm4iyQ8Zr2W05x2LVWE2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBD6ySxfeX0ebzJ1jsTWnOfvwSm4iyQ8Zr2W05x2LVWE2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 04:58:57PM +0800, Hillf Danton wrote:
> On Mon, Jul 29, 2013 at 1:31 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > There is a race condition if we map a same file on different processes.
> > Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
> > When we do mmap, we don't grab a hugetlb_instantiation_mutex, but,
> > grab a mmap_sem. This doesn't prevent other process to modify region
> > structure, so it can be modified by two processes concurrently.
> >
> > To solve this, I introduce a lock to resv_map and make region manipulation
> > function grab a lock before they do actual work. This makes region
> > tracking safe.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index 2677c07..e29e28f 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -26,6 +26,7 @@ struct hugepage_subpool {
> >
> >  struct resv_map {
> >         struct kref refs;
> > +       spinlock_t lock;
> >         struct list_head regions;
> >  };
> >  extern struct resv_map *resv_map_alloc(void);
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 24c0111..bf2ee11 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> [...]
> > @@ -193,6 +188,7 @@ static long region_chg(struct resv_map *resv, long f, long t)
> >         struct file_region *rg, *nrg;
> >         long chg = 0;
> >
> > +       spin_lock(&resv->lock);
> >         /* Locate the region we are before or in. */
> >         list_for_each_entry(rg, head, link)
> >                 if (f <= rg->to)
> > @@ -203,14 +199,18 @@ static long region_chg(struct resv_map *resv, long f, long t)
> >          * size such that we can guarantee to record the reservation. */
> >         if (&rg->link == head || t < rg->from) {
> >                 nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
> 
> Hm, you are allocating a piece of memory with spin lock held.
> How about replacing that spin lock with a mutex?

I think that lock held period here is very short, so mutex is not appropriate
to use. How about trying allocate with GFP_NOWAIT? And then if failed,
release the lock and allocate with GFP_KERNEL and retry at the beginnig.

Thanks.

> 
> > -               if (!nrg)
> > -                       return -ENOMEM;
> > +               if (!nrg) {
> > +                       chg = -ENOMEM;
> > +                       goto out;
> > +               }
> > +
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
