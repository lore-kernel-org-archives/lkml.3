Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3DLXTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:19:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53863 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3DLXTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:19:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing delay from HZ
Date: Fri, 12 Apr 2013 16:19:13 -0700
Message-Id: <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5406-0000-0000-0000076916F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Systems with HZ=100 can have slow bootup times due to the default
three-jiffy delays between quiescent-state forcing attempts.  This
commit therefore auto-tunes the RCU_JIFFIES_TILL_FORCE_QS value based
on the value of HZ.  However, this would break very large systems that
require more time between quiescent-state forcing attempts.  This
commit therefore also ups the default delay by one jiffy for each
256 CPUs that might be on the system (based off of nr_cpu_ids at
runtime, -not- NR_CPUS at build time).

Reported-by: Paul Mackerras <paulus@au1.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 18 ++++++++++++++++--
 kernel/rcutree.h | 12 +++++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3710d74..cbfb4ee 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -218,8 +218,8 @@ module_param(blimit, long, 0444);
 module_param(qhimark, long, 0444);
 module_param(qlowmark, long, 0444);
 
-static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
-static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
+static ulong jiffies_till_first_fqs = ULONG_MAX;
+static ulong jiffies_till_next_fqs = ULONG_MAX;
 
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
@@ -3252,11 +3252,25 @@ static void __init rcu_init_one(struct rcu_state *rsp,
  */
 static void __init rcu_init_geometry(void)
 {
+	ulong d;
 	int i;
 	int j;
 	int n = nr_cpu_ids;
 	int rcu_capacity[MAX_RCU_LVLS + 1];
 
+	/*
+	 * Initialize any unspecified boot parameters.
+	 * The default values of jiffies_till_first_fqs and
+	 * jiffies_till_next_fqs are set to the RCU_JIFFIES_TILL_FORCE_QS
+	 * value, which is a function of HZ, then adding one for each
+	 * RCU_JIFFIES_FQS_DIV CPUs that might be on the system.
+	 */
+	d = RCU_JIFFIES_TILL_FORCE_QS + nr_cpu_ids / RCU_JIFFIES_FQS_DIV;
+	if (jiffies_till_first_fqs == ULONG_MAX)
+		jiffies_till_first_fqs = d;
+	if (jiffies_till_next_fqs == ULONG_MAX)
+		jiffies_till_next_fqs = d;
+
 	/* If the compile-time values are accurate, just leave. */
 	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF &&
 	    nr_cpu_ids == NR_CPUS)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 08972c9..7d5f876 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -342,7 +342,17 @@ struct rcu_data {
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 
-#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#if HZ > 500
+#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for jiffies_till_first_fqs */
+#elif HZ > 250
+#define RCU_JIFFIES_TILL_FORCE_QS	 2
+#else
+#define RCU_JIFFIES_TILL_FORCE_QS	 1
+#endif
+#define RCU_JIFFIES_FQS_DIV		256	/* Very large systems need */
+						/*  more delay between bouts */
+						/*  of quiescent-state */
+						/*  forcing. */
 
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
-- 
1.8.1.5

