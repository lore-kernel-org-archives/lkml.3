Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaLNMDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 07:03:30 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40666 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaLNMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 07:03:26 -0500
Date: Sun, 14 Dec 2014 04:03:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: question about the luto-misc tree
Message-ID: <20141214120318.GA5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214175747.2e6c506e@canb.auug.org.au>
 <CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121412-0017-0000-0000-00000719A906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 11:26:36PM -0800, Andy Lutomirski wrote:
> On Dec 13, 2014 10:58 PM, "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
> >
> > Hi Andy,
> >
> > The luto-misc tree seems to have a whole series of commits in it that
> > have just bee removed from the rcu tree ...  You really have to be very
> > careful if you base your work on a tree that is regularly rebased.
> 
> Hmm.  They were there a couple days ago.  Paul, what should I do about
> this?  I only need the one NMI nesting change for the stuff in
> luto/next.
> 
> > I also wonder if the other commits in that tree are destined for
> > v3.19?  If they are for v3.20, then they should not be in linux-next
> > until after v3.19-rc1 has been released.
> 
> They're for 3.20.  I'll drop the whole series from the next branch for now.

You mean the NMI nesting change below, correct?  One approach would be
to include the branch rcu/dev from my -rcu tree.  Would that work for you?

							Thanx, Paul

