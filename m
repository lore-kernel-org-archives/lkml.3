Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935327AbaGYUIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:08:48 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13726 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbaGYUHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:07:35 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 1/5] tracing: Do not do anything special with
 tracepoint_string when tracing is disabled
Date: Fri, 25 Jul 2014 16:05:29 -0400
Message-id: <1406318733-26754-2-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

When CONFIG_TRACING is not enabled, there's no reason to save the trace
strings either by the linker or as a static variable that can be
referenced later. Simply pass back the string that is given to
tracepoint_string().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 include/linux/ftrace_event.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106ffe..b29636327d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -574,6 +574,7 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
+#ifdef CONFIG_TRACING
 /**
  * tracepoint_string - register constant persistent string to trace system
  * @str - a constant persistent string that will be referenced in tracepoints
@@ -607,6 +608,15 @@ do {									\
 		___tp_str;						\
 	})
 #define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+#else
+/*
+ * tracepoint_string() is used to save the string address for userspace
+ * tracing tools. When tracing isn't configured, there's no need to save
+ * anything.
+ */
+# define tracepoint_string(str) str
+# define __tracepoint_string
+#endif
 
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
-- 
1.8.4.108.g55ea5f6

