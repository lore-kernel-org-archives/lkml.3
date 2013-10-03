Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3JCTMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab3JCTMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:12:42 -0400
Date: Thu, 3 Oct 2013 21:05:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] hotplug: Optimize cpu_hotplug_{begin,done}() using
	rcu_sync
Message-ID: <20131003190535.GB11996@redhat.com>
References: <20131002145655.361606532@infradead.org> <20131002150518.748974359@infradead.org> <20131003164838.GF5790@linux.vnet.ibm.com> <20131003184151.GN28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003184151.GN28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Peter Zijlstra wrote:
>
> On Thu, Oct 03, 2013 at 09:48:38AM -0700, Paul E. McKenney wrote:
> > > -enum { readers_fast = 0, readers_slow, readers_block };
> > > +enum { readers_slow, readers_block };
> >
> > It took me a bit to realize that readers_fast is obsoleted by the
> > rcu_sync_is_idle() above.  ;-)
>
> Yeah.. I pondered changing/adding to the rcu_sync interface to allow
> using gp_count like status to avoid the extra variable, but decided
> against it for now.

Agreed, it looks simple enough even if get/put has to read ->gp_state
or/and cpuhp_state.

But, just is case, this is one example of why it probably makes sense
to rcu_sync_struct->state_changed(new_state, void *data) callback. In
this case it could simply do

	static void cpuhp_rcu_sync_state_cb(state, ...)
	{
		switch (state) {
		case GP_IDLE:
			cpuhp_state = readers_fast;
			break;
		case GP_PENDING:
			cpuhp_state = readers_slow;
			break;
		}
	}

Doesn't make sense in this particular case, but perhaps in general.

Oleg.

