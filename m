Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab3HSRRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:17:08 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40828 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3HSRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:17:05 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 19 Aug 2013 10:16:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 1/5] rcu: Add duplicate-callback tests to
 rcutorture
Message-ID: <20130819171651.GA11063@jtriplet-mobl1>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818025420.GC28923@leaf>
 <20130819035528.GD29406@linux.vnet.ibm.com>
 <20130819041925.GA12202@leaf>
 <20130819160945.GA32415@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160945.GA32415@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:09:45AM -0700, Paul E. McKenney wrote:
> On Sun, Aug 18, 2013 at 09:19:25PM -0700, Josh Triplett wrote:
> > On Sun, Aug 18, 2013 at 08:55:28PM -0700, Paul E. McKenney wrote:
> > > On Sat, Aug 17, 2013 at 07:54:20PM -0700, Josh Triplett wrote:
> > > > On Sat, Aug 17, 2013 at 07:25:13PM -0700, Paul E. McKenney wrote:
> > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > This commit adds a object_debug option to rcutorture to allow the
> > > > > debug-object-based checks for duplicate call_rcu() invocations to
> > > > > be deterministically tested.
> > > > > 
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > > > Cc: Sedat Dilek <sedat.dilek@gmail.com>
> > > > > Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > > > > Cc: Rik van Riel <riel@surriel.com>
> > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > > 
> > > > Two comments below; with those fixed,
> > > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > > 
> > > > > ---
> > > > > @@ -100,6 +101,8 @@ module_param(fqs_stutter, int, 0444);
> > > > >  MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
> > > > >  module_param(n_barrier_cbs, int, 0444);
> > > > >  MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
> > > > > +module_param(object_debug, int, 0444);
> > > > > +MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
> > > > 
> > > > modules-next has a change to ignore and warn about
> > > > unknown module parameters.  Thus, I'd suggest wrapping the ifdef around
> > > > this module parameter, so it doesn't exist at all without
> > > > CONFIG_DEBUG_OBJECTS_RCU_HEAD.
> > > > 
> > > > Alternatively, consider providing the test unconditionally, and just
> > > > printing a big warning message saying that it's going to cause
> > > > corruption in the !CONFIG_DEBUG_OBJECTS_RCU_HEAD case.
> > > 
> > > I currently do something like the above.  The module parameter
> > > is defined unconditionally, but the actual tests are under #ifdef
> > > CONFIG_DEBUG_OBJECTS_RCU_HEAD.  If you specify object_debug for a
> > > !CONFIG_DEBUG_OBJECTS_RCU_HEAD kernel, the pr_alert() below happens,
> > > and the test is omitted, thus avoiding the list corruption.
> > > 
> > > Seem reasonable?
> > 
> > That's exactly the bit I was commenting on.  I'm saying that you should
> > either make the test unconditional (perhaps with a warning saying it's
> > about to cause list corruption), or you should compile out the module
> > parameter as well and then you don't need the pr_alert (since current
> > kernels will emit a warning when you pass a non-existent module
> > parameter).
> > 
> > Personally, I'd go with the latter.
> 
> Ah, the problem is the ugly ifdef in the middle of a function.  Yeah,
> that is a problem in need of fixing.  No idea what I was thinking...
> 
> How about if I pull that block of code out into its own function, and
> #ifdef the function body.  For example, something like that shown below.
[...]
> static void rcu_test_debug_objects(void)
> {
> #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> 	struct rcu_head rh1;
> 	struct rcu_head rh2;
> 
> 	init_rcu_head_on_stack(&rh1);
> 	init_rcu_head_on_stack(&rh2);
> 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
> 	local_irq_disable(); /* Make it hard to finish grace period. */
> 	call_rcu(&rh1, rcu_torture_leak_cb); /* start grace period. */
> 	call_rcu(&rh2, rcu_torture_err_cb);
> 	call_rcu(&rh2, rcu_torture_err_cb); /* duplicate callback. */
> 	local_irq_enable();
> 	rcu_barrier();
> 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
> 	destroy_rcu_head_on_stack(&rh1);
> 	destroy_rcu_head_on_stack(&rh2);
> #else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> 	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
> #endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> }
> 

That's a major improvement, but I'd still suggest a couple more changes:
move the if for the config option into that function inside the ifdef,
wrap the config parameter itself in an ifdef so it doesn't exist without
CONFIG_DEBUG_OBJECTS_RCU_HEAD, and drop the #else branch since the
kernel will already emit a warning if you use the module parameter with
!CONFIG_DEBUG_OBJECTS_RCU_HEAD.

- Josh Triplett
