Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbaD3QXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:23:11 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:39121 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbaD3QXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:23:09 -0400
Message-ID: <1398874984.2618.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 09:23:04 -0700
In-Reply-To: <20140430091425.GC11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140430091425.GC11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 11:14 +0200, Peter Zijlstra wrote:
> On Mon, Apr 28, 2014 at 03:09:01PM -0700, Davidlohr Bueso wrote:
> > +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> > +{
> > +	int retval;
> > +	struct task_struct *owner;
> > +
> > +	rcu_read_lock();
> > +	owner = ACCESS_ONCE(sem->owner);
> > +
> > +	/* Spin only if active writer running */
> > +	if (owner)
> > +		retval = owner->on_cpu;
> > +	else {
> > +		/*
> > +		 * When the owner is not set, the sem owner may have just
> > +		 * acquired it and not set the owner yet, or the sem has
> > +		 * been released, or reader active.
> > +		 */
> > +		retval = false;
> > +	}
> > +	rcu_read_unlock();
> > +
> > +	return retval;
> > +}
> 
> Also, the mutex case has a need_resched() test in there; any particular
> reason you didn't mirror that?

Good catch. I had made sure we have it in rwsem_optimistic_spin() but
overlooked this function, will update.

