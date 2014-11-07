Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaKGF3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:29:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaKGF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:29:37 -0500
Date: Thu, 6 Nov 2014 21:28:20 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-92a9e4f7db89a013e1bdef2e548928fc71e9867c@git.kernel.org>
Cc: namhyung@gmail.com, acme@redhat.com, paulus@samba.org, eranian@google.com,
        hpa@zytor.com, jolsa@kernel.org, mingo@kernel.org,
        peterz@infradead.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, adrian.hunter@intel.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        fweisbec@gmail.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        eranian@google.com, paulus@samba.org, mingo@kernel.org,
        peterz@infradead.org, jolsa@kernel.org, hpa@zytor.com, acme@redhat.com,
        namhyung@gmail.com
In-Reply-To: <1414678188-14946-5-git-send-email-adrian.hunter@intel.com>
References: <1414678188-14946-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Enhance the thread stack to output call/return data
Git-Commit-ID: 92a9e4f7db89a013e1bdef2e548928fc71e9867c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92a9e4f7db89a013e1bdef2e548928fc71e9867c
Gitweb:     http://git.kernel.org/tip/92a9e4f7db89a013e1bdef2e548928fc71e9867c
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 30 Oct 2014 16:09:45 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 3 Nov 2014 17:43:56 -0300

perf tools: Enhance the thread stack to output call/return data

Enhance the thread stack to output detailed information about paired
calls and returns.

The enhanced processing consumes sample information via
thread_stack__process() and outputs information about paired calls /
returns via a call-back.

While the call-back makes it possible for the facility to be used by
arbitrary tools, a subsequent patch will provide the information to
Python scripting via the db-export interface.

An important part of the call/return information is the
call path which provides a structure that defines a context
sensitive call graph.

Note that there are now two ways to use the thread stack.

For simply providing a call stack (like you would get from the perf
record -g option) the interface consists of thread_stack__event() and
thread_stack__sample().

Whereas the enhanced interface consists of call_return_processor__new()
and thread_stack__process().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414678188-14946-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread-stack.c | 585 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/thread-stack.h |  79 ++++++
 2 files changed, 659 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
index 85b60d2..9ed59a4 100644
--- a/tools/perf/util/thread-stack.c
+++ b/tools/perf/util/thread-stack.c
@@ -13,23 +13,96 @@
  *
  */
 
+#include <linux/rbtree.h>
+#include <linux/list.h>
 #include "thread.h"
 #include "event.h"
+#include "machine.h"
 #include "util.h"
 #include "debug.h"
+#include "symbol.h"
+#include "comm.h"
 #include "thread-stack.h"
 
-#define STACK_GROWTH 4096
+#define CALL_PATH_BLOCK_SHIFT 8
+#define CALL_PATH_BLOCK_SIZE (1 << CALL_PATH_BLOCK_SHIFT)
+#define CALL_PATH_BLOCK_MASK (CALL_PATH_BLOCK_SIZE - 1)
 
+struct call_path_block {
+	struct call_path cp[CALL_PATH_BLOCK_SIZE];
+	struct list_head node;
+};
+
+/**
+ * struct call_path_root - root of all call paths.
+ * @call_path: root call path
+ * @blocks: list of blocks to store call paths
+ * @next: next free space
+ * @sz: number of spaces
+ */
+struct call_path_root {
+	struct call_path call_path;
+	struct list_head blocks;
+	size_t next;
+	size_t sz;
+};
+
+/**
+ * struct call_return_processor - provides a call-back to consume call-return
+ *                                information.
+ * @cpr: call path root
+ * @process: call-back that accepts call/return information
+ * @data: anonymous data for call-back
+ */
+struct call_return_processor {
+	struct call_path_root *cpr;
+	int (*process)(struct call_return *cr, void *data);
+	void *data;
+};
+
+#define STACK_GROWTH 2048
+
+/**
+ * struct thread_stack_entry - thread stack entry.
+ * @ret_addr: return address
+ * @timestamp: timestamp (if known)
+ * @ref: external reference (e.g. db_id of sample)
+ * @branch_count: the branch count when the entry was created
+ * @cp: call path
+ * @no_call: a 'call' was not seen
+ */
 struct thread_stack_entry {
 	u64 ret_addr;
+	u64 timestamp;
+	u64 ref;
+	u64 branch_count;
+	struct call_path *cp;
+	bool no_call;
 };
 
