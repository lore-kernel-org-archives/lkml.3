Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3EPJtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:49:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3EPJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:49:03 -0400
Date: Thu, 16 May 2013 11:45:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130516094519.GJ19669@dyad.programming.kicks-ass.net>
References: <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
 <20130515090234.GE10510@laptop.programming.kicks-ass.net>
 <20130515173142.GL4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515173142.GL4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:31:42AM -0700, Paul E. McKenney wrote:
> On Wed, May 15, 2013 at 11:02:34AM +0200, Peter Zijlstra wrote:

> > Earlier you said that improving EQS behaviour was expensive in that it
> > would require taking (global) locks or somesuch.
> > 
> > Would it not be possible to have the cpu performing a FQS finish this
> > work; that way the first FQS would be a little slow, but after that no
> > FQS would be needed anymore, right? Since we'd no longer require the
> > other CPUs to end a grace period.
> 
> It is not just the first FQS that would be slow, it would also be slow
> the next time that this CPU transitioned from idle to non-idle, which
> is when this work would need to be undone.

Hurm, yes I suppose that is true. If you've saved more on FQS cost it might be
worth it for the throughput people though.

But somehow I imagined making a CPU part of the GP would be easier than taking
it out. After all, taking it out is dangerous and careful work, one is not to
accidentally execute a callback or otherwise end a GP before time.

When entering the GP cycle there is no such concern, the CPU state is clean
after all.

> Furthermore, in this approach, RCU would still need to scan all the CPUs
> to see if any did the first part of the transition to idle.  And if we
> have to scan either way, why not keep the idle-nonidle transitions cheap
> and continue to rely on the scan?  Here are the rationales I can think
> of and what I am thinking in terms of doing instead:
> 
> 1.	The scan could become a scalability bottleneck.  There is one
> 	way to handle this today, and one possible future change.  The way
> 	to handle this today is to increas rcutree.jiffies_till_first_fqs,
> 	for example, the SGI guys set it to 20 or thereabouts.  If this
> 	becomes problematic, I could easily create multiple kthreads to
> 	carry out the FQS scan in parallel for large systems.

*groan* whoever thought all this SMP nonsense was worth it again? :-)

> 2.	Someone could demonstrate that RCU's grace periods were significantly
> 	delaying boot.  There are several ways of dealing with this:

Surely there's also non-boot cases where most of the machine is 'idle' and
we're running into FQS? Esp. now with that userspace NO_HZ stuff from Frederic.
