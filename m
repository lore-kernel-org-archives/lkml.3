Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbaGPD0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:26:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:55746 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758305AbaGPD0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:26:38 -0400
Message-Id: <20140716032636.883635728@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 15 Jul 2014 23:24:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 1/4] tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
References: <20140716032455.761976900@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-Add-ftrace_trace_stack-into-__trace_puts-__t.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Currently trace option stacktrace is not applicable for
trace_printk with constant string argument, the reason is
in __trace_puts/__trace_bputs ftrace_trace_stack is missing.

In contrast, when using trace_printk with non constant string
argument(will call into __trace_printk/__trace_bprintk), then
trace option stacktrace is workable, this inconstant result
will confuses users a lot.

Link: http://lkml.kernel.org/p/51E7A7C9.9040401@huawei.com

Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f243444a3772..a6ffc8918dda 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -466,6 +466,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	struct print_entry *entry;
 	unsigned long irq_flags;
 	int alloc;
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -475,7 +478,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc, 
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -492,6 +495,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 		entry->buf[size] = '\0';
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return size;
 }
@@ -509,6 +513,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	struct bputs_entry *entry;
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -516,7 +523,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -525,6 +532,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 	entry->str			= str;
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return 1;
 }
-- 
2.0.0


