Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3JDMU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3JDMU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:20:27 -0400
Date: Fri, 4 Oct 2013 14:13:00 +0200
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
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131004121300.GA7725@redhat.com>
References: <20131003184719.GA11996@redhat.com> <20131003192135.GR5790@linux.vnet.ibm.com> <20131003193206.GA17796@redhat.com> <20131003193319.GB17796@redhat.com> <20131003195026.GT5790@linux.vnet.ibm.com> <20131003200002.GA23768@redhat.com> <20131003211009.GA4127@redhat.com> <20131004071814.GS28601@twins.programming.kicks-ass.net> <20131004111513.GA5699@redhat.com> <20131004114442.GJ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004114442.GJ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 04, 2013 at 01:15:13PM +0200, Oleg Nesterov wrote:
> > > What's exclusive to mean? One writer at a time?
> >
> > Yes,
>
> I'm not entirely sure what the advantage is of having that logic in this
> primitive. Shouldn't that be something the user of this rcu_sync stuff
> does (or not) depending on its needs.

Yes, the user can do the locking itself. But I think this option can help.
If nothing else it can help to avoid another mutex/whatever and unnecessary
wakeup/scheule's, even if this is minor.

And. rcu_sync_enter() should be "bool", it should return "need_sync". IOW,
rcu_sync_enter() == T means that this thread has done the FAST -> SLOW
transition, this is particularly useful in "exclusive" mode.

Consider percpu_down_write(). It takes rw_sem for writing (and this blocks
the readers) before clear_fast_ctr(), but we only need to do this this
after sync_sched(), so it could do

	if (rcu_sync_enter(&brw->rcu_sync))
		atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
	else
		; /* the above was already done */

	/* exclude readers */
	down_write(&brw->rw_sem);

and now ->rw_sem is only needed to serialize readers/writer.

Sure, this all is minor (and we will probably copy the "pending writer"
logic from cpu_hotplug_begin/get_online_cpus).

But we can get this feature almost for free, so I think it makes sense.

Oleg.

