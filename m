Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaBZJWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:22:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38976 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaBZJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:22:30 -0500
Date: Wed, 26 Feb 2014 10:22:10 +0100
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
Message-ID: <20140226092210.GH18404@twins.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.671232531@infradead.org>
 <1393358179.7727.34.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393358179.7727.34.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:56:19AM -0800, Jason Low wrote:
> On Mon, 2014-02-10 at 20:58 +0100, Peter Zijlstra wrote:
> 
> > +unqueue:
> > +	/*
> > +	 * Step - A  -- stabilize @prev
> > +	 *
> > +	 * Undo our @prev->next assignment; this will make @prev's
> > +	 * unlock()/unqueue() wait for a next pointer since @lock points to us
> > +	 * (or later).
> > +	 */
> > +
> > +	for (;;) {
> > +		if (prev->next == node &&
> > +		    cmpxchg(&prev->next, node, NULL) == node)
> > +			break;
> > +
> > +		/*
> > +		 * We can only fail the cmpxchg() racing against an unlock(),
> > +		 * in which case we should observe @node->locked becomming
> > +		 * true.
> > +		 */
> > +		if (smp_load_acquire(&node->locked))
> > +			return true;

I've stuck on in right about here. So that we don't unduly delay the
cmpxchg() after the load of prev.

> > +
> > +		/*
> > +		 * Or we race against a concurrent unqueue()'s step-B, in which
> > +		 * case its step-C will write us a new @node->prev pointer.
> > +		 */
> > +		prev = ACCESS_ONCE(node->prev);
> 
> Should we also add an arch_mutex_cpu_relax() to this loop?
> 
> 
