Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaHXRKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:10:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:14246 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752385AbaHXRIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:08:52 -0400
Message-Id: <20140824170849.637795944@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 24 Aug 2014 13:08:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [PATCH 1/5] ftrace: Allow ftrace_ops to use the hashes from other ops
References: <20140824170808.753599145@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Allow-ftrace_ops-to-use-the-hashes-from-other.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently the top level debug file system function tracer shares its
ftrace_ops with the function graph tracer. This was thought to be fine
because the tracers are not used together, as one can only enable
function or function_graph tracer in the current_tracer file.

But that assumption proved to be incorrect. The function profiler
can use the function graph tracer when function tracing is enabled.
Since all function graph users uses the function tracing ftrace_ops
this causes a conflict and when a user enables both function profiling
as well as the function tracer it will crash ftrace and disable it.

The quick solution so far is to move them as separate ftrace_ops like
it was earlier. The problem though is to synchronize the functions that
are traced because both function and function_graph tracer are limited
by the selections made in the set_ftrace_filter and set_ftrace_notrace
files.

To handle this, a new structure is made called ftrace_ops_hash. This
structure will now hold the filter_hash and notrace_hash, and the
ftrace_ops will point to this structure. That will allow two ftrace_ops
to share the same hashes.

Since most ftrace_ops do not share the hashes, and to keep allocation
simple, the ftrace_ops structure will include both a pointer to the
ftrace_ops_hash called func_hash, as well as the structure itself,
called local_hash. When the ops are registered, the func_hash pointer
will be initialized to point to the local_hash within the ftrace_ops
structure. Some of the ftrace internal ftrace_ops will be initialized
statically. This will allow for the function and function_graph tracer
to have separate ops but still share the same hash tables that determine
what functions they trace.

Cc: stable@vger.kernel.org # 3.16 (apply after 3.17-rc4 is out)
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |  14 +++++--
 kernel/trace/ftrace.c  | 100 +++++++++++++++++++++++++------------------------
 2 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 6bb5e3f2a3b4..f0b0edbf55a9 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -102,6 +102,15 @@ enum {
 	FTRACE_OPS_FL_DELETED			= 1 << 8,
 };
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+/* The hash used to know what functions callbacks trace */
+struct ftrace_ops_hash {
+	struct ftrace_hash		*notrace_hash;
+	struct ftrace_hash		*filter_hash;
+	struct mutex			regex_lock;
+};
+#endif
+
 /*
  * Note, ftrace_ops can be referenced outside of RCU protection.
  * (Although, for perf, the control ops prevent that). If ftrace_ops is
@@ -121,10 +130,9 @@ struct ftrace_ops {
 	int __percpu			*disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	int				nr_trampolines;
-	struct ftrace_hash		*notrace_hash;
-	struct ftrace_hash		*filter_hash;
+	struct ftrace_ops_hash		local_hash;
+	struct ftrace_ops_hash		*func_hash;
 	struct ftrace_hash		*tramp_hash;
-	struct mutex			regex_lock;
 	unsigned long			trampoline;
 #endif
 };
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1654b12c891a..c92757adba79 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -65,15 +65,17 @@
 #define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_CONTROL)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-#define INIT_REGEX_LOCK(opsname)	\
-	.regex_lock	= __MUTEX_INITIALIZER(opsname.regex_lock),
+#define INIT_OPS_HASH(opsname)	\
+	.func_hash		= &opsname.local_hash,			\
+	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock),
 #else
-#define INIT_REGEX_LOCK(opsname)
+#define INIT_OPS_HASH(opsname)
 #endif
 
 static struct ftrace_ops ftrace_list_end __read_mostly = {
 	.func		= ftrace_stub,
 	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_STUB,
+	INIT_OPS_HASH(ftrace_list_end)
 };
 
 /* ftrace_enabled is a method to turn ftrace on or off */
@@ -140,7 +142,8 @@ static inline void ftrace_ops_init(struct ftrace_ops *ops)
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
 	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED)) {
-		mutex_init(&ops->regex_lock);
+		mutex_init(&ops->local_hash.regex_lock);
+		ops->func_hash = &ops->local_hash;
 		ops->flags |= FTRACE_OPS_FL_INITIALIZED;
 	}
 #endif
@@ -899,7 +902,7 @@ static void unregister_ftrace_profiler(void)
 static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
 	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
-	INIT_REGEX_LOCK(ftrace_profile_ops)
+	INIT_OPS_HASH(ftrace_profile_ops)
 };
 
 static int register_ftrace_profiler(void)
