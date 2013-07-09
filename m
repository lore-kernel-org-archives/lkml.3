Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3GIJiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:38:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47631 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3GIJiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:38:12 -0400
X-AuditID: 85900ec0-d4ccab900000151e-4f-51dbda003cb8
Subject: [RFC PATCH V2] tracing/kprobe: Wait for disabling all running kprobe
 handlers
To: Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 09 Jul 2013 18:35:26 +0900
Message-ID: <20130709093526.20138.93100.stgit@mhiramat-M0-7522>
In-Reply-To: <20130709082149.GK25631@dyad.programming.kicks-ass.net>
References: <20130709082149.GK25631@dyad.programming.kicks-ass.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait for disabling all running kprobe handlers when a kprobe
event is disabled, since the caller, trace_remove_event_call()
supposes that a removing event is disabled completely by
disabling the event.
With this change, ftrace can ensure that there is no running
event handlers after disabling it.

Changes in V2:
 - Comment (in code) for clarify why we need to wait there.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/trace/trace_kprobe.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..8374f78 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -243,11 +243,11 @@ find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
 static int
 disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
+	struct event_file_link *link = NULL;
+	int wait = 0;
 	int ret = 0;
 
 	if (file) {
-		struct event_file_link *link;
-
 		link = find_event_file_link(tp, file);
 		if (!link) {
 			ret = -EINVAL;
@@ -255,10 +255,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		}
 
 		list_del_rcu(&link->list);
-		/* synchronize with kprobe_trace_func/kretprobe_trace_func */
-		synchronize_sched();
-		kfree(link);
-
+		wait = 1;
 		if (!list_empty(&tp->files))
 			goto out;
 
@@ -271,8 +268,22 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
+		wait = 1;
 	}
  out:
+	if (wait) {
+		/*
+		 * Synchronize with kprobe_trace_func/kretprobe_trace_func
+		 * to ensure disabled (all running handlers are finished).
+		 * This is not only for kfree(), but also the caller,
+		 * trace_remove_event_call() supposes it for releasing
+		 * event_call related objects, which will be accessed in
+		 * the kprobe_trace_func/kretprobe_trace_func.
+		 */
+		synchronize_sched();
+		kfree(link);	/* Ignored if link == NULL */
+	}
+
 	return ret;
 }
 

