Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab3K0Bkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:40:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:6392 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759548Ab3K0Bjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:39:54 -0500
Message-Id: <20131127013950.698477318@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Nov 2013 20:38:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>
Subject: [PATCH 2/2] ftrace: Fix function graph with loading of modules
References: <20131127013841.321519823@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Fix-function-graph-with-loading-of-modules.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 8c4f3c3fa9681 "ftrace: Check module functions being traced on reload"
fixed module loading and unloading with respect to function tracing, but
it missed the function graph tracer. If you perform the following

 # cd /sys/kernel/debug/tracing
 # echo function_graph > current_tracer
 # modprobe nfsd
 # echo nop > current_tracer

You'll get the following oops message:

 ------------[ cut here ]------------
 WARNING: CPU: 2 PID: 2910 at /linux.git/kernel/trace/ftrace.c:1640 __ftrace_hash_rec_update.part.35+0x168/0x1b9()
 Modules linked in: nfsd exportfs nfs_acl lockd ipt_MASQUERADE sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables uinput snd_hda_codec_idt
 CPU: 2 PID: 2910 Comm: bash Not tainted 3.13.0-rc1-test #7
 Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
  0000000000000668 ffff8800787efcf8 ffffffff814fe193 ffff88007d500000
  0000000000000000 ffff8800787efd38 ffffffff8103b80a 0000000000000668
  ffffffff810b2b9a ffffffff81a48370 0000000000000001 ffff880037aea000
 Call Trace:
  [<ffffffff814fe193>] dump_stack+0x4f/0x7c
  [<ffffffff8103b80a>] warn_slowpath_common+0x81/0x9b
  [<ffffffff810b2b9a>] ? __ftrace_hash_rec_update.part.35+0x168/0x1b9
  [<ffffffff8103b83e>] warn_slowpath_null+0x1a/0x1c
  [<ffffffff810b2b9a>] __ftrace_hash_rec_update.part.35+0x168/0x1b9
  [<ffffffff81502f89>] ? __mutex_lock_slowpath+0x364/0x364
  [<ffffffff810b2cc2>] ftrace_shutdown+0xd7/0x12b
  [<ffffffff810b47f0>] unregister_ftrace_graph+0x49/0x78
  [<ffffffff810c4b30>] graph_trace_reset+0xe/0x10
  [<ffffffff810bf393>] tracing_set_tracer+0xa7/0x26a
  [<ffffffff810bf5e1>] tracing_set_trace_write+0x8b/0xbd
  [<ffffffff810c501c>] ? ftrace_return_to_handler+0xb2/0xde
  [<ffffffff811240a8>] ? __sb_end_write+0x5e/0x5e
  [<ffffffff81122aed>] vfs_write+0xab/0xf6
  [<ffffffff8150a185>] ftrace_graph_caller+0x85/0x85
  [<ffffffff81122dbd>] SyS_write+0x59/0x82
  [<ffffffff8150a185>] ftrace_graph_caller+0x85/0x85
  [<ffffffff8150a2d2>] system_call_fastpath+0x16/0x1b
 ---[ end trace 940358030751eafb ]---

The above mentioned commit didn't go far enough. Well, it covered the
function tracer by adding checks in __register_ftrace_function(). The
problem is that the function graph tracer circumvents that (for a slight
efficiency gain when function graph trace is running with a function
tracer. The gain was not worth this).

The problem came with ftrace_startup() which should always be called after
__register_ftrace_function(), if you want this bug to be completely fixed.

Anyway, this solution moves __register_ftrace_function() inside of
ftrace_startup() and removes the need to call them both.

Reported-by: Dave Wysochanski <dwysocha@redhat.com>
Fixes: ed926f9b35cd ("ftrace: Use counters to enable functions to trace")
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 64 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 22fa556..0e9f9ea 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -367,9 +367,6 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
-
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
@@ -428,9 +425,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
 
-	if (ftrace_disabled)
-		return -ENODEV;
-
 	if (WARN_ON(!(ops->flags & FTRACE_OPS_FL_ENABLED)))
 		return -EBUSY;
 
