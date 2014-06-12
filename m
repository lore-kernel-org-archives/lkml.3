Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbaFLQYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:24:39 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39949 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbaFLQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:24:04 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing: Improve message of empty set_ftrace_notrace file
Date: Fri, 13 Jun 2014 01:23:52 +0900
Message-Id: <1402590233-22321-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
References: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there's no entry in set_ftrace_notrace, it'll print nothing, but
it's better to print something like below like set_graph_notrace does:

  #### no functions disabled ####

Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b375cf2cd786..566ffa0f3442 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2603,6 +2603,16 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 		return iter;
 	}
 
+	if (iter->flags & FTRACE_ITER_NOTRACE &&
+	    ftrace_hash_empty(ops->notrace_hash)) {
+		if (*pos > 0)
+			return t_hash_start(m, pos);
+		iter->flags |= FTRACE_ITER_PRINTALL;
+		/* reset in case of seek/pread */
+		iter->flags &= ~FTRACE_ITER_HASH;
+		return iter;
+	}
+
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_start(m, pos);
 
@@ -2639,7 +2649,10 @@ static int t_show(struct seq_file *m, void *v)
 		return t_hash_show(m, iter);
 
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
-		seq_printf(m, "#### all functions enabled ####\n");
+		if (iter->flags & FTRACE_ITER_NOTRACE)
+			seq_printf(m, "#### no functions disabled ####\n");
+		else
+			seq_printf(m, "#### all functions enabled ####\n");
 		return 0;
 	}
 
-- 
1.7.9.2

