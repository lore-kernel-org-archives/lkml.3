Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3GMApx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:45:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab3GMApt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:45:49 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=yhlb_k0tiOQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3-bisJ1sjJIA:10 a=0vGzujyhlAE0wRuDPhsA:9 a=jeBq3FmKZ4MA:10 a=-qnxwe8RVnLnafE0:21 a=60k8tSGeGKPqUclM:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130713004547.861725299@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Jul 2013 20:41:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/4] rcu: Simplify RCU_STATE_INITIALIZER() macro
References: <20130713004102.219523935@goodmis.org>
Content-Disposition: inline; filename=0002-rcu-Simplify-RCU_STATE_INITIALIZER-macro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The RCU_STATE_INITIALIZER() macro is used only in the rcutree.c file
as well as the rcutree_plugin.h file. It is passed as a rvalue to
a variable of a similar name. A per_cpu variable is also created
with a similar name as well.

The uses of RCU_STATE_INITIALIZER() can be simplified to remove some
of the duplicate code that is done. Currently the three users of this
macro has this format:

struct rcu_state rcu_sched_state =
	RCU_STATE_INITIALIZER(rcu_sched, call_rcu_sched);
DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);

Notice that "rcu_sched" is called three times. This is the same with
the other two users. This can be condensed to just:

RCU_STATE_INITIALIZER(rcu_sched, call_rcu_sched);

by moving the rest into the macro itself.

This also opens the door to allow the RCU tracepoint strings and
their addresses to be exported so that userspace tracing tools can
translate the contents of the pointers of the RCU tracepoints.
The change will allow for helper code to be placed in the
RCU_STATE_INITIALIZER() macro to export the name that is used.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c        |   14 ++++++--------
 kernel/rcutree_plugin.h |    4 +---
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f560eb3..89a8b10 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -64,7 +64,8 @@
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 
-#define RCU_STATE_INITIALIZER(sname, sabbr, cr) { \
+#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
+struct rcu_state sname##_state = { \
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
 	.fqs_state = RCU_GP_IDLE, \
@@ -77,14 +78,11 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
 	.name = #sname, \
 	.abbr = sabbr, \
-}
-
-struct rcu_state rcu_sched_state =
-	RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
-DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
+}; \
+DEFINE_PER_CPU(struct rcu_data, sname##_data)
 
-struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
+RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
 
 static struct rcu_state *rcu_state;
 LIST_HEAD(rcu_struct_flavors);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 49df554..5cdb559 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -110,9 +110,7 @@ static void __init rcu_bootup_announce_oddness(void)
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
-struct rcu_state rcu_preempt_state =
-	RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
-DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
+RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
-- 
1.7.10.4


