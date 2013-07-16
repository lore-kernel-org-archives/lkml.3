Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab3GPTDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:03:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933364Ab3GPTCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:02:48 -0400
Date: Tue, 16 Jul 2013 20:57:30 +0200
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
Subject: [RFC PATCH 4/4] tracing: Change ftrace_event_filter_fops to rely
	on event_mutex/i_private
Message-ID: <20130716185730.GA21203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716185658.GA21167@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Shift mutex_lock(event_mutex) from print/apply_event_filter to
   the callers. And rename them just in case.

2. Change the callers, event_filter_read() and event_filter_write()
   to read call = i_private under this mutex and abort if it is NULL.

3. Remove .open from ftrace_event_filter_fops.

Note: I think event_filter_read() should not use "struct trace_seq".
It buys nothing compared to the simple kmalloc'ed buffer, just needs
a bit more memory and efforts.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.h               |    4 ++--
 kernel/trace/trace_events.c        |   29 ++++++++++++++++++-----------
 kernel/trace/trace_events_filter.c |   21 ++++++++-------------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4a4f6e1..57199ac 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -985,9 +985,9 @@ struct filter_pred {
 
 extern enum regex_type
 filter_parse_regex(char *buff, int len, char **search, int *not);
-extern void print_event_filter(struct ftrace_event_call *call,
+extern void __print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
-extern int apply_event_filter(struct ftrace_event_call *call,
+extern int __apply_event_filter(struct ftrace_event_call *call,
 			      char *filter_string);
 extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 					char *filter_string);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6401b51..f4a86f9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -959,9 +959,9 @@ static ssize_t
 event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_call *call;
 	struct trace_seq *s;
-	int r;
+	int r = -ENODEV;
 
 	if (*ppos)
 		return 0;
@@ -969,14 +969,18 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
-
 	trace_seq_init(s);
 
-	print_event_filter(call, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	mutex_lock(&event_mutex);
+	call = file_inode(filp)->i_private;
+	if (likely(call))
+		__print_event_filter(call, s);
+	mutex_unlock(&event_mutex);
 
-	kfree(s);
+	if (call)
+		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
+	kfree(s);
 	return r;
 }
 
@@ -984,9 +988,9 @@ static ssize_t
 event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_call *call;
 	char *buf;
-	int err;
+	int err = -ENODEV;
 
 	if (cnt >= PAGE_SIZE)
 		return -EINVAL;
@@ -1001,13 +1005,17 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 	buf[cnt] = '\0';
 
-	err = apply_event_filter(call, buf);
+	mutex_lock(&event_mutex);
+	call = file_inode(filp)->i_private;
+	if (likely(call))
+		err = __apply_event_filter(call, buf);
+	mutex_unlock(&event_mutex);
+
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
 
 	*ppos += cnt;
-
 	return cnt;
 }
 
@@ -1240,7 +1248,6 @@ static const struct file_operations ftrace_event_id_fops = {
 };
 
 static const struct file_operations ftrace_event_filter_fops = {
-	.open = tracing_open_generic,
 	.read = event_filter_read,
 	.write = event_filter_write,
 	.llseek = default_llseek,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 0d883dc..f4b5eed 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -637,17 +637,15 @@ static void append_filter_err(struct filter_parse_state *ps,
 	free_page((unsigned long) buf);
 }
 
-void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
+/* caller must hold event_mutex */
+void __print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
-	struct event_filter *filter;
+	struct event_filter *filter = call->filter;
 
-	mutex_lock(&event_mutex);
-	filter = call->filter;
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
-	mutex_unlock(&event_mutex);
 }
 
 void print_subsystem_event_filter(struct event_subsystem *system,
@@ -1841,23 +1839,22 @@ static int create_system_filter(struct event_subsystem *system,
 	return err;
 }
 
-int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
+/* caller must hold event_mutex */
+int __apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
 	struct event_filter *filter;
 	int err = 0;
 
-	mutex_lock(&event_mutex);
-
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable(call);
 		filter = call->filter;
 		if (!filter)
-			goto out_unlock;
+			goto out;
 		RCU_INIT_POINTER(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
-		goto out_unlock;
+		goto out;
 	}
 
 	err = create_filter(call, filter_string, true, &filter);
@@ -1884,9 +1881,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 			__free_filter(tmp);
 		}
 	}
-out_unlock:
-	mutex_unlock(&event_mutex);
-
+out:
 	return err;
 }
 
-- 
1.5.5.1

