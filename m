Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3CPWCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 18:02:19 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:46838 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3CPWCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 18:02:18 -0400
Date: Sat, 16 Mar 2013 22:02:16 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
 Implementation
Message-ID: <20130316220216.GA25099@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
 <20130314042227.GA15675@dcvr.yhbt.net>
 <20130314131855.GA9155@Krystal>
 <20130314190746.GA16120@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314190746.GA16120@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > * Eric Wong (normalperson@yhbt.net) wrote:
> > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > > +/*
> > > > + * Load a data from shared memory.
> > > > + */
> > > > +#define CMM_LOAD_SHARED(p)		ACCESS_ONCE(p)
> > > 
> > > When iterating through the queue by dequeueing, I needed a way
> > > to get the tail at the start of the iteration and use that as
> > > a sentinel while iterating, so I access the tail like this:
> > > 
> > > 	struct wfcq_node *p = CMM_LOAD_SHARED(ep->rdltail.p);
> > > 
> > > I hope this is supported... it seems to work :)
> > 
> > Ideally it would be good if users could try using the exposed APIs to do
> > these things, or if it's really needed, maybe it's a sign that we need
> > to extend the API.
> 
> Right.  If I can use splice, I will not need this.  more comments below
> on splice...

Even with splice, I think I need to see the main tail at the start of
iteration to maintain compatibility (for weird apps that might care).

Consider this scenario:

  1) main.queue has 20 events

  2) epoll_wait(maxevents=16) called by user

  3) splice all 20 events into unconsumed.queue, main.queue is empty

  4) put_user + dequeue on 16 events from unconsumed.queue
     # unconsumed.queue has 4 left at this point

  5) main.queue gets several more events enqueued at any point after 3.

  6) epoll_wait(maxevents=16) called by user again

  7) put_user + dequeue on 4 remaining items in unconsumed.queue

     We can safely return 4 events back to the user at this point.

     However, this might break compatibility for existing users.  I'm
     not sure if there's any weird apps which know/expect the event
     count they'll get from epoll_wait, but maybe there is one...

  8) We could perform a splice off main.queue to fill the remaining
     slots the user requested, but we do not know if the things we
     splice from main.queue at this point were just dequeued in 7.

     If we loaded the main.queue.tail before 7, we could safely splice
     into unconsumed.queue and know when to stop when repeating the
     put_user + dequeue loop.
