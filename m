Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaFIN2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:28:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:52434 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755142AbaFIN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:28:37 -0400
Date: Mon, 9 Jun 2014 09:28:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] tracing: Updates for 3.16
Message-ID: <20140609092834.39663b57@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Lots of tweaks, small fixes, optimizations, and some helper functions
to help out the rest of the kernel to ease their use of trace events.

The big change for this release is the allowing of other tracers,
such as the latency tracers, to be used in the trace instances and allow
for function or function graph tracing to be in the top level
simultaneously.

Note, I previous told you that I had two trees, where the other one was
a separate branch I let arm64 build from. As I never added to that tree
and you already pulled the arm64 changes which incorporated that tree,
I only have one tree for you to pull now.

Please pull the latest trace-3.16 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.16

Tag SHA1: 86dda713be0513c905ef4a2baca00c41e99791cb
Head SHA1: a9fcaaac37b3baba1343f906f52aeb65c4d4e356


Christoph Lameter (1):
      tracing: Replace __get_cpu_var uses with this_cpu_ptr

Fabian Frederick (1):
      tracing: Add static to local functions

Frederic Weisbecker (1):
      tracing: Remove myself as a tracing maintainer

Jiaxing Wang (2):
      tracing/stack_trace: Skip 4 instead of 3 when using ftrace_ops_list_func
      tracing: Fix documentation of ftrace_set_global_{filter,notrace}()

Mathias Krause (1):
      ftrace: Statically initialize pm notifier block

Minchan Kim (1):
      tracing: Print max callstack on stacktrace bug

Petr Mladek (2):
      ftrace/x86: Fix order of warning messages when ftrace modifies code
      ftrace/x86: Call text_ip_addr() instead of the duplicated code

Robert Elliott (2):
      tracing: Eliminate duplicate TRACE_GRAPH_PRINT_xx defines
      tracing: Add funcgraph_tail option to print function name after closing braces

Steven Rostedt (2):
      ftrace/x86: Move the mcount/fentry code out of entry_64.S
      tracing: Print nasty banner when trace_printk() is in use

Steven Rostedt (Red Hat) (26):
      ftrace: Remove global function list and call function directly
      tracing: Move tracing_max_latency into trace_array
      tracing: Move ftrace_max_lock into trace_array
      tracing: Allow wakeup tracers to be used by instances
      tracing: Allow irq/preempt tracers to be used by instances
      tracing: Break out of tracing_wait_pipe() before wait_pipe() is called
      tracing: Remove mock up poll wait function
      ftrace: Have function graph tracer use global_ops for filtering
      tracing: Add trace_<tracepoint>_enabled() function
      ftrace: Remove boolean of hash_enable and hash_disable
      ftrace: Write in missing comment from a very old commit
      ftrace: Always inline ftrace_hash_empty() helper function
      ftrace/x86: Get the current mcount addr for add_breakpoint()
      ftrace: Make get_ftrace_addr() and get_ftrace_addr_old() global
      ftrace: Use the ftrace_addr helper functions to find the ftrace_addr
      ftrace: Remove FTRACE_UPDATE_MODIFY_CALL_REGS flag
      tracing: Add __bitmask() macro to trace events to cpumasks and other bitmasks
      tracing: Add tracepoint benchmark tracepoint
      tracing: Try again for saved cmdline if failed due to locking
      tracing: Move locking of trace_cmdline_lock into start/stop seq calls
      tracing: Remove unused variable in trace_benchmark
      tracing: Add __get_dynamic_array_len() macro for trace events
      tracing: Convert stddev into u64 in tracepoint benchmark
      tracing: Only calculate stats of tracepoint benchmarks for 2^32 times
      tracing: Fix leak of ring buffer data when new instances creation fails
      tracing: Fix memory leak on instance deletion

Yoshihiro YUNOMAE (5):
      tracing: Have saved_cmdlines use the seq_read infrastructure
      tracing: Eliminate double free on failure of allocation on boot up
      tracing: Introduce saved_cmdlines_size file
      tracing: Return error if ftrace_trace_arrays list is empty
      tracing/kprobes: Avoid self tests if tracing is disabled on boot up

----
 Documentation/trace/ftrace.txt       |  26 +++
 Documentation/trace/tracepoints.txt  |  24 ++
 MAINTAINERS                          |   1 -
 arch/x86/kernel/Makefile             |   1 +
 arch/x86/kernel/entry_64.S           | 204 ----------------
 arch/x86/kernel/ftrace.c             |  56 +----
 arch/x86/kernel/mcount_64.S          | 217 +++++++++++++++++
 include/linux/ftrace.h               |  24 +-
 include/linux/ftrace_event.h         |   3 +
 include/linux/kprobes.h              |   2 +-
 include/linux/trace_seq.h            |  10 +
 include/linux/tracepoint.h           |  10 +
 include/trace/ftrace.h               |  66 +++++-
 kernel/trace/Kconfig                 |  30 +++
 kernel/trace/Makefile                |   3 +
 kernel/trace/ftrace.c                | 267 +++++++++------------
 kernel/trace/trace.c                 | 441 +++++++++++++++++++++++------------
 kernel/trace/trace.h                 |  46 ++--
 kernel/trace/trace_benchmark.c       | 198 ++++++++++++++++
 kernel/trace/trace_benchmark.h       |  41 ++++
 kernel/trace/trace_events.c          |  13 ++
 kernel/trace/trace_functions.c       |  56 ++---
 kernel/trace/trace_functions_graph.c |  19 +-
 kernel/trace/trace_irqsoff.c         |  71 +++---
 kernel/trace/trace_kprobe.c          |   3 +
 kernel/trace/trace_nop.c             |   1 -
 kernel/trace/trace_output.c          |  41 ++++
 kernel/trace/trace_sched_wakeup.c    |  70 +++---
 kernel/trace/trace_selftest.c        |  69 +++---
 kernel/trace/trace_stack.c           |  42 +++-
 30 files changed, 1326 insertions(+), 729 deletions(-)
---------------------------
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bd365988e8d8..2479b2a0c77c 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -2003,6 +2003,32 @@ want, depending on your needs.
   360.774530 |   1)   0.594 us    |                                          __phys_addr();
 
 
+The function name is always displayed after the closing bracket
+for a function if the start of that function is not in the
+trace buffer.
+
+Display of the function name after the closing bracket may be
+enabled for functions whose start is in the trace buffer,
+allowing easier searching with grep for function durations.
+It is default disabled.
+
+	hide: echo nofuncgraph-tail > trace_options
+	show: echo funcgraph-tail > trace_options
+
+  Example with nofuncgraph-tail (default):
+  0)               |      putname() {
+  0)               |        kmem_cache_free() {
+  0)   0.518 us    |          __phys_addr();
+  0)   1.757 us    |        }
+  0)   2.861 us    |      }
+
+  Example with funcgraph-tail:
+  0)               |      putname() {
+  0)               |        kmem_cache_free() {
+  0)   0.518 us    |          __phys_addr();
+  0)   1.757 us    |        } /* kmem_cache_free() */
+  0)   2.861 us    |      } /* putname() */
+
 You can put some comments on specific functions by using
 trace_printk() For example, if you want to put a comment inside
 the __might_sleep() function, you just have to include
diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
index 6b018b53177a..a3efac621c5a 100644
--- a/Documentation/trace/tracepoints.txt
+++ b/Documentation/trace/tracepoints.txt
@@ -115,6 +115,30 @@ If the tracepoint has to be used in kernel modules, an
 EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be
 used to export the defined tracepoints.
 
+If you need to do a bit of work for a tracepoint parameter, and
+that work is only used for the tracepoint, that work can be encapsulated
+within an if statement with the following:
+
+	if (trace_foo_bar_enabled()) {
+		int i;
+		int tot = 0;
+
+		for (i = 0; i < count; i++)
+			tot += calculate_nuggets();
+
+		trace_foo_bar(tot);
+	}
+
+All trace_<tracepoint>() calls have a matching trace_<tracepoint>_enabled()
+function defined that returns true if the tracepoint is enabled and
+false otherwise. The trace_<tracepoint>() should always be within the
+block of the if (trace_<tracepoint>_enabled()) to prevent races between
+the tracepoint being enabled and the check being seen.
+
+The advantage of using the trace_<tracepoint>_enabled() is that it uses
+the static_key of the tracepoint to allow the if statement to be implemented
+with jump labels and avoid conditional branches.
+
 Note: The convenience macro TRACE_EVENT provides an alternative way to
       define tracepoints. Check http://lwn.net/Articles/379903,
       http://lwn.net/Articles/381064 and http://lwn.net/Articles/383362
diff --git a/MAINTAINERS b/MAINTAINERS
index e67ea2442041..120af71debaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9041,7 +9041,6 @@ F:	drivers/char/tpm/
 
 TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
-M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Ingo Molnar <mingo@redhat.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Maintained
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f4d96000d33a..db7f41d74842 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
+obj-$(CONFIG_X86_64)	+= mcount_64.o
 obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c3628bf2..3db806de57a0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -53,7 +53,6 @@
 #include <asm/page_types.h>
 #include <asm/irqflags.h>
 #include <asm/paravirt.h>
-#include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
 #include <asm/context_tracking.h>
@@ -69,209 +68,6 @@
 	.code64
 	.section .entry.text, "ax"
 
-#ifdef CONFIG_FUNCTION_TRACER
-
-#ifdef CC_USING_FENTRY
-# define function_hook	__fentry__
-#else
-# define function_hook	mcount
-#endif
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-
-ENTRY(function_hook)
-	retq
-END(function_hook)
-
-/* skip is set if stack has been adjusted */
-.macro ftrace_caller_setup skip=0
-	MCOUNT_SAVE_FRAME \skip
-
-	/* Load the ftrace_ops into the 3rd parameter */
-	movq function_trace_op(%rip), %rdx
-
-	/* Load ip into the first parameter */
-	movq RIP(%rsp), %rdi
-	subq $MCOUNT_INSN_SIZE, %rdi
-	/* Load the parent_ip into the second parameter */
-#ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
-#else
-	movq 8(%rbp), %rsi
-#endif
-.endm
-
-ENTRY(ftrace_caller)
-	/* Check if tracing was disabled (quick check) */
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
-	ftrace_caller_setup
-	/* regs go into 4th parameter (but make it NULL) */
-	movq $0, %rcx
-
-GLOBAL(ftrace_call)
-	call ftrace_stub
-
-	MCOUNT_RESTORE_FRAME
-ftrace_return:
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-GLOBAL(ftrace_graph_call)
-	jmp ftrace_stub
-#endif
-
-GLOBAL(ftrace_stub)
-	retq
-END(ftrace_caller)
-
-ENTRY(ftrace_regs_caller)
-	/* Save the current flags before compare (in SS location)*/
-	pushfq
-
-	/* Check if tracing was disabled (quick check) */
-	cmpl $0, function_trace_stop
-	jne  ftrace_restore_flags
-
-	/* skip=8 to skip flags saved in SS */
-	ftrace_caller_setup 8
-
-	/* Save the rest of pt_regs */
-	movq %r15, R15(%rsp)
-	movq %r14, R14(%rsp)
-	movq %r13, R13(%rsp)
-	movq %r12, R12(%rsp)
-	movq %r11, R11(%rsp)
-	movq %r10, R10(%rsp)
-	movq %rbp, RBP(%rsp)
-	movq %rbx, RBX(%rsp)
-	/* Copy saved flags */
-	movq SS(%rsp), %rcx
-	movq %rcx, EFLAGS(%rsp)
-	/* Kernel segments */
-	movq $__KERNEL_DS, %rcx
-	movq %rcx, SS(%rsp)
-	movq $__KERNEL_CS, %rcx
-	movq %rcx, CS(%rsp)
-	/* Stack - skipping return address */
-	leaq SS+16(%rsp), %rcx
-	movq %rcx, RSP(%rsp)
-
-	/* regs go into 4th parameter */
-	leaq (%rsp), %rcx
-
-GLOBAL(ftrace_regs_call)
-	call ftrace_stub
-
-	/* Copy flags back to SS, to restore them */
-	movq EFLAGS(%rsp), %rax
-	movq %rax, SS(%rsp)
-
-	/* Handlers can change the RIP */
-	movq RIP(%rsp), %rax
-	movq %rax, SS+8(%rsp)
-
-	/* restore the rest of pt_regs */
-	movq R15(%rsp), %r15
-	movq R14(%rsp), %r14
-	movq R13(%rsp), %r13
-	movq R12(%rsp), %r12
-	movq R10(%rsp), %r10
-	movq RBP(%rsp), %rbp
-	movq RBX(%rsp), %rbx
-
-	/* skip=8 to skip flags saved in SS */
-	MCOUNT_RESTORE_FRAME 8
-
-	/* Restore flags */
-	popfq
-
-	jmp ftrace_return
-ftrace_restore_flags:
-	popfq
-	jmp  ftrace_stub
-
-END(ftrace_regs_caller)
-
-
-#else /* ! CONFIG_DYNAMIC_FTRACE */
-
-ENTRY(function_hook)
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
-	cmpq $ftrace_stub, ftrace_trace_function
-	jnz trace
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	cmpq $ftrace_stub, ftrace_graph_return
-	jnz ftrace_graph_caller
-
-	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
-	jnz ftrace_graph_caller
-#endif
-
-GLOBAL(ftrace_stub)
-	retq
-
-trace:
-	MCOUNT_SAVE_FRAME
-
-	movq RIP(%rsp), %rdi
-#ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
-#else
-	movq 8(%rbp), %rsi
-#endif
-	subq $MCOUNT_INSN_SIZE, %rdi
-
-	call   *ftrace_trace_function
-
-	MCOUNT_RESTORE_FRAME
-
-	jmp ftrace_stub
-END(function_hook)
-#endif /* CONFIG_DYNAMIC_FTRACE */
-#endif /* CONFIG_FUNCTION_TRACER */
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-ENTRY(ftrace_graph_caller)
-	MCOUNT_SAVE_FRAME
-
-#ifdef CC_USING_FENTRY
-	leaq SS+16(%rsp), %rdi
-	movq $0, %rdx	/* No framepointers needed */
-#else
-	leaq 8(%rbp), %rdi
-	movq (%rbp), %rdx
-#endif
-	movq RIP(%rsp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rsi
-
-	call	prepare_ftrace_return
-
-	MCOUNT_RESTORE_FRAME
-
-	retq
-END(ftrace_graph_caller)
-
-GLOBAL(return_to_handler)
-	subq  $24, %rsp
-
-	/* Save the return values */
-	movq %rax, (%rsp)
-	movq %rdx, 8(%rsp)
-	movq %rbp, %rdi
-
-	call ftrace_return_to_handler
-
-	movq %rax, %rdi
-	movq 8(%rsp), %rdx
-	movq (%rsp), %rax
-	addq $24, %rsp
-	jmp *%rdi
-#endif
-
 
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 52819e816f87..cbc4a91b131e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -297,16 +297,7 @@ int ftrace_int3_handler(struct pt_regs *regs)
 
 static int ftrace_write(unsigned long ip, const char *val, int size)
 {
-	/*
-	 * On x86_64, kernel text mappings are mapped read-only with
-	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
-	 * of the kernel text mapping to modify the kernel text.
-	 *
-	 * For 32bit kernels, these mappings are same and we can use
-	 * kernel identity mapping to modify code.
-	 */
-	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa_symbol(ip));
+	ip = text_ip_addr(ip);
 
 	if (probe_kernel_write((void *)ip, val, size))
 		return -EPERM;
@@ -349,40 +340,14 @@ static int add_brk_on_nop(struct dyn_ftrace *rec)
 	return add_break(rec->ip, old);
 }
 
