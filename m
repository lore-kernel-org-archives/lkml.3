Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3K0GVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:21:21 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56223 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3K0GUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:15 -0500
X-AuditID: 9c930197-b7caaae000001cef-c3-52958f175768
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH/RFC 17/17] tracing/uprobes: Add @+file_offset fetch method
Date: Wed, 27 Nov 2013 15:20:03 +0900
Message-Id: <1385533203-10014-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Enable to fetch data from a file offset.  Currently it only supports
fetching from same binary uprobe set.  It'll translate the file offset
to a proper virtual address in the process.

The syntax is "@+OFFSET" as it does similar to normal memory fetching
(@ADDR) which does no address translation.

To do it, change fifth argument to receive 'void *priv' and make it
set only for uprobes so that we can determine the arg is for kprobes
or uprobes easily.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/trace/uprobetracer.txt |  1 +
 kernel/trace/trace_kprobe.c          | 10 +++++++++-
 kernel/trace/trace_probe.c           | 32 +++++++++++++++++++++++++++-----
 kernel/trace/trace_probe.h           |  9 ++++++++-
 kernel/trace/trace_uprobe.c          | 36 +++++++++++++++++++++++++++++++++++-
 5 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index 6e5cff263e2b..f1cf9a34ad9d 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -32,6 +32,7 @@ Synopsis of uprobe_tracer
   FETCHARGS     : Arguments. Each probe can have up to 128 args.
    %REG         : Fetch register REG
    @ADDR	: Fetch memory at ADDR (ADDR should be in userspace)
+   @+OFFSET	: Fetch memory at OFFSET (OFFSET from same file as PATH)
    $stackN	: Fetch Nth entry of stack (N >= 0)
    $stack	: Fetch stack address.
    $retval	: Fetch return value.(*)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5c4f72d45b97..300fd0f8b2a9 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -239,6 +239,14 @@ DEFINE_BASIC_FETCH_FUNCS(symbol)
 DEFINE_FETCH_symbol(string)
 DEFINE_FETCH_symbol(string_size)
 
+/* kprobes don't support file_offset fetch methods */
+#define fetch_file_offset_u8		NULL
+#define fetch_file_offset_u16		NULL
+#define fetch_file_offset_u32		NULL
+#define fetch_file_offset_u64		NULL
+#define fetch_file_offset_string	NULL
+#define fetch_file_offset_string_size	NULL
+
 /* Fetch type information table */
 const struct fetch_type kprobes_fetch_type_table[] = {
 	/* Special types */
@@ -758,7 +766,7 @@ static int create_trace_kprobe(int argc, char **argv)
 
 		/* Parse fetch argument */
 		ret = traceprobe_parse_probe_arg(arg, &tp->p.size, parg,
-						is_return, true);
+						is_return, NULL);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 1be603d45811..bd16aed615b2 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -348,13 +348,14 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 
 /* Recursive argument parser */
 static int parse_probe_arg(char *arg, const struct fetch_type *t,
-		     struct fetch_param *f, bool is_return, bool is_kprobe)
+		     struct fetch_param *f, bool is_return, void *priv)
 {
 	const struct fetch_type *ftbl;
 	unsigned long param;
 	long offset;
 	char *tmp;
 	int ret = 0;
+	bool is_kprobe = (priv == NULL);
 
 	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
 	BUG_ON(ftbl == NULL);
@@ -373,7 +374,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		}
 		break;
 
-	case '@':	/* memory or symbol */
+	case '@':	/* memory, file-offset or symbol */
 		if (isdigit(arg[1])) {
 			ret = kstrtoul(arg + 1, 0, &param);
 			if (ret)
@@ -381,6 +382,26 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
+		} else if (arg[1] == '+') {
+			struct file_offset_fetch_param *foprm;
+
+			/* kprobes don't support file offsets */
+			if (is_kprobe)
+				return -EINVAL;
+
+			ret = kstrtol(arg + 2, 0, &offset);
+			if (ret)
+				break;
+
+			foprm = kzalloc(sizeof(*foprm), GFP_KERNEL);
+			if (!foprm)
+				return -ENOMEM;
+
+			foprm->tu = priv;
+			foprm->offset = offset;
+
+			f->fn = t->fetch[FETCH_MTD_file_offset];
+			f->data = foprm;
 		} else {
 			/* uprobes don't support symbols */
 			if (!is_kprobe)
@@ -428,7 +449,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			dprm->fetch_size = get_fetch_size_function(t,
 							dprm->fetch, ftbl);
 			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
-							is_kprobe);
+							priv);
 			if (ret)
 				kfree(dprm);
 			else {
@@ -486,11 +507,12 @@ static int __parse_bitfield_probe_arg(const char *bf,
 
 /* String length checking wrapper */
 int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
-		struct probe_arg *parg, bool is_return, bool is_kprobe)
+		struct probe_arg *parg, bool is_return, void *priv)
 {
 	const struct fetch_type *ftbl;
 	const char *t;
 	int ret;
+	bool is_kprobe = (priv == NULL);
 
 	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
 	BUG_ON(ftbl == NULL);
@@ -516,7 +538,7 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 	}
 	parg->offset = *size;
 	*size += parg->type->size;
