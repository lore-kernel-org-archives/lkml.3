Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaHDOyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:54:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:57707 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750949AbaHDOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:54:00 -0400
Date: Mon, 4 Aug 2014 10:53:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] tracing: Updates for 3.17
Message-ID: <20140804105358.05e7f06e@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This pull request has a lot of work done. The main thing is the changes
to the ftrace function callback infrastructure. It's introducing a
way to allow different functions to call directly different trampolines
instead of all calling the same "mcount" one.

The only user of this for now is the function graph tracer, which always
had a different trampoline, but the function tracer trampoline was called
and did basically nothing, and then the function graph tracer trampoline
was called. The difference now, is that the function graph tracer
trampoline can be called directly if a function is only being traced by
the function graph trampoline. If function tracing is also happening on
the same function, the old way is still done.

The accounting for this takes up more memory when function graph tracing
is activated, as it needs to keep track of which functions it uses.
I have a new way that wont take as much memory, but it's not ready yet
for this merge window, and will have to wait for the next one.

Another big change was the removal of the ftrace_start/stop() calls that
were used by the suspend/resume code that stopped function tracing when
entering into suspend and resume paths. The stop of ftrace was done
because there was some function that would crash the system if one called
smp_processor_id()! The stop/start was a big hammer to solve the issue
at the time, which was when ftrace was first introduced into Linux.
Now ftrace has better infrastructure to debug such issues, and I found
the problem function and labeled it with "notrace" and function tracing
can now safely be activated all the way down into the guts of suspend
and resume.

Other changes include clean ups of uprobe code.
Clean up of the trace_seq() code.
And other various small fixes and clean ups to ftrace and tracing.

Please pull the latest trace-3.17 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.17

Tag SHA1: d4002f19e30e036df2dce7c212c84055db88c612
Head SHA1: dc6f03f26f570104a2bb03f9d1deb588026d7c75


Corey Minyard (1):
      ring-buffer: Always run per-cpu ring buffer resize with schedule_work_on()

Fabian Frederick (2):
      tracing: Remove unnecessary null test before debugfs_remove()
      tracing: Convert pr_warning() to pr_warn() in trace_events.c

Heiko Carstens (1):
      s390/ftrace: remove check of obsolete variable function_trace_stop

Masami Hiramatsu (1):
      ftrace: Simplify ftrace_hash_disable/enable path in ftrace_hash_move

Namhyung Kim (7):
      ftrace: Get rid of obsolete global_start_up variable
      ftrace: Fix memory leak on failure path in ftrace_allocate_pages()
      ftrace: Do not copy hash if O_TRUNC is set
      tracing: Add ftrace_graph_notrace boot parameter
      tracing: Improve message of empty set_graph_notrace file
      tracing: Improve message of empty set_ftrace_notrace file
      tracing: Add description of set_graph_notrace to tracing/README

Oleg Nesterov (4):
      tracing/uprobes: Revert "Support mix of ftrace and perf"
      uprobes: Change unregister/apply to WARN() if uprobe/consumer is gone
      tracing/uprobes: Kill the bogus UPROBE_HANDLER_REMOVE code in uprobe_dispatcher()
      tracing/uprobes: Fix the usage of uprobe_buffer_enable() in probe_event_enable()

Stanislav Fomichev (1):
      tracing: let user specify tracing_thresh after selecting function_graph

Steven Rostedt (Red Hat) (44):
      ftrace: Allow no regs if no more callbacks require it
      ftrace: Use macros for numbers in ftrace rec shift bits
      ftrace: Add ftrace_rec_counter() macro to simplify the code
      ftrace: Optimize function graph to be called directly
      ftrace: Add trampolines to enabled_functions debug file
      tracing: Move the trace_seq_* functions into its own trace_seq.c file
      tracing: Clean up trace_seq.c
      tracing: Make trace_seq_putmem_hex() more robust
      tracing: Remove trace_seq_reserve()
      tracing: Add trace_seq_buffer_ptr() helper function
      tracing: Remove ftrace_stop/start() from reading the trace file
      Merge branch 'trace/ftrace/urgent' into trace/ftrace/core
      ftrace: Allow archs to specify if they need a separate function graph trampoline
      ftrace/x86: Have function graph tracer use its own trampoline
      x86, power, suspend: Annotate restore_processor_state() with notrace
      PM / Sleep: Remove ftrace_stop/start() from suspend and hibernate
      ftrace-graph: Remove dependency of ftrace_stop() from ftrace_graph_stop()
      ftrace/x86: Add call to ftrace_graph_is_dead() in function graph code
      microblaze: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      MIPS: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      parisc: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      powerpc/ftrace: Add call to ftrace_graph_is_dead() in function graph code
      sh: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      ftrace-graph: Remove usage of ftrace_stop() in ftrace_graph_stop()
      ftrace: Remove ftrace_start/stop()
      ftrace: Do no disable function tracing on enabling function tracing
      ftrace: Remove function_trace_stop check from list func
      ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST
      ftrace: x86: Remove check of obsolete variable function_trace_stop
      tile: ftrace: Remove check of obsolete variable function_trace_stop
      sparc64,ftrace: Remove check of obsolete variable function_trace_stop
      sh: ftrace: Remove check of obsolete variable function_trace_stop
      parisc: ftrace: Remove check of obsolete variable function_trace_stop
      MIPS: ftrace: Remove check of obsolete variable function_trace_stop
      microblaze: ftrace: Remove check of obsolete variable function_trace_stop
      metag: ftrace: Remove check of obsolete variable function_trace_stop
      Blackfin: ftrace: Remove check of obsolete variable function_trace_stop
      arm64, ftrace: Remove check of obsolete variable function_trace_stop
      tracing: Remove function_trace_stop and HAVE_FUNCTION_TRACE_MCOUNT_TEST
      tracing: Convert local function_graph functions to static
      ftrace: Rename ftrace_ops field from trampolines to nr_trampolines
      ring-buffer: Use rb_page_size() instead of open coded head_page size
      ftrace: Fix trampoline hash update check on rec->flags
      ftrace: Add warning if tramp hash does not match nr_trampolines

Wang Nan (1):
      ftrace: Do not copy old hash when resetting

Zhao Hongjiang (1):
      tracing: Change trace event sample to use strlcpy instead of strncpy

----
 Documentation/kernel-parameters.txt        |   6 +
 Documentation/trace/ftrace-design.txt      |  26 --
 arch/arm64/kernel/entry-ftrace.S           |   5 -
 arch/blackfin/Kconfig                      |   1 -
 arch/blackfin/kernel/ftrace-entry.S        |  18 --
 arch/metag/Kconfig                         |   1 -
 arch/metag/kernel/ftrace_stub.S            |  14 -
 arch/microblaze/Kconfig                    |   1 -
 arch/microblaze/kernel/ftrace.c            |   3 +
 arch/microblaze/kernel/mcount.S            |   5 -
 arch/mips/Kconfig                          |   1 -
 arch/mips/kernel/ftrace.c                  |   3 +
 arch/mips/kernel/mcount.S                  |   7 -
 arch/parisc/Kconfig                        |   1 -
 arch/parisc/kernel/ftrace.c                |   6 +-
 arch/powerpc/kernel/ftrace.c               |   3 +
 arch/s390/Kconfig                          |   1 -
 arch/s390/kernel/mcount.S                  |  10 +-
 arch/s390/kernel/mcount64.S                |   3 -
 arch/sh/Kconfig                            |   1 -
 arch/sh/kernel/ftrace.c                    |   3 +
 arch/sh/lib/mcount.S                       |  24 +-
 arch/sparc/Kconfig                         |   1 -
 arch/sparc/lib/mcount.S                    |  10 +-
 arch/tile/Kconfig                          |   1 -
 arch/tile/kernel/mcount_64.S               |  18 --
 arch/x86/Kconfig                           |   1 -
 arch/x86/include/asm/ftrace.h              |   2 +
 arch/x86/kernel/entry_32.S                 |   9 -
 arch/x86/kernel/ftrace.c                   |   3 +
 arch/x86/kernel/mcount_64.S                |  13 +-
 arch/x86/kvm/mmutrace.h                    |   2 +-
 arch/x86/power/cpu.c                       |   4 +-
 drivers/scsi/scsi_trace.c                  |  16 +-
 include/linux/ftrace.h                     |  68 ++---
 include/linux/trace_seq.h                  |  36 ++-
 kernel/events/uprobes.c                    |   6 +-
 kernel/power/hibernate.c                   |   6 -
 kernel/power/suspend.c                     |   2 -
 kernel/trace/Kconfig                       |   5 -
 kernel/trace/Makefile                      |   1 +
 kernel/trace/ftrace.c                      | 445 +++++++++++++++++++++++------
 kernel/trace/ring_buffer.c                 |  26 +-
 kernel/trace/trace.c                       |  98 ++++---
 kernel/trace/trace.h                       |   2 +
 kernel/trace/trace_events.c                |  56 ++--
 kernel/trace/trace_functions_graph.c       |  43 ++-
 kernel/trace/trace_output.c                | 282 +-----------------
 kernel/trace/trace_output.h                |   4 -
 kernel/trace/trace_seq.c                   | 428 +++++++++++++++++++++++++++
 kernel/trace/trace_uprobe.c                |  46 +--
 samples/trace_events/trace-events-sample.h |   2 +-
 52 files changed, 1062 insertions(+), 717 deletions(-)
---------------------------
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1b9aa8c5a52..19c0a9096a02 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1097,6 +1097,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			that can be changed at run time by the
 			set_graph_function file in the debugfs tracing directory.
 
+	ftrace_graph_notrace=[function-list]
+			[FTRACE] Do not trace from the functions specified in
+			function-list.  This list is a comma separated list of
+			functions that can be changed at run time by the
+			set_graph_notrace file in the debugfs tracing directory.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 3f669b9e8852..dd5f916b351d 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -102,30 +102,6 @@ extern void mcount(void);
 EXPORT_SYMBOL(mcount);
 
 