-/*
- * If the record has the FTRACE_FL_REGS set, that means that it
- * wants to convert to a callback that saves all regs. If FTRACE_FL_REGS
- * is not not set, then it wants to convert to the normal callback.
- */
-static unsigned long get_ftrace_addr(struct dyn_ftrace *rec)
-{
-	if (rec->flags & FTRACE_FL_REGS)
-		return (unsigned long)FTRACE_REGS_ADDR;
-	else
-		return (unsigned long)FTRACE_ADDR;
-}
-
-/*
- * The FTRACE_FL_REGS_EN is set when the record already points to
- * a function that saves all the regs. Basically the '_EN' version
- * represents the current state of the function.
- */
-static unsigned long get_ftrace_old_addr(struct dyn_ftrace *rec)
-{
-	if (rec->flags & FTRACE_FL_REGS_EN)
-		return (unsigned long)FTRACE_REGS_ADDR;
-	else
-		return (unsigned long)FTRACE_ADDR;
-}
-
 static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 {
 	unsigned long ftrace_addr;
 	int ret;
 
-	ret = ftrace_test_record(rec, enable);
+	ftrace_addr = ftrace_get_addr_curr(rec);
 
-	ftrace_addr = get_ftrace_addr(rec);
+	ret = ftrace_test_record(rec, enable);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
@@ -392,10 +357,7 @@ static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 		/* converting nop to call */
 		return add_brk_on_nop(rec);
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
-		ftrace_addr = get_ftrace_old_addr(rec);
-		/* fall through */
 	case FTRACE_UPDATE_MAKE_NOP:
 		/* converting a call to a nop */
 		return add_brk_on_call(rec, ftrace_addr);
@@ -440,14 +402,14 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 		 * If not, don't touch the breakpoint, we make just create
 		 * a disaster.
 		 */
-		ftrace_addr = get_ftrace_addr(rec);
+		ftrace_addr = ftrace_get_addr_new(rec);
 		nop = ftrace_call_replace(ip, ftrace_addr);
 
 		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) == 0)
 			goto update;
 
 		/* Check both ftrace_addr and ftrace_old_addr */
-		ftrace_addr = get_ftrace_old_addr(rec);
+		ftrace_addr = ftrace_get_addr_curr(rec);
 		nop = ftrace_call_replace(ip, ftrace_addr);
 
 		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0)
@@ -491,13 +453,12 @@ static int add_update(struct dyn_ftrace *rec, int enable)
 
 	ret = ftrace_test_record(rec, enable);
 
-	ftrace_addr  = get_ftrace_addr(rec);
+	ftrace_addr  = ftrace_get_addr_new(rec);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
 		return 0;
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
 		/* converting nop to call */
@@ -538,13 +499,12 @@ static int finish_update(struct dyn_ftrace *rec, int enable)
 
 	ret = ftrace_update_record(rec, enable);
 
-	ftrace_addr = get_ftrace_addr(rec);
+	ftrace_addr = ftrace_get_addr_new(rec);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
 		return 0;
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
 		/* converting nop to call */
@@ -621,8 +581,8 @@ void ftrace_replace_code(int enable)
 	return;
 
  remove_breakpoints:
+	pr_warn("Failed on %s (%d):\n", report, count);
 	ftrace_bug(ret, rec ? rec->ip : 0);
-	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
 		/*
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
new file mode 100644
index 000000000000..c050a0153168
--- /dev/null
+++ b/arch/x86/kernel/mcount_64.S
@@ -0,0 +1,217 @@
+/*
+ *  linux/arch/x86_64/mcount_64.S
+ *
+ *  Copyright (C) 2014  Steven Rostedt, Red Hat Inc
+ */
+
+#include <linux/linkage.h>
+#include <asm/ptrace.h>
+#include <asm/ftrace.h>
+
+
+	.code64
+	.section .entry.text, "ax"
+
+
+#ifdef CONFIG_FUNCTION_TRACER
+
+#ifdef CC_USING_FENTRY
+# define function_hook	__fentry__
+#else
+# define function_hook	mcount
+#endif
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+ENTRY(function_hook)
+	retq
+END(function_hook)
+
+/* skip is set if stack has been adjusted */
+.macro ftrace_caller_setup skip=0
+	MCOUNT_SAVE_FRAME \skip
+
+	/* Load the ftrace_ops into the 3rd parameter */
+	movq function_trace_op(%rip), %rdx
+
+	/* Load ip into the first parameter */
+	movq RIP(%rsp), %rdi
+	subq $MCOUNT_INSN_SIZE, %rdi
+	/* Load the parent_ip into the second parameter */
+#ifdef CC_USING_FENTRY
+	movq SS+16(%rsp), %rsi
+#else
+	movq 8(%rbp), %rsi
+#endif
+.endm
+
+ENTRY(ftrace_caller)
+	/* Check if tracing was disabled (quick check) */
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
+	ftrace_caller_setup
+	/* regs go into 4th parameter (but make it NULL) */
+	movq $0, %rcx
+
+GLOBAL(ftrace_call)
+	call ftrace_stub
+
+	MCOUNT_RESTORE_FRAME
+ftrace_return:
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+GLOBAL(ftrace_graph_call)
+	jmp ftrace_stub
+#endif
+
+GLOBAL(ftrace_stub)
+	retq
+END(ftrace_caller)
+
+ENTRY(ftrace_regs_caller)
+	/* Save the current flags before compare (in SS location)*/
+	pushfq
+
+	/* Check if tracing was disabled (quick check) */
+	cmpl $0, function_trace_stop
+	jne  ftrace_restore_flags
+
+	/* skip=8 to skip flags saved in SS */
+	ftrace_caller_setup 8
+
+	/* Save the rest of pt_regs */
+	movq %r15, R15(%rsp)
+	movq %r14, R14(%rsp)
+	movq %r13, R13(%rsp)
+	movq %r12, R12(%rsp)
+	movq %r11, R11(%rsp)
+	movq %r10, R10(%rsp)
+	movq %rbp, RBP(%rsp)
+	movq %rbx, RBX(%rsp)
+	/* Copy saved flags */
+	movq SS(%rsp), %rcx
+	movq %rcx, EFLAGS(%rsp)
+	/* Kernel segments */
+	movq $__KERNEL_DS, %rcx
+	movq %rcx, SS(%rsp)
+	movq $__KERNEL_CS, %rcx
+	movq %rcx, CS(%rsp)
+	/* Stack - skipping return address */
+	leaq SS+16(%rsp), %rcx
+	movq %rcx, RSP(%rsp)
+
+	/* regs go into 4th parameter */
+	leaq (%rsp), %rcx
+
+GLOBAL(ftrace_regs_call)
+	call ftrace_stub
+
+	/* Copy flags back to SS, to restore them */
+	movq EFLAGS(%rsp), %rax
+	movq %rax, SS(%rsp)
+
+	/* Handlers can change the RIP */
+	movq RIP(%rsp), %rax
+	movq %rax, SS+8(%rsp)
+
+	/* restore the rest of pt_regs */
+	movq R15(%rsp), %r15
+	movq R14(%rsp), %r14
+	movq R13(%rsp), %r13
+	movq R12(%rsp), %r12
+	movq R10(%rsp), %r10
+	movq RBP(%rsp), %rbp
+	movq RBX(%rsp), %rbx
+
+	/* skip=8 to skip flags saved in SS */
+	MCOUNT_RESTORE_FRAME 8
+
+	/* Restore flags */
+	popfq
+
+	jmp ftrace_return
+ftrace_restore_flags:
+	popfq
+	jmp  ftrace_stub
+
+END(ftrace_regs_caller)
+
+
+#else /* ! CONFIG_DYNAMIC_FTRACE */
+
+ENTRY(function_hook)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
+	cmpq $ftrace_stub, ftrace_trace_function
+	jnz trace
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	cmpq $ftrace_stub, ftrace_graph_return
+	jnz ftrace_graph_caller
+
+	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
+	jnz ftrace_graph_caller
+#endif
+
+GLOBAL(ftrace_stub)
+	retq
+
+trace:
+	MCOUNT_SAVE_FRAME
+
+	movq RIP(%rsp), %rdi
+#ifdef CC_USING_FENTRY
+	movq SS+16(%rsp), %rsi
+#else
+	movq 8(%rbp), %rsi
+#endif
+	subq $MCOUNT_INSN_SIZE, %rdi
+
+	call   *ftrace_trace_function
+
+	MCOUNT_RESTORE_FRAME
+
+	jmp ftrace_stub
+END(function_hook)
+#endif /* CONFIG_DYNAMIC_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ftrace_graph_caller)
+	MCOUNT_SAVE_FRAME
+
+#ifdef CC_USING_FENTRY
+	leaq SS+16(%rsp), %rdi
+	movq $0, %rdx	/* No framepointers needed */
+#else
+	leaq 8(%rbp), %rdi
+	movq (%rbp), %rdx
+#endif
+	movq RIP(%rsp), %rsi
+	subq $MCOUNT_INSN_SIZE, %rsi
+
+	call	prepare_ftrace_return
+
+	MCOUNT_RESTORE_FRAME
+
+	retq
+END(ftrace_graph_caller)
+
+GLOBAL(return_to_handler)
+	subq  $24, %rsp
+
+	/* Save the return values */
+	movq %rax, (%rsp)
+	movq %rdx, 8(%rsp)
+	movq %rbp, %rdi
+
+	call ftrace_return_to_handler
+
+	movq %rax, %rdi
+	movq 8(%rsp), %rdx
+	movq (%rsp), %rax
+	addq $24, %rsp
+	jmp *%rdi
+#endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9212b017bc72..3e6dfb31f8e6 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -62,9 +62,6 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * set in the flags member.
  *
  * ENABLED - set/unset when ftrace_ops is registered/unregistered
- * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
- *           is part of the global tracers sharing the same filter
- *           via set_ftrace_* debugfs files.
  * DYNAMIC - set when ftrace_ops is registered to denote dynamically
  *           allocated ftrace_ops which need special care
  * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
@@ -96,15 +93,14 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
-	FTRACE_OPS_FL_GLOBAL			= 1 << 1,
-	FTRACE_OPS_FL_DYNAMIC			= 1 << 2,
-	FTRACE_OPS_FL_CONTROL			= 1 << 3,
-	FTRACE_OPS_FL_SAVE_REGS			= 1 << 4,
-	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	= 1 << 5,
-	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
-	FTRACE_OPS_FL_STUB			= 1 << 7,
-	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
-	FTRACE_OPS_FL_DELETED			= 1 << 9,
+	FTRACE_OPS_FL_DYNAMIC			= 1 << 1,
+	FTRACE_OPS_FL_CONTROL			= 1 << 2,
+	FTRACE_OPS_FL_SAVE_REGS			= 1 << 3,
+	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	= 1 << 4,
+	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 5,
+	FTRACE_OPS_FL_STUB			= 1 << 6,
+	FTRACE_OPS_FL_INITIALIZED		= 1 << 7,
+	FTRACE_OPS_FL_DELETED			= 1 << 8,
 };
 
 /*
@@ -366,14 +362,12 @@ enum {
  *  IGNORE           - The function is already what we want it to be
  *  MAKE_CALL        - Start tracing the function
  *  MODIFY_CALL      - Stop saving regs for the function
- *  MODIFY_CALL_REGS - Start saving regs for the function
  *  MAKE_NOP         - Stop tracing the function
  */
 enum {
 	FTRACE_UPDATE_IGNORE,
 	FTRACE_UPDATE_MAKE_CALL,
 	FTRACE_UPDATE_MODIFY_CALL,
-	FTRACE_UPDATE_MODIFY_CALL_REGS,
 	FTRACE_UPDATE_MAKE_NOP,
 };
 
@@ -404,6 +398,8 @@ int ftrace_update_record(struct dyn_ftrace *rec, int enable);
 int ftrace_test_record(struct dyn_ftrace *rec, int enable);
 void ftrace_run_stop_machine(int command);
 unsigned long ftrace_location(unsigned long ip);
+unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec);
+unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec);
 
 extern ftrace_func_t ftrace_trace_function;
 
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d16da3e53bc7..cff3106ffe2c 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -38,6 +38,9 @@ const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
 								 *symbol_array);
 #endif
 
+const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
+				     unsigned int bitmask_size);
+
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
 
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 925eaf28fca9..7bd2ad01e39c 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -355,7 +355,7 @@ static inline void reset_current_kprobe(void)
 
 static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
 {
-	return (&__get_cpu_var(kprobe_ctlblk));
+	return this_cpu_ptr(&kprobe_ctlblk);
 }
 
 int register_kprobe(struct kprobe *p);
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index a32d86ec8bf2..136116924d8d 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -46,6 +46,9 @@ extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
 extern int trace_seq_path(struct trace_seq *s, const struct path *path);
 
+extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+			     int nmaskbits);
+
 #else /* CONFIG_TRACING */
 static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
@@ -57,6 +60,13 @@ trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 	return 0;
 }
 