@@ -1081,11 +1084,12 @@ static const struct ftrace_hash empty_hash = {
 #define EMPTY_HASH	((struct ftrace_hash *)&empty_hash)
 
 static struct ftrace_ops global_ops = {
-	.func			= ftrace_stub,
-	.notrace_hash		= EMPTY_HASH,
-	.filter_hash		= EMPTY_HASH,
-	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
-	INIT_REGEX_LOCK(global_ops)
+	.func				= ftrace_stub,
+	.local_hash.notrace_hash	= EMPTY_HASH,
+	.local_hash.filter_hash		= EMPTY_HASH,
+	INIT_OPS_HASH(global_ops)
+	.flags				= FTRACE_OPS_FL_RECURSION_SAFE |
+					  FTRACE_OPS_FL_INITIALIZED,
 };
 
 struct ftrace_page {
@@ -1226,8 +1230,8 @@ static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
 void ftrace_free_filter(struct ftrace_ops *ops)
 {
 	ftrace_ops_init(ops);
-	free_ftrace_hash(ops->filter_hash);
-	free_ftrace_hash(ops->notrace_hash);
+	free_ftrace_hash(ops->func_hash->filter_hash);
+	free_ftrace_hash(ops->func_hash->notrace_hash);
 }
 
 static struct ftrace_hash *alloc_ftrace_hash(int size_bits)
@@ -1382,8 +1386,8 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 		return 0;
 #endif
 
-	filter_hash = rcu_dereference_raw_notrace(ops->filter_hash);
-	notrace_hash = rcu_dereference_raw_notrace(ops->notrace_hash);
+	filter_hash = rcu_dereference_raw_notrace(ops->func_hash->filter_hash);
+	notrace_hash = rcu_dereference_raw_notrace(ops->func_hash->notrace_hash);
 
 	if ((ftrace_hash_empty(filter_hash) ||
 	     ftrace_lookup_ip(filter_hash, ip)) &&
@@ -1554,14 +1558,14 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 	 *   gets inversed.
 	 */
 	if (filter_hash) {
-		hash = ops->filter_hash;
-		other_hash = ops->notrace_hash;
+		hash = ops->func_hash->filter_hash;
+		other_hash = ops->func_hash->notrace_hash;
 		if (ftrace_hash_empty(hash))
 			all = 1;
 	} else {
 		inc = !inc;
-		hash = ops->notrace_hash;
-		other_hash = ops->filter_hash;
+		hash = ops->func_hash->notrace_hash;
+		other_hash = ops->func_hash->filter_hash;
 		/*
 		 * If the notrace hash has no items,
 		 * then there's nothing to do.
@@ -2436,8 +2440,8 @@ static inline int ops_traces_mod(struct ftrace_ops *ops)
 	 * Filter_hash being empty will default to trace module.
 	 * But notrace hash requires a test of individual module functions.
 	 */
-	return ftrace_hash_empty(ops->filter_hash) &&
-		ftrace_hash_empty(ops->notrace_hash);
+	return ftrace_hash_empty(ops->func_hash->filter_hash) &&
+		ftrace_hash_empty(ops->func_hash->notrace_hash);
 }
 
 /*
@@ -2459,12 +2463,12 @@ ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
 		return 0;
 
 	/* The function must be in the filter */
-	if (!ftrace_hash_empty(ops->filter_hash) &&
-	    !ftrace_lookup_ip(ops->filter_hash, rec->ip))
+	if (!ftrace_hash_empty(ops->func_hash->filter_hash) &&
+	    !ftrace_lookup_ip(ops->func_hash->filter_hash, rec->ip))
 		return 0;
 
 	/* If in notrace hash, we ignore it too */
-	if (ftrace_lookup_ip(ops->notrace_hash, rec->ip))
+	if (ftrace_lookup_ip(ops->func_hash->notrace_hash, rec->ip))
 		return 0;
 
 	return 1;
@@ -2785,10 +2789,10 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	} else {
 		rec = &iter->pg->records[iter->idx++];
 		if (((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(ftrace_lookup_ip(ops->filter_hash, rec->ip))) ||
+		     !(ftrace_lookup_ip(ops->func_hash->filter_hash, rec->ip))) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
-		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
+		     !ftrace_lookup_ip(ops->func_hash->notrace_hash, rec->ip)) ||
 
 		    ((iter->flags & FTRACE_ITER_ENABLED) &&
 		     !(rec->flags & FTRACE_FL_ENABLED))) {
@@ -2837,9 +2841,9 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 * functions are enabled.
 	 */
 	if ((iter->flags & FTRACE_ITER_FILTER &&
-	     ftrace_hash_empty(ops->filter_hash)) ||
+	     ftrace_hash_empty(ops->func_hash->filter_hash)) ||
 	    (iter->flags & FTRACE_ITER_NOTRACE &&
-	     ftrace_hash_empty(ops->notrace_hash))) {
+	     ftrace_hash_empty(ops->func_hash->notrace_hash))) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
@@ -3001,12 +3005,12 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 	iter->ops = ops;
 	iter->flags = flag;
 
-	mutex_lock(&ops->regex_lock);
+	mutex_lock(&ops->func_hash->regex_lock);
 
 	if (flag & FTRACE_ITER_NOTRACE)
-		hash = ops->notrace_hash;
+		hash = ops->func_hash->notrace_hash;
 	else
-		hash = ops->filter_hash;
+		hash = ops->func_hash->filter_hash;
 
 	if (file->f_mode & FMODE_WRITE) {
 		const int size_bits = FTRACE_HASH_DEFAULT_BITS;
@@ -3041,7 +3045,7 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		file->private_data = iter;
 
  out_unlock:
-	mutex_unlock(&ops->regex_lock);
+	mutex_unlock(&ops->func_hash->regex_lock);
 
 	return ret;
 }
@@ -3279,7 +3283,7 @@ static struct ftrace_ops trace_probe_ops __read_mostly =
 {
 	.func		= function_trace_probe_call,
 	.flags		= FTRACE_OPS_FL_INITIALIZED,
-	INIT_REGEX_LOCK(trace_probe_ops)
+	INIT_OPS_HASH(trace_probe_ops)
 };
 
 static int ftrace_probe_registered;
@@ -3342,7 +3346,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			      void *data)
 {
 	struct ftrace_func_probe *entry;
-	struct ftrace_hash **orig_hash = &trace_probe_ops.filter_hash;
+	struct ftrace_hash **orig_hash = &trace_probe_ops.func_hash->filter_hash;
 	struct ftrace_hash *hash;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
@@ -3359,7 +3363,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	if (WARN_ON(not))
 		return -EINVAL;
 
-	mutex_lock(&trace_probe_ops.regex_lock);
+	mutex_lock(&trace_probe_ops.func_hash->regex_lock);
 
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
 	if (!hash) {
@@ -3428,7 +3432,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
  out_unlock:
 	mutex_unlock(&ftrace_lock);
  out:
-	mutex_unlock(&trace_probe_ops.regex_lock);
+	mutex_unlock(&trace_probe_ops.func_hash->regex_lock);
 	free_ftrace_hash(hash);
 
 	return count;
@@ -3446,7 +3450,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	struct ftrace_func_entry *rec_entry;
 	struct ftrace_func_probe *entry;
 	struct ftrace_func_probe *p;
-	struct ftrace_hash **orig_hash = &trace_probe_ops.filter_hash;
+	struct ftrace_hash **orig_hash = &trace_probe_ops.func_hash->filter_hash;
 	struct list_head free_list;
 	struct ftrace_hash *hash;
 	struct hlist_node *tmp;
@@ -3468,7 +3472,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			return;
 	}
 
-	mutex_lock(&trace_probe_ops.regex_lock);
+	mutex_lock(&trace_probe_ops.func_hash->regex_lock);
 
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
 	if (!hash)
@@ -3521,7 +3525,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	mutex_unlock(&ftrace_lock);
 		
  out_unlock:
-	mutex_unlock(&trace_probe_ops.regex_lock);
+	mutex_unlock(&trace_probe_ops.func_hash->regex_lock);
 	free_ftrace_hash(hash);
 }
 
