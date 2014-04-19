Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaDSH4E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 03:56:04 -0400
Received: from mx.insigma.com.cn ([115.236.48.170]:34930 "EHLO
	WX-Ex2010Edge01.insigma.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750905AbaDSHz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 03:55:59 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2014 03:55:59 EDT
From: Jiaxing Wang <wangjiaxing@insigma.com.cn>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Jiaxing Wang <wangjiaxing@insigma.com.cn>
Subject: [PATCH] tracing:Do not profile dumpstack utilities to fix stack trace output
Date: Sat, 19 Apr 2014 15:45:46 +0800
Message-ID: <1397893546-7465-1-git-send-email-wangjiaxing@insigma.com.cn>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [120.40.72.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When function_graph tracer is enabled, we get stack trace like this:

         Depth    Size   Location    (88 entries)
         -----    ----   --------
   0)     3232       0   update_curr+0xe/0x1e0
   1)     3232       0   dump_trace+0xb5/0x1b0
   2)     3232       0   ftrace_ops_list_func+0xe6/0x100
   3)     3232      68   ftrace_call+0x5/0xb
   4)     3164      92   enqueue_entity+0x38/0xe20
   5)     3072       0   return_to_handler+0x0/0xf
   6)     3072      80   save_stack_trace+0x30/0x50
   7)     2992       0   return_to_handler+0x0/0xf
   8)     2992      28   stack_trace_call+0x119/0x340
   9)     2964       0   return_to_handler+0x0/0xf
  10)     2964      12   enqueue_task_fair+0x47/0x7e0
  11)     2952       0   return_to_handler+0x0/0xf
  12)     2952      16   enqueue_task+0x45/0x70
  ... ...

The 'save_stack_trace+0x30/0x50' and 'stack_trace_call+0x119/0x340'
entries are misplaced below the ftrace_ops_list_func and ftrace_call entries,
which looks very confusing.

And dump_stack() is also affected when function_graph tracer is enabled:

  [  425.353391] Call Trace:
  [  425.353449]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.353496]  [<c1012546>] print_context_stack+0xc6/0xd0
  [  425.353547]  [<c108ab84>] enqueue_entity+0x894/0xe60
  [  425.353597]  [<c107b4c5>] ? enqueue_task+0x45/0x70
  [  425.353649]  [<c108b159>] ? enqueue_task_fair+0x9/0x7e0
  [  425.353694]  [<c107b4c5>] ? enqueue_task+0x45/0x70
  [  425.353743]  [<c1041037>] ? prepare_ftrace_return+0x77/0xa0
  [  425.353791]  [<c108b159>] ? enqueue_task_fair+0x9/0x7e0
  [  425.353856]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.353901]  [<c10116b5>] dump_trace+0xb5/0x1b0
  [  425.353958]  [<c107b4dd>] ? enqueue_task+0x5d/0x70
  [  425.354002]  [<c107b436>] ? update_rq_clock.part.80+0x6/0x50
  [  425.354074]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.354120]  [<c1012666>] show_trace_log_lvl+0x46/0x50
  [  425.354178]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.354222]  [<c1011802>] show_stack_log_lvl+0x52/0xe0
  [  425.354272]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.354317]  [<c10126c6>] show_stack+0x26/0x50
  [  425.354369]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.354415]  [<c1643be1>] dump_stack+0x41/0x52
  [  425.354483]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.354527]  [<c108b197>] enqueue_task_fair+0x47/0x7e0
  [  425.354576]  [<c16531c1>] ftrace_graph_caller+0x19/0x19
  [  425.354621]  [<c107b4c5>] enqueue_task+0x45/0x70
  ... ...

This happens because the functions in the route of stack_trace and
dump_stack() get function_graph traced, their return addresses on stack are
replaced by 'return_to_handler' and their real return addresses are
saved in current->ret_stack[].(Specifically, these functons include
save_stack_trace,dump_trace,print_context_stack,print_ftrace_graph_addr
in the case of stack_trace and show_stack,show_stack_log_lvl,show_trace_log_lvl
,dump_trace,print_context_stack,print_ftrace_graph_addr in the case of
dump_stack()).

When dumping the stack, their 'return_to_handler' on stack are skipped
but not their corresponding current->ret_stack entries which then are matched
with other function's 'return_to_handler' on the stack and resulting the
wrong output above.

To fix this, we can disable the profiling of dumpstack utilities.

Signed-off-by: Jiaxing Wang <wangjiaxing@insigma.com.cn>
---
 arch/x86/kernel/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f4d9600..9dd8ce4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -14,6 +14,9 @@ CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
+CFLAGS_REMOVE_dumpstack.o = -pg
+CFLAGS_REMOVE_dumpstack_32.o = -pg
+CFLAGS_REMOVE_stacktrace.o = -pg
 endif
 
 CFLAGS_irq.o := -I$(src)/../include/asm/trace
-- 
1.8.3.2

