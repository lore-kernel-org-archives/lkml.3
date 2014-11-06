Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaKFVFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:05:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:43038 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaKFVEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:04:55 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/18] perf tools: Add a thread stack for synthesizing call chains
Date: Thu,  6 Nov 2014 18:04:22 -0300
Message-Id: <1415307879-912-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a thread stack for synthesizing call chains from call and return
events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414678188-14946-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf       |   2 +
 tools/perf/util/event.h        |  26 +++++++
 tools/perf/util/thread-stack.c | 172 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/thread-stack.h |  32 ++++++++
 tools/perf/util/thread.c       |   3 +
 tools/perf/util/thread.h       |   3 +
 6 files changed, 238 insertions(+)
 create mode 100644 tools/perf/util/thread-stack.c
 create mode 100644 tools/perf/util/thread-stack.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3caf7dab50e8..0ebcc4ad0244 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -317,6 +317,7 @@ LIB_H += ui/util.h
 LIB_H += ui/ui.h
 LIB_H += util/data.h
 LIB_H += util/kvm-stat.h
+LIB_H += util/thread-stack.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -394,6 +395,7 @@ LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
+LIB_OBJS += $(OUTPUT)util/thread-stack.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8c7fe9d64e79..7be389735402 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -143,6 +143,32 @@ struct branch_stack {
 	struct branch_entry	entries[0];
 };
 
