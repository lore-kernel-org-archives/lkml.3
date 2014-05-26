Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaEZQxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:53:18 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59489 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaEZQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:53:17 -0400
Date: Mon, 26 May 2014 18:53:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Split raised and lazy lists
Message-ID: <20140526165312.GF2066@localhost.localdomain>
References: <1401028191-29756-1-git-send-email-fweisbec@gmail.com>
 <1401028191-29756-2-git-send-email-fweisbec@gmail.com>
 <20140526155944.GL30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526155944.GL30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 05:59:44PM +0200, Peter Zijlstra wrote:
> On Sun, May 25, 2014 at 04:29:47PM +0200, Frederic Weisbecker wrote:
> > An irq work can be handled from two places: from the tick if the work
> > carries the "lazy" flag and the tick is periodic, or from a self IPI.
> > 
> > We merge all these works in a single list and we use some per cpu latch
> > to avoid raising a self-IPI when one is already pending.
> > 
> > Now we could do away with this ugly latch if only the list was only made of
> > non-lazy works. Just enqueueing a work on the empty list would be enough
> > to know if we need to raise an IPI or not.
> > 
> > Also we are going to implement remote irq work queuing. Then the per CPU
> > latch will need to become atomic in the global scope. That's too bad
> > because, here as well, just enqueueing a work on an empty list of
> > non-lazy works would be enough to know if we need to raise an IPI or not.
> > 
> > So lets take a way out of this: split the works in two distinct lists,
> > one for the works that can be handled by the next tick and another
> > one for those handled by the IPI. Just checking if the latter is empty
> > when we queue a new work is enough to know if we need to raise an IPI.
> 
> That ^
> 
> >  bool irq_work_queue(struct irq_work *work)
> >  {
> > +	unsigned long flags;
> > +
> >  	/* Only queue if not already pending */
> >  	if (!irq_work_claim(work))
> >  		return false;
> >  
> > -	/* Queue the entry and raise the IPI if needed. */
> > -	preempt_disable();
> > +	/* Check dynticks safely */
> > +	local_irq_save(flags);
> 
> Does not mention this ^
> 
> 'sup?

Because it's really just a technical detail.

If we enqueue before checking for tick stopped, we can avoid disabling irqs
because it's fine if we just raced with an irq in-between.

But now that we enqueue _after_, we can't afford an IRQ in between.

Should I update the comments maybe?


