Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaJ0RsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:48:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48378 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaJ0RsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:48:17 -0400
Date: Mon, 27 Oct 2014 10:44:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: hung tasks in 3.18.0-rc1-00221-gc3351df
Message-ID: <20141027174424.GB27568@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.11.1410231619340.11555@adalberg.ut.ee>
 <20141024001822.GK4977@linux.vnet.ibm.com>
 <alpine.LRH.2.11.1410241057270.15464@adalberg.ut.ee>
 <20141024145509.GO4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024145509.GO4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102717-0033-0000-0000-000000DDA096
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 07:55:09AM -0700, Paul E. McKenney wrote:
> On Fri, Oct 24, 2014 at 10:58:17AM +0300, Meelis Roos wrote:

[ . . . ]

> > > The get_state_synchronize_rcu() from within the wait for _rcu_barrier()
> > > looks a bit odd, but perhaps this is stack-tracing inaccuracy.
> > > 
> > > Could you please send your .config?
> 
> This does look like something that a couple of other people are seeing.
> Could you please check to see if reverting this commit makes the problem
> go away?
> 
> 35ce7f29a44a rcu: Create rcuo kthreads only for onlined CPUs
> 
> This cannot be the full fix because this commit is itself a bug fix, but
> it would be good to check whether you are really seeing what they are
> seeing.  ;-)

------------------------------------------------------------------------

rcu: Make rcu_barrier() understand about missing rcuo kthreads

Commit 35ce7f29a44a (rcu: Create rcuo kthreads only for onlined CPUs)
avoids creating rcuo kthreads for CPUs that never come online.  This
fixes a bug in many instances of firmware: Instead of lying about their
age, these systems instead lie about the number of CPUs that they have.
Before commit 35ce7f29a44a, this could result in huge numbers of useless
rcuo kthreads being created.

It appears that experience indicates that I should have told the
people suffering from this problem to fix their broken firmware, but
I instead produced what turned out to be a partial fix.   The missing
piece supplied by this commit makes sure that rcu_barrier() knows not to
post callbacks for no-CBs CPUs that have not yet come online, because
otherwise rcu_barrier() will hang on systems having firmware that lies
about the number of CPUs.

It is tempting to simply have rcu_barrier() refuse to post a callback on
any no-CBs CPU that does not have an rcuo kthread.  This unfortunately
does not work because rcu_barrier() is required to wait for all pending
callbacks.  It is therefore required to wait even for those callbacks
that cannot possibly be invoked.  Even if doing so hangs the system.

Given that posting a callback to a no-CBs CPU that does not yet have an
rcuo kthread can hang rcu_barrier(), It is tempting to report an error
in this case.  Unfortunately, this will result in false positives at
boot time, when it is perfectly legal to post callbacks to the boot CPU
before the scheduler has started, in other words, before it is legal
to invoke rcu_barrier().

So this commit instead has rcu_barrier() avoid posting callbacks to
CPUs having neither rcuo kthread nor pending callbacks, and has it
complain bitterly if it finds CPUs having no rcuo kthread but some
pending callbacks.  And when rcu_barrier() does find CPUs having no rcuo
kthread but pending callbacks, as noted earlier, it has no choice but
to hang indefinitely.

