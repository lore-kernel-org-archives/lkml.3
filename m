Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3G3Lcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:32:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab3G3Lbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:55 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0BxkyexcUGIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=o5_efUqTCgsA:10 a=PgUdrdKq0IdpbQO35oIA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113153.179720150@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 7/8] ftrace: Consolidate some duplicate code for updating ftrace ops
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-Consolidate-some-duplicate-code-for-updating-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When ftrace ops modifies the functions that it will trace, the update
to the function mcount callers may need to be modified. Consolidate
the two places that do the checks to see if an update is required
with a wrapper function for those checks.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8ce9eef..92d3334 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3384,6 +3384,12 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 	return add_hash_entry(hash, ip);
 }
 
+static void ftrace_ops_update_code(struct ftrace_ops *ops)
+{
+	if (ops->flags & FTRACE_OPS_FL_ENABLED && ftrace_enabled)
+		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+}
+
 static int
 ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 		unsigned long ip, int remove, int reset, int enable)
@@ -3426,9 +3432,8 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
-	if (!ret && ops->flags & FTRACE_OPS_FL_ENABLED
-	    && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+	if (!ret)
+		ftrace_ops_update_code(ops);
 
 	mutex_unlock(&ftrace_lock);
 
@@ -3655,9 +3660,8 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 		mutex_lock(&ftrace_lock);
 		ret = ftrace_hash_move(iter->ops, filter_hash,
 				       orig_hash, iter->hash);
-		if (!ret && (iter->ops->flags & FTRACE_OPS_FL_ENABLED)
-		    && ftrace_enabled)
-			ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+		if (!ret)
+			ftrace_ops_update_code(iter->ops);
 
 		mutex_unlock(&ftrace_lock);
 	}
-- 
1.7.10.4


