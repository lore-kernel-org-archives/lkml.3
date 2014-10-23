Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaJWKtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:49:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:60790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbaJWKr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:47:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594446058"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/16] perf tools: Enhance the thread stack to output call/return data
Date: Thu, 23 Oct 2014 13:45:18 +0300
Message-Id: <1414061124-26830-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the thread stack to output detailed information
about paired calls and returns.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/thread-stack.c | 547 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/thread-stack.h |  47 ++++
 2 files changed, 590 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
index c1ca2a9..444d132 100644
--- a/tools/perf/util/thread-stack.c
+++ b/tools/perf/util/thread-stack.c
@@ -13,15 +13,48 @@
  *
  */
 
+#include <linux/rbtree.h>
+#include <linux/list.h>
 #include "thread.h"
 #include "event.h"
+#include "machine.h"
 #include "util.h"
+#include "debug.h"
+#include "symbol.h"
+#include "comm.h"
 #include "thread-stack.h"
 
-#define STACK_GROWTH 4096
+#define CALL_PATH_BLOCK_SHIFT 8
+#define CALL_PATH_BLOCK_SIZE (1 << CALL_PATH_BLOCK_SHIFT)
+#define CALL_PATH_BLOCK_MASK (CALL_PATH_BLOCK_SIZE - 1)
+
+struct call_path_block {
+	struct call_path cp[CALL_PATH_BLOCK_SIZE];
+	struct list_head node;
+};
+
+struct call_path_root {
+	struct call_path call_path;
+	struct list_head blocks;
+	size_t next;
+	size_t sz;
+};
+
+struct call_return_processor {
+	struct call_path_root *cpr;
+	int (*process)(struct call_return *cr, void *data);
+	void *data;
+};
+
+#define STACK_GROWTH 2048
 
 struct thread_stack_entry {
 	u64 ret_addr;
+	u64 timestamp;
+	u64 ref;
+	u64 branch_count;
+	struct call_path *cp;
+	bool no_call;
 };
 
 struct thread_stack {
@@ -29,6 +62,11 @@ struct thread_stack {
 	size_t cnt;
 	size_t sz;
 	u64 trace_nr;
+	u64 branch_count;
+	u64 kernel_start;
+	u64 last_time;
+	struct call_return_processor *crp;
+	struct comm *comm;
 };
 
 static void thread_stack__grow(struct thread_stack *ts)
@@ -45,7 +83,8 @@ static void thread_stack__grow(struct thread_stack *ts)
 	}
 }
 
-static struct thread_stack *thread_stack__new(void)
+static struct thread_stack *thread_stack__new(struct thread *thread,
+					      struct call_return_processor *crp)
 {
 	struct thread_stack *ts;
 
@@ -59,6 +98,12 @@ static struct thread_stack *thread_stack__new(void)
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
 
@@ -92,6 +137,64 @@ static void thread_stack__pop(struct thread_stack *ts, u64 ret_addr)
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
 void thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 			 u64 to_ip, u16 insn_len, u64 trace_nr)
 {
@@ -99,17 +202,22 @@ void thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 		return;
 
 	if (!thread->ts) {
-		thread->ts = thread_stack__new();
+		thread->ts = thread_stack__new(thread, NULL);
 		if (!thread->ts)
 			return;
 		thread->ts->trace_nr = trace_nr;
 	}
 
 	if (trace_nr != thread->ts->trace_nr) {
+		if (thread->ts->trace_nr)
+			thread_stack__flush(thread, thread->ts);
 		thread->ts->trace_nr = trace_nr;
-		thread->ts->cnt = 0;
 	}
 
+	/* Stop here if thread_stack__process() is in use */
+	if (thread->ts->crp)
+		return;
+
 	if (flags & PERF_FLAG_CALL) {
 		u64 ret_addr;
 
@@ -126,9 +234,22 @@ void thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
 	}
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
@@ -149,3 +270,421 @@ void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
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
+
+	if (ts->cnt == ts->sz) {
+		thread_stack__grow(ts);
+		if (ts->cnt == ts->sz)
+			return -ENOMEM;
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
+	if (sample->flags & PERF_FLAG_CALL) {
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
+	} else if (sample->flags & PERF_FLAG_RETURN) {
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
+	} else if (sample->flags & PERF_FLAG_TRACE_BEGIN) {
+		err = thread_stack__trace_begin(thread, ts, sample->time, ref);
+	} else if (sample->flags & PERF_FLAG_TRACE_END) {
+		err = thread_stack__trace_end(ts, sample, ref);
+	}
+
+	return err;
+}
diff --git a/tools/perf/util/thread-stack.h b/tools/perf/util/thread-stack.h
index c0ba4cf..5bca14e 100644
--- a/tools/perf/util/thread-stack.h
+++ b/tools/perf/util/thread-stack.h
@@ -19,14 +19,61 @@
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
+enum {
+	CALL_RETURN_NO_CALL	= 1 << 0,
+	CALL_RETURN_NO_RETURN	= 1 << 1,
+};
+
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
+struct call_path {
+	struct call_path *parent;
+	struct symbol *sym;
+	u64 ip; /* Only if sym is null */
+	u64 db_id;
+	bool in_kernel;
+	struct rb_node rb_node;
+	struct rb_root children;
+};
 
 void thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
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
-- 
1.9.1

