Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3H3N35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:29:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3H3NYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:24:06 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Cic2vvSNioQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5ckQPjUOnXkA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=h-8mOlai3LmyHrTG0I0A:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130830132404.107233435@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 30 Aug 2013 09:02:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Dave Jones <davej@redhat.com>
Subject: [RFC][PATCH 2/8] ftrace: Do not set ftrace records for unsafe RCU when not allowed
References: <20130830130205.504335754@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Do-not-set-ftrace-records-for-unsafe-RCU-when.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

For the ftrace_ops that use RCU read locks, and can not be called by
unsafe RCU functions (those outside of RCU tracking), have them not
update the RCU unsafe function records when they are being registered
or unregistered.

The ftrace function records store a counter of all the ftrace_ops
callbacks that are hooked to the function the record represents.
As unsafe RCU functions do not call callbacks that do not specify
that they do not use RCU, do not update those records.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2580cdb..dc11951 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1168,6 +1168,12 @@ static struct ftrace_page *ftrace_new_pgs;
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
 
+/*
+ * Hash of functions that are not safe to be called by
+ * callbacks that use RCU read locks.
+ */
+static struct ftrace_hash *ftrace_unsafe_rcu;
+
 static bool ftrace_hash_empty(struct ftrace_hash *hash)
 {
 	return !hash || !hash->count;
@@ -1627,6 +1633,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 {
 	struct ftrace_hash *hash;
 	struct ftrace_hash *other_hash;
+	struct ftrace_hash *rcu_hash;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	int count = 0;
@@ -1636,6 +1643,12 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return;
 
+	/* Ignore rcu unsafe functions unless ops handles them */
+	if (ops->flags & FTRACE_OPS_FL_RCU_SAFE)
+		rcu_hash = NULL;
+	else
+		rcu_hash = ftrace_unsafe_rcu;
+
 	/*
 	 * In the filter_hash case:
 	 *   If the count is zero, we update all records.
@@ -1669,6 +1682,10 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 		int in_hash = 0;
 		int match = 0;
 
+		/* Ignore all in the rcu unsafe hash */
+		if (ftrace_lookup_ip(rcu_hash, rec->ip))
+			continue;
+
 		if (all) {
 			/*
 			 * Only the filter_hash affects all records.
@@ -4280,8 +4297,6 @@ struct notifier_block ftrace_module_exit_nb = {
 extern struct ftrace_func_finder *__start_ftrace_unsafe_rcu[];
 extern struct ftrace_func_finder *__stop_ftrace_unsafe_rcu[];
 
-static struct ftrace_hash *ftrace_unsafe_rcu;
-
 static void __init create_unsafe_rcu_hash(void)
 {
 	struct ftrace_func_finder *finder;
-- 
1.7.10.4


