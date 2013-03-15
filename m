Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3COCi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:38:26 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48027 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409Ab3COCiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:38:25 -0400
Date: Thu, 14 Mar 2013 22:38:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
	Implementation
Message-ID: <20130315023821.GB25419@Krystal>
References: <20130311213602.GB9829@Krystal> <20130314042227.GA15675@dcvr.yhbt.net> <20130314131855.GA9155@Krystal> <20130314190746.GA16120@dcvr.yhbt.net> <20130314194853.GA22198@Krystal> <20130314213209.GA15771@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314213209.GA15771@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > * Eric Wong (normalperson@yhbt.net) wrote:
> > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > > The advantage of using splice() over dequeue() is that you will reduce
> > > > the amount of interactions between concurrent enqueue and dequeue
> > > > operations on the head and tail of the same queue.
> > > 
> > > I wanted to use splice here originally, but epoll_wait(2) may not
> > > consume the entire queue, as it's limited to maxevents specified by the
> > > user calling epoll_wait.
> > 
> > I see,
> > 
> > > 
> > > With unconsumed elements, I need to preserve ordering of the queue to
> > > avoid starvation.  So I would either need to:
> > > 
> > > a) splice the unconsumed portion back to the head of the shared queue.
> > >    I'm not sure if this is possible while elements are being enqueued...
> > 
> > That would be a double-ended queue. I haven't thought this problem
> > through yet.
> > 
> > >    Using a mutex for splicing back to unconsumed elements is OK, and
> > >    probably required anyways since we need to keep EPOLLONESHOT
> > >    unmasking synced with dequeue.
> > > 
> > > b) preserve the unconsumed spliced queue across epoll_wait invocations
> > >    but that requires checking both queues for event availability...
> > 
> > I think b) should be preferred over a).
> > 
> > Basically, instead of having the "unconsumed element" queue on the stack
> > as I suggested, you might want to keep it across epoll_wait invocations.
> > 
> > Before you start digging in the unconsumed element queue, you just start
> > by splicing the content of the shared queue into the tail of unconsumed
> > queue. Then, you simply dequeue the unconsumed queue elements until you
> > either reach the end or the max nr.
> > 
> > You should note that with this scheme, you'll have to dequeue items from
> > the unconsumed queue rather than just iterating over the elements. The
> > nice side of consuming all the elements (in the temp queue on the local
> > stack) is that you don't care about dequeuing, since the entire queue
> > will vanish. However, in this case, since you care about keeping the
> > queue after a partial iteration, you need to dequeue from it.
> > 
> > And yes, this approach involves checking both queues for event
> > availability. Hopefully none of this will be too much of an issue
> > performance-wise.
> 
> Right.  I will try this, I don't think the check will be too expensive.
> 
> When dequeuing from the unconsumed queue, perhaps there should be a
> "dequeue_local" function which omits the normal barriers required
> for the shared queue.
> 
> With a splice and without needing barriers for iteration, this sounds good.

Well actually, __wfcq_dequeue() is really not that expensive. In terms
of synchronization, here is what it typically does:

node = ___wfcq_node_sync_next(&head->node);
  -> busy wait if node->next is NULL. This check is needed even if we
     work on a "local" queue, because the O(1) splice operation does not
     walk over every node to check for NULL next pointer: this is left
     to the dequeue/iteration operations.
if ((next = CMM_LOAD_SHARED(node->next)) == NULL) {
  -> only taken if we are getting the last node of the queue. Happens
     at most once per batch.
}

head->node.next = next;
  -> a simple store.

smp_read_barrier_depends();
  -> no-op on everything but Alpha.

return node;

So my recommendation would be to be careful before trying to come up
with flavors that remove barriers if those are not actually hurting the
fast-path significantly. By dequeue fast-path, I mean what needs to be
executed for dequeue of each node.

> 
> > Another approach could be to let you work directly on the shared queue:
> > 
> > I could possibly implement a
> > 
> > void __wfcq_snapshot(struct wfcq_head *head,
> >                 struct wfcq_tail *tail);
> > 
> > That would save a tail shapshot that would then be used to stop
> > iteration, dequeue and splice at the location of the tail snapshot. And
> > 
> > void __wfcq_snapshot_reset(struct wfcq_head *head,
> >                 struct wfcq_tail *tail);
> > 
> > would set the tail snapshot pointer back to NULL.
> > 
> > This would require a few extra checks, but nothing very expensive I
> > expect.
> > 
> > Thoughts ?
> 
> I'm not sure I follow, would using it be something like this?
> 
> 	snapshot
> 	iterate (read-only, no dequeue)
> 	splice(discard_head, discard_tail, shared_head, iter_stop_point)
> 	snapshot_reset

My idea was more like:

snapshot
__wfcq_dequeue until returns NULL or reach max
snapshot_reset

But I would really prefer the splice approach unless there is a very
significant performance gain to do otherwise, because I don't want to
clutter the API with various ways of performing the same thing
needlessly.

> 
> I also use an atomic state variable to prevent an item from being queued
> twice, and I unset that while iterating+dequeueing.
> 
> I change the state to IDLE while iterating and ep_poll_callback sets
> state READY on any item before being spliced out, that would cause the
> event to be lost when it's spliced out.
> 
> So I think dequeue/state IDLE while iterating is required for epoll_wait,
> I'll try the private queue.

Yep. Just to summarize the private queue approach:

within your epoll queue structure:

struct wfcq_tail queue_tail;       /* enqueue fast-path */

/* Below only touched by splice and dequeue */
struct wfcq_head queue_head;
struct wfcq_tail unconsumed_tail;
struct wfcq_head unconsumed_head ____cacheline_aligned;  /* dequeue fast-path */

In fact, what we really, really care about is that enqueue and dequeue
fast-paths don't touch the same cache-line. For the other fields, we
don't really care.

Then, when you need to handle the batch:

/* Hold dequeue mutex */

(void) __wfcq_splice(&epoll_queue->unconsumed_head,
        &epoll_queue->unconsumed_tail,
        &epoll_queue->queue_head,
        &epoll_queue->queue_tail);
/* You don't care about the return value here. */

for (i = 0; i < max_ev; i++) {
        struct wfcq_node *node;

        node = __wfcq_dequeue(&epoll_queue->unconsumed_head,
                        &epoll_queue->unconsumed_tail);
        if (!node)
                break;
        /* Deal with node, free node's container */
}

/* Release dequeue mutex */

You don't need to do an extra check for empty queues, because these
checks are embedded into splice and dequeue operations.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