Reported-by: Yanko Kaneti <yaneti@declera.com>
Reported-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Reported-by: Meelis Roos <mroos@linux.ee>
Reported-by: Eric B Munson <emunson@akamai.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index aa8e5eea3ab4..c78e88ce5ea3 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -660,18 +660,18 @@ TRACE_EVENT(rcu_torture_read,
 /*
  * Tracepoint for _rcu_barrier() execution.  The string "s" describes
  * the _rcu_barrier phase:
- *	"Begin": rcu_barrier_callback() started.
- *	"Check": rcu_barrier_callback() checking for piggybacking.
- *	"EarlyExit": rcu_barrier_callback() piggybacked, thus early exit.
- *	"Inc1": rcu_barrier_callback() piggyback check counter incremented.
- *	"Offline": rcu_barrier_callback() found offline CPU
- *	"OnlineNoCB": rcu_barrier_callback() found online no-CBs CPU.
- *	"OnlineQ": rcu_barrier_callback() found online CPU with callbacks.
- *	"OnlineNQ": rcu_barrier_callback() found online CPU, no callbacks.
+ *	"Begin": _rcu_barrier() started.
+ *	"Check": _rcu_barrier() checking for piggybacking.
+ *	"EarlyExit": _rcu_barrier() piggybacked, thus early exit.
+ *	"Inc1": _rcu_barrier() piggyback check counter incremented.
+ *	"OfflineNoCB": _rcu_barrier() found callback on never-online CPU
+ *	"OnlineNoCB": _rcu_barrier() found online no-CBs CPU.
+ *	"OnlineQ": _rcu_barrier() found online CPU with callbacks.
+ *	"OnlineNQ": _rcu_barrier() found online CPU, no callbacks.
  *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
  *	"CB": An rcu_barrier_callback() invoked a callback, not the last.
  *	"LastCB": An rcu_barrier_callback() invoked the last callback.
- *	"Inc2": rcu_barrier_callback() piggyback check counter incremented.
+ *	"Inc2": _rcu_barrier() piggyback check counter incremented.
  * The "cpu" argument is the CPU or -1 if meaningless, the "cnt" argument
  * is the count of remaining callbacks, and "done" is the piggybacking count.
  */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f6880052b917..7680fc275036 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3312,11 +3312,16 @@ static void _rcu_barrier(struct rcu_state *rsp)
 			continue;
 		rdp = per_cpu_ptr(rsp->rda, cpu);
 		if (rcu_is_nocb_cpu(cpu)) {
-			_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
-					   rsp->n_barrier_done);
-			atomic_inc(&rsp->barrier_cpu_count);
-			__call_rcu(&rdp->barrier_head, rcu_barrier_callback,
-				   rsp, cpu, 0);
+			if (!rcu_nocb_cpu_needs_barrier(rsp, cpu)) {
+				_rcu_barrier_trace(rsp, "OfflineNoCB", cpu,
+						   rsp->n_barrier_done);
+			} else {
+				_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
+						   rsp->n_barrier_done);
+				atomic_inc(&rsp->barrier_cpu_count);
+				__call_rcu(&rdp->barrier_head,
+					   rcu_barrier_callback, rsp, cpu, 0);
+			}
 		} else if (ACCESS_ONCE(rdp->qlen)) {
 			_rcu_barrier_trace(rsp, "OnlineQ", cpu,
 					   rsp->n_barrier_done);
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 4beab3d2328c..8e7b1843896e 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -587,6 +587,7 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
+static bool rcu_nocb_cpu_needs_barrier(struct rcu_state *rsp, int cpu);
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
 static void rcu_init_one_nocb(struct rcu_node *rnp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 927c17b081c7..68c5b23b7173 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2050,6 +2050,33 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
 }
 
 /*
+ * Does the specified CPU need an RCU callback for the specified flavor
+ * of rcu_barrier()?
+ */
+static bool rcu_nocb_cpu_needs_barrier(struct rcu_state *rsp, int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
+	struct rcu_head *rhp;
+
+	/* No-CBs CPUs might have callbacks on any of three lists. */
+	rhp = ACCESS_ONCE(rdp->nocb_head);
+	if (!rhp)
+		rhp = ACCESS_ONCE(rdp->nocb_gp_head);
+	if (!rhp)
+		rhp = ACCESS_ONCE(rdp->nocb_follower_head);
+
+	/* Having no rcuo kthread but CBs after scheduler starts is bad! */
+	if (!ACCESS_ONCE(rdp->nocb_kthread) && rhp) {
+		/* RCU callback enqueued before CPU first came online??? */
+		pr_err("RCU: Never-onlined no-CBs CPU %d has CB %p\n",
+		       cpu, rhp->func);
+		WARN_ON_ONCE(1);
+	}
+
+	return !!rhp;
+}
+
+/*
  * Enqueue the specified string of rcu_head structures onto the specified
  * CPU's no-CBs lists.  The CPU is specified by rdp, the head of the
  * string by rhp, and the tail of the string by rhtp.  The non-lazy/lazy
@@ -2646,6 +2673,10 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 
+static bool rcu_nocb_cpu_needs_barrier(struct rcu_state *rsp, int cpu)
+{
+}
+
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
 }

