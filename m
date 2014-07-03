Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaGCMAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:00:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbaGCMAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:00:50 -0400
Date: Thu, 3 Jul 2014 14:00:46 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390: add support for DYNAMIC_FTRACE_WITH_REGS
Message-ID: <20140703120046.GA10664@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DYNAMIC_FTRACE_WITH_REGS to 64-bit and 31-bit s390
architectures. This is required for kGraft and kpatch to work on s390.

It's done by adding a _regs variant of ftrace_caller that preserves
registers and puts them on stack in a struct pt_regs layout and
allows modification of return address by changing the PSW (instruction
pointer) member od struct pt_regs. 

Signed-off-by: Vojtech Pavlik <vojtech@suse.cz>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>

---

 arch/s390/Kconfig               |    1 
 arch/s390/include/asm/ftrace.h  |    4 ++
 arch/s390/include/asm/lowcore.h |   12 ++++---
 arch/s390/kernel/asm-offsets.c  |    1 
 arch/s390/kernel/early.c        |    3 +
 arch/s390/kernel/ftrace.c       |   68 +++++++++++++++++++++++++++++++++++-----
 arch/s390/kernel/mcount.S       |   43 +++++++++++++++++++++++++
 arch/s390/kernel/mcount64.S     |   38 ++++++++++++++++++++++
 arch/s390/kernel/setup.c        |    1 
 arch/s390/kernel/smp.c          |    1 
 include/linux/ftrace.h          |    1 
 11 files changed, 160 insertions(+), 13 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bb63499..1de14d3 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -113,6 +113,7 @@ config S390
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DYNAMIC_FTRACE
+	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index bf246da..df87fd2 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -17,6 +17,10 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 
 #endif /* __ASSEMBLY__ */
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+#define ARCH_SUPPORTS_FTRACE_OPS 1
+#endif
+
 #ifdef CONFIG_64BIT
 #define MCOUNT_INSN_SIZE  12
 #else
diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index 4349197..31b064a 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -142,9 +142,10 @@ struct _lowcore {
 	__u32	percpu_offset;			/* 0x02f0 */
 	__u32	machine_flags;			/* 0x02f4 */
 	__u32	ftrace_func;			/* 0x02f8 */
-	__u32	spinlock_lockval;		/* 0x02fc */
+	__u32	ftrace_regs_func;		/* 0x02fc */
+	__u32	spinlock_lockval;		/* 0x0300 */
 
-	__u8	pad_0x0300[0x0e00-0x0300];	/* 0x0300 */
+	__u8	pad_0x0304[0x0e00-0x0304];	/* 0x0304 */
 
 	/*
 	 * 0xe00 contains the address of the IPL Parameter Information
@@ -287,9 +288,10 @@ struct _lowcore {
 	__u64	vdso_per_cpu_data;		/* 0x0380 */
 	__u64	machine_flags;			/* 0x0388 */
 	__u64	ftrace_func;			/* 0x0390 */
-	__u64	gmap;				/* 0x0398 */
-	__u32	spinlock_lockval;		/* 0x03a0 */
-	__u8	pad_0x03a0[0x0400-0x03a4];	/* 0x03a4 */
+	__u64	ftrace_regs_func;		/* 0x0398 */
+	__u64	gmap;				/* 0x03a0 */
+	__u32	spinlock_lockval;		/* 0x03a8 */
+	__u8	pad_0x03ac[0x0400-0x03ac];	/* 0x03ac */
 
 	/* Per cpu primary space access list */
 	__u32	paste[16];			/* 0x0400 */
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index afe1715..12ef6ce 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -150,6 +150,7 @@ int main(void)
 	DEFINE(__LC_MCCK_CLOCK, offsetof(struct _lowcore, mcck_clock));
 	DEFINE(__LC_MACHINE_FLAGS, offsetof(struct _lowcore, machine_flags));
 	DEFINE(__LC_FTRACE_FUNC, offsetof(struct _lowcore, ftrace_func));
+	DEFINE(__LC_FTRACE_REGS_FUNC, offsetof(struct _lowcore, ftrace_regs_func));
 	DEFINE(__LC_DUMP_REIPL, offsetof(struct _lowcore, ipib));
 	BLANK();
 	DEFINE(__LC_CPU_TIMER_SAVE_AREA, offsetof(struct _lowcore, cpu_timer_save_area));
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 0dff972..2ab52d2 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -493,5 +493,8 @@ void __init startup_init(void)
 #ifdef CONFIG_DYNAMIC_FTRACE
 	S390_lowcore.ftrace_func = (unsigned long)ftrace_caller;
 #endif
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	S390_lowcore.ftrace_regs_func = (unsigned long)ftrace_regs_caller;
+#endif
 	lockdep_on();
 }
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 54d6493..7d1ec79 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -21,6 +21,7 @@
 
 void ftrace_disable_code(void);
 void ftrace_enable_insn(void);
