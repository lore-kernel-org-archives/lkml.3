Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3GIIFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:05:08 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41640 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3GIIEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:04:31 -0400
X-AuditID: 85900ec0-d38c8b900000151e-21-51dbc40c752b
Subject: [RFC PATCH] tracing/kprobe: Wait for disabling all running kprobe
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
Date: Tue, 09 Jul 2013 17:01:45 +0900
Message-ID: <20130709080145.7975.83164.stgit@mhiramat-M0-7522>
In-Reply-To: <20130708142533.GA23749@redhat.com>
References: <20130708142533.GA23749@redhat.com>
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/trace/trace_kprobe.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..a9a4fe5 100644
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
 
@@ -271,8 +268,18 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
+		wait = 1;
 	}
  out:
+	if (wait) {
+		/*
+		 * synchronize with kprobe_trace_func/kretprobe_trace_func
+		 * to ensure disabled (all running handlers are finished)
+		 */
+		synchronize_sched();
+		kfree(link);	/* Ignored if link == NULL */
+	}
+
 	return ret;
 }
 

