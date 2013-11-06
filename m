Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3KFOyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:54:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34091 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932509Ab3KFOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:53:00 -0500
Message-Id: <20131106145258.088636095@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 7/8] tracing: Make register/unregister_ftrace_command __init
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Make-register-unregister_ftrace_command-__in.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

register/unregister_ftrace_command() are only ever called from __init
functions, so can themselves be made __init.

Also make register_snapshot_cmd() __init for the same reason.

Link: http://lkml.kernel.org/r/d4042c8cadb7ae6f843ac9a89a24e1c6a3099727.1382620672.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |  4 ++--
 kernel/trace/ftrace.c  | 12 ++++++++++--
 kernel/trace/trace.c   |  4 ++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ec85d48..31ea4b4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -533,11 +533,11 @@ static inline int ftrace_force_update(void) { return 0; }
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
-static inline int register_ftrace_command(struct ftrace_func_command *cmd)
+static inline __init int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
 }
-static inline int unregister_ftrace_command(char *cmd_name)
+static inline __init int unregister_ftrace_command(char *cmd_name)
 {
 	return -EINVAL;
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 080b7d4..22fa556 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3307,7 +3307,11 @@ void unregister_ftrace_function_probe_all(char *glob)
 static LIST_HEAD(ftrace_commands);
 static DEFINE_MUTEX(ftrace_cmd_mutex);
 
-int register_ftrace_command(struct ftrace_func_command *cmd)
+/*
+ * Currently we only register ftrace commands from __init, so mark this
+ * __init too.
+ */
+__init int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	struct ftrace_func_command *p;
 	int ret = 0;
@@ -3326,7 +3330,11 @@ int register_ftrace_command(struct ftrace_func_command *cmd)
 	return ret;
 }
 
-int unregister_ftrace_command(struct ftrace_func_command *cmd)
+/*
+ * Currently we only unregister ftrace commands from __init, so mark
+ * this __init too.
+ */
+__init int unregister_ftrace_command(struct ftrace_func_command *cmd)
 {
 	struct ftrace_func_command *p, *n;
 	int ret = -ENODEV;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 489da8b..f9fa42b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5477,12 +5477,12 @@ static struct ftrace_func_command ftrace_snapshot_cmd = {
 	.func			= ftrace_trace_snapshot_callback,
 };
 
-static int register_snapshot_cmd(void)
+static __init int register_snapshot_cmd(void)
 {
 	return register_ftrace_command(&ftrace_snapshot_cmd);
 }
 #else
-static inline int register_snapshot_cmd(void) { return 0; }
+static inline __init int register_snapshot_cmd(void) { return 0; }
 #endif /* defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE) */
 
 struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
-- 
1.8.4.rc3


