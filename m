Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaFFRVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:21:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:27385 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752648AbaFFRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:21:06 -0400
Message-Id: <20140606172104.693665166@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 06 Jun 2014 12:30:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [for-next][PATCH 4/6] tracing: Return error if ftrace_trace_arrays list is empty
References: <20140606163034.516780857@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Return-error-if-ftrace_trace_arrays-list-is-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

ftrace_trace_arrays links global_trace.list. However, global_trace
is not added to ftrace_trace_arrays if trace_alloc_buffers() failed.
As the result, ftrace_trace_arrays becomes an empty list. If
ftrace_trace_arrays is an empty list, current top_trace_array() returns
an invalid pointer. As the result, the kernel can induce memory corruption
or panic.

Current implementation does not check whether ftrace_trace_arrays is empty
list or not. So, in this patch, if ftrace_trace_arrays is empty list,
top_trace_array() returns NULL. Moreover, this patch makes all functions
calling top_trace_array() handle it appropriately.

Link: http://lkml.kernel.org/p/20140605223517.32311.99233.stgit@yunodevel

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h        |  3 +++
 kernel/trace/trace_events.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 217207ad60b3..9e82551dd566 100644
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
index 3ddfd8f62c05..f99e0b3bca8c 100644
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
+		return;
 
 	pr_info("Running tests on trace events:\n");
 
-- 
2.0.0.rc2