+static inline int
+trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+		  int nmaskbits)
+{
+	return 0;
+}
+
 static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	return 0;
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9d30ee469c2a..2e2a5f7717e5 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -185,6 +185,11 @@ extern void syscall_unregfunc(void);
 	static inline void						\
 	check_trace_callback_type_##name(void (*cb)(data_proto))	\
 	{								\
+	}								\
+	static inline bool						\
+	trace_##name##_enabled(void)					\
+	{								\
+		return static_key_false(&__tracepoint_##name.key);	\
 	}
 
 /*
@@ -230,6 +235,11 @@ extern void syscall_unregfunc(void);
 	}								\
 	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
 	{								\
+	}								\
+	static inline bool						\
+	trace_##name##_enabled(void)					\
+	{								\
+		return false;						\
 	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0a1a4f7caf09..0fd06fef9fac 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -53,6 +53,9 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(char, item, -1)
+
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
@@ -128,6 +131,9 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 	struct ftrace_data_offsets_##call {				\
@@ -197,9 +203,22 @@
 #define __get_dynamic_array(field)	\
 		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
+#undef __get_dynamic_array_len
+#define __get_dynamic_array_len(field)	\
+		((__entry->__data_loc_##field >> 16) & 0xffff)
+
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
+#undef __get_bitmask
+#define __get_bitmask(field)						\
+	({								\
+		void *__bitmask = __get_dynamic_array(field);		\
+		unsigned int __bitmask_size;				\
+		__bitmask_size = __get_dynamic_array_len(field);	\
+		ftrace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
+	})
+
 #undef __print_flags
 #define __print_flags(flag, delim, flag_array...)			\
 	({								\
@@ -322,6 +341,9 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
 static int notrace __init						\
@@ -372,6 +394,29 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #define __string(item, src) __dynamic_array(char, item,			\
 		    strlen((src) ? (const char *)(src) : "(null)") + 1)
 
+/*
+ * __bitmask_size_in_bytes_raw is the number of bytes needed to hold
+ * num_possible_cpus().
+ */
+#define __bitmask_size_in_bytes_raw(nr_bits)	\
+	(((nr_bits) + 7) / 8)
+
+#define __bitmask_size_in_longs(nr_bits)			\
+	((__bitmask_size_in_bytes_raw(nr_bits) +		\
+	  ((BITS_PER_LONG / 8) - 1)) / (BITS_PER_LONG / 8))
+
+/*
+ * __bitmask_size_in_bytes is the number of bytes needed to hold
+ * num_possible_cpus() padded out to the nearest long. This is what
+ * is saved in the buffer, just to be consistent.
+ */
+#define __bitmask_size_in_bytes(nr_bits)				\
+	(__bitmask_size_in_longs(nr_bits) * (BITS_PER_LONG / 8))
+
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item,	\
+					 __bitmask_size_in_longs(nr_bits))
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static inline notrace int ftrace_get_offsets_##call(			\
@@ -513,12 +558,22 @@ static inline notrace int ftrace_get_offsets_##call(			\
 	__entry->__data_loc_##item = __data_offsets.item;
 
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, -1)       	\
+#define __string(item, src) __dynamic_array(char, item, -1)
 
 #undef __assign_str
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), (src) ? (const char *)(src) : "(null)");
 
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
+#undef __get_bitmask
+#define __get_bitmask(field) (char *)__get_dynamic_array(field)
+
+#undef __assign_bitmask
+#define __assign_bitmask(dst, src, nr_bits)					\
+	memcpy(__get_bitmask(dst), (src), __bitmask_size_in_bytes(nr_bits))
+
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
 
@@ -585,7 +640,9 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __print_symbolic
 #undef __print_hex
 #undef __get_dynamic_array
+#undef __get_dynamic_array_len
 #undef __get_str
+#undef __get_bitmask
 
 #undef TP_printk
 #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
@@ -648,9 +705,16 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #define __get_dynamic_array(field)	\
 		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
+#undef __get_dynamic_array_len
+#define __get_dynamic_array_len(field)	\
+		((__entry->__data_loc_##field >> 16) & 0xffff)
+
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
+#undef __get_bitmask
+#define __get_bitmask(field) (char *)__get_dynamic_array(field)
+
 #undef __perf_addr
 #define __perf_addr(a)	(__addr = (a))
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8639819f6cef..d4409356f40d 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -535,6 +535,36 @@ config MMIOTRACE_TEST
 
 	  Say N, unless you absolutely know what you are doing.
 
+config TRACEPOINT_BENCHMARK
+        bool "Add tracepoint that benchmarks tracepoints"
+	help
+	 This option creates the tracepoint "benchmark:benchmark_event".
+	 When the tracepoint is enabled, it kicks off a kernel thread that
+	 goes into an infinite loop (calling cond_sched() to let other tasks
+	 run), and calls the tracepoint. Each iteration will record the time
+	 it took to write to the tracepoint and the next iteration that
+	 data will be passed to the tracepoint itself. That is, the tracepoint
+	 will report the time it took to do the previous tracepoint.
+	 The string written to the tracepoint is a static string of 128 bytes
+	 to keep the time the same. The initial string is simply a write of
+	 "START". The second string records the cold cache time of the first
+	 write which is not added to the rest of the calculations.
+
+	 As it is a tight loop, it benchmarks as hot cache. That's fine because
+	 we care most about hot paths that are probably in cache already.
+
+	 An example of the output:
+
+	      START
+	      first=3672 [COLD CACHED]
+	      last=632 first=3672 max=632 min=632 avg=316 std=446 std^2=199712
+	      last=278 first=3672 max=632 min=278 avg=303 std=316 std^2=100337
+	      last=277 first=3672 max=632 min=277 avg=296 std=258 std^2=67064
+	      last=273 first=3672 max=632 min=273 avg=292 std=224 std^2=50411
+	      last=273 first=3672 max=632 min=273 avg=288 std=200 std^2=40389
+	      last=281 first=3672 max=632 min=273 avg=287 std=183 std^2=33666
+
+
 config RING_BUFFER_BENCHMARK
 	tristate "Ring buffer benchmark stress tester"
 	depends on RING_BUFFER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 1378e84fbe39..2611613f14f1 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -17,6 +17,7 @@ ifdef CONFIG_TRACING_BRANCHES
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_trace_benchmark.o := -I$(src)
 CFLAGS_trace_events_filter.o := -I$(src)
 
 obj-$(CONFIG_TRACE_CLOCK) += trace_clock.o
@@ -62,4 +63,6 @@ endif
 obj-$(CONFIG_PROBE_EVENTS) += trace_probe.o
 obj-$(CONFIG_UPROBE_EVENT) += trace_uprobe.o
 
+obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
+
 libftrace-y := ftrace.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1fd4b9479210..cc07b7fc4372 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -62,7 +62,7 @@
 #define FTRACE_HASH_DEFAULT_BITS 10
 #define FTRACE_HASH_MAX_BITS 12
 
-#define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTROL)
+#define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_CONTROL)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 #define INIT_REGEX_LOCK(opsname)	\
@@ -103,7 +103,6 @@ static int ftrace_disabled __read_mostly;
 
 static DEFINE_MUTEX(ftrace_lock);
 
-static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_control_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
@@ -171,23 +170,6 @@ int ftrace_nr_registered_ops(void)
 	return cnt;
 }
 
-static void
-ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
-			struct ftrace_ops *op, struct pt_regs *regs)
-{
-	int bit;
-
-	bit = trace_test_and_set_recursion(TRACE_GLOBAL_START, TRACE_GLOBAL_MAX);
-	if (bit < 0)
-		return;
-
-	do_for_each_ftrace_op(op, ftrace_global_list) {
-		op->func(ip, parent_ip, op, regs);
-	} while_for_each_ftrace_op(op);
-
-	trace_clear_recursion(bit);
-}
-
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
 			    struct ftrace_ops *op, struct pt_regs *regs)
 {
@@ -237,43 +219,6 @@ static int control_ops_alloc(struct ftrace_ops *ops)
 	return 0;
 }
 
-static void update_global_ops(void)
-{
-	ftrace_func_t func = ftrace_global_list_func;
-	void *private = NULL;
-
-	/* The list has its own recursion protection. */
-	global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
-
-	/*
-	 * If there's only one function registered, then call that
-	 * function directly. Otherwise, we need to iterate over the
-	 * registered callers.
-	 */
-	if (ftrace_global_list == &ftrace_list_end ||
-	    ftrace_global_list->next == &ftrace_list_end) {
-		func = ftrace_global_list->func;
-		private = ftrace_global_list->private;
-		/*
-		 * As we are calling the function directly.
-		 * If it does not have recursion protection,
-		 * the function_trace_op needs to be updated
-		 * accordingly.
-		 */
-		if (!(ftrace_global_list->flags & FTRACE_OPS_FL_RECURSION_SAFE))
-			global_ops.flags &= ~FTRACE_OPS_FL_RECURSION_SAFE;
-	}
-
-	/* If we filter on pids, update to use the pid function */
-	if (!list_empty(&ftrace_pids)) {
-		set_ftrace_pid_function(func);
-		func = ftrace_pid_func;
-	}
-
-	global_ops.func = func;
-	global_ops.private = private;
-}
-
 static void ftrace_sync(struct work_struct *work)
 {
 	/*
@@ -301,8 +246,6 @@ static void update_ftrace_function(void)
 {
 	ftrace_func_t func;
 
-	update_global_ops();
-
 	/*
 	 * If we are at the end of the list and this ops is
 	 * recursion safe and not dynamic and the arch supports passing ops,
@@ -314,10 +257,7 @@ static void update_ftrace_function(void)
 	     (ftrace_ops_list->flags & FTRACE_OPS_FL_RECURSION_SAFE) &&
 	     !FTRACE_FORCE_LIST_FUNC)) {
 		/* Set the ftrace_ops that the arch callback uses */
-		if (ftrace_ops_list == &global_ops)
-			set_function_trace_op = ftrace_global_list;
-		else
-			set_function_trace_op = ftrace_ops_list;
+		set_function_trace_op = ftrace_ops_list;
 		func = ftrace_ops_list->func;
 	} else {
 		/* Just use the default ftrace_ops */
@@ -373,6 +313,11 @@ static void update_ftrace_function(void)
 	ftrace_trace_function = func;
 }
 
+int using_ftrace_ops_list_func(void)
+{
+	return ftrace_trace_function == ftrace_ops_list_func;
+}
+
 static void add_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 {
 	ops->next = *list;
@@ -434,16 +379,9 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (ops->flags & FTRACE_OPS_FL_DELETED)
 		return -EINVAL;
 
-	if (FTRACE_WARN_ON(ops == &global_ops))
-		return -EINVAL;
-
 	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EBUSY;
 
-	/* We don't support both control and global flags set. */
-	if ((ops->flags & FL_GLOBAL_CONTROL_MASK) == FL_GLOBAL_CONTROL_MASK)
-		return -EINVAL;
-
 #ifndef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 	/*
 	 * If the ftrace_ops specifies SAVE_REGS, then it only can be used
@@ -461,10 +399,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		add_ftrace_list_ops(&ftrace_global_list, &global_ops, ops);
-		ops->flags |= FTRACE_OPS_FL_ENABLED;
-	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+	if (ops->flags & FTRACE_OPS_FL_CONTROL) {
 		if (control_ops_alloc(ops))
 			return -ENOMEM;
 		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
@@ -484,15 +419,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (WARN_ON(!(ops->flags & FTRACE_OPS_FL_ENABLED)))
 		return -EBUSY;
 
-	if (FTRACE_WARN_ON(ops == &global_ops))
-		return -EINVAL;
-
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ret = remove_ftrace_list_ops(&ftrace_global_list,
-					     &global_ops, ops);
-		if (!ret)
-			ops->flags &= ~FTRACE_OPS_FL_ENABLED;
-	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+	if (ops->flags & FTRACE_OPS_FL_CONTROL) {
 		ret = remove_ftrace_list_ops(&ftrace_control_list,
 					     &control_ops, ops);
 	} else
@@ -895,7 +822,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip,
 
 	local_irq_save(flags);
 
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
@@ -926,7 +853,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
@@ -1178,7 +1105,7 @@ struct ftrace_page {
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
 
-static bool ftrace_hash_empty(struct ftrace_hash *hash)
+static bool __always_inline ftrace_hash_empty(struct ftrace_hash *hash)
 {
 	return !hash || !hash->count;
 }
@@ -1625,7 +1552,14 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			in_other_hash = !!ftrace_lookup_ip(other_hash, rec->ip);
 
 			/*
+			 * If filter_hash is set, we want to match all functions
+			 * that are in the hash but not in the other hash.
 			 *
+			 * If filter_hash is not set, then we are decrementing.
+			 * That means we match anything that is in the hash
+			 * and also in the other_hash. That is, we need to turn
+			 * off functions in the other hash because they are disabled
+			 * by this hash.
 			 */
 			if (filter_hash && in_hash && !in_other_hash)
 				match = 1;
@@ -1767,19 +1701,15 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 		/*
 		 * If this record is being updated from a nop, then
 		 *   return UPDATE_MAKE_CALL.
-		 * Otherwise, if the EN flag is set, then return
-		 *   UPDATE_MODIFY_CALL_REGS to tell the caller to convert
-		 *   from the non-save regs, to a save regs function.
 		 * Otherwise,
 		 *   return UPDATE_MODIFY_CALL to tell the caller to convert
-		 *   from the save regs, to a non-save regs function.
+		 *   from the save regs, to a non-save regs function or
+		 *   vice versa.
 		 */
 		if (flag & FTRACE_FL_ENABLED)
 			return FTRACE_UPDATE_MAKE_CALL;
-		else if (rec->flags & FTRACE_FL_REGS_EN)
-			return FTRACE_UPDATE_MODIFY_CALL_REGS;
-		else
-			return FTRACE_UPDATE_MODIFY_CALL;
+
+		return FTRACE_UPDATE_MODIFY_CALL;
 	}
 
 	if (update) {
@@ -1821,6 +1751,42 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
 	return ftrace_check_record(rec, enable, 0);
 }
 
+/**
+ * ftrace_get_addr_new - Get the call address to set to
+ * @rec:  The ftrace record descriptor
+ *
+ * If the record has the FTRACE_FL_REGS set, that means that it
+ * wants to convert to a callback that saves all regs. If FTRACE_FL_REGS
+ * is not not set, then it wants to convert to the normal callback.
+ *
+ * Returns the address of the trampoline to set to
+ */
+unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
+{
+	if (rec->flags & FTRACE_FL_REGS)
+		return (unsigned long)FTRACE_REGS_ADDR;
+	else
+		return (unsigned long)FTRACE_ADDR;
+}
+
+/**
+ * ftrace_get_addr_curr - Get the call address that is already there
+ * @rec:  The ftrace record descriptor
+ *
+ * The FTRACE_FL_REGS_EN is set when the record already points to
+ * a function that saves all the regs. Basically the '_EN' version
+ * represents the current state of the function.
+ *
+ * Returns the address of the trampoline that is currently being called
+ */
+unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec)
+{
+	if (rec->flags & FTRACE_FL_REGS_EN)
+		return (unsigned long)FTRACE_REGS_ADDR;
+	else
+		return (unsigned long)FTRACE_ADDR;
+}
+
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
@@ -1828,12 +1794,12 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	unsigned long ftrace_addr;
 	int ret;
 
-	ret = ftrace_update_record(rec, enable);
+	ftrace_addr = ftrace_get_addr_new(rec);
 
-	if (rec->flags & FTRACE_FL_REGS)
-		ftrace_addr = (unsigned long)FTRACE_REGS_ADDR;
-	else
-		ftrace_addr = (unsigned long)FTRACE_ADDR;
+	/* This needs to be done before we call ftrace_update_record */
+	ftrace_old_addr = ftrace_get_addr_curr(rec);
+
+	ret = ftrace_update_record(rec, enable);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
@@ -1845,13 +1811,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	case FTRACE_UPDATE_MAKE_NOP:
 		return ftrace_make_nop(NULL, rec, ftrace_addr);
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
-		if (rec->flags & FTRACE_FL_REGS)
-			ftrace_old_addr = (unsigned long)FTRACE_ADDR;
-		else
-			ftrace_old_addr = (unsigned long)FTRACE_REGS_ADDR;
-
 		return ftrace_modify_call(rec, ftrace_old_addr, ftrace_addr);
 	}
 
