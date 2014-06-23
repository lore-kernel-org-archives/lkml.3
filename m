Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaFWTFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:05:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54892 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbaFWTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:05:33 -0400
Date: Mon, 23 Jun 2014 12:05:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Romanov Arya <romanov.arya@gmail.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: simplify
 force_quiescent_state()
Message-ID: <20140623190528.GM4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539FAE21.7070702@gmail.com>
 <20140617145419.GE4669@linux.vnet.ibm.com>
 <CAJKcOGdUDwdmdkpd0dw5xO9+TK=9W9fvF9Q+f5F_b4R8cEgdTA@mail.gmail.com>
 <53A07336.7030704@hp.com>
 <20140617171116.GH4669@linux.vnet.ibm.com>
 <20140617173717.GA28198@linux.vnet.ibm.com>
 <20140623102850.GX19860@laptop.programming.kicks-ass.net>
 <20140623155750.GD4603@linux.vnet.ibm.com>
 <20140623173308.GA3550@linux.vnet.ibm.com>
 <20140623185735.GJ13930@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623185735.GJ13930@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062319-6688-0000-0000-000002C4A739
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:57:35PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 23, 2014 at 10:33:08AM -0700, Paul E. McKenney wrote:
> > On Mon, Jun 23, 2014 at 08:57:50AM -0700, Paul E. McKenney wrote:
> > > On Mon, Jun 23, 2014 at 12:28:50PM +0200, Peter Zijlstra wrote:
> > > > On Tue, Jun 17, 2014 at 10:37:17AM -0700, Paul E. McKenney wrote:
> > > > > Oh, and to answer the implicit question...  A properly configured 4096-CPU
> > > > > system will have two funnel levels, with 64 nodes at the leaf level
> > > > > and a single node at the root level.  If the system is not properly
> > > > > configured, it will have three funnel levels.  The maximum number of
> > > > > funnel levels is four, which would handle more than four million CPUs
> > > > > (sixteen million if properly configured), so we should be good.  ;-)
> > > > > 
> > > > > The larger numbers of levels are intended strictly for testing.  I set
> > > > > CONFIG_RCU_FANOUT_LEAF=2 and CONFIG_RCU_FANOUT=2 on a 16-CPU system just
> > > > > to make sure that I am testing something uglier than what will be running
> > > > > in production.  A large system should have both of these set to 64,
> > > > > though this requires also booting with skew_tick=1 as well.
> > > > 
> > > > Right, and I think we talked about this before; the first thing one
> > > > should do is align the RCU fanout masks with the actual machine
> > > > topology. Because currently they can be all over the place.
> > > 
> > > And we also talked before about how it would make a lot more sense to
> > > align the CPU numbering with the actual machine topology, as that would
> > > fix the problem in one place.  But either way, in the particular case
> > > of the RCU fanout, does anyone have any real data showing that this is
> > > a real problem?  Given that the rcu_node accesses are quite a ways off
> > > of any fastpath, I remain skeptical.
> > 
> > And one way to test for this is to set CONFIG_RCU_FANOUT to the number of
> > cores in a socket (or to the number of hardware threads per socket for
> > systems that number their hardware threads consecutively), then specify
> > CONFIG_RCU_FANOUT_EXACT=y.  This will align the rcu_node structures with
> > the sockets.  If the number of cores/threads per socket is too large,
> > you can of course use a smaller number that exactly divides the number
> > of cores/threads per socket.
> 
> Typical Intel cpu numbering is [0..n) for SMT0 and [n..2*n) for SMT1, so
> that'll fall flat on its face at try 1.

I am quite painfully aware of that CPU numbering scheme, which is why
I suggested using the number of cores per socket as well as the number
of threads per socket.

							Thanx, Paul

