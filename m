Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbaD3Mm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:42:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:45406 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758836AbaD3Mmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:42:33 -0400
Message-Id: <20140430124231.012679704@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 08:41:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiaxing Wang <wangjiaxing@insigma.com.cn>
Subject: [for-next][PATCH 1/4] tracing/stack_trace: Skip 4 instead of 3 when using
 ftrace_ops_list_func
References: <20140430124153.334527053@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-stack_trace-Skip-4-instead-of-3-when-using-f.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiaxing Wang <wangjiaxing@insigma.com.cn>

When using ftrace_ops_list_func, we should skip 4 instead of 3,
to avoid ftrace_call+0x5/0xb appearing in the stack trace:

        Depth    Size   Location    (110 entries)
        -----    ----   --------
  0)     2956       0   update_curr+0xe/0x1e0
  1)     2956      68   ftrace_call+0x5/0xb
  2)     2888      92   enqueue_entity+0x53/0xe80
  3)     2796      80   enqueue_task_fair+0x47/0x7e0
  4)     2716      28   enqueue_task+0x45/0x70
  5)     2688      12   activate_task+0x22/0x30

Add a function using_ftrace_ops_list_func() to test for this while keeping
ftrace_ops_list_func to remain static.

Link: http://lkml.kernel.org/p/1398006644-5935-2-git-send-email-wangjiaxing@insigma.com.cn

Signed-off-by: Jiaxing Wang <wangjiaxing@insigma.com.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c      | 5 +++++
 kernel/trace/trace.h       | 1 +
 kernel/trace/trace_stack.c | 8 ++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 846888e..3cfeb66 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -313,6 +313,11 @@ static void update_ftrace_function(void)
 	ftrace_trace_function = func;
 }
 
+int using_ftrace_ops_list_func(void)
+{
+	return ftrace_trace_function == ftrace_ops_list_func;
+}
+
 static void add_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 {
 	ops->next = *list;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5d2f07d..8624b50 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -830,6 +830,7 @@ void ftrace_destroy_function_files(struct trace_array *tr);
 void ftrace_init_global_array_ops(struct trace_array *tr);
 void ftrace_init_array_ops(struct trace_array *tr, ftrace_func_t func);
 void ftrace_reset_array_ops(struct trace_array *tr);
+int using_ftrace_ops_list_func(void);
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 21b320e..5aa9a5b 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -85,8 +85,12 @@ check_stack(unsigned long ip, unsigned long *stack)
 
 	max_stack_size = this_size;
 
-	max_stack_trace.nr_entries	= 0;
-	max_stack_trace.skip		= 3;
+	max_stack_trace.nr_entries = 0;
+
+	if (using_ftrace_ops_list_func())
+		max_stack_trace.skip = 4;
+	else
+		max_stack_trace.skip = 3;
 
 	save_stack_trace(&max_stack_trace);
 
-- 
1.8.5.3


