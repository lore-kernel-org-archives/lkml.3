Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3GVOVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:21:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab3GVOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:21:27 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=D693eyLjtfsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=W6LRzY4cOK8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=9eudB-iudPty_y5Cnl4A:9 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130722142124.713164801@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Jul 2013 10:19:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/14] tracing/function: Avoid perf_trace_buf_*() if
 event_function.perf_events is empty
References: <20130722141947.972915744@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-function-Avoid-perf_trace_buf_-if-event_func.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

perf_trace_buf_prepare() + perf_trace_buf_submit(head, task => NULL)
make no sense if hlist_empty(head). Change perf_ftrace_function_call()
to check event_function.perf_events beforehand.

Link: http://lkml.kernel.org/r/20130617170204.GA19803@redhat.com

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_event_perf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
1.7.10.4


