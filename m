Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab3GCMiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:38:21 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52553 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab3GCMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:55 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-f1-51d41aa54ab0
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 08/12] tracing/uprobes: Fetch args before reserving a ring buffer
Date: Wed,  3 Jul 2013 21:35:42 +0900
Message-Id: <1372854946-17074-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Fetching from user space should be done in a non-atomic context.  So
use a temporary buffer and copy its content to the ring buffer
atomically.

While at it, use __get_data_size() and store_trace_args() to reduce
code duplication.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 69 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index e4e294d61bec..8611b3289393 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -514,15 +514,31 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	void *data;
-	int size, i;
+	void *data, *tmp;
+	int size, dsize, esize;
 	struct ftrace_event_call *call = &tu->p.call;
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+	dsize = __get_data_size(&tu->p, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	/*
+	 * A temporary buffer is used for storing fetched data before reserving
+	 * the ring buffer because fetching from user space should be done in a
+	 * non-atomic context.
+	 */
+	tmp = kmalloc(tu->p.size + dsize, GFP_KERNEL);
+	if (tmp == NULL)
+		return;
+
+	store_trace_args(esize, &tu->p, regs, tmp, dsize);
+
+	size = esize + tu->p.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size + tu->p.size, 0, 0);
-	if (!event)
+						  size, 0, 0);
+	if (!event) {
+		kfree(tmp);
 		return;
+	}
 
 	entry = ring_buffer_event_data(event);
 	if (is_ret_probe(tu)) {
@@ -534,13 +550,12 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->p.nr_args; i++) {
-		call_fetch(&tu->p.args[i].fetch, regs,
-			   data + tu->p.args[i].offset);
-	}
+	memcpy(data, tmp, tu->p.size + dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
+
+	kfree(tmp);
 }
 
 /* uprobe handler */
@@ -754,13 +769,30 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	struct ftrace_event_call *call = &tu->p.call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
-	void *data;
-	int size, rctx, i;
+	void *data, *tmp;
+	int size, dsize, esize;
+	int rctx;
+
+	dsize = __get_data_size(&tu->p, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	/*
+	 * A temporary buffer is used for storing fetched data before reserving
+	 * the ring buffer because fetching from user space should be done in a
+	 * non-atomic context.
+	 */
+	tmp = kmalloc(tu->p.size + dsize, GFP_KERNEL);
+	if (tmp == NULL)
+		return;
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-	size = ALIGN(size + tu->p.size + sizeof(u32), sizeof(u64)) - sizeof(u32);
-	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
+	store_trace_args(esize, &tu->p, regs, tmp, dsize);
+
+	size = esize + tu->p.size + dsize;
+	size = ALIGN(size + + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough")) {
+		kfree(tmp);
 		return;
+	}
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
@@ -780,15 +812,18 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->p.nr_args; i++) {
-		struct probe_arg *parg = &tu->p.args[i];
+	memcpy(data, tmp, tu->p.size + dsize);
+
+	if (size - esize > tu->p.size + dsize) {
+		int len = tu->p.size + dsize;
 
-		call_fetch(&parg->fetch, regs, data + parg->offset);
+		memset(data + len, 0, size - esize - len);
 	}
 
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
+	kfree(tmp);
 }
 
 /* uprobe profile handler */
-- 
1.7.11.7

