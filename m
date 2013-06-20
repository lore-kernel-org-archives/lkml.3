Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377Ab3FTSbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:31:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:55235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161044Ab3FTSbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:31:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,906,1363158000"; 
   d="scan'208";a="320172479"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 03/11] tracing: add soft disable for syscall events
Date: Thu, 20 Jun 2013 13:31:27 -0500
Message-Id: <dd9d5f3d3781d1074bf554a473d49648dc79b359.1371751701.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for SOFT_DISABLE to syscall events.

The original SOFT_DISABLE patches didn't add support for soft disable
of syscall events; this adds it and paves the way for future patches
allowing triggers to be added to syscall events, since triggers are
built on top of SOFT_DISABLE.

Because the trigger and SOFT_DISABLE bits are attached to the
ftrace_event_file associated with the event, pointers to the
ftrace_event_files associated with the event are added to the syscall
metadata entry for the event.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/syscalls.h      |  2 ++
 include/trace/syscall.h       |  5 +++++
 kernel/trace/trace_syscalls.c | 28 ++++++++++++++++++++++++----
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4147d70..b4c2afa 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -158,6 +158,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.args		= nb ? args_##sname : NULL,	\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
+		.enter_file	= NULL,	/* Filled in at boot */	\
+		.exit_file	= NULL,	/* Filled in at boot */	\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
 	};							\
 	static struct syscall_metadata __used			\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index fed853f..ba24d3a 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -19,6 +19,8 @@
  * @enter_fields: list of fields for syscall_enter trace event
  * @enter_event: associated syscall_enter trace event
  * @exit_event: associated syscall_exit trace event
+ * @enter_file: associated syscall_enter ftrace event file
+ * @exit_file: associated syscall_exit ftrace event file
  */
 struct syscall_metadata {
 	const char	*name;
@@ -30,6 +32,9 @@ struct syscall_metadata {
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
+
+	struct ftrace_event_file *enter_file;
+	struct ftrace_event_file *exit_file;
 };
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..1d81881 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -319,6 +319,10 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!sys_data)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+		     &sys_data->enter_file->flags))
+		return;
+
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	buffer = tr->trace_buffer.buffer;
@@ -355,6 +359,10 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+		     &sys_data->exit_file->flags))
+		return;
+
 	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
 			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
@@ -374,10 +382,12 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
 				   struct ftrace_event_call *call)
 {
 	struct trace_array *tr = file->tr;
+	struct syscall_metadata *meta;
 	int ret = 0;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	meta = (struct syscall_metadata *)call->data;
+	num = meta->syscall_nr;
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
@@ -386,6 +396,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
 	if (!ret) {
 		set_bit(num, tr->enabled_enter_syscalls);
 		tr->sys_refcount_enter++;
+		meta->enter_file = file;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
@@ -395,14 +406,17 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
 				      struct ftrace_event_call *call)
 {
 	struct trace_array *tr = file->tr;
+	struct syscall_metadata *meta;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	meta = (struct syscall_metadata *)call->data;
+	num = meta->syscall_nr;
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
 	clear_bit(num, tr->enabled_enter_syscalls);
+	meta->enter_file = NULL;
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -412,10 +426,12 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
 				  struct ftrace_event_call *call)
 {
 	struct trace_array *tr = file->tr;
+	struct syscall_metadata *meta;
 	int ret = 0;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	meta = (struct syscall_metadata *)call->data;
+	num = meta->syscall_nr;
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
@@ -424,6 +440,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
 	if (!ret) {
 		set_bit(num, tr->enabled_exit_syscalls);
 		tr->sys_refcount_exit++;
+		meta->exit_file = file;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
@@ -433,14 +450,17 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 				     struct ftrace_event_call *call)
 {
 	struct trace_array *tr = file->tr;
+	struct syscall_metadata *meta;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	meta = (struct syscall_metadata *)call->data;
+	num = meta->syscall_nr;
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
 	clear_bit(num, tr->enabled_exit_syscalls);
+	meta->exit_file = NULL;
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
-- 
1.7.11.4

