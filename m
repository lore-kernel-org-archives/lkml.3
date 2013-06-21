Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887Ab3FUF6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:58:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53819 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965648Ab3FUF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:58:02 -0400
Date: Thu, 20 Jun 2013 22:57:32 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-f5abaa1bfc3dbf26d19d3513f39279ca369f8d65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <51C3236C.8030508@hds.com>
References: <51C3236C.8030508@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] tracing: Add DEFINE_EVENT_FN() macro
Git-Commit-ID: f5abaa1bfc3dbf26d19d3513f39279ca369f8d65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 22:57:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5abaa1bfc3dbf26d19d3513f39279ca369f8d65
Gitweb:     http://git.kernel.org/tip/f5abaa1bfc3dbf26d19d3513f39279ca369f8d65
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Thu, 20 Jun 2013 11:44:44 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 22:24:32 -0700

tracing: Add DEFINE_EVENT_FN() macro

Each TRACE_EVENT() adds several helper functions. If two or more trace events
share the same structure and print format, they can also share most of these
helper functions and save a lot of space from duplicate code. This is why the
DECLARE_EVENT_CLASS() and DEFINE_EVENT() were created.

Some events require a trigger to be called at registering and unregistering of
the event and to do so they use TRACE_EVENT_FN().

If multiple events require a trigger, they currently have no choice but to use
TRACE_EVENT_FN() as there's no DEFINE_EVENT_FN() available. This unfortunately
causes a lot of wasted duplicate code created.

By adding a DEFINE_EVENT_FN(), these events can still use a
DECLARE_EVENT_CLASS() and then define their own triggers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/51C3236C.8030508@hds.com
Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/tracepoint.h   | 2 ++
 include/trace/define_trace.h | 5 +++++
 include/trace/ftrace.h       | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f8e084d..ebeab36 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -378,6 +378,8 @@ static inline void tracepoint_synchronize_unregister(void)
 #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
 #define DEFINE_EVENT(template, name, proto, args)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_CONDITION(template, name, proto,		\
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 1905ca8..02e1003 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -44,6 +44,10 @@
 #define DEFINE_EVENT(template, name, proto, args) \
 	DEFINE_TRACE(name)
 
+#undef DEFINE_EVENT_FN
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg) \
+	DEFINE_TRACE_FN(name, reg, unreg)
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_TRACE(name)
@@ -91,6 +95,7 @@
 #undef TRACE_EVENT_CONDITION
 #undef DECLARE_EVENT_CLASS
 #undef DEFINE_EVENT
+#undef DEFINE_EVENT_FN
 #undef DEFINE_EVENT_PRINT
 #undef DEFINE_EVENT_CONDITION
 #undef TRACE_HEADER_MULTI_READ
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 19edd7f..d615f78 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -71,6 +71,10 @@
 	static struct ftrace_event_call	__used		\
 	__attribute__((__aligned__(4))) event_##name
 
+#undef DEFINE_EVENT_FN
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
