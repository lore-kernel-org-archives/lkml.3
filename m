Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaACCND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:13:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753290AbaACCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:51 -0500
Message-Id: <20140103021147.109021378@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 17/17] tracing/uprobes: Add @+file_offset fetch method
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-uprobes-Add-file_offset-fetch-method.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
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
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
index 6e5cff2..f1cf9a3 100644
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
index f94a569..ce0ed8a 100644
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
index a130d61..8364a42 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -374,7 +374,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		}
 		break;
 
-	case '@':	/* memory or symbol */
+	case '@':	/* memory, file-offset or symbol */
 		if (isdigit(arg[1])) {
 			ret = kstrtoul(arg + 1, 0, &param);
 			if (ret)
@@ -382,6 +382,17 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
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
index 2d5b8f5..e29d743 100644
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
index 794e8bc..1fdea6d 100644
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
@@ -1106,11 +1134,17 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
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
 
@@ -1125,9 +1159,15 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
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
1.8.4.3