-HAVE_FUNCTION_TRACE_MCOUNT_TEST
--------------------------------
-
-This is an optional optimization for the normal case when tracing is turned off
-in the system.  If you do not enable this Kconfig option, the common ftrace
-code will take care of doing the checking for you.
-
-To support this feature, you only need to check the function_trace_stop
-variable in the mcount function.  If it is non-zero, there is no tracing to be
-done at all, so you can return.
-
-This additional pseudo code would simply be:
-void mcount(void)
-{
-	/* save any bare state needed in order to do initial checking */
-
-+	if (function_trace_stop)
-+		return;
-
-	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
-	if (ftrace_trace_function != ftrace_stub)
-...
-
-
 HAVE_FUNCTION_GRAPH_TRACER
 --------------------------
 
@@ -328,8 +304,6 @@ void mcount(void)
 
 void ftrace_caller(void)
 {
-	/* implement HAVE_FUNCTION_TRACE_MCOUNT_TEST if you desire */
-
 	/* save all state needed by the ABI (see paragraph above) */
 
 	unsigned long frompc = ...;
diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index aa5f9fcbf9ee..38e704e597f7 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -96,11 +96,6 @@
  *     - ftrace_graph_caller to set up an exit hook
  */
 ENTRY(_mcount)
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	ldr	x0, =ftrace_trace_stop
-	ldr	x0, [x0]		// if ftrace_trace_stop
-	ret				//   return;
-#endif
 	mcount_enter
 
 	ldr	x0, =ftrace_trace_function
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f81e7b989fff..ed30699cc635 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -18,7 +18,6 @@ config BLACKFIN
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_IDE
 	select HAVE_KERNEL_GZIP if RAMKERNEL
 	select HAVE_KERNEL_BZIP2 if RAMKERNEL
diff --git a/arch/blackfin/kernel/ftrace-entry.S b/arch/blackfin/kernel/ftrace-entry.S
index 7eed00bbd26d..28d059540424 100644
--- a/arch/blackfin/kernel/ftrace-entry.S
+++ b/arch/blackfin/kernel/ftrace-entry.S
@@ -33,15 +33,6 @@ ENDPROC(__mcount)
  * function will be waiting there.  mmmm pie.
  */
 ENTRY(_ftrace_caller)
-# ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	/* optional micro optimization: return if stopped */
-	p1.l = _function_trace_stop;
-	p1.h = _function_trace_stop;
-	r3 = [p1];
-	cc = r3 == 0;
-	if ! cc jump _ftrace_stub (bp);
-# endif
-
 	/* save first/second/third function arg and the return register */
 	[--sp] = r2;
 	[--sp] = r0;
@@ -83,15 +74,6 @@ ENDPROC(_ftrace_caller)
 
 /* See documentation for _ftrace_caller */
 ENTRY(__mcount)
-# ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	/* optional micro optimization: return if stopped */
-	p1.l = _function_trace_stop;
-	p1.h = _function_trace_stop;
-	r3 = [p1];
-	cc = r3 == 0;
-	if ! cc jump _ftrace_stub (bp);
-# endif
-
 	/* save third function arg early so we can do testing below */
 	[--sp] = r2;
 
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 499b7610eaaf..0b389a81c43a 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -13,7 +13,6 @@ config METAG
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
diff --git a/arch/metag/kernel/ftrace_stub.S b/arch/metag/kernel/ftrace_stub.S
index e70bff745bdd..3acc288217c0 100644
--- a/arch/metag/kernel/ftrace_stub.S
+++ b/arch/metag/kernel/ftrace_stub.S
@@ -16,13 +16,6 @@ _mcount_wrapper:
 	.global _ftrace_caller
 	.type	_ftrace_caller,function
 _ftrace_caller:
-	MOVT    D0Re0,#HI(_function_trace_stop)
-	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
-	GETD	D0Re0,[D0Re0]
-	CMP	D0Re0,#0
-	BEQ	$Lcall_stub
-	MOV	PC,D0.4
-$Lcall_stub:
 	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
 	MOV     D1Ar1, D0.4
 	MOV     D0Ar2, D1RtP
@@ -42,13 +35,6 @@ _ftrace_call:
 	.global	_mcount_wrapper
 	.type	_mcount_wrapper,function
 _mcount_wrapper:
-	MOVT    D0Re0,#HI(_function_trace_stop)
-	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
-	GETD	D0Re0,[D0Re0]
-	CMP	D0Re0,#0
-	BEQ	$Lcall_mcount
-	MOV	PC,D0.4
-$Lcall_mcount:
 	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
 	MOV     D1Ar1, D0.4
 	MOV     D0Ar2, D1RtP
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 9ae08541e30d..40e1c1dd0e24 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -22,7 +22,6 @@ config MICROBLAZE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUNCTION_TRACER
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index bbcd2533766c..fc7b48a52cd5 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -27,6 +27,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	unsigned long return_hooker = (unsigned long)
 				&return_to_handler;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
index fc1e1322ce4c..fed9da5de8c4 100644
--- a/arch/microblaze/kernel/mcount.S
+++ b/arch/microblaze/kernel/mcount.S
@@ -91,11 +91,6 @@ ENTRY(ftrace_caller)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 	SAVE_REGS
 	swi	r15, r1, 0;
-	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST begin of checking */
-	lwi	r5, r0, function_trace_stop;
-	bneid	r5, end;
-	nop;
-	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 #ifndef CONFIG_DYNAMIC_FTRACE
 	lwi	r5, r0, ftrace_graph_return;
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 4e238e6e661c..10f270bd3e25 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -15,7 +15,6 @@ config MIPS
 	select HAVE_BPF_JIT if !CPU_MICROMIPS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_C_RECORDMCOUNT
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 60e7e5e45af1..8b6538750fe1 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -302,6 +302,9 @@ void prepare_ftrace_return(unsigned long *parent_ra_addr, unsigned long self_ra,
 	    &return_to_handler;
 	int faulted, insns;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 539b6294b613..00940d1d5c4f 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -74,10 +74,6 @@ _mcount:
 #endif
 
 	/* When tracing is activated, it calls ftrace_caller+8 (aka here) */
-	lw	t1, function_trace_stop
-	bnez	t1, ftrace_stub
-	 nop
-
 	MCOUNT_SAVE_REGS
 #ifdef KBUILD_MCOUNT_RA_ADDRESS
 	PTR_S	MCOUNT_RA_ADDRESS_REG, PT_R12(sp)
@@ -105,9 +101,6 @@ ftrace_stub:
 #else	/* ! CONFIG_DYNAMIC_FTRACE */
 
 NESTED(_mcount, PT_SIZE, ra)
-	lw	t1, function_trace_stop
-	bnez	t1, ftrace_stub
-	 nop
 	PTR_LA	t1, ftrace_stub
 	PTR_L	t2, ftrace_trace_function /* Prepare t2 for (1) */
 	bne	t1, t2, static_trace
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 108d48e652af..6e75e2030927 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -6,7 +6,6 @@ config PARISC
 	select HAVE_OPROFILE
 	select HAVE_FUNCTION_TRACER if 64BIT
 	select HAVE_FUNCTION_GRAPH_TRACER if 64BIT
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST if 64BIT
 	select ARCH_WANT_FRAME_POINTERS
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 5beb97bafbb1..559d400f9385 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -112,6 +112,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	unsigned long long calltime;
 	struct ftrace_graph_ent trace;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
@@ -152,9 +155,6 @@ void ftrace_function_trampoline(unsigned long parent,
 {
 	extern ftrace_func_t ftrace_trace_function;
 
-	if (function_trace_stop)
-		return;
-
 	if (ftrace_trace_function != ftrace_stub) {
 		ftrace_trace_function(parent, self_addr);
 		return;
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index d178834fe508..390311c0f03d 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -525,6 +525,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	struct ftrace_graph_ent trace;
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bb63499fc5d3..f5af5f6ef0f4 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -116,7 +116,6 @@ config S390
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 08dcf21cb8df..433c6dbfa442 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -21,13 +21,9 @@ ENTRY(_mcount)
 ENTRY(ftrace_caller)
 #endif
 	stm	%r2,%r5,16(%r15)
-	bras	%r1,2f
+	bras	%r1,1f
 0:	.long	ftrace_trace_function
-1:	.long	function_trace_stop
-2:	l	%r2,1b-0b(%r1)
-	icm	%r2,0xf,0(%r2)
-	jnz	3f
-	st	%r14,56(%r15)
+1:	st	%r14,56(%r15)
 	lr	%r0,%r15
 	ahi	%r15,-96
 	l	%r3,100(%r15)
@@ -50,7 +46,7 @@ ENTRY(ftrace_graph_caller)
 #endif
 	ahi	%r15,96
 	l	%r14,56(%r15)
-3:	lm	%r2,%r5,16(%r15)
+	lm	%r2,%r5,16(%r15)
 	br	%r14
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index 1c52eae3396a..c67a8bf0fd9a 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -20,9 +20,6 @@ ENTRY(_mcount)
 
 ENTRY(ftrace_caller)
 #endif
-	larl	%r1,function_trace_stop
-	icm	%r1,0xf,0(%r1)
-	bnzr	%r14
 	stmg	%r2,%r5,32(%r15)
 	stg	%r14,112(%r15)
 	lgr	%r1,%r15
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 834b67c4db5a..aa2df3eaeb29 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -57,7 +57,6 @@ config SUPERH32
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_FUNCTION_GRAPH_TRACER
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index 3c74f53db6db..079d70e6d74b 100644
--- a/arch/sh/kernel/ftrace.c
+++ b/arch/sh/kernel/ftrace.c
@@ -344,6 +344,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	struct ftrace_graph_ent trace;
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
diff --git a/arch/sh/lib/mcount.S b/arch/sh/lib/mcount.S
index 52aa2011d753..7a8572f9d58b 100644
--- a/arch/sh/lib/mcount.S
+++ b/arch/sh/lib/mcount.S
@@ -92,13 +92,6 @@ mcount:
 	rts
 	 nop
 #else
-#ifndef CONFIG_DYNAMIC_FTRACE
-	mov.l	.Lfunction_trace_stop, r0
-	mov.l	@r0, r0
-	tst	r0, r0
-	bf	ftrace_stub
-#endif
-
 	MCOUNT_ENTER()
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -174,11 +167,6 @@ ftrace_graph_call:
 
 	.globl ftrace_caller
 ftrace_caller:
-	mov.l	.Lfunction_trace_stop, r0
-	mov.l	@r0, r0
-	tst	r0, r0
-	bf	ftrace_stub
-
 	MCOUNT_ENTER()
 
 	.globl ftrace_call
@@ -196,8 +184,6 @@ ftrace_call:
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 	.align 2
-.Lfunction_trace_stop:
-	.long	function_trace_stop
 
 /*
  * NOTE: From here on the locations of the .Lftrace_stub label and
@@ -217,12 +203,7 @@ ftrace_stub:
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	.globl	ftrace_graph_caller
 ftrace_graph_caller:
-	mov.l	2f, r0
-	mov.l	@r0, r0
-	tst	r0, r0
-	bt	1f
-
-	mov.l	3f, r1
+	mov.l	2f, r1
 	jmp	@r1
 	 nop
 1:
@@ -242,8 +223,7 @@ ftrace_graph_caller:
 	MCOUNT_LEAVE()
 
 	.align 2
-2:	.long	function_trace_stop
-3:	.long	skip_trace
+2:	.long	skip_trace
 .Lprepare_ftrace_return:
 	.long	prepare_ftrace_return
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 29f2e988c56a..abd7d5575a7d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -55,7 +55,6 @@ config SPARC64
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select HAVE_RCU_TABLE_FREE if SMP
diff --git a/arch/sparc/lib/mcount.S b/arch/sparc/lib/mcount.S
index 3ad6cbdc2163..0b0ed4d34219 100644
--- a/arch/sparc/lib/mcount.S
+++ b/arch/sparc/lib/mcount.S
@@ -24,10 +24,7 @@ mcount:
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/* Do nothing, the retl/nop below is all we need.  */
 #else
-	sethi		%hi(function_trace_stop), %g1
-	lduw		[%g1 + %lo(function_trace_stop)], %g2
-	brnz,pn		%g2, 2f
-	 sethi		%hi(ftrace_trace_function), %g1
+	sethi		%hi(ftrace_trace_function), %g1
 	sethi		%hi(ftrace_stub), %g2
 	ldx		[%g1 + %lo(ftrace_trace_function)], %g1
 	or		%g2, %lo(ftrace_stub), %g2
@@ -80,11 +77,8 @@ ftrace_stub:
 	.globl		ftrace_caller
 	.type		ftrace_caller,#function
 ftrace_caller:
-	sethi		%hi(function_trace_stop), %g1
 	mov		%i7, %g2
-	lduw		[%g1 + %lo(function_trace_stop)], %g1
-	brnz,pn		%g1, ftrace_stub
-	 mov		%fp, %g3
+	mov		%fp, %g3
 	save		%sp, -176, %sp
 	mov		%g2, %o1
 	mov		%g2, %l0
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 4f3006b600e3..7fcd492adbfc 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -128,7 +128,6 @@ config TILEGX
 	select SPARSE_IRQ
 	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/tile/kernel/mcount_64.S b/arch/tile/kernel/mcount_64.S
index 70d7bb0c4d8f..3c2b8d5e1d1a 100644
--- a/arch/tile/kernel/mcount_64.S
+++ b/arch/tile/kernel/mcount_64.S
@@ -77,15 +77,6 @@ STD_ENDPROC(__mcount)
 
 	.align	64
 STD_ENTRY(ftrace_caller)
-	moveli	r11, hw2_last(function_trace_stop)
-	{ shl16insli	r11, r11, hw1(function_trace_stop); move r12, lr }
-	{ shl16insli	r11, r11, hw0(function_trace_stop); move lr, r10 }
-	ld	r11, r11
-	beqz	r11, 1f
-	jrp	r12
-
-1:
-	{ move	r10, lr; move	lr, r12 }
 	MCOUNT_SAVE_REGS
 
 	/* arg1: self return address */
@@ -119,15 +110,6 @@ STD_ENDPROC(ftrace_caller)
 
 	.align	64
 STD_ENTRY(__mcount)
-	moveli	r11, hw2_last(function_trace_stop)
-	{ shl16insli	r11, r11, hw1(function_trace_stop); move r12, lr }
-	{ shl16insli	r11, r11, hw0(function_trace_stop); move lr, r10 }
-	ld	r11, r11
-	beqz	r11, 1f
-	jrp	r12
-
-1:
-	{ move	r10, lr; move	lr, r12 }
 	{
 	 moveli	r11, hw2_last(ftrace_trace_function)
 	 moveli	r13, hw2_last(ftrace_stub)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749ef0fdc..5b45e8fccaca 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,7 +54,6 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_SYSCALL_TRACEPOINTS
 	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_KVM
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 0525a8bdf65d..e1f7fecaa7d6 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -68,6 +68,8 @@ struct dyn_arch_ftrace {
 
 int ftrace_int3_handler(struct pt_regs *regs);
 
+#define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
+
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dbaa23e78b36..64762c62e8a7 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1058,9 +1058,6 @@ ENTRY(mcount)
 END(mcount)
 
 ENTRY(ftrace_caller)
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	pushl %eax
 	pushl %ecx
 	pushl %edx
@@ -1092,8 +1089,6 @@ END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
 	pushf	/* push flags before compare (in cs location) */
-	cmpl $0, function_trace_stop
-	jne ftrace_restore_flags
 
 	/*
 	 * i386 does not save SS and ESP when coming from kernel.
@@ -1152,7 +1147,6 @@ GLOBAL(ftrace_regs_call)
 	popf			/* Pop flags at end (no addl to corrupt flags) */
 	jmp ftrace_ret
 
-ftrace_restore_flags:
 	popf
 	jmp  ftrace_stub
 #else /* ! CONFIG_DYNAMIC_FTRACE */
@@ -1161,9 +1155,6 @@ ENTRY(mcount)
 	cmpl $__PAGE_OFFSET, %esp
 	jb ftrace_stub		/* Paging not enabled yet? */
 
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cbc4a91b131e..3386dc9aa333 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -703,6 +703,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	unsigned long return_hooker = (unsigned long)
 				&return_to_handler;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return;
+
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index c050a0153168..c73aecf10d34 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -46,10 +46,6 @@ END(function_hook)
 .endm
 
 ENTRY(ftrace_caller)
-	/* Check if tracing was disabled (quick check) */
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	ftrace_caller_setup
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
@@ -73,10 +69,6 @@ ENTRY(ftrace_regs_caller)
 	/* Save the current flags before compare (in SS location)*/
 	pushfq
 
-	/* Check if tracing was disabled (quick check) */
-	cmpl $0, function_trace_stop
-	jne  ftrace_restore_flags
-
 	/* skip=8 to skip flags saved in SS */
 	ftrace_caller_setup 8
 
@@ -131,7 +123,7 @@ GLOBAL(ftrace_regs_call)
 	popfq
 
 	jmp ftrace_return
-ftrace_restore_flags:
+
 	popfq
 	jmp  ftrace_stub
 
@@ -141,9 +133,6 @@ END(ftrace_regs_caller)
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(function_hook)
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 9d2e0ffcb190..2e5652b62fd6 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -22,7 +22,7 @@
 	__entry->unsync = sp->unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
-	const char *ret = p->buffer + p->len;				\
+	const char *ret = trace_seq_buffer_ptr(p);			\
 	static const char *access_str[] = {			        \
 		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
 	};							        \
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 424f4c97a44d..6ec7910f59bf 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -165,7 +165,7 @@ static void fix_processor_context(void)
  *		by __save_processor_state()
  *	@ctxt - structure to load the registers contents from
  */
-static void __restore_processor_state(struct saved_context *ctxt)
+static void notrace __restore_processor_state(struct saved_context *ctxt)
 {
 	if (ctxt->misc_enable_saved)
 		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
@@ -239,7 +239,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 }
 
 /* Needed by apm.c */
-void restore_processor_state(void)
+void notrace restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
 }
diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 2bea4f0b684a..503594e5f76d 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -28,7 +28,7 @@ scsi_trace_misc(struct trace_seq *, unsigned char *, int);
 static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 	sector_t lba = 0, txlen = 0;
 
 	lba |= ((cdb[1] & 0x1F) << 16);
@@ -46,7 +46,7 @@ scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 	sector_t lba = 0, txlen = 0;
 
 	lba |= (cdb[2] << 24);
@@ -71,7 +71,7 @@ scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 	sector_t lba = 0, txlen = 0;
 
 	lba |= (cdb[2] << 24);
@@ -94,7 +94,7 @@ scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 	sector_t lba = 0, txlen = 0;
 
 	lba |= ((u64)cdb[2] << 56);
@@ -125,7 +125,7 @@ scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len, *cmd;
+	const char *ret = trace_seq_buffer_ptr(p), *cmd;
 	sector_t lba = 0, txlen = 0;
 	u32 ei_lbrt = 0;
 
@@ -180,7 +180,7 @@ out:
 static const char *
 scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 	unsigned int regions = cdb[7] << 8 | cdb[8];
 
 	trace_seq_printf(p, "regions=%u", (regions - 8) / 16);
@@ -192,7 +192,7 @@ scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len, *cmd;
+	const char *ret = trace_seq_buffer_ptr(p), *cmd;
 	sector_t lba = 0;
 	u32 alloc_len = 0;
 
@@ -247,7 +247,7 @@ scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_misc(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	trace_seq_printf(p, "-");
 	trace_seq_putc(p, 0);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 404a686a3644..6bb5e3f2a3b4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -33,8 +33,7 @@
  * features, then it must call an indirect function that
  * does. Or at least does enough to prevent any unwelcomed side effects.
  */
-#if !defined(CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST) || \
-	!ARCH_SUPPORTS_FTRACE_OPS
+#if !ARCH_SUPPORTS_FTRACE_OPS
 # define FTRACE_FORCE_LIST_FUNC 1
 #else
 # define FTRACE_FORCE_LIST_FUNC 0
@@ -118,17 +117,18 @@ struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
-	int __percpu			*disabled;
 	void				*private;
+	int __percpu			*disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
+	int				nr_trampolines;
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
+	struct ftrace_hash		*tramp_hash;
 	struct mutex			regex_lock;
+	unsigned long			trampoline;
 #endif
 };
 
-extern int function_trace_stop;
-
 /*
  * Type of the current tracing.
  */
@@ -140,32 +140,6 @@ enum ftrace_tracing_type_t {
 /* Current tracing type, default is FTRACE_TYPE_ENTER */
 extern enum ftrace_tracing_type_t ftrace_tracing_type;
 
-/**
- * ftrace_stop - stop function tracer.
- *
- * A quick way to stop the function tracer. Note this an on off switch,
- * it is not something that is recursive like preempt_disable.
- * This does not disable the calling of mcount, it only stops the
- * calling of functions from mcount.
- */
-static inline void ftrace_stop(void)
-{
-	function_trace_stop = 1;
-}
-
-/**
- * ftrace_start - start the function tracer.
- *
- * This function is the inverse of ftrace_stop. This does not enable
- * the function tracing if the function tracer is disabled. This only
- * sets the function tracer flag to continue calling the functions
- * from mcount.
- */
-static inline void ftrace_start(void)
-{
-	function_trace_stop = 0;
-}
-
 /*
  * The ftrace_ops must be a static and should also
  * be read_mostly.  These functions do modify read_mostly variables
@@ -242,8 +216,6 @@ static inline int ftrace_nr_registered_ops(void)
 }
 static inline void clear_ftrace_function(void) { }
 static inline void ftrace_kill(void) { }
-static inline void ftrace_stop(void) { }
-static inline void ftrace_start(void) { }
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_STACK_TRACER
@@ -317,13 +289,20 @@ extern int ftrace_nr_registered_ops(void);
  * from tracing that function.
  */
 enum {
-	FTRACE_FL_ENABLED	= (1UL << 29),
+	FTRACE_FL_ENABLED	= (1UL << 31),
 	FTRACE_FL_REGS		= (1UL << 30),
-	FTRACE_FL_REGS_EN	= (1UL << 31)
+	FTRACE_FL_REGS_EN	= (1UL << 29),
+	FTRACE_FL_TRAMP		= (1UL << 28),
+	FTRACE_FL_TRAMP_EN	= (1UL << 27),
 };
 
-#define FTRACE_FL_MASK		(0x7UL << 29)
-#define FTRACE_REF_MAX		((1UL << 29) - 1)
+#define FTRACE_REF_MAX_SHIFT	27
+#define FTRACE_FL_BITS		5
+#define FTRACE_FL_MASKED_BITS	((1UL << FTRACE_FL_BITS) - 1)
+#define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
+#define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
+
+#define ftrace_rec_count(rec)	((rec)->flags & ~FTRACE_FL_MASK)
 
 struct dyn_ftrace {
 	unsigned long		ip; /* address of mcount call-site */
@@ -431,6 +410,10 @@ void ftrace_modify_all_code(int command);
 #define FTRACE_ADDR ((unsigned long)ftrace_caller)
 #endif
 
+#ifndef FTRACE_GRAPH_ADDR
+#define FTRACE_GRAPH_ADDR ((unsigned long)ftrace_graph_caller)
+#endif
+
 #ifndef FTRACE_REGS_ADDR
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 # define FTRACE_REGS_ADDR ((unsigned long)ftrace_regs_caller)
@@ -439,6 +422,16 @@ void ftrace_modify_all_code(int command);
 #endif
 #endif
 
+/*
+ * If an arch would like functions that are only traced
+ * by the function graph tracer to jump directly to its own
+ * trampoline, then they can define FTRACE_GRAPH_TRAMP_ADDR
+ * to be that address to jump to.
+ */
+#ifndef FTRACE_GRAPH_TRAMP_ADDR
+#define FTRACE_GRAPH_TRAMP_ADDR ((unsigned long) 0)
+#endif
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern void ftrace_graph_caller(void);
 extern int ftrace_enable_ftrace_graph_caller(void);
@@ -736,6 +729,7 @@ extern char __irqentry_text_end[];
 extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 				trace_func_graph_ent_t entryfunc);
 
+extern bool ftrace_graph_is_dead(void);
 extern void ftrace_graph_stop(void);
 
 /* The current handlers in use */
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 136116924d8d..ea6c9dea79e3 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -25,6 +25,21 @@ trace_seq_init(struct trace_seq *s)
 	s->full = 0;
 }
 
+/**
+ * trace_seq_buffer_ptr - return pointer to next location in buffer
+ * @s: trace sequence descriptor
+ *
+ * Returns the pointer to the buffer where the next write to
+ * the buffer will happen. This is useful to save the location
+ * that is about to be written to and then return the result
+ * of that write.
+ */
+static inline unsigned char *
+trace_seq_buffer_ptr(struct trace_seq *s)
+{
+	return s->buffer + s->len;
+}
+
 /*
  * Currently only defined when tracing is enabled.
  */
@@ -36,14 +51,13 @@ int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args);
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
-extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt);
+extern int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+			     int cnt);
 extern int trace_seq_puts(struct trace_seq *s, const char *str);
 extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-extern int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len);
+extern int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len);
 extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
-				size_t len);
-extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
+				unsigned int len);
 extern int trace_seq_path(struct trace_seq *s, const struct path *path);
 
 extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
