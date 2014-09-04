Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaIDQQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:16:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60515 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaIDQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:16:36 -0400
Date: Thu, 4 Sep 2014 09:16:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140904161629.GF5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140902211517.GO5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
 <20140903021152.GA14069@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409030846310.9372@gentwo.org>
 <20140903144349.GT5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031043540.24085@gentwo.org>
 <20140903171409.GZ5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031226001.24691@gentwo.org>
 <20140903181931.GB5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409040944220.4565@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409040944220.4565@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090416-1542-0000-0000-000004894E54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:04:17AM -0500, Christoph Lameter wrote:
> 
> On Wed, 3 Sep 2014, Paul E. McKenney wrote:
> 
> > As noted earlier, in theory, the atomic operations could be nonatomic,
> 
> Well as demonstrated by the patch earlier: The atomic operations are only
> used on a the local cpu. There is no synchronization in that sense needed
> between processors because there is never a remote atomic operation.

Easy to say!  ;-)

> > > The code looks fragile and bound to have issues in the future given the
> > > barriers/atomics etc. Its going to be cleaner without that.
> >
> > What exactly looks fragile about it, and exactly what issues do you
> > anticipate?
> 
> I am concerned about creation of unecessary synchronization issues. In
> this case we have already discovered that the atomic operations on per
> cpu variables are only used to modify the contents from the local cpu.
> 
> This means at minimum we can give up on the use of atomics and keep the
> barriers to enforce visibility.

Sounds like a desire for a potential optimization rather than any
sort of fragility.  And in this case, it is not clear that your desire
of replacing a value-returning atomic operation with a normal memory
reference and a pair of memory barrier actually makes anything go faster.

So in short, you don't see the potential for this use case actually
breaking anything, correct?

Besides RCU is not the only place where atomics are used on per-CPU
variables.  For one thing, there are a number of per-CPU spinlocks in use
in various places throughout the kernel.  For another thing, there is also
a large number of per-CPU structures (not pointers to structures, actual
structures), and I bet that a fair number of these feature cross-CPU
writes and cross-CPU atomics.  RCU's rcu_data structures certainly do.

> > > And we are right now focusing on the simplest case. The atomics scheme is
> > > used multiple times in the RCU subsystem. There is more weird looking code
> > > there like atomic_add using zero etc.
> >
> > The atomic_add_return(0,...) reads the value out, forcing full ordering.
> > Again, in theory, this could be a volatile read with explicit memory-barrier
> > instructions on either side, but it is not clear which wins.  (Keep in
> > mind that almost all of the atomic_add_return(0,...) calls for a given
> > dynticks counter are executed from a single kthread.)
> >
> > If systems continue to add CPUs like they have over the past decade or
> > so, I expect that you will be seeing more code like RCU's, not less.
> 
> We have other code like this in multiple subsystems but it does not have
> the barrier issues, per cpu variables are updated always without the use
> of atomics and the inspection of the per cpu state from remote cpus works
> just fine also without them.

Including the per-CPU spinlocks?  That seems a bit unlikely.  And again,
I expect that a fair number of the per-CPU structures involve cross-CPU
synchronization.

> I'd like to simplify this as much as possible and make it consistent
> throughout the kernel.

It already is consistent, just not in the manner that you want.  ;-)

But -why- do you want these restrictions?  How does it help anything?

							Thanx, Paul

