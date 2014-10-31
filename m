Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaJaQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:57:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53936 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaJaQ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:57:23 -0400
Date: Fri, 31 Oct 2014 09:57:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH tip/core/rcu 4/7] rcu: Unify boost and kthread priorities
Message-ID: <20141031165716.GB5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534982-29203-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20141029110146.GA3337@twins.programming.kicks-ass.net>
 <20141029161602.GT5718@linux.vnet.ibm.com>
 <20141031162210.GV23531@worktop.programming.kicks-ass.net>
 <20141031164229.GY5718@linux.vnet.ibm.com>
 <20141031165143.GN10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031165143.GN10501@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103116-0025-0000-0000-000005C2C4A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 05:51:43PM +0100, Peter Zijlstra wrote:
> On Fri, Oct 31, 2014 at 09:42:30AM -0700, Paul E. McKenney wrote:
> 
> > Well, you are supposed to determine the highest RT priority at which
> > your workload might run CPU-bound tasks, and set the boost priority
> > at some level above that.  My model of RCU priority boosting is that
> > it should be used to make inadvertent high-priority infinite loops
> > easier to debug, but others might have different approaches.
> 
> Ah, so DL will never be CPU-bound -- and RR/FIFO _should_ never be, but
> I digress ;-)

;-) ;-) ;-)

> > > We should be able to detect the case where more and work piles on and
> > > the actual running does not appear to catch up, but I'm not sure what to
> > > do about it, seeing how system stability is at risk.
> > 
> > I could imagine having a backup SCHED_FIFO task that handled the
> > case where callbacks were piling up, but synchronizing it with the
> > SCHED_DEADLINE task while avoiding callback misordering could be a bit
> > "interesting".  (Recall that callback misordering messes up rcu_barrier().)
> 
> Ah, so there is talk of 'soft' CBS modes, which instead of hard throttle
> either reclaim 'unused' DL bandwidth, or continue running in lower scheduling
> classes.

OK, something like that might work in this case, at least making the
dubious assumption that I actually understand what you are getting at.  ;-)

You might be amused to hear that one of the solutions in my back pocket
for the potential problem of callbacks piling up in the current RCU
priority boosting scheme is to temporarily increase the priority.  This is
similar to how blimit gets increased if too many callbacks pile up.

Thus far, no need for this back-pocket solution, but I wanted to put it
out there in case it sparks something in the SCHED_DEADLINE approach.

							Thanx, Paul