+enum {
+	PERF_IP_FLAG_BRANCH		= 1ULL << 0,
+	PERF_IP_FLAG_CALL		= 1ULL << 1,
+	PERF_IP_FLAG_RETURN		= 1ULL << 2,
+	PERF_IP_FLAG_CONDITIONAL	= 1ULL << 3,
+	PERF_IP_FLAG_SYSCALLRET		= 1ULL << 4,
+	PERF_IP_FLAG_ASYNC		= 1ULL << 5,
+	PERF_IP_FLAG_INTERRUPT		= 1ULL << 6,
+	PERF_IP_FLAG_TX_ABORT		= 1ULL << 7,
+	PERF_IP_FLAG_TRACE_BEGIN	= 1ULL << 8,
+	PERF_IP_FLAG_TRACE_END		= 1ULL << 9,
+	PERF_IP_FLAG_IN_TX		= 1ULL << 10,
+};
+
+#define PERF_BRANCH_MASK		(\
+	PERF_IP_FLAG_BRANCH		|\
+	PERF_IP_FLAG_CALL		|\
+	PERF_IP_FLAG_RETURN		|\
+	PERF_IP_FLAG_CONDITIONAL	|\
+	PERF_IP_FLAG_SYSCALLRET		|\
+	PERF_IP_FLAG_ASYNC		|\
+	PERF_IP_FLAG_INTERRUPT		|\
+	PERF_IP_FLAG_TX_ABORT		|\
+	PERF_IP_FLAG_TRACE_BEGIN	|\
+	PERF_IP_FLAG_TRACE_END)
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
new file mode 100644
index 000000000000..85b60d2e738f
--- /dev/null
+++ b/tools/perf/util/thread-stack.c
@@ -0,0 +1,172 @@
+/*
+ * thread-stack.c: Synthesize a thread's stack using call / return events
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include "thread.h"
+#include "event.h"
+#include "util.h"
+#include "debug.h"
+#include "thread-stack.h"
+
+#define STACK_GROWTH 4096
+
+struct thread_stack_entry {
+	u64 ret_addr;
+};
+
+struct thread_stack {
+	struct thread_stack_entry *stack;
+	size_t cnt;
+	size_t sz;
+	u64 trace_nr;
+};
+
+static int thread_stack__grow(struct thread_stack *ts)
+{
+	struct thread_stack_entry *new_stack;
+	size_t sz, new_sz;
+
+	new_sz = ts->sz + STACK_GROWTH;
+	sz = new_sz * sizeof(struct thread_stack_entry);
+
+	new_stack = realloc(ts->stack, sz);
+	if (!new_stack)
+		return -ENOMEM;
+
+	ts->stack = new_stack;
+	ts->sz = new_sz;
+
+	return 0;
+}
+
+static struct thread_stack *thread_stack__new(void)
+{
+	struct thread_stack *ts;
+
+	ts = zalloc(sizeof(struct thread_stack));
+	if (!ts)
+		return NULL;
+
+	if (thread_stack__grow(ts)) {
+		free(ts);
+		return NULL;
+	}
+
+	return ts;
+}
+
+static int thread_stack__push(struct thread_stack *ts, u64 ret_addr)
+{
+	int err = 0;
+
+	if (ts->cnt == ts->sz) {
+		err = thread_stack__grow(ts);
+		if (err) {
+			pr_warning("Out of memory: discarding thread stack\n");
+			ts->cnt = 0;
+		}
+	}
+
+	ts->stack[ts->cnt++].ret_addr = ret_addr;
+
+	return err;
+}
+
+static void thread_stack__pop(struct thread_stack *ts, u64 ret_addr)
+{
+	size_t i;
+
+	/*
+	 * In some cases there may be functions which are not seen to return.
+	 * For example when setjmp / longjmp has been used.  Or the perf context
+	 * switch in the kernel which doesn't stop and start tracing in exactly
+	 * the same code path.  When that happens the return address will be
+	 * further down the stack.  If the return address is not found at all,
+	 * we assume the opposite (i.e. this is a return for a call that wasn't
+	 * seen for some reason) and leave the stack alone.
+	 */
+	for (i = ts->cnt; i; ) {
+		if (ts->stack[--i].ret_addr == ret_addr) {
+			ts->cnt = i;
+			return;
+		}
+	}
+}
+
+int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
+			u64 to_ip, u16 insn_len, u64 trace_nr)
+{
+	if (!thread)
+		return -EINVAL;
+
+	if (!thread->ts) {
+		thread->ts = thread_stack__new();
+		if (!thread->ts) {
+			pr_warning("Out of memory: no thread stack\n");
+			return -ENOMEM;
+		}
+		thread->ts->trace_nr = trace_nr;
+	}
+
+	/*
+	 * When the trace is discontinuous, the trace_nr changes.  In that case
+	 * the stack might be completely invalid.  Better to report nothing than
+	 * to report something misleading, so reset the stack count to zero.
+	 */
+	if (trace_nr != thread->ts->trace_nr) {
+		thread->ts->trace_nr = trace_nr;
+		thread->ts->cnt = 0;
+	}
+
+	if (flags & PERF_IP_FLAG_CALL) {
+		u64 ret_addr;
+
+		if (!to_ip)
+			return 0;
+		ret_addr = from_ip + insn_len;
+		if (ret_addr == to_ip)
+			return 0; /* Zero-length calls are excluded */
+		return thread_stack__push(thread->ts, ret_addr);
+	} else if (flags & PERF_IP_FLAG_RETURN) {
+		if (!from_ip)
+			return 0;
+		thread_stack__pop(thread->ts, to_ip);
+	}
+
+	return 0;
+}
+
+void thread_stack__free(struct thread *thread)
+{
+	if (thread->ts) {
+		zfree(&thread->ts->stack);
+		zfree(&thread->ts);
+	}
+}
+
+void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
+			  size_t sz, u64 ip)
+{
+	size_t i;
+
+	if (!thread || !thread->ts)
+		chain->nr = 1;
+	else
+		chain->nr = min(sz, thread->ts->cnt + 1);
+
+	chain->ips[0] = ip;
+
+	for (i = 1; i < chain->nr; i++)
+		chain->ips[i] = thread->ts->stack[thread->ts->cnt - i].ret_addr;
+}
diff --git a/tools/perf/util/thread-stack.h b/tools/perf/util/thread-stack.h
new file mode 100644
index 000000000000..7c41579aec74
--- /dev/null
+++ b/tools/perf/util/thread-stack.h
@@ -0,0 +1,32 @@
+/*
+ * thread-stack.h: Synthesize a thread's stack using call / return events
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __PERF_THREAD_STACK_H
+#define __PERF_THREAD_STACK_H
+
+#include <sys/types.h>
+
+#include <linux/types.h>
+
+struct thread;
+struct ip_callchain;
+
+int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
+			u64 to_ip, u16 insn_len, u64 trace_nr);
+void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
+			  size_t sz, u64 ip);
+void thread_stack__free(struct thread *thread);
+
+#endif
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index bf5bf858b7f6..a2157f0ef1df 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include "session.h"
 #include "thread.h"
+#include "thread-stack.h"
 #include "util.h"
 #include "debug.h"
 #include "comm.h"
@@ -66,6 +67,8 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
+	thread_stack__free(thread);
+
 	if (thread->mg) {
 		map_groups__put(thread->mg);
 		thread->mg = NULL;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index d34cf5c0d0d9..160fd066a7d1 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -8,6 +8,8 @@
 #include "symbol.h"
 #include <strlist.h>
 
+struct thread_stack;
+
 struct thread {
 	union {
 		struct rb_node	 rb_node;
@@ -26,6 +28,7 @@ struct thread {
 	u64			db_id;
 
 	void			*priv;
+	struct thread_stack	*ts;
 };
 
 struct machine;
-- 
1.9.3

