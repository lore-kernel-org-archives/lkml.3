Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3GCMgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:36:31 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65413 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab3GCMf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:56 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-f9-51d41aa5b51a
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 12/12] tracing/uprobes: Add support for full argument access methods
Date: Wed,  3 Jul 2013 21:35:46 +0900
Message-Id: <1372854946-17074-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Enable to fetch other types of argument for the uprobes.  IOW, we can
access stack, memory, deref, bitfield and retval from uprobes now.

Original-patch-by: Hyeoncheol Lee <cheol.lee@lge.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index a46c9fd494ff..8ad48ca4e344 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -318,7 +318,7 @@ fail:
 }
 
 /* Special function : only accept unsigned long */
-static __kprobes void fetch_stack_address(struct pt_regs *regs,
+static __kprobes void fetch_kernel_stack_address(struct pt_regs *regs,
 					  void *dummy, void *dest, void *priv)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
@@ -368,7 +368,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
 static int parse_probe_vars(char *arg, const struct fetch_type *t,
-			    struct fetch_param *f, bool is_return)
+			    struct fetch_param *f, bool is_return,
+			    bool is_kprobe)
 {
 	int ret = 0;
 	unsigned long param;
@@ -380,13 +381,18 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			ret = -EINVAL;
 	} else if (strncmp(arg, "stack", 5) == 0) {
 		if (arg[5] == '\0') {
-			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
-				f->fn = fetch_stack_address;
-			else
-				ret = -EINVAL;
+			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
+				return -EINVAL;
+
+			if (is_kprobe)
+				f->fn = fetch_kernel_stack_address;
+			else {
+				f->fn = t->fetch[FETCH_MTD_stack];
+				f->data = (void *)0;
+			}
 		} else if (isdigit(arg[5])) {
 			ret = kstrtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
+			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
 				ret = -EINVAL;
 			else {
 				f->fn = t->fetch[FETCH_MTD_stack];
@@ -410,17 +416,13 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 	int ret;
 	const struct fetch_type *ttbl;
 
-	ttbl = kprobes_fetch_type_table;
+	ttbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
 
 	ret = 0;
 
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
@@ -443,6 +445,10 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		} else {
 			struct symbol_cache *sc;
 
+			/* uprobes don't support symbols */
+			if (!is_kprobe)
+				return -EINVAL;
+
 			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
@@ -554,7 +560,7 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 	int ret;
 	const struct fetch_type *ttbl;
 
-	ttbl = kprobes_fetch_type_table;
+	ttbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
 
 	if (strlen(arg) > MAX_ARGSTR_LEN) {
 		pr_info("Argument is too long.: %s\n",  arg);
-- 
1.7.11.7

