Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaICSTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:19:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35050 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaICSTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:19:36 -0400
Date: Wed, 3 Sep 2014 11:19:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140903181931.GB5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140902203743.GL5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021545370.32690@gentwo.org>
 <20140902211517.GO5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
 <20140903021152.GA14069@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409030846310.9372@gentwo.org>
 <20140903144349.GT5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031043540.24085@gentwo.org>
 <20140903171409.GZ5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031226001.24691@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409031226001.24691@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090318-3532-0000-0000-00000457F9D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 12:43:15PM -0500, Christoph Lameter wrote:
> On Wed, 3 Sep 2014, Paul E. McKenney wrote:
> 
> > > Well, a shared data structure would be cleaner in general but there are
> > > certainly other approaches.
> >
> > Per-CPU variables -are- a shared data structure.
> 
> No the intent is for them to be for the particular cpu and therefore
> there is limited support for sharing. Its not a shared data structure in
> the classic sense.

It really is shared.  Normal memory at various addresses and all that.

So what is your real concern here, anyway?

> The code in the rcu subsystem operates like other percpu code: There is a
> modification of local variables by the current processor and other
> processors inspect the state once in awhile. The other percpu code does
> not need atomics and barriers. RCU for some reason (that is not clear to
> me) does.

Like I have said several times before in multiple email threads, including
this one, RCU needs to reliably detect quiescent states.  To do this, it
needs do know that the accesses prior to the quiescent state will reliably
be seen by all as having happened before the quiescent state started.
Similarly, it needs to know that the accesses after the quiescent state
will reliably be seen by all as having happened after the quiescent
state ended.  The memory barriers are required to enforce this ordering.

As noted earlier, in theory, the atomic operations could be nonatomic,
but on x86 this would require adding explicit memory-barrier instructions.
Not clear to me which would be faster.

> > > But lets focus on the dynticks_idle case we are discussing here rather
> > > than tackle the more difficult other atomics. What is checked in the loop
> > > over the remote cpus is the dynticks_idle value plus
> > > dynticks_idle_jiffies. So it seems that memory ordering is only used to
> > > ensure that the jiffies are seen correctly.
> > >
> > > In that case both the dynticks_idle and dynticks_idle_jiffies could be
> > > placed in one 64 bit value. If this is stored and retrieved as one then
> > > there is no issue with ordering anymore and the barriers would no longer
> > > be needed.
> >
> > If there was an upper bound on the propagation of values through a system,
> > I could buy this.
> 
> What is different in propagation speeds? The atomic read on the function
> that checks for the quiescent period having passed is a regular read
> anyways. The atomic_inc makes the cacheline propagate faster through the
> system? I understand that it evicts the cachelines from other processors
> caches (containing other percpu data by the way). That is the desired
> effect?

The smp_mb__{before,after}_atomic() guarantee the ordering.

> > But Mike Galbraith checked the overhead of ->dynticks_idle and found
> > it to be too small to measure.  So doesn't seem to be a problem worth
> > extraordinary efforts, especially given that many systems can avoid
> > it simply by leaving CONFIG_NO_HZ_SYSIDLE=n.
> 
> The code looks fragile and bound to have issues in the future given the
> barriers/atomics etc. Its going to be cleaner without that.

What exactly looks fragile about it, and exactly what issues do you
anticipate?

> And we are right now focusing on the simplest case. The atomics scheme is
> used multiple times in the RCU subsystem. There is more weird looking code
> there like atomic_add using zero etc.

The atomic_add_return(0,...) reads the value out, forcing full ordering.
Again, in theory, this could be a volatile read with explicit memory-barrier
instructions on either side, but it is not clear which wins.  (Keep in
mind that almost all of the atomic_add_return(0,...) calls for a given
dynticks counter are executed from a single kthread.)

If systems continue to add CPUs like they have over the past decade or
so, I expect that you will be seeing more code like RCU's, not less.

							Thanx, Paul

