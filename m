Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IWPw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:52:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38199 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3IWPw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:52:28 -0400
Date: Mon, 23 Sep 2013 08:50:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923155059.GO9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-38-git-send-email-mgorman@suse.de>
 <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130917162050.GK22421@suse.de>
 <20130917164505.GG12926@twins.programming.kicks-ass.net>
 <20130918154939.GZ26785@twins.programming.kicks-ass.net>
 <20130919143241.GB26785@twins.programming.kicks-ass.net>
 <20130923105017.030e0aef@gandalf.local.home>
 <20130923145446.GX9326@twins.programming.kicks-ass.net>
 <20130923111303.04b99db8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923111303.04b99db8@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092315-5806-0000-0000-000022D1FF9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 11:13:03AM -0400, Steven Rostedt wrote:
> On Mon, 23 Sep 2013 16:54:46 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, Sep 23, 2013 at 10:50:17AM -0400, Steven Rostedt wrote:

[ . . . ]

> ?? I'm not sure I understand this. The online_cpus_held++ was there for
> recursion. Can't get_online_cpus() nest? I was thinking it can. If so,
> once the "__cpuhp_writer" is set, we need to do __put_online_cpus() as
> many times as we did a __get_online_cpus(). I don't know where the
> O(nr_tasks) comes from. The ref here was just to account for doing the
> old "get_online_cpus" instead of a srcu_read_lock().
> 
> > 
> > > static inline void put_online_cpus(void)
> > > {
> > > 	if (unlikely(current->online_cpus_held)) {
> > > 		current->online_cpus_held--;
> > > 		__put_online_cpus();
> > > 		return;
> > > 	}
> > > 
> > > 	srcu_read_unlock(&cpuhp_srcu);
> > > }
> > 
> > Also, you might not have noticed but, srcu_read_{,un}lock() have an
> > extra idx thing to pass about. That doesn't fit with the hotplug api.
> 
> I'll have to look a that, as I'm not exactly sure about the idx thing.

Not a problem, just stuff the idx into some per-task thing.  Either
task_struct or taskinfo will work fine.

> > > 
> > > Then have the writer simply do:
> > > 
> > > 	__cpuhp_write = current;
> > > 	synchronize_srcu(&cpuhp_srcu);
> > > 
> > > 	<grab the mutex here>
> > 
> > How does that do reader preference?
> 
> Well, the point I was trying to do was to let readers go very fast
> (well, with a mb instead of a mutex), and then when the CPU hotplug
> happens, it goes back to the current method.
> 
> That is, once we set __cpuhp_write, and then run synchronize_srcu(),
> the system will be in a state that does what it does today (grabbing
> mutexes, and upping refcounts).
> 
> I thought the whole point was to speed up the get_online_cpus() when no
> hotplug is happening. This does that, and is rather simple. It only
> gets slow when hotplug is in effect.

Or to put it another way, if the underlying slow-path mutex is
reader-preference, then the whole thing will be reader-preference.

							Thanx, Paul

