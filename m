Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaACCLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:11:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31592 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751870AbaACCLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:47 -0500
Message-Id: <20140103021145.370538700@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 06/17] tracing/probes: Integrate duplicate set_print_fmt()
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-probes-Integrate-duplicate-set_print_fmt.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The set_print_fmt() functions are implemented almost same for
[ku]probes.  Move it to a common place and get rid of the duplication.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 63 +--------------------------------------------
 kernel/trace/trace_probe.c  | 62 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |  2 ++
 kernel/trace/trace_uprobe.c | 55 +--------------------------------------
 4 files changed, 66 insertions(+), 116 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index fb1a027..c9ffdaf 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -964,67 +964,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-static int __set_print_fmt(struct trace_kprobe *tk, char *buf, int len)
-{
-	int i;
-	int pos = 0;
-
-	const char *fmt, *arg;
-
-	if (!trace_kprobe_is_return(tk)) {
-		fmt = "(%lx)";
-		arg = "REC->" FIELD_STRING_IP;
-	} else {
-		fmt = "(%lx <- %lx)";
-		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
-	}
-
-	/* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
-
-	for (i = 0; i < tk->tp.nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tk->tp.args[i].name, tk->tp.args[i].type->fmt);
-	}
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
-
-	for (i = 0; i < tk->tp.nr_args; i++) {
-		if (strcmp(tk->tp.args[i].type->name, "string") == 0)
-			pos += snprintf(buf + pos, LEN_OR_ZERO,
-					", __get_str(%s)",
-					tk->tp.args[i].name);
-		else
-			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-					tk->tp.args[i].name);
-	}
-
-#undef LEN_OR_ZERO
-
-	/* return the length of print_fmt */
-	return pos;
-}
-
-static int set_print_fmt(struct trace_kprobe *tk)
-{
-	int len;
-	char *print_fmt;
-
-	/* First: called with 0 length to calculate the needed length */
-	len = __set_print_fmt(tk, NULL, 0);
-	print_fmt = kmalloc(len + 1, GFP_KERNEL);
-	if (!print_fmt)
-		return -ENOMEM;
-
-	/* Second: actually write the @print_fmt */
-	__set_print_fmt(tk, print_fmt, len + 1);
-	tk->tp.call.print_fmt = print_fmt;
-
-	return 0;
-}
-
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
@@ -1175,7 +1114,7 @@ static int register_kprobe_event(struct trace_kprobe *tk)
 		call->event.funcs = &kprobe_funcs;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
-	if (set_print_fmt(tk) < 0)
+	if (set_print_fmt(&tk->tp, trace_kprobe_is_return(tk)) < 0)
 		return -ENOMEM;
 	ret = register_ftrace_event(&call->event);
 	if (!ret) {
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 430505b..d8347b0 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -837,3 +837,65 @@ out:
 
 	return ret;
 }
+
+static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
+			   bool is_return)
+{
+	int i;
+	int pos = 0;
+
+	const char *fmt, *arg;
+
+	if (!is_return) {
+		fmt = "(%lx)";
+		arg = "REC->" FIELD_STRING_IP;
+	} else {
+		fmt = "(%lx <- %lx)";
+		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
+	}
+
+	/* When len=0, we just calculate the needed length */
+#define LEN_OR_ZERO (len ? len - pos : 0)
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
+				tp->args[i].name, tp->args[i].type->fmt);
+	}
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		if (strcmp(tp->args[i].type->name, "string") == 0)
+			pos += snprintf(buf + pos, LEN_OR_ZERO,
+					", __get_str(%s)",
+					tp->args[i].name);
+		else
+			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
+					tp->args[i].name);
+	}
+
+#undef LEN_OR_ZERO
+
+	/* return the length of print_fmt */
+	return pos;
+}
+
+int set_print_fmt(struct trace_probe *tp, bool is_return)
+{
+	int len;
+	char *print_fmt;
+
+	/* First: called with 0 length to calculate the needed length */
+	len = __set_print_fmt(tp, NULL, 0, is_return);
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
+
+	/* Second: actually write the @print_fmt */
+	__set_print_fmt(tp, print_fmt, len + 1, is_return);
+	tp->call.print_fmt = print_fmt;
+
+	return 0;
+}
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index d384fbd..2c979cb 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -226,3 +226,5 @@ store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
 				   data + tp->args[i].offset);
 	}
 }
+
+extern int set_print_fmt(struct trace_probe *tp, bool is_return);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index afda372..b233d9c 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -682,59 +682,6 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-#define LEN_OR_ZERO		(len ? len - pos : 0)
-static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
-{
-	const char *fmt, *arg;
-	int i;
-	int pos = 0;
-
-	if (is_ret_probe(tu)) {
-		fmt = "(%lx <- %lx)";
-		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
-	} else {
-		fmt = "(%lx)";
-		arg = "REC->" FIELD_STRING_IP;
-	}
-
-	/* When len=0, we just calculate the needed length */
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
-
-	for (i = 0; i < tu->tp.nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tu->tp.args[i].name, tu->tp.args[i].type->fmt);
-	}
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
-
-	for (i = 0; i < tu->tp.nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-				tu->tp.args[i].name);
-	}
-
-	return pos;	/* return the length of print_fmt */
-}
-#undef LEN_OR_ZERO
-
-static int set_print_fmt(struct trace_uprobe *tu)
-{
-	char *print_fmt;
-	int len;
-
-	/* First: called with 0 length to calculate the needed length */
-	len = __set_print_fmt(tu, NULL, 0);
-	print_fmt = kmalloc(len + 1, GFP_KERNEL);
-	if (!print_fmt)
-		return -ENOMEM;
-
-	/* Second: actually write the @print_fmt */
-	__set_print_fmt(tu, print_fmt, len + 1);
-	tu->tp.call.print_fmt = print_fmt;
-
-	return 0;
-}
-
 #ifdef CONFIG_PERF_EVENTS
 static bool
 __uprobe_perf_filter(struct trace_uprobe_filter *filter, struct mm_struct *mm)
@@ -966,7 +913,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 	call->event.funcs = &uprobe_funcs;
 	call->class->define_fields = uprobe_event_define_fields;
 
-	if (set_print_fmt(tu) < 0)
+	if (set_print_fmt(&tu->tp, is_ret_probe(tu)) < 0)
 		return -ENOMEM;
 
 	ret = register_ftrace_event(&call->event);
-- 
1.8.4.3


