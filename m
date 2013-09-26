Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3IZQNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:13:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54285 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3IZQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:13:33 -0400
Date: Thu, 26 Sep 2013 18:13:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130926161311.GG3657@laptop.programming.kicks-ass.net>
References: <20130923092955.GV9326@twins.programming.kicks-ass.net>
 <20130923173203.GA20392@redhat.com>
 <20130924202423.GW12926@twins.programming.kicks-ass.net>
 <20130925155515.GA17447@redhat.com>
 <20130925174307.GA3220@laptop.programming.kicks-ass.net>
 <20130925175055.GA25914@redhat.com>
 <20130925184015.GC3657@laptop.programming.kicks-ass.net>
 <20130925212200.GA7959@linux.vnet.ibm.com>
 <20130926111042.GS3081@twins.programming.kicks-ass.net>
 <20130926155321.GA4342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926155321.GA4342@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 05:53:21PM +0200, Oleg Nesterov wrote:
> On 09/26, Peter Zijlstra wrote:
> >  void cpu_hotplug_done(void)
> >  {
> > -	cpu_hotplug.active_writer = NULL;
> > -	mutex_unlock(&cpu_hotplug.lock);
> > +	/* Signal the writer is done, no fast path yet. */
> > +	__cpuhp_state = readers_slow;
> > +	wake_up_all(&cpuhp_readers);
> > +
> > +	/*
> > +	 * The wait_event()/wake_up_all() prevents the race where the readers
> > +	 * are delayed between fetching __cpuhp_state and blocking.
> > +	 */
> > +
> > +	/* See percpu_up_write(); readers will no longer attempt to block. */
> > +	synchronize_sched();
> 
> Shouldn't you move wake_up_all(&cpuhp_readers) down after
> synchronize_sched() (or add another one) ? To ensure that a reader can't
> see state = BLOCK after wakeup().

Well, if they are blocked, the wake_up_all() will do an actual
try_to_wake_up() which issues a MB as per smp_mb__before_spinlock().

The woken task will get a MB from passing through the context switch to
make it actually run. And therefore; like Paul's comment says; it cannot
observe the previous BLOCK state but must indeed see the just issued
SLOW state.

Right?
