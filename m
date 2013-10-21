Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3JUCrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:47:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:22710 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752309Ab3JUCqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:46:34 -0400
Message-Id: <20131021024630.984692390@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 20 Oct 2013 22:44:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 5/6] ftrace: Narrow down the protected area of graph_lock
References: <20131021024429.189874455@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Narrow-down-the-protected-area-of-graph_lock.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The parser set up is just a generic utility that uses local variables
allocated by the function. There's no need to hold the graph_lock for
this set up.

This also makes the code simpler.

Link: http://lkml.kernel.org/r/1381739066-7531-4-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0ff3449..26a229a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3973,37 +3973,33 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_parser parser;
-	ssize_t read, ret;
+	ssize_t read, ret = 0;
 	struct ftrace_graph_data *fgd = file->private_data;
 
 	if (!cnt)
 		return 0;
 
-	mutex_lock(&graph_lock);
-
-	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
-		ret = -ENOMEM;
-		goto out_unlock;
-	}
+	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX))
+		return -ENOMEM;
 
 	read = trace_get_user(&parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded((&parser))) {
 		parser.buffer[parser.idx] = 0;
 
+		mutex_lock(&graph_lock);
+
 		/* we allow only one expression at a time */
 		ret = ftrace_set_func(fgd->table, fgd->count, fgd->size,
 				      parser.buffer);
-		if (ret)
-			goto out_free;
+
+		mutex_unlock(&graph_lock);
 	}
 
-	ret = read;
+	if (!ret)
+		ret = read;
 
-out_free:
 	trace_parser_put(&parser);
-out_unlock:
-	mutex_unlock(&graph_lock);
 
 	return ret;
 }
-- 
1.8.4.rc3


