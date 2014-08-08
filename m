Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbaHHWaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:30:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbaHHUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 137/259] tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
Date: Fri,  8 Aug 2014 13:39:20 -0700
Message-Id: <1407530482-4483-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/trace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9250479..d3db296 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -454,6 +454,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	struct print_entry *entry;
 	unsigned long irq_flags;
 	int alloc;
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -463,7 +466,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc, 
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -480,6 +483,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 		entry->buf[size] = '\0';
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return size;
 }
@@ -497,6 +501,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	struct bputs_entry *entry;
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -504,7 +511,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -513,6 +520,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 	entry->str			= str;
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return 1;
 }
-- 
1.9.1

