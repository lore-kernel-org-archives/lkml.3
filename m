Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaFEWfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:35:23 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47769 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaFEWfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:35:20 -0400
X-AuditID: 85900ec0-d312bb9000001514-ce-5390f0a6753d
Subject: [PATCH ftrace/core 1/3] trace/event: Return error if
 ftrace_trace_arrays is empty list
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Fri, 06 Jun 2014 07:35:17 +0900
Message-ID: <20140605223517.32311.99233.stgit@yunodevel>
In-Reply-To: <20140605223515.32311.71203.stgit@yunodevel>
References: <20140605223515.32311.71203.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_trace_arrays links global_trace.list. However, global_trace is not added
to ftrace_trace_arrays if trace_alloc_buffers() failed. As the result,
ftrace_trace_arrays becomes empty list. If ftrace_trace_arrays is empty list,
current top_trace_array() returns invalid pointer. As the result, the kernel
can induce memory corruption or panic.

Current implementation does not check whether ftrace_trace_arrays is empty
list or not. So, in this patch, if ftrace_trace_arrays is empty list,
top_trace_array() returns NULL. Moreover, this patch makes all functions calling
top_trace_array() handle it appropriately.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.h        |    3 +++
 kernel/trace/trace_events.c |   13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 217207a..9e82551 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -252,6 +252,9 @@ static inline struct trace_array *top_trace_array(void)
 {
 	struct trace_array *tr;
 
+	if (list_empty(ftrace_trace_arrays.prev))
+		return NULL;
+
 	tr = list_entry(ftrace_trace_arrays.prev,
 			typeof(*tr), list);
 	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3ddfd8f..1349870 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -574,6 +574,9 @@ int trace_set_clr_event(const char *system, const char *event, int set)
 {
 	struct trace_array *tr = top_trace_array();
 
+	if (!tr)
+		return -ENODEV;
+
 	return __ftrace_set_clr_event(tr, NULL, system, event, set);
 }
 EXPORT_SYMBOL_GPL(trace_set_clr_event);
@@ -2065,6 +2068,9 @@ event_enable_func(struct ftrace_hash *hash,
 	bool enable;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	/* hash funcs only work with set_ftrace_filter */
 	if (!enabled || !param)
 		return -EINVAL;
@@ -2396,6 +2402,9 @@ static __init int event_trace_enable(void)
 	char *token;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	for_each_event(iter, __start_ftrace_events, __stop_ftrace_events) {
 
 		call = *iter;
@@ -2442,6 +2451,8 @@ static __init int event_trace_init(void)
 	int ret;
 
 	tr = top_trace_array();
+	if (!tr)
+		return -ENODEV;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -2535,6 +2546,8 @@ static __init void event_trace_self_tests(void)
 	int ret;
 
 	tr = top_trace_array();
+	if (!tr)
+		return -ENODEV;
 
 	pr_info("Running tests on trace events:\n");
 

