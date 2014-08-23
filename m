Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaHWHoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 03:44:12 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:56872 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaHWHoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 03:44:10 -0400
MIME-Version: 1.0
From: Pranith Kumar <pranith@gatech.edu>
Date: Sat, 23 Aug 2014 03:43:38 -0400
X-Google-Sender-Auth: KbILDCe1nuKyA1On_aBbeSTFXls
Message-ID: <CAJhHMCC6XUo0erp6mPyjiz5614DQq_+gfVaLR5s9YZkP=jPVCw@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
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
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Silas Boyd-Wickizer <sbw@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 5:53 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Hmmm...  Please try replacing the synchronize_rcu() in
> __sysrq_swap_key_ops() with (say) schedule_timeout_interruptible(HZ / 10).
> I bet that gets rid of the hang.  (And also introduces a low-probability
> bug, but should be OK for testing.)
>
> The other thing to try is to revert your patch that turned my event
> traces into printk()s, then put an ftrace_dump(DUMP_ALL); just after
> the synchronize_rcu() -- that might make it so that the ftrace data
> actually gets dumped out.
>

I was able to reproduce this error on my Ubuntu 14.04 machine. I think
I found the root cause of the problem after several kvm runs.

The problem is that earlier we were waiting on nocb_head and now we
are waiting on nocb_leader_wake.

So there are a lot of nocb callbacks which are enqueued before the
nocb thread is spawned. This sets up nocb_head to be non-null, because
of which the nocb kthread used to wake up immediately after sleeping.

Now that we have switched to nocb_leader_wake, this is not being set
when there are pending callbacks, unless the callbacks overflow the
qhimark. The pending callbacks were around 7000 when the boot hangs.

So setting the qhimark using the boot parameter rcutree.qhimark=5000
is one way to allow us to boot past the point by forcefully waking up
the nocb kthread. I am not sure this is fool-proof.

Another option to start the nocb kthreads with nocb_leader_wake set,
so that it can handle any pending callbacks. The following patch also
allows us to boot properly.

Phew! Let me know if this makes any sense :)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 00dc411..4c397aa 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2386,6 +2386,9 @@ static int rcu_nocb_kthread(void *arg)
        struct rcu_head **tail;
        struct rcu_data *rdp = arg;

+       if (rdp->nocb_leader == rdp)
+               rdp->nocb_leader_wake = true;
+
        /* Each pass through this loop invokes one batch of callbacks */
        for (;;) {
                /* Wait for callbacks. */


-- 
Pranith
