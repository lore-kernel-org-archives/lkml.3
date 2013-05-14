Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab3ENOSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:18:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58081 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab3ENOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:18:50 -0400
Date: Tue, 14 May 2013 07:12:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130514141245.GA4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130514122049.GH15942@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051414-5406-0000-0000-000008735003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 02:20:49PM +0200, Peter Zijlstra wrote:
> On Sat, Apr 13, 2013 at 03:09:43PM -0700, Paul E. McKenney wrote:
> > > How are those CPUs going idle without first telling RCU that they're
> > > quiesced?  Seems like, during boot at least, you want RCU to use its
> > > idle==quiesced logic to proactively note continuously-quiescent states.
> > > Ideally, you should not hit the FQS code at all during boot.
> > 
> > FQS is RCU's idle==quiesced logic.  ;-)
> > 
> > In theory, RCU could add logic at idle entry to report a quiescent state,
> > in fact CONFIG_RCU_FAST_NO_HZ used to do exactly that.  In practice,
> > this is not good for energy efficiency at runtime for a goodly number
> > of workloads, which is why CONFIG_RCU_FAST_NO_HZ now relies on callback
> > numbering and FQS.
> 
> OK, so bear with me.. I've missed a few months of RCU so I might not be as
> up-to-date as I'd like to be.
> 
> So going by the above; FAST_NO_HZ used to kick RCU into quiescence on entering
> NO_HZ. This made some ARM people happy but made the rest of the world sad
> because of immense idle-entry times.

The old RCU_FAST_NO_HZ was too heavy-weight.  The effect was that
it achieved the stated goal of producing long idle periods without
scheduling-clock interrupts, but incurred to-idle and from-idle overhead
that rivaled the savings.  :-(

> The above implies you've changed this about to allow CPUs to go idle without
> reporting home but instead rely on Forced Quiescent States to push the remote
> idle cpus into quiescence.

This is one prong of the mechanism, which is the same prong used for
normal dyntick-idle CPUs.  The other prong is a slowed-down timer tick,
4 jiffies if there is at least one non-lazy callback on a given CPU, 6
seconds if all of that CPU's callbacks are lazy ("lazy" as in kfree_rcu()
as opposed to synchronize_rcu() or call_rcu()).

Unfortunately, idiot here got the lazy/non-lazy comparison backwards,
which is what I believe to be responsible for the excessive boot times.
(Also for the excessive suspend and hibernation times, but it appears
that using expedited grace periods works really well for that.)  The
patch to fix my mistake is attached below.

> Now I understand that advancing the RCU state machine and processing callbacks
> takes time; however at boot (and possibly thereafter) we have the special case
> where we have no pending RCU state.
> 
> Could we not, under those circumstances, quickly remove the CPU from the RCU
> state machine so that FQS aren't required to prod quite as much remote state?

In theory, yes.  In practice, this requires lots of lock acquisitions
and releases on large systems, including some global locks.  The weight
could be reduced, but...

What I would like to do instead would be to specify expedited grace
periods during boot.  The challenge here appears to be somehow telling
RCU when boot is done.  The APIs are there from an RCU viewpoint:  boot
with rcupdate.rcu_expedited=1, then, once boot is complete (whatever
that means on your platform) "echo 0 > /sys/kernel/rcu_expedited".

							Thanx, Paul

------------------------------------------------------------------------

rcu: Fix comparison sense in rcu_needs_cpu()

Commit c0f4dfd4f (rcu: Make RCU_FAST_NO_HZ take advantage of numbered
callbacks) introduced a bug that can result in excessively long grace
periods.  This bug reverse the senes of the "if" statement checking
for lazy callbacks, so that RCU takes a lazy approach when there are
in fact non-lazy callbacks.  This can result in excessive boot, suspend,
and resume times.

This commit therefore fixes the sense of this "if" statement.

Reported-by: Borislav Petkov <bp@alien8.de>
Reported-by: Bjørn Mork <bjorn@mork.no>
Reported-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 170814d..6d939a6 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1667,7 +1667,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
 	rdtp->last_accelerate = jiffies;
 
 	/* Request timer delay depending on laziness, and round. */
-	if (rdtp->all_lazy) {
+	if (!rdtp->all_lazy) {
 		*dj = round_up(rcu_idle_gp_delay + jiffies,
 			       rcu_idle_gp_delay) - jiffies;
 	} else {