+/**
+ * struct thread_stack - thread stack constructed from 'call' and 'return'
+ *                       branch samples.
+ * @stack: array that holds the stack
+ * @cnt: number of entries in the stack
+ * @sz: current maximum stack size
+ * @trace_nr: current trace number
+ * @branch_count: running branch count
+ * @kernel_start: kernel start address
+ * @last_time: last timestamp
+ * @crp: call/return processor
+ * @comm: current comm
+ */
 struct thread_stack {
 	struct thread_stack_entry *stack;
 	size_t cnt;
 	size_t sz;
 	u64 trace_nr;
+	u64 branch_count;
+	u64 kernel_start;
+	u64 last_time;
+	struct call_return_processor *crp;
+	struct comm *comm;
 };
 
 static int thread_stack__grow(struct thread_stack *ts)
@@ -50,7 +123,8 @@ static int thread_stack__grow(struct thread_stack *ts)
 	return 0;
 }
 
-static struct thread_stack *thread_stack__new(void)
+static struct thread_stack *thread_stack__new(struct thread *thread,
+					      struct call_return_processor *crp)
 {
 	struct thread_stack *ts;
 
@@ -63,6 +137,12 @@ static struct thread_stack *thread_stack__new(void)
 		return NULL;
 	}
 
+	if (thread->mg && thread->mg->machine)
+		ts->kernel_start = machine__kernel_start(thread->mg->machine);
+	else
+		ts->kernel_start = 1ULL << 63;
+	ts->crp = crp;
+
 	return ts;
 }
 
@@ -104,6 +184,64 @@ static void thread_stack__pop(struct thread_stack *ts, u64 ret_addr)
 	}
 }
 