@@ -2115,7 +2075,6 @@ static void ftrace_startup_enable(int command)
 
 static int ftrace_startup(struct ftrace_ops *ops, int command)
 {
-	bool hash_enable = true;
 	int ret;
 
 	if (unlikely(ftrace_disabled))
@@ -2128,18 +2087,9 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 	ftrace_start_up++;
 	command |= FTRACE_UPDATE_CALLS;
 
-	/* ops marked global share the filter hashes */
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ops = &global_ops;
-		/* Don't update hash if global is already set */
-		if (global_start_up)
-			hash_enable = false;
-		global_start_up++;
-	}
-
 	ops->flags |= FTRACE_OPS_FL_ENABLED;
-	if (hash_enable)
-		ftrace_hash_rec_enable(ops, 1);
+
+	ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
 
@@ -2148,7 +2098,6 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 
 static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 {
-	bool hash_disable = true;
 	int ret;
 
 	if (unlikely(ftrace_disabled))
@@ -2166,21 +2115,9 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ops = &global_ops;
-		global_start_up--;
-		WARN_ON_ONCE(global_start_up < 0);
-		/* Don't update hash if global still has users */
-		if (global_start_up) {
-			WARN_ON_ONCE(!ftrace_start_up);
-			hash_disable = false;
-		}
-	}
-
-	if (hash_disable)
-		ftrace_hash_rec_disable(ops, 1);
+	ftrace_hash_rec_disable(ops, 1);
 
-	if (ops != &global_ops || !global_start_up)
+	if (!global_start_up)
 		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
 
 	command |= FTRACE_UPDATE_CALLS;
@@ -3524,10 +3461,6 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	struct ftrace_hash *hash;
 	int ret;
 
-	/* All global ops uses the global ops filters */
-	if (ops->flags & FTRACE_OPS_FL_GLOBAL)
-		ops = &global_ops;
-
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
@@ -3639,8 +3572,7 @@ int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
 /**
- * ftrace_set_filter - set a function to filter on in ftrace
- * @ops - the ops to set the filter with
+ * ftrace_set_global_filter - set a function to filter on with global tracers
  * @buf - the string that holds the function filter text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -3655,8 +3587,7 @@ void ftrace_set_global_filter(unsigned char *buf, int len, int reset)
 EXPORT_SYMBOL_GPL(ftrace_set_global_filter);
 
 /**
- * ftrace_set_notrace - set a function to not trace in ftrace
- * @ops - the ops to set the notrace filter with
+ * ftrace_set_global_notrace - set a function to not trace with global tracers
  * @buf - the string that holds the function notrace text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -4462,6 +4393,34 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+__init void ftrace_init_global_array_ops(struct trace_array *tr)
+{
+	tr->ops = &global_ops;
+	tr->ops->private = tr;
+}
+
+void ftrace_init_array_ops(struct trace_array *tr, ftrace_func_t func)
+{
+	/* If we filter on pids, update to use the pid function */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		if (WARN_ON(tr->ops->func != ftrace_stub))
+			printk("ftrace ops had %pS for function\n",
+			       tr->ops->func);
+		/* Only the top level instance does pid tracing */
+		if (!list_empty(&ftrace_pids)) {
+			set_ftrace_pid_function(func);
+			func = ftrace_pid_func;
+		}
+	}
+	tr->ops->func = func;
+	tr->ops->private = tr;
+}
+
+void ftrace_reset_array_ops(struct trace_array *tr)
+{
+	tr->ops->func = ftrace_stub;
+}
+
 static void
 ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 			struct ftrace_ops *op, struct pt_regs *regs)
@@ -4520,9 +4479,16 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (ftrace_ops_test(op, ip, regs))
+		if (ftrace_ops_test(op, ip, regs)) {
+			if (WARN_ON(!op->func)) {
+				function_trace_stop = 1;
+				printk("op=%p %pS\n", op, op);
+				goto out;
+			}
 			op->func(ip, parent_ip, op, regs);
+		}
 	} while_for_each_ftrace_op(op);
+out:
 	preempt_enable_notrace();
 	trace_clear_recursion(bit);
 }
@@ -4927,7 +4893,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static int ftrace_graph_active;
-static struct notifier_block ftrace_suspend_notifier;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 {
@@ -5073,13 +5038,6 @@ ftrace_suspend_notifier_call(struct notifier_block *bl, unsigned long state,
 	return NOTIFY_DONE;
 }
 
-/* Just a place holder for function graph */
-static struct ftrace_ops fgraph_ops __read_mostly = {
-	.func		= ftrace_stub,
-	.flags		= FTRACE_OPS_FL_STUB | FTRACE_OPS_FL_GLOBAL |
-				FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
 static int ftrace_graph_entry_test(struct ftrace_graph_ent *trace)
 {
 	if (!ftrace_ops_test(&global_ops, trace->func, NULL))
@@ -5104,6 +5062,10 @@ static void update_function_graph_func(void)
 		ftrace_graph_entry = ftrace_graph_entry_test;
 }
 
+static struct notifier_block ftrace_suspend_notifier = {
+	.notifier_call = ftrace_suspend_notifier_call,
+};
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -5117,7 +5079,6 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 		goto out;
 	}
 
-	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
 	register_pm_notifier(&ftrace_suspend_notifier);
 
 	ftrace_graph_active++;
@@ -5139,7 +5100,10 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_entry = ftrace_graph_entry_test;
 	update_function_graph_func();
 
-	ret = ftrace_startup(&fgraph_ops, FTRACE_START_FUNC_RET);
+	/* Function graph doesn't use the .func field of global_ops */
+	global_ops.flags |= FTRACE_OPS_FL_STUB;
+
+	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -5157,7 +5121,8 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	__ftrace_graph_entry = ftrace_graph_entry_stub;
-	ftrace_shutdown(&fgraph_ops, FTRACE_STOP_FUNC_RET);
+	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
+	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 737b0efa1a62..16f7038d1f4d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -275,7 +275,7 @@ int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
 }
 EXPORT_SYMBOL_GPL(call_filter_check_discard);
 
-cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
+static cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
 {
 	u64 ts;
 
@@ -599,7 +599,7 @@ static int alloc_snapshot(struct trace_array *tr)
 	return 0;
 }
 
-void free_snapshot(struct trace_array *tr)
+static void free_snapshot(struct trace_array *tr)
 {
 	/*
 	 * We don't free the ring buffer. instead, resize it because
@@ -963,27 +963,9 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	return cnt;
 }
 
-/*
- * ftrace_max_lock is used to protect the swapping of buffers
- * when taking a max snapshot. The buffers themselves are
- * protected by per_cpu spinlocks. But the action of the swap
- * needs its own lock.
- *
- * This is defined as a arch_spinlock_t in order to help
- * with performance when lockdep debugging is enabled.
- *
- * It is also used in other places outside the update_max_tr
- * so it needs to be defined outside of the
- * CONFIG_TRACER_MAX_TRACE.
- */
-static arch_spinlock_t ftrace_max_lock =
-	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-
 unsigned long __read_mostly	tracing_thresh;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-unsigned long __read_mostly	tracing_max_latency;
-
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
@@ -1000,7 +982,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	max_buf->cpu = cpu;
 	max_buf->time_start = data->preempt_timestamp;
 
-	max_data->saved_latency = tracing_max_latency;
+	max_data->saved_latency = tr->max_latency;
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
 
@@ -1048,14 +1030,14 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 	}
 
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&tr->max_lock);
 
 	buf = tr->trace_buffer.buffer;
 	tr->trace_buffer.buffer = tr->max_buffer.buffer;
 	tr->max_buffer.buffer = buf;
 
 	__update_max_tr(tr, tsk, cpu);
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&tr->max_lock);
 }
 
 /**
@@ -1081,7 +1063,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 	}
 
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&tr->max_lock);
 
 	ret = ring_buffer_swap_cpu(tr->max_buffer.buffer, tr->trace_buffer.buffer, cpu);
 
@@ -1099,11 +1081,11 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	WARN_ON_ONCE(ret && ret != -EAGAIN && ret != -EBUSY);
 
 	__update_max_tr(tr, tsk, cpu);
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&tr->max_lock);
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
-static void default_wait_pipe(struct trace_iterator *iter)
+static void wait_on_pipe(struct trace_iterator *iter)
 {
 	/* Iterators are static, they should be filled or empty */
 	if (trace_buffer_iter(iter, iter->cpu_file))
@@ -1220,8 +1202,6 @@ int register_tracer(struct tracer *type)
 	else
 		if (!type->flags->opts)
 			type->flags->opts = dummy_tracer_opt;
-	if (!type->wait_pipe)
-		type->wait_pipe = default_wait_pipe;
 
 	ret = run_tracer_selftest(type);
 	if (ret < 0)
@@ -1305,22 +1285,71 @@ void tracing_reset_all_online_cpus(void)
 	}
 }
 
-#define SAVED_CMDLINES 128
+#define SAVED_CMDLINES_DEFAULT 128
 #define NO_CMDLINE_MAP UINT_MAX
-static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
-static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
-static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
-static int cmdline_idx;
 static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
+struct saved_cmdlines_buffer {
+	unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
+	unsigned *map_cmdline_to_pid;
+	unsigned cmdline_num;
+	int cmdline_idx;
+	char *saved_cmdlines;
+};
+static struct saved_cmdlines_buffer *savedcmd;
 
 /* temporary disable recording */
 static atomic_t trace_record_cmdline_disabled __read_mostly;
 
-static void trace_init_cmdlines(void)
+static inline char *get_saved_cmdlines(int idx)
 {
-	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
-	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
-	cmdline_idx = 0;
+	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
+}
+
+static inline void set_cmdline(int idx, const char *cmdline)
+{
+	memcpy(get_saved_cmdlines(idx), cmdline, TASK_COMM_LEN);
+}
+
+static int allocate_cmdlines_buffer(unsigned int val,
+				    struct saved_cmdlines_buffer *s)
+{
+	s->map_cmdline_to_pid = kmalloc(val * sizeof(*s->map_cmdline_to_pid),
+					GFP_KERNEL);
+	if (!s->map_cmdline_to_pid)
+		return -ENOMEM;
+
+	s->saved_cmdlines = kmalloc(val * TASK_COMM_LEN, GFP_KERNEL);
+	if (!s->saved_cmdlines) {
+		kfree(s->map_cmdline_to_pid);
+		return -ENOMEM;
+	}
+
+	s->cmdline_idx = 0;
+	s->cmdline_num = val;
+	memset(&s->map_pid_to_cmdline, NO_CMDLINE_MAP,
+	       sizeof(s->map_pid_to_cmdline));
+	memset(s->map_cmdline_to_pid, NO_CMDLINE_MAP,
+	       val * sizeof(*s->map_cmdline_to_pid));
+
+	return 0;
+}
+
+static int trace_create_savedcmd(void)
+{
+	int ret;
+
+	savedcmd = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	if (!savedcmd)
+		return -ENOMEM;
+
+	ret = allocate_cmdlines_buffer(SAVED_CMDLINES_DEFAULT, savedcmd);
+	if (ret < 0) {
+		kfree(savedcmd);
+		savedcmd = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 int is_tracing_stopped(void)
@@ -1353,7 +1382,7 @@ void tracing_start(void)
 	}
 
 	/* Prevent the buffers from switching */
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&global_trace.max_lock);
 
 	buffer = global_trace.trace_buffer.buffer;
 	if (buffer)
@@ -1365,7 +1394,7 @@ void tracing_start(void)
 		ring_buffer_record_enable(buffer);
 #endif
 
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&global_trace.max_lock);
 
 	ftrace_start();
  out:
@@ -1420,7 +1449,7 @@ void tracing_stop(void)
 		goto out;
 
 	/* Prevent the buffers from switching */
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&global_trace.max_lock);
 
 	buffer = global_trace.trace_buffer.buffer;
 	if (buffer)
@@ -1432,7 +1461,7 @@ void tracing_stop(void)
 		ring_buffer_record_disable(buffer);
 #endif
 
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&global_trace.max_lock);
 
  out:
 	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
@@ -1461,12 +1490,12 @@ static void tracing_stop_tr(struct trace_array *tr)
 
 void trace_stop_cmdline_recording(void);
 
-static void trace_save_cmdline(struct task_struct *tsk)
+static int trace_save_cmdline(struct task_struct *tsk)
 {
 	unsigned pid, idx;
 
 	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
-		return;
+		return 0;
 
 	/*
 	 * It's not the end of the world if we don't get
@@ -1475,11 +1504,11 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	 * so if we miss here, then better luck next time.
 	 */
 	if (!arch_spin_trylock(&trace_cmdline_lock))
-		return;
+		return 0;
 
-	idx = map_pid_to_cmdline[tsk->pid];
+	idx = savedcmd->map_pid_to_cmdline[tsk->pid];
 	if (idx == NO_CMDLINE_MAP) {
-		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
+		idx = (savedcmd->cmdline_idx + 1) % savedcmd->cmdline_num;
 
 		/*
 		 * Check whether the cmdline buffer at idx has a pid
@@ -1487,22 +1516,24 @@ static void trace_save_cmdline(struct task_struct *tsk)
 		 * need to clear the map_pid_to_cmdline. Otherwise we
 		 * would read the new comm for the old pid.
 		 */
-		pid = map_cmdline_to_pid[idx];
+		pid = savedcmd->map_cmdline_to_pid[idx];
 		if (pid != NO_CMDLINE_MAP)
-			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
+			savedcmd->map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
 
-		map_cmdline_to_pid[idx] = tsk->pid;
-		map_pid_to_cmdline[tsk->pid] = idx;
+		savedcmd->map_cmdline_to_pid[idx] = tsk->pid;
+		savedcmd->map_pid_to_cmdline[tsk->pid] = idx;
 
-		cmdline_idx = idx;
+		savedcmd->cmdline_idx = idx;
 	}
 
-	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
+	set_cmdline(idx, tsk->comm);
 
 	arch_spin_unlock(&trace_cmdline_lock);
+
+	return 1;
 }
 
