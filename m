Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3ETPCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:02:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42810 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab3ETO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:58:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/13] rcu: Shrink TINY_RCU by reworking CPU-stall ifdefs
Date: Mon, 20 May 2013 07:58:20 -0700
Message-Id: <1369061900-546-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-9360-0000-0000-000012433E0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

TINY_RCU's reset_cpu_stall_ticks() and check_cpu_stalls() functions
are defined unconditionally, and are empty functions if CONFIG_RCU_TRACE
is disabled (which in turns disables detection of RCU CPU stalls).
These empty functions can add a bit of bloat to TINY_RCU, so this
commit reworks the ifdefs so that these functions are defined only
if they actually do something.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c        | 4 ++--
 kernel/rcutiny_plugin.h | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 4adc9e2..aa34411 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -204,7 +204,7 @@ static int rcu_is_cpu_rrupt_from_idle(void)
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
-	reset_cpu_stall_ticks(rcp);
+	RCU_TRACE(reset_cpu_stall_ticks(rcp));
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
@@ -251,7 +251,7 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	check_cpu_stalls();
+	RCU_TRACE(check_cpu_stalls());
 	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 65ef180..0cd385a 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -158,15 +158,11 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
 }
 
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
 static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
 {
-#ifdef CONFIG_RCU_TRACE
 	rcp->ticks_this_gp = 0;
 	rcp->gp_start = jiffies;
 	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
-#endif /* #ifdef CONFIG_RCU_TRACE */
 }
 
 static void check_cpu_stalls(void)
@@ -174,3 +170,5 @@ static void check_cpu_stalls(void)
 	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
 	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
 }
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
-- 
1.8.1.5

