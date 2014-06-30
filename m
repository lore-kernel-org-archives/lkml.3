Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbaF3VwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:52:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:13588 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751917AbaF3Vvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:51:46 -0400
Message-Id: <20140630215144.888924115@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 30 Jun 2014 17:50:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [for-next][PATCH 3/4] tracing/uprobes: Kill the bogus UPROBE_HANDLER_REMOVE code in
 uprobe_dispatcher()
References: <20140630215038.852406012@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-uprobes-Kill-the-bogus-UPROBE_HANDLER_REMOVE.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

I do not know why dd9fa555d7bb "tracing/uprobes: Move argument fetching
to uprobe_dispatcher()" added the UPROBE_HANDLER_REMOVE, but it looks
wrong.

OK, perhaps it makes sense to avoid store_trace_args() if the tracee is
nacked by uprobe_perf_filter(). But then we should kill the same code
in uprobe_perf_func() and unify the TRACE/PROFILE filtering (we need to
do this anyway to mix perf/ftrace). Until then this code actually adds
the pessimization because uprobe_perf_filter() will be called twice and
return T in likely case.

Link: http://lkml.kernel.org/p/20140627170143.GA18329@redhat.com

Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 08e7970bf3f9..c4cf0abd60ba 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1208,12 +1208,6 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 
 	current->utask->vaddr = (unsigned long) &udd;
 
-#ifdef CONFIG_PERF_EVENTS
-	if ((tu->tp.flags & TP_FLAG_TRACE) == 0 &&
-	    !uprobe_perf_filter(&tu->consumer, 0, current->mm))
-		return UPROBE_HANDLER_REMOVE;
-#endif
-
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
 		return 0;
 
-- 
2.0.0


