Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3CNNTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:19:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47497 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755858Ab3CNNTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:19:04 -0400
Date: Thu, 14 Mar 2013 09:18:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
	Implementation
Message-ID: <20130314131855.GA9155@Krystal>
References: <20130311213602.GB9829@Krystal> <20130314042227.GA15675@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314042227.GA15675@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > Ported to the Linux kernel from Userspace RCU library, at commit
> > 108a92e5b97ee91b2b902dba2dd2e78aab42f420.
> > 
> > Ref: http://git.lttng.org/userspace-rcu.git
> > 
> > It is provided as a starting point only. Test cases should be ported
> > from Userspace RCU to kernel space and thoroughly ran on a wide range of
> > architectures before considering this port production-ready.
> 
> Thanks, this seems to work.  Will post an early epoll patch in a minute.
> 
> Minor comments below.
> 
> > +/*
> > + * Load a data from shared memory.
> > + */
> > +#define CMM_LOAD_SHARED(p)		ACCESS_ONCE(p)
> 
> When iterating through the queue by dequeueing, I needed a way
> to get the tail at the start of the iteration and use that as
> a sentinel while iterating, so I access the tail like this:
> 
> 	struct wfcq_node *p = CMM_LOAD_SHARED(ep->rdltail.p);
> 
> I hope this is supported... it seems to work :)

Ideally it would be good if users could try using the exposed APIs to do
these things, or if it's really needed, maybe it's a sign that we need
to extend the API.

> 
> Unlike most queue users, I need to stop iteration to prevent the same
> item from appearing in the events returned by epoll_wait; since a
> dequeued item may appear back in the wfcqueue immediately.

I think your use-case is very similar to our urcu call_rcu
implementation. I would recommend to use wfcq in the following way:

When you want to dequeue, define, on the stack:

struct wfcq_head qhead;
struct wfcq_tail qtail;
struct wfcq_node *node, *n;
enum wfcq_ret ret;

wfcq_init(&qhead, &qtail);

/*
 * Then use splice to move the entire source queue into the local queue.
 * Don't forget to grab the appropriate mutexes for eqpoll_q here.
 */
ret = __wfcq_splice(&qhead, &qtail, epoll_q_head, epoll_q_tail);

switch (ret) {
case WFCQ_RET_SRC_EMPTY:
        return -ENOENT;         /* No events to handle */
case WFCQ_RET_DEST_EMPTY:
case WFCQ_RET_DEST_NON_EMPTY:
        break;
}

/*
 * From this point, you can release the epoll_q lock and simply iterate
 * on the local queue using __wfcq_for_each() or __wfcq_for_each_safe()
 * if you need to free the nodes at the same time.
 */
__wfcq_for_each_safe(&qhead, &qtail, node, n) {
    ...
}

The advantage of using splice() over dequeue() is that you will reduce
the amount of interactions between concurrent enqueue and dequeue
operations on the head and tail of the same queue.

> 
> > +struct wfcq_head {
> > +	struct wfcq_node node;
> > +	struct mutex lock;
> > +};
> 
> I'm not using this lock at all since I already have ep->mtx (which also
> protects the ep->rbr).  Perhaps it should not be included; normal linked
> list and most data structures I see in the kernel do not provide their
> own locks, either

Good point. The Linux kernel habits are to leave the locks outside of
those structures whenever possible, so users can pick the right lock for
their need. Will remove, and remove all the "helpers" that use this lock
as well.

> 
> > +static inline void wfcq_init(struct wfcq_head *head,
> > +		struct wfcq_tail *tail)
> > +{
> > +	/* Set queue head and tail */
> > +	wfcq_node_init(&head->node);
> > +	tail->p = &head->node;
> > +	mutex_init(&head->lock);
> > +}
> 
> There's no corresponding mutex_destroy, so I'm just destroying it
> myself...

Since I remove it, it will become a non-issue.

After thinking about it, I plan to disable preemption around xchg and
store within __wfcq_append. This is a luxury we have at kernel-level
that we don't have in user-space, si it might be good to use it. This
will allow me to remove the 10ms sleep from the adaptative busy-wait in
___wfcq_busy_wait(), and replace this by a simple busy-wait. This will
eliminate those possible latency peaks from the dequeue/splice/iteration
side. It's a shame to have a possibility of 10ms sleep due to preemption
within a 2 instructions window. preempt_disable() will fix this, while
adding a very low overhead to enqueue path in preemptible kernels.

I'll send a new patch version soon,

Thanks for your comments!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
