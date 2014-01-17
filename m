Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaAQIJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:09:05 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42209 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAQIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:08:50 -0500
X-AuditID: 9c930197-b7b7cae000000e34-14-52d8e50db5b0
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 4/5] tracing/uprobes: Support event triggering
Date: Fri, 17 Jan 2014 17:08:39 +0900
Message-Id: <1389946120-19610-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for event triggering to uprobes.  This is same as kprobes
support added by Tom (plus cleanup by Steven).

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 349c6df9e332..01fcb0db75cb 100644
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
1.7.11.7

