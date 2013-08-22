Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3HVT7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:59:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:45279 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab3HVT6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:58:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="350324421"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v5 10/10] tracing: make register/unregister_ftrace_command __init
Date: Thu, 22 Aug 2013 14:57:43 -0500
Message-Id: <5acaec50787eeddda7090631e542f37c4e952301.1377183739.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register/unregister_ftrace_command() are only ever called from __init
functions, so can themselves be made __init.

Also make register_snapshot_cmd() __init for the same reason.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace.h |  4 ++--
 kernel/trace/ftrace.c  | 12 ++++++++++--
 kernel/trace/trace.c   |  4 ++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9f15c00..6062491 100644
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
index a6d098c..64f7f39 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3292,7 +3292,11 @@ void unregister_ftrace_function_probe_all(char *glob)
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
@@ -3311,7 +3315,11 @@ int register_ftrace_command(struct ftrace_func_command *cmd)
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
index 2aabd34..4222c6a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5458,12 +5458,12 @@ static struct ftrace_func_command ftrace_snapshot_cmd = {
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
1.7.11.4

