Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaHWXnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 19:43:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43636 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaHWXm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 19:42:57 -0400
Date: Sat, 23 Aug 2014 09:51:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Amit Shah <amit.shah@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Silas Boyd-Wickizer <sbw@mit.edu>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140823165121.GJ2663@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCC6XUo0erp6mPyjiz5614DQq_+gfVaLR5s9YZkP=jPVCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCC6XUo0erp6mPyjiz5614DQq_+gfVaLR5s9YZkP=jPVCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082323-6688-0000-0000-0000043D7FED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 03:43:38AM -0400, Pranith Kumar wrote:
> On Fri, Aug 22, 2014 at 5:53 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Hmmm...  Please try replacing the synchronize_rcu() in
> > __sysrq_swap_key_ops() with (say) schedule_timeout_interruptible(HZ / 10).
> > I bet that gets rid of the hang.  (And also introduces a low-probability
> > bug, but should be OK for testing.)
> >
> > The other thing to try is to revert your patch that turned my event
> > traces into printk()s, then put an ftrace_dump(DUMP_ALL); just after
> > the synchronize_rcu() -- that might make it so that the ftrace data
> > actually gets dumped out.
> >
> 
> I was able to reproduce this error on my Ubuntu 14.04 machine. I think
> I found the root cause of the problem after several kvm runs.
> 
> The problem is that earlier we were waiting on nocb_head and now we
> are waiting on nocb_leader_wake.
> 
> So there are a lot of nocb callbacks which are enqueued before the
> nocb thread is spawned. This sets up nocb_head to be non-null, because
> of which the nocb kthread used to wake up immediately after sleeping.
> 
> Now that we have switched to nocb_leader_wake, this is not being set
> when there are pending callbacks, unless the callbacks overflow the
> qhimark. The pending callbacks were around 7000 when the boot hangs.
> 
> So setting the qhimark using the boot parameter rcutree.qhimark=5000
> is one way to allow us to boot past the point by forcefully waking up
> the nocb kthread. I am not sure this is fool-proof.

Unfortunately, not in all cases.  A small kernel for embedded use might
register only a few callbacks during boot, which could still result
in a hang.

> Another option to start the nocb kthreads with nocb_leader_wake set,
> so that it can handle any pending callbacks. The following patch also
> allows us to boot properly.

This seems like a much better approach.

> Phew! Let me know if this makes any sense :)

It might well!  Another possibility is that the early_initcall function
doing the synchronize_rcu() is happening before the early_initcall
creating the RCU grace-period kthreads.

Seems like we need to close both holes.  Let's see how your patch works
for Amit, and I am testing a patch for the possible early_initcall
ordering issue.

> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 00dc411..4c397aa 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2386,6 +2386,9 @@ static int rcu_nocb_kthread(void *arg)
>         struct rcu_head **tail;
>         struct rcu_data *rdp = arg;
> 
> +       if (rdp->nocb_leader == rdp)
> +               rdp->nocb_leader_wake = true;
> +

Not that it matters all that much, but given that the followers don't
ever reference ->nocb_leader_wake, we should be able to set this flag
unconditionally.

						Thanx, Paul

>         /* Each pass through this loop invokes one batch of callbacks */
>         for (;;) {
>                 /* Wait for callbacks. */
> 
> 
> -- 
> Pranith
> 

