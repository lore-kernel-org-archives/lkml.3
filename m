Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbbATVgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:36:33 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54494 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbbATVga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:36:30 -0500
Date: Tue, 20 Jan 2015 13:35:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, torvalds@linux-foundation.org,
        oleg@redhat.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Behaviour of smp_mb__{before,after}_spin* and acquire/release
Message-ID: <20150120213545.GT9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150113163353.GE31784@arm.com>
 <20150120093443.GA11596@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120093443.GA11596@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012021-8236-0000-0000-000008C796C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:34:43AM +0100, Peter Zijlstra wrote:
> On Tue, Jan 13, 2015 at 04:33:54PM +0000, Will Deacon wrote:
> > Hi Paul,
> > 
> > I started dusting off a series I've been working to implement a relaxed
> > atomic API in Linux (i.e. things like atomic_read(v, ACQUIRE)) but I'm
> > having trouble making sense of the ordering semantics we have in mainline
> > today:
> 
> >   2. Does smp_mb__after_unlock_lock order smp_store_release against
> >      smp_load_acquire? Again, Documentation/memory-barriers.txt puts
> >      these operations into the RELEASE and ACQUIRE classes respectively,
> >      but since smp_mb__after_unlock_lock is a NOP everywhere other than
> >      PowerPC, I don't think this is enforced by the current code. 
> 
> Yeah, wasn't Paul going to talk to Ben about that? PPC is the only arch
> that has the weak ACQUIRE/RELEASE for its spinlocks.

I thought that you guys were going to propose something and we would see
what the reaction was.  ;-)

> >      Most
> >      architectures follow the pattern used by asm-generic/barrier.h:
> > 
> >        release: smp_mb(); STORE
> >        acquire: LOAD; smp_mb();
> > 
> >      which doesn't provide any release -> acquire ordering afaict.
> 
> Only when combined on the same address, if the LOAD observes the result
> of the STORE we can guarantee the rest of the ordering. And if you
> build a locking primitive with them (or circular lists or whatnot) you
> have that extra condition.
> 
> But yes, I see your argument that this implementation is weak like the
> PPC.

A more complete example would be as follows:

       STOREs followed by release: smp_mb(); STORE A
       acquire: LOAD A; smp_mb(); preceding LOADs

If the LOAD A gets the value from the STORE A, then the LOADs following
the acquire are guaranteed to see the STOREs preceding the release.

And yes, this really truly does work fine with weaker ordering.

							Thanx, Paul