-void trace_find_cmdline(int pid, char comm[])
+static void __trace_find_cmdline(int pid, char comm[])
 {
 	unsigned map;
 
@@ -1521,13 +1552,19 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	preempt_disable();
-	arch_spin_lock(&trace_cmdline_lock);
-	map = map_pid_to_cmdline[pid];
+	map = savedcmd->map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
-		strcpy(comm, saved_cmdlines[map]);
+		strcpy(comm, get_saved_cmdlines(map));
 	else
 		strcpy(comm, "<...>");
+}
+
+void trace_find_cmdline(int pid, char comm[])
+{
+	preempt_disable();
+	arch_spin_lock(&trace_cmdline_lock);
+
+	__trace_find_cmdline(pid, comm);
 
 	arch_spin_unlock(&trace_cmdline_lock);
 	preempt_enable();
@@ -1541,9 +1578,8 @@ void tracing_record_cmdline(struct task_struct *tsk)
 	if (!__this_cpu_read(trace_cmdline_save))
 		return;
 
-	__this_cpu_write(trace_cmdline_save, false);
-
-	trace_save_cmdline(tsk);
+	if (trace_save_cmdline(tsk))
+		__this_cpu_write(trace_cmdline_save, false);
 }
 
 void
@@ -1746,7 +1782,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	 */
 	barrier();
 	if (use_stack == 1) {
-		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
 		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
 
 		if (regs)
@@ -1995,7 +2031,21 @@ void trace_printk_init_buffers(void)
 	if (alloc_percpu_trace_buffer())
 		return;
 
-	pr_info("ftrace: Allocated trace_printk buffers\n");
+	/* trace_printk() is for debug use only. Don't use it in production. */
+
+	pr_warning("\n**********************************************************\n");
+	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
+	pr_warning("** unsafe for produciton use.                           **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("** If you see this message and you are not debugging    **\n");
+	pr_warning("** the kernel, report this immediately to your vendor!  **\n");
+	pr_warning("**                                                      **\n");
+	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
+	pr_warning("**********************************************************\n");
 
 	/* Expand the buffers to set size */
 	tracing_update_buffers();
@@ -3333,7 +3383,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	mutex_lock(&tracing_cpumask_update_lock);
 
 	local_irq_disable();
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&tr->max_lock);
 	for_each_tracing_cpu(cpu) {
 		/*
 		 * Increase/decrease the disabled counter if we are
@@ -3350,7 +3400,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 			ring_buffer_record_enable_cpu(tr->trace_buffer.buffer, cpu);
 		}
 	}
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&tr->max_lock);
 	local_irq_enable();
 
 	cpumask_copy(tr->tracing_cpumask, tracing_cpumask_new);
@@ -3592,6 +3642,7 @@ static const char readme_msg[] =
 	"  trace_options\t\t- Set format or modify how tracing happens\n"
 	"\t\t\t  Disable an option by adding a suffix 'no' to the\n"
 	"\t\t\t  option name\n"
+	"  saved_cmdlines_size\t- echo command number in here to store comm-pid list\n"
 #ifdef CONFIG_DYNAMIC_FTRACE
 	"\n  available_filter_functions - list of functions that can be filtered on\n"
 	"  set_ftrace_filter\t- echo function name in here to only trace these\n"
@@ -3705,55 +3756,153 @@ static const struct file_operations tracing_readme_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static void *saved_cmdlines_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	unsigned int *ptr = v;
+
+	if (*pos || m->count)
+		ptr++;
+
+	(*pos)++;
+
+	for (; ptr < &savedcmd->map_cmdline_to_pid[savedcmd->cmdline_num];
+	     ptr++) {
+		if (*ptr == -1 || *ptr == NO_CMDLINE_MAP)
+			continue;
+
+		return ptr;
+	}
+
+	return NULL;
+}
+
+static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
+{
+	void *v;
+	loff_t l = 0;
+
+	preempt_disable();
+	arch_spin_lock(&trace_cmdline_lock);
+
+	v = &savedcmd->map_cmdline_to_pid[0];
+	while (l <= *pos) {
+		v = saved_cmdlines_next(m, v, &l);
+		if (!v)
+			return NULL;
+	}
+
+	return v;
+}
+
+static void saved_cmdlines_stop(struct seq_file *m, void *v)
+{
+	arch_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
+}
+
+static int saved_cmdlines_show(struct seq_file *m, void *v)
+{
+	char buf[TASK_COMM_LEN];
+	unsigned int *pid = v;
+
+	__trace_find_cmdline(*pid, buf);
+	seq_printf(m, "%d %s\n", *pid, buf);
+	return 0;
+}
+
+static const struct seq_operations tracing_saved_cmdlines_seq_ops = {
+	.start		= saved_cmdlines_start,
+	.next		= saved_cmdlines_next,
+	.stop		= saved_cmdlines_stop,
+	.show		= saved_cmdlines_show,
+};
+
+static int tracing_saved_cmdlines_open(struct inode *inode, struct file *filp)
+{
+	if (tracing_disabled)
+		return -ENODEV;
+
+	return seq_open(filp, &tracing_saved_cmdlines_seq_ops);
+}
+
+static const struct file_operations tracing_saved_cmdlines_fops = {
+	.open		= tracing_saved_cmdlines_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static ssize_t
-tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
-				size_t cnt, loff_t *ppos)
+tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
+				 size_t cnt, loff_t *ppos)
 {
-	char *buf_comm;
-	char *file_buf;
-	char *buf;
-	int len = 0;
-	int pid;
-	int i;
+	char buf[64];
+	int r;
+
+	arch_spin_lock(&trace_cmdline_lock);
+	r = sprintf(buf, "%u\n", savedcmd->cmdline_num);
+	arch_spin_unlock(&trace_cmdline_lock);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
+{
+	kfree(s->saved_cmdlines);
+	kfree(s->map_cmdline_to_pid);
+	kfree(s);
+}
+
+static int tracing_resize_saved_cmdlines(unsigned int val)
+{
+	struct saved_cmdlines_buffer *s, *savedcmd_temp;
 
-	file_buf = kmalloc(SAVED_CMDLINES*(16+TASK_COMM_LEN), GFP_KERNEL);
-	if (!file_buf)
+	s = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	if (!s)
 		return -ENOMEM;
 
-	buf_comm = kmalloc(TASK_COMM_LEN, GFP_KERNEL);
-	if (!buf_comm) {
-		kfree(file_buf);
+	if (allocate_cmdlines_buffer(val, s) < 0) {
+		kfree(s);
 		return -ENOMEM;
 	}
 
-	buf = file_buf;
+	arch_spin_lock(&trace_cmdline_lock);
+	savedcmd_temp = savedcmd;
+	savedcmd = s;
+	arch_spin_unlock(&trace_cmdline_lock);
+	free_saved_cmdlines_buffer(savedcmd_temp);
 
-	for (i = 0; i < SAVED_CMDLINES; i++) {
-		int r;
+	return 0;
+}
 
-		pid = map_cmdline_to_pid[i];
-		if (pid == -1 || pid == NO_CMDLINE_MAP)
-			continue;
+static ssize_t
+tracing_saved_cmdlines_size_write(struct file *filp, const char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
 
-		trace_find_cmdline(pid, buf_comm);
-		r = sprintf(buf, "%d %s\n", pid, buf_comm);
-		buf += r;
-		len += r;
-	}
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
 
-	len = simple_read_from_buffer(ubuf, cnt, ppos,
-				      file_buf, len);
+	/* must have at least 1 entry or less than PID_MAX_DEFAULT */
+	if (!val || val > PID_MAX_DEFAULT)
+		return -EINVAL;
 
-	kfree(file_buf);
-	kfree(buf_comm);
+	ret = tracing_resize_saved_cmdlines((unsigned int)val);
+	if (ret < 0)
+		return ret;
 
-	return len;
+	*ppos += cnt;
+
+	return cnt;
 }
 
-static const struct file_operations tracing_saved_cmdlines_fops = {
-    .open       = tracing_open_generic,
-    .read       = tracing_saved_cmdlines_read,
-    .llseek	= generic_file_llseek,
+static const struct file_operations tracing_saved_cmdlines_size_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_saved_cmdlines_size_read,
+	.write		= tracing_saved_cmdlines_size_write,
 };
 
 static ssize_t
@@ -4225,25 +4374,6 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 	return trace_poll(iter, filp, poll_table);
 }
 
-/*
- * This is a make-shift waitqueue.
- * A tracer might use this callback on some rare cases:
- *
- *  1) the current tracer might hold the runqueue lock when it wakes up
- *     a reader, hence a deadlock (sched, function, and function graph tracers)
- *  2) the function tracers, trace all functions, we don't want
- *     the overhead of calling wake_up and friends
- *     (and tracing them too)
- *
- *     Anyway, this is really very primitive wakeup.
- */
-void poll_wait_pipe(struct trace_iterator *iter)
-{
-	set_current_state(TASK_INTERRUPTIBLE);
-	/* sleep for 100 msecs, and try again. */
-	schedule_timeout(HZ / 10);
-}
-
 /* Must be called with trace_types_lock mutex held. */
 static int tracing_wait_pipe(struct file *filp)
 {
@@ -4255,15 +4385,6 @@ static int tracing_wait_pipe(struct file *filp)
 			return -EAGAIN;
 		}
 
-		mutex_unlock(&iter->mutex);
-
-		iter->trace->wait_pipe(iter);
-
-		mutex_lock(&iter->mutex);
-
-		if (signal_pending(current))
-			return -EINTR;
-
 		/*
 		 * We block until we read something and tracing is disabled.
 		 * We still block if tracing is disabled, but we have never
@@ -4275,6 +4396,15 @@ static int tracing_wait_pipe(struct file *filp)
 		 */
 		if (!tracing_is_on() && iter->pos)
 			break;
+
+		mutex_unlock(&iter->mutex);
+
+		wait_on_pipe(iter);
+
+		mutex_lock(&iter->mutex);
+
+		if (signal_pending(current))
+			return -EINTR;
 	}
 
 	return 1;
@@ -5197,7 +5327,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 				goto out_unlock;
 			}
 			mutex_unlock(&trace_types_lock);
-			iter->trace->wait_pipe(iter);
+			wait_on_pipe(iter);
 			mutex_lock(&trace_types_lock);
 			if (signal_pending(current)) {
 				size = -EINTR;
@@ -5408,7 +5538,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			goto out;
 		}
 		mutex_unlock(&trace_types_lock);
-		iter->trace->wait_pipe(iter);
+		wait_on_pipe(iter);
 		mutex_lock(&trace_types_lock);
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -6102,6 +6232,25 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	return 0;
 }
 
