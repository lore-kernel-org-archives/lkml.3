Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaHMFq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaHMFq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:46:28 -0400
Date: Wed, 13 Aug 2014 11:14:39 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140813054439.GA29913@grmbl.mre>
References: <20140811162807.GW5821@linux.vnet.ibm.com>
 <20140811194126.GF4184@grmbl.mre>
 <20140811201102.GD5821@linux.vnet.ibm.com>
 <20140811201845.GG4184@grmbl.mre>
 <20140811203421.GE5821@linux.vnet.ibm.com>
 <20140812034531.GA13801@linux.vnet.ibm.com>
 <20140812053321.GK4184@grmbl.mre>
 <20140812160621.GC4752@linux.vnet.ibm.com>
 <20140812213936.GA3106@linux.vnet.ibm.com>
 <20140812214151.GB3106@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812214151.GB3106@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 12 Aug 2014 [14:41:51], Paul E. McKenney wrote:
> On Tue, Aug 12, 2014 at 02:39:36PM -0700, Paul E. McKenney wrote:
> > On Tue, Aug 12, 2014 at 09:06:21AM -0700, Paul E. McKenney wrote:
> > > On Tue, Aug 12, 2014 at 11:03:21AM +0530, Amit Shah wrote:
> > 
> > [ . . . ]
> > 
> > > > I know of only virtio-console doing this (via userspace only,
> > > > though).
> > > 
> > > As in userspace within the guest?  That would not work.  The userspace
> > > that the qemu is running in might.  There is a way to extract ftrace info
> > > from crash dumps, so one approach would be "sendkey alt-sysrq-c", then
> > > pull the buffer from the resulting dump.  For all I know, there might also
> > > be some script that uses the qemu "x" command to get at the ftrace buffer.
> > > 
> > > Again, I cannot reproduce this, and I have been through the code several
> > > times over the past few days, and am not seeing it.  I could start
> > > sending you random diagnostic patches, but it would be much better if
> > > we could get the trace data from the failure.

I think the only recourse I now have is to dump the guest state from
qemu, and attempt to find the ftrace buffers by poking pages and
finding some ftrace-like struct... and then dumping the buffers.

> > Hearing no objections, random patch #1.  The compiler could in theory
> > cause trouble without this patch, so there is some possibility that
> > it is a fix.
> 
> #2...  This would have been a problem without the earlier patch, but
> who knows?  (#1 moved from theoretically possible but not on x86 to
> maybe on x86 given a sufficiently malevolent compiler with the
> patch that you located with bisection.)

I tried all 3 patches individually, and all 3 together, no success.

My gcc is gcc-4.8.3-1.fc20.x86_64.  I'm using a fairly uptodate Fedora
20 system on my laptop for these tests.

Curiously, patches 1 and 3 applied fine, but this one had a conflict.

> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 1dc72f523c4a..1da605740e8d 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2137,6 +2137,17 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,

I have this hunk at line 2161, and...

>  		trace_rcu_callback(rdp->rsp->name, rhp,
>  				   -atomic_long_read(&rdp->nocb_q_count_lazy),
>  				   -atomic_long_read(&rdp->nocb_q_count));
> +
> +	/*
> +	 * If called from an extended quiescent state with interrupts
> +	 * disabled, invoke the RCU core in order to allow the idle-entry
> +	 * deferred-wakeup check to function.
> +	 */
> +	if (irqs_disabled_flags(flags) &&
> +	    !rcu_is_watching() &&
> +	    cpu_online(smp_processor_id()))
> +		invoke_rcu_core();
> +
>  	return true;

I have return 1; here.

I'm on linux.git, c8d6637d0497d62093dbba0694c7b3a80b79bfe1.


		Amit