@@ -71,8 +85,8 @@ static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	return 0;
 }
-static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt)
+static inline int trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				    int cnt)
 {
 	return 0;
 }
@@ -85,19 +99,15 @@ static inline int trace_seq_putc(struct trace_seq *s, unsigned char c)
 	return 0;
 }
 static inline int
-trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
+trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 {
 	return 0;
 }
 static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
-				       size_t len)
+				       unsigned int len)
 {
 	return 0;
 }
-static inline void *trace_seq_reserve(struct trace_seq *s, size_t len)
-{
-	return NULL;
-}
 static inline int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
 	return 0;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c445e392e93f..6f3254e8c137 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -846,7 +846,7 @@ static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *u
 {
 	int err;
 
-	if (!consumer_del(uprobe, uc))	/* WARN? */
+	if (WARN_ON(!consumer_del(uprobe, uc)))
 		return;
 
 	err = register_for_each_vma(uprobe, NULL);
@@ -927,7 +927,7 @@ int uprobe_apply(struct inode *inode, loff_t offset,
 	int ret = -ENOENT;
 
 	uprobe = find_uprobe(inode, offset);
-	if (!uprobe)
+	if (WARN_ON(!uprobe))
 		return ret;
 
 	down_write(&uprobe->register_rwsem);
@@ -952,7 +952,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	struct uprobe *uprobe;
 
 	uprobe = find_uprobe(inode, offset);
-	if (!uprobe)
+	if (WARN_ON(!uprobe))
 		return;
 
 	down_write(&uprobe->register_rwsem);
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fcc2611d3f14..a9dfa79b6bab 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -371,7 +371,6 @@ int hibernation_snapshot(int platform_mode)
 	}
 
 	suspend_console();
-	ftrace_stop();
 	pm_restrict_gfp_mask();
 
 	error = dpm_suspend(PMSG_FREEZE);
@@ -397,7 +396,6 @@ int hibernation_snapshot(int platform_mode)
 	if (error || !in_suspend)
 		pm_restore_gfp_mask();
 
-	ftrace_start();
 	resume_console();
 	dpm_complete(msg);
 
@@ -500,7 +498,6 @@ int hibernation_restore(int platform_mode)
 
 	pm_prepare_console();
 	suspend_console();
-	ftrace_stop();
 	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
@@ -508,7 +505,6 @@ int hibernation_restore(int platform_mode)
 		dpm_resume_end(PMSG_RECOVER);
 	}
 	pm_restore_gfp_mask();
