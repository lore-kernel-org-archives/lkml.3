Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab3GBU2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:28:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3GBUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:27 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=8bHPLWCpmD0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PUDWgdFKh_AA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=liAV-VWemG3EvjLrsgkA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202425.667999594@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 03/14] tracing/kprobes: Kill probe_enable_lock
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-kprobes-Kill-probe_enable_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

enable_trace_probe() and disable_trace_probe() should not worry about
serialization, the caller (perf_trace_init or __ftrace_set_clr_event)
holds event_mutex.

They are also called by kprobe_trace_self_tests_init(), but this __init
function can't race with itself or trace_events.c

And note that this code depended on event_mutex even before 41a7dd420c
which introduced probe_enable_lock. In fact it assumes that the caller
kprobe_register() can never race with itself. Otherwise, say, tp->flags
manipulations are racy.

Link: http://lkml.kernel.org/r/20130620173809.GA13158@redhat.com

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c35bebe..282f86c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -183,16 +183,15 @@ static struct trace_probe *find_trace_probe(const char *event,
 	return NULL;
 }
 
+/*
+ * This and enable_trace_probe/disable_trace_probe rely on event_mutex
+ * held by the caller, __ftrace_set_clr_event().
+ */
 static int trace_probe_nr_files(struct trace_probe *tp)
 {
-	struct ftrace_event_file **file;
+	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
 	int ret = 0;
 
-	/*
-	 * Since all tp->files updater is protected by probe_enable_lock,
-	 * we don't need to lock an rcu_read_lock.
-	 */
-	file = rcu_dereference_raw(tp->files);
 	if (file)
 		while (*(file++))
 			ret++;
@@ -200,8 +199,6 @@ static int trace_probe_nr_files(struct trace_probe *tp)
 	return ret;
 }
 
-static DEFINE_MUTEX(probe_enable_lock);
-
 /*
  * Enable trace_probe
  * if the file is NULL, enable "perf" handler, or enable "trace" handler.
@@ -211,8 +208,6 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
-	mutex_lock(&probe_enable_lock);
-
 	if (file) {
 		struct ftrace_event_file **new, **old;
 		int n = trace_probe_nr_files(tp);
@@ -223,7 +218,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 			      GFP_KERNEL);
 		if (!new) {
 			ret = -ENOMEM;
-			goto out_unlock;
+			goto out;
 		}
 		memcpy(new, old, n * sizeof(struct ftrace_event_file *));
 		new[n] = file;
@@ -246,10 +241,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		else
 			ret = enable_kprobe(&tp->rp.kp);
 	}
-
- out_unlock:
-	mutex_unlock(&probe_enable_lock);
-
+ out:
 	return ret;
 }
 
@@ -282,8 +274,6 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
-	mutex_lock(&probe_enable_lock);
-
 	if (file) {
 		struct ftrace_event_file **new, **old;
 		int n = trace_probe_nr_files(tp);
@@ -292,7 +282,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		old = rcu_dereference_raw(tp->files);
 		if (n == 0 || trace_probe_file_index(tp, file) < 0) {
 			ret = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 
 		if (n == 1) {	/* Remove the last file */
@@ -303,7 +293,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 				      GFP_KERNEL);
 			if (!new) {
 				ret = -ENOMEM;
-				goto out_unlock;
+				goto out;
 			}
 
 			/* This copy & check loop copies the NULL stopper too */
@@ -326,10 +316,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		else
 			disable_kprobe(&tp->rp.kp);
 	}
-
- out_unlock:
-	mutex_unlock(&probe_enable_lock);
-
+ out:
 	return ret;
 }
 
@@ -1214,6 +1201,12 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
+/*
+ * called by perf_trace_init() or __ftrace_set_clr_event() under event_mutex.
+ *
+ * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
+ * lockless, but we can't race with this __init function.
+ */
 static __kprobes
 int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
@@ -1379,6 +1372,10 @@ find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
 	return NULL;
 }
 
+/*
+ * Nobody but us can call enable_trace_probe/disable_trace_probe at this
+ * stage, we can do this lockless.
+ */
 static __init int kprobe_trace_self_tests_init(void)
 {
 	int ret, warn = 0;
-- 
1.7.10.4


