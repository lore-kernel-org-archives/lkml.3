Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaDTPMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 11:12:10 -0400
Received: from mx.insigma.com.cn ([115.236.48.170]:45771 "EHLO
	WX-Ex2010Edge01.insigma.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755461AbaDTPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 11:11:45 -0400
From: Jiaxing Wang <wangjiaxing@insigma.com.cn>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Jiaxing Wang <wangjiaxing@insigma.com.cn>
Subject: [PATCH 1/2] tracing/trace_stack:Skip 4 instead of 3 when using ftrace_ops_list_func
Date: Sun, 20 Apr 2014 23:10:43 +0800
Message-ID: <1398006644-5935-2-git-send-email-wangjiaxing@insigma.com.cn>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398006644-5935-1-git-send-email-wangjiaxing@insigma.com.cn>
References: <1398006644-5935-1-git-send-email-wangjiaxing@insigma.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [120.40.72.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Jiaxing Wang <wangjiaxing@insigma.com.cn>
---
 kernel/trace/ftrace.c      | 5 +++++
 kernel/trace/trace.h       | 1 +
 kernel/trace/trace_stack.c | 8 ++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1fd4b94..e7e7302 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -373,6 +373,11 @@ static void update_ftrace_function(void)
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
index ffc314b..920c0a5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -822,6 +822,7 @@ extern int ftrace_is_dead(void);
 int ftrace_create_function_files(struct trace_array *tr,
 				 struct dentry *parent);
 void ftrace_destroy_function_files(struct trace_array *tr);
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
1.8.3.2

