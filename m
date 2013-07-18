Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3GRIfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:35:17 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16934 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3GRIfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:35:14 -0400
Message-ID: <51E7A7DC.80108@huawei.com>
Date: Thu, 18 Jul 2013 16:31:24 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3 V2] tracing: guard tracing_selftest_disabled by CONFIG_FTRACE_STARTUP_TEST
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable tracing_selftest_disabled have not any sense when
CONFIG_FTRACE_STARTUP_TEST is disabled.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c        |    4 +++-
 kernel/trace/trace.h        |    2 +-
 kernel/trace/trace_events.c |    2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 41340c3..248a856 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -58,10 +58,12 @@ bool ring_buffer_expanded;
  */
 static bool __read_mostly tracing_selftest_running;

+#ifdef CONFIG_FTRACE_STARTUP_TEST
 /*
  * If a tracer is running, we do not want to run SELFTEST.
  */
 bool __read_mostly tracing_selftest_disabled;
+#endif

 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
@@ -1093,9 +1095,9 @@ int register_tracer(struct tracer *type)
 	/* Do we want this tracer to start on bootup? */
 	tracing_set_tracer(type->name);
 	default_bootup_tracer = NULL;
+#ifdef CONFIG_FTRACE_STARTUP_TEST
 	/* disable other selftests, since this will break it. */
 	tracing_selftest_disabled = true;
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
 	       type->name);
 #endif
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 20572ed..532c2e3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -658,10 +658,10 @@ extern int DYN_FTRACE_TEST_NAME(void);
 extern int DYN_FTRACE_TEST_NAME2(void);

 extern bool ring_buffer_expanded;
-extern bool tracing_selftest_disabled;
 DECLARE_PER_CPU(int, ftrace_cpu_disabled);

 #ifdef CONFIG_FTRACE_STARTUP_TEST
+extern bool tracing_selftest_disabled;
 extern int trace_selftest_startup_function(struct tracer *trace,
 					   struct trace_array *tr);
 extern int trace_selftest_startup_function_graph(struct tracer *trace,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 27963e2..5f694ce 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2228,7 +2228,9 @@ static __init int setup_trace_event(char *str)
 {
 	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
 	ring_buffer_expanded = true;
+#ifdef CONFIG_FTRACE_STARTUP_TEST
 	tracing_selftest_disabled = true;
+#endif

 	return 1;
 }
-- 
1.7.9.7


