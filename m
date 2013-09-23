Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3IWPNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:13:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3IWPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:13:06 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6uerBSPhkSsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rzOjJkEkrDcA:10 a=JfrnYn6hAAAA:8 a=HQ8RT3mqG9F48fsa8ZcA:9 a=CjuIK1q_8ugA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 23 Sep 2013 11:13:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923111303.04b99db8@gandalf.local.home>
In-Reply-To: <20130923145446.GX9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
	<1378805550-29949-38-git-send-email-mgorman@suse.de>
	<20130917143003.GA29354@twins.programming.kicks-ass.net>
	<20130917162050.GK22421@suse.de>
	<20130917164505.GG12926@twins.programming.kicks-ass.net>
	<20130918154939.GZ26785@twins.programming.kicks-ass.net>
	<20130919143241.GB26785@twins.programming.kicks-ass.net>
	<20130923105017.030e0aef@gandalf.local.home>
	<20130923145446.GX9326@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013 16:54:46 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Sep 23, 2013 at 10:50:17AM -0400, Steven Rostedt wrote:
> > On Thu, 19 Sep 2013 16:32:41 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > 
> > > +extern void __get_online_cpus(void);
> > > +
> > > +static inline void get_online_cpus(void)
> > > +{
> > > +	might_sleep();
> > > +
> > > +	preempt_disable();
> > > +	if (likely(!__cpuhp_writer || __cpuhp_writer == current))
> > > +		this_cpu_inc(__cpuhp_refcount);
> > > +	else
> > > +		__get_online_cpus();
> > > +	preempt_enable();
> > > +}
> > 
> > 
> > This isn't much different than srcu_read_lock(). What about doing
> > something like this:
> > 
> > static inline void get_online_cpus(void)
> > {
> > 	might_sleep();
> > 
> > 	srcu_read_lock(&cpuhp_srcu);
> > 	if (unlikely(__cpuhp_writer || __cpuhp_writer != current)) {
> > 		srcu_read_unlock(&cpuhp_srcu);
> > 		__get_online_cpus();
> > 		current->online_cpus_held++;
> > 	}
> > }
> 
> There's a full memory barrier in srcu_read_lock(), while there was no
> such thing in the previous fast path.

Yeah, I mentioned this to Paul, and we talked about making
srcu_read_lock() work with no mb's. But currently, doesn't
get_online_cpus() just take a mutex? What's wrong with a mb() as it
still kicks ass over what is currently there today?

> 
> Also, why current->online_cpus_held()? That would make the write side
> O(nr_tasks) instead of O(nr_cpus).

?? I'm not sure I understand this. The online_cpus_held++ was there for
recursion. Can't get_online_cpus() nest? I was thinking it can. If so,
once the "__cpuhp_writer" is set, we need to do __put_online_cpus() as
many times as we did a __get_online_cpus(). I don't know where the
O(nr_tasks) comes from. The ref here was just to account for doing the
old "get_online_cpus" instead of a srcu_read_lock().

> 
> > static inline void put_online_cpus(void)
> > {
> > 	if (unlikely(current->online_cpus_held)) {
> > 		current->online_cpus_held--;
> > 		__put_online_cpus();
> > 		return;
> > 	}
> > 
> > 	srcu_read_unlock(&cpuhp_srcu);
> > }
> 
> Also, you might not have noticed but, srcu_read_{,un}lock() have an
> extra idx thing to pass about. That doesn't fit with the hotplug api.

I'll have to look a that, as I'm not exactly sure about the idx thing.

> 
> > 
> > Then have the writer simply do:
> > 
> > 	__cpuhp_write = current;
> > 	synchronize_srcu(&cpuhp_srcu);
> > 
> > 	<grab the mutex here>
> 
> How does that do reader preference?

Well, the point I was trying to do was to let readers go very fast
(well, with a mb instead of a mutex), and then when the CPU hotplug
happens, it goes back to the current method.

That is, once we set __cpuhp_write, and then run synchronize_srcu(),
the system will be in a state that does what it does today (grabbing
mutexes, and upping refcounts).

I thought the whole point was to speed up the get_online_cpus() when no
hotplug is happening. This does that, and is rather simple. It only
gets slow when hotplug is in effect.

-- Steve


