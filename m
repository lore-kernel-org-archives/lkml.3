Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721Ab3FTUp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:45:58 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48494 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965757Ab3FTUpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:45:50 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH 2/4] sched: Consolidate nohz cpu load prelude code
Date: Thu, 20 Jun 2013 22:45:39 +0200
Message-Id: <1371761141-25386-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
References: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gather the common code that computes the pending idle cpu load
to decay.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/proc.c |   40 ++++++++++++++--------------------------
 1 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index bb3a6a0..030528a 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -470,11 +470,14 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
-			      unsigned long pending_updates)
+static void __update_cpu_load(struct rq *this_rq, unsigned long this_load)
 {
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long pending_updates;
 	int i, scale;
 
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	this_rq->last_load_update_tick = curr_jiffies;
 	this_rq->nr_load_updates++;
 
 	/* Update our load: */
@@ -521,20 +524,15 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
  */
 void update_idle_cpu_load(struct rq *this_rq)
 {
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
 	unsigned long load = this_rq->load.weight;
-	unsigned long pending_updates;
 
 	/*
 	 * bail if there's load or we're actually up-to-date.
 	 */
-	if (load || curr_jiffies == this_rq->last_load_update_tick)
+	if (load || jiffies == this_rq->last_load_update_tick)
 		return;
 
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	this_rq->last_load_update_tick = curr_jiffies;
-
-	__update_cpu_load(this_rq, load, pending_updates);
+	__update_cpu_load(this_rq, load);
 }
 
 /*
@@ -543,22 +541,16 @@ void update_idle_cpu_load(struct rq *this_rq)
 void update_cpu_load_nohz(void)
 {
 	struct rq *this_rq = this_rq();
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long pending_updates;
 
-	if (curr_jiffies == this_rq->last_load_update_tick)
+	if (jiffies == this_rq->last_load_update_tick)
 		return;
 
 	raw_spin_lock(&this_rq->lock);
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	if (pending_updates) {
-		this_rq->last_load_update_tick = curr_jiffies;
-		/*
-		 * We were idle, this means load 0, the current load might be
-		 * !0 due to remote wakeups and the sort.
-		 */
-		__update_cpu_load(this_rq, 0, pending_updates);
-	}
+	/*
+	 * We were idle, this means load 0, the current load might be
+	 * !0 due to remote wakeups and the sort.
+	 */
+	__update_cpu_load(this_rq, 0);
 	raw_spin_unlock(&this_rq->lock);
 }
 #endif /* CONFIG_NO_HZ */
@@ -568,11 +560,7 @@ void update_cpu_load_nohz(void)
  */
 void update_cpu_load_active(struct rq *this_rq)
 {
-	/*
-	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
-	 */
-	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, this_rq->load.weight);
 
 	calc_load_account_active(this_rq);
 }
-- 
1.7.5.4

