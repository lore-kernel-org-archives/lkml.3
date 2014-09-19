Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbaISR0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:26:08 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:39139 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbaISR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:26:07 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [RFC PATCH] rcu: Change use of __this_cpu ops on a bool type
Date: Fri, 19 Sep 2014 13:26:03 -0400
Message-Id: <1411147563-9136-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_{read/write}() uses sizeof() to determine the size of the variable.
Using this operation on a bool type causes sparse to complain.

I checked the generated code and there is only a slight difference in
instructions generated.

I am not sure this warning by sparse is really valid, but let us silence it
anyways.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c        | 12 ++++++++----
 kernel/rcu/tree_plugin.h |  6 ++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index bc085e5..85f228a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -186,21 +186,25 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
  */
 void rcu_sched_qs(void)
 {
-	if (!__this_cpu_read(rcu_sched_data.passed_quiesce)) {
+	struct rcu_data *rdp = __this_cpu_ptr(&rcu_sched_data);
+
+	if (!rdp->passed_quiesce) {
 		trace_rcu_grace_period(TPS("rcu_sched"),
 				       __this_cpu_read(rcu_sched_data.gpnum),
 				       TPS("cpuqs"));
-		__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
+		rdp->passed_quiesce = true;
 	}
 }
 
 void rcu_bh_qs(void)
 {
-	if (!__this_cpu_read(rcu_bh_data.passed_quiesce)) {
+	struct rcu_data *rdp = __this_cpu_ptr(&rcu_bh_data);
+
+	if (!rdp->passed_quiesce) {
 		trace_rcu_grace_period(TPS("rcu_bh"),
 				       __this_cpu_read(rcu_bh_data.gpnum),
 				       TPS("cpuqs"));
-		__this_cpu_write(rcu_bh_data.passed_quiesce, 1);
+		rdp->passed_quiesce = true;
 	}
 }
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 77f9376..98de303 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -143,11 +143,13 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  */
 static void rcu_preempt_qs(void)
 {
-	if (!__this_cpu_read(rcu_preempt_data.passed_quiesce)) {
+	struct rcu_data *rdp = __this_cpu_ptr(&rcu_preempt_data);
+
+	if (!rdp->passed_quiesce) {
 		trace_rcu_grace_period(TPS("rcu_preempt"),
 				       __this_cpu_read(rcu_preempt_data.gpnum),
 				       TPS("cpuqs"));
-		__this_cpu_write(rcu_preempt_data.passed_quiesce, 1);
+		rdp->passed_quiesce = true;
 		barrier(); /* Coordinate with rcu_preempt_check_callbacks(). */
 		current->rcu_read_unlock_special.b.need_qs = false;
 	}
-- 
2.1.0

