Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbaGCQMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:12:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:3822 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759149AbaGCQM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:26 -0400
Message-Id: <20140703161224.062459692@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 04/21] ftrace: Optimize function graph to be called directly
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-ftrace-Optimize-function-graph-to-be-called-directly.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Function graph tracing is a bit different than the function tracers, as
it is processed after either the ftrace_caller or ftrace_regs_caller
and we only have one place to modify the jump to ftrace_graph_caller,
the jump needs to happen after the restore of registeres.

The function graph tracer is dependent on the function tracer, where
even if the function graph tracing is going on by itself, the save and
restore of registers is still done for function tracing regardless of
if function tracing is happening, before it calls the function graph
code.

If there's no function tracing happening, it is possible to just call
the function graph tracer directly, and avoid the wasted effort to save
and restore regs for function tracing.

This requires adding new flags to the dyn_ftrace records:

  FTRACE_FL_TRAMP
  FTRACE_FL_TRAMP_EN

The first is set if the count for the record is one, and the ftrace_ops
associated to that record has its own trampoline. That way the mcount code
can call that trampoline directly.

In the future, trampolines can be added to arbitrary ftrace_ops, where you
can have two or more ftrace_ops registered to ftrace (like kprobes and perf)
and if they are not tracing the same functions, then instead of doing a
loop to check all registered ftrace_ops against their hashes, just call the
ftrace_ops trampoline directly, which would call the registered ftrace_ops
function directly.

Without this patch perf showed:

  0.05%  hackbench  [kernel.kallsyms]  [k] ftrace_caller
  0.05%  hackbench  [kernel.kallsyms]  [k] arch_local_irq_save
  0.05%  hackbench  [kernel.kallsyms]  [k] native_sched_clock
  0.04%  hackbench  [kernel.kallsyms]  [k] __buffer_unlock_commit
  0.04%  hackbench  [kernel.kallsyms]  [k] preempt_trace
  0.04%  hackbench  [kernel.kallsyms]  [k] prepare_ftrace_return
  0.04%  hackbench  [kernel.kallsyms]  [k] __this_cpu_preempt_check
  0.04%  hackbench  [kernel.kallsyms]  [k] ftrace_graph_caller

See that the ftrace_caller took up more time than the ftrace_graph_caller
did.

With this patch:

  0.05%  hackbench  [kernel.kallsyms]  [k] __buffer_unlock_commit
  0.04%  hackbench  [kernel.kallsyms]  [k] call_filter_check_discard
  0.04%  hackbench  [kernel.kallsyms]  [k] ftrace_graph_caller
  0.04%  hackbench  [kernel.kallsyms]  [k] sched_clock

The ftrace_caller is no where to be found and ftrace_graph_caller still
takes up the same percentage.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S |   5 +
 include/linux/ftrace.h      |  19 +++-
 kernel/trace/ftrace.c       | 242 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 254 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index c050a0153168..6b4e3c3b3d74 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -182,6 +182,10 @@ END(function_hook)
 ENTRY(ftrace_graph_caller)
 	MCOUNT_SAVE_FRAME
 
+	/* Check if tracing was disabled (quick check) */
+	cmpl $0, function_trace_stop
+	jne  fgraph_skip
+
 #ifdef CC_USING_FENTRY
 	leaq SS+16(%rsp), %rdi
 	movq $0, %rdx	/* No framepointers needed */
@@ -194,6 +198,7 @@ ENTRY(ftrace_graph_caller)
 
 	call	prepare_ftrace_return
 
+fgraph_skip:
 	MCOUNT_RESTORE_FRAME
 
 	retq
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e5baa6b2c93f..11e18fd58b1a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -118,12 +118,15 @@ struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
-	int __percpu			*disabled;
 	void				*private;
+	int __percpu			*disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
+	int				trampolines;
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
+	struct ftrace_hash		*tramp_hash;
 	struct mutex			regex_lock;
+	unsigned long			trampoline;
 #endif
 };
 
