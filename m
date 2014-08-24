Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaHXRIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:08:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:14246 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752116AbaHXRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:08:51 -0400
Message-Id: <20140824170849.801726356@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 24 Aug 2014 13:08:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [PATCH 2/5] ftrace: Update all ftrace_ops for a ftrace_hash_ops update
References: <20140824170808.753599145@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftrace-Update-all-ftrace_ops-for-a-ftrace_hash_ops-u.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When updating what an ftrace_ops traces, if it is registered (that is,
actively tracing), and that ftrace_ops uses the shared global_ops
local_hash, then we need to update all tracers that are active and
also share the global_ops' ftrace_hash_ops.

Cc: stable@vger.kernel.org # 3.16 (apply after 3.17-rc4 is out)
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c92757adba79..37f9e90d241c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1292,9 +1292,9 @@ alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
 }
 
 static void
-ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
+ftrace_hash_rec_disable_modify(struct ftrace_ops *ops, int filter_hash);
 static void
-ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
+ftrace_hash_rec_enable_modify(struct ftrace_ops *ops, int filter_hash);
 
 static int
 ftrace_hash_move(struct ftrace_ops *ops, int enable,
@@ -1346,13 +1346,13 @@ update:
 	 * Remove the current set, update the hash and add
 	 * them back.
 	 */
-	ftrace_hash_rec_disable(ops, enable);
+	ftrace_hash_rec_disable_modify(ops, enable);
 
 	old_hash = *dst;
 	rcu_assign_pointer(*dst, new_hash);
 	free_ftrace_hash_rcu(old_hash);
 
-	ftrace_hash_rec_enable(ops, enable);
+	ftrace_hash_rec_enable_modify(ops, enable);
 
 	return 0;
 }
@@ -1686,6 +1686,41 @@ static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
 	__ftrace_hash_rec_update(ops, filter_hash, 1);
 }
 
+static void ftrace_hash_rec_update_modify(struct ftrace_ops *ops,
+					  int filter_hash, int inc)
+{
+	struct ftrace_ops *op;
+
+	__ftrace_hash_rec_update(ops, filter_hash, inc);
+
+	if (ops->func_hash != &global_ops.local_hash)
+		return;
+
+	/*
+	 * If the ops shares the global_ops hash, then we need to update
+	 * all ops that are enabled and use this hash.
+	 */
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		/* Already done */
+		if (op == ops)
+			continue;
+		if (op->func_hash == &global_ops.local_hash)
+			__ftrace_hash_rec_update(op, filter_hash, inc);
+	} while_for_each_ftrace_op(op);
+}
+
+static void ftrace_hash_rec_disable_modify(struct ftrace_ops *ops,
+					   int filter_hash)
+{
+	ftrace_hash_rec_update_modify(ops, filter_hash, 0);
+}
+
+static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
+					  int filter_hash)
+{
+	ftrace_hash_rec_update_modify(ops, filter_hash, 1);
+}
+
 static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
-- 
2.0.1


