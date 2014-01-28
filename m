Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaA1CfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:35:22 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:23206 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaA1CfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:35:20 -0500
Message-ID: <1390876457.27421.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 3/8] mm, hugetlb: fix race in region tracking
From: Davidlohr Bueso <davidlohr@hp.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 18:34:17 -0800
In-Reply-To: <1390874021-48f5mo0m-mutt-n-horiguchi@ah.jp.nec.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
	 <1390794746-16755-4-git-send-email-davidlohr@hp.com>
	 <1390856576-ud1qp3fm-mutt-n-horiguchi@ah.jp.nec.com>
	 <1390859042.27421.4.camel@buesod1.americas.hpqcorp.net>
	 <1390874021-48f5mo0m-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 20:53 -0500, Naoya Horiguchi wrote:
> Hi Davidlohr,
> 
> On Mon, Jan 27, 2014 at 01:44:02PM -0800, Davidlohr Bueso wrote:
> > On Mon, 2014-01-27 at 16:02 -0500, Naoya Horiguchi wrote:
> > > On Sun, Jan 26, 2014 at 07:52:21PM -0800, Davidlohr Bueso wrote:
> > > > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > > > 
> > > > There is a race condition if we map a same file on different processes.
> > > > Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
> > > > When we do mmap, we don't grab a hugetlb_instantiation_mutex, but only the,
> > > > mmap_sem (exclusively). This doesn't prevent other tasks from modifying the
> > > > region structure, so it can be modified by two processes concurrently.
> > > > 
> > > > To solve this, introduce a spinlock to resv_map and make region manipulation
> > > > function grab it before they do actual work.
> > > > 
> > > > Acked-by: David Gibson <david@gibson.dropbear.id.au>
> > > > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > > > [Updated changelog]
> > > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > > ---
> > > ...
> > > > @@ -203,15 +200,23 @@ static long region_chg(struct resv_map *resv, long f, long t)
> > > >  	 * Subtle, allocate a new region at the position but make it zero
> > > >  	 * size such that we can guarantee to record the reservation. */
> > > >  	if (&rg->link == head || t < rg->from) {
> > > > -		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
> > > > -		if (!nrg)
> > > > -			return -ENOMEM;
> > > > +		if (!nrg) {
> > > > +			spin_unlock(&resv->lock);
> > > 
> > > I think that doing kmalloc() inside the lock is simpler.
> > > Why do you unlock and retry here?
> > 
> > This is a spinlock, no can do -- we've previously debated this and since
> > the critical region is quite small, a non blocking lock is better suited
> > here. We do the retry so we don't race once the new region is allocated
> > after the lock is dropped.
> 
> Using spinlock instead of rw_sem makes sense.
> But I'm not sure how the retry is essential to fix the race.
> (Sorry I can't find the discussion log about this.)
> As you did in your ver.1 (https://lkml.org/lkml/2013/7/26/296),
> simply doing like below seems to be fine to me, is it right?
> 
>         if (&rg->link == head || t < rg->from) {
> 		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
> 		if (!nrg) {
> 			chg = -ENOMEM;
> 			goto out_locked;
> 		}
> 		nrg->from = f;
> 		...
> 	}

That's nice and simple because we were using the rwsem version.

> 
> In the current version nrg is initialized to NULL, so we always do retry
> once when adding new file_region. That's not optimal to me.

Right, the retry can only occur once.

> 
> If this retry is really essential for the fix, please comment the reason
> both in patch description and inline comment. It's very important for
> future code maintenance.

So we locate the corresponding region in the reserve map, and if we are
below the current region, then we allocate a new one. Since we dropped
the lock to allocate memory, we have to make sure that we still need the
new region and that we don't race with the new status of the reservation
map. This is the whole point of the retry, and I don't see it being
suboptimal.

We just cannot retake the lock after we get the new region and just add
it to to the list.

> 
> And I noticed another point. I don't think the name of new goto label
> 'out_locked' is a good one. 'out_unlock' or 'unlock' is better.

What worries me more is that we're actually freeing a valid new region
(nrg) upon exit. We certainly don't do so in the current code, and it
doesn't seem to be a leak. Instead, we should be doing:

	if (&rg->link == head || t < rg->from) {
		if (!nrg) {
			spin_unlock(&resv->lock);
			nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
			if (!nrg)
				return -ENOMEM;

			goto retry;
		}

		nrg->from = f;
		nrg->to   = f;
		INIT_LIST_HEAD(&nrg->link);
		list_add(&nrg->link, rg->link.prev);

		chg = t - f;
		goto out;
	}
...
out:
	spin_unlock(&resv->lock);
	return chg;


Thanks,
Davidlohr

