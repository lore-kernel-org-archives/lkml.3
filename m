Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756Ab3LIGUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:20:54 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57542 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760636Ab3LIGUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:20:25 -0500
X-AuditID: 9c930197-b7bdbae000000e78-9e-52a56123e189
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 17/17] tracing/uprobes: Add @+file_offset fetch method
Date: Mon,  9 Dec 2013 15:20:05 +0900
Message-Id: <1386570005-3368-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
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

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/trace/uprobetracer.txt |  1 +
 kernel/trace/trace_kprobe.c          |  8 ++++++++
 kernel/trace/trace_probe.c           | 13 +++++++++++-
 kernel/trace/trace_probe.h           |  2 ++
 kernel/trace/trace_uprobe.c          | 40 ++++++++++++++++++++++++++++++++++++
 5 files changed, 63 insertions(+), 1 deletion(-)

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
index 8b32236ae890..1cf8f3375559 100644
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
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 464ec506ec08..705c06ba0a8a 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -373,7 +373,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		}
 		break;
 
-	case '@':	/* memory or symbol */
+	case '@':	/* memory, file-offset or symbol */
 		if (isdigit(arg[1])) {
 			ret = kstrtoul(arg + 1, 0, &param);
 			if (ret)
@@ -381,6 +381,17 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
+		} else if (arg[1] == '+') {
+			/* kprobes don't support file offsets */
+			if (is_kprobe)
+				return -EINVAL;
+
+			ret = kstrtol(arg + 2, 0, &offset);
+			if (ret)
+				break;
+
+			f->fn = t->fetch[FETCH_MTD_file_offset];
+			f->data = (void *)offset;
 		} else {
 			/* uprobes don't support symbols */
 			if (!is_kprobe)
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 385206bbbf8b..d9afeb580cbf 100644
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
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f86a6a711de9..f5cbed7e7709 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -70,6 +70,11 @@ static int unregister_uprobe_event(struct trace_uprobe *tu);
 static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
 
+struct uprobe_dispatch_data {
+	struct trace_uprobe	*tu;
+	unsigned long		bp_addr;
+};
+
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
 static int uretprobe_dispatcher(struct uprobe_consumer *con,
 				unsigned long func, struct pt_regs *regs);
@@ -175,6 +180,29 @@ static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 #define fetch_symbol_string		NULL
 #define fetch_symbol_string_size	NULL
 
+static unsigned long translate_user_vaddr(void *file_offset)
+{
+	unsigned long base_addr;
+	struct uprobe_dispatch_data *udd;
+
+	udd = (void *) current->utask->vaddr;
+
+	base_addr = udd->bp_addr - udd->tu->offset;
+	return base_addr + (unsigned long)file_offset;
+}
+
+#define DEFINE_FETCH_file_offset(type)					\
+static __kprobes void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,\
+					void *offset, void *dest) 	\
+{									\
+	void *vaddr = (void *)translate_user_vaddr(offset);		\
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
@@ -1104,11 +1132,17 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
+	struct uprobe_dispatch_data udd;
 	int ret = 0;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
+	udd.tu = tu;
+	udd.bp_addr = instruction_pointer(regs);
+
+	current->utask->vaddr = (unsigned long) &udd;
+
 	if (tu->tp.flags & TP_FLAG_TRACE)
 		ret |= uprobe_trace_func(tu, regs);
 
@@ -1123,9 +1157,15 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
+	struct uprobe_dispatch_data udd;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
+	udd.tu = tu;
+	udd.bp_addr = func;
+
+	current->utask->vaddr = (unsigned long) &udd;
+
 	if (tu->tp.flags & TP_FLAG_TRACE)
 		uretprobe_trace_func(tu, func, regs);
 
-- 
1.7.11.7

