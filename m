Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaHMOM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:12:27 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59745 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMOMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:12:25 -0400
Date: Wed, 13 Aug 2014 07:12:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813141217.GU4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813134025.GN9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081314-1344-0000-0000-0000036F981F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 03:40:25PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 13, 2014 at 05:48:18AM -0700, Paul E. McKenney wrote:
> > On Wed, Aug 13, 2014 at 10:12:15AM +0200, Peter Zijlstra wrote:
> > > On Mon, Aug 11, 2014 at 03:49:04PM -0700, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Because idle-task code may need to be patched, RCU-tasks need to wait
> > > > for idle tasks to schedule.  This commit therefore detects this case
> > > > via context switch.  Block CPU hotplug during this time to avoid sending
> > > > IPIs to offline CPUs.
> > > > 
> > > > Note that checking for changes in the dyntick-idle counters is tempting,
> > > > but wrong.  The reason that it is wrong is that a interrupt or NMI can
> > > > increment these counters without necessarily allowing the idle tasks to
> > > > make any forward progress.
> > > 
> > > I'm going to NAK this.. with that rcu_idle patch I send there's
> > > typically only a single idle function thats out of bounds and if its
> > > more it can be made that with a bit of tlc to the cpuidle driver in
> > > question.
> > > 
> > > This needs _FAR_ more justification than a maybe and a want.
> > 
> > Peter, your patch might be a good start, but I didn't see any reaction
> > from Steven or Masami and it did only x86.
> 
> That's not an excuse for doing horrible things. And inventing new infra
> that needs to wake all CPUs is horrible.

Does your patch even work?  Looks like it should, and yes, the idle loop
seems quite a bit simpler than it was a few years ago, but we really
don't need some strange thing that leaves a CPU idle but not visible as
such to RCU.

I have already said that I will be happy to rip out the wakeup code
when it is no longer needed, and I agree that it would be way better if
not needed.  But I won't base a patch on hypotheticals.  You have already
drawn way too much water from -that- well over the past years!  ;-)

							Thanx, Paul

