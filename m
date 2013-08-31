Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3HaFUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:20:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab3HaFRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:04 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jNP3OkI5QL0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OlPmlbCOKaoA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=ac4SS_tiFSPT9NLxd24A:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051701.452903571@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 06/18 v2] ftrace: Add rcu_unsafe_filter_functions file
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Add-rcu_unsafe_filter_functions-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Since the RCU unsafe functions are no longer displayed by the
available_filter_functions, we still need a way to see these
functions in order to trace them. Create a new file that lists
the functions that were declared RCU unsafe.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    1 +
 kernel/trace/ftrace.c  |   31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4709264..4752764 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -412,6 +412,7 @@ enum {
 	FTRACE_ITER_HASH	= (1 << 4),
 	FTRACE_ITER_ENABLED	= (1 << 5),
 	FTRACE_ITER_NO_UNSAFE	= (1 << 6),
+	FTRACE_ITER_UNSAFE_ONLY	= (1 << 7),
 };
 
 void arch_ftrace_update_code(int command);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index be87ac9..a3e4b71 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2647,6 +2647,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		    ((iter->flags & FTRACE_ITER_ENABLED) &&
 		     !(rec->flags & FTRACE_FL_ENABLED)) ||
 
+		    ((iter->flags & FTRACE_ITER_UNSAFE_ONLY) &&
+		     !ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip)) ||
+
 		    ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
 		     ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {
 
@@ -2784,6 +2787,24 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 }
 
 static int
+ftrace_rcu_unsafe_open(struct inode *inode, struct file *file)
+{
+	struct ftrace_iterator *iter;
+
+	if (unlikely(ftrace_disabled))
+		return -ENODEV;
+
+	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
+	if (iter) {
+		iter->pg = ftrace_pages_start;
+		iter->flags = FTRACE_ITER_UNSAFE_ONLY;
+		iter->ops = &global_ops;
+	}
+
+	return iter ? 0 : -ENOMEM;
+}
+
+static int
 ftrace_enabled_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
@@ -3835,6 +3856,13 @@ static const struct file_operations ftrace_avail_fops = {
 	.release = seq_release_private,
 };
 
+static const struct file_operations ftrace_rcu_unsafe_fops = {
+	.open = ftrace_rcu_unsafe_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
 static const struct file_operations ftrace_enabled_fops = {
 	.open = ftrace_enabled_open,
 	.read = seq_read,
@@ -4071,6 +4099,9 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("available_filter_functions", 0444,
 			d_tracer, NULL, &ftrace_avail_fops);
 
+	trace_create_file("rcu_unsafe_filter_functions", 0444,
+			d_tracer, NULL, &ftrace_rcu_unsafe_fops);
+
 	trace_create_file("enabled_functions", 0444,
 			d_tracer, NULL, &ftrace_enabled_fops);
 
-- 
1.7.10.4


