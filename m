Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab3GSOQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:16:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760583Ab3GSOOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:53 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_r4Fp4fxZN4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=m6cvJ1o1IkAA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=qLV7lnlNmj29gnodlM4A:9 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130719141449.400736809@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 10:12:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next-3.11][PATCH 07/12] tracing/kprobe: Wait for disabling all running kprobe handlers
References: <20130719141224.703522101@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-kprobe-Wait-for-disabling-all-running-kprobe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Wait for disabling all running kprobe handlers when a kprobe
event is disabled, since the caller, trace_remove_event_call()
supposes that a removing event is disabled completely by
disabling the event.
With this change, ftrace can ensure that there is no running
event handlers after disabling it.

Link: http://lkml.kernel.org/r/20130709093526.20138.93100.stgit@mhiramat-M0-7522

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ae6ce83..3811487 100644
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
 
-- 
1.7.10.4


