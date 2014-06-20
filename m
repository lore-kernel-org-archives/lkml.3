Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967177AbaFTWE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:04:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34180 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269AbaFTWEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:04:55 -0400
Date: Fri, 20 Jun 2014 15:04:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/5] Fix for cond_resched performance
 regression
Message-ID: <20140620220448.GC4615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <20140620190434.GA22178@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620190434.GA22178@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062022-6688-0000-0000-000002B621D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:04:34PM -0700, josh@joshtriplett.org wrote:
> On Fri, Jun 20, 2014 at 11:32:49AM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This series contains changes to address the performance regressions
> > introduced by commit ac1bea85781e (Make cond_resched() report RCU
> > quiescent states), which was in turn fixing a problem where tasks looping
> > in the kernel could delay RCU grace periods.  The changes in this series
> > are as follows:
> > 
> > 1.	Reduce the overhead of checking added to cond_resched() and friends.
> > 
> > 2.	Add a new cond_resched_rcu_qs() to provide RCU quiescent states
> > 	even if cond_resched() should stop doing so.
> > 
> > 3.	Add a new RCU_COND_RESCHED_QS to prevent cond_resched() from
> > 	reporting RCU quiescent states.
> > 
> > 4.	Prevent rcutorture testing from reporting spurious RCU CPU stall
> > 	warnings, and also to test RCU_COND_RESCHED_QS.
> > 
> > 5.	Provides a boot/sysfs rcutree.jiffies_till_cond_resched_qs
> > 	parameter to replace the magic "7".
> 
> For all five patches:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you, added!

> Glad to see this doesn't add any overhead to rcutiny.

I suppose I should explain why that is...

First, single-CPU systems tend not to have thousands of mass-storage
devices, processes with many thousands of open files, or terabytes
of memory.  Of course, in theory, a single-CPU system -could- have all
those things, but in practice thus far, they don't.  Therefore, the
looping-in-the-kernel behavior that these things can cause simply don't
happen on single-CPU systems.  Maybe some day they will, at which point
we can simply re-enable TREE_RCU for !SMP systems, so that those huge
single-CPU systems can use TREE_RCU, which has the needed protections.
Small embedded systems would of course still be able to benefit from
TINY_RCU.

In addition, single-CPU systems by definition have but on CPU.  This
means that having a single runnable process on that CPU for tens of
seconds is much less likely, which eliminates another class of possible
indefinite-grace-period-extension bugs.  In addition, the situations
where a bunch of CPUs "gang up" on a single CPU, generating endless
cleanup work for that CPU, also cannot happen on a single-CPU system.
This in turn eliminates the "grace-period extension via unending
cleanup" class of bugs.

Make sense?

							Thanx, Paul

