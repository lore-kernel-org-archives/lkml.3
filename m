Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3ANTuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:50:06 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49920 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3ANTuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:50:03 -0500
Date: Mon, 14 Jan 2013 11:49:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
Message-ID: <20130114194956.GB3384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130107142649.c843e0b711532dc3a631e4cf@canb.auug.org.au>
 <50EB252C.4010005@infradead.org>
 <20130107221627.GZ2525@linux.vnet.ibm.com>
 <20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au>
 <1357600327.5190.13.camel@gandalf.local.home>
 <1357605379.5190.15.camel@gandalf.local.home>
 <20130108035348.GF2525@linux.vnet.ibm.com>
 <50F43612.8080600@infradead.org>
 <20130114173208.GY3384@linux.vnet.ibm.com>
 <50F45321.50808@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F45321.50808@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011419-3620-0000-0000-000000E5257F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:49:05AM -0800, Randy Dunlap wrote:
> On 01/14/13 09:32, Paul E. McKenney wrote:
> > On Mon, Jan 14, 2013 at 08:45:06AM -0800, Randy Dunlap wrote:
> >> On 01/07/13 19:53, Paul E. McKenney wrote:
> >>> On Mon, Jan 07, 2013 at 07:36:19PM -0500, Steven Rostedt wrote:
> >>>> On Mon, 2013-01-07 at 18:12 -0500, Steven Rostedt wrote:
> >>>>> On Tue, 2013-01-08 at 09:59 +1100, Stephen Rothwell wrote:
> >>>>>> Hi Paul,
> >>>>>>
> >>>>>> On Mon, 7 Jan 2013 14:16:27 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>>>>>>
> >>>>>>> On Mon, Jan 07, 2013 at 11:42:36AM -0800, Randy Dunlap wrote:
> >>>>>>>>
> >>>>>>>> on i386 or x86_64:
> >>>>>>>>
> >>>>>>>> ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> >>>>>>>
> >>>>>>> Hello, Randy,
> >>>>>>>
> >>>>>>> Did your build include the following, also pushed to -next in that same
> >>>>>>> batch from -rcu?  Including Steven Rostedt on CC for his take.
> >>>>>>
> >>>>>> That commit was certainly in next-20130107.
> >>>>>
> >>>>> Could be bad config dependencies.
> >>>>
> >>>> Paul,
> >>>>
> >>>> You need to also select TRACE_CLOCK if you are going to use it.
> >>>
> >>> Thank you, Steve!
> >>>
> >>> Randy, does the following patch help?
> >>>
> >>> 							Thanx, Paul
> >>
> >> Hi Paul,
> >>
> >> This patch fixed the Jan. 7 linux-next build errors, but there is
> >> still some similar problem with current linux-next (0114 and late
> >> last week as well).
> >>
> >> ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> > 
> > Ah, my bad...
> > 
> > Does the following (rough and untested) patch help?
> 
> Yes, it helps, but there is still the same problem in
> rcu_torture_reader() -- after that it builds OK.

One of those days, I guess...  Thank you for fixing it up.

Please see below for a more civilized fix.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu.h b/kernel/rcu.h
index 7f8e759..b5d30c3 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -24,6 +24,7 @@
 #define __LINUX_RCU_H
 
 #ifdef CONFIG_RCU_TRACE
+#include <linux/trace_clock.h>
 #define RCU_TRACE(stmt) stmt
 #else /* #ifdef CONFIG_RCU_TRACE */
 #define RCU_TRACE(stmt)
@@ -118,4 +119,13 @@ int rcu_jiffies_till_stall_check(void);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
 
+static inline u64 notrace rcu_trace_clock_local(void)
+{
+#ifdef CONFIG_RCU_TRACE
+	return trace_clock_local();
+#else /* #ifdef CONFIG_RCU_TRACE */
+	return 0;
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+}
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index cd4c35d..f28f501 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -46,8 +46,9 @@
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
-#include <linux/trace_clock.h>
 #include <asm/byteorder.h>
+#include <trace/events/rcu.h>
+#include "rcu.h"
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
@@ -1051,7 +1052,7 @@ static void rcu_torture_timer(unsigned long unused)
 
 	idx = cur_ops->readlock();
 	completed = cur_ops->completed();
-	ts = trace_clock_local();
+	ts = rcu_trace_clock_local();
 	p = rcu_dereference_check(rcu_torture_current,
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
@@ -1122,7 +1123,7 @@ rcu_torture_reader(void *arg)
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
-		ts = trace_clock_local();
+		ts = rcu_trace_clock_local();
 		p = rcu_dereference_check(rcu_torture_current,
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||

