Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaFMHYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:24:13 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43002 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFMHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:24:12 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/4] tracing: Improve message of empty set_ftrace_notrace file
Date: Fri, 13 Jun 2014 16:24:06 +0900
Message-Id: <1402644246-4649-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20140612152759.40316084@gandalf.local.home>
References: <20140612152759.40316084@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there's no entry in set_ftrace_notrace, it'll print nothing, but
it's better to print something like below like set_graph_notrace does:

  #### no functions disabled ####

Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
also updated the ftrace/nograph-v3 branch..

 kernel/trace/ftrace.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b375cf2cd786..ff402e092df1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2593,8 +2593,10 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER &&
-	    ftrace_hash_empty(ops->filter_hash)) {
+	if ((iter->flags & FTRACE_ITER_FILTER &&
+	     ftrace_hash_empty(ops->filter_hash)) ||
+	    (iter->flags & FTRACE_ITER_NOTRACE &&
+	     ftrace_hash_empty(ops->notrace_hash))) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
@@ -2639,7 +2641,10 @@ static int t_show(struct seq_file *m, void *v)
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

