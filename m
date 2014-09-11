Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaIKOwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:52:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:41665 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752969AbaIKOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:49:10 -0400
Message-Id: <20140911144908.515250660@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 11 Sep 2014 10:47:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 6/9] ftrace: Annotate the ops operation on update
References: <20140911144744.907770249@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0006-ftrace-Annotate-the-ops-operation-on-update.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add three new flags for ftrace_ops:

  FTRACE_OPS_FL_ADDING
  FTRACE_OPS_FL_REMOVING
  FTRACE_OPS_FL_MODIFYING

These will be set for the ftrace_ops when they are first added
to the function tracing, being removed from function tracing
or just having their functions changed from function tracing,
respectively.

This will be needed to remove the tramp_hash, which can grow quite
big. The tramp_hash is used to note what functions a ftrace_ops
is using a trampoline for. Denoting which ftrace_ops is being
modified, will allow us to use the ftrace_ops hashes themselves,
which are much smaller as they have a global flag to denote if
a ftrace_ops is tracing all functions, as well as a notrace hash
if the ftrace_ops is tracing all but a few. The tramp_hash just
creates a hash item for every function, which can go into the 10s
of thousands if all functions are using the ftrace_ops trampoline.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |  6 ++++++
 kernel/trace/ftrace.c  | 45 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ef37286547fc..d9216f6385d9 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -91,6 +91,9 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
  * DELETED - The ops are being deleted, do not let them be registered again.
+ * ADDING  - The ops is in the process of being added.
+ * REMOVING - The ops is in the process of being removed.
+ * MODIFYING - The ops is in the process of changing its filter functions.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -102,6 +105,9 @@ enum {
 	FTRACE_OPS_FL_STUB			= 1 << 6,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 7,
 	FTRACE_OPS_FL_DELETED			= 1 << 8,
+	FTRACE_OPS_FL_ADDING			= 1 << 9,
+	FTRACE_OPS_FL_REMOVING			= 1 << 10,
+	FTRACE_OPS_FL_MODIFYING			= 1 << 11,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 858ac16f8492..e43c793093e5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1057,6 +1057,12 @@ static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 static struct ftrace_ops *removed_ops;
 
+/*
+ * Set when doing a global update, like enabling all recs or disabling them.
+ * It is not set when just updating a single ftrace_ops.
+ */
+static bool update_all_ops;
+
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
 # error Dynamic ftrace depends on MCOUNT_RECORD
 #endif
@@ -2366,6 +2372,13 @@ static void ftrace_run_update_code(int command)
 	FTRACE_WARN_ON(ret);
 }
 
+static void ftrace_run_modify_code(struct ftrace_ops *ops, int command)
+{
+	ops->flags |= FTRACE_OPS_FL_MODIFYING;
+	ftrace_run_update_code(command);
+	ops->flags &= ~FTRACE_OPS_FL_MODIFYING;
+}
+
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
 
@@ -2387,6 +2400,13 @@ static void ftrace_startup_enable(int command)
 	ftrace_run_update_code(command);
 }
 
+static void ftrace_startup_all(int command)
+{
+	update_all_ops = true;
+	ftrace_startup_enable(command);
+	update_all_ops = false;
+}
+
 static int ftrace_startup(struct ftrace_ops *ops, int command)
 {
 	int ret;
@@ -2401,12 +2421,22 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 	ftrace_start_up++;
 	command |= FTRACE_UPDATE_CALLS;
 
-	ops->flags |= FTRACE_OPS_FL_ENABLED;
+	/*
+	 * Note that ftrace probes uses this to start up
+	 * and modify functions it will probe. But we still
+	 * set the ADDING flag for modification, as probes
+	 * do not have trampolines. If they add them in the
+	 * future, then the probes will need to distinguish
+	 * between adding and updating probes.
+	 */
+	ops->flags |= FTRACE_OPS_FL_ENABLED | FTRACE_OPS_FL_ADDING;
 
 	ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
 
+	ops->flags &= ~FTRACE_OPS_FL_ADDING;
+
 	return 0;
 }
 
@@ -2456,11 +2486,12 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 * If the ops uses a trampoline, then it needs to be
 	 * tested first on update.
 	 */
+	ops->flags |= FTRACE_OPS_FL_REMOVING;
 	removed_ops = ops;
 
 	ftrace_run_update_code(command);
 
-	removed_ops = NULL;
+	ops->flags &= ~FTRACE_OPS_FL_REMOVING;
 
 	/*
 	 * Dynamic ops may be freed, we must make sure that all
@@ -3373,7 +3404,7 @@ static void __enable_ftrace_function_probe(void)
 	if (ftrace_probe_registered) {
 		/* still need to update the function call sites */
 		if (ftrace_enabled)
-			ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+			ftrace_run_modify_code(&trace_probe_ops, FTRACE_UPDATE_CALLS);
 		return;
 	}
 
@@ -3792,7 +3823,7 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 static void ftrace_ops_update_code(struct ftrace_ops *ops)
 {
 	if (ops->flags & FTRACE_OPS_FL_ENABLED && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+		ftrace_run_modify_code(ops, FTRACE_UPDATE_CALLS);
 }
 
 static int
@@ -4717,6 +4748,7 @@ core_initcall(ftrace_nodyn_init);
 
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
+static inline void ftrace_startup_all(int command) { }
 /* Keep as macros so we do not need to define the commands */
 # define ftrace_startup(ops, command)					\
 	({								\
@@ -5016,7 +5048,8 @@ static int ftrace_pid_add(int p)
 	set_ftrace_pid_task(pid);
 
 	ftrace_update_pid_func();
-	ftrace_startup_enable(0);
+
+	ftrace_startup_all(0);
 
 	mutex_unlock(&ftrace_lock);
 	return 0;
@@ -5045,7 +5078,7 @@ static void ftrace_pid_reset(void)
 	}
 
 	ftrace_update_pid_func();
-	ftrace_startup_enable(0);
+	ftrace_startup_all(0);
 
 	mutex_unlock(&ftrace_lock);
 }
-- 
2.0.1


