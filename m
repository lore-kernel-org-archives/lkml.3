Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaAQIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:09:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60517 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaAQIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:08:50 -0500
X-AuditID: 9c930197-b7b7cae000000e34-1c-52d8e50eb4a3
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 5/5] tracing/uprobes: Support mix of ftrace and perf
Date: Fri, 17 Jan 2014 17:08:40 +0900
Message-Id: <1389946120-19610-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems there's no reason to prevent mixed used of ftrace and perf
for a single uprobe event.  At least the kprobes already support it.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 01fcb0db75cb..e4473367e7a4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -882,9 +882,6 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 	int ret;
 
 	if (file) {
-		if (tu->tp.flags & TP_FLAG_PROFILE)
-			return -EINTR;
-
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link)
 			return -ENOMEM;
@@ -893,12 +890,8 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 		list_add_tail_rcu(&link->list, &tu->tp.files);
 
 		tu->tp.flags |= TP_FLAG_TRACE;
-	} else {
-		if (tu->tp.flags & TP_FLAG_TRACE)
-			return -EINTR;
-
+	} else
 		tu->tp.flags |= TP_FLAG_PROFILE;
-	}
 
 	ret = uprobe_buffer_enable();
 	if (ret < 0)
-- 
1.7.11.7

