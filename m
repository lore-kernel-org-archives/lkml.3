Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaHXRJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:09:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54846 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752409AbaHXRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:08:53 -0400
Message-Id: <20140824170849.971161471@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 24 Aug 2014 13:08:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [PATCH 3/5] ftrace: Fix up trampoline accounting with looping on hash ops
References: <20140824170808.753599145@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftrace-Fix-up-trampoline-accounting-with-looping-on-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Now that a ftrace_hash can be shared by multiple ftrace_ops, they can dec
the rec->flags by more than once (one per those that share the ftrace_hash).
This means that the tramp_hash may not have a hash item when it was added.

For example, if two ftrace_ops share a hash for a ftrace record, and the
first ops has a trampoline, when it adds itself it will set the rec->flags
TRAMP flag and increments its nr_trampolines counter. When the second ops
is added, it must clear that tramp flag but also decrement the other ops
that shares its hash. As the update to the function callbacks has not yet
been performed, the other ops will not have the tramp hash set yet and it
can not be used to know to decrement its nr_trampolines.

Luckily, the tramp_hash does not need to be used. As the ftrace_mutex is
held, a ops with a trampoline to a record during an update of another ops
that shares the record will have its func_hash pointing to it. Since a
trampoline can only be set for a record if only one ops is attached to it,
we can just check if the record has a trampoline (the FTRACE_FL_TRAMP flag
is set) and then find the ops that has this record in its hashes.

Also added some output to help debug when things go wrong.

Cc: stable@vger.kernel.org # 3.16+ (apply after 3.17-rc4 is out)
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 37f9e90d241c..92376aeac4a7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1507,25 +1507,38 @@ static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
 static void ftrace_remove_tramp(struct ftrace_ops *ops,
 				struct dyn_ftrace *rec)
 {
-	struct ftrace_func_entry *entry;
-
-	entry = ftrace_lookup_ip(ops->tramp_hash, rec->ip);
-	if (!entry)
+	/* If TRAMP is not set, no ops should have a trampoline for this */
+	if (!(rec->flags & FTRACE_FL_TRAMP))
 		return;
 
+	rec->flags &= ~FTRACE_FL_TRAMP;
+
+	if ((!ftrace_hash_empty(ops->func_hash->filter_hash) &&
+	     !ftrace_lookup_ip(ops->func_hash->filter_hash, rec->ip)) ||
+	    ftrace_lookup_ip(ops->func_hash->notrace_hash, rec->ip))
+		return;
 	/*
 	 * The tramp_hash entry will be removed at time
 	 * of update.
 	 */
 	ops->nr_trampolines--;
-	rec->flags &= ~FTRACE_FL_TRAMP;
 }
 
-static void ftrace_clear_tramps(struct dyn_ftrace *rec)
+static void ftrace_clear_tramps(struct dyn_ftrace *rec, struct ftrace_ops *ops)
 {
 	struct ftrace_ops *op;
 
+	/* If TRAMP is not set, no ops should have a trampoline for this */
+	if (!(rec->flags & FTRACE_FL_TRAMP))
+		return;
+
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		/*
+		 * This function is called to clear other tramps
+		 * not the one that is being updated.
+		 */
+		if (op == ops)
+			continue;
 		if (op->nr_trampolines)
 			ftrace_remove_tramp(op, rec);
 	} while_for_each_ftrace_op(op);
@@ -1626,13 +1639,10 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				/*
 				 * If we are adding another function callback
 				 * to this function, and the previous had a
-				 * trampoline used, then we need to go back to
-				 * the default trampoline.
+				 * custom trampoline in use, then we need to go
+				 * back to the default trampoline.
 				 */
-				rec->flags &= ~FTRACE_FL_TRAMP;
-
-				/* remove trampolines from any ops for this rec */
-				ftrace_clear_tramps(rec);
+				ftrace_clear_tramps(rec, ops);
 			}
 
 			/*
@@ -1935,8 +1945,8 @@ unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
 	if (rec->flags & FTRACE_FL_TRAMP) {
 		ops = ftrace_find_tramp_ops_new(rec);
 		if (FTRACE_WARN_ON(!ops || !ops->trampoline)) {
-			pr_warning("Bad trampoline accounting at: %p (%pS)\n",
-				    (void *)rec->ip, (void *)rec->ip);
+			pr_warn("Bad trampoline accounting at: %p (%pS) (%lx)\n",
+				(void *)rec->ip, (void *)rec->ip, rec->flags);
 			/* Ftrace is shutting down, return anything */
 			return (unsigned long)FTRACE_ADDR;
 		}
@@ -2266,7 +2276,10 @@ static int ftrace_save_ops_tramp_hash(struct ftrace_ops *ops)
 	} while_for_each_ftrace_rec();
 
 	/* The number of recs in the hash must match nr_trampolines */
-	FTRACE_WARN_ON(ops->tramp_hash->count != ops->nr_trampolines);
+	if (FTRACE_WARN_ON(ops->tramp_hash->count != ops->nr_trampolines))
+		pr_warn("count=%ld trampolines=%d\n",
+			ops->tramp_hash->count,
+			ops->nr_trampolines);
 
 	return 0;
 }
-- 
2.0.1


