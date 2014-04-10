Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965734AbaDJSsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:48:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934686AbaDJSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:47:32 -0400
Date: Thu, 10 Apr 2014 17:36:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Clark Williams <williams@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410153617.GN10526@twins.programming.kicks-ass.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
 <20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
 <5346B2C8.6000207@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5346B2C8.6000207@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 05:03:36PM +0200, Sebastian Andrzej Siewior wrote:
> On 04/10/2014 04:44 PM, Clark Williams wrote:
> > The means of each group of five test runs are:
> > 
> > vanilla.log:  1210117 rt.log:  17210953 (14.2 x slower than
> > vanilla) rt-fixes.log:  10062027 (8.3 x slower than vanilla) 
> > rt-multi.log:  3179582  (2.x x slower than vanilla)
> > 
> > 
> > As expected, vanilla kicked RT's butt when hammering on the 
> > mmap_sem. But somewhat unexpectedly, your fixups helped quite a
> > bit and the multi+fixups got RT back into being almost
> > respectable.
> > 
> > Obviously these are just preliminary results on one piece of h/w
> > but it looks promising.
> 
> Is it easy to look at the latency when you have multiple readers and
> and a high prio writer which has to boost all those readers away
> instead just one?
> Or is this something that should not happen for a high prio RT task
> because it has all memory already allocated?

With care it should not happen; it should be relatively straight forward
to avoid all system calls that take mmap_sem for writing.

But yes, the total latency is a concern, that said, that is the very
reason there is a hard limit to the reader concurrency and why this
limit is a tunable.

It defaults to the total number of CPUs in the system, given the default
setup (all CPUs in a single balance domain), this should result in all
CPUs working concurrently on the boosted read sides.

So while there is always some overhead, the worst case should not be
nr_readers * read-hold-time.

Although, with more (unrelated) higher prio threads you can indeed wreck
this. Similarly by partitioning the system and not adjusting the max
reader you also get into trouble.

But then, the above nr_readers * read-hold-time is still an upper bound,
and the entire thing does stay deterministic.
