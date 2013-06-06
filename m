Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3FFWbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:31:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3FFWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:31:43 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Ztj8HWjcsxMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=w4yIvt1DFNUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=CDACZWZoLOAk42Mg54wA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130606223142.024687528@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Jun 2013 18:29:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 1/4 (no gpg)] rcu: Add _notrace variation of rcu_dereference_raw() and
 hlist_for_each_entry_rcu()
References: <20130606222924.366792086@goodmis.org>
Content-Disposition: inline; filename=0001-rcu-Add-_notrace-variation-of-rcu_dereference_raw-an.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

As rcu_dereference_raw() under RCU debug config options can add quite a
bit of checks, and that tracing uses rcu_dereference_raw(), these checks
happen with the function tracer. The function tracer also happens to trace
these debug checks too. This added overhead can livelock the system.

Add a new interface to RCU for both rcu_dereference_raw_notrace() as well
as hlist_for_each_entry_rcu_notrace() as the hlist iterator uses the
rcu_dereference_raw() as well, and is used a bit with the function tracer.

Link: http://lkml.kernel.org/r/20130528184209.304356745@goodmis.org

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rculist.h  |   20 ++++++++++++++++++++
 include/linux/rcupdate.h |    9 +++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 8089e35..f4b1001 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -461,6 +461,26 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
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
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 4ccd68e..ddcc782 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -640,6 +640,15 @@ static inline void rcu_preempt_sleep_check(void)
 
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
-- 
1.7.10.4


