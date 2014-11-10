Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaKJIwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:52:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaKJIwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:52:53 -0500
Date: Mon, 10 Nov 2014 09:52:50 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neilb@suse.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141110085250.GB15948@quack.suse.cz>
References: <20141029172608.39119c80@notabene.brown>
 <20141029143210.GA25226@htj.dyndns.org>
 <20141030101932.2241daa7@notabene.brown>
 <20141104142240.GD14459@htj.dyndns.org>
 <20141106165811.GA2338@gmail.com>
 <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110162848.6f2246bb@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-11-14 16:28:48, NeilBrown wrote:
> On Fri, 7 Nov 2014 11:03:40 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > On 11/07/2014 12:58 AM, Dongsu Park wrote:
> > > Hi Tejun & Neil,
> > > 
> > > On 04.11.2014 09:22, Tejun Heo wrote:
> > >> On Thu, Oct 30, 2014 at 10:19:32AM +1100, NeilBrown wrote:
> > >>>>                           Given that workder depletion is pool-wide
> > >>>> event, maybe it'd make sense to trigger rescuers immediately while
> > >>>> workers are in short supply?  e.g. while there's a manager stuck in
> > >>>> maybe_create_worker() with the mayday timer already triggered?
> > >>>
> > >>> So what if I change "need_more_worker" to "need_to_create_worker" ?
> > >>> Then it will stop as soon as there in an idle worker thread.
> > >>> That is the condition that keeps maybe_create_worker() looping.
> > >>> ??
> > >>
> > >> Yeah, that'd be a better condition and can work out.  Can you please
> > >> write up a patch to do that and do some synthetic tests excercising
> > >> the code path?  Also please cc Lai Jiangshan <laijs@cn.fujitsu.com>
> > >> when posting the patch.
> > > 
> > > This issue looks exactly like what I've encountered occasionally in our test
> > > setup. (with a custom kernel based on 3.12, MD/raid1, dm-multipath, etc.)
> > > When a system suffers from high memory pressure, and at the same time
> > > underlying devices of RAID arrays are repeatedly removed and re-added,
> > > then sometimes the whole system gets locked up on a worker pool's lock.
> > > So I had to fix our custom MD code to allocate a separate ordered workqueue
> > > with WQ_MEM_RECLAIM, apart from md_wq or md_misc_wq.
> > > Then the lockup seemed to have disappeared.
> > > 
> > > Now that I read the Neil's patch, which looks like an ultimate solution
> > > to the problem I have seen. I'm really looking forward to seeing this
> > > change in mainline.
> > > 
> > > How about the attached patch? Based on the Neil's patch, I replaced
> > > need_more_worker() with need_to_create_worker() as Tejun suggested.
> > > 
> > > Test is running with this patch, which seems to be working for now.
> > > But I'm going to observe the test result carefully for a few more days.
> > > 
> > > Regards,
> > > Dongsu
> > > 
> > > ----
> > >>From de9aadd6fb742ea8acce4245a27946d3f233ab7f Mon Sep 17 00:00:00 2001
> > > From: Dongsu Park <dongsu.park@profitbricks.com>
> > > Date: Wed, 5 Nov 2014 17:28:07 +0100
> > > Subject: [RFC PATCH] workqueue: allow rescuer thread to do more work
> > > 
> > > Original commit message from NeilBrown <neilb@suse.de>:
> > > ====
> > > When there is serious memory pressure, all workers in a pool could be
> > > blocked, and a new thread cannot be created because it requires memory
> > > allocation.
> > > 
> > > In this situation a WQ_MEM_RECLAIM workqueue will wake up the rescuer
> > > thread to do some work.
> > > 
> > > The rescuer will only handle requests that are already on ->worklist.
> > > If max_requests is 1, that means it will handle a single request.
> > > 
> > > The rescuer will be woken again in 100ms to handle another max_requests
> > > requests.
> > 
> > 
> > I also observed this problem by review when I was developing
> > the per-pwq-worklist patchset which has a side-affect that it also naturally
> > fix the problem.
> > 
> > However, it is nothing about correctness and I made promise to Frederic Weisbecker
> > for working on unbound pool for power-saving, then the per-pwq-worklist patchset
> > is put off. So I have to ack it.
> 
> Thanks!
> However testing showed that the patch isn't quite right.
> The test on ->nr_active is not correct.  I was meaning to test "are there
> any requests that have been activated but not yet serviced", but this test
> only covers the first half.
> 
> If a queue allows a number of active requests (max_active > 1), and several
> are blocked waiting for something (e.g. more memory), then max_active will be
> positive even though there is no useful work for the rescuer thread to do -
> so it will spin.
> 
> Jan Kara and I came up with a different patch which testing has shown is
> quite successful.  However it makes changes to when mayday_clear_cpu() is
> set, and that isn't relevant in the current kernel.
> 
> I've ported the patch to -mainline, but haven't really tested it properly
> (just compile tested so far).
> That version is below.
...
> 
> From: NeilBrown <neilb@suse.de>
> Subject: workqueue: Make rescuer thread process more works
> 
> Currently workqueue rescuer thread processes at most max_active works from a
> workqueue before it goes back to sleep for 100 ms. Especially for workqueues
> with low max_active this leads to rescuer being very slow and when queued
> work is blocking reclaim it leads to machine taking very long time (minutes
> or more) to recover from a situation when new workers cannot be created.
> 
> Fix the problem by going through worklist until either new worker is created
> or all no new works can be found.
> 
> We remove and re-add the pool_workqueue to the mayday list so that each pool_workqueue
> so that no one pool_workqueue can starve the others.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 09b685daee3d..19ecee70e3e9 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2253,6 +2253,10 @@ repeat:
>  			if (get_work_pwq(work) == pwq)
>  				move_linked_works(work, scheduled, &n);
>  
> +		if (!list_empty(scheduled) && need_to_create_worker(pool))
> +			/* Try again, in case more requests get added */
> +			if (list_empty(&pwq->mayday_node))
> +				list_add_tail(&pwq->mayday_node, &wq->maydays);
>  		process_scheduled_works(rescuer);
  This is certainly missing locking - we need to hold wq_mayday_lock when
changing wq->maydays list. Otherwise the patch looks good to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
