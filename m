Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaBJWEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:04:38 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:38286 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBJWEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:04:36 -0500
Message-ID: <1392069862.2918.26.camel@j-VirtualBox>
Subject: Re: [PATCH 5/8] locking, mutex: Cancelable MCS lock for adaptive
 spinning
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Mon, 10 Feb 2014 14:04:22 -0800
In-Reply-To: <20140210213202.GX2936@laptop.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
	 <20140210203659.671232531@infradead.org>
	 <1392066959.2051.2.camel@j-VirtualBox>
	 <20140210213202.GX2936@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 22:32 +0100, Peter Zijlstra wrote:
> On Mon, Feb 10, 2014 at 01:15:59PM -0800, Jason Low wrote:
> > On Mon, 2014-02-10 at 20:58 +0100, Peter Zijlstra wrote:
> > > +void osq_unlock(struct optimistic_spin_queue **lock)
> > > +{
> > > +	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
> > > +	struct optimistic_spin_queue *next;
> > > +
> > > +	/*
> > > +	 * Fast path for the uncontended case.
> > > +	 */
> > > +	if (likely(cmpxchg(lock, node, NULL) == node))
> > > +		return;
> > 
> > Can we can also add the following code here as I'm noticing next != NULL
> > is the much more likely scenario on my box:
> > 
> >         next = xchg(&node->next, NULL);
> >         if (next) {
> >                 ACCESS_ONCE(next->locked) = 1;
> >                 return;
> 
> Is adding that really much faster than the relatively straight path
> oqs_wait_next() would walk to bit the same exit?
> 
> The only reason I pulled out the above cmpxchg() is because its the
> uncontended fast path, which seems like a special enough case.

So it would avoid 2 extra checks (*lock == node) and (node->next) in the
oqs_wait_next() path, which aren't necessary when node->next != NULL.

And I think node->next != NULL can be considered a special enough case
after the cmpxchg() fails because in the contended case, we're expecting
the node->next to be pointing at something. The only times node->next is
NULL after cmpxchg() fails are during a very small race window with the
osq_lock(), and when the next node is unqueuing due to need_resched,
which is also a very small window.

