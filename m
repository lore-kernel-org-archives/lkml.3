Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaHHCgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:36:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:15119 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752825AbaHHCgJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:36:09 -0400
Date: Thu, 7 Aug 2014 22:35:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/5] tracing: Do not do anything special with
 tracepoint_string when tracing is disabled
Message-ID: <20140807223553.541eada9@gandalf.local.home>
In-Reply-To: <1406318733-26754-2-git-send-email-nicolas.pitre@linaro.org>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
	<1406318733-26754-2-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because ftrace_events.h is not included when config tracing is not
enabled, I got error messages when compiling arm and arm64 without
tracing enabled. This is the new patch I'm now testing that moves the
tracepoint_string code to include/linux/tracepoint.h as well.

-- Steve

>From 3c49b52b155d0f723792377e1a4480a0e7ca0ba2 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 25 Jul 2014 16:05:29 -0400
Subject: [PATCH] tracing: Do not do anything special with tracepoint_string
 when tracing is disabled

When CONFIG_TRACING is not enabled, there's no reason to save the trace
strings either by the linker or as a static variable that can be
referenced later. Simply pass back the string that is given to
tracepoint_string().

Had to move the define to include/linux/tracepoint.h so that it is still
visible when CONFIG_TRACING is not set.

Link: http://lkml.kernel.org/p/1406318733-26754-2-git-send-email-nicolas.pitre@linaro.org

Suggested-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h | 34 ----------------------------------
 include/linux/tracepoint.h   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106ffe2c..c9f619a2070f 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -574,40 +574,6 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
-/**
- * tracepoint_string - register constant persistent string to trace system
- * @str - a constant persistent string that will be referenced in tracepoints
- *
- * If constant strings are being used in tracepoints, it is faster and
- * more efficient to just save the pointer to the string and reference
- * that with a printf "%s" instead of saving the string in the ring buffer
- * and wasting space and time.
- *
- * The problem with the above approach is that userspace tools that read
- * the binary output of the trace buffers do not have access to the string.
- * Instead they just show the address of the string which is not very
- * useful to users.
- *
- * With tracepoint_string(), the string will be registered to the tracing
- * system and exported to userspace via the debugfs/tracing/printk_formats
- * file that maps the string address to the string text. This way userspace
- * tools that read the binary buffers have a way to map the pointers to
- * the ASCII strings they represent.
- *
- * The @str used must be a constant string and persistent as it would not
- * make sense to show a string that no longer exists. But it is still fine
- * to be used with modules, because when modules are unloaded, if they
- * had tracepoints, the ring buffers are cleared too. As long as the string
- * does not change during the life of the module, it is fine to use
- * tracepoint_string() within a module.
- */
-#define tracepoint_string(str)						\
-	({								\
-		static const char *___tp_str __tracepoint_string = str; \
-		___tp_str;						\
-	})
-#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
-
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
 
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2e2a5f7717e5..b1293f15f592 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -249,6 +249,50 @@ extern void syscall_unregfunc(void);
 
 #endif /* CONFIG_TRACEPOINTS */
 
+#ifdef CONFIG_TRACING
+/**
+ * tracepoint_string - register constant persistent string to trace system
+ * @str - a constant persistent string that will be referenced in tracepoints
+ *
+ * If constant strings are being used in tracepoints, it is faster and
+ * more efficient to just save the pointer to the string and reference
+ * that with a printf "%s" instead of saving the string in the ring buffer
+ * and wasting space and time.
+ *
+ * The problem with the above approach is that userspace tools that read
+ * the binary output of the trace buffers do not have access to the string.
+ * Instead they just show the address of the string which is not very
+ * useful to users.
+ *
+ * With tracepoint_string(), the string will be registered to the tracing
+ * system and exported to userspace via the debugfs/tracing/printk_formats
+ * file that maps the string address to the string text. This way userspace
+ * tools that read the binary buffers have a way to map the pointers to
+ * the ASCII strings they represent.
+ *
+ * The @str used must be a constant string and persistent as it would not
+ * make sense to show a string that no longer exists. But it is still fine
+ * to be used with modules, because when modules are unloaded, if they
+ * had tracepoints, the ring buffers are cleared too. As long as the string
+ * does not change during the life of the module, it is fine to use
+ * tracepoint_string() within a module.
+ */
+#define tracepoint_string(str)						\
+	({								\
+		static const char *___tp_str __tracepoint_string = str; \
+		___tp_str;						\
+	})
+#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+#else
+/*
+ * tracepoint_string() is used to save the string address for userspace
+ * tracing tools. When tracing isn't configured, there's no need to save
+ * anything.
+ */
+# define tracepoint_string(str) str
+# define __tracepoint_string
+#endif
+
 /*
  * The need for the DECLARE_TRACE_NOARGS() is to handle the prototype
  * (void). "void" is a special value in a function prototype and can
-- 
2.0.1

