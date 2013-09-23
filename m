Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3IWOzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:55:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3IWOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:55:12 -0400
Date: Mon, 23 Sep 2013 16:54:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923145446.GX9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-38-git-send-email-mgorman@suse.de>
 <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130917162050.GK22421@suse.de>
 <20130917164505.GG12926@twins.programming.kicks-ass.net>
 <20130918154939.GZ26785@twins.programming.kicks-ass.net>
 <20130919143241.GB26785@twins.programming.kicks-ass.net>
 <20130923105017.030e0aef@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923105017.030e0aef@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:50:17AM -0400, Steven Rostedt wrote:
> On Thu, 19 Sep 2013 16:32:41 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> 
> > +extern void __get_online_cpus(void);
> > +
> > +static inline void get_online_cpus(void)
> > +{
> > +	might_sleep();
> > +
> > +	preempt_disable();
> > +	if (likely(!__cpuhp_writer || __cpuhp_writer == current))
> > +		this_cpu_inc(__cpuhp_refcount);
> > +	else
> > +		__get_online_cpus();
> > +	preempt_enable();
> > +}
> 
> 
> This isn't much different than srcu_read_lock(). What about doing
> something like this:
> 
> static inline void get_online_cpus(void)
> {
> 	might_sleep();
> 
> 	srcu_read_lock(&cpuhp_srcu);
> 	if (unlikely(__cpuhp_writer || __cpuhp_writer != current)) {
> 		srcu_read_unlock(&cpuhp_srcu);
> 		__get_online_cpus();
> 		current->online_cpus_held++;
> 	}
> }

There's a full memory barrier in srcu_read_lock(), while there was no
such thing in the previous fast path.

Also, why current->online_cpus_held()? That would make the write side
O(nr_tasks) instead of O(nr_cpus).

> static inline void put_online_cpus(void)
> {
> 	if (unlikely(current->online_cpus_held)) {
> 		current->online_cpus_held--;
> 		__put_online_cpus();
> 		return;
> 	}
> 
> 	srcu_read_unlock(&cpuhp_srcu);
> }

Also, you might not have noticed but, srcu_read_{,un}lock() have an
extra idx thing to pass about. That doesn't fit with the hotplug api.

> 
> Then have the writer simply do:
> 
> 	__cpuhp_write = current;
> 	synchronize_srcu(&cpuhp_srcu);
> 
> 	<grab the mutex here>

How does that do reader preference?
