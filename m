Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936414Ab3DJUKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:10:31 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:52953 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935970Ab3DJUK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:10:29 -0400
Date: Wed, 10 Apr 2013 13:10:20 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org
Cc: rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: [PATCH UPDATED 1/7] x86: don't show trace into stacktrace machinery
Message-ID: <20130410201020.GF17641@mtj.dyndns.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <1365016497-32033-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365016497-32033-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1abcf30c5fe1ddf166bedd482b1fc7dbed164a87 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 10 Apr 2013 13:06:06 -0700

When dumping stacktrace, frames of the stacktrace code itself aren't
interesting.  Implement dump_trace_current_frame() helper which can be
used by (eventual) users of dump_trace() to determine the stack and
frame pointers of the current frame so that frames beyond that point
are ignored by dump_trace().

show_stack() and save_stack_trace[_tsk]() are updated to use the
helper and now ignore frames beyond their own.  This brings
show_stack(NULL, NULL)'s behavior in line with dump_stack().

Also add dump_trace_warn_current_frame() which is used by dump_trace()
implementations to whine about callers which dump %current but don't
specify the frame to dump to catch mistakes.

The original patch just updated show_stack().  Applying it to other
users and addition of warning are suggested by Ingo.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
save_stack_trace*() were specifying NULL %bp as well.  Introduced a
helper and make both dump_stack() and save_stack_trace*() use it and
added a warning message in dump_trace().

git branch also updated.  This change doesn't affect other patches in
the series other than minor offset changes.

Thanks.

 arch/x86/include/asm/stacktrace.h | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/dumpstack.c       | 11 ++++++++++-
 arch/x86/kernel/dumpstack_32.c    |  2 ++
 arch/x86/kernel/dumpstack_64.c    |  2 ++
 arch/x86/kernel/stacktrace.c      | 12 ++++++++++--
 5 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 70bbe39..1abe898 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -73,14 +73,49 @@ stack_frame(struct task_struct *task, struct pt_regs *regs)
 	/* bp is the last reg pushed by switch_to */
 	return *(unsigned long *)task->thread.sp;
 }
+
+/* sanity check helper for dump_trace(), see dump_trace_current_frame() */
+static inline void
+dump_trace_warn_current_frame(struct task_struct *task, struct pt_regs *regs,
+			      unsigned long bp)
+{
+	if ((!task || task == current) && !regs && !bp)
+		printk(KERN_WARNING "dump_trace: %pf didn't specify neither frame nor regs for %%current\n",
+		       __builtin_return_address(0));
+}
 #else
 static inline unsigned long
 stack_frame(struct task_struct *task, struct pt_regs *regs)
 {
 	return 0;
 }
+
+static inline void
+dump_trace_warn_current_frame(struct task_struct *task, struct pt_regs *regs,
+			      unsigned long bp)
+{ }
 #endif
 
+/**
+ * dump_trace_current_frame - stack and frame pointers for the current frame
+ * @sp: output argument for the stack pointer
+ * @bp: output argument for the frame pointer
+ *
+ * When dumping %current, dump_trace() wants its caller to specify the top
+ * frame so that it doesn't end up showing unncessary traces into stack
+ * dumping machinery.  This helper can be used to determine @sp and @bp to
+ * pass to dump_trace() when dumping %current.  This functions is
+ * __always_inline so that it records the frame of the caller.
+ */
+static __always_inline
+void dump_trace_current_frame(unsigned long **sp, unsigned long *bp)
+{
+	unsigned long stack;
+
+	*sp = &stack;
+	*bp = stack_frame(current, NULL);
+}
+
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		   unsigned long *stack, unsigned long bp, char *log_lvl);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c8797d5..6e5e3ab 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -176,7 +176,16 @@ void show_trace(struct task_struct *task, struct pt_regs *regs,
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	show_stack_log_lvl(task, NULL, sp, 0, "");
+	unsigned long bp = 0;
+
+	/*
+	 * Stack frames below this one aren't interesting.  Don't show them
+	 * if we're printing for %current.
+	 */
+	if (!sp && (!task || task == current))
+		dump_trace_current_frame(&sp, &bp);
+
+	show_stack_log_lvl(task, NULL, sp, bp, "");
 }
 
 /*
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 1038a41..8cc7c4a 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -23,6 +23,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 {
 	int graph = 0;
 
+	dump_trace_warn_current_frame(task, regs, bp);
+
 	if (!task)
 		task = current;
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index b653675..349a8a9 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -123,6 +123,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	int graph = 0;
 	unsigned long dummy;
 
+	dump_trace_warn_current_frame(task, regs, bp);
+
 	if (!task)
 		task = current;
 
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index fdd0c64..0908a50 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -60,7 +60,10 @@ static const struct stacktrace_ops save_stack_ops_nosched = {
  */
 void save_stack_trace(struct stack_trace *trace)
 {
-	dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
+	unsigned long *sp, bp;
+
+	dump_trace_current_frame(&sp, &bp);
+	dump_trace(current, NULL, sp, bp, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
@@ -75,7 +78,12 @@ void save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
+	unsigned long *sp = NULL, bp = 0;
+
+	if (!tsk || tsk == current)
+		dump_trace_current_frame(&sp, &bp);
+
+	dump_trace(tsk, NULL, sp, bp, &save_stack_ops_nosched, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
-- 
1.8.1.4