+static void free_trace_buffers(struct trace_array *tr)
+{
+	if (!tr)
+		return;
+
+	if (tr->trace_buffer.buffer) {
+		ring_buffer_free(tr->trace_buffer.buffer);
+		tr->trace_buffer.buffer = NULL;
+		free_percpu(tr->trace_buffer.data);
+	}
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (tr->max_buffer.buffer) {
+		ring_buffer_free(tr->max_buffer.buffer);
+		tr->max_buffer.buffer = NULL;
+	}
+#endif
+}
+
 static int new_instance_create(const char *name)
 {
 	struct trace_array *tr;
@@ -6131,6 +6280,8 @@ static int new_instance_create(const char *name)
 
 	raw_spin_lock_init(&tr->start_lock);
 
+	tr->max_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
 	tr->current_trace = &nop_trace;
 
 	INIT_LIST_HEAD(&tr->systems);
@@ -6158,8 +6309,7 @@ static int new_instance_create(const char *name)
 	return 0;
 
  out_free_tr:
-	if (tr->trace_buffer.buffer)
-		ring_buffer_free(tr->trace_buffer.buffer);
+	free_trace_buffers(tr);
 	free_cpumask_var(tr->tracing_cpumask);
 	kfree(tr->name);
 	kfree(tr);
@@ -6199,8 +6349,7 @@ static int instance_delete(const char *name)
 	event_trace_del_tracer(tr);
 	ftrace_destroy_function_files(tr);
 	debugfs_remove_recursive(tr->dir);
-	free_percpu(tr->trace_buffer.data);
-	ring_buffer_free(tr->trace_buffer.buffer);
+	free_trace_buffers(tr);
 
 	kfree(tr->name);
 	kfree(tr);
@@ -6328,6 +6477,11 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("tracing_on", 0644, d_tracer,
 			  tr, &rb_simple_fops);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+	trace_create_file("tracing_max_latency", 0644, d_tracer,
+			&tr->max_latency, &tracing_max_lat_fops);
+#endif
+
 	if (ftrace_create_function_files(tr, d_tracer))
 		WARN(1, "Could not allocate function filter files");
 
@@ -6353,11 +6507,6 @@ static __init int tracer_init_debugfs(void)
 
 	init_tracer_debugfs(&global_trace, d_tracer);
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	trace_create_file("tracing_max_latency", 0644, d_tracer,
-			&tracing_max_latency, &tracing_max_lat_fops);
-#endif
-
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
 
@@ -6367,6 +6516,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("saved_cmdlines", 0444, d_tracer,
 			NULL, &tracing_saved_cmdlines_fops);
 
+	trace_create_file("saved_cmdlines_size", 0644, d_tracer,
+			  NULL, &tracing_saved_cmdlines_size_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
@@ -6603,18 +6755,19 @@ __init static int tracer_alloc_buffers(void)
 	if (!temp_buffer)
 		goto out_free_cpumask;
 
+	if (trace_create_savedcmd() < 0)
+		goto out_free_temp_buffer;
+
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	if (allocate_trace_buffers(&global_trace, ring_buf_size) < 0) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
-		goto out_free_temp_buffer;
+		goto out_free_savedcmd;
 	}
 
 	if (global_trace.buffer_disabled)
 		tracing_off();
 
-	trace_init_cmdlines();
-
 	if (trace_boot_clock) {
 		ret = tracing_set_clock(&global_trace, trace_boot_clock);
 		if (ret < 0)
@@ -6629,6 +6782,10 @@ __init static int tracer_alloc_buffers(void)
 	 */
 	global_trace.current_trace = &nop_trace;
 
+	global_trace.max_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
+	ftrace_init_global_array_ops(&global_trace);
+
 	register_tracer(&nop_trace);
 
 	/* All seems OK, enable tracing */
@@ -6656,13 +6813,11 @@ __init static int tracer_alloc_buffers(void)
 
 	return 0;
 
+out_free_savedcmd:
+	free_saved_cmdlines_buffer(savedcmd);
 out_free_temp_buffer:
 	ring_buffer_free(temp_buffer);
 out_free_cpumask:
-	free_percpu(global_trace.trace_buffer.data);
-#ifdef CONFIG_TRACER_MAX_TRACE
-	free_percpu(global_trace.max_buffer.data);
-#endif
 	free_cpumask_var(global_trace.tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2e29d7ba5a52..9e82551dd566 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -190,7 +190,22 @@ struct trace_array {
 	 */
 	struct trace_buffer	max_buffer;
 	bool			allocated_snapshot;
+	unsigned long		max_latency;
 #endif
+	/*
+	 * max_lock is used to protect the swapping of buffers
+	 * when taking a max snapshot. The buffers themselves are
+	 * protected by per_cpu spinlocks. But the action of the swap
+	 * needs its own lock.
+	 *
+	 * This is defined as a arch_spinlock_t in order to help
+	 * with performance when lockdep debugging is enabled.
+	 *
+	 * It is also used in other places outside the update_max_tr
+	 * so it needs to be defined outside of the
+	 * CONFIG_TRACER_MAX_TRACE.
+	 */
+	arch_spinlock_t		max_lock;
 	int			buffer_disabled;
 #ifdef CONFIG_FTRACE_SYSCALLS
 	int			sys_refcount_enter;
@@ -237,6 +252,9 @@ static inline struct trace_array *top_trace_array(void)
 {
 	struct trace_array *tr;
 
+	if (list_empty(ftrace_trace_arrays.prev))
+		return NULL;
+
 	tr = list_entry(ftrace_trace_arrays.prev,
 			typeof(*tr), list);
 	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));
@@ -323,7 +341,6 @@ struct tracer_flags {
  * @stop: called when tracing is paused (echo 0 > tracing_enabled)
  * @open: called when the trace file is opened
  * @pipe_open: called when the trace_pipe file is opened
- * @wait_pipe: override how the user waits for traces on trace_pipe
  * @close: called when the trace file is released
  * @pipe_close: called when the trace_pipe file is released
  * @read: override the default read callback on trace_pipe
@@ -342,7 +359,6 @@ struct tracer {
 	void			(*stop)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
-	void			(*wait_pipe)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
 	void			(*pipe_close)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
@@ -416,13 +432,7 @@ enum {
 	TRACE_FTRACE_IRQ_BIT,
 	TRACE_FTRACE_SIRQ_BIT,
 
-	/* GLOBAL_BITs must be greater than FTRACE_BITs */
-	TRACE_GLOBAL_BIT,
-	TRACE_GLOBAL_NMI_BIT,
-	TRACE_GLOBAL_IRQ_BIT,
-	TRACE_GLOBAL_SIRQ_BIT,
-
-	/* INTERNAL_BITs must be greater than GLOBAL_BITs */
+	/* INTERNAL_BITs must be greater than FTRACE_BITs */
 	TRACE_INTERNAL_BIT,
 	TRACE_INTERNAL_NMI_BIT,
 	TRACE_INTERNAL_IRQ_BIT,
@@ -449,9 +459,6 @@ enum {
 #define TRACE_FTRACE_START	TRACE_FTRACE_BIT
 #define TRACE_FTRACE_MAX	((1 << (TRACE_FTRACE_START + TRACE_CONTEXT_BITS)) - 1)
 
-#define TRACE_GLOBAL_START	TRACE_GLOBAL_BIT
-#define TRACE_GLOBAL_MAX	((1 << (TRACE_GLOBAL_START + TRACE_CONTEXT_BITS)) - 1)
-
 #define TRACE_LIST_START	TRACE_INTERNAL_BIT
 #define TRACE_LIST_MAX		((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
 
@@ -560,8 +567,6 @@ void trace_init_global_iter(struct trace_iterator *iter);
 
 void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
-void poll_wait_pipe(struct trace_iterator *iter);
-
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
 				struct task_struct *next,
@@ -608,8 +613,6 @@ extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 extern unsigned long tracing_thresh;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-extern unsigned long tracing_max_latency;
-
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
@@ -724,6 +727,8 @@ extern unsigned long trace_flags;
 #define TRACE_GRAPH_PRINT_PROC          0x8
 #define TRACE_GRAPH_PRINT_DURATION      0x10
 #define TRACE_GRAPH_PRINT_ABS_TIME      0x20
+#define TRACE_GRAPH_PRINT_IRQS          0x40
+#define TRACE_GRAPH_PRINT_TAIL          0x80
 #define TRACE_GRAPH_PRINT_FILL_SHIFT	28
 #define TRACE_GRAPH_PRINT_FILL_MASK	(0x3 << TRACE_GRAPH_PRINT_FILL_SHIFT)
 
@@ -823,6 +828,10 @@ extern int ftrace_is_dead(void);
 int ftrace_create_function_files(struct trace_array *tr,
 				 struct dentry *parent);
 void ftrace_destroy_function_files(struct trace_array *tr);
+void ftrace_init_global_array_ops(struct trace_array *tr);
+void ftrace_init_array_ops(struct trace_array *tr, ftrace_func_t func);
+void ftrace_reset_array_ops(struct trace_array *tr);
+int using_ftrace_ops_list_func(void);
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
@@ -836,6 +845,11 @@ ftrace_create_function_files(struct trace_array *tr,
 	return 0;
 }
 static inline void ftrace_destroy_function_files(struct trace_array *tr) { }
+static inline __init void
+ftrace_init_global_array_ops(struct trace_array *tr) { }
+static inline void ftrace_reset_array_ops(struct trace_array *tr) { }
+/* ftace_func_t type is not defined, use macro instead of static inline */
+#define ftrace_init_array_ops(tr, func) do { } while (0)
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #if defined(CONFIG_FUNCTION_TRACER) && defined(CONFIG_DYNAMIC_FTRACE)
diff --git a/kernel/trace/trace_benchmark.c b/kernel/trace/trace_benchmark.c
new file mode 100644
index 000000000000..40a14cbcf8e0
--- /dev/null
+++ b/kernel/trace/trace_benchmark.c
@@ -0,0 +1,198 @@
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/trace_clock.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace_benchmark.h"
+
+static struct task_struct *bm_event_thread;
+
+static char bm_str[BENCHMARK_EVENT_STRLEN] = "START";
+
+static u64 bm_total;
+static u64 bm_totalsq;
+static u64 bm_last;
+static u64 bm_max;
+static u64 bm_min;
+static u64 bm_first;
+static u64 bm_cnt;
+static u64 bm_stddev;
+static unsigned int bm_avg;
+static unsigned int bm_std;
+
+/*
+ * This gets called in a loop recording the time it took to write
+ * the tracepoint. What it writes is the time statistics of the last
+ * tracepoint write. As there is nothing to write the first time
+ * it simply writes "START". As the first write is cold cache and
+ * the rest is hot, we save off that time in bm_first and it is
+ * reported as "first", which is shown in the second write to the
+ * tracepoint. The "first" field is writen within the statics from
+ * then on but never changes.
+ */
+static void trace_do_benchmark(void)
+{
+	u64 start;
+	u64 stop;
+	u64 delta;
+	u64 stddev;
+	u64 seed;
+	u64 last_seed;
+	unsigned int avg;
+	unsigned int std = 0;
+
+	/* Only run if the tracepoint is actually active */
+	if (!trace_benchmark_event_enabled())
+		return;
+
+	local_irq_disable();
+	start = trace_clock_local();
+	trace_benchmark_event(bm_str);
+	stop = trace_clock_local();
+	local_irq_enable();
+
+	bm_cnt++;
+
+	delta = stop - start;
+
+	/*
+	 * The first read is cold cached, keep it separate from the
+	 * other calculations.
+	 */
+	if (bm_cnt == 1) {
+		bm_first = delta;
+		scnprintf(bm_str, BENCHMARK_EVENT_STRLEN,
+			  "first=%llu [COLD CACHED]", bm_first);
+		return;
+	}
+
+	bm_last = delta;
+
+	if (delta > bm_max)
+		bm_max = delta;
+	if (!bm_min || delta < bm_min)
+		bm_min = delta;
+
+	/*
+	 * When bm_cnt is greater than UINT_MAX, it breaks the statistics
+	 * accounting. Freeze the statistics when that happens.
+	 * We should have enough data for the avg and stddev anyway.
+	 */
+	if (bm_cnt > UINT_MAX) {
+		scnprintf(bm_str, BENCHMARK_EVENT_STRLEN,
+		    "last=%llu first=%llu max=%llu min=%llu ** avg=%u std=%d std^2=%lld",
+			  bm_last, bm_first, bm_max, bm_min, bm_avg, bm_std, bm_stddev);
+		return;
+	}
+
+	bm_total += delta;
+	bm_totalsq += delta * delta;
+
+
+	if (bm_cnt > 1) {
+		/*
+		 * Apply Welford's method to calculate standard deviation:
+		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
+		 */
+		stddev = (u64)bm_cnt * bm_totalsq - bm_total * bm_total;
+		do_div(stddev, (u32)bm_cnt);
+		do_div(stddev, (u32)bm_cnt - 1);
+	} else
+		stddev = 0;
+
+	delta = bm_total;
+	do_div(delta, bm_cnt);
+	avg = delta;
+
+	if (stddev > 0) {
+		int i = 0;
+		/*
+		 * stddev is the square of standard deviation but
+		 * we want the actualy number. Use the average
+		 * as our seed to find the std.
+		 *
+		 * The next try is:
+		 *  x = (x + N/x) / 2
+		 *
+		 * Where N is the squared number to find the square
+		 * root of.
+		 */
+		seed = avg;
+		do {
+			last_seed = seed;
+			seed = stddev;
+			if (!last_seed)
+				break;
+			do_div(seed, last_seed);
+			seed += last_seed;
+			do_div(seed, 2);
+		} while (i++ < 10 && last_seed != seed);
+
+		std = seed;
+	}
+
+	scnprintf(bm_str, BENCHMARK_EVENT_STRLEN,
+		  "last=%llu first=%llu max=%llu min=%llu avg=%u std=%d std^2=%lld",
+		  bm_last, bm_first, bm_max, bm_min, avg, std, stddev);
+
+	bm_std = std;
+	bm_avg = avg;
+	bm_stddev = stddev;
+}
+
+static int benchmark_event_kthread(void *arg)
+{
+	/* sleep a bit to make sure the tracepoint gets activated */
+	msleep(100);
+
+	while (!kthread_should_stop()) {
+
+		trace_do_benchmark();
+
+		/*
+		 * We don't go to sleep, but let others
+		 * run as well.
+		 */
+		cond_resched();
+	}
+
+	return 0;
+}
+
+/*
+ * When the benchmark tracepoint is enabled, it calls this
+ * function and the thread that calls the tracepoint is created.
+ */
+void trace_benchmark_reg(void)
+{
+	bm_event_thread = kthread_run(benchmark_event_kthread,
+				      NULL, "event_benchmark");
+	WARN_ON(!bm_event_thread);
+}
+
+/*
+ * When the benchmark tracepoint is disabled, it calls this
+ * function and the thread that calls the tracepoint is deleted
+ * and all the numbers are reset.
+ */
+void trace_benchmark_unreg(void)
+{
+	if (!bm_event_thread)
+		return;
+
+	kthread_stop(bm_event_thread);
+
+	strcpy(bm_str, "START");
+	bm_total = 0;
+	bm_totalsq = 0;
+	bm_last = 0;
+	bm_max = 0;
+	bm_min = 0;
+	bm_cnt = 0;
+	/* These don't need to be reset but reset them anyway */
+	bm_first = 0;
+	bm_std = 0;
+	bm_avg = 0;
+	bm_stddev = 0;
+}
diff --git a/kernel/trace/trace_benchmark.h b/kernel/trace/trace_benchmark.h
new file mode 100644
index 000000000000..3c1df1df4e29
--- /dev/null
+++ b/kernel/trace/trace_benchmark.h
@@ -0,0 +1,41 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM benchmark
+
+#if !defined(_TRACE_BENCHMARK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BENCHMARK_H
+
+#include <linux/tracepoint.h>
+
+extern void trace_benchmark_reg(void);
+extern void trace_benchmark_unreg(void);
+
+#define BENCHMARK_EVENT_STRLEN		128
+
+TRACE_EVENT_FN(benchmark_event,
+
+	TP_PROTO(const char *str),
+
+	TP_ARGS(str),
+
+	TP_STRUCT__entry(
+		__array(	char,	str,	BENCHMARK_EVENT_STRLEN	)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->str, str, BENCHMARK_EVENT_STRLEN);
+	),
+
+	TP_printk("%s", __entry->str),
+
+	trace_benchmark_reg, trace_benchmark_unreg
+);
+
+#endif /* _TRACE_BENCHMARK_H */
+
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_benchmark
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3ddfd8f62c05..f99e0b3bca8c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -574,6 +574,9 @@ int trace_set_clr_event(const char *system, const char *event, int set)
 {
 	struct trace_array *tr = top_trace_array();
 
+	if (!tr)
+		return -ENODEV;
+
 	return __ftrace_set_clr_event(tr, NULL, system, event, set);
 }
 EXPORT_SYMBOL_GPL(trace_set_clr_event);
@@ -2065,6 +2068,9 @@ event_enable_func(struct ftrace_hash *hash,
 	bool enable;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	/* hash funcs only work with set_ftrace_filter */
 	if (!enabled || !param)
 		return -EINVAL;
@@ -2396,6 +2402,9 @@ static __init int event_trace_enable(void)
 	char *token;
 	int ret;
 
+	if (!tr)
+		return -ENODEV;
+
 	for_each_event(iter, __start_ftrace_events, __stop_ftrace_events) {
 
 		call = *iter;
@@ -2442,6 +2451,8 @@ static __init int event_trace_init(void)
 	int ret;
 
 	tr = top_trace_array();
+	if (!tr)
+		return -ENODEV;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -2535,6 +2546,8 @@ static __init void event_trace_self_tests(void)
 	int ret;
 
 	tr = top_trace_array();
+	if (!tr)
+		return;
 
 	pr_info("Running tests on trace events:\n");
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index ffd56351b521..57f0ec962d2c 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -26,8 +26,6 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 static void
 function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 			  struct ftrace_ops *op, struct pt_regs *pt_regs);
-static struct ftrace_ops trace_ops;
-static struct ftrace_ops trace_stack_ops;
 static struct tracer_flags func_flags;
 
 /* Our option */
@@ -83,28 +81,24 @@ void ftrace_destroy_function_files(struct trace_array *tr)
 
 static int function_trace_init(struct trace_array *tr)
 {
-	struct ftrace_ops *ops;
-
-	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
-		/* There's only one global tr */
-		if (!trace_ops.private) {
-			trace_ops.private = tr;
-			trace_stack_ops.private = tr;
-		}
+	ftrace_func_t func;
 
-		if (func_flags.val & TRACE_FUNC_OPT_STACK)
-			ops = &trace_stack_ops;
-		else
-			ops = &trace_ops;
-		tr->ops = ops;
-	} else if (!tr->ops) {
-		/*
-		 * Instance trace_arrays get their ops allocated
-		 * at instance creation. Unless it failed
-		 * the allocation.
-		 */
+	/*
+	 * Instance trace_arrays get their ops allocated
+	 * at instance creation. Unless it failed
+	 * the allocation.
+	 */
+	if (!tr->ops)
 		return -ENOMEM;
-	}
+
+	/* Currently only the global instance can do stack tracing */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL &&
+	    func_flags.val & TRACE_FUNC_OPT_STACK)
+		func = function_stack_trace_call;
+	else
+		func = function_trace_call;
+
+	ftrace_init_array_ops(tr, func);
 
 	tr->trace_buffer.cpu = get_cpu();
 	put_cpu();
@@ -118,6 +112,7 @@ static void function_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_function_trace(tr);
 	tracing_stop_cmdline_record();
+	ftrace_reset_array_ops(tr);
 }
 
 static void function_trace_start(struct trace_array *tr)
@@ -199,18 +194,6 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 	local_irq_restore(flags);
 }
 
-static struct ftrace_ops trace_ops __read_mostly =
-{
-	.func = function_trace_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
-static struct ftrace_ops trace_stack_ops __read_mostly =
-{
-	.func = function_stack_trace_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
 static struct tracer_opt func_opts[] = {
 #ifdef CONFIG_STACKTRACE
 	{ TRACER_OPT(func_stack_trace, TRACE_FUNC_OPT_STACK) },
@@ -248,10 +231,10 @@ func_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 		unregister_ftrace_function(tr->ops);
 
 		if (set) {
-			tr->ops = &trace_stack_ops;
+			tr->ops->func = function_stack_trace_call;
 			register_ftrace_function(tr->ops);
 		} else {
-			tr->ops = &trace_ops;
+			tr->ops->func = function_trace_call;
 			register_ftrace_function(tr->ops);
 		}
 
@@ -269,7 +252,6 @@ static struct tracer function_trace __tracer_data =
 	.init		= function_trace_init,
 	.reset		= function_trace_reset,
 	.start		= function_trace_start,
-	.wait_pipe	= poll_wait_pipe,
 	.flags		= &func_flags,
 	.set_flag	= func_set_flag,
 	.allow_instances = true,
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index deff11200261..4de3e57f723c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -38,15 +38,6 @@ struct fgraph_data {
 
 #define TRACE_GRAPH_INDENT	2
 
-/* Flag options */
-#define TRACE_GRAPH_PRINT_OVERRUN	0x1
-#define TRACE_GRAPH_PRINT_CPU		0x2
-#define TRACE_GRAPH_PRINT_OVERHEAD	0x4
-#define TRACE_GRAPH_PRINT_PROC		0x8
-#define TRACE_GRAPH_PRINT_DURATION	0x10
-#define TRACE_GRAPH_PRINT_ABS_TIME	0x20
-#define TRACE_GRAPH_PRINT_IRQS		0x40
-
 static unsigned int max_depth;
 
 static struct tracer_opt trace_opts[] = {
@@ -64,11 +55,13 @@ static struct tracer_opt trace_opts[] = {
 	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
 	/* Display interrupts */
 	{ TRACER_OPT(funcgraph-irqs, TRACE_GRAPH_PRINT_IRQS) },
+	/* Display function name after trailing } */
+	{ TRACER_OPT(funcgraph-tail, TRACE_GRAPH_PRINT_TAIL) },
 	{ } /* Empty entry */
 };
 
 static struct tracer_flags tracer_flags = {
-	/* Don't display overruns and proc by default */
+	/* Don't display overruns, proc, or tail by default */
 	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD |
 	       TRACE_GRAPH_PRINT_DURATION | TRACE_GRAPH_PRINT_IRQS,
 	.opts = trace_opts
@@ -1176,9 +1169,10 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	 * If the return function does not have a matching entry,
 	 * then the entry was lost. Instead of just printing
 	 * the '}' and letting the user guess what function this
-	 * belongs to, write out the function name.
+	 * belongs to, write out the function name. Always do
+	 * that if the funcgraph-tail option is enabled.
 	 */
-	if (func_match) {
+	if (func_match && !(flags & TRACE_GRAPH_PRINT_TAIL)) {
 		ret = trace_seq_puts(s, "}\n");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -1505,7 +1499,6 @@ static struct tracer graph_trace __tracer_data = {
 	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
 	.pipe_close	= graph_trace_close,
-	.wait_pipe	= poll_wait_pipe,
 	.init		= graph_trace_init,
 	.reset		= graph_trace_reset,
 	.print_line	= print_graph_function,
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 8ff02cbb892f..9bb104f748d0 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -151,12 +151,6 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip,
 
 	atomic_dec(&data->disabled);
 }
-
-static struct ftrace_ops trace_ops __read_mostly =
-{
-	.func = irqsoff_tracer_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -176,7 +170,7 @@ irqsoff_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 	for_each_possible_cpu(cpu)
 		per_cpu(tracing_cpu, cpu) = 0;
 
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	tracing_reset_online_cpus(&irqsoff_trace->trace_buffer);
 
 	return start_irqsoff_tracer(irqsoff_trace, set);
@@ -303,13 +297,13 @@ static void irqsoff_print_header(struct seq_file *s)
 /*
  * Should this new latency be reported/recorded?
  */
-static int report_latency(cycle_t delta)
+static int report_latency(struct trace_array *tr, cycle_t delta)
 {
 	if (tracing_thresh) {
 		if (delta < tracing_thresh)
 			return 0;
 	} else {
-		if (delta <= tracing_max_latency)
+		if (delta <= tr->max_latency)
 			return 0;
 	}
 	return 1;
@@ -333,13 +327,13 @@ check_critical_timing(struct trace_array *tr,
 
 	pc = preempt_count();
 
-	if (!report_latency(delta))
+	if (!report_latency(tr, delta))
 		goto out;
 
 	raw_spin_lock_irqsave(&max_trace_lock, flags);
 
 	/* check if we are still the max latency */
-	if (!report_latency(delta))
+	if (!report_latency(tr, delta))
 		goto out_unlock;
 
 	__trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
@@ -352,7 +346,7 @@ check_critical_timing(struct trace_array *tr,
 	data->critical_end = parent_ip;
 
 	if (likely(!is_tracing_stopped())) {
-		tracing_max_latency = delta;
+		tr->max_latency = delta;
 		update_max_tr_single(tr, current, cpu);
 	}
 
@@ -531,7 +525,7 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
-static int register_irqsoff_function(int graph, int set)
+static int register_irqsoff_function(struct trace_array *tr, int graph, int set)
 {
 	int ret;
 
@@ -543,7 +537,7 @@ static int register_irqsoff_function(int graph, int set)
 		ret = register_ftrace_graph(&irqsoff_graph_return,
 					    &irqsoff_graph_entry);
 	else
-		ret = register_ftrace_function(&trace_ops);
+		ret = register_ftrace_function(tr->ops);
 
 	if (!ret)
 		function_enabled = true;
@@ -551,7 +545,7 @@ static int register_irqsoff_function(int graph, int set)
 	return ret;
 }
 
-static void unregister_irqsoff_function(int graph)
+static void unregister_irqsoff_function(struct trace_array *tr, int graph)
 {
 	if (!function_enabled)
 		return;
@@ -559,17 +553,17 @@ static void unregister_irqsoff_function(int graph)
 	if (graph)
 		unregister_ftrace_graph();
 	else
-		unregister_ftrace_function(&trace_ops);
+		unregister_ftrace_function(tr->ops);
 
 	function_enabled = false;
 }
 
-static void irqsoff_function_set(int set)
+static void irqsoff_function_set(struct trace_array *tr, int set)
 {
 	if (set)
-		register_irqsoff_function(is_graph(), 1);
+		register_irqsoff_function(tr, is_graph(), 1);
 	else
-		unregister_irqsoff_function(is_graph());
+		unregister_irqsoff_function(tr, is_graph());
 }
 
 static int irqsoff_flag_changed(struct trace_array *tr, u32 mask, int set)
@@ -577,7 +571,7 @@ static int irqsoff_flag_changed(struct trace_array *tr, u32 mask, int set)
 	struct tracer *tracer = tr->current_trace;
 
 	if (mask & TRACE_ITER_FUNCTION)
-		irqsoff_function_set(set);
+		irqsoff_function_set(tr, set);
 
 	return trace_keep_overwrite(tracer, mask, set);
 }
@@ -586,7 +580,7 @@ static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 {
 	int ret;
 
-	ret = register_irqsoff_function(graph, 0);
+	ret = register_irqsoff_function(tr, graph, 0);
 
 	if (!ret && tracing_is_enabled())
 		tracer_enabled = 1;
@@ -600,25 +594,37 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 {
 	tracer_enabled = 0;
 
-	unregister_irqsoff_function(graph);
+	unregister_irqsoff_function(tr, graph);
 }
 
-static void __irqsoff_tracer_init(struct trace_array *tr)
+static bool irqsoff_busy;
+
+static int __irqsoff_tracer_init(struct trace_array *tr)
 {
+	if (irqsoff_busy)
+		return -EBUSY;
+
 	save_flags = trace_flags;
 
 	/* non overwrite screws up the latency tracers */
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
 
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
 	tracing_reset_online_cpus(&tr->trace_buffer);
 
-	if (start_irqsoff_tracer(tr, is_graph()))
+	ftrace_init_array_ops(tr, irqsoff_tracer_call);
+
+	/* Only toplevel instance supports graph tracing */
+	if (start_irqsoff_tracer(tr, (tr->flags & TRACE_ARRAY_FL_GLOBAL &&
+				      is_graph())))
 		printk(KERN_ERR "failed to start irqsoff tracer\n");
+
+	irqsoff_busy = true;
+	return 0;
 }
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
@@ -630,6 +636,9 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
+	ftrace_reset_array_ops(tr);
+
+	irqsoff_busy = false;
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -647,8 +656,7 @@ static int irqsoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_IRQS_OFF;
 
-	__irqsoff_tracer_init(tr);
-	return 0;
+	return __irqsoff_tracer_init(tr);
 }
 static struct tracer irqsoff_tracer __read_mostly =
 {
@@ -668,6 +676,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 #endif
 	.open           = irqsoff_trace_open,
 	.close          = irqsoff_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 # define register_irqsoff(trace) register_tracer(&trace)
@@ -680,8 +689,7 @@ static int preemptoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_PREEMPT_OFF;
 
-	__irqsoff_tracer_init(tr);
-	return 0;
+	return __irqsoff_tracer_init(tr);
 }
 
 static struct tracer preemptoff_tracer __read_mostly =
@@ -702,6 +710,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 # define register_preemptoff(trace) register_tracer(&trace)
@@ -716,8 +725,7 @@ static int preemptirqsoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_IRQS_OFF | TRACER_PREEMPT_OFF;
 
-	__irqsoff_tracer_init(tr);
-	return 0;
+	return __irqsoff_tracer_init(tr);
 }
 
 static struct tracer preemptirqsoff_tracer __read_mostly =
@@ -738,6 +746,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 903ae28962be..ef2fba1f46b5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1377,6 +1377,9 @@ static __init int kprobe_trace_self_tests_init(void)
 	struct trace_kprobe *tk;
 	struct ftrace_event_file *file;
 
+	if (tracing_is_disabled())
+		return -ENODEV;
+
 	target = kprobe_trace_selftest_target;
 
 	pr_info("Testing kprobe tracing: ");
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 69a5cc94c01a..fcf0a9e48916 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -91,7 +91,6 @@ struct tracer nop_trace __read_mostly =
 	.name		= "nop",
 	.init		= nop_trace_init,
 	.reset		= nop_trace_reset,
-	.wait_pipe	= poll_wait_pipe,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_nop,
 #endif
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index a436de18aa99..f3dad80c20b2 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -126,6 +126,34 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
 /**
+ * trace_seq_bitmask - put a list of longs as a bitmask print output
+ * @s:		trace sequence descriptor
+ * @maskp:	points to an array of unsigned longs that represent a bitmask
+ * @nmaskbits:	The number of bits that are valid in @maskp
+ *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
+ * Writes a ASCII representation of a bitmask string into @s.
+ */
+int
+trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+		  int nmaskbits)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
+	s->len += ret;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(trace_seq_bitmask);
+
+/**
  * trace_seq_vprintf - sequence printing of trace information
  * @s: trace sequence descriptor
  * @fmt: printf format string
@@ -399,6 +427,19 @@ EXPORT_SYMBOL(ftrace_print_symbols_seq_u64);
 #endif
 
 const char *
+ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
+			 unsigned int bitmask_size)
+{
+	const char *ret = p->buffer + p->len;
+
+	trace_seq_bitmask(p, bitmask_ptr, bitmask_size * 8);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ftrace_print_bitmask_seq);
+
+const char *
 ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 {
 	int i;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index e14da5e97a69..19bd8928ce94 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -130,15 +130,9 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip,
 	atomic_dec(&data->disabled);
 	preempt_enable_notrace();
 }
-
-static struct ftrace_ops trace_ops __read_mostly =
-{
-	.func = wakeup_tracer_call,
-	.flags = FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
 #endif /* CONFIG_FUNCTION_TRACER */
 
-static int register_wakeup_function(int graph, int set)
+static int register_wakeup_function(struct trace_array *tr, int graph, int set)
 {
 	int ret;
 
@@ -150,7 +144,7 @@ static int register_wakeup_function(int graph, int set)
 		ret = register_ftrace_graph(&wakeup_graph_return,
 					    &wakeup_graph_entry);
 	else
-		ret = register_ftrace_function(&trace_ops);
+		ret = register_ftrace_function(tr->ops);
 
 	if (!ret)
 		function_enabled = true;
@@ -158,7 +152,7 @@ static int register_wakeup_function(int graph, int set)
 	return ret;
 }
 
-static void unregister_wakeup_function(int graph)
+static void unregister_wakeup_function(struct trace_array *tr, int graph)
 {
 	if (!function_enabled)
 		return;
@@ -166,17 +160,17 @@ static void unregister_wakeup_function(int graph)
 	if (graph)
 		unregister_ftrace_graph();
 	else
-		unregister_ftrace_function(&trace_ops);
+		unregister_ftrace_function(tr->ops);
 
 	function_enabled = false;
 }
 
-static void wakeup_function_set(int set)
+static void wakeup_function_set(struct trace_array *tr, int set)
 {
 	if (set)
-		register_wakeup_function(is_graph(), 1);
+		register_wakeup_function(tr, is_graph(), 1);
 	else
-		unregister_wakeup_function(is_graph());
+		unregister_wakeup_function(tr, is_graph());
 }
 
 static int wakeup_flag_changed(struct trace_array *tr, u32 mask, int set)
@@ -184,16 +178,16 @@ static int wakeup_flag_changed(struct trace_array *tr, u32 mask, int set)
 	struct tracer *tracer = tr->current_trace;
 
 	if (mask & TRACE_ITER_FUNCTION)
-		wakeup_function_set(set);
+		wakeup_function_set(tr, set);
 
 	return trace_keep_overwrite(tracer, mask, set);
 }
 
-static int start_func_tracer(int graph)
+static int start_func_tracer(struct trace_array *tr, int graph)
 {
 	int ret;
 
-	ret = register_wakeup_function(graph, 0);
+	ret = register_wakeup_function(tr, graph, 0);
 
 	if (!ret && tracing_is_enabled())
 		tracer_enabled = 1;
@@ -203,11 +197,11 @@ static int start_func_tracer(int graph)
 	return ret;
 }
 
-static void stop_func_tracer(int graph)
+static void stop_func_tracer(struct trace_array *tr, int graph)
 {
 	tracer_enabled = 0;
 
-	unregister_wakeup_function(graph);
+	unregister_wakeup_function(tr, graph);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -221,12 +215,12 @@ wakeup_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 	if (!(is_graph() ^ set))
 		return 0;
 
-	stop_func_tracer(!set);
+	stop_func_tracer(tr, !set);
 
 	wakeup_reset(wakeup_trace);
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 
-	return start_func_tracer(set);
+	return start_func_tracer(tr, set);
 }
 
 static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
@@ -350,13 +344,13 @@ static void wakeup_print_header(struct seq_file *s)
 /*
  * Should this new latency be reported/recorded?
  */
-static int report_latency(cycle_t delta)
+static int report_latency(struct trace_array *tr, cycle_t delta)
 {
 	if (tracing_thresh) {
 		if (delta < tracing_thresh)
 			return 0;
 	} else {
-		if (delta <= tracing_max_latency)
+		if (delta <= tr->max_latency)
 			return 0;
 	}
 	return 1;
@@ -424,11 +418,11 @@ probe_wakeup_sched_switch(void *ignore,
 	T1 = ftrace_now(cpu);
 	delta = T1-T0;
 
-	if (!report_latency(delta))
+	if (!report_latency(wakeup_trace, delta))
 		goto out_unlock;
 
 	if (likely(!is_tracing_stopped())) {
-		tracing_max_latency = delta;
+		wakeup_trace->max_latency = delta;
 		update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
 	}
 
@@ -587,7 +581,7 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	 */
 	smp_wmb();
 
-	if (start_func_tracer(is_graph()))
+	if (start_func_tracer(tr, is_graph()))
 		printk(KERN_ERR "failed to start wakeup tracer\n");
 
 	return;
@@ -600,13 +594,15 @@ fail_deprobe:
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	stop_func_tracer(is_graph());
+	stop_func_tracer(tr, is_graph());
 	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 	unregister_trace_sched_wakeup(probe_wakeup, NULL);
 	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task, NULL);
 }
 
+static bool wakeup_busy;
+
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
 	save_flags = trace_flags;
@@ -615,14 +611,20 @@ static int __wakeup_tracer_init(struct trace_array *tr)
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
 
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	wakeup_trace = tr;
+	ftrace_init_array_ops(tr, wakeup_tracer_call);
 	start_wakeup_tracer(tr);
+
+	wakeup_busy = true;
 	return 0;
 }
 
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	if (wakeup_busy)
+		return -EBUSY;
+
 	wakeup_dl = 0;
 	wakeup_rt = 0;
 	return __wakeup_tracer_init(tr);
@@ -630,6 +632,9 @@ static int wakeup_tracer_init(struct trace_array *tr)
 
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	if (wakeup_busy)
+		return -EBUSY;
+
 	wakeup_dl = 0;
 	wakeup_rt = 1;
 	return __wakeup_tracer_init(tr);
@@ -637,6 +642,9 @@ static int wakeup_rt_tracer_init(struct trace_array *tr)
 
 static int wakeup_dl_tracer_init(struct trace_array *tr)
 {
+	if (wakeup_busy)
+		return -EBUSY;
+
 	wakeup_dl = 1;
 	wakeup_rt = 0;
 	return __wakeup_tracer_init(tr);
@@ -653,6 +661,8 @@ static void wakeup_tracer_reset(struct trace_array *tr)
 
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
+	ftrace_reset_array_ops(tr);
+	wakeup_busy = false;
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
@@ -684,6 +694,7 @@ static struct tracer wakeup_tracer __read_mostly =
 #endif
 	.open		= wakeup_trace_open,
 	.close		= wakeup_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 
@@ -694,7 +705,6 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
-	.wait_pipe	= poll_wait_pipe,
 	.print_max	= true,
 	.print_header	= wakeup_print_header,
 	.print_line	= wakeup_print_line,
@@ -706,6 +716,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 #endif
 	.open		= wakeup_trace_open,
 	.close		= wakeup_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 
@@ -716,7 +727,6 @@ static struct tracer wakeup_dl_tracer __read_mostly =
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
-	.wait_pipe	= poll_wait_pipe,
 	.print_max	= true,
 	.print_header	= wakeup_print_header,
 	.print_line	= wakeup_print_line,
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index e98fca60974f..5ef60499dc8e 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -65,7 +65,7 @@ static int trace_test_buffer(struct trace_buffer *buf, unsigned long *count)
 
 	/* Don't allow flipping of max traces now */
 	local_irq_save(flags);
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&buf->tr->max_lock);
 
 	cnt = ring_buffer_entries(buf->buffer);
 
@@ -83,7 +83,7 @@ static int trace_test_buffer(struct trace_buffer *buf, unsigned long *count)
 			break;
 	}
 	tracing_on();
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&buf->tr->max_lock);
 	local_irq_restore(flags);
 
 	if (count)
@@ -161,11 +161,6 @@ static struct ftrace_ops test_probe3 = {
 	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
 };
 
-static struct ftrace_ops test_global = {
-	.func		= trace_selftest_test_global_func,
-	.flags		= FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
 static void print_counts(void)
 {
 	printk("(%d %d %d %d %d) ",
@@ -185,7 +180,7 @@ static void reset_counts(void)
 	trace_selftest_test_dyn_cnt = 0;
 }
 
-static int trace_selftest_ops(int cnt)
+static int trace_selftest_ops(struct trace_array *tr, int cnt)
 {
 	int save_ftrace_enabled = ftrace_enabled;
 	struct ftrace_ops *dyn_ops;
@@ -220,7 +215,11 @@ static int trace_selftest_ops(int cnt)
 	register_ftrace_function(&test_probe1);
 	register_ftrace_function(&test_probe2);
 	register_ftrace_function(&test_probe3);
-	register_ftrace_function(&test_global);
+	/* First time we are running with main function */
+	if (cnt > 1) {
+		ftrace_init_array_ops(tr, trace_selftest_test_global_func);
+		register_ftrace_function(tr->ops);
+	}
 
 	DYN_FTRACE_TEST_NAME();
 
@@ -232,8 +231,10 @@ static int trace_selftest_ops(int cnt)
 		goto out;
 	if (trace_selftest_test_probe3_cnt != 1)
 		goto out;
-	if (trace_selftest_test_global_cnt == 0)
-		goto out;
+	if (cnt > 1) {
+		if (trace_selftest_test_global_cnt == 0)
+			goto out;
+	}
 
 	DYN_FTRACE_TEST_NAME2();
 
@@ -269,8 +270,10 @@ static int trace_selftest_ops(int cnt)
 		goto out_free;
 	if (trace_selftest_test_probe3_cnt != 3)
 		goto out_free;
-	if (trace_selftest_test_global_cnt == 0)
-		goto out;
+	if (cnt > 1) {
+		if (trace_selftest_test_global_cnt == 0)
+			goto out;
+	}
 	if (trace_selftest_test_dyn_cnt == 0)
 		goto out_free;
 
@@ -295,7 +298,9 @@ static int trace_selftest_ops(int cnt)
 	unregister_ftrace_function(&test_probe1);
 	unregister_ftrace_function(&test_probe2);
 	unregister_ftrace_function(&test_probe3);
-	unregister_ftrace_function(&test_global);
+	if (cnt > 1)
+		unregister_ftrace_function(tr->ops);
+	ftrace_reset_array_ops(tr);
 
 	/* Make sure everything is off */
 	reset_counts();
@@ -315,9 +320,9 @@ static int trace_selftest_ops(int cnt)
 }
 
 /* Test dynamic code modification and ftrace filters */
-int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
-					   struct trace_array *tr,
-					   int (*func)(void))
+static int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
+						  struct trace_array *tr,
+						  int (*func)(void))
 {
 	int save_ftrace_enabled = ftrace_enabled;
 	unsigned long count;
@@ -388,7 +393,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	}
 
 	/* Test the ops with global tracing running */
-	ret = trace_selftest_ops(1);
+	ret = trace_selftest_ops(tr, 1);
 	trace->reset(tr);
 
  out:
@@ -399,7 +404,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 
 	/* Test the ops with global tracing off */
 	if (!ret)
-		ret = trace_selftest_ops(2);
+		ret = trace_selftest_ops(tr, 2);
 
 	return ret;
 }
@@ -802,7 +807,7 @@ out:
 int
 trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	unsigned long count;
 	int ret;
 
@@ -814,7 +819,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	/* disable interrupts for a bit */
 	local_irq_disable();
 	udelay(100);
@@ -841,7 +846,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 		ret = -1;
 	}
 
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	return ret;
 }
@@ -851,7 +856,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 int
 trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	unsigned long count;
 	int ret;
 
@@ -876,7 +881,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	/* disable preemption for a bit */
 	preempt_disable();
 	udelay(100);
@@ -903,7 +908,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 		ret = -1;
 	}
 
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	return ret;
 }
@@ -913,7 +918,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 int
 trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	unsigned long count;
 	int ret;
 
@@ -938,7 +943,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 
 	/* disable preemption and interrupts for a bit */
 	preempt_disable();
@@ -973,7 +978,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	}
 
 	/* do the test by disabling interrupts first this time */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	tracing_start();
 	trace->start(tr);
 
@@ -1004,7 +1009,7 @@ out:
 	tracing_start();
 out_no_start:
 	trace->reset(tr);
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	return ret;
 }
@@ -1057,7 +1062,7 @@ static int trace_wakeup_test_thread(void *data)
 int
 trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	struct task_struct *p;
 	struct completion is_ready;
 	unsigned long count;
@@ -1083,7 +1088,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 
 	while (p->on_rq) {
 		/*
@@ -1113,7 +1118,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	trace->reset(tr);
 	tracing_start();
 
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	/* kill the thread */
 	kthread_stop(p);
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 21b320e5d163..8a4e5cb66a4c 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -51,11 +51,33 @@ static DEFINE_MUTEX(stack_sysctl_mutex);
 int stack_tracer_enabled;
 static int last_stack_tracer_enabled;
 
+static inline void print_max_stack(void)
+{
+	long i;
+	int size;
+
+	pr_emerg("        Depth    Size   Location    (%d entries)\n"
+			   "        -----    ----   --------\n",
+			   max_stack_trace.nr_entries - 1);
+
+	for (i = 0; i < max_stack_trace.nr_entries; i++) {
+		if (stack_dump_trace[i] == ULONG_MAX)
+			break;
+		if (i+1 == max_stack_trace.nr_entries ||
+				stack_dump_trace[i+1] == ULONG_MAX)
+			size = stack_dump_index[i];
+		else
+			size = stack_dump_index[i] - stack_dump_index[i+1];
+
+		pr_emerg("%3ld) %8d   %5d   %pS\n", i, stack_dump_index[i],
+				size, (void *)stack_dump_trace[i]);
+	}
+}
+
 static inline void
 check_stack(unsigned long ip, unsigned long *stack)
 {
-	unsigned long this_size, flags;
-	unsigned long *p, *top, *start;
+	unsigned long this_size, flags; unsigned long *p, *top, *start;
 	static int tracer_frame;
 	int frame_size = ACCESS_ONCE(tracer_frame);
 	int i;
@@ -85,8 +107,12 @@ check_stack(unsigned long ip, unsigned long *stack)
 
 	max_stack_size = this_size;
 
-	max_stack_trace.nr_entries	= 0;
-	max_stack_trace.skip		= 3;
+	max_stack_trace.nr_entries = 0;
+
+	if (using_ftrace_ops_list_func())
+		max_stack_trace.skip = 4;
+	else
+		max_stack_trace.skip = 3;
 
 	save_stack_trace(&max_stack_trace);
 
@@ -145,8 +171,12 @@ check_stack(unsigned long ip, unsigned long *stack)
 			i++;
 	}
 
-	BUG_ON(current != &init_task &&
-		*(end_of_stack(current)) != STACK_END_MAGIC);
+	if ((current != &init_task &&
+		*(end_of_stack(current)) != STACK_END_MAGIC)) {
+		print_max_stack();
+		BUG();
+	}
+
  out:
 	arch_spin_unlock(&max_stack_lock);
 	local_irq_restore(flags);
