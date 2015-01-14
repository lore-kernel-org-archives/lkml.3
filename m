Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbbANPoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:44:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13625 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752055AbbANPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:43:32 -0500
Message-Id: <20150114154329.358378039@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 10:40:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/3] ftrace: Check both notrace and filter for old hash
References: <20150114153958.931152836@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftrace-Check-both-notrace-and-filter-for-old-hash.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Using just the filter for checking for trampolines or regs is not enough
when updating the code against the records that represent all functions.
Both the filter hash and the notrace hash need to be checked.

To trigger this bug (using trace-cmd and perf):

 # perf probe -a do_fork
 # trace-cmd start -B foo -e probe
 # trace-cmd record -p function_graph -n do_fork sleep 1

The trace-cmd record at the end clears the filter before it disables
function_graph tracing and then that causes the accounting of the
ftrace function records to become incorrect and causes ftrace to bug.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2b35d0ba578d..224e768bdc73 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2497,12 +2497,14 @@ static void ftrace_run_update_code(int command)
 }
 
 static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
-				   struct ftrace_hash *old_hash)
+				   struct ftrace_ops_hash *old_hash)
 {
 	ops->flags |= FTRACE_OPS_FL_MODIFYING;
-	ops->old_hash.filter_hash = old_hash;
+	ops->old_hash.filter_hash = old_hash->filter_hash;
+	ops->old_hash.notrace_hash = old_hash->notrace_hash;
 	ftrace_run_update_code(command);
 	ops->old_hash.filter_hash = NULL;
+	ops->old_hash.notrace_hash = NULL;
 	ops->flags &= ~FTRACE_OPS_FL_MODIFYING;
 }
 
@@ -3579,7 +3581,7 @@ static struct ftrace_ops trace_probe_ops __read_mostly =
 
 static int ftrace_probe_registered;
 
-static void __enable_ftrace_function_probe(struct ftrace_hash *old_hash)
+static void __enable_ftrace_function_probe(struct ftrace_ops_hash *old_hash)
 {
 	int ret;
 	int i;
@@ -3637,6 +3639,7 @@ int
 register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			      void *data)
 {
+	struct ftrace_ops_hash old_hash_ops;
 	struct ftrace_func_probe *entry;
 	struct ftrace_hash **orig_hash = &trace_probe_ops.func_hash->filter_hash;
 	struct ftrace_hash *old_hash = *orig_hash;
@@ -3658,6 +3661,10 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	mutex_lock(&trace_probe_ops.func_hash->regex_lock);
 
+	old_hash_ops.filter_hash = old_hash;
+	/* Probes only have filters */
+	old_hash_ops.notrace_hash = NULL;
+
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, old_hash);
 	if (!hash) {
 		count = -ENOMEM;
@@ -3718,7 +3725,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
 
-	__enable_ftrace_function_probe(old_hash);
+	__enable_ftrace_function_probe(&old_hash_ops);
 
 	if (!ret)
 		free_ftrace_hash_rcu(old_hash);
@@ -4006,7 +4013,7 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 }
 
 static void ftrace_ops_update_code(struct ftrace_ops *ops,
-				   struct ftrace_hash *old_hash)
+				   struct ftrace_ops_hash *old_hash)
 {
 	struct ftrace_ops *op;
 
@@ -4041,6 +4048,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 		unsigned long ip, int remove, int reset, int enable)
 {
 	struct ftrace_hash **orig_hash;
+	struct ftrace_ops_hash old_hash_ops;
 	struct ftrace_hash *old_hash;
 	struct ftrace_hash *hash;
 	int ret;
@@ -4077,9 +4085,11 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 	mutex_lock(&ftrace_lock);
 	old_hash = *orig_hash;
+	old_hash_ops.filter_hash = ops->func_hash->filter_hash;
+	old_hash_ops.notrace_hash = ops->func_hash->notrace_hash;
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
 	if (!ret) {
-		ftrace_ops_update_code(ops, old_hash);
+		ftrace_ops_update_code(ops, &old_hash_ops);
 		free_ftrace_hash_rcu(old_hash);
 	}
 	mutex_unlock(&ftrace_lock);
@@ -4291,6 +4301,7 @@ static void __init set_ftrace_early_filters(void)
 int ftrace_regex_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct ftrace_ops_hash old_hash_ops;
 	struct ftrace_iterator *iter;
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *old_hash;
@@ -4324,10 +4335,12 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 		mutex_lock(&ftrace_lock);
 		old_hash = *orig_hash;
+		old_hash_ops.filter_hash = iter->ops->func_hash->filter_hash;
+		old_hash_ops.notrace_hash = iter->ops->func_hash->notrace_hash;
 		ret = ftrace_hash_move(iter->ops, filter_hash,
 				       orig_hash, iter->hash);
 		if (!ret) {
-			ftrace_ops_update_code(iter->ops, old_hash);
+			ftrace_ops_update_code(iter->ops, &old_hash_ops);
 			free_ftrace_hash_rcu(old_hash);
 		}
 		mutex_unlock(&ftrace_lock);
-- 
2.1.4


