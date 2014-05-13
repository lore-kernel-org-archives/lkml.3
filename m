Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaEMS1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:27:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48522 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaEMS1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:27:45 -0400
Date: Tue, 13 May 2014 11:27:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 01/45] rcutorture: Add forward-progress
 checking for writer
Message-ID: <20140513182738.GL18164@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507211649.GA27924@cloud>
 <20140507234313.GP8754@linux.vnet.ibm.com>
 <20140509155230.GA4152@thin>
 <20140509173658.GV8754@linux.vnet.ibm.com>
 <20140509193246.GC13050@jtriplet-mobl1>
 <20140509223004.GZ8754@linux.vnet.ibm.com>
 <20140509224052.GC5725@thin>
 <20140509225514.GA8754@linux.vnet.ibm.com>
 <20140510001454.GA7553@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510001454.GA7553@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051318-1542-0000-0000-000001C65F29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:14:54PM -0700, Josh Triplett wrote:
> On Fri, May 09, 2014 at 03:55:14PM -0700, Paul E. McKenney wrote:
> > On Fri, May 09, 2014 at 03:40:52PM -0700, Josh Triplett wrote:
> > > On Fri, May 09, 2014 at 03:30:04PM -0700, Paul E. McKenney wrote:
> > > > On Fri, May 09, 2014 at 12:32:46PM -0700, Josh Triplett wrote:
> > > > > On Fri, May 09, 2014 at 10:36:58AM -0700, Paul E. McKenney wrote:
> > > > > > On Fri, May 09, 2014 at 08:52:31AM -0700, Josh Triplett wrote:
> > > > > > > On Wed, May 07, 2014 at 04:43:13PM -0700, Paul E. McKenney wrote:
> > > > > > > > On Wed, May 07, 2014 at 02:16:49PM -0700, josh@joshtriplett.org wrote:
> > > > > > > > > On Mon, Apr 28, 2014 at 05:24:49PM -0700, Paul E. McKenney wrote:
> > > > > > > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > > > > > > 
> > > > > > > > > > The rcutorture output currently does not distinguish between stalls in
> > > > > > > > > > the RCU implementation and stalls in the rcu_torture_writer() kthreads.
> > > > > > > > > > This commit therefore adds some diagnostics to help distinguish between
> > > > > > > > > > these two conditions, at least for the non-SRCU implementations.  (SRCU
> > > > > > > > > > does not provide evidence of update-side forward progress by design.)
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > > > > 
> > > > > > > > > The concept makes sense, and the writer state annotations seem like a
> > > > > > > > > useful debugging mechanism, but having RCU know about RCU torture types
> > > > > > > > > seems fundamentally wrong.  This mechanism accesses rcu_state, which is
> > > > > > > > > already implementation-specific, so why not just only define the
> > > > > > > > > function for the RCU implementations that support it, and then have a
> > > > > > > > > function pointer in the torture-test structure to report a stall?
> > > > > > > > 
> > > > > > > > Ouch.  It is worse than that!  When running RCU-bh or RCU-sched,
> > > > > > > > the current code incorrectly returns the statistics for RCU.
> > > > > > > > So I do need some way for rcutorture to tell RCU which flavor
> > > > > > > > it is testing.
> > > > > > > > 
> > > > > > > > One thing I could do would be to pass in a pointer to the call_rcu()
> > > > > > > > function (cur_ops->call from rcutorture's viewpoint), then scan the
> > > > > > > > rcu_state structures looking for the selected flavor (rsp->call from
> > > > > > > > tree.c's viewpoint).  In the SRCU and RCU-busted cases, the flavor would
> > > > > > > > not be found, and I could then just set everything to zero.
> > > > > > > > 
> > > > > > > > Does that seem reasonable, or is there a better way to do this?
> > > > > > > 
> > > > > > > That search seems rather too hackish; why not just declare one
> > > > > > > stats-returning function per RCU flavor, and put the pointer to the
> > > > > > > corresponding function in the structure for each test type?
> > > > > > 
> > > > > > The problem is that rcutorture doesn't know anything about the structures,
> > > > > > as those are internal to the implementation.  All it knows is which
> > > > > > functions it is using.  I -could- EXPORT_SYMBOL_GPL() the rcu_state
> > > > > > structures to modules (they are already non-static), then rename
> > > > > > TINY_RCU's rcu_ctrlblk to rcu_state to allow the needed type punning,
> > > > > > then do some special-case thing for SRCU, and put a pointer to whatever
> > > > > > in rcu_torture_ops, but that was feeling a bit hackish as well.
> > > > > > 
> > > > > > So what did you have in mind to allow rcutorture to communicate the
> > > > > > rcuflavor to the underlying RCU implementation?
> > > > > 
> > > > > Rather than EXPORT_SYMBOL_GPLing the rcu_state structures, just
> > > > > EXPORT_SYMBOL_GPL one version of rcutorture_get_gp_data per RCU flavor.
> > > > > (And hide them all behind #ifdef CONFIG_RCU_TORTURE_TEST.)  Then add a
> > > > > get_gp_data field to rcu_torture_ops; if NULL, skip the stats.  (Or put
> > > > > a no-op version in rcutorture.)
> > > > 
> > > > But that would require me to provide these same exports from TINY_RCU,
> > > > which does not need them.
> > > > 
> > > > How about exporting integers identifying the flavors of RCU to rcutorture,
> > > > which rcutorture can then pass to rcutorture_get_gp_data()?  This allows
> > > > TINY_RCU to provide a trivial static inline function.  TREE_RCU and
> > > > TREE_PREEMPT_RCU can keep an array of pointers to the corresponding
> > > > rcu_state structure, with NULL pointers for flavors of RCU that don't
> > > > have any data to provide.
> > > > 
> > > > Would that help?
> > > 
> > > Either way seems fine: a single function with an extra parameter or a
> > > unique function per flavor.  But if you're going to provide the
> > > RCU-flavor integers, they should be in RCU itself and refer to RCU
> > > flavors, rather than being in rcutorture and refering to test types.
> > 
> > Fair enough, will take that approach!
> > 
> > I am thinking in terms of something like the following:
> > 
> > RCU_FLAVOR
> > RCU_BH_FLAVOR
> > RCU_SCHED_FLAVOR
> > SRCU_FLAVOR
> > OTHER_FLAVOR
> > 
> > The "OTHER_FLAVOR" would be what rcutorture uses for the "busted"
> > incorrect-on-purpose flavor of RCU, which is local to rcutorture.
> > 
> > Seem reasonable, or would some other naming scheme be better?
> 
> Seems reasonable to me.  I'd call the last one "INVALID_RCU_FLAVOR" or
> similar.

Done!

I ended up with a switch statement rather than an array of pointers, FWIW.

							Thanx, Paul

