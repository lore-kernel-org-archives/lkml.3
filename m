Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3H0ItG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:49:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51891 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3H0ItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:02 -0400
X-AuditID: 9c930197-b7b44ae00000347f-47-521c67fa3701
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 05/13] tracing/kprobes: Staticize stack and memory fetch functions
Date: Tue, 27 Aug 2013 17:48:48 +0900
Message-Id: <1377593336-16828-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Those fetch functions need to be implemented differently for kprobes
and uprobes.  Since the deref fetch functions don't call those
directly anymore, we can make them static and implement them
separately.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 8 ++++----
 kernel/trace/trace_probe.h  | 8 --------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1eff166990c2..fdb6dec11592 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -758,7 +758,7 @@ static const struct file_operations kprobe_profile_ops = {
  * kprobes-specific fetch functions
  */
 #define DEFINE_FETCH_stack(type)					\
-__kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,	\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
 					  void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
@@ -770,7 +770,7 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_memory(type)					\
-__kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,	\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
 					  void *addr, void *dest)	\
 {									\
 	type retval;							\
@@ -784,7 +784,7 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
  * length and relative data location.
  */
-__kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 					       void *addr, void *dest)
 {
 	long ret;
@@ -821,7 +821,7 @@ __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 }
 
 /* Return the length of string -- including null terminal byte */
-__kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 						    void *addr, void *dest)
 {
 	mm_segment_t old_fs;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 8c62746e5419..9ac7bdf607cc 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -177,18 +177,10 @@ DECLARE_BASIC_FETCH_FUNCS(reg);
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

