Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3CKHQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:16:44 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26280 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3CKHOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:14 -0400
Message-ID: <513D843B.40109@huawei.com>
Date: Mon, 11 Mar 2013 15:14:03 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 08/13] tracing: rename trace_event_mutex to trace_event_sem
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_event_mutex is rw semaphore now, not mutex,
change the name.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace_events.c |   10 +++++-----
 kernel/trace/trace_output.c |   16 ++++++++--------
 kernel/trace/trace_output.h |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0626792..61243a4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1319,7 +1319,7 @@ static void remove_subsystem_dir(const char *name)
 }

 /*
- * Must be called under locking both of event_mutex and trace_event_mutex.
+ * Must be called under locking both of event_mutex and trace_event_sem.
  */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
@@ -1334,9 +1334,9 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
 	mutex_lock(&event_mutex);
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	__trace_remove_event_call(call);
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
 }

@@ -1425,7 +1425,7 @@ static void trace_module_remove_events(struct module *mod)
 	struct ftrace_event_call *call, *p;
 	bool found = false;

-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
 			found = true;
@@ -1449,7 +1449,7 @@ static void trace_module_remove_events(struct module *mod)
 	 */
 	if (found)
 		tracing_reset_current_online_cpus();
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
 }

 static int trace_module_notify(struct notifier_block *self,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 697e88d..6fa709b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -14,7 +14,7 @@
 /* must be a power of 2 */
 #define EVENT_HASHSIZE	128

-DECLARE_RWSEM(trace_event_mutex);
+DECLARE_RWSEM(trace_event_sem);

 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;

@@ -783,12 +783,12 @@ static int trace_search_list(struct list_head **list)

 void trace_event_read_lock(void)
 {
-	down_read(&trace_event_mutex);
+	down_read(&trace_event_sem);
 }

 void trace_event_read_unlock(void)
 {
-	up_read(&trace_event_mutex);
+	up_read(&trace_event_sem);
 }

 /**
@@ -811,7 +811,7 @@ int register_ftrace_event(struct trace_event *event)
 	unsigned key;
 	int ret = 0;

-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);

 	if (WARN_ON(!event))
 		goto out;
@@ -866,14 +866,14 @@ int register_ftrace_event(struct trace_event *event)

 	ret = event->type;
  out:
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);

 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_event);

 /*
- * Used by module code with the trace_event_mutex held for write.
+ * Used by module code with the trace_event_sem held for write.
  */
 int __unregister_ftrace_event(struct trace_event *event)
 {
@@ -888,9 +888,9 @@ int __unregister_ftrace_event(struct trace_event *event)
  */
 int unregister_ftrace_event(struct trace_event *event)
 {
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	__unregister_ftrace_event(event);
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);

 	return 0;
 }
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index c038eba..4d96de5 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -31,7 +31,7 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);

 /* used by module unregistering */
 extern int __unregister_ftrace_event(struct trace_event *event);
-extern struct rw_semaphore trace_event_mutex;
+extern struct rw_semaphore trace_event_sem;

 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-- 
1.7.9.7


