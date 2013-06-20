Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965086Ab3FTDg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:36:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935651Ab3FTDgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:44 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=snS-Ytu4pT0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kaQxfkCxA1UA:10 a=oExj5NFNAAAA:8 a=OCeZj-3jOE64cGuZ1-AA:9 a=jeBq3FmKZ4MA:10 a=r0HesoeFUbUA:10 a=m-w9MJy2HLGlLGX1:21 a=irABsSEaN9MZT3Zw:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033638.613248599@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: [for-next][PATCH 01/12] tracing: Add function probe to trigger a ftrace dump to console
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-function-probe-to-trigger-a-ftrace-dump-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add the "dump" command to have the ftrace buffer dumped to console if
a function is hit. This is useful when debugging a tripple fault,
where you have an idea of a function that is called just before the
tripple fault occurs, and can tell ftrace to dump its content out
to the console before it continues.

Format is:

  <function>:dump

echo 'bad_address:dump' > /debug/tracing/set_ftrace_filter

To remove this:

echo '!bad_address:dump' > /debug/tracing/set_ftrace_filter

Requested-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |    7 +++++
 kernel/trace/trace_functions.c |   59 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bfe8c29..cc9ec57 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -2430,6 +2430,13 @@ The following commands are supported:
    echo '!schedule:disable_event:sched:sched_switch' > \
    	 set_ftrace_filter
 
+- dump
+  When the function is hit, it will dump the contents of the ftrace
+  ring buffer to the console. This is useful if you need to debug
+  something, and want to dump the trace when a certain function
+  is hit. Perhaps its a function that is called before a tripple
+  fault happens and does not allow you to get a regular dump.
+
 trace_pipe
 ----------
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index c4d6d71..d7c8719 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -290,6 +290,13 @@ ftrace_stacktrace_count(unsigned long ip, unsigned long parent_ip, void **data)
 		trace_dump_stack(STACK_SKIP);
 }
 
+static void
+ftrace_dump_probe(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	if (update_count(data))
+		ftrace_dump(DUMP_ALL);
+}
+
 static int
 ftrace_probe_print(const char *name, struct seq_file *m,
 		   unsigned long ip, void *data)
@@ -327,6 +334,13 @@ ftrace_stacktrace_print(struct seq_file *m, unsigned long ip,
 	return ftrace_probe_print("stacktrace", m, ip, data);
 }
 
+static int
+ftrace_dump_print(struct seq_file *m, unsigned long ip,
+			struct ftrace_probe_ops *ops, void *data)
+{
+	return ftrace_probe_print("dump", m, ip, data);
+}
+
 static struct ftrace_probe_ops traceon_count_probe_ops = {
 	.func			= ftrace_traceon_count,
 	.print			= ftrace_traceon_print,
@@ -342,6 +356,11 @@ static struct ftrace_probe_ops stacktrace_count_probe_ops = {
 	.print			= ftrace_stacktrace_print,
 };
 
+static struct ftrace_probe_ops dump_probe_ops = {
+	.func			= ftrace_dump_probe,
+	.print			= ftrace_dump_print,
+};
+
 static struct ftrace_probe_ops traceon_probe_ops = {
 	.func			= ftrace_traceon,
 	.print			= ftrace_traceon_print,
@@ -425,6 +444,19 @@ ftrace_stacktrace_callback(struct ftrace_hash *hash,
 					   param, enable);
 }
 
+static int
+ftrace_dump_callback(struct ftrace_hash *hash,
+			   char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_probe_ops *ops;
+
+	ops = &dump_probe_ops;
+
+	/* Only dump once. */
+	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
+					   "1", enable);
+}
+
 static struct ftrace_func_command ftrace_traceon_cmd = {
 	.name			= "traceon",
 	.func			= ftrace_trace_onoff_callback,
@@ -440,6 +472,11 @@ static struct ftrace_func_command ftrace_stacktrace_cmd = {
 	.func			= ftrace_stacktrace_callback,
 };
 
+static struct ftrace_func_command ftrace_dump_cmd = {
+	.name			= "dump",
+	.func			= ftrace_dump_callback,
+};
+
 static int __init init_func_cmd_traceon(void)
 {
 	int ret;
@@ -450,13 +487,25 @@ static int __init init_func_cmd_traceon(void)
 
 	ret = register_ftrace_command(&ftrace_traceon_cmd);
 	if (ret)
-		unregister_ftrace_command(&ftrace_traceoff_cmd);
+		goto out_free_traceoff;
 
 	ret = register_ftrace_command(&ftrace_stacktrace_cmd);
-	if (ret) {
-		unregister_ftrace_command(&ftrace_traceoff_cmd);
-		unregister_ftrace_command(&ftrace_traceon_cmd);
-	}
+	if (ret)
+		goto out_free_traceon;
+
+	ret = register_ftrace_command(&ftrace_dump_cmd);
+	if (ret)
+		goto out_free_stacktrace;
+
+	return 0;
+
+ out_free_stacktrace:
+	unregister_ftrace_command(&ftrace_stacktrace_cmd);
+ out_free_traceon:
+	unregister_ftrace_command(&ftrace_traceon_cmd);
+ out_free_traceoff:
+	unregister_ftrace_command(&ftrace_traceoff_cmd);
+
 	return ret;
 }
 #else
-- 
1.7.10.4