@@ -2088,10 +2082,15 @@ static void ftrace_startup_enable(int command)
 static int ftrace_startup(struct ftrace_ops *ops, int command)
 {
 	bool hash_enable = true;
+	int ret;
 
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
+	ret = __register_ftrace_function(ops);
+	if (ret)
+		return ret;
+
 	ftrace_start_up++;
 	command |= FTRACE_UPDATE_CALLS;
 
@@ -2113,12 +2112,17 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 	return 0;
 }
 
-static void ftrace_shutdown(struct ftrace_ops *ops, int command)
+static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 {
 	bool hash_disable = true;
+	int ret;
 
 	if (unlikely(ftrace_disabled))
-		return;
+		return -ENODEV;
+
+	ret = __unregister_ftrace_function(ops);
+	if (ret)
+		return ret;
 
 	ftrace_start_up--;
 	/*
@@ -2153,9 +2157,10 @@ static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 	}
 
 	if (!command || !ftrace_enabled)
-		return;
+		return 0;
 
 	ftrace_run_update_code(command);
+	return 0;
 }
 
 static void ftrace_startup_sysctl(void)
@@ -3060,16 +3065,13 @@ static void __enable_ftrace_function_probe(void)
 	if (i == FTRACE_FUNC_HASHSIZE)
 		return;
 
-	ret = __register_ftrace_function(&trace_probe_ops);
-	if (!ret)
-		ret = ftrace_startup(&trace_probe_ops, 0);
+	ret = ftrace_startup(&trace_probe_ops, 0);
 
 	ftrace_probe_registered = 1;
 }
 
 static void __disable_ftrace_function_probe(void)
 {
-	int ret;
 	int i;
 
 	if (!ftrace_probe_registered)
@@ -3082,9 +3084,7 @@ static void __disable_ftrace_function_probe(void)
 	}
 
 	/* no more funcs left */
-	ret = __unregister_ftrace_function(&trace_probe_ops);
-	if (!ret)
-		ftrace_shutdown(&trace_probe_ops, 0);
+	ftrace_shutdown(&trace_probe_ops, 0);
 
 	ftrace_probe_registered = 0;
 }
@@ -4366,12 +4366,15 @@ core_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
-# define ftrace_startup(ops, command)			\
-	({						\
-		(ops)->flags |= FTRACE_OPS_FL_ENABLED;	\
-		0;					\
+# define ftrace_startup(ops, command)					\
+	({								\
+		int ___ret = __register_ftrace_function(ops);		\
+		if (!___ret)						\
+			(ops)->flags |= FTRACE_OPS_FL_ENABLED;		\
+		___ret;							\
 	})
-# define ftrace_shutdown(ops, command)	do { } while (0)
+# define ftrace_shutdown(ops, command) __unregister_ftrace_function(ops)
+
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
 
@@ -4780,9 +4783,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 
-	ret = __register_ftrace_function(ops);
-	if (!ret)
-		ret = ftrace_startup(ops, 0);
+	ret = ftrace_startup(ops, 0);
 
 	mutex_unlock(&ftrace_lock);
 
@@ -4801,9 +4802,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 	int ret;
 
 	mutex_lock(&ftrace_lock);
-	ret = __unregister_ftrace_function(ops);
-	if (!ret)
-		ftrace_shutdown(ops, 0);
+	ret = ftrace_shutdown(ops, 0);
 	mutex_unlock(&ftrace_lock);
 
 	return ret;
@@ -4997,6 +4996,13 @@ ftrace_suspend_notifier_call(struct notifier_block *bl, unsigned long state,
 	return NOTIFY_DONE;
 }
 
+/* Just a place holder for function graph */
+static struct ftrace_ops fgraph_ops __read_mostly = {
+	.func		= ftrace_stub,
+	.flags		= FTRACE_OPS_FL_STUB | FTRACE_OPS_FL_GLOBAL |
+				FTRACE_OPS_FL_RECURSION_SAFE,
+};
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -5023,7 +5029,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
-	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
+	ret = ftrace_startup(&fgraph_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -5040,7 +5046,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
-	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
+	ftrace_shutdown(&fgraph_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
-- 
1.8.4.rc3


