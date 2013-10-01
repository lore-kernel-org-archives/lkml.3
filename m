Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3JAOVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab3JAOVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:21:40 -0400
Date: Tue, 1 Oct 2013 16:14:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131001141429.GA32423@redhat.com>
References: <20130925174307.GA3220@laptop.programming.kicks-ass.net> <20130925175055.GA25914@redhat.com> <20130925184015.GC3657@laptop.programming.kicks-ass.net> <20130925212200.GA7959@linux.vnet.ibm.com> <20130926111042.GS3081@twins.programming.kicks-ass.net> <20130926165840.GA863@redhat.com> <20130926175016.GI3657@laptop.programming.kicks-ass.net> <20130927181532.GA8401@redhat.com> <20130927204116.GJ15690@laptop.programming.kicks-ass.net> <20131001035604.GW19582@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001035604.GW19582@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Paul E. McKenney wrote:
>
> On Fri, Sep 27, 2013 at 10:41:16PM +0200, Peter Zijlstra wrote:
> > On Fri, Sep 27, 2013 at 08:15:32PM +0200, Oleg Nesterov wrote:
> > > On 09/26, Peter Zijlstra wrote:
>
> [ . . . ]
>
> > > > +static bool cpuhp_readers_active_check(void)
> > > >  {
> > > > +	unsigned int seq = per_cpu_sum(cpuhp_seq);
> > > > +
> > > > +	smp_mb(); /* B matches A */
> > > > +
> > > > +	/*
> > > > +	 * In other words, if we see __get_online_cpus() cpuhp_seq increment,
> > > > +	 * we are guaranteed to also see its __cpuhp_refcount increment.
> > > > +	 */
> > > >
> > > > +	if (per_cpu_sum(__cpuhp_refcount) != 0)
> > > > +		return false;
> > > >
> > > > +	smp_mb(); /* D matches C */
> > >
> > > It seems that both barries could be smp_rmb() ? I am not sure the comments
> > > from srcu_readers_active_idx_check() can explain mb(), note that
> > > __srcu_read_lock() always succeeds unlike get_cpus_online().
> >
> > I see what you mean; cpuhp_readers_active_check() is all purely reads;
> > there are no writes to order.
> >
> > Paul; is there any argument for the MB here as opposed to RMB; and if
> > not should we change both these and SRCU?
>
> Given that these memory barriers execute only on the semi-slow path,
> why add the complexity of moving from smp_mb() to either smp_rmb()
> or smp_wmb()?  Straight smp_mb() is easier to reason about and more
> robust against future changes.

But otoh this looks misleading, and the comments add more confusion.

But please note another email, it seems to me we can simply kill
cpuhp_seq and all the barriers in cpuhp_readers_active_check().

Oleg.

