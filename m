Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaF0SdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:33:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaF0SdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:33:08 -0400
Date: Fri, 27 Jun 2014 19:01:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] tracing/uprobes: Kill the bogus UPROBE_HANDLER_REMOVE
	code in uprobe_dispatcher()
Message-ID: <20140627170143.GA18329@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627170116.GA18298@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not know why dd9fa555d7bb "tracing/uprobes: Move argument fetching
to uprobe_dispatcher()" added the UPROBE_HANDLER_REMOVE, but it looks
wrong.

OK, perhaps it makes sense to avoid store_trace_args() if the tracee is
nacked by uprobe_perf_filter(). But then we should kill the same code
in uprobe_perf_func() and unify the TRACE/PROFILE filtering (we need to
do this anyway to mix perf/ftrace). Until then this code actually adds
the pessimization because uprobe_perf_filter() will be called twice and
return T in likely case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 08e7970..c4cf0ab 100644
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
1.5.5.1

