Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbaDIVGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:06:24 -0400
Received: from mail.efficios.com ([78.47.125.74]:58784 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964967AbaDIVGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:06:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] Fix: anonymous unions in struct ftrace_event_call
Date: Wed,  9 Apr 2014 17:06:08 -0400
Message-Id: <1397077568-3156-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc <= 4.5.x has significant limitations with respect to initialization
of anonymous unions within structures. They need to be surrounded by
brackets, _and_ they need to be initialized in the same order in which
they appear in the structure declaration.

Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=10676
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h    |    8 ++++++--
 include/trace/ftrace.h      |   12 +++++++++---
 kernel/trace/trace_export.c |    6 ++++--
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a747a77..57c2509 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -117,8 +117,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
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
@@ -131,8 +133,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
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
1.7.10.4