@@ -317,13 +320,15 @@ extern int ftrace_nr_registered_ops(void);
  * from tracing that function.
  */
 enum {
-	FTRACE_FL_ENABLED	= (1UL << 29),
+	FTRACE_FL_ENABLED	= (1UL << 31),
 	FTRACE_FL_REGS		= (1UL << 30),
-	FTRACE_FL_REGS_EN	= (1UL << 31)
+	FTRACE_FL_REGS_EN	= (1UL << 29),
+	FTRACE_FL_TRAMP		= (1UL << 28),
+	FTRACE_FL_TRAMP_EN	= (1UL << 27),
 };
 
-#define FTRACE_REF_MAX_SHIFT	29
-#define FTRACE_FL_BITS		3
+#define FTRACE_REF_MAX_SHIFT	27
+#define FTRACE_FL_BITS		5
 #define FTRACE_FL_MASKED_BITS	((1UL << FTRACE_FL_BITS) - 1)
 #define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
 #define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
@@ -436,6 +441,10 @@ void ftrace_modify_all_code(int command);
 #define FTRACE_ADDR ((unsigned long)ftrace_caller)
 #endif
 
+#ifndef FTRACE_GRAPH_ADDR
+#define FTRACE_GRAPH_ADDR ((unsigned long)ftrace_graph_caller)
+#endif
+
 #ifndef FTRACE_REGS_ADDR
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 # define FTRACE_REGS_ADDR ((unsigned long)ftrace_regs_caller)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a58d840305c3..5d15eb8146a7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1042,6 +1042,8 @@ static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+static struct ftrace_ops *removed_ops;
+
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
 # error Dynamic ftrace depends on MCOUNT_RECORD
 #endif
@@ -1512,6 +1514,33 @@ static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
 	return  keep_regs;
 }
 
+static void ftrace_remove_tramp(struct ftrace_ops *ops,
+				struct dyn_ftrace *rec)
+{
+	struct ftrace_func_entry *entry;
+
+	entry = ftrace_lookup_ip(ops->tramp_hash, rec->ip);
+	if (!entry)
+		return;
+
+	/*
+	 * The tramp_hash entry will be removed at time
+	 * of update.
+	 */
+	ops->trampolines--;
+	rec->flags &= ~FTRACE_FL_TRAMP;
+}
+
+static void ftrace_clear_tramps(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *op;
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		if (op->trampolines)
+			ftrace_remove_tramp(op, rec);
+	} while_for_each_ftrace_op(op);
+}
+
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1594,6 +1623,28 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			rec->flags++;
 			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == FTRACE_REF_MAX))
 				return;
+
+			/*
+			 * If there's only a single callback registered to a
+			 * function, and the ops has a trampoline registered
+			 * for it, then we can call it directly.
+			 */
+			if (ftrace_rec_count(rec) == 1 && ops->trampoline) {
+				rec->flags |= FTRACE_FL_TRAMP;
+				ops->trampolines++;
+			} else {
+				/*
+				 * If we are adding another function callback
+				 * to this function, and the previous had a
+				 * trampoline used, then we need to go back to
+				 * the default trampoline.
+				 */
+				rec->flags &= ~FTRACE_FL_TRAMP;
+
+				/* remove trampolines from any ops for this rec */
+				ftrace_clear_tramps(rec);
+			}
+
 			/*
 			 * If any ops wants regs saved for this function
 			 * then all ops will get saved regs.
@@ -1604,6 +1655,10 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == 0))
 				return;
 			rec->flags--;
+
+			if (ops->trampoline && !ftrace_rec_count(rec))
+				ftrace_remove_tramp(ops, rec);
+
 			/*
 			 * If the rec had REGS enabled and the ops that is
 			 * being removed had REGS set, then see if there is
@@ -1616,6 +1671,11 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				if (!test_rec_ops_needs_regs(rec))
 					rec->flags &= ~FTRACE_FL_REGS;
 			}
+
+			/*
+			 * flags will be cleared in ftrace_check_record()
+			 * if rec count is zero.
+			 */
 		}
 		count++;
 		/* Shortcut, if we handled all records, we are done. */
