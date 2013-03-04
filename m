Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3CDGQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 01:16:32 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:40144 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3CDGQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 01:16:31 -0500
Message-ID: <51343C1F.2050502@huawei.com>
Date: Mon, 4 Mar 2013 14:15:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing: Fix some section mismatch warninings
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we've added __init annotation to field-defining functions, we should
add __refdata annotation to event_call variables, which reference those
functions.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/trace/ftrace.h        | 2 +-
 kernel/trace/trace_export.c   | 2 +-
 kernel/trace/trace_syscalls.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index dc18af3..3ffaf52 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -570,7 +570,7 @@ static inline void ftrace_test_probe_##call(void)			\
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 _TRACE_PERF_PROTO(call, PARAMS(proto));					\
 static const char print_fmt_##call[] = print;				\
-static struct ftrace_event_class __used event_class_##call = {		\
+static struct ftrace_event_class __used __refdata event_class_##call = { \
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4f6a91c..d21a746 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -168,7 +168,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, filter,\
 			 regfn)						\
 									\
-struct ftrace_event_class event_class_ftrace_##call = {			\
+struct ftrace_event_class __refdata event_class_ftrace_##call = {	\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c57fe3d..07d75e5 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -438,7 +438,7 @@ struct trace_event_functions exit_syscall_print_funcs = {
 	.trace		= print_syscall_exit,
 };
 
-struct ftrace_event_class event_class_syscall_enter = {
+struct ftrace_event_class __refdata event_class_syscall_enter = {
 	.system		= "syscalls",
 	.reg		= syscall_enter_register,
 	.define_fields	= syscall_enter_define_fields,
@@ -446,7 +446,7 @@ struct ftrace_event_class event_class_syscall_enter = {
 	.raw_init	= init_syscall_trace,
 };
 
-struct ftrace_event_class event_class_syscall_exit = {
+struct ftrace_event_class __refdata event_class_syscall_exit = {
 	.system		= "syscalls",
 	.reg		= syscall_exit_register,
 	.define_fields	= syscall_exit_define_fields,
-- 
1.8.0.2
