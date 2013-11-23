Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3KWUPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 15:15:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab3KWUPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 15:15:01 -0500
Date: Sat, 23 Nov 2013 21:16:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] tracing: Introduce "pseudo registers" for FETCH_MTD_reg
Message-ID: <20131123201605.GB22148@redhat.com>
References: <20131123201543.GA22148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123201543.GA22148@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe can dump the registers or memory, but it is not possible
to dump, say, current->pid. This patch adds the pseudo regs table,
currently it has only two methods to get current/smp_processor_id
but it can be trivially extended.

This syntax is %%pseudo-reg-name, I agree in advance with any other
naming.

Test-case: 452 == offsetof(task_struct, pid), 39 == __NR_getpid,

  # perf probe 'sys_getpid%return ret=$retval:s32 pid=+452(%%current):s32'
  # perf record -e probe:sys_getpid perl -e 'syscall 39'
  # perf --no-pager script | tail -1
	perl   586 [001]   753.102549: probe:sys_getpid: \
	(ffffffff81052c00 <- ffffffff8134d012) ret=586 pid=586

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_probe.c |   57 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959..e167c0a 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -109,13 +109,14 @@ DEFINE_FETCH_##method(u64)
 	  (FETCH_FUNC_NAME(method, string_size) == fn)) \
 	 && (fn != NULL))
 
+static unsigned long probe_get_register(struct pt_regs *, unsigned long);
+
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
 static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
 					void *offset, void *dest)	\
 {									\
-	*(type *)dest = (type)regs_get_register(regs,			\
-				(unsigned int)((unsigned long)offset));	\
+	*(type *)dest = (type)probe_get_register(regs, (long)offset);	\
 }
 DEFINE_BASIC_FETCH_FUNCS(reg)
 /* No string on the register */
@@ -548,6 +549,52 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 	return ret;
 }
 
+#define PSEUDO_REG_OFFSET	4096	/* arbitrary value > MAX_REG_OFFSET */
+
+static unsigned long pseudo_reg_cpu(void)
+{
+	return (unsigned long)raw_smp_processor_id();
+}
+
+static unsigned long pseudo_reg_current(void)
+{
+	return (unsigned long)current;
+}
+
+static struct {
+	const char *name;
+	unsigned long (*fetch)(void);
+}
+const pseudo_reg_table[] = {
+	{
+		.name	= "cpu",
+		.fetch	= pseudo_reg_cpu,
+	},
+	{
+		.name	= "current",
+		.fetch	= pseudo_reg_current,
+	},
+};
+
+static unsigned long probe_get_register(struct pt_regs *regs, unsigned long offset)
+{
+	if (offset < PSEUDO_REG_OFFSET)
+		return regs_get_register(regs, offset);
+
+	return pseudo_reg_table[offset - PSEUDO_REG_OFFSET].fetch();
+}
+
+static int pseudo_reg_query_offset(const char *name)
+{
+	int nr;
+
+	for (nr = 0; nr < ARRAY_SIZE(pseudo_reg_table); ++nr)
+		if (strcmp(pseudo_reg_table[nr].name, name) == 0)
+			return PSEUDO_REG_OFFSET + nr;
+
+	return -EINVAL;
+}
+
 /* Recursive argument parser */
 static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		     struct fetch_param *f, bool is_return, bool is_kprobe)
@@ -569,7 +616,11 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		break;
 
 	case '%':	/* named register */
-		ret = regs_query_register_offset(arg + 1);
+		if (arg[1] == '%')
+			ret = pseudo_reg_query_offset(arg + 2);
+		else
+			ret = regs_query_register_offset(arg + 1);
+
 		if (ret >= 0) {
 			f->fn = t->fetch[FETCH_MTD_reg];
 			f->data = (void *)(unsigned long)ret;
-- 
1.5.5.1