@@ -1704,13 +1764,19 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 		flag = FTRACE_FL_ENABLED;
 
 	/*
-	 * If enabling and the REGS flag does not match the REGS_EN, then
-	 * do not ignore this record. Set flags to fail the compare against
-	 * ENABLED.
+	 * If enabling and the REGS flag does not match the REGS_EN, or
+	 * the TRAMP flag doesn't match the TRAMP_EN, then do not ignore
+	 * this record. Set flags to fail the compare against ENABLED.
 	 */
-	if (flag &&
-	    (!(rec->flags & FTRACE_FL_REGS) != !(rec->flags & FTRACE_FL_REGS_EN)))
-		flag |= FTRACE_FL_REGS;
+	if (flag) {
+		if (!(rec->flags & FTRACE_FL_REGS) != 
+		    !(rec->flags & FTRACE_FL_REGS_EN))
+			flag |= FTRACE_FL_REGS;
+
+		if (!(rec->flags & FTRACE_FL_TRAMP) != 
+		    !(rec->flags & FTRACE_FL_TRAMP_EN))
+			flag |= FTRACE_FL_TRAMP;
+	}
 
 	/* If the state of this record hasn't changed, then do nothing */
 	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
@@ -1728,6 +1794,12 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 				else
 					rec->flags &= ~FTRACE_FL_REGS_EN;
 			}
+			if (flag & FTRACE_FL_TRAMP) {
+				if (rec->flags & FTRACE_FL_TRAMP)
+					rec->flags |= FTRACE_FL_TRAMP_EN;
+				else
+					rec->flags &= ~FTRACE_FL_TRAMP_EN;
+			}
 		}
 
 		/*
@@ -1736,7 +1808,7 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 		 * Otherwise,
 		 *   return UPDATE_MODIFY_CALL to tell the caller to convert
 		 *   from the save regs, to a non-save regs function or
-		 *   vice versa.
+		 *   vice versa, or from a trampoline call.
 		 */
 		if (flag & FTRACE_FL_ENABLED)
 			return FTRACE_UPDATE_MAKE_CALL;
@@ -1783,6 +1855,43 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
 	return ftrace_check_record(rec, enable, 0);
 }
 
+static struct ftrace_ops *
+ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *op;
+
+	/* Removed ops need to be tested first */
+	if (removed_ops && removed_ops->tramp_hash) {
+		if (ftrace_lookup_ip(removed_ops->tramp_hash, rec->ip))
+			return removed_ops;
+	}
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		if (!op->tramp_hash)
+			continue;
+
+		if (ftrace_lookup_ip(op->tramp_hash, rec->ip))
+			return op;
+
+	} while_for_each_ftrace_op(op);
+
+	return NULL;
+}
+
+static struct ftrace_ops *
+ftrace_find_tramp_ops_new(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *op;
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		/* pass rec in as regs to have non-NULL val */
+		if (ftrace_ops_test(op, rec->ip, rec))
+			return op;
+	} while_for_each_ftrace_op(op);
+
+	return NULL;
+}
+
 /**
  * ftrace_get_addr_new - Get the call address to set to
  * @rec:  The ftrace record descriptor
@@ -1795,6 +1904,20 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
  */
 unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
 {
+	struct ftrace_ops *ops;
+
+	/* Trampolines take precedence over regs */
+	if (rec->flags & FTRACE_FL_TRAMP) {
+		ops = ftrace_find_tramp_ops_new(rec);
+		if (FTRACE_WARN_ON(!ops || !ops->trampoline)) {
+			pr_warning("Bad trampoline accounting at: %p (%pS)\n",
+				    (void *)rec->ip, (void *)rec->ip);
+			/* Ftrace is shutting down, return anything */
+			return (unsigned long)FTRACE_ADDR;
+		}
+		return ops->trampoline;
+	}
+
 	if (rec->flags & FTRACE_FL_REGS)
 		return (unsigned long)FTRACE_REGS_ADDR;
 	else
@@ -1813,6 +1936,20 @@ unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
  */
 unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec)
 {
+	struct ftrace_ops *ops;
+
+	/* Trampolines take precedence over regs */
+	if (rec->flags & FTRACE_FL_TRAMP_EN) {
+		ops = ftrace_find_tramp_ops_curr(rec);
+		if (FTRACE_WARN_ON(!ops)) {
+			pr_warning("Bad trampoline accounting at: %p (%pS)\n",
+				    (void *)rec->ip, (void *)rec->ip);
+			/* Ftrace is shutting down, return anything */
+			return (unsigned long)FTRACE_ADDR;
+		}
+		return ops->trampoline;
+	}
+
 	if (rec->flags & FTRACE_FL_REGS_EN)
 		return (unsigned long)FTRACE_REGS_ADDR;
 	else
@@ -2055,6 +2192,78 @@ void __weak arch_ftrace_update_code(int command)
 	ftrace_run_stop_machine(command);
 }
 
