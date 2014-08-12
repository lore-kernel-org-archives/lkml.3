Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaHLVoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:44:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38814 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaHLVoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:44:12 -0400
Date: Tue, 12 Aug 2014 14:44:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140812214405.GC3106@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081221-6688-0000-0000-000003F6289A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 02:41:51PM -0700, Paul E. McKenney wrote:
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
> > 
> > Hearing no objections, random patch #1.  The compiler could in theory
> > cause trouble without this patch, so there is some possibility that
> > it is a fix.
> 
> #2...  This would have been a problem without the earlier patch, but
> who knows?  (#1 moved from theoretically possible but not on x86 to
> maybe on x86 given a sufficiently malevolent compiler with the
> patch that you located with bisection.)

#3...  This one is theoretically possible, but not on any system that has
a full barrier on lock acquisition.  This code did not exist before the
patch you located via bisection, but on the other hand, given that you
were running only two CPUs, it should be dead code anyway.  But who knows?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 1da605740e8d..70bff565dab6 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2314,6 +2314,7 @@ wait_again:
 		atomic_long_add(rdp->nocb_gp_count, &rdp->nocb_follower_count);
 		atomic_long_add(rdp->nocb_gp_count_lazy,
 				&rdp->nocb_follower_count_lazy);
+		smp_mb__after_atomic(); /* Store *tail before wakeup. */
 		if (rdp != my_rdp && tail == &rdp->nocb_follower_head) {
 			/*
 			 * List was empty, wake up the follower.

