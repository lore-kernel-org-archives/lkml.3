Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaCQKNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:13:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56241 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaCQKNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:13:24 -0400
Date: Mon, 17 Mar 2014 11:13:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, josh@joshtriplett.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140317101300.GA27965@twins.programming.kicks-ass.net>
References: <20140316015914.GA22102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140316015914.GA22102@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 06:59:14PM -0700, Paul E. McKenney wrote:
> So I have been tightening up rcutorture a bit over the past year.
> The other day, I came across what looked like a great opportunity for
> further tightening, namely the schedule() in rcu_torture_reader().
> Why not turn this into a cond_resched(), speeding up the readers a bit
> and placing more stress on RCU?
> 
> And boy does it increase stress!
> 
> Unfortunately, this increased stress sometimes shows up in the form of
> lots of RCU CPU stall warnings.  These can appear when an instance of
> rcu_torture_reader() gets a CPU to itself, in which case it won't ever
> enter the scheduler, and RCU will never see a quiescent state from that
> CPU, which means the grace period never ends.
> 
> So I am taking a more measured approach to cond_resched() in
> rcu_torture_reader() for the moment.
> 
> But longer term, should cond_resched() imply a set of RCU
> quiescent states?  One way to do this would be to add calls to
> rcu_note_context_switch() in each of the various cond_resched() functions.
> Easy change, but of course adds some overhead.  On the other hand,
> there might be more than a few of the 500+ calls to cond_resched() that
> expect that RCU CPU stalls will be prevented (to say nothing of
> might_sleep() and cond_resched_lock()).
> 
> Thoughts?

I share Mike's concern. Some of those functions might be too expensive
to do in the loops where we have the cond_resched()s. And while its only
strictly required when nr_running==1, keying off off that seems
unfortunate in that it makes things behave differently with a single
running task.

I suppose your proposed per-cpu counter is the best option; even though
its still an extra cacheline hit in cond_resched().

As to the other cond_resched() variants; they might be a little more
tricky, eg. cond_resched_lock() would have you drop the lock in order to
note the QS, etc.

So one thing that might make sense is to have something like
rcu_should_qs() which will indicate RCUs need for a grace period end.
Then we can augment the various should_resched()/spin_needbreak() etc.
with that condition.

That also gets rid of the counter (or at least hides it in the
implementation if RCU really can't do anything better).

