Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaFUAgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 20:36:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42563 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaFUAgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 20:36:39 -0400
Date: Fri, 20 Jun 2014 17:36:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/5] Fix for cond_resched performance
 regression
Message-ID: <20140621003632.GA27808@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <20140620191236.GA10340@linux.vnet.ibm.com>
 <20140620212423.GA22886@cloud>
 <20140620221120.GD4615@linux.vnet.ibm.com>
 <20140620223951.GA23677@cloud>
 <20140620233033.GE4615@linux.vnet.ibm.com>
 <20140620235215.GA24026@cloud>
 <20140621001418.GF4615@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140621001418.GF4615@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062100-0928-0000-0000-000002CD0779
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 05:14:18PM -0700, Paul E. McKenney wrote:
> On Fri, Jun 20, 2014 at 04:52:15PM -0700, josh@joshtriplett.org wrote:
> > On Fri, Jun 20, 2014 at 04:30:33PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jun 20, 2014 at 03:39:51PM -0700, josh@joshtriplett.org wrote:
> > > > On Fri, Jun 20, 2014 at 03:11:20PM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Jun 20, 2014 at 02:24:23PM -0700, josh@joshtriplett.org wrote:
> > > > > > On Fri, Jun 20, 2014 at 12:12:36PM -0700, Paul E. McKenney wrote:
> > > > > > > o	Make cond_resched() a no-op for PREEMPT=y.  This might well turn
> > > > > > > 	out to be a good thing, but it doesn't help give RCU the quiescent
> > > > > > > 	states that it needs.
> > > > > > 
> > > > > > What about doing this, together with letting the fqs logic poke
> > > > > > un-quiesced kernel code as needed?  That way, rather than having
> > > > > > cond_resched do any work, you have the fqs logic recognize that a
> > > > > > particular CPU has gone too long without quiescing, without disturbing
> > > > > > that CPU at all if it hasn't gone too long.
> > > > > 
> > > > > My next stop is to post the previous series, but with a couple of
> > > > > exports and one bug fix uncovered by testing thus far, but after
> > > > > another round of testing.  Then I am going to take a close look at
> > > > > this one:
> > > > > 
> > > > > o	Push the checks further into cond_resched(), so that the
> > > > > 	fastpath does the same sequence of instructions that the original
> > > > > 	did.  This might work well, but requires IPIs, which are not so
> > > > > 	good for latencies on the remote CPU.  It nevertheless might be a
> > > > > 	decent long-term solution given that if your CPU is spending many
> > > > > 	jiffies looping in the kernel, you aren't getting good latencies
> > > > > 	anyway.  It also has the benefit of allowing RCU to take advantage
> > > > > 	of the implicit quiescent states of all cond_resched() calls,
> > > > > 	and of eliminating the need for a separate cond_resched_rcu_qs()
> > > > > 	and for RCU_COND_RESCHED_QS.
> > > > > 
> > > > > The one you call out is of course interesting as well.  But there are
> > > > > a couple of questions:
> > > > > 
> > > > > 1.	Why wasn't cond_resched() a no-op in CONFIG_PREEMPT to start
> > > > > 	with?  It just seems to obvious a thing to do for it to possibly
> > > > > 	be an oversight.  (What, me paranoid?)
> > > > > 
> > > > > 2.	When RCU recognizes that a particular CPU has gone too long,
> > > > > 	exactly what are you suggesting that RCU do about it?  When
> > > > > 	formulating your answer, please give due consideration to the
> > > > > 	implications of that CPU being a NO_HZ_FULL CPU.  ;-)
> > > > 
> > > > Send it an IPI that either causes it to flag a quiescent state
> > > > immediately if currently quiesced or causes it to quiesce at the next
> > > > opportunity if not.
> > > 
> > > OK.  But if we are in a !PREEMPT kernel,
> > 
> > That's not the case I was suggesting.
> 
> Fair enough, but we still need to support !PREEMPT kernels.
> 
> >                                        *If* the kernel is fully
> > preemptible, then it makes little sense to put any code in cond_resched,
> > when instead another thread can simply cause a preemption if it needs a
> > quiescent state.  That has the advantage of not imposing any unnecessary
> > polling on code running in the kernel.
> 
> OK.  Exactly which thread are you suggesting should cause the preemption?
> 
> > In a !PREEMPT kernel, it makes a bit more sense to have cond_resched as
> > a voluntary preemption point.  But voluntary preemption points don't
> > make as much sense in a kernel prepared to preempt a thread anywhere.
> 
> That does sound intuitive, but I am not yet prepared to believe that
> the scheduler guys missed this trick.  There might well be some good
> reason for cond_resched() doing something, though I cannot think what it
> might be (something to do with preempt_enable_no_resched(), perhaps?).
> We should at least ask them, although if you want to do some testing
> before asking them, I of course have no objection to your doing so.

Oh, and it turns out to be possible to drive RCU's need-a-qs check much
farther down the cond_resched() rabbit hole than I expected.  Looks like
it can be driven all the way down to rcu_note_context_switch().

							Thanx, Paul

