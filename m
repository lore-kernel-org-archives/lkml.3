Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3AaTTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:19:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3AaTTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:19:32 -0500
Date: Thu, 31 Jan 2013 20:18:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] uprobes/perf: Always increment trace_uprobe->nhit
Message-ID: <20130131191832.GA30457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131191752.GA30410@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tu->nhit++ from uprobe_trace_func() to uprobe_dispatcher().

->nhit counts how many time we hit the breakpoint inserted by this
uprobe, we do not want to loose this info if uprobe was enabled by
sys_perf_event_open().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 55cdc14..0a9a8de 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -473,8 +473,6 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tu->call;
 
-	tu->nhit++;
-
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
@@ -698,6 +696,7 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	struct trace_uprobe *tu;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
+	tu->nhit++;
 
 	if (tu->flags & TP_FLAG_TRACE)
 		uprobe_trace_func(tu, regs);
-- 
1.5.5.1

