Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3JJMTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:19:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37151 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3JJMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:19:38 -0400
Date: Thu, 10 Oct 2013 14:19:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010121908.GB28601@twins.programming.kicks-ass.net>
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009225006.7101379c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 10:50:06PM -0700, Andrew Morton wrote:
> On Tue, 08 Oct 2013 12:25:05 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > The current cpu hotplug lock is a single global lock; therefore excluding
> > hotplug is a very expensive proposition even though it is rare occurrence under
> > normal operation.
> > 
> > There is a desire for a more light weight implementation of
> > {get,put}_online_cpus() from both the NUMA scheduling as well as the -RT side.
> > 
> > The current hotplug lock is a full reader preference lock -- and thus supports
> > reader recursion. However since we're making the read side lock much cheaper it
> > is the expectation that it will also be used far more. Which in turn would lead
> > to writer starvation.
> > 
> > Therefore the new lock proposed is completely fair; albeit somewhat expensive
> > on the write side. This in turn means that we need a per-task nesting count to
> > support reader recursion.
> 
> This is a lot of code and a lot of new complexity.  It needs some pretty
> convincing performance numbers to justify its inclusion, no?

And here I thought it was generally understood to be unwise to bash
global state on anything like a regular manner from every cpu.

The NUMA bits really ought to use get_online_cpus()/put_online_cpus() on
every balance pass; which is about once a second on every cpu.

RT -- which has some quite horrible hotplug hacks due to this --
basically takes get_online_cpus() for every spin_lock/spin_unlock in the
kernel.

But the thing is; our sense of NR_CPUS has shifted, where it used to be
ok to do something like:

  for_each_cpu()

With preemption disabled; it gets to be less and less sane to do so,
simply because 'common' hardware has 256+ CPUs these days. If we cannot
rely on preempt disable to exclude hotplug, we must use
get_online_cpus(), but get_online_cpus() is global state and thus cannot
be used at any sort of frequency.