+static bool thread_stack__in_kernel(struct thread_stack *ts)
+{
+	if (!ts->cnt)
+		return false;
+
+	return ts->stack[ts->cnt - 1].cp->in_kernel;
+}
+
+static int thread_stack__call_return(struct thread *thread,
+				     struct thread_stack *ts, size_t idx,
+				     u64 timestamp, u64 ref, bool no_return)
+{
+	struct call_return_processor *crp = ts->crp;
+	struct thread_stack_entry *tse;
+	struct call_return cr = {
+		.thread = thread,
+		.comm = ts->comm,
+		.db_id = 0,
+	};
+
+	tse = &ts->stack[idx];
+	cr.cp = tse->cp;
+	cr.call_time = tse->timestamp;
+	cr.return_time = timestamp;
+	cr.branch_count = ts->branch_count - tse->branch_count;
+	cr.call_ref = tse->ref;
+	cr.return_ref = ref;
+	if (tse->no_call)
+		cr.flags |= CALL_RETURN_NO_CALL;
+	if (no_return)
+		cr.flags |= CALL_RETURN_NO_RETURN;
+
+	return crp->process(&cr, crp->data);
+}
+
+static int thread_stack__flush(struct thread *thread, struct thread_stack *ts)
+{
+	struct call_return_processor *crp = ts->crp;
+	int err;
+
+	if (!crp) {
+		ts->cnt = 0;
+		return 0;
+	}
+
+	while (ts->cnt) {
+		err = thread_stack__call_return(thread, ts, --ts->cnt,
+						ts->last_time, 0, true);
+		if (err) {
+			pr_err("Error flushing thread stack!\n");
+			ts->cnt = 0;
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 			u64 to_ip, u16 insn_len, u64 trace_nr)
 {
@@ -111,7 +249,7 @@ int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 		return -EINVAL;
 
 	if (!thread->ts) {
-		thread->ts = thread_stack__new();
+		thread->ts = thread_stack__new(thread, NULL);
 		if (!thread->ts) {
 			pr_warning("Out of memory: no thread stack\n");
 			return -ENOMEM;
@@ -122,13 +260,18 @@ int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 	/*
 	 * When the trace is discontinuous, the trace_nr changes.  In that case
 	 * the stack might be completely invalid.  Better to report nothing than
-	 * to report something misleading, so reset the stack count to zero.
+	 * to report something misleading, so flush the stack.
 	 */
 	if (trace_nr != thread->ts->trace_nr) {
+		if (thread->ts->trace_nr)
+			thread_stack__flush(thread, thread->ts);
 		thread->ts->trace_nr = trace_nr;
-		thread->ts->cnt = 0;
 	}
 
+	/* Stop here if thread_stack__process() is in use */
+	if (thread->ts->crp)
+		return 0;
+
 	if (flags & PERF_IP_FLAG_CALL) {
 		u64 ret_addr;
 
@@ -147,9 +290,22 @@ int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 	return 0;
 }
 
+void thread_stack__set_trace_nr(struct thread *thread, u64 trace_nr)
+{
+	if (!thread || !thread->ts)
+		return;
+
+	if (trace_nr != thread->ts->trace_nr) {
+		if (thread->ts->trace_nr)
+			thread_stack__flush(thread, thread->ts);
+		thread->ts->trace_nr = trace_nr;
+	}
+}
+
 void thread_stack__free(struct thread *thread)
 {
 	if (thread->ts) {
+		thread_stack__flush(thread, thread->ts);
 		zfree(&thread->ts->stack);
 		zfree(&thread->ts);
 	}
@@ -170,3 +326,422 @@ void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
 	for (i = 1; i < chain->nr; i++)
 		chain->ips[i] = thread->ts->stack[thread->ts->cnt - i].ret_addr;
 }
+
+static void call_path__init(struct call_path *cp, struct call_path *parent,
+			    struct symbol *sym, u64 ip, bool in_kernel)
+{
+	cp->parent = parent;
+	cp->sym = sym;
+	cp->ip = sym ? 0 : ip;
+	cp->db_id = 0;
+	cp->in_kernel = in_kernel;
+	RB_CLEAR_NODE(&cp->rb_node);
+	cp->children = RB_ROOT;
+}
+
+static struct call_path_root *call_path_root__new(void)
+{
+	struct call_path_root *cpr;
+
+	cpr = zalloc(sizeof(struct call_path_root));
+	if (!cpr)
+		return NULL;
+	call_path__init(&cpr->call_path, NULL, NULL, 0, false);
+	INIT_LIST_HEAD(&cpr->blocks);
+	return cpr;
+}
+
+static void call_path_root__free(struct call_path_root *cpr)
+{
+	struct call_path_block *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &cpr->blocks, node) {
+		list_del(&pos->node);
+		free(pos);
+	}
+	free(cpr);
+}
+
+static struct call_path *call_path__new(struct call_path_root *cpr,
+					struct call_path *parent,
+					struct symbol *sym, u64 ip,
+					bool in_kernel)
+{
+	struct call_path_block *cpb;
+	struct call_path *cp;
+	size_t n;
+
+	if (cpr->next < cpr->sz) {
+		cpb = list_last_entry(&cpr->blocks, struct call_path_block,
+				      node);
+	} else {
+		cpb = zalloc(sizeof(struct call_path_block));
+		if (!cpb)
+			return NULL;
+		list_add_tail(&cpb->node, &cpr->blocks);
+		cpr->sz += CALL_PATH_BLOCK_SIZE;
+	}
+
+	n = cpr->next++ & CALL_PATH_BLOCK_MASK;
+	cp = &cpb->cp[n];
+
+	call_path__init(cp, parent, sym, ip, in_kernel);
+
+	return cp;
+}
+
+static struct call_path *call_path__findnew(struct call_path_root *cpr,
+					    struct call_path *parent,
+					    struct symbol *sym, u64 ip, u64 ks)
+{
+	struct rb_node **p;
+	struct rb_node *node_parent = NULL;
+	struct call_path *cp;
+	bool in_kernel = ip >= ks;
+
+	if (sym)
+		ip = 0;
+
+	if (!parent)
+		return call_path__new(cpr, parent, sym, ip, in_kernel);
+
+	p = &parent->children.rb_node;
+	while (*p != NULL) {
+		node_parent = *p;
+		cp = rb_entry(node_parent, struct call_path, rb_node);
+
+		if (cp->sym == sym && cp->ip == ip)
+			return cp;
+
+		if (sym < cp->sym || (sym == cp->sym && ip < cp->ip))
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	cp = call_path__new(cpr, parent, sym, ip, in_kernel);
+	if (!cp)
+		return NULL;
+
+	rb_link_node(&cp->rb_node, node_parent, p);
+	rb_insert_color(&cp->rb_node, &parent->children);
+
+	return cp;
+}
+
+struct call_return_processor *
+call_return_processor__new(int (*process)(struct call_return *cr, void *data),
+			   void *data)
+{
+	struct call_return_processor *crp;
+
+	crp = zalloc(sizeof(struct call_return_processor));
+	if (!crp)
+		return NULL;
+	crp->cpr = call_path_root__new();
+	if (!crp->cpr)
+		goto out_free;
+	crp->process = process;
+	crp->data = data;
+	return crp;
+
+out_free:
+	free(crp);
+	return NULL;
+}
+
+void call_return_processor__free(struct call_return_processor *crp)
+{
+	if (crp) {
+		call_path_root__free(crp->cpr);
+		free(crp);
+	}
+}
+
+static int thread_stack__push_cp(struct thread_stack *ts, u64 ret_addr,
+				 u64 timestamp, u64 ref, struct call_path *cp,
+				 bool no_call)
+{
+	struct thread_stack_entry *tse;
+	int err;
+
+	if (ts->cnt == ts->sz) {
+		err = thread_stack__grow(ts);
+		if (err)
+			return err;
+	}
+
+	tse = &ts->stack[ts->cnt++];
+	tse->ret_addr = ret_addr;
+	tse->timestamp = timestamp;
+	tse->ref = ref;
+	tse->branch_count = ts->branch_count;
+	tse->cp = cp;
+	tse->no_call = no_call;
+
+	return 0;
+}
+
+static int thread_stack__pop_cp(struct thread *thread, struct thread_stack *ts,
+				u64 ret_addr, u64 timestamp, u64 ref,
+				struct symbol *sym)
+{
+	int err;
+
+	if (!ts->cnt)
+		return 1;
+
+	if (ts->cnt == 1) {
+		struct thread_stack_entry *tse = &ts->stack[0];
+
+		if (tse->cp->sym == sym)
+			return thread_stack__call_return(thread, ts, --ts->cnt,
+							 timestamp, ref, false);
+	}
+
+	if (ts->stack[ts->cnt - 1].ret_addr == ret_addr) {
+		return thread_stack__call_return(thread, ts, --ts->cnt,
+						 timestamp, ref, false);
+	} else {
+		size_t i = ts->cnt - 1;
+
+		while (i--) {
+			if (ts->stack[i].ret_addr != ret_addr)
+				continue;
+			i += 1;
+			while (ts->cnt > i) {
+				err = thread_stack__call_return(thread, ts,
+								--ts->cnt,
+								timestamp, ref,
+								true);
+				if (err)
+					return err;
+			}
+			return thread_stack__call_return(thread, ts, --ts->cnt,
+							 timestamp, ref, false);
+		}
+	}
+
+	return 1;
+}
+
+static int thread_stack__bottom(struct thread *thread, struct thread_stack *ts,
+				struct perf_sample *sample,
+				struct addr_location *from_al,
+				struct addr_location *to_al, u64 ref)
+{
+	struct call_path_root *cpr = ts->crp->cpr;
+	struct call_path *cp;
+	struct symbol *sym;
+	u64 ip;
+
+	if (sample->ip) {
+		ip = sample->ip;
+		sym = from_al->sym;
+	} else if (sample->addr) {
+		ip = sample->addr;
+		sym = to_al->sym;
+	} else {
+		return 0;
+	}
+
+	cp = call_path__findnew(cpr, &cpr->call_path, sym, ip,
+				ts->kernel_start);
+	if (!cp)
+		return -ENOMEM;
+
+	return thread_stack__push_cp(thread->ts, ip, sample->time, ref, cp,
+				     true);
+}
+
+static int thread_stack__no_call_return(struct thread *thread,
+					struct thread_stack *ts,
+					struct perf_sample *sample,
+					struct addr_location *from_al,
+					struct addr_location *to_al, u64 ref)
+{
+	struct call_path_root *cpr = ts->crp->cpr;
+	struct call_path *cp, *parent;
+	u64 ks = ts->kernel_start;
+	int err;
+
+	if (sample->ip >= ks && sample->addr < ks) {
+		/* Return to userspace, so pop all kernel addresses */
+		while (thread_stack__in_kernel(ts)) {
+			err = thread_stack__call_return(thread, ts, --ts->cnt,
+							sample->time, ref,
+							true);
+			if (err)
+				return err;
+		}
+
+		/* If the stack is empty, push the userspace address */
+		if (!ts->cnt) {
+			cp = call_path__findnew(cpr, &cpr->call_path,
+						to_al->sym, sample->addr,
+						ts->kernel_start);
+			if (!cp)
+				return -ENOMEM;
+			return thread_stack__push_cp(ts, 0, sample->time, ref,
+						     cp, true);
+		}
+	} else if (thread_stack__in_kernel(ts) && sample->ip < ks) {
+		/* Return to userspace, so pop all kernel addresses */
+		while (thread_stack__in_kernel(ts)) {
+			err = thread_stack__call_return(thread, ts, --ts->cnt,
+							sample->time, ref,
+							true);
+			if (err)
+				return err;
+		}
+	}
+
+	if (ts->cnt)
+		parent = ts->stack[ts->cnt - 1].cp;
+	else
+		parent = &cpr->call_path;
+
+	/* This 'return' had no 'call', so push and pop top of stack */
+	cp = call_path__findnew(cpr, parent, from_al->sym, sample->ip,
+				ts->kernel_start);
+	if (!cp)
+		return -ENOMEM;
+
+	err = thread_stack__push_cp(ts, sample->addr, sample->time, ref, cp,
+				    true);
+	if (err)
+		return err;
+
+	return thread_stack__pop_cp(thread, ts, sample->addr, sample->time, ref,
+				    to_al->sym);
+}
+
+static int thread_stack__trace_begin(struct thread *thread,
+				     struct thread_stack *ts, u64 timestamp,
+				     u64 ref)
+{
+	struct thread_stack_entry *tse;
+	int err;
+
+	if (!ts->cnt)
+		return 0;
+
+	/* Pop trace end */
+	tse = &ts->stack[ts->cnt - 1];
+	if (tse->cp->sym == NULL && tse->cp->ip == 0) {
+		err = thread_stack__call_return(thread, ts, --ts->cnt,
+						timestamp, ref, false);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int thread_stack__trace_end(struct thread_stack *ts,
+				   struct perf_sample *sample, u64 ref)
+{
+	struct call_path_root *cpr = ts->crp->cpr;
+	struct call_path *cp;
+	u64 ret_addr;
+
+	/* No point having 'trace end' on the bottom of the stack */
+	if (!ts->cnt || (ts->cnt == 1 && ts->stack[0].ref == ref))
+		return 0;
+
+	cp = call_path__findnew(cpr, ts->stack[ts->cnt - 1].cp, NULL, 0,
+				ts->kernel_start);
+	if (!cp)
+		return -ENOMEM;
+
+	ret_addr = sample->ip + sample->insn_len;
+
+	return thread_stack__push_cp(ts, ret_addr, sample->time, ref, cp,
+				     false);
+}
+
+int thread_stack__process(struct thread *thread, struct comm *comm,
+			  struct perf_sample *sample,
+			  struct addr_location *from_al,
+			  struct addr_location *to_al, u64 ref,
+			  struct call_return_processor *crp)
+{
+	struct thread_stack *ts = thread->ts;
+	int err = 0;
+
+	if (ts) {
+		if (!ts->crp) {
+			/* Supersede thread_stack__event() */
+			thread_stack__free(thread);
+			thread->ts = thread_stack__new(thread, crp);
+			if (!thread->ts)
+				return -ENOMEM;
+			ts = thread->ts;
+			ts->comm = comm;
+		}
+	} else {
+		thread->ts = thread_stack__new(thread, crp);
+		if (!thread->ts)
+			return -ENOMEM;
+		ts = thread->ts;
+		ts->comm = comm;
+	}
+
+	/* Flush stack on exec */
+	if (ts->comm != comm && thread->pid_ == thread->tid) {
+		err = thread_stack__flush(thread, ts);
+		if (err)
+			return err;
+		ts->comm = comm;
+	}
+
+	/* If the stack is empty, put the current symbol on the stack */
+	if (!ts->cnt) {
+		err = thread_stack__bottom(thread, ts, sample, from_al, to_al,
+					   ref);
+		if (err)
+			return err;
+	}
+
+	ts->branch_count += 1;
+	ts->last_time = sample->time;
+
+	if (sample->flags & PERF_IP_FLAG_CALL) {
+		struct call_path_root *cpr = ts->crp->cpr;
+		struct call_path *cp;
+		u64 ret_addr;
+
+		if (!sample->ip || !sample->addr)
+			return 0;
+
+		ret_addr = sample->ip + sample->insn_len;
+		if (ret_addr == sample->addr)
+			return 0; /* Zero-length calls are excluded */
+
+		cp = call_path__findnew(cpr, ts->stack[ts->cnt - 1].cp,
+					to_al->sym, sample->addr,
+					ts->kernel_start);
+		if (!cp)
+			return -ENOMEM;
+		err = thread_stack__push_cp(ts, ret_addr, sample->time, ref,
+					    cp, false);
+	} else if (sample->flags & PERF_IP_FLAG_RETURN) {
+		if (!sample->ip || !sample->addr)
+			return 0;
+
+		err = thread_stack__pop_cp(thread, ts, sample->addr,
+					   sample->time, ref, from_al->sym);
+		if (err) {
+			if (err < 0)
+				return err;
+			err = thread_stack__no_call_return(thread, ts, sample,
+							   from_al, to_al, ref);
+		}
+	} else if (sample->flags & PERF_IP_FLAG_TRACE_BEGIN) {
+		err = thread_stack__trace_begin(thread, ts, sample->time, ref);
+	} else if (sample->flags & PERF_IP_FLAG_TRACE_END) {
+		err = thread_stack__trace_end(ts, sample, ref);
+	}
+
+	return err;
+}
diff --git a/tools/perf/util/thread-stack.h b/tools/perf/util/thread-stack.h
index 7c41579..b843bbe 100644
--- a/tools/perf/util/thread-stack.h
+++ b/tools/perf/util/thread-stack.h
@@ -19,14 +19,93 @@
 #include <sys/types.h>
 
 #include <linux/types.h>
+#include <linux/rbtree.h>
 
 struct thread;
+struct comm;
 struct ip_callchain;
+struct symbol;
+struct dso;
+struct call_return_processor;
+struct comm;
+struct perf_sample;
+struct addr_location;
+
+/*
+ * Call/Return flags.
+ *
+ * CALL_RETURN_NO_CALL: 'return' but no matching 'call'
+ * CALL_RETURN_NO_RETURN: 'call' but no matching 'return'
+ */
+enum {
+	CALL_RETURN_NO_CALL	= 1 << 0,
+	CALL_RETURN_NO_RETURN	= 1 << 1,
+};
+
+/**
+ * struct call_return - paired call/return information.
+ * @thread: thread in which call/return occurred
+ * @comm: comm in which call/return occurred
+ * @cp: call path
+ * @call_time: timestamp of call (if known)
+ * @return_time: timestamp of return (if known)
+ * @branch_count: number of branches seen between call and return
+ * @call_ref: external reference to 'call' sample (e.g. db_id)
+ * @return_ref:  external reference to 'return' sample (e.g. db_id)
+ * @db_id: id used for db-export
+ * @flags: Call/Return flags
+ */
+struct call_return {
+	struct thread *thread;
+	struct comm *comm;
+	struct call_path *cp;
+	u64 call_time;
+	u64 return_time;
+	u64 branch_count;
+	u64 call_ref;
+	u64 return_ref;
+	u64 db_id;
+	u32 flags;
+};
+
+/**
+ * struct call_path - node in list of calls leading to a function call.
+ * @parent: call path to the parent function call
+ * @sym: symbol of function called
+ * @ip: only if sym is null, the ip of the function
+ * @db_id: id used for db-export
+ * @in_kernel: whether function is a in the kernel
+ * @rb_node: node in parent's tree of called functions
+ * @children: tree of call paths of functions called
+ *
+ * In combination with the call_return structure, the call_path structure
+ * defines a context-sensitve call-graph.
+ */
+struct call_path {
+	struct call_path *parent;
+	struct symbol *sym;
+	u64 ip;
+	u64 db_id;
+	bool in_kernel;
+	struct rb_node rb_node;
+	struct rb_root children;
+};
 
 int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 			u64 to_ip, u16 insn_len, u64 trace_nr);
+void thread_stack__set_trace_nr(struct thread *thread, u64 trace_nr);
 void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
 			  size_t sz, u64 ip);
 void thread_stack__free(struct thread *thread);
 
+struct call_return_processor *
+call_return_processor__new(int (*process)(struct call_return *cr, void *data),
+			   void *data);
+void call_return_processor__free(struct call_return_processor *crp);
+int thread_stack__process(struct thread *thread, struct comm *comm,
+			  struct perf_sample *sample,
+			  struct addr_location *from_al,
+			  struct addr_location *to_al, u64 ref,
+			  struct call_return_processor *crp);
+
 #endif
