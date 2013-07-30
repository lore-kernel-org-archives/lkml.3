Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3G3Lcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:32:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab3G3Lbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:55 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=QQUHsBMXWBMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=X0hVryAAmmoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=iyQWiLMnTuEKbDek1OAA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113152.434186243@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 3/8] tracing: Change event_filter_read/write to verify i_private != NULL
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Change-event_filter_read-write-to-verify-i_p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

event_filter_read/write() are racy, ftrace_event_call can be already
freed by trace_remove_event_call() callers.

1. Shift mutex_lock(event_mutex) from print/apply_event_filter to
   the callers.

2. Change the callers, event_filter_read() and event_filter_write()
   to read i_private under this mutex and abort if it is NULL.

This fixes nothing, but now we can change debugfs_remove("filter")
callers to nullify ->i_private and fix the the problem.

Link: http://lkml.kernel.org/r/20130726172540.GA3619@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c        |   26 +++++++++++++++++++-------
 kernel/trace/trace_events_filter.c |   17 ++++++-----------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3dfa841..1d7b6d0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -980,21 +980,28 @@ static ssize_t
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
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
+
 	if (!s)
 		return -ENOMEM;
 
 	trace_seq_init(s);
 
-	print_event_filter(call, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	mutex_lock(&event_mutex);
+	call = event_file_data(filp);
+	if (call)
+		print_event_filter(call, s);
+	mutex_unlock(&event_mutex);
+
+	if (call)
+		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
 
@@ -1005,9 +1012,9 @@ static ssize_t
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
@@ -1022,7 +1029,12 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 	buf[cnt] = '\0';
 
-	err = apply_event_filter(call, buf);
+	mutex_lock(&event_mutex);
+	call = event_file_data(filp);
+	if (call)
+		err = apply_event_filter(call, buf);
+	mutex_unlock(&event_mutex);
+
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 0c7b75a..97daa8c 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -637,17 +637,15 @@ static void append_filter_err(struct filter_parse_state *ps,
 	free_page((unsigned long) buf);
 }
 
+/* caller must hold event_mutex */
 void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
-	struct event_filter *filter;
+	struct event_filter *filter = call->filter;
 
-	mutex_lock(&event_mutex);
-	filter = call->filter;
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_puts(s, "none\n");
-	mutex_unlock(&event_mutex);
 }
 
 void print_subsystem_event_filter(struct event_subsystem *system,
@@ -1841,23 +1839,22 @@ static int create_system_filter(struct event_subsystem *system,
 	return err;
 }
 
+/* caller must hold event_mutex */
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
 	struct event_filter *filter;
-	int err = 0;
-
-	mutex_lock(&event_mutex);
+	int err;
 
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable(call);
 		filter = call->filter;
 		if (!filter)
-			goto out_unlock;
+			return 0;
 		RCU_INIT_POINTER(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
-		goto out_unlock;
+		return 0;
 	}
 
 	err = create_filter(call, filter_string, true, &filter);
@@ -1884,8 +1881,6 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 			__free_filter(tmp);
 		}
 	}
-out_unlock:
-	mutex_unlock(&event_mutex);
 
 	return err;
 }
-- 
1.7.10.4


