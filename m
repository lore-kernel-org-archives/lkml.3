Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab3C2STB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:19:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab3C2STA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:19:00 -0400
Date: Fri, 29 Mar 2013 19:15:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] uprobes/tracing: Kill the pointless
	local_save_flags/preempt_count calls
Message-ID: <20130329181545.GA20697@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329181520.GA20670@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_trace_func() is never called with irqs or preemption
disabled, no need to ask preempt_count() or local_save_flags().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 8e00901..43d258d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -492,17 +492,13 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	u8 *data;
-	int size, i, pc;
-	unsigned long irq_flags;
+	int size, i;
 	struct ftrace_event_call *call = &tu->call;
 
-	local_save_flags(irq_flags);
-	pc = preempt_count();
-
 	size = sizeof(*entry) + tu->size;
 
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, irq_flags, pc);
+						  size, 0, 0);
 	if (!event)
 		return 0;
 
@@ -513,7 +509,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
 
 	return 0;
 }
-- 
1.5.5.1

