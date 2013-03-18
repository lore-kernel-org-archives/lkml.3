Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3CRNGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:06:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50396 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751383Ab3CRNGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:06:52 -0400
Date: Mon, 18 Mar 2013 09:06:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130318130649.GA15947@Krystal>
References: <20130314044215.GA27312@dcvr.yhbt.net> <20130318110722.GA8798@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318110722.GA8798@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Eric Wong <normalperson@yhbt.net> wrote:
> > I'm posting this lightly tested version since I may not be able to do
> > more testing/benchmarking until the weekend.
> 
> Still lightly tested (on an initramfs KVM, no real applications, yet).
> 
> > Davide's totalmess is still running, so that's probably a good sign :)
> > http://www.xmailserver.org/totalmess.c
> 
> Ditto :)  Also testing with eponeshotmt, which is close to my target
> use case: http://yhbt.net/eponeshotmt.c
> 
> > I will look for more ways to break this (and benchmark when I stop
> > finding ways to break it).  No real applications tested, yet, and
> > I think I can improve upon this, too.
> 
> No real apps, yet, and I need to make sure this doesn't cause
> regressions for the traditional single-threaded event loop case.
> 
> This is the use case I mainly care about (multiple tasks calling
> epoll_wait(maxevents=1) to divide work).
> 
> Time to wait on 4 million events (4 threads generating events,
> 4 threads calling epoll_wait(maxevents=1) 1 million times each,
> 10 eventfd file descriptors (fewer descriptors means higher
> chance of contention for epi->state inside ep_poll_callback).
> 
> Before:
> $ eponeshotmt -t 4 -w 4 -f 10 -c 1000000
> real    0m 9.58s
> user    0m 1.22s
> sys     0m 37.08s
> 
> After:
> $ eponeshotmt -t 4 -w 4 -f 10 -c 1000000
> real    0m 6.49s
> user    0m 1.28s
> sys     0m 24.66s

Nice! This looks like a 31% speedup with 4 cores. It would be nice to
see how this evolves when the number of cores and threads increase. I
also notice that you turned the spinlock_irqsave into a mutex. Maybe
comparison with a simple spinlock (rather than the mutex) with lead to
interesting findings. (note that this spinlock will likely not need to
have IRQ off, as enqueue won't need to hold the spinlock).

Some comments below,

[...]
> +static int ep_send_events(struct eventpoll *ep,
> +			  struct epoll_event __user *uevent, int maxevents)
> +{
> +	int eventcnt = 0;
>  	unsigned int revents;
>  	struct epitem *epi;
> -	struct epoll_event __user *uevent;
>  	struct wakeup_source *ws;
> +	struct wfcq_node *node, *n;
> +	enum epoll_item_state state;
>  	poll_table pt;
>  
>  	init_poll_funcptr(&pt, NULL);
>  
>  	/*
> -	 * We can loop without lock because we are passed a task private list.
> -	 * Items cannot vanish during the loop because ep_scan_ready_list() is
> -	 * holding "mtx" during this call.
> +	 * Items cannot vanish during the loop because we are holding
> +	 * "mtx" during this call.
>  	 */
> -	for (eventcnt = 0, uevent = esed->events;
> -	     !list_empty(head) && eventcnt < esed->maxevents;) {
> -		epi = list_first_entry(head, struct epitem, rdllink);
> +	ep_ready_prepare(ep);
> +	__wfcq_for_each_safe(&ep->txlhead, &ep->txltail, node, n) {

Even though it should technically work, I don't understand why you do
this:

eventcnt = 0;

__wfcq_for_each_safe(&ep->txlhead, &ep->txltail, node, n) {
        ...
        if (++eventcnt == maxevents)
                n = NULL; /* stop iteration */
        __wfcq_dequeue(&ep->txlhead, &ep->txltail);
}

Rather than this:

eventcnt = 0;

for (;;) {
        if (eventcnt++ >= maxevents)
                break;
        node = __wfcq_dequeue(&ep->txlhead, &ep->txltail);
        if (!node)
                break;
        ...
}

The second way to express your queue would save a couple of useless ops,
and would ensure your item is kicked out of the queue as soon as it is
processed.

I'm also not entirely sure why you need to add enum epoll_item_state
along with expensive atomic ops to compute the state.  Wouldn't it be
enough to know in which queue the nodes are located ? If need be, you
could add new queues, e.g. one per state. So instead of marking states,
you would simply re-enqueue the nodes into per-state queues. This would
simplify zombie management and save a couple of brains in the process. ;-)

Thanks,

Mathieu

> +		epi = ep_item_from_node(node);
> +
> +		state = ep_item_state(epi);
> +
> +		if (state == EP_STATE_ZOMBIE) {
> +			ep_reap_zombie(ep, epi);
> +			continue;
> +		}
> +		WARN_ON(state != EP_STATE_READY);
>  
>  		/*
>  		 * Activate ep->ws before deactivating epi->ws to prevent
> @@ -1459,7 +1448,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
>  		 *
>  		 * This could be rearranged to delay the deactivation of epi->ws
>  		 * instead, but then epi->ws would temporarily be out of sync
> -		 * with ep_is_linked().
> +		 * with epi->state.
>  		 */
>  		ws = ep_wakeup_source(epi);
>  		if (ws) {
> @@ -1468,8 +1457,6 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
>  			__pm_relax(ws);
>  		}
>  
> -		list_del_init(&epi->rdllink);
> -
>  		revents = ep_item_poll(epi, &pt);
>  
>  		/*
> @@ -1481,46 +1468,37 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
>  		if (revents) {
>  			if (__put_user(revents, &uevent->events) ||
>  			    __put_user(epi->event.data, &uevent->data)) {
> -				list_add(&epi->rdllink, head);
> -				ep_pm_stay_awake(epi);
> -				return eventcnt ? eventcnt : -EFAULT;
> +				if (!eventcnt)
> +					eventcnt = -EFAULT;
> +				break;
>  			}
> -			eventcnt++;
> +
>  			uevent++;
> -			if (epi->event.events & EPOLLONESHOT)
> +			if (++eventcnt == maxevents)
> +				n = NULL; /* stop iteration */
> +
> +			if (epi->event.events & EPOLLONESHOT) {
>  				epi->event.events &= EP_PRIVATE_BITS;
> -			else if (!(epi->event.events & EPOLLET)) {
> -				/*
> -				 * If this file has been added with Level
> -				 * Trigger mode, we need to insert back inside
> -				 * the ready list, so that the next call to
> -				 * epoll_wait() will check again the events
> -				 * availability. At this point, no one can insert
> -				 * into ep->rdllist besides us. The epoll_ctl()
> -				 * callers are locked out by
> -				 * ep_scan_ready_list() holding "mtx" and the
> -				 * poll callback will queue them in ep->ovflist.
> -				 */
> -				list_add_tail(&epi->rdllink, &ep->rdllist);
> -				ep_pm_stay_awake(epi);
> +			} else if (!(epi->event.events & EPOLLET)) {
> +				ep_level_trigger(ep, epi);
> +				continue;
>  			}
>  		}
> +
> +		/*
> +		 * we set EP_STATE_DEQUEUE before dequeueing to prevent losing
> +		 * events during ep_poll_callback that fire before we can set
> +		 * EP_STATE_IDLE ep_poll_callback must spin while we're
> +		 * EP_STATE_DEQUEUE (for the dequeue)
> +		 */
> +		atomic_xchg(&epi->state, EP_STATE_DEQUEUE);
> +		__wfcq_dequeue(&ep->txlhead, &ep->txltail);
> +		atomic_xchg(&epi->state, EP_STATE_IDLE);
>  	}
>  
>  	return eventcnt;
>  }
[...]

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
