Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3DMOIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:08:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3DMOIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:08:46 -0400
Date: Sat, 13 Apr 2013 16:02:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: [PATCH 1/1] uprobes/perf: Avoid perf_trace_buf_prepare/submit if
	->perf_events is empty
Message-ID: <20130413140251.GB32273@redhat.com>
References: <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com> <20130410145818.GA30670@redhat.com> <516692BF.6070904@hitachi.com> <20130411115921.GA27492@redhat.com> <1365801588.9609.95.camel@gandalf.local.home> <20130413140234.GA32273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413140234.GA32273@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_trace_buf_prepare() + perf_trace_buf_submit() make no sense
if this task/CPU has no active counters. Change uprobe_perf_print()
to return if hlist_empty(call->perf_events).

Note: this is not uprobe-specific, we can change other users too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 37ccb72..32494fb 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -820,6 +820,10 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		return;
 
 	preempt_disable();
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		goto out;
+
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
 		goto out;
@@ -836,7 +840,6 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
-	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
-- 
1.5.5.1