+void ftrace_enable_regs_insn(void);
 
 #ifdef CONFIG_64BIT
 /*
@@ -56,7 +57,13 @@ asm(
 	"0:\n"
 	"	.align	4\n"
 	"ftrace_enable_insn:\n"
-	"	lg	%r1,"__stringify(__LC_FTRACE_FUNC)"\n");
+	"	lg	%r1,"__stringify(__LC_FTRACE_FUNC)"\n"
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	"	.align	4\n"
+	"ftrace_enable_regs_insn:\n"
+	"	lg	%r1,"__stringify(__LC_FTRACE_REGS_FUNC)"\n"
+#endif
+);
 
 #define FTRACE_INSN_SIZE	6
 
@@ -101,7 +108,13 @@ asm(
 	"1:\n"
 	"	.align	4\n"
 	"ftrace_enable_insn:\n"
-	"	l	%r14,"__stringify(__LC_FTRACE_FUNC)"\n");
+	"	l	%r14,"__stringify(__LC_FTRACE_FUNC)"\n"
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	"	.align	4\n"
+	"ftrace_enable_regs_insn:\n"
+	"	l	%r14,"__stringify(__LC_FTRACE_REGS_FUNC)"\n"
+#endif
+);
 
 #define FTRACE_INSN_SIZE	4
 
@@ -119,12 +132,29 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	if (probe_kernel_write((void *) rec->ip, ftrace_enable_insn,
-			       FTRACE_INSN_SIZE))
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	if (rec->flags & FTRACE_FL_REGS) {
+		if (probe_kernel_write((void *) rec->ip, ftrace_enable_regs_insn,
+				       FTRACE_INSN_SIZE))
 		return -EPERM;
+	} else
+#endif
+	{
+		if (probe_kernel_write((void *) rec->ip, ftrace_enable_insn,
+				       FTRACE_INSN_SIZE))
+		return -EPERM;
+	}
 	return 0;
 }
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
+				unsigned long addr)
+{
+	return ftrace_make_call(rec, addr);
+}
+#endif
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	return 0;
@@ -173,19 +203,41 @@ out:
 int ftrace_enable_ftrace_graph_caller(void)
 {
 	unsigned short offset;
+	int ret;
+
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	offset = ((void *) prepare_ftrace_return -
+		  (void *) ftrace_regs_graph_caller) / 2;
+	if ((ret = probe_kernel_write((void *) ftrace_regs_graph_caller + 2,
+				  &offset, sizeof(offset))))
+		return ret;
+#endif
 
 	offset = ((void *) prepare_ftrace_return -
 		  (void *) ftrace_graph_caller) / 2;
-	return probe_kernel_write((void *) ftrace_graph_caller + 2,
-				  &offset, sizeof(offset));
+	if ((ret = probe_kernel_write((void *) ftrace_graph_caller + 2,
+				  &offset, sizeof(offset))))
+		return ret;
+
+	return 0;
 }
 
 int ftrace_disable_ftrace_graph_caller(void)
 {
 	static unsigned short offset = 0x0002;
+	int ret;
 
-	return probe_kernel_write((void *) ftrace_graph_caller + 2,
-				  &offset, sizeof(offset));
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	if ((ret = probe_kernel_write((void *) ftrace_regs_graph_caller + 2,
+			  &offset, sizeof(offset))))
+		return ret;
+#endif
+
+	if ((ret = probe_kernel_write((void *) ftrace_graph_caller + 2,
+			  &offset, sizeof(offset))))
+		return ret;
+
+	return 0;
 }
 
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 08dcf21..e4322cf 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -53,6 +53,49 @@ ENTRY(ftrace_graph_caller)
 3:	lm	%r2,%r5,16(%r15)
 	br	%r14
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+ENTRY(ftrace_regs_caller)
+	bras	%r1,1f
+0:	.long	function_trace_stop
+1:	l	%r1,0(%r1)
+	icm	%r1,0xf,0(%r1)
+	bnzr	%r14
+	lr	%r1,%r15
+	ahi	%r15,-188
+	st	%r1,__SF_BACKCHAIN(%r15)
+	st	%r1,168(%r15)
+	stm	%r0,%r13,108(%r15)
+	st	%r14,104(%r15)
+	lr	%r2,%r14
+	ahi	%r2,-MCOUNT_INSN_SIZE
+	l	%r3,192(%r15)
+	st	%r3,164(%r15)
+	bras	%r1,1f
+0:	.long	ftrace_trace_function
+1:	.long	function_trace_op
+	l	%r4,1b-0b(%r1)
+	l	%r4,0(%r4)
+	lr	%r5, %r15
+	ahi	%r5, 96
+	l	%r14,0(%r1)
+	l	%r14,0(%r14)
+	basr	%r14,%r14
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	l	%r2,192(%r15)
+	l	%r3,244(%r15)
+ENTRY(ftrace_regs_graph_caller)
+# The bras instruction gets runtime patched to call prepare_ftrace_return.
+# See ftrace_enable_ftrace_graph_caller. The patched instruction is:
+#	bras	%r14,prepare_ftrace_return
+	bras	%r14,0f
+0:	st	%r2,192(%r15)
+#endif
+	lm	%r0,%r13,108(%r15)
+	l	%r14,104(%r15)
+	ahi	%r15,188
+	br	%r14
+#endif
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 ENTRY(return_to_handler)
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index 1c52eae..bcad958 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -49,6 +49,44 @@ ENTRY(ftrace_graph_caller)
 	lg	%r14,112(%r15)
 	br	%r14
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+ENTRY(ftrace_regs_caller)
+	larl	%r1,function_trace_stop
+	icm	%r1,0xf,0(%r1)
+	bnzr	%r14
+	lgr	%r1,%r15
+	aghi	%r15,-336
+	stg	%r1,__SF_BACKCHAIN(%r15)
+	stg	%r1,304(%r15)
+	stmg	%r0,%r13,184(%r15)
+	stg	%r14,176(%r15)
+	lgr	%r2,%r14
+	aghi	%r2,-MCOUNT_INSN_SIZE
+	lg	%r3,344(%r15)
+	stg	%r3,296(%r15)
+	larl	%r4,function_trace_op
+	lg	%r4,0(%r4)
+	lgr	%r5, %r15
+	aghi	%r5, 160
+	larl	%r14,ftrace_trace_function
+	lg	%r14,0(%r14)
+	basr	%r14,%r14
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	lg	%r2,344(%r15)
+	lg	%r3,448(%r15)
+ENTRY(ftrace_regs_graph_caller)
+# The bras instruction gets runtime patched to call prepare_ftrace_return.
+# See ftrace_enable_ftrace_graph_caller. The patched instruction is:
+#	bras	%r14,prepare_ftrace_return
+	bras	%r14,0f
+0:	stg	%r2,344(%r15)
+#endif
+	lmg	%r0,%r13,184(%r15)
+	lg	%r14,176(%r15)
+	aghi	%r15,336
+	br	%r14
+#endif
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 ENTRY(return_to_handler)
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 1e2264b..6cdf2a1 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -352,6 +352,7 @@ static void __init setup_lowcore(void)
 	lc->last_update_timer = S390_lowcore.last_update_timer;
 	lc->last_update_clock = S390_lowcore.last_update_clock;
 	lc->ftrace_func = S390_lowcore.ftrace_func;
+	lc->ftrace_regs_func = S390_lowcore.ftrace_regs_func;
 
 	restart_stack = __alloc_bootmem(ASYNC_SIZE, ASYNC_SIZE, 0);
 	restart_stack += ASYNC_SIZE;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 243c7e5..152967a 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -232,6 +232,7 @@ static void pcpu_prepare_secondary(struct pcpu *pcpu, int cpu)
 	lc->kernel_asce = S390_lowcore.kernel_asce;
 	lc->machine_flags = S390_lowcore.machine_flags;
 	lc->ftrace_func = S390_lowcore.ftrace_func;
+	lc->ftrace_regs_func = S390_lowcore.ftrace_regs_func;
 	lc->user_timer = lc->system_timer = lc->steal_timer = 0;
 	__ctl_store(lc->cregs_save_area, 0, 15);
 	save_access_regs((unsigned int *) lc->access_regs_save_area);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 404a686..70ccc82 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -441,6 +441,7 @@ void ftrace_modify_all_code(int command);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern void ftrace_graph_caller(void);
+extern void ftrace_regs_graph_caller(void);
 extern int ftrace_enable_ftrace_graph_caller(void);
 extern int ftrace_disable_ftrace_graph_caller(void);
 #else
