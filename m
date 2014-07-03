Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbaGCQQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:16:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:3195 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759211AbaGCQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:28 -0400
Message-Id: <20140703161226.830170539@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 20/21] tracing: Improve message of empty set_ftrace_notrace file
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0020-tracing-Improve-message-of-empty-set_ftrace_notrace-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When there's no entry in set_ftrace_notrace, it'll print nothing, but
it's better to print something like below like set_graph_notrace does:

  #### no functions disabled ####

Link: http://lkml.kernel.org/p/1402644246-4649-1-git-send-email-namhyung@kernel.org

Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ee245c0659a6..45aac1a742c5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2835,8 +2835,10 @@ static void *t_start(struct seq_file *m, loff_t *pos)
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
@@ -2881,7 +2883,10 @@ static int t_show(struct seq_file *m, void *v)
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
2.0.0