-	ftrace_start();
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -535,7 +531,6 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
-	ftrace_stop();
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -579,7 +574,6 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
-	ftrace_start();
 	resume_console();
 
  Close:
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4dd8822f732a..f6623da034d8 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -248,7 +248,6 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 		goto Platform_wake;
 	}
 
-	ftrace_stop();
 	error = disable_nonboot_cpus();
 	if (error || suspend_test(TEST_CPUS))
 		goto Enable_cpus;
@@ -275,7 +274,6 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 
  Enable_cpus:
 	enable_nonboot_cpus();
-	ftrace_start();
 
  Platform_wake:
 	if (need_suspend_ops(state) && suspend_ops->wake)
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d4409356f40d..a5da09c899dd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -29,11 +29,6 @@ config HAVE_FUNCTION_GRAPH_FP_TEST
 	help
 	  See Documentation/trace/ftrace-design.txt
 
-config HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	bool
-	help
-	  See Documentation/trace/ftrace-design.txt
-
 config HAVE_DYNAMIC_FTRACE
 	bool
 	help
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 2611613f14f1..67d6369ddf83 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
+obj-$(CONFIG_TRACING) += trace_seq.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b372e3ed675..979bd8cb4349 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -80,9 +80,6 @@ static struct ftrace_ops ftrace_list_end __read_mostly = {
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
-/* Quick disabling of function tracer. */
-int function_trace_stop __read_mostly;
-
 /* Current function tracing op */
 struct ftrace_ops *function_trace_op __read_mostly = &ftrace_list_end;
 /* What to set function_trace_op to */
@@ -1042,6 +1039,8 @@ static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+static struct ftrace_ops *removed_ops;
+
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
 # error Dynamic ftrace depends on MCOUNT_RECORD
 #endif
@@ -1304,25 +1303,15 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct ftrace_hash *new_hash;
 	int size = src->count;
 	int bits = 0;
-	int ret;
 	int i;
 
 	/*
-	 * Remove the current set, update the hash and add
-	 * them back.
-	 */
-	ftrace_hash_rec_disable(ops, enable);
-
-	/*
 	 * If the new source is empty, just free dst and assign it
 	 * the empty_hash.
 	 */
 	if (!src->count) {
-		free_ftrace_hash_rcu(*dst);
-		rcu_assign_pointer(*dst, EMPTY_HASH);
-		/* still need to update the function records */
-		ret = 0;
-		goto out;
+		new_hash = EMPTY_HASH;
+		goto update;
 	}
 
 	/*
@@ -1335,10 +1324,9 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	if (bits > FTRACE_HASH_MAX_BITS)
 		bits = FTRACE_HASH_MAX_BITS;
 
-	ret = -ENOMEM;
 	new_hash = alloc_ftrace_hash(bits);
 	if (!new_hash)
-		goto out;
+		return -ENOMEM;
 
 	size = 1 << src->size_bits;
 	for (i = 0; i < size; i++) {
@@ -1349,20 +1337,20 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 		}
 	}
 
+update:
+	/*
+	 * Remove the current set, update the hash and add
+	 * them back.
+	 */
+	ftrace_hash_rec_disable(ops, enable);
+
 	old_hash = *dst;
 	rcu_assign_pointer(*dst, new_hash);
 	free_ftrace_hash_rcu(old_hash);
 
-	ret = 0;
- out:
-	/*
-	 * Enable regardless of ret:
-	 *  On success, we enable the new hash.
-	 *  On failure, we re-enable the original hash.
-	 */
 	ftrace_hash_rec_enable(ops, enable);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -1492,6 +1480,53 @@ int ftrace_text_reserved(const void *start, const void *end)
 	return (int)!!ret;
 }
 
+/* Test if ops registered to this rec needs regs */
+static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *ops;
+	bool keep_regs = false;
+
+	for (ops = ftrace_ops_list;
+	     ops != &ftrace_list_end; ops = ops->next) {
+		/* pass rec in as regs to have non-NULL val */
+		if (ftrace_ops_test(ops, rec->ip, rec)) {
+			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+				keep_regs = true;
+				break;
+			}
+		}
+	}
+
+	return  keep_regs;
+}
+
+static void ftrace_remove_tramp(struct ftrace_ops *ops,
+				struct dyn_ftrace *rec)
+{
+	struct ftrace_func_entry *entry;
+
+	entry = ftrace_lookup_ip(ops->tramp_hash, rec->ip);
+	if (!entry)
+		return;
+
+	/*
+	 * The tramp_hash entry will be removed at time
+	 * of update.
+	 */
+	ops->nr_trampolines--;
+	rec->flags &= ~FTRACE_FL_TRAMP;
+}
+
+static void ftrace_clear_tramps(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *op;
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		if (op->nr_trampolines)
+			ftrace_remove_tramp(op, rec);
+	} while_for_each_ftrace_op(op);
+}
+
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1572,8 +1607,30 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 
 		if (inc) {
 			rec->flags++;
-			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == FTRACE_REF_MAX))
+			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == FTRACE_REF_MAX))
 				return;
+
+			/*
+			 * If there's only a single callback registered to a
+			 * function, and the ops has a trampoline registered
+			 * for it, then we can call it directly.
+			 */
+			if (ftrace_rec_count(rec) == 1 && ops->trampoline) {
+				rec->flags |= FTRACE_FL_TRAMP;
+				ops->nr_trampolines++;
+			} else {
+				/*
+				 * If we are adding another function callback
+				 * to this function, and the previous had a
+				 * trampoline used, then we need to go back to
+				 * the default trampoline.
+				 */
+				rec->flags &= ~FTRACE_FL_TRAMP;
+
+				/* remove trampolines from any ops for this rec */
+				ftrace_clear_tramps(rec);
+			}
+
 			/*
 			 * If any ops wants regs saved for this function
 			 * then all ops will get saved regs.
@@ -1581,9 +1638,30 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
 				rec->flags |= FTRACE_FL_REGS;
 		} else {
-			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
+			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == 0))
 				return;
 			rec->flags--;
+
+			if (ops->trampoline && !ftrace_rec_count(rec))
+				ftrace_remove_tramp(ops, rec);
+
+			/*
+			 * If the rec had REGS enabled and the ops that is
+			 * being removed had REGS set, then see if there is
+			 * still any ops for this record that wants regs.
+			 * If not, we can stop recording them.
+			 */
+			if (ftrace_rec_count(rec) > 0 &&
+			    rec->flags & FTRACE_FL_REGS &&
+			    ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+				if (!test_rec_ops_needs_regs(rec))
+					rec->flags &= ~FTRACE_FL_REGS;
+			}
+
+			/*
+			 * flags will be cleared in ftrace_check_record()
+			 * if rec count is zero.
+			 */
 		}
 		count++;
 		/* Shortcut, if we handled all records, we are done. */
@@ -1668,17 +1746,23 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 	 * If we are disabling calls, then disable all records that
 	 * are enabled.
 	 */
-	if (enable && (rec->flags & ~FTRACE_FL_MASK))
+	if (enable && ftrace_rec_count(rec))
 		flag = FTRACE_FL_ENABLED;
 
 	/*
-	 * If enabling and the REGS flag does not match the REGS_EN, then
-	 * do not ignore this record. Set flags to fail the compare against
-	 * ENABLED.
+	 * If enabling and the REGS flag does not match the REGS_EN, or
+	 * the TRAMP flag doesn't match the TRAMP_EN, then do not ignore
+	 * this record. Set flags to fail the compare against ENABLED.
 	 */
-	if (flag &&
-	    (!(rec->flags & FTRACE_FL_REGS) != !(rec->flags & FTRACE_FL_REGS_EN)))
-		flag |= FTRACE_FL_REGS;
+	if (flag) {
+		if (!(rec->flags & FTRACE_FL_REGS) != 
+		    !(rec->flags & FTRACE_FL_REGS_EN))
+			flag |= FTRACE_FL_REGS;
+
+		if (!(rec->flags & FTRACE_FL_TRAMP) != 
+		    !(rec->flags & FTRACE_FL_TRAMP_EN))
+			flag |= FTRACE_FL_TRAMP;
+	}
 
 	/* If the state of this record hasn't changed, then do nothing */
 	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
@@ -1696,6 +1780,12 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 				else
 					rec->flags &= ~FTRACE_FL_REGS_EN;
 			}
+			if (flag & FTRACE_FL_TRAMP) {
+				if (rec->flags & FTRACE_FL_TRAMP)
+					rec->flags |= FTRACE_FL_TRAMP_EN;
+				else
+					rec->flags &= ~FTRACE_FL_TRAMP_EN;
+			}
 		}
 
 		/*
@@ -1704,7 +1794,7 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 		 * Otherwise,
 		 *   return UPDATE_MODIFY_CALL to tell the caller to convert
 		 *   from the save regs, to a non-save regs function or
-		 *   vice versa.
+		 *   vice versa, or from a trampoline call.
 		 */
 		if (flag & FTRACE_FL_ENABLED)
 			return FTRACE_UPDATE_MAKE_CALL;
