Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3H3Nas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:30:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3H3NYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:24:06 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=62qllVeDKZoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=T_P90eYxbNQA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=JZYXgP7PDSWMtFAQ7SMA:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130830132404.542218666@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 30 Aug 2013 09:02:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Dave Jones <davej@redhat.com>
Subject: [RFC][PATCH 5/8] ftrace: Do not display non safe RCU functions in
 available_filter_functions
References: <20130830130205.504335754@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Do-not-display-non-safe-RCU-functions-in-avai.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As available_filter_functions file displays functions that are generally
available for tracing, do not show the ones that are RCU unsafe. Otherwise
it may be confusing for perf users to see these functions in this file but
not be able to trace them.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    1 +
 kernel/trace/ftrace.c  |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1d17a82..4709264 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -411,6 +411,7 @@ enum {
 	FTRACE_ITER_DO_HASH	= (1 << 3),
 	FTRACE_ITER_HASH	= (1 << 4),
 	FTRACE_ITER_ENABLED	= (1 << 5),
+	FTRACE_ITER_NO_UNSAFE	= (1 << 6),
 };
 
 void arch_ftrace_update_code(int command);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c7ef936..6550f72 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2634,7 +2634,10 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
 
 		    ((iter->flags & FTRACE_ITER_ENABLED) &&
-		     !(rec->flags & FTRACE_FL_ENABLED))) {
+		     !(rec->flags & FTRACE_FL_ENABLED)) ||
+
+		    ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
+		     ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {
 
 			rec = NULL;
 			goto retry;
@@ -2762,6 +2765,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
 	if (iter) {
 		iter->pg = ftrace_pages_start;
+		iter->flags = FTRACE_ITER_NO_UNSAFE;
 		iter->ops = &global_ops;
 	}
 
-- 
1.7.10.4


