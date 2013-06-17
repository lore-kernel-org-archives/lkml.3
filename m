Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3FQRG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:06:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab3FQRG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:06:28 -0400
Date: Mon, 17 Jun 2013 19:02:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tracing/function: Avoid perf_trace_buf_*() if
	event_function.perf_events is empty
Message-ID: <20130617170204.GA19803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617170142.GA19780@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_trace_buf_prepare() + perf_trace_buf_submit(head, task => NULL)
make no sense if hlist_empty(head). Change perf_ftrace_function_call()
to check event_function.perf_events beforehand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_event_perf.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 84b1e04..12df557 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -266,6 +266,10 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 	struct pt_regs regs;
 	int rctx;
 
+	head = this_cpu_ptr(event_function.perf_events);
+	if (hlist_empty(head))
+		return;
+
 #define ENTRY_SIZE (ALIGN(sizeof(struct ftrace_entry) + sizeof(u32), \
 		    sizeof(u64)) - sizeof(u32))
 
@@ -279,8 +283,6 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 
 	entry->ip = ip;
 	entry->parent_ip = parent_ip;
-
-	head = this_cpu_ptr(event_function.perf_events);
 	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
 			      1, &regs, head, NULL);
 
-- 
1.5.5.1

