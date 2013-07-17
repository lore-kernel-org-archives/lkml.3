Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3GQTfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:35:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101Ab3GQTft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:35:49 -0400
Date: Wed, 17 Jul 2013 21:30:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/4] tracing: Change f_start() to verify i_private
	under event_mutex
Message-ID: <20130717193036.GB15312@redhat.com>
References: <20130716185658.GA21167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716185658.GA21167@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally change f_start() to take event_mutex and verify i_private,
f_stop() drops this lock. This closes the races with event_remove.

Note: the usage of event_mutex is sub-optimal but simple, we can
change this later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6c3e4e6..dc6c1ee 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -805,7 +805,8 @@ enum {
 
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
+	struct inode *inode = m->private;
+	struct ftrace_event_call *call = inode->i_private;
 	struct list_head *common_head = &ftrace_common_fields;
 	struct list_head *head = trace_get_fields(call);
 	struct list_head *node = v;
@@ -837,7 +838,8 @@ static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 
 static int f_show(struct seq_file *m, void *v)
 {
-	struct ftrace_event_call *call = m->private;
+	struct inode *inode = m->private;
+	struct ftrace_event_call *call = inode->i_private;
 	struct ftrace_event_field *field;
 	const char *array_descriptor;
 
@@ -887,9 +889,16 @@ static int f_show(struct seq_file *m, void *v)
 
 static void *f_start(struct seq_file *m, loff_t *pos)
 {
+	struct inode *inode = m->private;
 	void *p = (void *)FORMAT_HEADER;
 	loff_t l = 0;
 
+	mutex_lock(&event_mutex);
+	if (unlikely(!inode->i_private)) {
+		mutex_unlock(&event_mutex);
+		return ERR_PTR(-ENODEV);
+	}
+
 	while (p && l < *pos)
 		p = f_next(m, p, &l);
 
@@ -898,6 +907,7 @@ static void *f_start(struct seq_file *m, loff_t *pos)
 
 static void f_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&event_mutex);
 }
 
 static const struct seq_operations trace_format_seq_ops = {
@@ -909,7 +919,6 @@ static const struct seq_operations trace_format_seq_ops = {
 
 static int trace_format_open(struct inode *inode, struct file *file)
 {
-	struct ftrace_event_call *call = inode->i_private;
 	struct seq_file *m;
 	int ret;
 
@@ -918,7 +927,7 @@ static int trace_format_open(struct inode *inode, struct file *file)
 		return ret;
 
 	m = file->private_data;
-	m->private = call;
+	m->private = inode;
 
 	return 0;
 }
-- 
1.5.5.1


