Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaG2RZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:25:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaG2RZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:25:56 -0400
Date: Tue, 29 Jul 2014 19:25:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 2/9] rcu: Provide cond_resched_rcu_qs()
 to force quiescent states in long loops
Message-ID: <20140729172542.GK3935@laptop>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406588180-21933-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729075536.GZ19379@twins.programming.kicks-ass.net>
 <20140729162236.GP11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140729162236.GP11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:22:36AM -0700, Paul E. McKenney wrote:
> On Tue, Jul 29, 2014 at 09:55:36AM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 28, 2014 at 03:56:13PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > RCU-tasks requires the occasional voluntary context switch
> > > from CPU-bound in-kernel tasks.  In some cases, this requires
> > > instrumenting cond_resched().  However, there is some reluctance
> > > to countenance unconditionally instrumenting cond_resched() (see
> > > http://lwn.net/Articles/603252/),
> > 
> > No, if its a good reason mention it, if not ignore it.
> 
> Fair enough.  ;-)
> 
> > > so this commit creates a separate
> > > cond_resched_rcu_qs() that may be used in place of cond_resched() in
> > > locations prone to long-duration in-kernel looping.
> > 
> > Sounds like a pain and a recipe for mistakes. How is joe kernel hacker
> > supposed to 1) know about this new api, and 2) decide which to use?
> > 
> > Heck, even I wouldn't know, and I just read the damn patch.
> 
> When Joe Hacker gets stall warning messages due to loops in the kernel
> that contain cond_resched(), that is a hint that cond_resched_rcu_qs()
> is required.  These stall warnings can occur when using RCU-tasks and when
> using normal RCU in NO_HZ_FULL kernels in cases where the scheduling-clock
> interrupt is left off while executing a long code path in the kernel.
> (Of course, in both cases, another eminently reasonable fix is to shorten
> the offending code path in the kernel.)
> 
> I should add words to that effect to Documentation/RCU/stallwarn.txt,
> shouldn't I?  Done.

No, but why can't we make the regular cond_resched() do this?
