Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935755Ab3FTDgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:36:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935652Ab3FTDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:40 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XMBClIXJuBAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kaQxfkCxA1UA:10 a=wrDdfQKqFcNDy5NifbcA:9 a=jeBq3FmKZ4MA:10 a=IgQTG-qG4Rs63gPH:21 a=Hxu1XeePWK8Yt58c:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033638.776877844@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 02/12] tracing: Add function probe to trigger a ftrace dump of current CPU
 trace
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-function-probe-to-trigger-a-ftrace-dump-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add the "cpudump" command to have the current CPU ftrace buffer dumped
to console if a function is hit. This is useful when debugging a
tripple fault, where you have an idea of a function that is called
just before the tripple fault occurs, and can tell ftrace to dump its
content out to the console before it continues.

This differs from the "dump" command as it only dumps the content of
the ring buffer for the currently executing CPU, and does not show
the contents of the other CPUs.

Format is:

  <function>:cpudump

echo 'bad_address:cpudump' > /debug/tracing/set_ftrace_filter

To remove this:

echo '!bad_address:cpudump' > /debug/tracing/set_ftrace_filter

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |    6 ++++++
 kernel/trace/trace_functions.c |   44 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index cc9ec57..b937c6e 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -2437,6 +2437,12 @@ The following commands are supported:
   is hit. Perhaps its a function that is called before a tripple
   fault happens and does not allow you to get a regular dump.
 
+- cpudump
+  When the function is hit, it will dump the contents of the ftrace
+  ring buffer for the current CPU to the console. Unlike the "dump"
+  command, it only prints out the contents of the ring buffer for the
+  CPU that executed the function that triggered the dump.
+
 trace_pipe
 ----------
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index d7c8719..b863f93 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -297,6 +297,14 @@ ftrace_dump_probe(unsigned long ip, unsigned long parent_ip, void **data)
 		ftrace_dump(DUMP_ALL);
 }
 
+/* Only dump the current CPU buffer. */
+static void
+ftrace_cpudump_probe(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	if (update_count(data))
+		ftrace_dump(DUMP_ORIG);
+}
+
 static int
 ftrace_probe_print(const char *name, struct seq_file *m,
 		   unsigned long ip, void *data)
@@ -341,6 +349,13 @@ ftrace_dump_print(struct seq_file *m, unsigned long ip,
 	return ftrace_probe_print("dump", m, ip, data);
 }
 
+static int
+ftrace_cpudump_print(struct seq_file *m, unsigned long ip,
+			struct ftrace_probe_ops *ops, void *data)
+{
+	return ftrace_probe_print("cpudump", m, ip, data);
+}
+
 static struct ftrace_probe_ops traceon_count_probe_ops = {
 	.func			= ftrace_traceon_count,
 	.print			= ftrace_traceon_print,
@@ -361,6 +376,11 @@ static struct ftrace_probe_ops dump_probe_ops = {
 	.print			= ftrace_dump_print,
 };
 
+static struct ftrace_probe_ops cpudump_probe_ops = {
+	.func			= ftrace_cpudump_probe,
+	.print			= ftrace_cpudump_print,
+};
+
 static struct ftrace_probe_ops traceon_probe_ops = {
 	.func			= ftrace_traceon,
 	.print			= ftrace_traceon_print,
@@ -457,6 +477,19 @@ ftrace_dump_callback(struct ftrace_hash *hash,
 					   "1", enable);
 }
 
+static int
+ftrace_cpudump_callback(struct ftrace_hash *hash,
+			   char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_probe_ops *ops;
+
+	ops = &cpudump_probe_ops;
+
+	/* Only dump once. */
+	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
+					   "1", enable);
+}
+
 static struct ftrace_func_command ftrace_traceon_cmd = {
 	.name			= "traceon",
 	.func			= ftrace_trace_onoff_callback,
@@ -477,6 +510,11 @@ static struct ftrace_func_command ftrace_dump_cmd = {
 	.func			= ftrace_dump_callback,
 };
 
+static struct ftrace_func_command ftrace_cpudump_cmd = {
+	.name			= "cpudump",
+	.func			= ftrace_cpudump_callback,
+};
+
 static int __init init_func_cmd_traceon(void)
 {
 	int ret;
@@ -497,8 +535,14 @@ static int __init init_func_cmd_traceon(void)
 	if (ret)
 		goto out_free_stacktrace;
 
+	ret = register_ftrace_command(&ftrace_cpudump_cmd);
+	if (ret)
+		goto out_free_dump;
+
 	return 0;
 
+ out_free_dump:
+	unregister_ftrace_command(&ftrace_dump_cmd);
  out_free_stacktrace:
 	unregister_ftrace_command(&ftrace_stacktrace_cmd);
  out_free_traceon:
-- 
1.7.10.4


