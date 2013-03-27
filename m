Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3C0Jtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:49:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64396 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab3C0Jtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:43 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 12/14] tracing: guard tracing_selftest_disabled by CONFIG_FTRACE_STARTUP_TEST
Date: Wed, 27 Mar 2013 17:48:54 +0800
Message-ID: <1364377737-10540-14-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Variable tracing_selftest_disabled have not any sense when
CONFIG_FTRACE_STARTUP_TEST is disabled.

This patch also remove __read_mostly attribute, since variable
tracing_selftest_disabled really not read mostly.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c        |    6 ++++--
 kernel/trace/trace.h        |    2 +-
 kernel/trace/trace_events.c |    2 ++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee4e110..09a3aa8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -58,10 +58,12 @@ bool ring_buffer_expanded;
  */
 static bool __read_mostly tracing_selftest_running;
 
+#ifdef CONFIG_FTRACE_STARTUP_TEST
 /*
  * If a tracer is running, we do not want to run SELFTEST.
  */
-bool __read_mostly tracing_selftest_disabled;
+bool tracing_selftest_disabled;
+#endif
 
 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
@@ -1069,8 +1071,8 @@ int register_tracer(struct tracer *type)
 	tracing_set_tracer(type->name);
 	default_bootup_tracer = NULL;
 	/* disable other selftests, since this will break it. */
-	tracing_selftest_disabled = true;
 #ifdef CONFIG_FTRACE_STARTUP_TEST
+	tracing_selftest_disabled = true;
 	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
 	       type->name);
 #endif
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 19e3da2..573c1dc 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -546,10 +546,10 @@ extern int DYN_FTRACE_TEST_NAME(void);
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
index 23f4cfc..d5ca0c1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2251,7 +2251,9 @@ static __init int setup_trace_event(char *str)
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


