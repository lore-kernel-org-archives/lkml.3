Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaHLVjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:39:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59053 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaHLVjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:39:42 -0400
Date: Tue, 12 Aug 2014 14:39:36 -0700
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
Message-ID: <20140812213936.GA3106@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140808214648.GA19058@linux.vnet.ibm.com>
 <20140811071308.GA4184@grmbl.mre>
 <20140811162807.GW5821@linux.vnet.ibm.com>
 <20140811194126.GF4184@grmbl.mre>
 <20140811201102.GD5821@linux.vnet.ibm.com>
 <20140811201845.GG4184@grmbl.mre>
 <20140811203421.GE5821@linux.vnet.ibm.com>
 <20140812034531.GA13801@linux.vnet.ibm.com>
 <20140812053321.GK4184@grmbl.mre>
 <20140812160621.GC4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812160621.GC4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081221-3532-0000-0000-000003CC4EA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 09:06:21AM -0700, Paul E. McKenney wrote:
> On Tue, Aug 12, 2014 at 11:03:21AM +0530, Amit Shah wrote:

[ . . . ]

> > I know of only virtio-console doing this (via userspace only,
> > though).
> 
> As in userspace within the guest?  That would not work.  The userspace
> that the qemu is running in might.  There is a way to extract ftrace info
> from crash dumps, so one approach would be "sendkey alt-sysrq-c", then
> pull the buffer from the resulting dump.  For all I know, there might also
> be some script that uses the qemu "x" command to get at the ftrace buffer.
> 
> Again, I cannot reproduce this, and I have been through the code several
> times over the past few days, and am not seeing it.  I could start
> sending you random diagnostic patches, but it would be much better if
> we could get the trace data from the failure.

Hearing no objections, random patch #1.  The compiler could in theory
cause trouble without this patch, so there is some possibility that
it is a fix.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a2333d07f5d6..1dc72f523c4a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2043,7 +2043,7 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
 	if (!ACCESS_ONCE(rdp_leader->nocb_kthread))
 		return;
 	if (!ACCESS_ONCE(rdp_leader->nocb_leader_wake) || force) {
-		/* Prior xchg orders against prior callback enqueue. */
+		/* Prior smp_mb__after_atomic() orders against prior enqueue. */
 		ACCESS_ONCE(rdp_leader->nocb_leader_wake) = true;
 		wake_up(&rdp_leader->nocb_wq);
 	}
@@ -2072,6 +2072,7 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 	ACCESS_ONCE(*old_rhpp) = rhp;
 	atomic_long_add(rhcount, &rdp->nocb_q_count);
 	atomic_long_add(rhcount_lazy, &rdp->nocb_q_count_lazy);
+	smp_mb__after_atomic(); /* Store *old_rhpp before _wake test. */
 
 	/* If we are not being polled and there is a kthread, awaken it ... */
 	t = ACCESS_ONCE(rdp->nocb_kthread);

