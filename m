Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaAFToa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:44:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:41121 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbaAFTo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:44:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="454422158"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 2/2] tracing: Remove double-underscore naming in syscall trigger invocations
Date: Mon,  6 Jan 2014 13:44:20 -0600
Message-Id: <0b489c9d1f7ee315cff60fa0e4c2b433ade8ae0d.1389036657.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1389036657.git.tom.zanussi@linux.intel.com>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1389036657.git.tom.zanussi@linux.intel.com>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to use double-underscores for any variable name in
ftrace_syscall_enter()/exit(), since those functions aren't generated
and there's no need to avoid namespace collisions as with the event
macros, which is where the original invocation code came from.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace_syscalls.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index fdd955f..a4acf9b 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -306,7 +306,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
-	enum event_trigger_type __tt = ETT_NONE;
+	enum event_trigger_type tt = ETT_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
 	unsigned long eflags;
@@ -352,15 +352,15 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
 	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
-		__tt = event_triggers_call(ftrace_file, entry);
+		tt = event_triggers_call(ftrace_file, entry);
 
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		ring_buffer_discard_commit(buffer, event);
 	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
-	if (__tt)
-		event_triggers_post_call(ftrace_file, __tt);
+	if (tt)
+		event_triggers_post_call(ftrace_file, tt);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -370,7 +370,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
-	enum event_trigger_type __tt = ETT_NONE;
+	enum event_trigger_type tt = ETT_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
 	unsigned long eflags;
@@ -414,15 +414,15 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->ret = syscall_get_return_value(current, regs);
 
 	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
-		__tt = event_triggers_call(ftrace_file, entry);
+		tt = event_triggers_call(ftrace_file, entry);
 
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		ring_buffer_discard_commit(buffer, event);
 	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_current_buffer_unlock_commit(buffer, event,
 						   irq_flags, pc);
-	if (__tt)
-		event_triggers_post_call(ftrace_file, __tt);
+	if (tt)
+		event_triggers_post_call(ftrace_file, tt);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
-- 
1.8.3.1

