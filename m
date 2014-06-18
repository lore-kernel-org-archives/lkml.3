Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaFRQVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:21:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56589 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaFRQVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:21:23 -0400
Date: Wed, 18 Jun 2014 09:21:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140618162117.GM4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
 <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
 <20140529000909.GC6507@localhost.localdomain>
 <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
 <20140610164641.GD1951@localhost.localdomain>
 <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
 <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
 <20140618143612.GC4669@linux.vnet.ibm.com>
 <CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061816-0928-0000-0000-000002BC61BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 05:58:40AM -1000, Linus Torvalds wrote:
> On Jun 18, 2014 4:36 AM, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> wrote:
> >
> > I could easily add an option to RCU to allow people to tell it not to
> > use NMIs to dump the stack.
> 
> I don't think it should be an "option".
> 
> We should stop using nmi as if it was something "normal". It isn't. Code
> running in nmi context should be special, and should be very very aware
> that it is special. That goes way beyond "don't use printk". We seem to
> have gone way way too far in using nmi context.
> 
> So we should get *rid* of code in nmi context rather than then complain
> about printk being buggy.

OK, unconditional non-use of NMIs is even easier.  ;-)

Something like the following.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Don't use NMIs to dump other CPUs' stacks

Although NMI-based stack dumps are in principle more accurate, they are
also more likely to trigger deadlocks.  This commit therefore replaces
all uses of trigger_all_cpu_backtrace() with rcu_dump_cpu_stacks(), so
that the CPU detecting an RCU CPU stall does the stack dumping.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c590e1201c74..777624e1329b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -932,10 +932,7 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 }
 
 /*
- * Dump stacks of all tasks running on stalled CPUs.  This is a fallback
- * for architectures that do not implement trigger_all_cpu_backtrace().
- * The NMI-triggered stack traces are more accurate because they are
- * printed by the target CPU.
+ * Dump stacks of all tasks running on stalled CPUs.
  */
 static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
 {
@@ -1013,7 +1010,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
 	if (ndetected == 0)
 		pr_err("INFO: Stall ended before state dump start\n");
-	else if (!trigger_all_cpu_backtrace())
+	else
 		rcu_dump_cpu_stacks(rsp);
 
 	/* Complain about tasks blocking the grace period. */
@@ -1044,8 +1041,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
 		jiffies - rsp->gp_start,
 		(long)rsp->gpnum, (long)rsp->completed, totqlen);
-	if (!trigger_all_cpu_backtrace())
-		dump_stack();
+	rcu_dump_cpu_stacks(rsp);
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, ACCESS_ONCE(rsp->jiffies_stall)))

