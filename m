Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaACCMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:12:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31592 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753307AbaACCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:51 -0500
Message-Id: <20140103021146.728137570@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hyeoncheol Lee <cheol.lee@lge.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 15/17] tracing/uprobes: Add support for full argument access methods
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0015-tracing-uprobes-Add-support-for-full-argument-access.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Enable to fetch other types of argument for the uprobes.  IOW, we can
access stack, memory, deref, bitfield and retval from uprobes now.

The format for the argument types are same as kprobes (but @SYMBOL
type is not supported for uprobes), i.e:

  @ADDR   : Fetch memory at ADDR
  $stackN : Fetch Nth entry of stack (N >= 0)
  $stack  : Fetch stack address
  $retval : Fetch return value
  +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address

Note that the retval only can be used with uretprobes.

Original-patch-by: Hyeoncheol Lee <cheol.lee@lge.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/trace/uprobetracer.txt | 25 +++++++++++++++++++++++++
 kernel/trace/trace_probe.c           | 34 ++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index 8f1a8b89..6e5cff2 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -31,6 +31,31 @@ Synopsis of uprobe_tracer
 
   FETCHARGS     : Arguments. Each probe can have up to 128 args.
    %REG         : Fetch register REG
+   @ADDR	: Fetch memory at ADDR (ADDR should be in userspace)
+   $stackN	: Fetch Nth entry of stack (N >= 0)
+   $stack	: Fetch stack address.
+   $retval	: Fetch return value.(*)
+   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(**)
+   NAME=FETCHARG     : Set NAME as the argument name of FETCHARG.
+   FETCHARG:TYPE     : Set TYPE as the type of FETCHARG. Currently, basic types
+		       (u8/u16/u32/u64/s8/s16/s32/s64), "string" and bitfield
+		       are supported.
+
+  (*) only for return probe.
+  (**) this is useful for fetching a field of data structures.
+
+Types
+-----
+Several types are supported for fetch-args. Uprobe tracer will access memory
+by given type. Prefix 's' and 'u' means those types are signed and unsigned
+respectively. Traced arguments are shown in decimal (signed) or hex (unsigned).
+String type is a special type, which fetches a "null-terminated" string from
+user space.
+Bitfield is another special type, which takes 3 parameters, bit-width, bit-
+offset, and container-size (usually 32). The syntax is;
+
+ b<bit-width>@<bit-offset>/<container-size>
+
 
 Event Profiling
 ---------------
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 8f7a2b6d..a130d61 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -255,12 +255,18 @@ fail:
 }
 
 /* Special function : only accept unsigned long */
-static __kprobes void fetch_stack_address(struct pt_regs *regs,
-					void *dummy, void *dest)
+static __kprobes void fetch_kernel_stack_address(struct pt_regs *regs,
+						 void *dummy, void *dest)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
 
+static __kprobes void fetch_user_stack_address(struct pt_regs *regs,
+					       void *dummy, void *dest)
+{
+	*(unsigned long *)dest = user_stack_pointer(regs);
+}
+
 static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
 					    fetch_func_t orig_fn,
 					    const struct fetch_type *ftbl)
@@ -305,7 +311,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
 static int parse_probe_vars(char *arg, const struct fetch_type *t,
-			    struct fetch_param *f, bool is_return)
+			    struct fetch_param *f, bool is_return,
+			    bool is_kprobe)
 {
 	int ret = 0;
 	unsigned long param;
@@ -317,13 +324,16 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			ret = -EINVAL;
 	} else if (strncmp(arg, "stack", 5) == 0) {
 		if (arg[5] == '\0') {
-			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
-				f->fn = fetch_stack_address;
+			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
+				return -EINVAL;
+
+			if (is_kprobe)
+				f->fn = fetch_kernel_stack_address;
 			else
-				ret = -EINVAL;
+				f->fn = fetch_user_stack_address;
 		} else if (isdigit(arg[5])) {
 			ret = kstrtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
+			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
 				ret = -EINVAL;
 			else {
 				f->fn = t->fetch[FETCH_MTD_stack];
@@ -350,13 +360,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
 	BUG_ON(ftbl == NULL);
 
-	/* Until uprobe_events supports only reg arguments */
-	if (!is_kprobe && arg[0] != '%')
-		return -EINVAL;
-
 	switch (arg[0]) {
 	case '$':
-		ret = parse_probe_vars(arg + 1, t, f, is_return);
+		ret = parse_probe_vars(arg + 1, t, f, is_return, is_kprobe);
 		break;
 
 	case '%':	/* named register */
@@ -377,6 +383,10 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
 		} else {
+			/* uprobes don't support symbols */
+			if (!is_kprobe)
+				return -EINVAL;
+
 			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
-- 
1.8.4.3


