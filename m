Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3KYT3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab3KYT3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:29:07 -0500
Date: Mon, 25 Nov 2013 20:30:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tracing: Kill FETCH_MTD_retval, reimplement $retval
	via pseudo_reg_retval()
Message-ID: <20131125193016.GC9737@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125192926.GA9737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125192926.GA9737@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have pseudo_reg_table[] we can kill FETCH_MTD_retval
and related code, we can simply add the new pseudo_reg_retval()
entry into the pseudo_reg_table[],

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_probe.c |   42 +++++++++++++++++++-----------------------
 kernel/trace/trace_probe.h |    1 -
 2 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index b066e9d..fce222f 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -135,17 +135,6 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string	NULL
 #define fetch_stack_string_size	NULL
 
-#define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
-					  void *dummy, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_return_value(regs);			\
-}
-DEFINE_BASIC_FETCH_FUNCS(retval)
-/* No string on the retval */
-#define fetch_retval_string		NULL
-#define fetch_retval_string_size	NULL
-
 #define DEFINE_FETCH_memory(type)					\
 static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
 					  void *addr, void *dest)	\
@@ -394,7 +383,6 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 	 .fetch = {					\
 ASSIGN_FETCH_FUNC(reg, ftype),				\
 ASSIGN_FETCH_FUNC(stack, ftype),			\
-ASSIGN_FETCH_FUNC(retval, ftype),			\
 ASSIGN_FETCH_FUNC(memory, ftype),			\
 ASSIGN_FETCH_FUNC(symbol, ftype),			\
 ASSIGN_FETCH_FUNC(deref, ftype),			\
@@ -514,22 +502,31 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 	return 0;
 }
 
-static unsigned long pseudo_reg_cpu(void)
+static unsigned long pseudo_reg_retval(struct pt_regs *regs)
+{
+	return regs_return_value(regs);
+}
+
+static unsigned long pseudo_reg_cpu(struct pt_regs *regs)
 {
 	return (unsigned long)raw_smp_processor_id();
 }
 
-static unsigned long pseudo_reg_current(void)
+static unsigned long pseudo_reg_current(struct pt_regs *regs)
 {
 	return (unsigned long)current;
 }
 
 static struct {
 	const char *name;
-	unsigned long (*fetch)(void);
+	unsigned long (*fetch)(struct pt_regs *regs);
 }
 const pseudo_reg_table[] = {
 	{
+		.name	= "retval",
+		.fetch	= pseudo_reg_retval,
+	},
+	{
 		.name	= "cpu",
 		.fetch	= pseudo_reg_cpu,
 	},
@@ -546,7 +543,7 @@ static unsigned long probe_get_register(struct pt_regs *regs, unsigned long offs
 	if (offset < PSEUDO_REG_OFFSET)
 		return regs_get_register(regs, offset);
 
-	return pseudo_reg_table[offset - PSEUDO_REG_OFFSET].fetch();
+	return pseudo_reg_table[offset - PSEUDO_REG_OFFSET].fetch(regs);
 }
 
 static int pseudo_reg_query_offset(const char *name)
@@ -568,12 +565,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 	int ret = 0;
 	unsigned long param;
 
-	if (strcmp(arg, "retval") == 0) {
-		if (is_return)
-			f->fn = t->fetch[FETCH_MTD_retval];
-		else
-			ret = -EINVAL;
-	} else if (strncmp(arg, "stack", 5) == 0) {
+	if (strncmp(arg, "stack", 5) == 0) {
 		if (arg[5] == '\0') {
 			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
 				f->fn = fetch_stack_address;
@@ -590,7 +582,11 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 		} else
 			ret = -EINVAL;
 	} else {
-		ret = pseudo_reg_query_offset(arg);
+		if (strcmp(arg, "retval") == 0 && !is_return)
+			ret = -EINVAL;
+		else
+			ret = pseudo_reg_query_offset(arg);
+
 		if (ret >= 0) {
 			f->fn = t->fetch[FETCH_MTD_reg];
 			f->data = (void *)(unsigned long)ret;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 5c7e09d..b6f33b1 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -90,7 +90,6 @@ typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *, void
 enum {
 	FETCH_MTD_reg = 0,
 	FETCH_MTD_stack,
-	FETCH_MTD_retval,
 	FETCH_MTD_memory,
 	FETCH_MTD_symbol,
 	FETCH_MTD_deref,
-- 
1.5.5.1


