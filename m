Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3BDSgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:36:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3BDSgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:36:15 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4A6_XDq7Hi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=04ct_mqUnDIA:10 a=VnNF1IyMAAAA:8 a=HcK8BPdSa1V2uxgnAtUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360002973.5642.66.camel@gandalf.local.home>
Subject: Re: [PATCH] rcu: Have rcu torture test select trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 04 Feb 2013 13:36:13 -0500
In-Reply-To: <20130204165932.GW2632@linux.vnet.ibm.com>
References: <1359993141.5642.61.camel@gandalf.local.home>
	 <20130204165932.GW2632@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 08:59 -0800, Paul E. McKenney wrote:
> On Mon, Feb 04, 2013 at 10:52:21AM -0500, Steven Rostedt wrote:
> > The rcu torture test uses trace_clock, and requires that it be built
> > into the kernel. If it is not, then we get the following build error:
> > 
> > ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> > 
> > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> This would work, but would unnecessarily force trace_clock_local()
> to be defined when RCU tracing is disabled.  So, would the alternative
> patch I posted work for you?
> 

Unfortunately the other patch wasn't Cc'd to LKML (I hate private
emails).

I would suggest the following to be complete, why keep that extra divide
around?

-- Steve

I started with your patch:


rcu: Allow rcutorture to be built at low optimization levels

The uses of trace_clock_local() are dead code when CONFIG_RCU_TRACE=n,
but some compilers might nevertheless generate code calling this function.
This commit therefore ensures that trace_clock_local() is invoked only
when CONFIG_RCU_TRACE=y.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/kernel/rcutorture.c
===================================================================
--- linux-trace.git.orig/kernel/rcutorture.c
+++ linux-trace.git/kernel/rcutorture.c
@@ -208,6 +208,20 @@ MODULE_PARM_DESC(rcutorture_runnable, "S
 #define rcu_can_boost() 0
 #endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 
+#ifdef CONFIG_RCU_TRACE
+static u64 notrace rcu_trace_clock_local(void)
+{
+	u64 ts = trace_clock_local();
+	unsigned long __maybe_unused ts_rem = do_div(ts, NSEC_PER_USEC);
+	return ts;
+}
+#else /* #ifdef CONFIG_RCU_TRACE */
+static u64 notrace rcu_trace_clock_local(void)
+{
+	return 0ULL;
+}
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
 static unsigned long shutdown_time;	/* jiffies to system shutdown. */
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
@@ -1051,7 +1065,7 @@ static void rcu_torture_timer(unsigned l
 
 	idx = cur_ops->readlock();
 	completed = cur_ops->completed();
-	ts = trace_clock_local();
+	ts = rcu_trace_clock_local();
 	p = rcu_dereference_check(rcu_torture_current,
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
@@ -1075,8 +1089,6 @@ static void rcu_torture_timer(unsigned l
 	}
 	completed_end = cur_ops->completed();
 	if (pipe_count > 1) {
-		unsigned long __maybe_unused ts_rem = do_div(ts, NSEC_PER_USEC);
-
 		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu, ts,
 					  completed, completed_end);
 		rcutorture_trace_dump();
@@ -1122,7 +1134,7 @@ rcu_torture_reader(void *arg)
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
-		ts = trace_clock_local();
+		ts = rcu_trace_clock_local();
 		p = rcu_dereference_check(rcu_torture_current,
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||
@@ -1144,9 +1156,6 @@ rcu_torture_reader(void *arg)
 		}
 		completed_end = cur_ops->completed();
 		if (pipe_count > 1) {
-			unsigned long __maybe_unused ts_rem =
-					do_div(ts, NSEC_PER_USEC);
-
 			do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu,
 						  ts, completed, completed_end);
 			rcutorture_trace_dump();


