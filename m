Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaIKOty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:49:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22696 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753581AbaIKOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:49:12 -0400
Message-Id: <20140911144908.664780335@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 11 Sep 2014 10:47:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 7/9] ftrace: Replace tramp_hash with old_*_hash to save space
References: <20140911144744.907770249@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-ftrace-Replace-tramp_hash-with-old_-_hash-to-save-sp.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Allowing function callbacks to declare their own trampolines requires
that each ftrace_ops that has a trampoline must have some sort of
accounting that keeps track of which ops has a trampoline attached
to a record.

The easy way to solve this was to add a "tramp_hash" that created a
hash entry for every function that a ops uses with a trampoline.
But since we can have literally tens of thousands of functions being
traced, that means we need tens of thousands of descriptors to map
the ops to the function in the hash. This is quite expensive and
can cause enabling and disabling the function graph tracer to take
some time to start and stop. It can take up to several seconds to
disable or enable all functions in the function graph tracer for this
reason.

The better approach albeit more complex, is to keep track of how ops
are being enabled and disabled, and use that along with the counting
of the number of ops attached to records, to determive what ops has
a trampoline attached to a record at enabling and disabling of
tracing.

To do this, the tramp_hash has been replaced with an old_filter_hash
and old_notrace_hash, which get the copy of the ops filter_hash and
notrace_hash respectively. The old hashes is kept until the ops has
been modified or removed and the old hashes are used with the logic
of the accounting to determine the ops that have the trampoline of
a record. The reason this has less of a footprint is due to the trick
that an "empty" hash in the filter_hash means "all functions" and
an empty hash in the notrace hash means "no functions" in the hash.

This is much more efficienct, doesn't have the delay, and takes up
much less memory, as we do not need to map all the functions but
just figure out which functions are mapped at the time it is
enabled or disabled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   2 +-
 kernel/trace/ftrace.c  | 239 +++++++++++++++++--------------------------------
 2 files changed, 85 insertions(+), 156 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index d9216f6385d9..662697babd48 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -140,7 +140,7 @@ struct ftrace_ops {
 	int				nr_trampolines;
 	struct ftrace_ops_hash		local_hash;
 	struct ftrace_ops_hash		*func_hash;
-	struct ftrace_hash		*tramp_hash;
+	struct ftrace_ops_hash		old_hash;
 	unsigned long			trampoline;
 #endif
 };
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e43c793093e5..d325a1e76554 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1373,6 +1373,21 @@ update:
 	return 0;
 }
 
+static bool hash_contains_ip(unsigned long ip,
+			     struct ftrace_ops_hash *hash)
+{
+	/*
+	 * The function record is a match if it exists in the filter
+	 * hash and not in the notrace hash. Note, an emty hash is
+	 * considered a match for the filter hash, but an empty
+	 * notrace hash is considered not in the notrace hash.
+	 */
+	return (ftrace_hash_empty(hash->filter_hash) ||
+		ftrace_lookup_ip(hash->filter_hash, ip)) &&
+		(ftrace_hash_empty(hash->notrace_hash) ||
+		 !ftrace_lookup_ip(hash->notrace_hash, ip));
+}
+
 /*
  * Test the hashes for this ops to see if we want to call
  * the ops->func or not.
@@ -1388,8 +1403,7 @@ update:
 static int
 ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 {
-	struct ftrace_hash *filter_hash;
-	struct ftrace_hash *notrace_hash;
+	struct ftrace_ops_hash hash;
 	int ret;
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
@@ -1402,13 +1416,10 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 		return 0;
 #endif
 
-	filter_hash = rcu_dereference_raw_notrace(ops->func_hash->filter_hash);
-	notrace_hash = rcu_dereference_raw_notrace(ops->func_hash->notrace_hash);
+	hash.filter_hash = rcu_dereference_raw_notrace(ops->func_hash->filter_hash);
+	hash.notrace_hash = rcu_dereference_raw_notrace(ops->func_hash->notrace_hash);
 
-	if ((ftrace_hash_empty(filter_hash) ||
-	     ftrace_lookup_ip(filter_hash, ip)) &&
-	    (ftrace_hash_empty(notrace_hash) ||
-	     !ftrace_lookup_ip(notrace_hash, ip)))
+	if (hash_contains_ip(ip, &hash))
 		ret = 1;
 	else
 		ret = 0;
@@ -1520,46 +1531,6 @@ static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
 	return  keep_regs;
 }
 
-static void ftrace_remove_tramp(struct ftrace_ops *ops,
-				struct dyn_ftrace *rec)
-{
-	/* If TRAMP is not set, no ops should have a trampoline for this */
-	if (!(rec->flags & FTRACE_FL_TRAMP))
-		return;
-
-	rec->flags &= ~FTRACE_FL_TRAMP;
-
-	if ((!ftrace_hash_empty(ops->func_hash->filter_hash) &&
-	     !ftrace_lookup_ip(ops->func_hash->filter_hash, rec->ip)) ||
-	    ftrace_lookup_ip(ops->func_hash->notrace_hash, rec->ip))
-		return;
-	/*
-	 * The tramp_hash entry will be removed at time
-	 * of update.
-	 */
-	ops->nr_trampolines--;
-}
-
-static void ftrace_clear_tramps(struct dyn_ftrace *rec, struct ftrace_ops *ops)
-{
-	struct ftrace_ops *op;
-
-	/* If TRAMP is not set, no ops should have a trampoline for this */
-	if (!(rec->flags & FTRACE_FL_TRAMP))
-		return;
-
-	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		/*
-		 * This function is called to clear other tramps
-		 * not the one that is being updated.
-		 */
-		if (op == ops)
-			continue;
-		if (op->nr_trampolines)
-			ftrace_remove_tramp(op, rec);
-	} while_for_each_ftrace_op(op);
-}
-
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1648,18 +1619,16 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			 * function, and the ops has a trampoline registered
 			 * for it, then we can call it directly.
 			 */
