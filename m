Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbaDJNBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:01:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:41131 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030745AbaDJNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:01:04 -0400
Message-Id: <20140410130059.680173788@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 10 Apr 2014 09:00:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 2/2] tracing: Fix anonymous unions in struct ftrace_event_call
References: <20140410130021.634516192@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Fix-anonymous-unions-in-struct-ftrace_event_.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

gcc <= 4.5.x has significant limitations with respect to initialization
of anonymous unions within structures. They need to be surrounded by
brackets, _and_ they need to be initialized in the same order in which
they appear in the structure declaration.

Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=10676
Link: http://lkml.kernel.org/r/1397077568-3156-1-git-send-email-mathieu.desnoyers@efficios.com

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h    |  8 ++++++--
 include/trace/ftrace.h      | 12 +++++++++---
 kernel/trace/trace_export.c |  6 ++++--
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1e67b7a..af94c98 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -119,8 +119,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
 	  event_enter_##sname = {					\
-		.name                   = "sys_enter"#sname,		\
 		.class			= &event_class_syscall_enter,	\
+		{							\
+			.name                   = "sys_enter"#sname,	\
+		},							\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
@@ -133,8 +135,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
 	  event_exit_##sname = {					\
-		.name                   = "sys_exit"#sname,		\
 		.class			= &event_class_syscall_exit,	\
+		{							\
+			.name                   = "sys_exit"#sname,	\
+		},							\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 9c44c11..0a1a4f7 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -470,8 +470,10 @@ static inline notrace int ftrace_get_offsets_##call(			\
  * };
  *
  * static struct ftrace_event_call event_<call> = {
- *	.tp			= &__tracepoint_<call>,
  *	.class			= event_class_<template>,
+ *	{
+ *		.tp			= &__tracepoint_<call>,
+ *	},
  *	.event			= &ftrace_event_type_<call>,
  *	.print_fmt		= print_fmt_<call>,
  *	.flags			= TRACE_EVENT_FL_TRACEPOINT,
@@ -606,8 +608,10 @@ static struct ftrace_event_class __used __refdata event_class_##call = { \
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
 static struct ftrace_event_call __used event_##call = {			\
-	.tp			= &__tracepoint_##call,			\
 	.class			= &event_class_##template,		\
+	{								\
+		.tp			= &__tracepoint_##call,		\
+	},								\
 	.event.funcs		= &ftrace_event_type_funcs_##template,	\
 	.print_fmt		= print_fmt_##template,			\
 	.flags			= TRACE_EVENT_FL_TRACEPOINT,		\
@@ -621,8 +625,10 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 static const char print_fmt_##call[] = print;				\
 									\
 static struct ftrace_event_call __used event_##call = {			\
-	.tp			= &__tracepoint_##call,			\
 	.class			= &event_class_##template,		\
+	{								\
+		.tp			= &__tracepoint_##call,		\
+	},								\
 	.event.funcs		= &ftrace_event_type_funcs_##call,	\
 	.print_fmt		= print_fmt_##call,			\
 	.flags			= TRACE_EVENT_FL_TRACEPOINT,		\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index ee0a509..d4ddde2 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -173,9 +173,11 @@ struct ftrace_event_class __refdata event_class_ftrace_##call = {	\
 };									\
 									\
 struct ftrace_event_call __used event_##call = {			\
-	.name			= #call,				\
-	.event.type		= etype,				\
 	.class			= &event_class_ftrace_##call,		\
+	{								\
+		.name			= #call,			\
+	},								\
+	.event.type		= etype,				\
 	.print_fmt		= print,				\
 	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE | TRACE_EVENT_FL_USE_CALL_FILTER, \
 };									\
-- 
1.8.5.3