@@ -1714,7 +1804,7 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 
 	if (update) {
 		/* If there's no more users, clear all flags */
-		if (!(rec->flags & ~FTRACE_FL_MASK))
+		if (!ftrace_rec_count(rec))
 			rec->flags = 0;
 		else
 			/* Just disable the record (keep REGS state) */
@@ -1751,6 +1841,43 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
 	return ftrace_check_record(rec, enable, 0);
 }
 
+static struct ftrace_ops *
+ftrace_find_tramp_ops_curr(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *op;
+
+	/* Removed ops need to be tested first */
+	if (removed_ops && removed_ops->tramp_hash) {
+		if (ftrace_lookup_ip(removed_ops->tramp_hash, rec->ip))
+			return removed_ops;
+	}
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		if (!op->tramp_hash)
+			continue;
+
+		if (ftrace_lookup_ip(op->tramp_hash, rec->ip))
+			return op;
+
+	} while_for_each_ftrace_op(op);
+
+	return NULL;
+}
+
+static struct ftrace_ops *
+ftrace_find_tramp_ops_new(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *op;
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		/* pass rec in as regs to have non-NULL val */
+		if (ftrace_ops_test(op, rec->ip, rec))
+			return op;
+	} while_for_each_ftrace_op(op);
+
+	return NULL;
+}
+
 /**
  * ftrace_get_addr_new - Get the call address to set to
  * @rec:  The ftrace record descriptor
@@ -1763,6 +1890,20 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
  */
 unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
 {
+	struct ftrace_ops *ops;
+
+	/* Trampolines take precedence over regs */
+	if (rec->flags & FTRACE_FL_TRAMP) {
+		ops = ftrace_find_tramp_ops_new(rec);
+		if (FTRACE_WARN_ON(!ops || !ops->trampoline)) {
+			pr_warning("Bad trampoline accounting at: %p (%pS)\n",
+				    (void *)rec->ip, (void *)rec->ip);
+			/* Ftrace is shutting down, return anything */
+			return (unsigned long)FTRACE_ADDR;
+		}
+		return ops->trampoline;
+	}
+
 	if (rec->flags & FTRACE_FL_REGS)
 		return (unsigned long)FTRACE_REGS_ADDR;
 	else
@@ -1781,6 +1922,20 @@ unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
  */
 unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec)
 {
+	struct ftrace_ops *ops;
+
+	/* Trampolines take precedence over regs */
+	if (rec->flags & FTRACE_FL_TRAMP_EN) {
+		ops = ftrace_find_tramp_ops_curr(rec);
+		if (FTRACE_WARN_ON(!ops)) {
+			pr_warning("Bad trampoline accounting at: %p (%pS)\n",
+				    (void *)rec->ip, (void *)rec->ip);
+			/* Ftrace is shutting down, return anything */
+			return (unsigned long)FTRACE_ADDR;
+		}
+		return ops->trampoline;
+	}
+
 	if (rec->flags & FTRACE_FL_REGS_EN)
 		return (unsigned long)FTRACE_REGS_ADDR;
 	else
@@ -2023,6 +2178,89 @@ void __weak arch_ftrace_update_code(int command)
 	ftrace_run_stop_machine(command);
 }
 
+static int ftrace_save_ops_tramp_hash(struct ftrace_ops *ops)
+{
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	int size, bits;
+	int ret;
+
+	size = ops->nr_trampolines;
+	bits = 0;
+	/*
+	 * Make the hash size about 1/2 the # found
+	 */
+	for (size /= 2; size; size >>= 1)
+		bits++;
+
+	ops->tramp_hash = alloc_ftrace_hash(bits);
+	/*
+	 * TODO: a failed allocation is going to screw up
+	 * the accounting of what needs to be modified
+	 * and not. For now, we kill ftrace if we fail
+	 * to allocate here. But there are ways around this,
+	 * but that will take a little more work.
+	 */
+	if (!ops->tramp_hash)
+		return -ENOMEM;
+
+	do_for_each_ftrace_rec(pg, rec) {
+		if (ftrace_rec_count(rec) == 1 &&
+		    ftrace_ops_test(ops, rec->ip, rec)) {
+
+			/*
+			 * If another ops adds to a rec, the rec will
+			 * lose its trampoline and never get it back
+			 * until all ops are off of it.
+			 */
+			if (!(rec->flags & FTRACE_FL_TRAMP))
+				continue;
+
+			/* This record had better have a trampoline */
+			if (FTRACE_WARN_ON(!(rec->flags & FTRACE_FL_TRAMP_EN)))
+				return -1;
+
+			ret = add_hash_entry(ops->tramp_hash, rec->ip);
+			if (ret < 0)
+				return ret;
+		}
+	} while_for_each_ftrace_rec();
+
+	/* The number of recs in the hash must match nr_trampolines */
+	FTRACE_WARN_ON(ops->tramp_hash->count != ops->nr_trampolines);
+
+	return 0;
+}
+
+static int ftrace_save_tramp_hashes(void)
+{
+	struct ftrace_ops *op;
+	int ret;
+
+	/*
+	 * Now that any trampoline is being used, we need to save the
+	 * hashes for the ops that have them. This allows the mapping
+	 * back from the record to the ops that has the trampoline to
+	 * know what code is being replaced. Modifying code must always
+	 * verify what it is changing.
+	 */
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+
+		/* The tramp_hash is recreated each time. */
+		free_ftrace_hash(op->tramp_hash);
+		op->tramp_hash = NULL;
+
+		if (op->nr_trampolines) {
+			ret = ftrace_save_ops_tramp_hash(op);
+			if (ret)
+				return ret;
+		}
+
+	} while_for_each_ftrace_op(op);
+
+	return 0;
+}
+
 static void ftrace_run_update_code(int command)
 {
 	int ret;
@@ -2031,11 +2269,6 @@ static void ftrace_run_update_code(int command)
 	FTRACE_WARN_ON(ret);
 	if (ret)
 		return;
-	/*
-	 * Do not call function tracer while we update the code.
-	 * We are in stop machine.
-	 */
-	function_trace_stop++;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2045,15 +2278,15 @@ static void ftrace_run_update_code(int command)
 	 */
 	arch_ftrace_update_code(command);
 
-	function_trace_stop--;
-
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
+
+	ret = ftrace_save_tramp_hashes();
+	FTRACE_WARN_ON(ret);
 }
 
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
-static int global_start_up;
 
 static void control_ops_free(struct ftrace_ops *ops)
 {
@@ -2117,8 +2350,7 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 
 	ftrace_hash_rec_disable(ops, 1);
 
-	if (!global_start_up)
-		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
 
 	command |= FTRACE_UPDATE_CALLS;
 
@@ -2139,8 +2371,16 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 		return 0;
 	}
 
+	/*
+	 * If the ops uses a trampoline, then it needs to be
+	 * tested first on update.
+	 */
+	removed_ops = ops;
+
 	ftrace_run_update_code(command);
 
+	removed_ops = NULL;
+
 	/*
 	 * Dynamic ops may be freed, we must make sure that all
 	 * callers are done before leaving this function.
@@ -2398,7 +2638,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	return start_pg;
 
  free_pages:
-	while (start_pg) {
+	pg = start_pg;
+	while (pg) {
 		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
 		free_pages((unsigned long)pg->records, order);
 		start_pg = pg->next;
@@ -2595,8 +2836,10 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER &&
-	    ftrace_hash_empty(ops->filter_hash)) {
+	if ((iter->flags & FTRACE_ITER_FILTER &&
+	     ftrace_hash_empty(ops->filter_hash)) ||
+	    (iter->flags & FTRACE_ITER_NOTRACE &&
+	     ftrace_hash_empty(ops->notrace_hash))) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
@@ -2641,7 +2884,10 @@ static int t_show(struct seq_file *m, void *v)
 		return t_hash_show(m, iter);
 
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
-		seq_printf(m, "#### all functions enabled ####\n");
+		if (iter->flags & FTRACE_ITER_NOTRACE)
+			seq_printf(m, "#### no functions disabled ####\n");
+		else
+			seq_printf(m, "#### all functions enabled ####\n");
 		return 0;
 	}
 
@@ -2651,10 +2897,22 @@ static int t_show(struct seq_file *m, void *v)
 		return 0;
 
 	seq_printf(m, "%ps", (void *)rec->ip);
-	if (iter->flags & FTRACE_ITER_ENABLED)
+	if (iter->flags & FTRACE_ITER_ENABLED) {
 		seq_printf(m, " (%ld)%s",
-			   rec->flags & ~FTRACE_FL_MASK,
-			   rec->flags & FTRACE_FL_REGS ? " R" : "");
+			   ftrace_rec_count(rec),
+			   rec->flags & FTRACE_FL_REGS ? " R" : "  ");
+		if (rec->flags & FTRACE_FL_TRAMP_EN) {
+			struct ftrace_ops *ops;
+
+			ops = ftrace_find_tramp_ops_curr(rec);
+			if (ops && ops->trampoline)
+				seq_printf(m, "\ttramp: %pS",
+					   (void *)ops->trampoline);
+			else
+				seq_printf(m, "\ttramp: ERROR!");
+		}
+	}	
+
 	seq_printf(m, "\n");
 
 	return 0;
@@ -2702,13 +2960,6 @@ ftrace_enabled_open(struct inode *inode, struct file *file)
 	return iter ? 0 : -ENOMEM;
 }
 
-static void ftrace_filter_reset(struct ftrace_hash *hash)
-{
-	mutex_lock(&ftrace_lock);
-	ftrace_hash_clear(hash);
-	mutex_unlock(&ftrace_lock);
-}
-
 /**
  * ftrace_regex_open - initialize function tracer filter files
  * @ops: The ftrace_ops that hold the hash filters
@@ -2758,7 +3009,13 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		hash = ops->filter_hash;
 
 	if (file->f_mode & FMODE_WRITE) {
-		iter->hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, hash);
+		const int size_bits = FTRACE_HASH_DEFAULT_BITS;
+
+		if (file->f_flags & O_TRUNC)
+			iter->hash = alloc_ftrace_hash(size_bits);
+		else
+			iter->hash = alloc_and_copy_ftrace_hash(size_bits, hash);
+
 		if (!iter->hash) {
 			trace_parser_put(&iter->parser);
 			kfree(iter);
@@ -2767,10 +3024,6 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	}
 
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_TRUNC))
-		ftrace_filter_reset(iter->hash);
-
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
 
@@ -3471,14 +3724,16 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	else
 		orig_hash = &ops->notrace_hash;
 
-	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (reset)
+		hash = alloc_ftrace_hash(FTRACE_HASH_DEFAULT_BITS);
+	else
+		hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+
 	if (!hash) {
 		ret = -ENOMEM;
 		goto out_regex_unlock;
 	}
 
-	if (reset)
-		ftrace_filter_reset(hash);
 	if (buf && !ftrace_match_records(hash, buf, len)) {
 		ret = -EINVAL;
 		goto out_regex_unlock;
@@ -3630,6 +3885,7 @@ __setup("ftrace_filter=", set_ftrace_filter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
+static char ftrace_graph_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
 
 static int __init set_graph_function(char *str)
@@ -3639,16 +3895,29 @@ static int __init set_graph_function(char *str)
 }
 __setup("ftrace_graph_filter=", set_graph_function);
 
-static void __init set_ftrace_early_graph(char *buf)
+static int __init set_graph_notrace_function(char *str)
+{
+	strlcpy(ftrace_graph_notrace_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_graph_notrace=", set_graph_notrace_function);
+
+static void __init set_ftrace_early_graph(char *buf, int enable)
 {
 	int ret;
 	char *func;
+	unsigned long *table = ftrace_graph_funcs;
+	int *count = &ftrace_graph_count;
+
+	if (!enable) {
+		table = ftrace_graph_notrace_funcs;
+		count = &ftrace_graph_notrace_count;
+	}
 
 	while (buf) {
 		func = strsep(&buf, ",");
 		/* we allow only one expression at a time */
