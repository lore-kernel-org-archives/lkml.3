Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3E1Smg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:42:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3E1SmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:42:12 -0400
X-Authority-Analysis: v=2.0 cv=IZAFqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1XnhMa43XEEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QZ4w3rYvwOcA:10 a=_sU22LERHAiRM1DjZHAA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130528184209.467603904@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 May 2013 14:38:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] ftrace: Use the rcu _notrace variants for rcu_dereference_raw() and friends
References: <20130528183841.535484906@goodmis.org>
Content-Disposition: inline; filename=ftrace-rcu-dereference.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As rcu_dereference_raw() under RCU debug config options can add quite a
bit of checks, and that tracing uses rcu_dereference_raw(), these checks
happen with the function tracer. The function tracer also happens to trace
these debug checks too. This added overhead can livelock the system.

Have the function tracer use the new RCU _notrace equivalents that do
not do the debug checks for RCU.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/kernel/trace/ftrace.c
===================================================================
--- linux-trace.git.orig/kernel/trace/ftrace.c
+++ linux-trace.git/kernel/trace/ftrace.c
@@ -120,22 +120,22 @@ static void ftrace_ops_no_ops(unsigned l
 
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
- * can use rcu_dereference_raw() is that elements removed from this list
+ * can use rcu_dereference_raw_notrace() is that elements removed from this list
  * are simply leaked, so there is no need to interact with a grace-period
- * mechanism.  The rcu_dereference_raw() calls are needed to handle
+ * mechanism.  The rcu_dereference_raw_notrace() calls are needed to handle
  * concurrent insertions into the ftrace_global_list.
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
 #define do_for_each_ftrace_op(op, list)			\
-	op = rcu_dereference_raw(list);			\
+	op = rcu_dereference_raw_notrace(list);			\
 	do
 
 /*
  * Optimized for just a single item in the list (as that is the normal case).
  */
 #define while_for_each_ftrace_op(op)				\
-	while (likely(op = rcu_dereference_raw((op)->next)) &&	\
+	while (likely(op = rcu_dereference_raw_notrace((op)->next)) &&	\
 	       unlikely((op) != &ftrace_list_end))
 
 static inline void ftrace_ops_init(struct ftrace_ops *ops)
@@ -779,7 +779,7 @@ ftrace_find_profiled_func(struct ftrace_
 	if (hlist_empty(hhd))
 		return NULL;
 
-	hlist_for_each_entry_rcu(rec, hhd, node) {
+	hlist_for_each_entry_rcu_notrace(rec, hhd, node) {
 		if (rec->ip == ip)
 			return rec;
 	}
@@ -1165,7 +1165,7 @@ ftrace_lookup_ip(struct ftrace_hash *has
 
 	hhd = &hash->buckets[key];
 
-	hlist_for_each_entry_rcu(entry, hhd, hlist) {
+	hlist_for_each_entry_rcu_notrace(entry, hhd, hlist) {
 		if (entry->ip == ip)
 			return entry;
 	}
@@ -1422,8 +1422,8 @@ ftrace_ops_test(struct ftrace_ops *ops, 
 	struct ftrace_hash *notrace_hash;
 	int ret;
 
-	filter_hash = rcu_dereference_raw(ops->filter_hash);
-	notrace_hash = rcu_dereference_raw(ops->notrace_hash);
+	filter_hash = rcu_dereference_raw_notrace(ops->filter_hash);
+	notrace_hash = rcu_dereference_raw_notrace(ops->notrace_hash);
 
 	if ((ftrace_hash_empty(filter_hash) ||
 	     ftrace_lookup_ip(filter_hash, ip)) &&
@@ -2920,7 +2920,7 @@ static void function_trace_probe_call(un
 	 * on the hash. rcu_read_lock is too dangerous here.
 	 */
 	preempt_disable_notrace();
-	hlist_for_each_entry_rcu(entry, hhd, node) {
+	hlist_for_each_entry_rcu_notrace(entry, hhd, node) {
 		if (entry->ip == ip)
 			entry->ops->func(ip, parent_ip, &entry->data);
 	}

