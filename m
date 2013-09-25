Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3IYR57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab3IYR56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:57:58 -0400
Date: Wed, 25 Sep 2013 19:50:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130925175055.GA25914@redhat.com>
References: <20130917162050.GK22421@suse.de> <20130917164505.GG12926@twins.programming.kicks-ass.net> <20130918154939.GZ26785@twins.programming.kicks-ass.net> <20130919143241.GB26785@twins.programming.kicks-ass.net> <20130921163404.GA8545@redhat.com> <20130923092955.GV9326@twins.programming.kicks-ass.net> <20130923173203.GA20392@redhat.com> <20130924202423.GW12926@twins.programming.kicks-ass.net> <20130925155515.GA17447@redhat.com> <20130925174307.GA3220@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925174307.GA3220@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25, Peter Zijlstra wrote:
>
> On Wed, Sep 25, 2013 at 05:55:15PM +0200, Oleg Nesterov wrote:
>
> > > +static inline void get_online_cpus(void)
> > > +{
> > > +	might_sleep();
> > > +
> > > +	/* Support reader-in-reader recursion */
> > > +	if (current->cpuhp_ref++) {
> > > +		barrier();
> > > +		return;
> > > +	}
> > > +
> > > +	preempt_disable();
> > > +	if (likely(!__cpuhp_writer))
> > > +		__this_cpu_inc(__cpuhp_refcount);
> >
> > mb() to ensure the reader can't miss, say, a STORE done inside
> > the cpu_hotplug_begin/end section.
> >
> > put_online_cpus() needs mb() as well.
>
> OK, I'm not getting this; why isn't the sync_sched sufficient to get out
> of this fast path without barriers?

Aah, sorry, I didn't notice this version has another synchronize_sched()
in cpu_hotplug_done().

Then I need to recheck again...

No. Too tired too ;) damn LSB test failures...

> > > +	if (atomic_dec_and_test(&cpuhp_waitcount))
> > > +		wake_up_all(&cpuhp_writer);
> >
> > Same problem as in previous version. __get_online_cpus() succeeds
> > without incrementing __cpuhp_refcount. "goto start" can't help
> > afaics.
>
> I added a goto into the cond-block, not before the cond; but see the
> version below.

"into the cond-block" doesn't look right too, at first glance. This
always succeeds, but by this time another writer can already hold
the lock.

Oleg.