-		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
-				      FTRACE_GRAPH_MAX_FUNCS, func);
+		ret = ftrace_set_func(table, count, FTRACE_GRAPH_MAX_FUNCS, func);
 		if (ret)
 			printk(KERN_DEBUG "ftrace: function %s not "
 					  "traceable\n", func);
@@ -3677,7 +3946,9 @@ static void __init set_ftrace_early_filters(void)
 		ftrace_set_early_filter(&global_ops, ftrace_notrace_buf, 0);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (ftrace_graph_buf[0])
-		set_ftrace_early_graph(ftrace_graph_buf);
+		set_ftrace_early_graph(ftrace_graph_buf, 1);
+	if (ftrace_graph_notrace_buf[0])
+		set_ftrace_early_graph(ftrace_graph_notrace_buf, 0);
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 }
 
@@ -3819,7 +4090,12 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 
 	if (ptr == (unsigned long *)1) {
-		seq_printf(m, "#### all functions enabled ####\n");
+		struct ftrace_graph_data *fgd = m->private;
+
+		if (fgd->table == ftrace_graph_funcs)
+			seq_printf(m, "#### all functions enabled ####\n");
+		else
+			seq_printf(m, "#### no functions disabled ####\n");
 		return 0;
 	}
 
@@ -4447,9 +4723,6 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	struct ftrace_ops *op;
 	int bit;
 
-	if (function_trace_stop)
-		return;
-
 	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
 	if (bit < 0)
 		return;
@@ -4461,9 +4734,8 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	preempt_disable_notrace();
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
 		if (ftrace_ops_test(op, ip, regs)) {
-			if (WARN_ON(!op->func)) {
-				function_trace_stop = 1;
-				printk("op=%p %pS\n", op, op);
+			if (FTRACE_WARN_ON(!op->func)) {
+				pr_warn("op=%p %pS\n", op, op);
 				goto out;
 			}
 			op->func(ip, parent_ip, op, regs);
@@ -5084,6 +5356,12 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	/* Function graph doesn't use the .func field of global_ops */
 	global_ops.flags |= FTRACE_OPS_FL_STUB;
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* Optimize function graph calling (if implemented by arch) */
+	if (FTRACE_GRAPH_TRAMP_ADDR != 0)
+		global_ops.trampoline = FTRACE_GRAPH_TRAMP_ADDR;
+#endif
+
 	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
@@ -5104,6 +5382,10 @@ void unregister_ftrace_graph(void)
 	__ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (FTRACE_GRAPH_TRAMP_ADDR != 0)
+		global_ops.trampoline = 0;
+#endif
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
@@ -5183,9 +5465,4 @@ void ftrace_graph_exit_task(struct task_struct *t)
 
 	kfree(ret_stack);
 }
-
-void ftrace_graph_stop(void)
-{
-	ftrace_stop();
-}
 #endif
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7c56c3d06943..d8c267ec5cca 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1693,22 +1693,14 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 			if (!cpu_buffer->nr_pages_to_update)
 				continue;
 
-			/* The update must run on the CPU that is being updated. */
-			preempt_disable();
-			if (cpu == smp_processor_id() || !cpu_online(cpu)) {
+			/* Can't run something on an offline CPU. */
+			if (!cpu_online(cpu)) {
 				rb_update_pages(cpu_buffer);
 				cpu_buffer->nr_pages_to_update = 0;
 			} else {
-				/*
-				 * Can not disable preemption for schedule_work_on()
-				 * on PREEMPT_RT.
-				 */
-				preempt_enable();
 				schedule_work_on(cpu,
 						&cpu_buffer->update_pages_work);
-				preempt_disable();
 			}
-			preempt_enable();
 		}
 
 		/* wait for all the updates to complete */
@@ -1746,22 +1738,14 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		get_online_cpus();
 
-		preempt_disable();
-		/* The update must run on the CPU that is being updated. */
-		if (cpu_id == smp_processor_id() || !cpu_online(cpu_id))
+		/* Can't run something on an offline CPU. */
+		if (!cpu_online(cpu_id))
 			rb_update_pages(cpu_buffer);
 		else {
-			/*
-			 * Can not disable preemption for schedule_work_on()
-			 * on PREEMPT_RT.
-			 */
-			preempt_enable();
 			schedule_work_on(cpu_id,
 					 &cpu_buffer->update_pages_work);
 			wait_for_completion(&cpu_buffer->update_done);
-			preempt_disable();
 		}
-		preempt_enable();
 
 		cpu_buffer->nr_pages_to_update = 0;
 		put_online_cpus();
@@ -3779,7 +3763,7 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 
-	if (iter->head >= local_read(&iter->head_page->page->commit)) {
+	if (iter->head >= rb_page_size(iter->head_page)) {
 		rb_inc_iter(iter);
 		goto again;
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede311717..2752147ed317 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -923,30 +923,6 @@ out:
 	return ret;
 }
 
-ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
-{
-	int len;
-	int ret;
-
-	if (!cnt)
-		return 0;
-
-	if (s->len <= s->readpos)
-		return -EBUSY;
-
-	len = s->len - s->readpos;
-	if (cnt > len)
-		cnt = len;
-	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
-	if (ret == cnt)
-		return -EFAULT;
-
-	cnt -= ret;
-
-	s->readpos += cnt;
-	return cnt;
-}
-
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
@@ -1396,7 +1372,6 @@ void tracing_start(void)
 
 	arch_spin_unlock(&global_trace.max_lock);
 
-	ftrace_start();
  out:
 	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
 }
@@ -1443,7 +1418,6 @@ void tracing_stop(void)
 	struct ring_buffer *buffer;
 	unsigned long flags;
 
-	ftrace_stop();
 	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
 	if (global_trace.stop_count++)
 		goto out;
@@ -3687,6 +3661,7 @@ static const char readme_msg[] =
 #endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	"  set_graph_function\t- Trace the nested calls of a function (function_graph)\n"
+	"  set_graph_notrace\t- Do not trace the nested calls of a function (function_graph)\n"
 	"  max_graph_depth\t- Trace a limited depth of nested calls (0 is unlimited)\n"
 #endif
 #ifdef CONFIG_TRACER_SNAPSHOT
@@ -4226,10 +4201,9 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 }
 
 static ssize_t
-tracing_max_lat_read(struct file *filp, char __user *ubuf,
-		     size_t cnt, loff_t *ppos)
+tracing_nsecs_read(unsigned long *ptr, char __user *ubuf,
+		   size_t cnt, loff_t *ppos)
 {
-	unsigned long *ptr = filp->private_data;
 	char buf[64];
 	int r;
 
@@ -4241,10 +4215,9 @@ tracing_max_lat_read(struct file *filp, char __user *ubuf,
 }
 
 static ssize_t
-tracing_max_lat_write(struct file *filp, const char __user *ubuf,
-		      size_t cnt, loff_t *ppos)
+tracing_nsecs_write(unsigned long *ptr, const char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
 {
-	unsigned long *ptr = filp->private_data;
 	unsigned long val;
 	int ret;
 
@@ -4257,6 +4230,52 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static ssize_t
+tracing_thresh_read(struct file *filp, char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
+{
+	return tracing_nsecs_read(&tracing_thresh, ubuf, cnt, ppos);
+}
+
+static ssize_t
+tracing_thresh_write(struct file *filp, const char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	int ret;
+
+	mutex_lock(&trace_types_lock);
+	ret = tracing_nsecs_write(&tracing_thresh, ubuf, cnt, ppos);
+	if (ret < 0)
+		goto out;
+
+	if (tr->current_trace->update_thresh) {
+		ret = tr->current_trace->update_thresh(tr);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = cnt;
+out:
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
+static ssize_t
+tracing_max_lat_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	return tracing_nsecs_read(filp->private_data, ubuf, cnt, ppos);
+}
+
+static ssize_t
+tracing_max_lat_write(struct file *filp, const char __user *ubuf,
+		      size_t cnt, loff_t *ppos)
+{
+	return tracing_nsecs_write(filp->private_data, ubuf, cnt, ppos);
+}
+
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
 	struct trace_array *tr = inode->i_private;
@@ -5158,6 +5177,13 @@ static int snapshot_raw_open(struct inode *inode, struct file *filp)
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 
+static const struct file_operations tracing_thresh_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_thresh_read,
+	.write		= tracing_thresh_write,
+	.llseek		= generic_file_llseek,
+};
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -6095,10 +6121,8 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
 	if (!topts)
 		return;
 
-	for (cnt = 0; topts[cnt].opt; cnt++) {
-		if (topts[cnt].entry)
-			debugfs_remove(topts[cnt].entry);
-	}
+	for (cnt = 0; topts[cnt].opt; cnt++)
+		debugfs_remove(topts[cnt].entry);
 
 	kfree(topts);
 }
@@ -6521,7 +6545,7 @@ static __init int tracer_init_debugfs(void)
 	init_tracer_debugfs(&global_trace, d_tracer);
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
-			&tracing_thresh, &tracing_max_lat_fops);
+			&global_trace, &tracing_thresh_fops);
 
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9258f5a815db..385391fb1d3b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -339,6 +339,7 @@ struct tracer_flags {
  * @reset: called when one switches to another tracer
  * @start: called when tracing is unpaused (echo 1 > tracing_enabled)
  * @stop: called when tracing is paused (echo 0 > tracing_enabled)
+ * @update_thresh: called when tracing_thresh is updated
  * @open: called when the trace file is opened
  * @pipe_open: called when the trace_pipe file is opened
  * @close: called when the trace file is released
@@ -357,6 +358,7 @@ struct tracer {
 	void			(*reset)(struct trace_array *tr);
 	void			(*start)(struct trace_array *tr);
 	void			(*stop)(struct trace_array *tr);
+	int			(*update_thresh)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f99e0b3bca8c..e7a814b3906b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -8,6 +8,8 @@
  *
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
@@ -1490,7 +1492,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 
 	dir->entry = debugfs_create_dir(name, parent);
 	if (!dir->entry) {
-		pr_warning("Failed to create system directory %s\n", name);
+		pr_warn("Failed to create system directory %s\n", name);
 		__put_system(system);
 		goto out_free;
 	}
@@ -1506,7 +1508,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warning("Could not create debugfs '%s/filter' entry\n", name);
+		pr_warn("Could not create debugfs '%s/filter' entry\n", name);
 	}
 
 	trace_create_file("enable", 0644, dir->entry, dir,
@@ -1521,8 +1523,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
  out_fail:
 	/* Only print this message if failed on memory allocation */
 	if (!dir || !system)
-		pr_warning("No memory to create event subsystem %s\n",
-			   name);
+		pr_warn("No memory to create event subsystem %s\n", name);
 	return NULL;
 }
 
@@ -1550,8 +1551,7 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 	name = ftrace_event_name(call);
 	file->dir = debugfs_create_dir(name, d_events);
 	if (!file->dir) {
-		pr_warning("Could not create debugfs '%s' directory\n",
-			   name);
+		pr_warn("Could not create debugfs '%s' directory\n", name);
 		return -1;
 	}
 
@@ -1574,8 +1574,8 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 	if (list_empty(head)) {
 		ret = call->class->define_fields(call);
 		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", name);
+			pr_warn("Could not initialize trace point events/%s\n",
+				name);
 			return -1;
 		}
 	}
@@ -1648,8 +1648,7 @@ static int event_init(struct ftrace_event_call *call)
 	if (call->class->raw_init) {
 		ret = call->class->raw_init(call);
 		if (ret < 0 && ret != -ENOSYS)
-			pr_warn("Could not initialize trace events/%s\n",
-				name);
+			pr_warn("Could not initialize trace events/%s\n", name);
 	}
 
 	return ret;
@@ -1894,8 +1893,8 @@ __trace_add_event_dirs(struct trace_array *tr)
 	list_for_each_entry(call, &ftrace_events, list) {
 		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)
-			pr_warning("Could not create directory for event %s\n",
-				   ftrace_event_name(call));
+			pr_warn("Could not create directory for event %s\n",
+				ftrace_event_name(call));
 	}
 }
 
