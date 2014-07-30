Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaG3Mhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:37:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36675 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbaG3MP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 21/94] tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
Date: Wed, 30 Jul 2014 14:14:10 +0200
Message-Id: <cce7b584fda8a233f543f0d1ba7eb2c9187e19ae.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/trace/trace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5e9cb157d31e..952cde4d4e3c 100644
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
2.0.1

