Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3GBUZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:25:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3GBUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=DQnPH4bpUpEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jfwFcczLjwUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=J6KtLUdGKimxu5Ye3iEA:9 a=T_MzRWcqBuIA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LNOUjzbqbzrbBtg4:21 a=W8s7-QhTDSps-_m6:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202427.132345962@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>, <stable@vger.kernel.org>,
        Alexander Z Lam <azl@google.com>
Subject: [for-next][PATCH 12/14] tracing: Protect ftrace_trace_arrays list in trace_events.c
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Protect-ftrace_trace_arrays-list-in-trace_ev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Z Lam <azl@google.com>

There are multiple places where the ftrace_trace_arrays list is accessed in
trace_events.c without the trace_types_lock held.

Link: http://lkml.kernel.org/r/1372732674-22726-1-git-send-email-azl@google.com

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Alexander Z Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |    2 +-
 kernel/trace/trace.h        |    2 ++
 kernel/trace/trace_events.c |   11 ++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e04e711..e36da7f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -266,7 +266,7 @@ static struct tracer		*trace_types __read_mostly;
 /*
  * trace_types_lock is used to protect the trace_types list.
  */
-static DEFINE_MUTEX(trace_types_lock);
+DEFINE_MUTEX(trace_types_lock);
 
 /*
  * serialize the access of the ring buffer
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a88939e..2c3cba59 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -224,6 +224,8 @@ enum {
 
 extern struct list_head ftrace_trace_arrays;
 
+extern struct mutex trace_types_lock;
+
 /*
  * The global tracer (top) should be the first trace array added,
  * but we check the flag anyway.
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5892470..35c6f23 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1008,6 +1008,7 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	/* Make sure the system still exists */
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		list_for_each_entry(dir, &tr->systems, list) {
@@ -1023,6 +1024,7 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	}
  exit_loop:
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 
 	if (!system)
 		return -ENODEV;
@@ -1617,6 +1619,7 @@ static void __add_event_to_tracers(struct ftrace_event_call *call,
 int trace_add_event_call(struct ftrace_event_call *call)
 {
 	int ret;
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 
 	ret = __register_event(call, NULL);
@@ -1624,11 +1627,13 @@ int trace_add_event_call(struct ftrace_event_call *call)
 		__add_event_to_tracers(call, NULL);
 
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 	return ret;
 }
 
 /*
- * Must be called under locking both of event_mutex and trace_event_sem.
+ * Must be called under locking of trace_types_lock, event_mutex and
+ * trace_event_sem.
  */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
@@ -1640,11 +1645,13 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 /* Remove an event_call */
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	__trace_remove_event_call(call);
 	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 }
 
 #define for_each_event(event, start, end)			\
@@ -1788,6 +1795,7 @@ static int trace_module_notify(struct notifier_block *self,
 {
 	struct module *mod = data;
 
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	switch (val) {
 	case MODULE_STATE_COMING:
@@ -1798,6 +1806,7 @@ static int trace_module_notify(struct notifier_block *self,
 		break;
 	}
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 
 	return 0;
 }
-- 
1.7.10.4


