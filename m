Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab3GZRbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab3GZRbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:31:05 -0400
Date: Fri, 26 Jul 2013 19:25:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] tracing: Change f_start() to take event_mutex and
	verify i_private != NULL
Message-ID: <20130726172543.GA3622@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726172513.GA3586@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_format_open() and trace_format_seq_ops are racy, nothing
protects ftrace_event_call from trace_remove_event_call().

Change f_start() to take event_mutex and verify i_private != NULL,
change f_stop() to drop this lock.

This fixes nothing, but now we can change debugfs_remove("format")
callers to nullify ->i_private and fix the the problem.

Note: the usage of event_mutex is sub-optimal but simple, we can
change this later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b5144c4..3de2aca 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -839,7 +839,7 @@ enum {
 
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct list_head *common_head = &ftrace_common_fields;
 	struct list_head *head = trace_get_fields(call);
 	struct list_head *node = v;
@@ -871,7 +871,7 @@ static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 
 static int f_show(struct seq_file *m, void *v)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct ftrace_event_field *field;
 	const char *array_descriptor;
 
@@ -924,6 +924,11 @@ static void *f_start(struct seq_file *m, loff_t *pos)
 	void *p = (void *)FORMAT_HEADER;
 	loff_t l = 0;
 
+	/* ->stop() is called even if ->start() fails */
+	mutex_lock(&event_mutex);
+	if (!event_file_data(m->private))
+		return ERR_PTR(-ENODEV);
+
 	while (l < *pos && p)
 		p = f_next(m, p, &l);
 
@@ -932,6 +937,7 @@ static void *f_start(struct seq_file *m, loff_t *pos)
 
 static void f_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&event_mutex);
 }
 
 static const struct seq_operations trace_format_seq_ops = {
@@ -943,7 +949,6 @@ static const struct seq_operations trace_format_seq_ops = {
 
 static int trace_format_open(struct inode *inode, struct file *file)
 {
-	struct ftrace_event_call *call = inode->i_private;
 	struct seq_file *m;
 	int ret;
 
@@ -952,7 +957,7 @@ static int trace_format_open(struct inode *inode, struct file *file)
 		return ret;
 
 	m = file->private_data;
-	m->private = call;
+	m->private = file;
 
 	return 0;
 }
-- 
1.5.5.1