@@ -2207,8 +2206,8 @@ __trace_early_add_event_dirs(struct trace_array *tr)
 	list_for_each_entry(file, &tr->events, list) {
 		ret = event_create_dir(tr->event_dir, file);
 		if (ret < 0)
-			pr_warning("Could not create directory for event %s\n",
-				   ftrace_event_name(file->event_call));
+			pr_warn("Could not create directory for event %s\n",
+				ftrace_event_name(file->event_call));
 	}
 }
 
@@ -2231,8 +2230,8 @@ __trace_early_add_events(struct trace_array *tr)
 
 		ret = __trace_early_add_new_event(call, tr);
 		if (ret < 0)
-			pr_warning("Could not create early event %s\n",
-				   ftrace_event_name(call));
+			pr_warn("Could not create early event %s\n",
+				ftrace_event_name(call));
 	}
 }
 
@@ -2279,13 +2278,13 @@ create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
 	entry = debugfs_create_file("set_event", 0644, parent,
 				    tr, &ftrace_set_event_fops);
 	if (!entry) {
-		pr_warning("Could not create debugfs 'set_event' entry\n");
+		pr_warn("Could not create debugfs 'set_event' entry\n");
 		return -ENOMEM;
 	}
 
 	d_events = debugfs_create_dir("events", parent);
 	if (!d_events) {
-		pr_warning("Could not create debugfs 'events' directory\n");
+		pr_warn("Could not create debugfs 'events' directory\n");
 		return -ENOMEM;
 	}
 
@@ -2461,11 +2460,10 @@ static __init int event_trace_init(void)
 	entry = debugfs_create_file("available_events", 0444, d_tracer,
 				    tr, &ftrace_avail_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'available_events' entry\n");
+		pr_warn("Could not create debugfs 'available_events' entry\n");
 
 	if (trace_define_common_fields())
-		pr_warning("tracing: Failed to allocate common fields");
+		pr_warn("tracing: Failed to allocate common fields");
 
 	ret = early_event_add_tracer(d_tracer, tr);
 	if (ret)
@@ -2474,7 +2472,7 @@ static __init int event_trace_init(void)
 #ifdef CONFIG_MODULES
 	ret = register_module_notifier(&trace_module_nb);
 	if (ret)
-		pr_warning("Failed to register trace events module notifier\n");
+		pr_warn("Failed to register trace events module notifier\n");
 #endif
 	return 0;
 }
@@ -2578,7 +2576,7 @@ static __init void event_trace_self_tests(void)
 		 * it and the self test should not be on.
 		 */
 		if (file->flags & FTRACE_EVENT_FL_ENABLED) {
-			pr_warning("Enabled event during self test!\n");
+			pr_warn("Enabled event during self test!\n");
 			WARN_ON_ONCE(1);
 			continue;
 		}
@@ -2606,8 +2604,8 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 1);
 		if (WARN_ON_ONCE(ret)) {
-			pr_warning("error enabling system %s\n",
-				   system->name);
+			pr_warn("error enabling system %s\n",
+				system->name);
 			continue;
 		}
 
@@ -2615,8 +2613,8 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 0);
 		if (WARN_ON_ONCE(ret)) {
-			pr_warning("error disabling system %s\n",
-				   system->name);
+			pr_warn("error disabling system %s\n",
+				system->name);
 			continue;
 		}
 
@@ -2630,7 +2628,7 @@ static __init void event_trace_self_tests(void)
 
 	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 1);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error enabling all events\n");
+		pr_warn("error enabling all events\n");
 		return;
 	}
 
@@ -2639,7 +2637,7 @@ static __init void event_trace_self_tests(void)
 	/* reset sysname */
 	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error disabling all events\n");
+		pr_warn("error disabling all events\n");
 		return;
 	}
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4de3e57f723c..f0a0c982cde3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -15,6 +15,33 @@
 #include "trace.h"
 #include "trace_output.h"
 
+static bool kill_ftrace_graph;
+
+/**
+ * ftrace_graph_is_dead - returns true if ftrace_graph_stop() was called
+ *
+ * ftrace_graph_stop() is called when a severe error is detected in
+ * the function graph tracing. This function is called by the critical
+ * paths of function graph to keep those paths from doing any more harm.
+ */
+bool ftrace_graph_is_dead(void)
+{
+	return kill_ftrace_graph;
+}
+
+/**
+ * ftrace_graph_stop - set to permanently disable function graph tracincg
+ *
+ * In case of an error int function graph tracing, this is called
+ * to try to keep function graph tracing from causing any more harm.
+ * Usually this is pretty severe and this is called to try to at least
+ * get a warning out to the user.
+ */
+void ftrace_graph_stop(void)
+{
+	kill_ftrace_graph = true;
+}
+
 /* When set, irq functions will be ignored */
 static int ftrace_graph_skip_irqs;
 
@@ -92,6 +119,9 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
 	unsigned long long calltime;
 	int index;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return -EBUSY;
+
 	if (!current->ret_stack)
 		return -EBUSY;
 
@@ -323,7 +353,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	return ret;
 }
 
-int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
+static int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
 {
 	if (tracing_thresh)
 		return 1;
@@ -412,7 +442,7 @@ void set_graph_array(struct trace_array *tr)
 	smp_mb();
 }
 
-void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
+static void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
 {
 	if (tracing_thresh &&
 	    (trace->rettime - trace->calltime < tracing_thresh))
@@ -445,6 +475,12 @@ static void graph_trace_reset(struct trace_array *tr)
 	unregister_ftrace_graph();
 }
 
+static int graph_trace_update_thresh(struct trace_array *tr)
+{
+	graph_trace_reset(tr);
+	return graph_trace_init(tr);
+}
+
 static int max_bytes_for_cpu;
 
 static enum print_line_t
@@ -1399,7 +1435,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	seq_printf(s, "               |   |   |   |\n");
 }
 
-void print_graph_headers(struct seq_file *s)
+static void print_graph_headers(struct seq_file *s)
 {
 	print_graph_headers_flags(s, tracer_flags.val);
 }
@@ -1495,6 +1531,7 @@ static struct trace_event graph_trace_ret_event = {
 
 static struct tracer graph_trace __tracer_data = {
 	.name		= "function_graph",
+	.update_thresh	= graph_trace_update_thresh,
 	.open		= graph_trace_open,
 	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index f3dad80c20b2..c6977d5a9b12 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -20,23 +20,6 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
-int trace_print_seq(struct seq_file *m, struct trace_seq *s)
-{
-	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
-	int ret;
-
-	ret = seq_write(m, s->buffer, len);
-
-	/*
-	 * Only reset this buffer if we successfully wrote to the
-	 * seq_file buffer.
-	 */
-	if (!ret)
-		trace_seq_init(s);
-
-	return ret;
-}
-
 enum print_line_t trace_print_bputs_msg_only(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -85,257 +68,6 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
-/**
- * trace_seq_printf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	va_list ap;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
-	va_end(ap);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(trace_seq_printf);
-
-/**
- * trace_seq_bitmask - put a list of longs as a bitmask print output
- * @s:		trace sequence descriptor
- * @maskp:	points to an array of unsigned longs that represent a bitmask
- * @nmaskbits:	The number of bits that are valid in @maskp
- *
- * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
- *
- * Writes a ASCII representation of a bitmask string into @s.
- */
-int
-trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
-		  int nmaskbits)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
-	s->len += ret;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(trace_seq_bitmask);
-
-/**
- * trace_seq_vprintf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(trace_seq_vprintf);
-
-int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return len;
-}
-
-/**
- * trace_seq_puts - trace sequence printing of simple string
- * @s: trace sequence descriptor
- * @str: simple string to record
- *
- * The tracer may use either the sequence operations or its own
- * copy to user routines. This function records a simple string
- * into a special buffer (@s) for later retrieval by a sequencer
- * or other mechanism.
- */
-int trace_seq_puts(struct trace_seq *s, const char *str)
-{
-	int len = strlen(str);
-
-	if (s->full)
-		return 0;
-
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
-		s->full = 1;
-		return 0;
-	}
-
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
-
-	return len;
-}
-
-int trace_seq_putc(struct trace_seq *s, unsigned char c)
-{
-	if (s->full)
-		return 0;
-
-	if (s->len >= (PAGE_SIZE - 1)) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->buffer[s->len++] = c;
-
-	return 1;
-}
-EXPORT_SYMBOL(trace_seq_putc);
-
-int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
-{
-	if (s->full)
-		return 0;
-
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
-		s->full = 1;
-		return 0;
-	}
-
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
-
-	return len;
-}
-
-int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
-{
-	unsigned char hex[HEX_CHARS];
-	const unsigned char *data = mem;
-	int i, j;
-
-	if (s->full)
-		return 0;
-
-#ifdef __BIG_ENDIAN
-	for (i = 0, j = 0; i < len; i++) {
-#else
-	for (i = len-1, j = 0; i >= 0; i--) {
-#endif
-		hex[j++] = hex_asc_hi(data[i]);
-		hex[j++] = hex_asc_lo(data[i]);
-	}
-	hex[j++] = ' ';
-
-	return trace_seq_putmem(s, hex, j);
-}
-
-void *trace_seq_reserve(struct trace_seq *s, size_t len)
-{
-	void *ret;
-
-	if (s->full)
-		return NULL;
-
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
-		s->full = 1;
-		return NULL;
-	}
-
-	ret = s->buffer + s->len;
-	s->len += len;
-
-	return ret;
-}
-
-int trace_seq_path(struct trace_seq *s, const struct path *path)
-{
-	unsigned char *p;
-
-	if (s->full)
-		return 0;
-
-	if (s->len >= (PAGE_SIZE - 1)) {
-		s->full = 1;
-		return 0;
-	}
-
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
-	if (!IS_ERR(p)) {
-		p = mangle_path(s->buffer + s->len, p, "\n");
-		if (p) {
-			s->len = p - s->buffer;
-			return 1;
-		}
-	} else {
-		s->buffer[s->len++] = '?';
-		return 1;
-	}
-
-	s->full = 1;
-	return 0;
-}
-
 const char *
 ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 		       unsigned long flags,
