Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaBUCwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:52:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23969 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753323AbaBUCuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:07 -0500
Message-Id: <20140221025003.281354835@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 15/18] tracing/uprobes: Support event triggering
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0015-tracing-uprobes-Support-event-triggering.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Add support for event triggering to uprobes.  This is same as kprobes
support added by Tom (plus cleanup by Steven).

Link: http://lkml.kernel.org/r/1389946120-19610-5-git-send-email-namhyung@kernel.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 349c6df..01fcb0d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -776,6 +776,9 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 	if (WARN_ON_ONCE(tu->tp.size + dsize > PAGE_SIZE))
 		return;
 
+	if (ftrace_trigger_soft_disabled(ftrace_file))
+		return;
+
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = esize + tu->tp.size + dsize;
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
@@ -795,8 +798,7 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 
 	memcpy(data, ucb->buf, tu->tp.size + dsize);
 
-	if (!call_filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry, 0, 0);
 }
 
 /* uprobe handler */
-- 
1.8.5.3