+static int ftrace_save_ops_tramp_hash(struct ftrace_ops *ops)
+{
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	int size, bits;
+	int ret;
+
+	size = ops->trampolines;
+	bits = 0;
+	/*
+	 * Make the hash size about 1/2 the # found
+	 */
+	for (size /= 2; size; size >>= 1)
+		bits++;
+
+	ops->tramp_hash = alloc_ftrace_hash(bits);
+	/*
+	 * TODO: a failed allocation is going to screw up
+	 * the accounting of what needs to be modified
+	 * and not. For now, we kill ftrace if we fail
+	 * to allocate here. But there are ways around this,
+	 * but that will take a little more work.
+	 */
+	if (!ops->tramp_hash)
+		return -ENOMEM;
+
+	do_for_each_ftrace_rec(pg, rec) {
+		if (ftrace_rec_count(rec) == 1 &&
+		    ftrace_ops_test(ops, rec->ip, rec)) {
+
+			/* This record had better have a trampoline */
+			if (FTRACE_WARN_ON(!(rec->flags & FTRACE_FL_TRAMP_EN)))
+				return -1;
+
+			ret = add_hash_entry(ops->tramp_hash, rec->ip);
+			if (ret < 0)
+				return ret;
+		}
+	} while_for_each_ftrace_rec();
+
+	return 0;
+}
+
+static int ftrace_save_tramp_hashes(void)
+{
+	struct ftrace_ops *op;
+	int ret;
+
+	/*
+	 * Now that any trampoline is being used, we need to save the
+	 * hashes for the ops that have them. This allows the mapping
+	 * back from the record to the ops that has the trampoline to
+	 * know what code is being replaced. Modifying code must always
+	 * verify what it is changing.
+	 */
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+
+		/* The tramp_hash is recreated each time. */
+		free_ftrace_hash(op->tramp_hash);
+		op->tramp_hash = NULL;
+
+		if (op->trampolines) {
+			ret = ftrace_save_ops_tramp_hash(op);
+			if (ret)
+				return ret;
+		}
+
+	} while_for_each_ftrace_op(op);
+
+	return 0;
+}
+
 static void ftrace_run_update_code(int command)
 {
 	int ret;
@@ -2081,6 +2290,9 @@ static void ftrace_run_update_code(int command)
 
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
+
+	ret = ftrace_save_tramp_hashes();
+	FTRACE_WARN_ON(ret);
 }
 
 static ftrace_func_t saved_ftrace_func;
@@ -2171,8 +2383,16 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 		return 0;
 	}
 
+	/*
+	 * If the ops uses a trampoline, then it needs to be
+	 * tested first on update.
+	 */
+	removed_ops = ops;
+
 	ftrace_run_update_code(command);
 
+	removed_ops = NULL;
+
 	/*
 	 * Dynamic ops may be freed, we must make sure that all
 	 * callers are done before leaving this function.
@@ -5116,6 +5336,11 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	/* Function graph doesn't use the .func field of global_ops */
 	global_ops.flags |= FTRACE_OPS_FL_STUB;
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* Optimize function graph calling (if implemented by arch) */
+	global_ops.trampoline = FTRACE_GRAPH_ADDR;
+#endif
+
 	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
@@ -5136,6 +5361,9 @@ void unregister_ftrace_graph(void)
 	__ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
+#ifdef CONFIG_DYNAMIC_FTRACE
+	global_ops.trampoline = 0;
+#endif
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
-- 
2.0.0