-	ret = parse_probe_arg(arg, parg->type, &parg->fetch, is_return, is_kprobe);
+	ret = parse_probe_arg(arg, parg->type, &parg->fetch, is_return, priv);
 
 	if (ret >= 0 && t != NULL)
 		ret = __parse_bitfield_probe_arg(t, parg->type, &parg->fetch);
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index c2f9adbfab3f..ea0c80d37c31 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -106,6 +106,7 @@ enum {
 	FETCH_MTD_symbol,
 	FETCH_MTD_deref,
 	FETCH_MTD_bitfield,
+	FETCH_MTD_file_offset,
 	FETCH_MTD_END,
 };
 
@@ -217,6 +218,7 @@ ASSIGN_FETCH_FUNC(memory, ftype),			\
 ASSIGN_FETCH_FUNC(symbol, ftype),			\
 ASSIGN_FETCH_FUNC(deref, ftype),			\
 ASSIGN_FETCH_FUNC(bitfield, ftype),			\
+ASSIGN_FETCH_FUNC(file_offset, ftype),			\
 	  }						\
 	}
 
@@ -291,6 +293,11 @@ static inline __kprobes void call_fetch(struct fetch_param *fprm,
 	return fprm->fn(regs, fprm->data, dest);
 }
 
+struct file_offset_fetch_param {
+	unsigned long 		offset;
+	struct trace_uprobe	*tu;
+};
+
 /* Check the name is good for event/group/fields */
 static inline int is_good_name(const char *name)
 {
@@ -304,7 +311,7 @@ static inline int is_good_name(const char *name)
 }
 
 extern int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
-		   struct probe_arg *parg, bool is_return, bool is_kprobe);
+		   struct probe_arg *parg, bool is_return, void *priv);
 
 extern int traceprobe_conflict_field_name(const char *name,
 			       struct probe_arg *args, int narg);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c037477d1c1a..fb1b81e2603a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -175,6 +175,26 @@ static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 #define fetch_symbol_string		NULL
 #define fetch_symbol_string_size	NULL
 
+static unsigned long translate_user_vaddr(struct file_offset_fetch_param *foprm)
+{
+	unsigned long base_addr;
+
+	base_addr = current->utask->vaddr - foprm->tu->offset;
+	return base_addr + foprm->offset;
+}
+
+#define DEFINE_FETCH_file_offset(type)					\
+static __kprobes void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,\
+					void *data, void *dest) 	\
+{									\
+	void *vaddr = (void *)translate_user_vaddr(data);		\
+									\
+	FETCH_FUNC_NAME(memory, type)(regs, vaddr, dest);		\
+}
+DEFINE_BASIC_FETCH_FUNCS(file_offset)
+DEFINE_FETCH_file_offset(string)
+DEFINE_FETCH_file_offset(string_size)
+
 /* Fetch type information table */
 const struct fetch_type uprobes_fetch_type_table[] = {
 	/* Special types */
@@ -512,7 +532,7 @@ static int create_trace_uprobe(int argc, char **argv)
 
 		/* Parse fetch argument */
 		ret = traceprobe_parse_probe_arg(arg, &tu->p.size, parg,
-						 is_return, false);
+						 is_return, tu);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
@@ -1104,11 +1124,18 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
+	struct uprobe_task *utask;
 	int ret = 0;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
+	utask = current->utask;
+	if (utask == NULL)
+		return UPROBE_HANDLER_REMOVE;
+
+	utask->vaddr = instruction_pointer(regs);
+
 	if (tu->p.flags & TP_FLAG_TRACE)
 		ret |= uprobe_trace_func(tu, regs);
 
@@ -1123,9 +1150,16 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
+	struct uprobe_task *utask;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
+	utask = current->utask;
+	if (utask == NULL)
+		return UPROBE_HANDLER_REMOVE;
+
+	utask->vaddr = func;
+
 	if (tu->p.flags & TP_FLAG_TRACE)
 		uretprobe_trace_func(tu, func, regs);
 
-- 
1.7.11.7

