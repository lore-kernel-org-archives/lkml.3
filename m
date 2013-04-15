Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3DOR1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:27:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54243 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3DOR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:27:43 -0400
Date: Mon, 15 Apr 2013 10:26:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130415172618.GJ29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130415020354.GB3401@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415020354.GB3401@iris.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041517-3620-0000-0000-000002096B60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:03:54PM +1000, Paul Mackerras wrote:
> On Fri, Apr 12, 2013 at 11:38:04PM -0700, Paul E. McKenney wrote:
> > On Fri, Apr 12, 2013 at 04:54:02PM -0700, Josh Triplett wrote:
> > > On Fri, Apr 12, 2013 at 04:19:13PM -0700, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Systems with HZ=100 can have slow bootup times due to the default
> > > > three-jiffy delays between quiescent-state forcing attempts.  This
> > > > commit therefore auto-tunes the RCU_JIFFIES_TILL_FORCE_QS value based
> > > > on the value of HZ.  However, this would break very large systems that
> > > > require more time between quiescent-state forcing attempts.  This
> > > > commit therefore also ups the default delay by one jiffy for each
> > > > 256 CPUs that might be on the system (based off of nr_cpu_ids at
> > > > runtime, -not- NR_CPUS at build time).
> > > > 
> > > > Reported-by: Paul Mackerras <paulus@au1.ibm.com>
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Something seems very wrong if RCU regularly hits the fqs code during
> > > boot; feels like there's some more straightforward solution we're
> > > missing.  What causes these CPUs to fall under RCU's scrutiny during
> > > boot yet not actually hit the RCU codepaths naturally?
> > 
> > The problem is that they are running HZ=100, so that RCU will often
> > take 30-60 milliseconds per grace period.  At that point, you only
> > need 16-30 grace periods to chew up a full second, so it is not all
> > that hard to eat up the additional 8-12 seconds of boot time that
> > they were seeing.  IIRC, UP boot was costing them 4 seconds.
> 
> I added some instrumentation, which counted 202 calls to
> synchronize_sched() during boot (Fedora 17 minimal install +
> development tools) with a 3.8.0 kernel on a 4-cpu KVM virtual machine
> on a POWER7.  Without this patch, those 202 calls take up a total of
> 4.32 seconds; with it, they take up 3.6 seconds.  The kernel is
> compiled with HZ=100 and NR_CPUS=1024, like the standard Fedora
> kernel.

Going from 4.32 seconds down to 3.6 seconds is an improvement, but there
is clearly room for more.  The following experimental not-for-inclusion
patch might help get most of the remaining 3.6 seconds.  Could you please
try it out?

> I suspect a lot of the calls are in udevd and related processes.
> Interestingly there were no calls to synchronize_rcu_bh or
> synchronize_sched_expedited.

The lack of synchronize_rcu_bh() suggests that networking is not
involved in the slowdown.  The lack of synchronize_sched_expedited()
is not surprising, unless you booted with rcupdate.rcu_expedited=1,
but in that case I would expect a much greater reduction in boot time.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Not for inclusion: Force expedited grace periods

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a9610d1..55c5ef6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2420,7 +2420,7 @@ void synchronize_sched(void)
 			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	if (rcu_expedited)
+	if (1)
 		synchronize_sched_expedited();
 	else
 		wait_rcu_gp(call_rcu_sched);
@@ -2447,7 +2447,7 @@ void synchronize_rcu_bh(void)
 			   "Illegal synchronize_rcu_bh() in RCU-bh read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	if (rcu_expedited)
+	if (1)
 		synchronize_rcu_bh_expedited();
 	else
 		wait_rcu_gp(call_rcu_bh);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 46b93b0..190a199 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -711,7 +711,7 @@ void synchronize_rcu(void)
 			   "Illegal synchronize_rcu() in RCU read-side critical section");
 	if (!rcu_scheduler_active)
 		return;
-	if (rcu_expedited)
+	if (1)
 		synchronize_rcu_expedited();
 	else
 		wait_rcu_gp(call_rcu);

