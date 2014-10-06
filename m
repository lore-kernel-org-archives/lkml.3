Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaJFVjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:39:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:14091 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751098AbaJFVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:36:32 -0400
Message-Id: <20141006213630.844645295@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 06 Oct 2014 17:35:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 05/11] ftrace: Grab any ops for a rec for enabled_functions output
References: <20141006213544.344821619@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-ftrace-Grab-any-ops-for-a-rec-for-enabled_functions-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When dumping the enabled_functions, use the first op that is
found with a trampoline to the record, as there should only be
one, as only one ops can be registered to a function that has
a trampoline.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2c4eef49b1af..858ac16f8492 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1901,6 +1901,25 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
 }
 
 static struct ftrace_ops *
+ftrace_find_tramp_ops_any(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *op;
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+
+		if (!op->trampoline)
+			continue;
+
+		if (ftrace_lookup_ip(op->func_hash->filter_hash, rec->ip) &&
+		    (ftrace_hash_empty(op->func_hash->notrace_hash) ||
+		     !ftrace_lookup_ip(op->func_hash->notrace_hash, rec->ip)))
+			return op;
+	} while_for_each_ftrace_op(op);
+
+	return NULL;
+}
+
+static struct ftrace_ops *
 ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
 {
 	struct ftrace_ops *op;
@@ -2966,7 +2985,7 @@ static int t_show(struct seq_file *m, void *v)
 		if (rec->flags & FTRACE_FL_TRAMP_EN) {
 			struct ftrace_ops *ops;
 
-			ops = ftrace_find_tramp_ops_curr(rec);
+			ops = ftrace_find_tramp_ops_any(rec);
 			if (ops && ops->trampoline)
 				seq_printf(m, "\ttramp: %pS",
 					   (void *)ops->trampoline);
-- 
2.0.1


