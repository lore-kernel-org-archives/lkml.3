Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3CRUbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:31:18 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50676 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753461Ab3CRUbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:31:16 -0400
Date: Mon, 18 Mar 2013 16:31:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130318203112.GA24702@Krystal>
References: <20130314044215.GA27312@dcvr.yhbt.net> <20130318110722.GA8798@dcvr.yhbt.net> <20130318130649.GA15947@Krystal> <20130318173237.GB8798@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318173237.GB8798@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > * Eric Wong (normalperson@yhbt.net) wrote:
> > > Eric Wong <normalperson@yhbt.net> wrote:
> > > > I'm posting this lightly tested version since I may not be able to do
> > > > more testing/benchmarking until the weekend.
> > > 
> > > Still lightly tested (on an initramfs KVM, no real applications, yet).
> > > 
> > > > Davide's totalmess is still running, so that's probably a good sign :)
> > > > http://www.xmailserver.org/totalmess.c
> > > 
> > > Ditto :)  Also testing with eponeshotmt, which is close to my target
> > > use case: http://yhbt.net/eponeshotmt.c
> > > 
> > > > I will look for more ways to break this (and benchmark when I stop
> > > > finding ways to break it).  No real applications tested, yet, and
> > > > I think I can improve upon this, too.
> > > 
> > > No real apps, yet, and I need to make sure this doesn't cause
> > > regressions for the traditional single-threaded event loop case.
> > > 
> > > This is the use case I mainly care about (multiple tasks calling
> > > epoll_wait(maxevents=1) to divide work).
> > > 
> > > Time to wait on 4 million events (4 threads generating events,
> > > 4 threads calling epoll_wait(maxevents=1) 1 million times each,
> > > 10 eventfd file descriptors (fewer descriptors means higher
> > > chance of contention for epi->state inside ep_poll_callback).
> > > 
> > > Before:
> > > $ eponeshotmt -t 4 -w 4 -f 10 -c 1000000
> > > real    0m 9.58s
> > > user    0m 1.22s
> > > sys     0m 37.08s
> > > 
> > > After:
> > > $ eponeshotmt -t 4 -w 4 -f 10 -c 1000000
> > > real    0m 6.49s
> > > user    0m 1.28s
> > > sys     0m 24.66s
> > 
> > Nice! This looks like a 31% speedup with 4 cores. It would be nice to
> > see how this evolves when the number of cores and threads increase. I
> > also notice that you turned the spinlock_irqsave into a mutex. Maybe
> > comparison with a simple spinlock (rather than the mutex) with lead to
> > interesting findings. (note that this spinlock will likely not need to
> > have IRQ off, as enqueue won't need to hold the spinlock).
> 
> Unfortunately, 4 cores is all I have right now.  I'm hoping others can
> help test with more cores.
> 
> I added the mutex lock to ep_poll since it's now required for
> ep_events_available.  Another upside is the ep_events_available is
> always coherent with the ep_send_events loop, so there's no chance of a
> task entering ep_send_events on an empty ready list
> 
> I was planning on making the mutex cover a wider scope for ep_poll
> before I discovered wfcqueue.  I noticed ep->lock was very contended
> (and always dominating lock_stat).
> 
> Previously with ep_poll + ep_scan_ready_list + ep_send_events_proc,
> it was something like this where a spin lock was taken 3 times in
> quick succession:
> 
> 	ep_poll:
> 		spin_lock;
> 		check ep_events_available;
> 		spin_unlock;
> 
> 		ep_send_events:
> 			ep_scan_ready_list:
> 				mutex_lock
> 				spin_lock
> 				...
> 				spin_unlock
> 
> 					ep_send_events_proc
> 
> 				spin_lock
> 				...
> 				spin_unlock
> 				mutex_unlock
> 
> ep->lock was getting bounced all over since ep_poll_callback(which also
> takes ep->lock) was constantly firing.  This is made worse when several
> threads are calling ep_poll.  The exclusive waitqueue-ing of ep_poll
> doesn't help much because of the sheer number of ep_poll_callback wakeups.

OK, yep, that's where the wait-free queue with head and tail on separate
cache lines really helps.

> 
> > Some comments below,
> > 
> > [...]
> > > +static int ep_send_events(struct eventpoll *ep,
> > > +			  struct epoll_event __user *uevent, int maxevents)
> > > +{
> > > +	int eventcnt = 0;
> > >  	unsigned int revents;
> > >  	struct epitem *epi;
> > > -	struct epoll_event __user *uevent;
> > >  	struct wakeup_source *ws;
> > > +	struct wfcq_node *node, *n;
> > > +	enum epoll_item_state state;
> > >  	poll_table pt;
> > >  
> > >  	init_poll_funcptr(&pt, NULL);
> > >  
> > >  	/*
> > > -	 * We can loop without lock because we are passed a task private list.
> > > -	 * Items cannot vanish during the loop because ep_scan_ready_list() is
> > > -	 * holding "mtx" during this call.
> > > +	 * Items cannot vanish during the loop because we are holding
> > > +	 * "mtx" during this call.
> > >  	 */
> > > -	for (eventcnt = 0, uevent = esed->events;
> > > -	     !list_empty(head) && eventcnt < esed->maxevents;) {
> > > -		epi = list_first_entry(head, struct epitem, rdllink);
> > > +	ep_ready_prepare(ep);
> > > +	__wfcq_for_each_safe(&ep->txlhead, &ep->txltail, node, n) {
> > 
> > Even though it should technically work, I don't understand why you do
> > this:
> > 
> > eventcnt = 0;
> > 
> > __wfcq_for_each_safe(&ep->txlhead, &ep->txltail, node, n) {
> >         ...
> >         if (++eventcnt == maxevents)
> >                 n = NULL; /* stop iteration */
> >         __wfcq_dequeue(&ep->txlhead, &ep->txltail);
> > }
> > 
> > Rather than this:
> > 
> > eventcnt = 0;
> > 
> > for (;;) {
> >         if (eventcnt++ >= maxevents)
> >                 break;
> >         node = __wfcq_dequeue(&ep->txlhead, &ep->txltail);
> >         if (!node)
> >                 break;
> >         ...
> > }
> > 
> > The second way to express your queue would save a couple of useless ops,
> > and would ensure your item is kicked out of the queue as soon as it is
> > processed.
> 
> I delay the dequeue and I don't dequeue at all if put_user fails.
> I should probably add a comment where I removed the list_add() to that
> effect.  On the other hand, preserving event ordering when users trigger
> -EFAULT might not be worth it...

That's arguable indeed. But I see why you try to keep it in the queue.

> 
> > I'm also not entirely sure why you need to add enum epoll_item_state
> > along with expensive atomic ops to compute the state.  Wouldn't it be
> > enough to know in which queue the nodes are located ? If need be, you
> > could add new queues, e.g. one per state. So instead of marking states,
> > you would simply re-enqueue the nodes into per-state queues. This would
> > simplify zombie management and save a couple of brains in the process. ;-)
> 
> Is there a quick way to know which queue the node is located?

Not really I'm afraid.

> ep_enqueue may fire from several places at once (ep_poll_callback,
> ep_insert/ep_modify) so I think guarding it with something (currently
> ep_mark_ready) is required.  We used to use ep->lock to protect all the
> "if (!ep_is_linked) list_add_tail" calls, too.

For READY state, it makes sense.

> 
> For making zombies, they could appear from the middle of a queue,
> so I couldn't pluck them out from either txl/rdl in O(1)

Good point.

So perharps there is not much to gain in trying to look at encoding
those states by moving nodes across queues compared to your
implementation. One thought I had was that maybe the EP_STATE_DEQUEUE
could go away if we re-enqueue the nodes into a separate queue, but it
might not be worth it if you need to keep these states anyway.

Thanks!

Mathieu

> 
> Thanks for all your help and comments.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
