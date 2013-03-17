Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3CQCEC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 22:04:02 -0400
Received: from mail.openrapids.net ([64.15.138.104]:49595 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751949Ab3CQCD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 22:03:57 -0400
Date: Sat, 16 Mar 2013 22:03:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
	Implementation
Message-ID: <20130317020353.GA9344@Krystal>
References: <20130311213602.GB9829@Krystal> <20130314042227.GA15675@dcvr.yhbt.net> <20130314131855.GA9155@Krystal> <20130314190746.GA16120@dcvr.yhbt.net> <20130316220216.GA25099@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316220216.GA25099@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Eric Wong <normalperson@yhbt.net> wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > * Eric Wong (normalperson@yhbt.net) wrote:
> > > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > > > +/*
> > > > > + * Load a data from shared memory.
> > > > > + */
> > > > > +#define CMM_LOAD_SHARED(p)		ACCESS_ONCE(p)
> > > > 
> > > > When iterating through the queue by dequeueing, I needed a way
> > > > to get the tail at the start of the iteration and use that as
> > > > a sentinel while iterating, so I access the tail like this:
> > > > 
> > > > 	struct wfcq_node *p = CMM_LOAD_SHARED(ep->rdltail.p);
> > > > 
> > > > I hope this is supported... it seems to work :)
> > > 
> > > Ideally it would be good if users could try using the exposed APIs to do
> > > these things, or if it's really needed, maybe it's a sign that we need
> > > to extend the API.
> > 
> > Right.  If I can use splice, I will not need this.  more comments below
> > on splice...
> 
> Even with splice, I think I need to see the main tail at the start of
> iteration to maintain compatibility (for weird apps that might care).

Thanks for providing this detailed scenario. I think there is an
important aspect in the use of splice I suggested on which we are not
fully understanding each other. I will annotate your scenario below with
clarifications:

> 
> Consider this scenario:
> 
>   1) main.queue has 20 events
> 
>   2) epoll_wait(maxevents=16) called by user
> 
>   3) splice all 20 events into unconsumed.queue, main.queue is empty
> 
>   4) put_user + dequeue on 16 events from unconsumed.queue
>      # unconsumed.queue has 4 left at this point
> 
>   5) main.queue gets several more events enqueued at any point after 3.

Let's suppose 11 events are enqueued into main.queue after 3.

> 
>   6) epoll_wait(maxevents=16) called by user again

Before 7), here is what should be done:

6.5) splice all new events from main.queue into unconsumed.queue.
     unconsumed.queue will now contain 4 + 11 = 15 events. Note
     that splice will preserve the right order of events within
     unconsumed.queue.

> 
>   7) put_user + dequeue on 4 remaining items in unconsumed.queue
> 
>      We can safely return 4 events back to the user at this point.

Step 7) will now return 15 events from unconsumed.queue.

> 
>      However, this might break compatibility for existing users.  I'm
>      not sure if there's any weird apps which know/expect the event
>      count they'll get from epoll_wait, but maybe there is one...

With the new step 6.5), I don't think the behavior will change compared
to what is already there.

> 
>   8) We could perform a splice off main.queue to fill the remaining
>      slots the user requested, but we do not know if the things we
>      splice from main.queue at this point were just dequeued in 7.
> 
>      If we loaded the main.queue.tail before 7, we could safely splice
>      into unconsumed.queue and know when to stop when repeating the
>      put_user + dequeue loop.

We can achieve the same thing by doing step 6.5) at the beginning of
epoll_wait(). It's important to do it at the beginning of epoll_wait for
the reason you discuss in 8) : if you wait until you notice that
unconsumed.queue is empty before refilling it from main.queue, you won't
be able to know if the events in main.queue were added after the first
event was dequeued.

Step 6.5) should be performed each time upon entry into epoll_wait(). It
does not matter if unconsumed.queue would happen to have enough events
to fill in the maxevents request or not (and you don't want to iterate
on the unconsumed.queue needlessly to count them): you can just do a
O(1) splice from main.queue into unconsumed.queue, and your original
semantic should be preserved.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
