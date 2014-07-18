Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbaGRVWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:22:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:32740 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932280AbaGRVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:22:30 -0400
Date: Fri, 18 Jul 2014 17:22:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/4] ARM: add IPI tracepoints
Message-ID: <20140718172221.6dbe83e4@gandalf.local.home>
In-Reply-To: <alpine.LFD.2.11.1407181652080.3647@knanqh.ubzr>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
	<1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org>
	<20140718160418.54d11f6a@gandalf.local.home>
	<alpine.LFD.2.11.1407181652080.3647@knanqh.ubzr>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 16:55:42 -0400 (EDT)
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

> 
> Here's the patch I have at the head of the series now, with the above
> ugliness changed to an unconditional __tracepoint_string attribute.
> 

I was thinking of something like this. Feel free to add this to your
series.

-- Steve

From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tracing: Do not do anything special with tracepoint_string when tracing is disabled

When CONFIG_TRACING is not enabled, there's no reason to save the trace
strings either by the linker or as a static variable that can be
referenced later. Simply pass back the string that is given to
tracepoint_string().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106..b296363 100644
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

