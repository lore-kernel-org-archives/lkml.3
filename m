Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3CNTHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:07:47 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:57187 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab3CNTHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:07:46 -0400
Date: Thu, 14 Mar 2013 19:07:46 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
 Implementation
Message-ID: <20130314190746.GA16120@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
 <20130314042227.GA15675@dcvr.yhbt.net>
 <20130314131855.GA9155@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314131855.GA9155@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> * Eric Wong (normalperson@yhbt.net) wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > +/*
> > > + * Load a data from shared memory.
> > > + */
> > > +#define CMM_LOAD_SHARED(p)		ACCESS_ONCE(p)
> > 
> > When iterating through the queue by dequeueing, I needed a way
> > to get the tail at the start of the iteration and use that as
> > a sentinel while iterating, so I access the tail like this:
> > 
> > 	struct wfcq_node *p = CMM_LOAD_SHARED(ep->rdltail.p);
> > 
> > I hope this is supported... it seems to work :)
> 
> Ideally it would be good if users could try using the exposed APIs to do
> these things, or if it's really needed, maybe it's a sign that we need
> to extend the API.

Right.  If I can use splice, I will not need this.  more comments below
on splice...

> > Unlike most queue users, I need to stop iteration to prevent the same
> > item from appearing in the events returned by epoll_wait; since a
> > dequeued item may appear back in the wfcqueue immediately.
> 
> I think your use-case is very similar to our urcu call_rcu
> implementation. I would recommend to use wfcq in the following way:
> 
> When you want to dequeue, define, on the stack:
> 
> struct wfcq_head qhead;
> struct wfcq_tail qtail;
> struct wfcq_node *node, *n;
> enum wfcq_ret ret;
> 
> wfcq_init(&qhead, &qtail);
> 
> /*
>  * Then use splice to move the entire source queue into the local queue.
>  * Don't forget to grab the appropriate mutexes for eqpoll_q here.
>  */
> ret = __wfcq_splice(&qhead, &qtail, epoll_q_head, epoll_q_tail);
> 
> switch (ret) {
> case WFCQ_RET_SRC_EMPTY:
>         return -ENOENT;         /* No events to handle */
> case WFCQ_RET_DEST_EMPTY:
> case WFCQ_RET_DEST_NON_EMPTY:
>         break;
> }
> 
> /*
>  * From this point, you can release the epoll_q lock and simply iterate
>  * on the local queue using __wfcq_for_each() or __wfcq_for_each_safe()
>  * if you need to free the nodes at the same time.
>  */
> __wfcq_for_each_safe(&qhead, &qtail, node, n) {
>     ...
> }
> 
> The advantage of using splice() over dequeue() is that you will reduce
> the amount of interactions between concurrent enqueue and dequeue
> operations on the head and tail of the same queue.

I wanted to use splice here originally, but epoll_wait(2) may not
consume the entire queue, as it's limited to maxevents specified by the
user calling epoll_wait.

With unconsumed elements, I need to preserve ordering of the queue to
avoid starvation.  So I would either need to:

a) splice the unconsumed portion back to the head of the shared queue.
   I'm not sure if this is possible while elements are being enqueued...
   Using a mutex for splicing back to unconsumed elements is OK, and
   probably required anyways since we need to keep EPOLLONESHOT
   unmasking synced with dequeue.

b) preserve the unconsumed spliced queue across epoll_wait invocations
   but that requires checking both queues for event availability...

> I'll send a new patch version soon,
> 
> Thanks for your comments!

Thank you for this data structure!  I will update my patch tomorrow or
the day after and do more testing.
