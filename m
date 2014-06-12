Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaFLQZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:25:25 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37847 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbaFLQYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:24:00 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing: Add ftrace_graph_notrace boot parameter
Date: Fri, 13 Jun 2014 01:23:50 +0900
Message-Id: <1402590233-22321-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
References: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace_graph_notrace option is for specifying notrace filter for
function graph tracer at boot time.  It can be altered after boot
using set_graph_notrace file on the debugfs.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 kernel/trace/ftrace.c               |   24 ++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 43842177b771..40cf0caf92a9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1062,6 +1062,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index 071908f58e7a..f08edd7125c6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3628,6 +3628,7 @@ __setup("ftrace_filter=", set_ftrace_filter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
+static char ftrace_graph_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
 
 static int __init set_graph_function(char *str)
@@ -3637,16 +3638,29 @@ static int __init set_graph_function(char *str)
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
@@ -3675,7 +3689,9 @@ static void __init set_ftrace_early_filters(void)
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
1.7.9.2

