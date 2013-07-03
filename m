Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab3GCMjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:39:25 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52553 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab3GCMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:52 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-ec-51d41aa4df34
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 03/12] tracing/kprobes: Make stack and memory fetch functions static
Date: Wed,  3 Jul 2013 21:35:37 +0900
Message-Id: <1372854946-17074-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Those fetch functions need to be implemented differently for kprobes
and uprobes.  Since the symbol and deref fetch functions don't call
those directly anymore, we can make them static and implement them
separately.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c |  8 ++++----
 kernel/trace/trace_probe.h  | 10 +---------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index de13465902b0..5351e5d3c8f5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -800,7 +800,7 @@ static const struct file_operations kprobe_profile_ops = {
  * kprobes-specific fetch functions
  */
 #define DEFINE_FETCH_stack(type)					\
-__kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,	\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
 					  void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
@@ -812,7 +812,7 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_memory(type)					\
-__kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,	\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
 					  void *addr, void *dest)	\
 {									\
 	type retval;							\
@@ -826,7 +826,7 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
  * length and relative data location.
  */
-__kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 					       void *addr, void *dest)
 {
 	long ret;
@@ -863,7 +863,7 @@ __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 }
 
 /* Return the length of string -- including null terminal byte */
-__kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 						    void *addr, void *dest)
 {
 	mm_segment_t old_fs;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 1c37c813e5e5..50f152eb7ef0 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -171,24 +171,16 @@ DECLARE_FETCH_FUNC(method, u32);		\
 DECLARE_FETCH_FUNC(method, u64)
 
 /*
- * Declare fetch functions
+ * Declare common fetch functions for both of kprobes and uprobes
  */
 DECLARE_BASIC_FETCH_FUNCS(reg);
 #define fetch_reg_string		NULL
 #define fetch_reg_string_size		NULL
 
-DECLARE_BASIC_FETCH_FUNCS(stack);
-#define fetch_stack_string		NULL
-#define fetch_stack_string_size		NULL
-
 DECLARE_BASIC_FETCH_FUNCS(retval);
 #define fetch_retval_string		NULL
 #define fetch_retval_string_size	NULL
 
-DECLARE_BASIC_FETCH_FUNCS(memory);
-DECLARE_FETCH_FUNC(memory, string);
-DECLARE_FETCH_FUNC(memory, string_size);
-
 DECLARE_BASIC_FETCH_FUNCS(symbol);
 DECLARE_FETCH_FUNC(symbol, string);
 DECLARE_FETCH_FUNC(symbol, string_size);
-- 
1.7.11.7

