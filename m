Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3C2SSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab3C2SSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:18:05 -0400
Date: Fri, 29 Mar 2013 19:15:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] uprobes/tracing: Kill the pointless task_pt_regs()
	calls
Message-ID: <20130329181540.GA20687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329181520.GA20670@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_trace_func() and uprobe_perf_func() do not need task_pt_regs(),
we already have "struct pt_regs *regs".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 8dad2a9..af5b773 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -507,7 +507,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 		return 0;
 
 	entry = ring_buffer_event_data(event);
-	entry->ip = instruction_pointer(task_pt_regs(current));
+	entry->ip = instruction_pointer(regs);
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
@@ -777,7 +777,7 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	if (!entry)
 		goto out;
 
-	entry->ip = instruction_pointer(task_pt_regs(current));
+	entry->ip = instruction_pointer(regs);
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
-- 
1.5.5.1