-			if (ftrace_rec_count(rec) == 1 && ops->trampoline) {
+			if (ftrace_rec_count(rec) == 1 && ops->trampoline)
 				rec->flags |= FTRACE_FL_TRAMP;
-				ops->nr_trampolines++;
-			} else {
+			else
 				/*
 				 * If we are adding another function callback
 				 * to this function, and the previous had a
 				 * custom trampoline in use, then we need to go
 				 * back to the default trampoline.
 				 */
-				ftrace_clear_tramps(rec, ops);
-			}
+				rec->flags &= ~FTRACE_FL_TRAMP;
 
 			/*
 			 * If any ops wants regs saved for this function
@@ -1672,9 +1641,6 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				return;
 			rec->flags--;
 
-			if (ops->trampoline && !ftrace_rec_count(rec))
-				ftrace_remove_tramp(ops, rec);
-
 			/*
 			 * If the rec had REGS enabled and the ops that is
 			 * being removed had REGS set, then see if there is
@@ -1689,6 +1655,17 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			}
 
 			/*
+			 * If the rec had TRAMP enabled, then it needs to
+			 * be cleared. As TRAMP can only be enabled iff
+			 * there is only a single ops attached to it.
+			 * In otherwords, always disable it on decrementing.
+			 * In the future, we may set it if rec count is
+			 * decremented to one, and the ops that is left
+			 * has a trampoline.
+			 */
+			rec->flags &= ~FTRACE_FL_TRAMP;
+
+			/*
 			 * flags will be cleared in ftrace_check_record()
 			 * if rec count is zero.
 			 */
@@ -1910,15 +1887,14 @@ static struct ftrace_ops *
 ftrace_find_tramp_ops_any(struct dyn_ftrace *rec)
 {
 	struct ftrace_ops *op;
+	unsigned long ip = rec->ip;
 
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
 
 		if (!op->trampoline)
 			continue;
 
-		if (ftrace_lookup_ip(op->func_hash->filter_hash, rec->ip) &&
-		    (ftrace_hash_empty(op->func_hash->notrace_hash) ||
-		     !ftrace_lookup_ip(op->func_hash->notrace_hash, rec->ip)))
+		if (hash_contains_ip(ip, op->func_hash))
 			return op;
 	} while_for_each_ftrace_op(op);
 
@@ -1929,18 +1905,51 @@ static struct ftrace_ops *
 ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
 {
 	struct ftrace_ops *op;
+	unsigned long ip = rec->ip;
 
-	/* Removed ops need to be tested first */
-	if (removed_ops && removed_ops->tramp_hash) {
-		if (ftrace_lookup_ip(removed_ops->tramp_hash, rec->ip))
+	/*
+	 * Need to check removed ops first.
+	 * If they are being removed, and this rec has a tramp,
+	 * and this rec is in the ops list, then it would be the
+	 * one with the tramp.
+	 */
+	if (removed_ops) {
+		if (hash_contains_ip(ip, &removed_ops->old_hash))
 			return removed_ops;
 	}
 
+	/*
+	 * Need to find the current trampoline for a rec.
+	 * Now, a trampoline is only attached to a rec if there
+	 * was a single 'ops' attached to it. But this can be called
+	 * when we are adding another op to the rec or removing the
+	 * current one. Thus, if the op is being added, we can
+	 * ignore it because it hasn't attached itself to the rec
+	 * yet. That means we just need to find the op that has a
+	 * trampoline and is not beeing added.
+	 */
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (!op->tramp_hash)
+
+		if (!op->trampoline)
+			continue;
+
+		/*
+		 * If the ops is being added, it hasn't gotten to
+		 * the point to be removed from this tree yet.
+		 */
+		if (op->flags & FTRACE_OPS_FL_ADDING)
 			continue;
 
-		if (ftrace_lookup_ip(op->tramp_hash, rec->ip))
+		/*
+		 * If the ops is not being added and has a trampoline,
+		 * then it must be the one that we want!
+		 */
+		if (hash_contains_ip(ip, op->func_hash))
+			return op;
+
+		/* If the ops is being modified, it may be in the old hash. */
+		if ((op->flags & FTRACE_OPS_FL_MODIFYING) &&
+		    hash_contains_ip(ip, &op->old_hash))
 			return op;
 
 	} while_for_each_ftrace_op(op);
@@ -1952,10 +1961,11 @@ static struct ftrace_ops *
 ftrace_find_tramp_ops_new(struct dyn_ftrace *rec)
 {
 	struct ftrace_ops *op;
+	unsigned long ip = rec->ip;
 
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
 		/* pass rec in as regs to have non-NULL val */
-		if (ftrace_ops_test(op, rec->ip, rec))
+		if (hash_contains_ip(ip, op->func_hash))
 			return op;
 	} while_for_each_ftrace_op(op);
 
@@ -2262,92 +2272,6 @@ void __weak arch_ftrace_update_code(int command)
 	ftrace_run_stop_machine(command);
 }
 
