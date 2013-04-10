Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936723Ab3DJPG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935753Ab3DJPG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:06:26 -0400
Date: Wed, 10 Apr 2013 16:58:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: [PATCH 1/1] uprobes/tracing: Don't pass addr=ip to
	perf_trace_buf_submit()
Message-ID: <20130410145844.GB30670@redhat.com>
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com> <20130410145818.GA30670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410145818.GA30670@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_perf_print() passes addr=ip to perf_trace_buf_submit() for
no reason. This sets perf_sample_data->addr for PERF_SAMPLE_ADDR,
we already have perf_sample_data->ip initialized if PERF_SAMPLE_IP.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2d08bea..37ccb72 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -811,7 +811,6 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	struct ftrace_event_call *call = &tu->call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
-	unsigned long ip;
 	void *data;
 	int size, rctx, i;
 
@@ -825,13 +824,12 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	if (!entry)
 		goto out;
 
-	ip = instruction_pointer(regs);
 	if (is_ret_probe(tu)) {
 		entry->vaddr[0] = func;
-		entry->vaddr[1] = ip;
+		entry->vaddr[1] = instruction_pointer(regs);
 		data = DATAOF_TRACE_ENTRY(entry, true);
 	} else {
-		entry->vaddr[0] = ip;
+		entry->vaddr[0] = instruction_pointer(regs);
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
@@ -839,7 +837,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
 	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx, ip, 1, regs, head, NULL);
+	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
 }
-- 
1.5.5.1


