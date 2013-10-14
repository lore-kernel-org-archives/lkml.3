Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3JNIZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:25:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58638 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3JNIY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:24:29 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-1a-525baa3c68f6
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/4] ftrace: Narrow down the protected area of graph_lock
Date: Mon, 14 Oct 2013 17:24:25 +0900
Message-Id: <1381739066-7531-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381739066-7531-1-git-send-email-namhyung@kernel.org>
References: <1381739066-7531-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It seems that it doesn't need to hold graph_lock during preparation of
the trace_parser.  At least it makes the code a bit simpler IMHO.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0ff3449b4272..26a229ab0c19 100644
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
1.7.11.7

