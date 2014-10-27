Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaJ0R6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:58:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:44979 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751912AbaJ0R6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:58:47 -0400
Message-Id: <20141027175845.233342474@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 27 Oct 2014 13:56:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] ftrace: Fix checking of trampoline ftrace_ops in finding trampoline
References: <20141027175606.622391559@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftrace-Fix-checking-of-trampoline-ftrace_ops-in-find.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When modifying code, ftrace has several checks to make sure things
are being done correctly. One of them is to make sure any code it
modifies is exactly what it expects it to be before it modifies it.
In order to do so with the new trampoline logic, it must be able
to find out what trampoline a function is hooked to in order to
see if the code that hooks to it is what's expected.

The logic to find the trampoline from a record (accounting descriptor
for a function that is hooked) needs to only look at the "old_hash"
of an ops that is being modified. The old_hash is the list of function
an ops is hooked to before its update. Since a record would only be
pointing to an ops that is being modified if it was already hooked
before.

Currently, it can pick a modified ops based on its new functions it
will be hooked to, and this picks the wrong trampoline and causes
the check to fail, disabling ftrace.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

ftrace: squash into ordering of ops for modification
---
 kernel/trace/ftrace.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 483b8c1b1de0..31c90fec4158 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1925,8 +1925,16 @@ ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
 	 * when we are adding another op to the rec or removing the
 	 * current one. Thus, if the op is being added, we can
 	 * ignore it because it hasn't attached itself to the rec
-	 * yet. That means we just need to find the op that has a
-	 * trampoline and is not beeing added.
+	 * yet.
+	 *
+	 * If an ops is being modified (hooking to different functions)
+	 * then we don't care about the new functions that are being
+	 * added, just the old ones (that are probably being removed).
+	 *
+	 * If we are adding an ops to a function that already is using
+	 * a trampoline, it needs to be removed (trampolines are only
+	 * for single ops connected), then an ops that is not being
+	 * modified also needs to be checked.
 	 */
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
 
@@ -1940,17 +1948,23 @@ ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
 		if (op->flags & FTRACE_OPS_FL_ADDING)
 			continue;
 
+
 		/*
-		 * If the ops is not being added and has a trampoline,
-		 * then it must be the one that we want!
+		 * If the ops is being modified and is in the old
+		 * hash, then it is probably being removed from this
+		 * function.
 		 */
-		if (hash_contains_ip(ip, op->func_hash))
-			return op;
-
-		/* If the ops is being modified, it may be in the old hash. */
 		if ((op->flags & FTRACE_OPS_FL_MODIFYING) &&
 		    hash_contains_ip(ip, &op->old_hash))
 			return op;
+		/*
+		 * If the ops is not being added or modified, and it's
+		 * in its normal filter hash, then this must be the one
+		 * we want!
+		 */
+		if (!(op->flags & FTRACE_OPS_FL_MODIFYING) &&
+		    hash_contains_ip(ip, op->func_hash))
+			return op;
 
 	} while_for_each_ftrace_op(op);
 
-- 
2.1.1


