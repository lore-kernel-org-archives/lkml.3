Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3EPJjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:39:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49233 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EPJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:39:51 -0400
Date: Thu, 16 May 2013 11:37:40 +0200
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
Message-ID: <20130516093740.GI19669@dyad.programming.kicks-ass.net>
References: <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
 <20130515163700.GK4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515163700.GK4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 09:37:00AM -0700, Paul E. McKenney wrote:
> The need is to detect that an idle CPU is idle without making it do
> anything.  To do otherwise would kill battery lifetime and introduce
> OS jitter.

Not anything isn't leaving us much room to wriggle, we could maybe try and do a
wee bit without people shooting us :-) In fact, looking at rcu_idle_enter()
its very much not an empty function.

> This other CPU must be able to correctly detect idle CPUs regardless of
> how long they have been idle.  In particular, it is necessary to detect
> CPUs that were idle at the start of the current grace period and have
> remained idle throughout the entirety of the current grace period.

OK, so continuing this hypothetical merry go round :-) 

Since RCU is a global endeavour, I'm assuming there is a global GP sequence
number. Could we not stamp the CPU with the current GP# in rcu_idle_enter().

> A CPU might transition between idle and non-idle states at any time.
> Therefore, if RCU collects a given CPU's idleness state during a given
> grace period, it must be very careful to avoid relying on that state
> during some other grace period.

However, if we know during which GP it became idle, we know we can ignore it
for all GPs thereafter, right?

> Therefore, from what I can see, unless all CPUs explicitly report a
> quiescent state in a timely fashion during a given grace period (in
> which case each CPU was non-idle at some point during that grace period),
> there is no alternative to polling RCU's per-CPU rcu_dynticks structures
> during that grace period.  In particular, if at least one CPU remained
> idle throughout that grace period, it will be necessary to poll.

Agreed.. 

> Of course, during boot time, there are often long time periods during
> which at least one CPU remains idle.  Therefore, we can expect many
> boot-time grace periods to delay for at least one FQS time period.
> 
> OK, so how much delay does this cause? 

Oh, I'm so way past that, it is a neat puzzle by now ;-)
