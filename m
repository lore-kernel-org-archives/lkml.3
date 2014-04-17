Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaDQISN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:18:13 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33402 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaDQISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:18:08 -0400
Subject: [PATCH -tip v9 12/26] ftrace/*probes: Allow probing on some
 functions
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:18:00 +0900
Message-ID: <20140417081800.26341.56504.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to prohibit probing on the functions
used for preparation and uprobe only fetch functions.
Those are safely probed because those are not invoked
from kprobe's breakpoint/fault/debug handlers. So there
is no chance to cause recursive exceptions.

Following functions are now removed from the kprobes blacklist.
update_bitfield_fetch_param
free_bitfield_fetch_param
kprobe_register
FETCH_FUNC_NAME(stack, type) in trace_uprobe.c
FETCH_FUNC_NAME(memory, type) in trace_uprobe.c
FETCH_FUNC_NAME(memory, string) in trace_uprobe.c
FETCH_FUNC_NAME(memory, string_size) in trace_uprobe.c
FETCH_FUNC_NAME(file_offset, type) in trace_uprobe.c

Changes from v8:
  - small style fix (Thanks to Steven Rostedt!)

Changes from v6:
  - allow probing fetch functions in trace_uprobe.c

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/trace/trace_kprobe.c |    5 ++---
 kernel/trace/trace_probe.c  |    4 ++--
 kernel/trace/trace_uprobe.c |   20 ++++++++++----------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 903ae28..aa5f0bf 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1196,9 +1196,8 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
  * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
  * lockless, but we can't race with this __init function.
  */
-static __kprobes
-int kprobe_register(struct ftrace_event_call *event,
-		    enum trace_reg type, void *data)
+static int kprobe_register(struct ftrace_event_call *event,
+			   enum trace_reg type, void *data)
 {
 	struct trace_kprobe *tk = (struct trace_kprobe *)event->data;
 	struct ftrace_event_file *file = data;
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 8364a42..d3a91e4 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -183,7 +183,7 @@ DEFINE_BASIC_FETCH_FUNCS(bitfield)
 #define fetch_bitfield_string		NULL
 #define fetch_bitfield_string_size	NULL
 
-static __kprobes void
+static void
 update_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*
@@ -196,7 +196,7 @@ update_bitfield_fetch_param(struct bitfield_fetch_param *data)
 		update_symbol_cache(data->orig.data);
 }
 
-static __kprobes void
+static void
 free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 930e514..42c28fd 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -108,8 +108,8 @@ static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
  * Uprobes-specific fetch functions
  */
 #define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
+static void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,		\
+					 void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)get_user_stack_nth(regs,			\
 					      ((unsigned long)offset)); \
@@ -120,8 +120,8 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-						void *addr, void *dest) \
+static void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,		\
+					  void *addr, void *dest)	\
 {									\
 	type retval;							\
 	void __user *vaddr = (void __force __user *) addr;		\
@@ -136,8 +136,8 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
  * length and relative data location.
  */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+					    void *addr, void *dest)
 {
 	long ret;
 	u32 rloc = *(u32 *)dest;
@@ -158,8 +158,8 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 	}
 }
 
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-						      void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						 void *addr, void *dest)
 {
 	int len;
 	void __user *vaddr = (void __force __user *) addr;
@@ -184,8 +184,8 @@ static unsigned long translate_user_vaddr(void *file_offset)
 }
 
 #define DEFINE_FETCH_file_offset(type)					\
-static __kprobes void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,\
-					void *offset, void *dest) 	\
+static void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,	\
+					       void *offset, void *dest)\
 {									\
 	void *vaddr = (void *)translate_user_vaddr(offset);		\
 									\


