Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3HVQeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:34:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3HVQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:34:23 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Cyz2jNeh5BAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=90aJUKrJnroA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=vMqKpMRR5qK3lec0e8oA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=mJGE7TPqQJF6mCZ_:21 a=-bcsu2J0MmDZN6ih:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130822163420.780574157@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 22 Aug 2013 12:32:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 5/5] tracing: Kill the !CONFIG_MODULES code in trace_events.c
References: <20130822163225.773134216@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Kill-the-CONFIG_MODULES-code-in-trace_events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Move trace_module_nb under CONFIG_MODULES and kill the dummy
trace_module_notify(). Imho it doesn't make sense to define
"struct notifier_block" and its .notifier_call just to avoid
"ifdef" in event_trace_init(), and all other !CONFIG_MODULES
code has already gone away.

Link: http://lkml.kernel.org/r/20130731173137.GA31043@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4e706a0..368a4d5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1820,12 +1820,10 @@ static int trace_module_notify(struct notifier_block *self,
 	return 0;
 }
 
-#else
-static inline int trace_module_notify(struct notifier_block *self,
-				      unsigned long val, void *data)
-{
-	return 0;
-}
+static struct notifier_block trace_module_nb = {
+	.notifier_call = trace_module_notify,
+	.priority = 0,
+};
 #endif /* CONFIG_MODULES */
 
 /* Create a new event directory structure for a trace directory. */
@@ -2193,11 +2191,6 @@ static void __add_event_to_tracers(struct ftrace_event_call *call)
 		__trace_add_new_event(call, tr);
 }
 
-static struct notifier_block trace_module_nb = {
-	.notifier_call = trace_module_notify,
-	.priority = 0,
-};
-
 extern struct ftrace_event_call *__start_ftrace_events[];
 extern struct ftrace_event_call *__stop_ftrace_events[];
 
@@ -2402,10 +2395,11 @@ static __init int event_trace_init(void)
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_MODULES
 	ret = register_module_notifier(&trace_module_nb);
 	if (ret)
 		pr_warning("Failed to register trace events module notifier\n");
-
+#endif
 	return 0;
 }
 early_initcall(event_trace_memsetup);
-- 
1.7.10.4


