Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbbAVAnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:43:23 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40290 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbbAVAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:43:12 -0500
Date: Wed, 21 Jan 2015 16:43:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at
 kernel/rcu/tree_plugin.h:337 rcu_read_unlock_special+0x369/0x550()
Message-ID: <20150122004305.GJ9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <54BBC084.2030604@oracle.com>
 <20150118232255.GD9719@linux.vnet.ibm.com>
 <54BE76B9.7070907@oracle.com>
 <20150121025754.GV9719@linux.vnet.ibm.com>
 <54BFC979.8040107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BFC979.8040107@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012200-0005-0000-0000-00000837E8AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:44:57AM -0500, Sasha Levin wrote:
> On 01/20/2015 09:57 PM, Paul E. McKenney wrote:
> >>> So RCU believes that an RCU read-side critical section that ended within
> >>> > > an interrupt handler (in this case, an hrtimer) somehow got preempted.
> >>> > > Which is not supposed to happen.
> >>> > > 
> >>> > > Do you have CONFIG_PROVE_RCU enabled?  If not, could you please enable it
> >>> > > and retry?
> >> > 
> >> > I did have CONFIG_PROVE_RCU, and didn't see anything else besides what I pasted here.
> > OK, fair enough.  I do have a stack of RCU CPU stall-warning changes on
> > their way in, please see v3.19-rc1..630181c4a915 in -rcu, which is at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> > 
> > These handle the problems that Dave Jones, yourself, and a few others
> > located this past December.  Could you please give them a spin?
> 
> They seem to be a part of -next already, so this testing already includes them.
> 
> I seem to be getting them about once a day, anything I can add to debug it?

Could you please try reproducing with the following patch?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Improve diagnostics for blocked critical sections in irq

If an RCU read-side critical section occurs within an interrupt handler
or a softirq handler, it cannot have been preempted.  Therefore, there is
a check in rcu_read_unlock_special() checking for this error.  However,
when this check triggers, it lacks diagnostic information.  This commit
therefore moves rcu_read_unlock()'s lockdep annotation to follow the
call to __rcu_read_unlock() and changes rcu_read_unlock_special()'s
WARN_ON_ONCE() to an lockdep_rcu_suspicious() in order to locate where
the offending RCU read-side critical section began.  In addition, the
value of the ->rcu_read_unlock_special field is printed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3e6afed51051..70b896e16f19 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -942,9 +942,9 @@ static inline void rcu_read_unlock(void)
 {
 	rcu_lockdep_assert(rcu_is_watching(),
 			   "rcu_read_unlock() used illegally while idle");
-	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
 	__rcu_read_unlock();
+	rcu_lock_release(&rcu_lock_map); /* Keep acq info for rls diags. */
 }
 
 /**
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index bb947ef1a2a4..8d2b497b52e9 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -334,7 +334,13 @@ void rcu_read_unlock_special(struct task_struct *t)
 	}
 
 	/* Hardware IRQ handlers cannot block, complain if they get here. */
-	if (WARN_ON_ONCE(in_irq() || in_serving_softirq())) {
+	if (in_irq() || in_serving_softirq()) {
+		lockdep_rcu_suspicious(__FILE__, __LINE__,
+				       "rcu_read_unlock() from irq or softirq with blocking in critical section!!!\n");
+		pr_alert("->rcu_read_unlock_special: %#x (b: %d, nq: %d)\n",
+			 t->rcu_read_unlock_special.s,
+			 t->rcu_read_unlock_special.b.blocked,
+			 t->rcu_read_unlock_special.b.need_qs);
 		local_irq_restore(flags);
 		return;
 	}

