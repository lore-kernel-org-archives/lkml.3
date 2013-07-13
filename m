Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3GMAqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:46:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12677 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab3GMApt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:45:49 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=DrNmnk2JS-sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=O0olwec3pisA:10 a=VnNF1IyMAAAA:8 a=NO-XTRILGWK9rTBr8EUA:9 a=jeBq3FmKZ4MA:10 a=6tQl6VDH3J4nkrVg:21 a=sNhEkZTIjf2agXgl:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130713004548.016951772@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Jul 2013 20:41:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 3/4] tracing: Add __tracepoint_string() to export string pointers
References: <20130713004102.219523935@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-__tracepoint_string-to-export-string-poi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There are several tracepoints (mostly in RCU), that reference a string
pointer and uses the print format of "%s" to display the string that
exists in the kernel, instead of copying the actual string to the
ring buffer (saves time and ring buffer space).

But this has an issue with userspace tools that read the binary buffers
that has the address of the string but has no access to what the string
itself is. The end result is just output that looks like:

 rcu_dyntick:          ffffffff818adeaa 1 0
 rcu_dyntick:          ffffffff818adeb5 0 140000000000000
 rcu_dyntick:          ffffffff818adeb5 0 140000000000000
 rcu_utilization:      ffffffff8184333b
 rcu_utilization:      ffffffff8184333b

The above is pretty useless when read by the userspace tools. Ideally
we would want something that looks like this:

 rcu_dyntick:          Start 1 0
 rcu_dyntick:          End 0 140000000000000
 rcu_dyntick:          Start 140000000000000 0
 rcu_callback:         rcu_preempt rhp=0xffff880037aff710 func=put_cred_rcu 0/4
 rcu_callback:         rcu_preempt rhp=0xffff880078961980 func=file_free_rcu 0/5
 rcu_dyntick:          End 0 1

The trace_printk() which also only stores the address of the string
format instead of recording the string into the buffer itself, exports
the mapping of kernel addresses to format strings via the printk_format
file in the debugfs tracing directory.

The tracepoint strings can use this same method and output the format
to the same file and the userspace tools will be able to decipher
the address without any modification.

The tracepoint strings need its own section to save the strings because
the trace_printk section will cause the trace_printk() buffers to be
allocated if anything exists within the section. trace_printk() is only
used for debugging and should never exist in the kernel, we can not use
the trace_printk sections.

Add a new tracepoint_str section that will also be examined by the output
of the printk_format file.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    7 ++++++-
 include/linux/ftrace_event.h      |    7 +++++++
 kernel/trace/trace.h              |    3 +++
 kernel/trace/trace_printk.c       |    7 +++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 69732d2..83e2c31 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -122,8 +122,12 @@
 #define TRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
 			 *(__trace_printk_fmt) /* Trace_printk fmt' pointer */ \
 			 VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = .;
+#define TRACEPOINT_STR() VMLINUX_SYMBOL(__start___tracepoint_str) = .;	\
+			 *(__tracepoint_str) /* Trace_printk fmt' pointer */ \
+			 VMLINUX_SYMBOL(__stop___tracepoint_str) = .;
 #else
 #define TRACE_PRINTKS()
+#define TRACEPOINT_STR()
 #endif
 
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -190,7 +194,8 @@
 	VMLINUX_SYMBOL(__stop___verbose) = .;				\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
-	TRACE_PRINTKS()
+	TRACE_PRINTKS()							\
+	TRACEPOINT_STR()
 
 /*
  * Data section helpers
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4372658..cead2e9 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -357,6 +357,13 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
+#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+#define tracepoint_string(str)						\
+	({								\
+		static const char *___tp_str __tracepoint_string = str; \
+		___tp_str;						\
+	})
+
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4a4f6e1..ba321f1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1022,6 +1022,9 @@ extern struct list_head ftrace_events;
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
+extern const char *__start___tracepoint_str[];
+extern const char *__stop___tracepoint_str[];
+
 void trace_printk_init_buffers(void);
 void trace_printk_start_comm(void);
 int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index a9077c1..fa8d070 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -244,12 +244,19 @@ static const char **find_next(void *v, loff_t *pos)
 {
 	const char **fmt = v;
 	int start_index;
+	int last_index;
 
 	start_index = __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt;
 
 	if (*pos < start_index)
 		return __start___trace_bprintk_fmt + *pos;
 
+	last_index = start_index;
+	start_index = __stop___tracepoint_str - __start___tracepoint_str;
+
+	if (*pos < last_index + start_index)
+		return __start___tracepoint_str + (*pos - last_index);
+
 	return find_next_mod_format(start_index, v, fmt, pos);
 }
 
-- 
1.7.10.4


