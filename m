Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3HVQfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:35:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3HVQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:34:21 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5JiLV5BdmL4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kkNRMbCVdw8A:10 a=VnNF1IyMAAAA:8 a=6YoDTMQ24hlwulc7F-gA:9 a=jeBq3FmKZ4MA:10 a=112KCApwnQhSBISL:21 a=Xw1ij397zh3I7ja2:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130822163420.190373748@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 22 Aug 2013 12:32:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 1/5] tracing: Add __tracepoint_string() to export string pointers
References: <20130822163225.773134216@goodmis.org>
Content-Disposition: inline; filename=0000-tracing-Add-__tracepoint_string-to-export-string-poi.patch
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
 include/linux/ftrace_event.h      |   34 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h              |    3 +++
 kernel/trace/trace_printk.c       |   19 +++++++++++++++++++
 4 files changed, 62 insertions(+), 1 deletion(-)

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
index 4372658..81af18a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -357,6 +357,40 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
+/**
+ * tracepoint_string - register constant persistent string to trace system
+ * @str - a constant persistent string that will be referenced in tracepoints
+ *
+ * If constant strings are being used in tracepoints, it is faster and
+ * more efficient to just save the pointer to the string and reference
+ * that with a printf "%s" instead of saving the string in the ring buffer
+ * and wasting space and time.
+ *
+ * The problem with the above approach is that userspace tools that read
+ * the binary output of the trace buffers do not have access to the string.
+ * Instead they just show the address of the string which is not very
+ * useful to users.
+ *
+ * With tracepoint_string(), the string will be registered to the tracing
+ * system and exported to userspace via the debugfs/tracing/printk_formats
+ * file that maps the string address to the string text. This way userspace
+ * tools that read the binary buffers have a way to map the pointers to
+ * the ASCII strings they represent.
+ *
+ * The @str used must be a constant string and persistent as it would not
+ * make sense to show a string that no longer exists. But it is still fine
+ * to be used with modules, because when modules are unloaded, if they
+ * had tracepoints, the ring buffers are cleared too. As long as the string
+ * does not change during the life of the module, it is fine to use
+ * tracepoint_string() within a module.
+ */
+#define tracepoint_string(str)						\
+	({								\
+		static const char *___tp_str __tracepoint_string = str; \
+		___tp_str;						\
+	})
+#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
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
index a9077c1..2900817 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -244,12 +244,31 @@ static const char **find_next(void *v, loff_t *pos)
 {
 	const char **fmt = v;
 	int start_index;
+	int last_index;
 
 	start_index = __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt;
 
 	if (*pos < start_index)
 		return __start___trace_bprintk_fmt + *pos;
 
+	/*
+	 * The __tracepoint_str section is treated the same as the
+	 * __trace_printk_fmt section. The difference is that the
+	 * __trace_printk_fmt section should only be used by trace_printk()
+	 * in a debugging environment, as if anything exists in that section
+	 * the trace_prink() helper buffers are allocated, which would just
+	 * waste space in a production environment.
+	 *
+	 * The __tracepoint_str sections on the other hand are used by
+	 * tracepoints which need to map pointers to their strings to
+	 * the ASCII text for userspace.
+	 */
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


