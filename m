Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbaGCQQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:16:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16237 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759199AbaGCQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:28 -0400
Message-Id: <20140703161226.536421069@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 18/21] tracing: Add ftrace_graph_notrace boot parameter
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0018-tracing-Add-ftrace_graph_notrace-boot-parameter.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The ftrace_graph_notrace option is for specifying notrace filter for
function graph tracer at boot time.  It can be altered after boot
using set_graph_notrace file on the debugfs.

Link: http://lkml.kernel.org/p/1402590233-22321-2-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |  6 ++++++
 kernel/trace/ftrace.c               | 24 ++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1b9aa8c5a52..19c0a9096a02 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1097,6 +1097,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			that can be changed at run time by the
 			set_graph_function file in the debugfs tracing directory.
 
+	ftrace_graph_notrace=[function-list]
+			[FTRACE] Do not trace from the functions specified in
+			function-list.  This list is a comma separated list of
+			functions that can be changed at run time by the
+			set_graph_notrace file in the debugfs tracing directory.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 232b898eebbd..17885a27281c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3884,6 +3884,7 @@ __setup("ftrace_filter=", set_ftrace_filter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
+static char ftrace_graph_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
 
 static int __init set_graph_function(char *str)
@@ -3893,16 +3894,29 @@ static int __init set_graph_function(char *str)
 }
 __setup("ftrace_graph_filter=", set_graph_function);
 
-static void __init set_ftrace_early_graph(char *buf)
+static int __init set_graph_notrace_function(char *str)
+{
+	strlcpy(ftrace_graph_notrace_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_graph_notrace=", set_graph_notrace_function);
+
+static void __init set_ftrace_early_graph(char *buf, int enable)
 {
 	int ret;
 	char *func;
+	unsigned long *table = ftrace_graph_funcs;
+	int *count = &ftrace_graph_count;
+
+	if (!enable) {
+		table = ftrace_graph_notrace_funcs;
+		count = &ftrace_graph_notrace_count;
+	}
 
 	while (buf) {
 		func = strsep(&buf, ",");
 		/* we allow only one expression at a time */
-		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
-				      FTRACE_GRAPH_MAX_FUNCS, func);
+		ret = ftrace_set_func(table, count, FTRACE_GRAPH_MAX_FUNCS, func);
 		if (ret)
 			printk(KERN_DEBUG "ftrace: function %s not "
 					  "traceable\n", func);
@@ -3931,7 +3945,9 @@ static void __init set_ftrace_early_filters(void)
 		ftrace_set_early_filter(&global_ops, ftrace_notrace_buf, 0);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (ftrace_graph_buf[0])
-		set_ftrace_early_graph(ftrace_graph_buf);
+		set_ftrace_early_graph(ftrace_graph_buf, 1);
+	if (ftrace_graph_notrace_buf[0])
+		set_ftrace_early_graph(ftrace_graph_notrace_buf, 0);
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 }
 
-- 
2.0.0


