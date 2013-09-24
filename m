Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3IXSHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab3IXSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:07:10 -0400
Date: Tue, 24 Sep 2013 20:00:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130924180005.GA7148@redhat.com>
References: <20130917162050.GK22421@suse.de> <20130917164505.GG12926@twins.programming.kicks-ass.net> <20130918154939.GZ26785@twins.programming.kicks-ass.net> <20130919143241.GB26785@twins.programming.kicks-ass.net> <20130923175052.GA20991@redhat.com> <20130924123821.GT12926@twins.programming.kicks-ass.net> <20130924160359.GA2739@redhat.com> <20130924124341.64d57912@gandalf.local.home> <20130924170631.GB5059@redhat.com> <20130924174717.GH9093@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924174717.GH9093@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Paul E. McKenney wrote:
>
> On Tue, Sep 24, 2013 at 07:06:31PM +0200, Oleg Nesterov wrote:
> >
> > If gcc can actually do something wrong, then I suspect this barrier()
> > should be unconditional.
>
> If you are saying that there should be a barrier() on all return paths
> from get_online_cpus(), I agree.

Paul, Peter, could you provide any (even completely artificial) example
to explain me why do we need this barrier() ? I am puzzled. And
preempt_enable() already has barrier...

	get_online_cpus();
	do_something();

Yes, we need to ensure gcc doesn't reorder this code so that
do_something() comes before get_online_cpus(). But it can't? At least
it should check current->cpuhp_ref != 0 first? And if it is non-zero
we do not really care, we are already in the critical section and
this ->cpuhp_ref has only meaning in put_online_cpus().

Confused...

Oleg.

