Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaHRJd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:33:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42492 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaHRJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 017/137] tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
Date: Mon, 18 Aug 2014 10:31:18 +0100
Message-Id: <1408354398-10226-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit 8abfb8727f4a724d31f9ccfd8013fbd16d539445 upstream.

Currently trace option stacktrace is not applicable for
trace_printk with constant string argument, the reason is
in __trace_puts/__trace_bputs ftrace_trace_stack is missing.

In contrast, when using trace_printk with non constant string
argument(will call into __trace_printk/__trace_bprintk), then
trace option stacktrace is workable, this inconstant result
will confuses users a lot.

Link: http://lkml.kernel.org/p/51E7A7C9.9040401@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c8b8717afc23..c75803fba4b9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -434,6 +434,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	struct print_entry *entry;
 	unsigned long irq_flags;
 	int alloc;
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -443,7 +446,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc, 
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -460,6 +463,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 		entry->buf[size] = '\0';
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return size;
 }
@@ -477,6 +481,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	struct bputs_entry *entry;
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -484,7 +491,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -493,6 +500,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 	entry->str			= str;
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return 1;
 }
-- 
1.9.1