------------------------------------------------------------------------

    rcu: Make rcu_nmi_enter() handle nesting
    
    The x86 architecture has multiple types of NMI-like interrupts: real
    NMIs, machine checks, and, for some values of NMI-like, debugging
    and breakpoint interrupts.  These interrupts can nest inside each
    other.  Andy Lutomirski is adding RCU support to these interrupts,
    so rcu_nmi_enter() and rcu_nmi_exit() must now correctly handle nesting.
    
    This commit therefore introduces nesting, using a clever NMI-coordination
    algorithm suggested by Andy.  The trick is to atomically increment
    ->dynticks (if needed) before manipulating ->dynticks_nmi_nesting on entry
    (and, accordingly, after on exit).  In addition, ->dynticks_nmi_nesting
    is incremented by one if ->dynticks was incremented and by two otherwise.
    This means that when rcu_nmi_exit() sees ->dynticks_nmi_nesting equal
    to one, it knows that ->dynticks must be atomically incremented.
    
    This NMI-coordination algorithms has been validated by the following
    Promela model:
    
    ------------------------------------------------------------------------
    
    /*
     * Promela model for Andy Lutomirski's suggested change to rcu_nmi_enter()
     * that allows nesting.
     *
     * This program is free software; you can redistribute it and/or modify
     * it under the terms of the GNU General Public License as published by
     * the Free Software Foundation; either version 2 of the License, or
     * (at your option) any later version.
     *
     * This program is distributed in the hope that it will be useful,
     * but WITHOUT ANY WARRANTY; without even the implied warranty of
     * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     * GNU General Public License for more details.
     *
     * You should have received a copy of the GNU General Public License
     * along with this program; if not, you can access it online at
     * http://www.gnu.org/licenses/gpl-2.0.html.
     *
     * Copyright IBM Corporation, 2014
     *
     * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
     */
    
    byte dynticks_nmi_nesting = 0;
    byte dynticks = 0;
    
    /*
     * Promela verision of rcu_nmi_enter().
     */
    inline rcu_nmi_enter()
    {
    	byte incby;
    	byte tmp;
    
    	incby = BUSY_INCBY;
    	assert(dynticks_nmi_nesting >= 0);
    	if
    	:: (dynticks & 1) == 0 ->
    		atomic {
    			dynticks = dynticks + 1;
    		}
    		assert((dynticks & 1) == 1);
    		incby = 1;
    	:: else ->
    		skip;
    	fi;
    	tmp = dynticks_nmi_nesting;
    	tmp = tmp + incby;
    	dynticks_nmi_nesting = tmp;
    	assert(dynticks_nmi_nesting >= 1);
    }
    
    /*
     * Promela verision of rcu_nmi_exit().
     */
    inline rcu_nmi_exit()
    {
    	byte tmp;
    
    	assert(dynticks_nmi_nesting > 0);
    	assert((dynticks & 1) != 0);
    	if
    	:: dynticks_nmi_nesting != 1 ->
    		tmp = dynticks_nmi_nesting;
    		tmp = tmp - BUSY_INCBY;
    		dynticks_nmi_nesting = tmp;
    	:: else ->
    		dynticks_nmi_nesting = 0;
    		atomic {
    			dynticks = dynticks + 1;
    		}
    		assert((dynticks & 1) == 0);
    	fi;
    }
    
    /*
     * Base-level NMI runs non-atomically.  Crudely emulates process-level
     * dynticks-idle entry/exit.
     */
    proctype base_NMI()
    {
    	byte busy;
    
    	busy = 0;
    	do
    	::	/* Emulate base-level dynticks and not. */
    		if
    		:: 1 ->	atomic {
    				dynticks = dynticks + 1;
    			}
    			busy = 1;
    		:: 1 ->	skip;
    		fi;
    
    		/* Verify that we only sometimes have base-level dynticks. */
    		if
    		:: busy == 0 -> skip;
    		:: busy == 1 -> skip;
    		fi;
    
    		/* Model RCU's NMI entry and exit actions. */
    		rcu_nmi_enter();
    		assert((dynticks & 1) == 1);
    		rcu_nmi_exit();
    
    		/* Emulated re-entering base-level dynticks and not. */
    		if
    		:: !busy -> skip;
    		:: busy ->
    			atomic {
    				dynticks = dynticks + 1;
    			}
    			busy = 0;
    		fi;
    
    		/* We had better now be in dyntick-idle mode. */
    		assert((dynticks & 1) == 0);
    	od;
    }
    
    /*
     * Nested NMI runs atomically to emulate interrupting base_level().
     */
    proctype nested_NMI()
    {
    	do
    	::	/*
    		 * Use an atomic section to model a nested NMI.  This is
    		 * guaranteed to interleave into base_NMI() between a pair
    		 * of base_NMI() statements, just as a nested NMI would.
    		 */
    		atomic {
    			/* Verify that we only sometimes are in dynticks. */
    			if
    			:: (dynticks & 1) == 0 -> skip;
    			:: (dynticks & 1) == 1 -> skip;
    			fi;
    
    			/* Model RCU's NMI entry and exit actions. */
    			rcu_nmi_enter();
    			assert((dynticks & 1) == 1);
    			rcu_nmi_exit();
    		}
    	od;
    }
    
    init {
    	run base_NMI();
    	run nested_NMI();
    }
    
    ------------------------------------------------------------------------
    
    The following script can be used to run this model if placed in
    rcu_nmi.spin:
    
    ------------------------------------------------------------------------
    
    if ! spin -a rcu_nmi.spin
    then
    	echo Spin errors!!!
    	exit 1
    fi
    if ! cc -DSAFETY -o pan pan.c
    then
    	echo Compilation errors!!!
    	exit 1
    fi
    ./pan -m100000
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8749f43f3f05..fc0236992655 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -759,39 +759,71 @@ void rcu_irq_enter(void)
 /**
  * rcu_nmi_enter - inform RCU of entry to NMI context
  *
- * If the CPU was idle with dynamic ticks active, and there is no
- * irq handler running, this updates rdtp->dynticks_nmi to let the
- * RCU grace-period handling know that the CPU is active.
+ * If the CPU was idle from RCU's viewpoint, update rdtp->dynticks and
+ * rdtp->dynticks_nmi_nesting to let the RCU grace-period handling know
+ * that the CPU is active.  This implementation permits nested NMIs, as
+ * long as the nesting level does not overflow an int.  (You will probably
+ * run out of stack space first.)
  */
 void rcu_nmi_enter(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
+	int incby = 2;
 
-	if (rdtp->dynticks_nmi_nesting == 0 &&
-	    (atomic_read(&rdtp->dynticks) & 0x1))
-		return;
-	rdtp->dynticks_nmi_nesting++;
-	smp_mb__before_atomic();  /* Force delay from prior write. */
-	atomic_inc(&rdtp->dynticks);
-	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
-	smp_mb__after_atomic();  /* See above. */
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	/* Complain about underflow. */
+	WARN_ON_ONCE(rdtp->dynticks_nmi_nesting < 0);
+
+	/*
+	 * If idle from RCU viewpoint, atomically increment ->dynticks
+	 * to mark non-idle and increment ->dynticks_nmi_nesting by one.
+	 * Otherwise, increment ->dynticks_nmi_nesting by two.  This means
+	 * if ->dynticks_nmi_nesting is equal to one, we are guaranteed
+	 * to be in the outermost NMI handler that interrupted an RCU-idle
+	 * period (observation due to Andy Lutomirski).
+	 */
+	if (!(atomic_read(&rdtp->dynticks) & 0x1)) {
+		smp_mb__before_atomic();  /* Force delay from prior write. */
+		atomic_inc(&rdtp->dynticks);
+		/* atomic_inc() before later RCU read-side crit sects */
+		smp_mb__after_atomic();  /* See above. */
+		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+		incby = 1;
+	}
+	rdtp->dynticks_nmi_nesting += incby;
+	barrier();
 }
 
 /**
  * rcu_nmi_exit - inform RCU of exit from NMI context
  *
- * If the CPU was idle with dynamic ticks active, and there is no
- * irq handler running, this updates rdtp->dynticks_nmi to let the
- * RCU grace-period handling know that the CPU is no longer active.
+ * If we are returning from the outermost NMI handler that interrupted an
+ * RCU-idle period, update rdtp->dynticks and rdtp->dynticks_nmi_nesting
+ * to let the RCU grace-period handling know that the CPU is back to
+ * being RCU-idle.
  */
 void rcu_nmi_exit(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
-	if (rdtp->dynticks_nmi_nesting == 0 ||
-	    --rdtp->dynticks_nmi_nesting != 0)
+	/*
+	 * Check for ->dynticks_nmi_nesting underflow and bad ->dynticks.
+	 * (We are exiting an NMI handler, so RCU better be paying attention
+	 * to us!)
+	 */
+	WARN_ON_ONCE(rdtp->dynticks_nmi_nesting <= 0);
+	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+
+	/*
+	 * If the nesting level is not 1, the CPU wasn't RCU-idle, so
+	 * leave it in non-RCU-idle state.
+	 */
+	if (rdtp->dynticks_nmi_nesting != 1) {
+		rdtp->dynticks_nmi_nesting -= 2;
 		return;
+	}
+
+	/* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
+	rdtp->dynticks_nmi_nesting = 0;
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic();  /* See above. */
 	atomic_inc(&rdtp->dynticks);