-static int ftrace_save_ops_tramp_hash(struct ftrace_ops *ops)
-{
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
-	int size, bits;
-	int ret;
-
-	size = ops->nr_trampolines;
-	bits = 0;
-	/*
-	 * Make the hash size about 1/2 the # found
-	 */
-	for (size /= 2; size; size >>= 1)
-		bits++;
-
-	ops->tramp_hash = alloc_ftrace_hash(bits);
-	/*
-	 * TODO: a failed allocation is going to screw up
-	 * the accounting of what needs to be modified
-	 * and not. For now, we kill ftrace if we fail
-	 * to allocate here. But there are ways around this,
-	 * but that will take a little more work.
-	 */
-	if (!ops->tramp_hash)
-		return -ENOMEM;
-
-	do_for_each_ftrace_rec(pg, rec) {
-		if (ftrace_rec_count(rec) == 1 &&
-		    ftrace_ops_test(ops, rec->ip, rec)) {
-
-			/*
-			 * If another ops adds to a rec, the rec will
-			 * lose its trampoline and never get it back
-			 * until all ops are off of it.
-			 */
-			if (!(rec->flags & FTRACE_FL_TRAMP))
-				continue;
-
-			/* This record had better have a trampoline */
-			if (FTRACE_WARN_ON(!(rec->flags & FTRACE_FL_TRAMP_EN)))
-				return -1;
-
-			ret = add_hash_entry(ops->tramp_hash, rec->ip);
-			if (ret < 0)
-				return ret;
-		}
-	} while_for_each_ftrace_rec();
-
-	/* The number of recs in the hash must match nr_trampolines */
-	if (FTRACE_WARN_ON(ops->tramp_hash->count != ops->nr_trampolines))
-		pr_warn("count=%ld trampolines=%d\n",
-			ops->tramp_hash->count,
-			ops->nr_trampolines);
-
-	return 0;
-}
-
-static int ftrace_save_tramp_hashes(void)
-{
-	struct ftrace_ops *op;
-	int ret;
-
-	/*
-	 * Now that any trampoline is being used, we need to save the
-	 * hashes for the ops that have them. This allows the mapping
-	 * back from the record to the ops that has the trampoline to
-	 * know what code is being replaced. Modifying code must always
-	 * verify what it is changing.
-	 */
-	do_for_each_ftrace_op(op, ftrace_ops_list) {
-
-		/* The tramp_hash is recreated each time. */
-		free_ftrace_hash(op->tramp_hash);
-		op->tramp_hash = NULL;
-
-		if (op->nr_trampolines) {
-			ret = ftrace_save_ops_tramp_hash(op);
-			if (ret)
-				return ret;
-		}
-
-	} while_for_each_ftrace_op(op);
-
-	return 0;
-}
-
 static void ftrace_run_update_code(int command)
 {
 	int ret;
@@ -2367,9 +2291,6 @@ static void ftrace_run_update_code(int command)
 
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
-
-	ret = ftrace_save_tramp_hashes();
-	FTRACE_WARN_ON(ret);
 }
 
 static void ftrace_run_modify_code(struct ftrace_ops *ops, int command)
@@ -2489,8 +2410,16 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	ops->flags |= FTRACE_OPS_FL_REMOVING;
 	removed_ops = ops;
 
+	/* The trampoline logic checks the old hashes */
+	ops->old_hash.filter_hash = ops->func_hash->filter_hash;
+	ops->old_hash.notrace_hash = ops->func_hash->notrace_hash;
+
 	ftrace_run_update_code(command);
 
+	ops->old_hash.filter_hash = NULL;
+	ops->old_hash.notrace_hash = NULL;
+
+	removed_ops = NULL;
 	ops->flags &= ~FTRACE_OPS_FL_REMOVING;
 
 	/*
@@ -3017,7 +2946,7 @@ static int t_show(struct seq_file *m, void *v)
 			struct ftrace_ops *ops;
 
 			ops = ftrace_find_tramp_ops_any(rec);
-			if (ops && ops->trampoline)
+			if (ops)
 				seq_printf(m, "\ttramp: %pS",
 					   (void *)ops->trampoline);
 			else
-- 
2.0.1