@@ -343,7 +75,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 {
 	unsigned long mask;
 	const char *str;
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 	int i, first = 1;
 
 	for (i = 0;  flag_array[i].name && flags; i++) {
@@ -379,7 +111,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 			 const struct trace_print_flags *symbol_array)
 {
 	int i;
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	for (i = 0;  symbol_array[i].name; i++) {
 
@@ -390,7 +122,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 		break;
 	}
 
-	if (ret == (const char *)(p->buffer + p->len))
+	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
 		trace_seq_printf(p, "0x%lx", val);
 		
 	trace_seq_putc(p, 0);
@@ -405,7 +137,7 @@ ftrace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
 			 const struct trace_print_flags_u64 *symbol_array)
 {
 	int i;
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	for (i = 0;  symbol_array[i].name; i++) {
 
@@ -416,7 +148,7 @@ ftrace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
 		break;
 	}
 
-	if (ret == (const char *)(p->buffer + p->len))
+	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
 		trace_seq_printf(p, "0x%llx", val);
 
 	trace_seq_putc(p, 0);
@@ -430,7 +162,7 @@ const char *
 ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
 			 unsigned int bitmask_size)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	trace_seq_bitmask(p, bitmask_ptr, bitmask_size * 8);
 	trace_seq_putc(p, 0);
@@ -443,7 +175,7 @@ const char *
 ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 {
 	int i;
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	for (i = 0; i < buf_len; i++)
 		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 127a9d8c8357..80b25b585a70 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -35,9 +35,6 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 extern int __unregister_ftrace_event(struct trace_event *event);
 extern struct rw_semaphore trace_event_sem;
 
-#define MAX_MEMHEX_BYTES	8
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
 #define SEQ_PUT_FIELD_RET(s, x)				\
 do {							\
 	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
@@ -46,7 +43,6 @@ do {							\
 
 #define SEQ_PUT_HEX_FIELD_RET(s, x)			\
 do {							\
-	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
 	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
 		return TRACE_TYPE_PARTIAL_LINE;		\
 } while (0)
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
new file mode 100644
index 000000000000..1f24ed99dca2
--- /dev/null
+++ b/kernel/trace/trace_seq.c
@@ -0,0 +1,428 @@
+/*
+ * trace_seq.c
+ *
+ * Copyright (C) 2008-2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * The trace_seq is a handy tool that allows you to pass a descriptor around
+ * to a buffer that other functions can write to. It is similar to the
+ * seq_file functionality but has some differences.
+ *
+ * To use it, the trace_seq must be initialized with trace_seq_init().
+ * This will set up the counters within the descriptor. You can call
+ * trace_seq_init() more than once to reset the trace_seq to start
+ * from scratch.
+ * 
+ * The buffer size is currently PAGE_SIZE, although it may become dynamic
+ * in the future.
+ *
+ * A write to the buffer will either succed or fail. That is, unlike
+ * sprintf() there will not be a partial write (well it may write into
+ * the buffer but it wont update the pointers). This allows users to
+ * try to write something into the trace_seq buffer and if it fails
+ * they can flush it and try again.
+ *
+ */
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+#include <linux/trace_seq.h>
+
+/* How much buffer is left on the trace_seq? */
+#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
+
+/* How much buffer is written? */
+#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
+
+/**
+ * trace_print_seq - move the contents of trace_seq into a seq_file
+ * @m: the seq_file descriptor that is the destination
+ * @s: the trace_seq descriptor that is the source.
+ *
+ * Returns 0 on success and non zero on error. If it succeeds to
+ * write to the seq_file it will reset the trace_seq, otherwise
+ * it does not modify the trace_seq to let the caller try again.
+ */
+int trace_print_seq(struct seq_file *m, struct trace_seq *s)
+{
+	unsigned int len = TRACE_SEQ_BUF_USED(s);
+	int ret;
+
+	ret = seq_write(m, s->buffer, len);
+
+	/*
+	 * Only reset this buffer if we successfully wrote to the
+	 * seq_file buffer. This lets the caller try again or
+	 * do something else with the contents.
+	 */
+	if (!ret)
+		trace_seq_init(s);
+
+	return ret;
+}
+
+/**
+ * trace_seq_printf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf() is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ *
+ * Returns 1 if we successfully written all the contents to
+ *   the buffer.
+  * Returns 0 if we the length to write is bigger than the
+ *   reserved buffer space. In this case, nothing gets written.
+ */
+int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+{
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	va_list ap;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	va_end(ap);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(trace_seq_printf);
+
+/**
+ * trace_seq_bitmask - write a bitmask array in its ASCII representation
+ * @s:		trace sequence descriptor
+ * @maskp:	points to an array of unsigned longs that represent a bitmask
+ * @nmaskbits:	The number of bits that are valid in @maskp
+ *
+ * Writes a ASCII representation of a bitmask string into @s.
+ *
+ * Returns 1 if we successfully written all the contents to
+ *   the buffer.
+ * Returns 0 if we the length to write is bigger than the
+ *   reserved buffer space. In this case, nothing gets written.
+ */
+int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+		      int nmaskbits)
+{
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
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
+ * trace_seq_vprintf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+{
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_seq_vprintf);
+
+/**
+ * trace_seq_bprintf - Write the printf string from binary arguments
+ * @s: trace sequence descriptor
+ * @fmt: The format string for the @binary arguments
+ * @binary: The binary arguments for @fmt.
+ *
+ * When recording in a fast path, a printf may be recorded with just
+ * saving the format and the arguments as they were passed to the
+ * function, instead of wasting cycles converting the arguments into
+ * ASCII characters. Instead, the arguments are saved in a 32 bit
+ * word array that is defined by the format string constraints.
+ *
+ * This function will take the format and the binary array and finish
+ * the conversion into the ASCII string within the buffer.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+{
+	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_seq_bprintf);
+
+/**
+ * trace_seq_puts - trace sequence printing of simple string
+ * @s: trace sequence descriptor
+ * @str: simple string to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple string
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_puts(struct trace_seq *s, const char *str)
+{
+	unsigned int len = strlen(str);
+
+	if (s->full)
+		return 0;
+
+	if (len > TRACE_SEQ_BUF_LEFT(s)) {
+		s->full = 1;
+		return 0;
+	}
+
+	memcpy(s->buffer + s->len, str, len);
+	s->len += len;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_seq_puts);
+
+/**
+ * trace_seq_putc - trace sequence printing of simple character
+ * @s: trace sequence descriptor
+ * @c: simple character to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple charater
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_putc(struct trace_seq *s, unsigned char c)
+{
+	if (s->full)
+		return 0;
+
+	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->buffer[s->len++] = c;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(trace_seq_putc);
+
+/**
+ * trace_seq_putmem - write raw data into the trace_seq buffer
+ * @s: trace sequence descriptor
+ * @mem: The raw memory to copy into the buffer
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * There may be cases where raw memory needs to be written into the
+ * buffer and a strcpy() would not work. Using this function allows
+ * for such cases.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
+{
+	if (s->full)
+		return 0;
+
+	if (len > TRACE_SEQ_BUF_LEFT(s)) {
+		s->full = 1;
+		return 0;
+	}
+
+	memcpy(s->buffer + s->len, mem, len);
+	s->len += len;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_seq_putmem);
+
+#define MAX_MEMHEX_BYTES	8U
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
+
+/**
+ * trace_seq_putmem_hex - write raw memory into the buffer in ASCII hex
+ * @s: trace sequence descriptor
+ * @mem: The raw memory to write its hex ASCII representation of
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * This is similar to trace_seq_putmem() except instead of just copying the
+ * raw memory into the buffer it writes its ASCII representation of it
+ * in hex characters.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+			 unsigned int len)
+{
+	unsigned char hex[HEX_CHARS];
+	const unsigned char *data = mem;
+	unsigned int start_len;
+	int i, j;
+	int cnt = 0;
+
+	if (s->full)
+		return 0;
+
+	while (len) {
+		start_len = min(len, HEX_CHARS - 1);
+#ifdef __BIG_ENDIAN
+		for (i = 0, j = 0; i < start_len; i++) {
+#else
+		for (i = start_len-1, j = 0; i >= 0; i--) {
+#endif
+			hex[j++] = hex_asc_hi(data[i]);
+			hex[j++] = hex_asc_lo(data[i]);
+		}
+		if (WARN_ON_ONCE(j == 0 || j/2 > len))
+			break;
+
+		/* j increments twice per loop */
+		len -= j / 2;
+		hex[j++] = ' ';
+
+		cnt += trace_seq_putmem(s, hex, j);
+	}
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
+
+/**
+ * trace_seq_path - copy a path into the sequence buffer
+ * @s: trace sequence descriptor
+ * @path: path to write into the sequence buffer.
+ *
+ * Write a path name into the sequence buffer.
+ *
+ * Returns 1 if we successfully written all the contents to
+ *   the buffer.
+ * Returns 0 if we the length to write is bigger than the
+ *   reserved buffer space. In this case, nothing gets written.
+ */
+int trace_seq_path(struct trace_seq *s, const struct path *path)
+{
+	unsigned char *p;
+
+	if (s->full)
+		return 0;
+
+	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
+		s->full = 1;
+		return 0;
+	}
+
+	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+	if (!IS_ERR(p)) {
+		p = mangle_path(s->buffer + s->len, p, "\n");
+		if (p) {
+			s->len = p - s->buffer;
+			return 1;
+		}
+	} else {
+		s->buffer[s->len++] = '?';
+		return 1;
+	}
+
+	s->full = 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(trace_seq_path);
+
+/**
+ * trace_seq_to_user - copy the squence buffer to user space
+ * @s: trace sequence descriptor
+ * @ubuf: The userspace memory location to copy to
+ * @cnt: The amount to copy
+ *
+ * Copies the sequence buffer into the userspace memory pointed to
+ * by @ubuf. It starts from the last read position (@s->readpos)
+ * and writes up to @cnt characters or till it reaches the end of
+ * the content in the buffer (@s->len), which ever comes first.
+ *
+ * On success, it returns a positive number of the number of bytes
+ * it copied.
+ *
+ * On failure it returns -EBUSY if all of the content in the
+ * sequence has been already read, which includes nothing in the
+ * sequenc (@s->len == @s->readpos).
+ *
+ * Returns -EFAULT if the copy to userspace fails.
+ */
+int trace_seq_to_user(struct trace_seq *s, char __user *ubuf, int cnt)
+{
+	int len;
+	int ret;
+
+	if (!cnt)
+		return 0;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = s->len - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	if (ret == cnt)
+		return -EFAULT;
+
+	cnt -= ret;
+
+	s->readpos += cnt;
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(trace_seq_to_user);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 04fdb5de823c..3c9b97e6b1f4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -893,6 +893,9 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 	int ret;
 
 	if (file) {
+		if (tu->tp.flags & TP_FLAG_PROFILE)
+			return -EINTR;
+
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link)
 			return -ENOMEM;
@@ -901,29 +904,40 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 		list_add_tail_rcu(&link->list, &tu->tp.files);
 
 		tu->tp.flags |= TP_FLAG_TRACE;
-	} else
-		tu->tp.flags |= TP_FLAG_PROFILE;
+	} else {
+		if (tu->tp.flags & TP_FLAG_TRACE)
+			return -EINTR;
 
-	ret = uprobe_buffer_enable();
-	if (ret < 0)
-		return ret;
+		tu->tp.flags |= TP_FLAG_PROFILE;
+	}
 
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	if (enabled)
 		return 0;
 
+	ret = uprobe_buffer_enable();
+	if (ret)
+		goto err_flags;
+
 	tu->consumer.filter = filter;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
-	if (ret) {
-		if (file) {
-			list_del(&link->list);
-			kfree(link);
-			tu->tp.flags &= ~TP_FLAG_TRACE;
-		} else
-			tu->tp.flags &= ~TP_FLAG_PROFILE;
-	}
+	if (ret)
+		goto err_buffer;
 
+	return 0;
+
+ err_buffer:
+	uprobe_buffer_disable();
+
+ err_flags:
+	if (file) {
+		list_del(&link->list);
+		kfree(link);
+		tu->tp.flags &= ~TP_FLAG_TRACE;
+	} else {
+		tu->tp.flags &= ~TP_FLAG_PROFILE;
+	}
 	return ret;
 }
 
@@ -1201,12 +1215,6 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 
 	current->utask->vaddr = (unsigned long) &udd;
 
-#ifdef CONFIG_PERF_EVENTS
-	if ((tu->tp.flags & TP_FLAG_TRACE) == 0 &&
-	    !uprobe_perf_filter(&tu->consumer, 0, current->mm))
-		return UPROBE_HANDLER_REMOVE;
-#endif
-
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
 		return 0;
 
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 4b0113f73ee9..476429281389 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -87,7 +87,7 @@ TRACE_EVENT(foo_bar,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->foo, foo, 10);
+		strlcpy(__entry->foo, foo, 10);
 		__entry->bar	= bar;
 	),
 
