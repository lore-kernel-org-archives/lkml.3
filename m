Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3G3Ldb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:33:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3G3Lby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:54 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Dn6SsLjw4JQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=A0v4L6Lz_KcA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=Ifv01XrSBeDAxmvL0_AA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113152.593866749@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 4/8] tracing: Change f_start() to take event_mutex and verify i_private
 != NULL
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Change-f_start-to-take-event_mutex-and-verif.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

trace_format_open() and trace_format_seq_ops are racy, nothing
protects ftrace_event_call from trace_remove_event_call().

Change f_start() to take event_mutex and verify i_private != NULL,
change f_stop() to drop this lock.

This fixes nothing, but now we can change debugfs_remove("format")
callers to nullify ->i_private and fix the the problem.

Note: the usage of event_mutex is sub-optimal but simple, we can
change this later.

Link: http://lkml.kernel.org/r/20130726172543.GA3622@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1d7b6d0..50dc8b2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -840,7 +840,7 @@ enum {
 
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct list_head *common_head = &ftrace_common_fields;
 	struct list_head *head = trace_get_fields(call);
 	struct list_head *node = v;
@@ -872,7 +872,7 @@ static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 
 static int f_show(struct seq_file *m, void *v)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct ftrace_event_field *field;
 	const char *array_descriptor;
 
@@ -925,6 +925,11 @@ static void *f_start(struct seq_file *m, loff_t *pos)
 	void *p = (void *)FORMAT_HEADER;
 	loff_t l = 0;
 
+	/* ->stop() is called even if ->start() fails */
+	mutex_lock(&event_mutex);
+	if (!event_file_data(m->private))
+		return ERR_PTR(-ENODEV);
+
 	while (l < *pos && p)
 		p = f_next(m, p, &l);
 
@@ -933,6 +938,7 @@ static void *f_start(struct seq_file *m, loff_t *pos)
 
 static void f_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&event_mutex);
 }
 
 static const struct seq_operations trace_format_seq_ops = {
@@ -944,7 +950,6 @@ static const struct seq_operations trace_format_seq_ops = {
 
 static int trace_format_open(struct inode *inode, struct file *file)
 {
-	struct ftrace_event_call *call = inode->i_private;
 	struct seq_file *m;
 	int ret;
 
@@ -953,7 +958,7 @@ static int trace_format_open(struct inode *inode, struct file *file)
 		return ret;
 
 	m = file->private_data;
-	m->private = call;
+	m->private = file;
 
 	return 0;
 }
-- 
1.7.10.4


