Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaGZTJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:09:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaGZTDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.14 14/87] tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
Date: Sat, 26 Jul 2014 12:01:48 -0700
Message-Id: <20140726190214.993897423@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -454,6 +454,9 @@ int __trace_puts(unsigned long ip, const
 	struct print_entry *entry;
 	unsigned long irq_flags;
 	int alloc;
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -463,7 +466,7 @@ int __trace_puts(unsigned long ip, const
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc, 
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -480,6 +483,7 @@ int __trace_puts(unsigned long ip, const
 		entry->buf[size] = '\0';
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return size;
 }
@@ -497,6 +501,9 @@ int __trace_bputs(unsigned long ip, cons
 	struct bputs_entry *entry;
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
+	int pc;
+
+	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -504,7 +511,7 @@ int __trace_bputs(unsigned long ip, cons
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
-					  irq_flags, preempt_count());
+					  irq_flags, pc);
 	if (!event)
 		return 0;
 
@@ -513,6 +520,7 @@ int __trace_bputs(unsigned long ip, cons
 	entry->str			= str;
 
 	__buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(buffer, irq_flags, 4, pc);
 
 	return 1;
 }


