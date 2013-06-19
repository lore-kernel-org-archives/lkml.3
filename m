Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab3FSUee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934999Ab3FSUeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:34:31 -0400
Date: Wed, 19 Jun 2013 22:30:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: [PATCH v2 2/3] tracing/kprobes: Kill probe_enable_lock
Message-ID: <20130619203005.GA19750@redhat.com>
References: <20130616172149.GA8540@redhat.com> <51BE97C0.1070203@hitachi.com> <20130617151841.GA32267@redhat.com> <51BFD6EF.1060805@hitachi.com> <20130618192414.GA19488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618192414.GA19488@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Oleg Nesterov wrote:
>
> On 06/18, Masami Hiramatsu wrote:
> >
> > Oh, I agree with removing probe_enable_lock itself :)
> > I just concerned only about the exceptional case of __init test
> > function, which can mislead someone to use enable/disable_trace_probe
> > at other racy point.
>
> Ah, understand.
>
> OK, I'll send v2 with the updated comments plus the additional patch
> tomorrow.

So. I'll resend this series, will you ack the v2 below?

I only added a couple of comments, the interdiff is

	@@ -1202,6 +1202,12 @@ kretprobe_perf_func(struct trace_probe *
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
	@@ -1367,6 +1373,10 @@ find_trace_probe_file(struct trace_probe
		return NULL;
	 }
	 
	+/*
	+ * Nobody but us can call enable_trace_probe/disable_trace_probe at this
	+ * stage, we can do this lockless.
	+ */
	 static __init int kprobe_trace_self_tests_init(void)
	 {
		int ret, warn = 0;

3/3 was updated too, but the only change is s/list_add_rcu/list_add_tail_rcu/,
I won't spam the list but preserve your ack unless you object.

Oleg.

-------------------------------------------------------------------------------
Subject: [PATCH v2] tracing/kprobes: Kill probe_enable_lock

enable_trace_probe() and disable_trace_probe() should not worry about
serialization, the caller (perf_trace_init or __ftrace_set_clr_event)
holds event_mutex.

They are also called by kprobe_trace_self_tests_init(), but this __init
function can't race with itself or trace_events.c

And note that this code depended on event_mutex even before 41a7dd420c
which introduced probe_enable_lock. In fact it assumes that the caller
kprobe_register() can never race with itself. Otherwise, say, tp->flags
manipulations are racy.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_kprobe.c |   43 ++++++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c0af476..3432652 100644
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
@@ -247,10 +242,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
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
 
@@ -283,8 +275,6 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
-	mutex_lock(&probe_enable_lock);
-
 	if (file) {
 		struct ftrace_event_file **new, **old;
 		int n = trace_probe_nr_files(tp);
@@ -293,7 +283,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		old = rcu_dereference_raw(tp->files);
 		if (n == 0 || trace_probe_file_index(tp, file) < 0) {
 			ret = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 
 		if (n == 1) {	/* Remove the last file */
@@ -304,7 +294,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 				      GFP_KERNEL);
 			if (!new) {
 				ret = -ENOMEM;
-				goto out_unlock;
+				goto out;
 			}
 
 			/* This copy & check loop copies the NULL stopper too */
@@ -327,10 +317,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
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
 
@@ -1215,6 +1202,12 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
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
@@ -1380,6 +1373,10 @@ find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
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
1.5.5.1