@@ -3717,12 +3721,12 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
-	mutex_lock(&ops->regex_lock);
+	mutex_lock(&ops->func_hash->regex_lock);
 
 	if (enable)
-		orig_hash = &ops->filter_hash;
+		orig_hash = &ops->func_hash->filter_hash;
 	else
-		orig_hash = &ops->notrace_hash;
+		orig_hash = &ops->func_hash->notrace_hash;
 
 	if (reset)
 		hash = alloc_ftrace_hash(FTRACE_HASH_DEFAULT_BITS);
@@ -3752,7 +3756,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	mutex_unlock(&ftrace_lock);
 
  out_regex_unlock:
-	mutex_unlock(&ops->regex_lock);
+	mutex_unlock(&ops->func_hash->regex_lock);
 
 	free_ftrace_hash(hash);
 	return ret;
@@ -3975,15 +3979,15 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 	trace_parser_put(parser);
 
-	mutex_lock(&iter->ops->regex_lock);
+	mutex_lock(&iter->ops->func_hash->regex_lock);
 
 	if (file->f_mode & FMODE_WRITE) {
 		filter_hash = !!(iter->flags & FTRACE_ITER_FILTER);
 
 		if (filter_hash)
-			orig_hash = &iter->ops->filter_hash;
+			orig_hash = &iter->ops->func_hash->filter_hash;
 		else
-			orig_hash = &iter->ops->notrace_hash;
+			orig_hash = &iter->ops->func_hash->notrace_hash;
 
 		mutex_lock(&ftrace_lock);
 		ret = ftrace_hash_move(iter->ops, filter_hash,
@@ -3994,7 +3998,7 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 		mutex_unlock(&ftrace_lock);
 	}
 
-	mutex_unlock(&iter->ops->regex_lock);
+	mutex_unlock(&iter->ops->func_hash->regex_lock);
 	free_ftrace_hash(iter->hash);
 	kfree(iter);
 
@@ -4611,7 +4615,7 @@ void __init ftrace_init(void)
 static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
-	INIT_REGEX_LOCK(global_ops)
+	INIT_OPS_HASH(global_ops)
 };
 
 static int __init ftrace_nodyn_init(void)
@@ -4713,7 +4717,7 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 static struct ftrace_ops control_ops = {
 	.func	= ftrace_ops_control_func,
 	.flags	= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
-	INIT_REGEX_LOCK(control_ops)
+	INIT_OPS_HASH(control_ops)
 };
 
 static inline void
-- 
2.0.1


