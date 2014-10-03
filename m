Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbaJCWDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:03:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaJCVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.16 269/357] ftrace: Update all ftrace_ops for a ftrace_hash_ops update
Date: Fri,  3 Oct 2014 14:30:55 -0700
Message-Id: <20141003212941.581123467@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 84261912ebee41269004e8a9f3614ba38ef6b206 upstream.

When updating what an ftrace_ops traces, if it is registered (that is,
actively tracing), and that ftrace_ops uses the shared global_ops
local_hash, then we need to update all tracers that are active and
also share the global_ops' ftrace_hash_ops.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 kernel/trace/ftrace.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1298,9 +1298,9 @@ alloc_and_copy_ftrace_hash(int size_bits
 }
 
 static void
-ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
+ftrace_hash_rec_disable_modify(struct ftrace_ops *ops, int filter_hash);
 static void
-ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
+ftrace_hash_rec_enable_modify(struct ftrace_ops *ops, int filter_hash);
 
 static int
 ftrace_hash_move(struct ftrace_ops *ops, int enable,
@@ -1320,7 +1320,7 @@ ftrace_hash_move(struct ftrace_ops *ops,
 	 * Remove the current set, update the hash and add
 	 * them back.
 	 */
-	ftrace_hash_rec_disable(ops, enable);
+	ftrace_hash_rec_disable_modify(ops, enable);
 
 	/*
 	 * If the new source is empty, just free dst and assign it
@@ -1369,7 +1369,7 @@ ftrace_hash_move(struct ftrace_ops *ops,
 	 *  On success, we enable the new hash.
 	 *  On failure, we re-enable the original hash.
 	 */
-	ftrace_hash_rec_enable(ops, enable);
+	ftrace_hash_rec_enable_modify(ops, enable);
 
 	return ret;
 }
@@ -1613,6 +1613,41 @@ static void ftrace_hash_rec_enable(struc
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


