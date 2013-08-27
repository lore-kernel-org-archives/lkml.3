Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3H0BHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3H0BHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 29/74] tracing: Change f_start() to take event_mutex and verify i_private != NULL
Date: Mon, 26 Aug 2013 18:08:27 -0700
Message-Id: <20130827010430.783793391@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit c5a44a1200c6eda2202434f25325e8ad19533fca upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 kernel/trace/trace_events.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -838,7 +838,7 @@ enum {
 
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct ftrace_event_field *field;
 	struct list_head *common_head = &ftrace_common_fields;
 	struct list_head *head = trace_get_fields(call);
@@ -882,6 +882,11 @@ static void *f_start(struct seq_file *m,
 	loff_t l = 0;
 	void *p;
 
+	/* ->stop() is called even if ->start() fails */
+	mutex_lock(&event_mutex);
+	if (!event_file_data(m->private))
+		return ERR_PTR(-ENODEV);
+
 	/* Start by showing the header */
 	if (!*pos)
 		return (void *)FORMAT_HEADER;
@@ -896,7 +901,7 @@ static void *f_start(struct seq_file *m,
 
 static int f_show(struct seq_file *m, void *v)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct ftrace_event_field *field;
 	const char *array_descriptor;
 
@@ -947,6 +952,7 @@ static int f_show(struct seq_file *m, vo
 
 static void f_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&event_mutex);
 }
 
 static const struct seq_operations trace_format_seq_ops = {
@@ -958,7 +964,6 @@ static const struct seq_operations trace
 
 static int trace_format_open(struct inode *inode, struct file *file)
 {
-	struct ftrace_event_call *call = inode->i_private;
 	struct seq_file *m;
 	int ret;
 
@@ -967,7 +972,7 @@ static int trace_format_open(struct inod
 		return ret;
 
 	m = file->private_data;
-	m->private = call;
+	m->private = file;
 
 	return 0;
 }


