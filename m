Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaBJVcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:32:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36699 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaBJVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:32:17 -0500
Date: Mon, 10 Feb 2014 22:32:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 5/8] locking, mutex: Cancelable MCS lock for adaptive
 spinning
Message-ID: <20140210213202.GX2936@laptop.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.671232531@infradead.org>
 <1392066959.2051.2.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392066959.2051.2.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:15:59PM -0800, Jason Low wrote:
> On Mon, 2014-02-10 at 20:58 +0100, Peter Zijlstra wrote:
> > +void osq_unlock(struct optimistic_spin_queue **lock)
> > +{
> > +	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
> > +	struct optimistic_spin_queue *next;
> > +
> > +	/*
> > +	 * Fast path for the uncontended case.
> > +	 */
> > +	if (likely(cmpxchg(lock, node, NULL) == node))
> > +		return;
> 
> Can we can also add the following code here as I'm noticing next != NULL
> is the much more likely scenario on my box:
> 
>         next = xchg(&node->next, NULL);
>         if (next) {
>                 ACCESS_ONCE(next->locked) = 1;
>                 return;

Is adding that really much faster than the relatively straight path
oqs_wait_next() would walk to bit the same exit?

The only reason I pulled out the above cmpxchg() is because its the
uncontended fast path, which seems like a special enough case.

> > +	next = osq_wait_next(lock, node, NULL);
> > +	if (next)
> > +		ACCESS_ONCE(next->locked) = 1;
> > +}
> 
