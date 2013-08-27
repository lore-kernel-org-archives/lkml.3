Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3H0Ivc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:51:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51891 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab3H0ItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:05 -0400
X-AuditID: 9c930197-b7b44ae00000347f-4e-521c67fb3efd
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 09/13] tracing/kprobes: Integrate duplicate set_print_fmt()
Date: Tue, 27 Aug 2013 17:48:52 +0900
Message-Id: <1377593336-16828-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The set_print_fmt() functions are implemented almost same for
[ku]probes.  Move it to a common place and get rid of the duplication.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
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
index 2a668516f0e4..3159b114f215 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1133,67 +1133,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-static int __set_print_fmt(struct trace_kprobe *tp, char *buf, int len)
-{
-	int i;
-	int pos = 0;
-
-	const char *fmt, *arg;
-
-	if (!trace_kprobe_is_return(tp)) {
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
-	for (i = 0; i < tp->p.nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tp->p.args[i].name, tp->p.args[i].type->fmt);
-	}
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
-
-	for (i = 0; i < tp->p.nr_args; i++) {
-		if (strcmp(tp->p.args[i].type->name, "string") == 0)
-			pos += snprintf(buf + pos, LEN_OR_ZERO,
-					", __get_str(%s)",
-					tp->p.args[i].name);
-		else
-			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-					tp->p.args[i].name);
-	}
-
-#undef LEN_OR_ZERO
-
-	/* return the length of print_fmt */
-	return pos;
-}
-
-static int set_print_fmt(struct trace_kprobe *tp)
-{
-	int len;
-	char *print_fmt;
-
-	/* First: called with 0 length to calculate the needed length */
-	len = __set_print_fmt(tp, NULL, 0);
-	print_fmt = kmalloc(len + 1, GFP_KERNEL);
-	if (!print_fmt)
-		return -ENOMEM;
-
-	/* Second: actually write the @print_fmt */
-	__set_print_fmt(tp, print_fmt, len + 1);
-	tp->p.call.print_fmt = print_fmt;
-
-	return 0;
-}
-
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
@@ -1344,7 +1283,7 @@ static int register_kprobe_event(struct trace_kprobe *tp)
 		call->event.funcs = &kprobe_funcs;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
-	if (set_print_fmt(tp) < 0)
+	if (set_print_fmt(&tp->p, trace_kprobe_is_return(tp)) < 0)
 		return -ENOMEM;
 	ret = register_ftrace_event(&call->event);
 	if (!ret) {
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index b7b8bda02d6e..1ab83d4c7775 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -629,3 +629,65 @@ out:
 
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
index 189a40baea98..325989f24dbf 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -350,3 +350,5 @@ store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
 				   data + tp->args[i].offset);
 	}
 }
+
+extern int set_print_fmt(struct trace_probe *tp, bool is_return);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index abb95529d851..9f2d12d2311d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -681,59 +681,6 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
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
-	for (i = 0; i < tu->p.nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tu->p.args[i].name, tu->p.args[i].type->fmt);
-	}
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
-
-	for (i = 0; i < tu->p.nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-				tu->p.args[i].name);
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
-	tu->p.call.print_fmt = print_fmt;
-
-	return 0;
-}
-
 #ifdef CONFIG_PERF_EVENTS
 static bool
 __uprobe_perf_filter(struct trace_uprobe_filter *filter, struct mm_struct *mm)
@@ -965,7 +912,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 	call->event.funcs = &uprobe_funcs;
 	call->class->define_fields = uprobe_event_define_fields;
 
-	if (set_print_fmt(tu) < 0)
+	if (set_print_fmt(&tu->p, is_ret_probe(tu)) < 0)
 		return -ENOMEM;
 
 	ret = register_ftrace_event(&call->event);
-- 
1.7.11.7

