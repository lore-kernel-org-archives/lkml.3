Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641Ab3GaRhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:37:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760595Ab3GaRg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:36:59 -0400
Date: Wed, 31 Jul 2013 19:31:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing: Kill the !CONFIG_MODULES code in
	trace_events.c
Message-ID: <20130731173137.GA31043@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731173116.GA31018@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move trace_module_nb under CONFIG_MODULES and kill the dummy
trace_module_notify(). Imho it doesn't make sense to define
"struct notifier_block" and its .notifier_call just to avoid
"ifdef" in event_trace_init(), and all other !CONFIG_MODULES
code has already gone away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 77ef314..6695970 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1810,12 +1810,10 @@ static int trace_module_notify(struct notifier_block *self,
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
@@ -2183,11 +2181,6 @@ static void __add_event_to_tracers(struct ftrace_event_call *call)
 		__trace_add_new_event(call, tr);
 }
 
-static struct notifier_block trace_module_nb = {
-	.notifier_call = trace_module_notify,
-	.priority = 0,
-};
-
 extern struct ftrace_event_call *__start_ftrace_events[];
 extern struct ftrace_event_call *__stop_ftrace_events[];
 
@@ -2392,10 +2385,11 @@ static __init int event_trace_init(void)
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
1.5.5.1

