Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3JAD4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:56:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39935 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3JAD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:56:10 -0400
Date: Mon, 30 Sep 2013 20:56:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131001035604.GW19582@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130925155515.GA17447@redhat.com>
 <20130925174307.GA3220@laptop.programming.kicks-ass.net>
 <20130925175055.GA25914@redhat.com>
 <20130925184015.GC3657@laptop.programming.kicks-ass.net>
 <20130925212200.GA7959@linux.vnet.ibm.com>
 <20130926111042.GS3081@twins.programming.kicks-ass.net>
 <20130926165840.GA863@redhat.com>
 <20130926175016.GI3657@laptop.programming.kicks-ass.net>
 <20130927181532.GA8401@redhat.com>
 <20130927204116.GJ15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927204116.GJ15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100103-9332-0000-0000-00000199D13A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 10:41:16PM +0200, Peter Zijlstra wrote:
> On Fri, Sep 27, 2013 at 08:15:32PM +0200, Oleg Nesterov wrote:
> > On 09/26, Peter Zijlstra wrote:

[ . . . ]

> > > +static bool cpuhp_readers_active_check(void)
> > >  {
> > > +	unsigned int seq = per_cpu_sum(cpuhp_seq);
> > > +
> > > +	smp_mb(); /* B matches A */
> > > +
> > > +	/*
> > > +	 * In other words, if we see __get_online_cpus() cpuhp_seq increment,
> > > +	 * we are guaranteed to also see its __cpuhp_refcount increment.
> > > +	 */
> > >  
> > > +	if (per_cpu_sum(__cpuhp_refcount) != 0)
> > > +		return false;
> > >  
> > > +	smp_mb(); /* D matches C */
> > 
> > It seems that both barries could be smp_rmb() ? I am not sure the comments
> > from srcu_readers_active_idx_check() can explain mb(), note that
> > __srcu_read_lock() always succeeds unlike get_cpus_online().
> 
> I see what you mean; cpuhp_readers_active_check() is all purely reads;
> there are no writes to order.
> 
> Paul; is there any argument for the MB here as opposed to RMB; and if
> not should we change both these and SRCU?

Given that these memory barriers execute only on the semi-slow path,
why add the complexity of moving from smp_mb() to either smp_rmb()
or smp_wmb()?  Straight smp_mb() is easier to reason about and more
robust against future changes.

							Thanx, Paul

