Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3E1SmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:42:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3E1SmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:42:11 -0400
X-Authority-Analysis: v=2.0 cv=MNbiabll c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=U_UBT7BNE-4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FFjlQw3OIPcA:10 a=2E_tCxuvyUkL-5MFE2wA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130528184209.304356745@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 May 2013 14:38:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] rcu: Add _notrace variation of rcu_dereference_raw() and hlist_for_each_entry_rcu()
References: <20130528183841.535484906@goodmis.org>
Content-Disposition: inline; filename=add_rcu_dereference_raw_notrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As rcu_dereference_raw() under RCU debug config options can add quite a
bit of checks, and that tracing uses rcu_dereference_raw(), these checks
happen with the function tracer. The function tracer also happens to trace
these debug checks too. This added overhead can livelock the system.

Add a new interface to RCU for both rcu_dereference_raw_notrace() as well
as hlist_for_each_entry_rcu_notrace() as the hlist iterator uses the
rcu_dereference_raw() as well, and is used a bit with the function tracer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/include/linux/rculist.h
===================================================================
--- linux-trace.git.orig/include/linux/rculist.h
+++ linux-trace.git/include/linux/rculist.h
@@ -461,6 +461,26 @@ static inline void hlist_add_after_rcu(s
 			&(pos)->member)), typeof(*(pos)), member))
 
 /**
+ * hlist_for_each_entry_rcu_notrace - iterate over rcu list of given type (for tracing)
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as hlist_add_head_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ *
+ * This is the same as hlist_for_each_entry_rcu() except that it does
+ * not do any RCU debugging or tracing.
+ */
+#define hlist_for_each_entry_rcu_notrace(pos, head, member)			\
+	for (pos = hlist_entry_safe (rcu_dereference_raw_notrace(hlist_first_rcu(head)),\
+			typeof(*(pos)), member);			\
+		pos;							\
+		pos = hlist_entry_safe(rcu_dereference_raw_notrace(hlist_next_rcu(\
+			&(pos)->member)), typeof(*(pos)), member))
+
+/**
  * hlist_for_each_entry_rcu_bh - iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
Index: linux-trace.git/include/linux/rcupdate.h
===================================================================
--- linux-trace.git.orig/include/linux/rcupdate.h
+++ linux-trace.git/include/linux/rcupdate.h
@@ -640,6 +640,15 @@ static inline void rcu_preempt_sleep_che
 
 #define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
 
+/*
+ * The tracing infrastructure traces RCU (we want that), but unfortunately
+ * some of the RCU checks causes tracing to lock up the system.
+ *
+ * The tracing version of rcu_dereference_raw() must not call
+ * rcu_read_lock_held().
+ */
+#define rcu_dereference_raw_notrace(p) __rcu_dereference_check((p), 1, __rcu)
+
 /**
  * rcu_access_index() - fetch RCU index with no dereferencing
  * @p: The index to read

