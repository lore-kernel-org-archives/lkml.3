Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab3BLSBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:01:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7804 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589Ab3BLSBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:01:31 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=pFkLfayExYYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=h5hdEbQflfcA:10 a=D19gQVrFAAAA:8 a=WO1Tn0vZyNYHTvBCDkYA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=njPhIINv8zpZXyo2:21 a=JsCfvgjAc75I_-Sq:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360692087.21867.42.camel@gandalf.local.home>
Subject: [RFC][PATCH] tracing/syscalls: Have ia32 compat syscalls show raw
 format
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 12 Feb 2013 13:01:27 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracing of ia32 compat system calls has been a bit of a pain as they
use different system call numbers than the 64bit equivalents.

I wrote a simple 'lls' program that lists files. I compiled it as a i686
ELF binary and ran it under a x86_64 box. This is the result:

echo 0 > /debug/tracing/tracing_on
echo 1 > /debug/tracing/events/syscalls/enable
echo 1 > /debug/tracing/tracing_on ; ./lls ; echo 0 > /debug/tracing/tracing_on

grep lls /debug/tracing/trace

[.. skipping calls before TS_COMPAT is set ...]

             lls-1127  [005] d...   936.409188: sys_recvfrom(fd: 0, ubuf: 4d560fc4, size: 0, flags: 8048034, addr: 8, addr_len: f7700420)
             lls-1127  [005] d...   936.409190: sys_recvfrom -> 0x8a77000
             lls-1127  [005] d...   936.409211: sys_lgetxattr(pathname: 0, name: 1000, value: 3, size: 22)
             lls-1127  [005] d...   936.409215: sys_lgetxattr -> 0xf76ff000
             lls-1127  [005] d...   936.409223: sys_dup2(oldfd: 4d55ae9b, newfd: 4)
             lls-1127  [005] d...   936.409228: sys_dup2 -> 0xfffffffffffffffe
             lls-1127  [005] d...   936.409236: sys_newfstat(fd: 4d55b085, statbuf: 80000)
             lls-1127  [005] d...   936.409242: sys_newfstat -> 0x3
             lls-1127  [005] d...   936.409243: sys_removexattr(pathname: 3, name: ffcd0060)
             lls-1127  [005] d...   936.409244: sys_removexattr -> 0x0
             lls-1127  [005] d...   936.409245: sys_lgetxattr(pathname: 0, name: 19614, value: 1, size: 2)
             lls-1127  [005] d...   936.409248: sys_lgetxattr -> 0xf76e5000
             lls-1127  [005] d...   936.409248: sys_newlstat(filename: 3, statbuf: 19614)
             lls-1127  [005] d...   936.409249: sys_newlstat -> 0x0
             lls-1127  [005] d...   936.409262: sys_newfstat(fd: f76fb588, statbuf: 80000)
             lls-1127  [005] d...   936.409279: sys_newfstat -> 0x3
             lls-1127  [005] d...   936.409279: sys_close(fd: 3)
             lls-1127  [005] d...   936.421550: sys_close -> 0x200
             lls-1127  [005] d...   936.421558: sys_removexattr(pathname: 3, name: ffcd00d0)
             lls-1127  [005] d...   936.421560: sys_removexattr -> 0x0
             lls-1127  [005] d...   936.421569: sys_lgetxattr(pathname: 4d564000, name: 1b1abc, value: 5, size: 802)
             lls-1127  [005] d...   936.421574: sys_lgetxattr -> 0x4d564000
             lls-1127  [005] d...   936.421575: sys_capget(header: 4d70f000, dataptr: 1000)
             lls-1127  [005] d...   936.421580: sys_capget -> 0x0
             lls-1127  [005] d...   936.421580: sys_lgetxattr(pathname: 4d710000, name: 3000, value: 3, size: 812)
             lls-1127  [005] d...   936.421589: sys_lgetxattr -> 0x4d710000
             lls-1127  [005] d...   936.426130: sys_lgetxattr(pathname: 4d713000, name: 2abc, value: 3, size: 32)
             lls-1127  [005] d...   936.426141: sys_lgetxattr -> 0x4d713000
             lls-1127  [005] d...   936.426145: sys_newlstat(filename: 3, statbuf: f76ff3f0)
             lls-1127  [005] d...   936.426146: sys_newlstat -> 0x0
             lls-1127  [005] d...   936.431748: sys_lgetxattr(pathname: 0, name: 1000, value: 3, size: 22)

Obviously I'm not calling newfstat with a fd of 4d55b085. The calls are
obviously incorrect, and confusing.

Other efforts have been made to fix this:

https://lkml.org/lkml/2012/3/26/367

But the real solution is to use a swap of syscall tables and such. We
also don't want to add a lot more kluge to the syscall handlers. But
this change will probably take a bit of design and time.

Thus for now, instead of outputting incorrect data, the compat calls can
at least show the raw data. With this patch the changes now have:

grep lls /debug/tracing/trace

[.. skipping calls before TS_COMPAT is set ...]

             lls-1100  [005] d...    97.051233: sys_compat_syscall -> 0x0
             lls-1100  [005] d...    97.051616: sys_compat_syscall(NR: 2d, arg1: 0, arg2: 4d560fc4, arg3: 0, arg4: 8048034, arg5: 8, arg6: f77bb420)
             lls-1100  [005] d...    97.051619: sys_compat_syscall -> 0x91fd000
             lls-1100  [005] d...    97.051640: sys_compat_syscall(NR: c0, arg1: 0, arg2: 1000, arg3: 3, arg4: 22, arg5: ffffffff, arg6: 0)
             lls-1100  [005] d...    97.051644: sys_compat_syscall -> 0xf77ba000
             lls-1100  [005] d...    97.051652: sys_compat_syscall(NR: 21, arg1: 4d55ae9b, arg2: 4, arg3: 4d560fc4, arg4: 4d55ae9b, arg5: 0, arg6: fff3ee78)
             lls-1100  [005] d...    97.051658: sys_compat_syscall -> 0xfffffffffffffffe
             lls-1100  [005] d...    97.051666: sys_compat_syscall(NR: 5, arg1: 4d55b085, arg2: 80000, arg3: 0, arg4: 80482e0, arg5: 4d56187c, arg6: 1)
             lls-1100  [005] d...    97.051672: sys_compat_syscall -> 0x3
             lls-1100  [005] d...    97.051673: sys_compat_syscall(NR: c5, arg1: 3, arg2: fff3e800, arg3: 4d560fc4, arg4: 3, arg5: 4d56187c, arg6: 1)
             lls-1100  [005] d...    97.051674: sys_compat_syscall -> 0x0
             lls-1100  [005] d...    97.051675: sys_compat_syscall(NR: c0, arg1: 0, arg2: 19614, arg3: 1, arg4: 2, arg5: 3, arg6: 0)
             lls-1100  [005] d...    97.051678: sys_compat_syscall -> 0xf77a0000
             lls-1100  [005] d...    97.051678: sys_compat_syscall(NR: 6, arg1: 3, arg2: 19614, arg3: 4d560fc4, arg4: 3, arg5: f77a0000, arg6: 1)
             lls-1100  [005] d...    97.051679: sys_compat_syscall -> 0x0
             lls-1100  [005] d...    97.051693: sys_compat_syscall(NR: 5, arg1: f77b6588, arg2: 80000, arg3: 14, arg4: 80482e0, arg5: 0, arg6: fff3e8e8)
             lls-1100  [005] d...    97.051710: sys_compat_syscall -> 0x3
             lls-1100  [005] d...    97.051711: sys_compat_syscall(NR: 3, arg1: 3, arg2: fff3e950, arg3: 200, arg4: fff3e950, arg5: 0, arg6: fff3e8e8)
             lls-1100  [005] d...    97.063980: sys_compat_syscall -> 0x200
             lls-1100  [005] d...    97.063989: sys_compat_syscall(NR: c5, arg1: 3, arg2: fff3e870, arg3: 4d560fc4, arg4: 80482e0, arg5: 4d5618f8, arg6: fff3e8e8)
             lls-1100  [005] d...    97.063991: sys_compat_syscall -> 0x0
             lls-1100  [005] d...    97.063995: sys_compat_syscall(NR: c0, arg1: 4d564000, arg2: 1b1abc, arg3: 5, arg4: 802, arg5: 3, arg6: 0)
             lls-1100  [005] d...    97.064000: sys_compat_syscall -> 0x4d564000
             lls-1100  [005] d...    97.064000: sys_compat_syscall(NR: 7d, arg1: 4d70f000, arg2: 1000, arg3: 0, arg4: fff3e6f4, arg5: f77ba3d0, arg6: fff3e8e8)
             lls-1100  [005] d...    97.064006: sys_compat_syscall -> 0x0
             lls-1100  [005] d...    97.064007: sys_compat_syscall(NR: c0, arg1: 4d710000, arg2: 3000, arg3: 3, arg4: 812, arg5: 3, arg6: 1ab)
             lls-1100  [005] d...    97.064022: sys_compat_syscall -> 0x4d710000
             lls-1100  [005] d...    97.068559: sys_compat_syscall(NR: c0, arg1: 4d713000, arg2: 2abc, arg3: 3, arg4: 32, arg5: ffffffff, arg6: 0)
             lls-1100  [005] d...    97.068569: sys_compat_syscall -> 0x4d713000
             lls-1100  [005] d...    97.068574: sys_compat_syscall(NR: 6, arg1: 3, arg2: f77ba3f0, arg3: 4d560fc4, arg4: 0, arg5: f77ba3d0, arg6: fff3e8e8)
             lls-1100  [005] d...    97.068575: sys_compat_syscall -> 0x0

Where the output shows the real syscall number (NR:) and each arg. A
userspace tool could easily parse this to convert it to a real system
output like the 64bit calls are done.

The trick to this was to create a pseudo system call called
sys_compat_syscall. This pseudo syscall is never called by anything and
has 7 arguments. Macros to define a 7 argument syscall are added to the
trace_syscall.c file for this special purpose (we don't want people to
think 7 argument syscalls actually exist). The macros will create the
syscall_metadata for the sys_compat_syscall system call, which will be
added to the /debug/tracing/events/syscalls directory. Now all compat
syscalls will go through this event.

The trace_syscalls.c file is updated just enough to handle this new
metadata. The syscall_nr given to this syscall is NR_syscalls, as
NR_syscalls - 1 is the last real syscall that can be traced.

For an architecture to take advantage of using the compat syscalls, it
must define ARCH_TRACE_COMPAT_RAW (done in asm/ftrace.h) and also define
an arch_trace_use_compat() function that will return true if the current
task should use the sys_compat_syscalls metadata for storing the syscall
data in the trace ring buffer (and printing it out as well).

I want to stress that this change does not affect actual syscalls in any
way, shape or form. It is only used within the tracing system and
doesn't interfere with the syscall logic at all. The changes are
consolidated nicely into trace_syscalls.c and asm/ftrace.h.

I had to make one small modification to asm/thread_info.h and that was
to remove the include of asm/ftrace.h. As asm/ftrace.h required the
current_thread_info() it was causing include hell. I do not know why
asm/thread_info.h included ftrace.h, I may need to run several
randconfigs to figure that out. If something needs ftrace.h it should
include it directly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 arch/x86/include/asm/ftrace.h      |   16 +++
 arch/x86/include/asm/thread_info.h |    1 
 kernel/trace/trace_syscalls.c      |  187 +++++++++++++++++++++++++++++++++----
 3 files changed, 184 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 86cb51e..b174032 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -72,4 +72,20 @@ int ftrace_int3_handler(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
+
+#if !defined(__ASSEMBLY__) && !defined(COMPILE_OFFSETS)
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#include <asm/compat.h>
+
+#define ARCH_TRACE_COMPAT_RAW	1
+static inline bool arch_trace_use_compat(struct pt_regs *regs)
+{
+	if (is_compat_task())
+		return true;
+	return false;
+}
+#endif /* CONFIG_FTRACE_SYSCALLS */
+#endif /* !__ASSEMBLY__  && !COMPILE_OFFSETS */
+
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2d946e6..2cd056e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -20,7 +20,6 @@
 struct task_struct;
 struct exec_domain;
 #include <asm/processor.h>
-#include <asm/ftrace.h>
 #include <linux/atomic.h>
 
 struct thread_info {
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5329e13e..92ae5f7 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,5 +1,6 @@
 #include <trace/syscall.h>
 #include <trace/events/syscalls.h>
+#include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>	/* for MODULE_NAME_LEN via KSYM_SYMBOL_LEN */
@@ -10,11 +11,17 @@
 #include "trace_output.h"
 #include "trace.h"
 
+#ifdef ARCH_TRACE_COMPAT_RAW
+# define NR_TRACE_SYSCALLS	(NR_syscalls + 1)
+#else
+# define NR_TRACE_SYSCALLS	NR_syscalls
+#endif
+
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_enter_syscalls, NR_TRACE_SYSCALLS);
+static DECLARE_BITMAP(enabled_exit_syscalls, NR_TRACE_SYSCALLS);
 
 static int syscall_enter_register(struct ftrace_event_call *event,
 				 enum trace_reg type, void *data);
@@ -47,6 +54,124 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 }
 #endif
 
+#ifdef ARCH_TRACE_COMPAT_RAW
+/*
+ * Some architectures that allow for 32bit applications
+ * to run on a 64bit kernel, do not map the syscalls for
+ * the 32bit tasks the same as they do for 64bit tasks.
+ *
+ *     *cough*x86*cough*
+ *
+ * In such a case, instead of reporting the wrong syscalls,
+ * if the arch defines ARCH_TRACE_COMPAT_RAW, it must also
+ * provide a function called arch_trace_use_compat() that
+ * returns true if it should just use a "raw" format for
+ * the syscall.
+ */
+
+static struct syscall_metadata *compat_metadata;
+
+/* The compat_syscall gets assigned to NR_syscalls */
+#define COMPAT_SYSCALL_NR (NR_TRACE_SYSCALLS - 1)
+
+long sys_compat_syscall(int NR, long arg1, long arg2,
+			long arg3, long arg4, long arg5, long arg6);
+
+/*
+ * Locate the syscall compat metadata that was declared by
+ * our pseudo syscall sys_compat_syscall.
+ */
+static void find_compat_meta(void)
+{
+	struct syscall_metadata **start;
+	struct syscall_metadata **stop;
+	struct syscall_metadata *meta;
+	char str[KSYM_SYMBOL_LEN];
+
+	start = __start_syscalls_metadata;
+	stop = __stop_syscalls_metadata;
+
+	/*
+	 * Look up the name instead of using the name, just in case
+	 * the arch does something funny with it (like PowerPC does).
+	 */
+	kallsyms_lookup((unsigned long)sys_compat_syscall, NULL, NULL, NULL, str);
+
+	start = __start_syscalls_metadata;
+	stop = __stop_syscalls_metadata;
+
+	for ( ; start < stop; start++) {
+		if ((*start)->name && arch_syscall_match_sym_name(str, (*start)->name))
+			break;
+	}
+	if (WARN_ON(start == stop))
+		return;
+
+	meta = *start;
+	meta->syscall_nr = COMPAT_SYSCALL_NR;
+	syscalls_metadata[COMPAT_SYSCALL_NR] = meta;
+
+	compat_metadata = *start;
+}
+
+static bool is_compat_syscall(struct syscall_metadata *sys_data)
+{
+	return sys_data == compat_metadata;
+}
+
+static int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	if (unlikely(arch_trace_use_compat(regs)))
+		return COMPAT_SYSCALL_NR;
+
+	return syscall_get_nr(task, regs);
+}
+
+/*
+ * sys_compat_syscall
+ *
+ * This is a stub function that is never called by anything.
+ * It is used by the tracing system as a way to set up the
+ * syscall metadata for reporting ia32 compat system calls.
+ *
+ * Because ia32 compat system calls have different syscall
+ * numbers than the x86_64 counterpart, the tracing system
+ * reports the wrong data when they are traced. Instead of
+ * reporting incorrect data, the sys_compat_syscall is recorded
+ * instead. When this function is shown in the trace output,
+ * it will report the syscall_nr used, and 6 arguments passed
+ * to it, similar to the raw_syscall events.
+ *
+ * As this pseudo syscall function has 7 arguments, and
+ * real syscalls are only allowed to have 6, the macros
+ * for a 7 argument syscall are placed here instead of in
+ * syscalls.h.  This is to keep anyone from thinking that
+ * a real system call might have 7 arguments.
+ *
+ * The macros here create the metadata for the trace system.
+ */
+#define __SC_DECL7(t7, a7, ...) t7 a7, __SC_DECL6(__VA_ARGS__)
+#define __SC_STR_ADECL7(t, a, ...)	#a, __SC_STR_ADECL6(__VA_ARGS__)
+#define __SC_STR_TDECL7(t, a, ...)	#t, __SC_STR_TDECL6(__VA_ARGS__)
+#define SYSCALL_DEFINE7(name, ...) SYSCALL_DEFINEx(7, _##name, __VA_ARGS__)
+SYSCALL_DEFINE7(compat_syscall, int, NR, long, arg1, long, arg2,
+		long, arg3, long, arg4, long, arg5, long, arg6)
+{
+	return -ENOSYS;
+}
+#else
+static inline int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return syscall_get_nr(task, regs);
+}
+static inline bool is_compat_syscall(struct syscall_metadata *sys_data)
+{
+	return false;
+}
+#endif /* ARCH_TRACE_COMPAT_RAW */
+
 static __init struct syscall_metadata *
 find_syscall_meta(unsigned long syscall)
 {
@@ -71,7 +196,7 @@ find_syscall_meta(unsigned long syscall)
 
 static struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
-	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
+	if (!syscalls_metadata || nr >= NR_TRACE_SYSCALLS || nr < 0)
 		return NULL;
 
 	return syscalls_metadata[nr];
@@ -276,10 +401,10 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	int size;
 	int syscall_nr;
+	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_enter_syscalls))
@@ -298,7 +423,17 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 
 	entry = ring_buffer_event_data(event);
 	entry->nr = syscall_nr;
-	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
+
+	if (unlikely(is_compat_syscall(sys_data))) {
+		/*
+		 * For compat syscalls, it has 7 args. The first arg
+		 * is to store the original syscall_nr.
+		 */
+		entry->args[0] = syscall_get_nr(current, regs);
+		syscall_get_arguments(current, regs, 0,
+				      sys_data->nb_args - 1, entry->args + 1);
+	} else
+		syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
 					  entry, event))
@@ -313,7 +448,7 @@ static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	struct ring_buffer *buffer;
 	int syscall_nr;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
@@ -343,7 +478,7 @@ static int reg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
+	if (WARN_ON_ONCE(num < 0 || num >= NR_TRACE_SYSCALLS))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
@@ -361,7 +496,7 @@ static void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
+	if (WARN_ON_ONCE(num < 0 || num >= NR_TRACE_SYSCALLS))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
@@ -377,7 +512,7 @@ static int reg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
+	if (WARN_ON_ONCE(num < 0 || num >= NR_TRACE_SYSCALLS))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
@@ -395,7 +530,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
+	if (WARN_ON_ONCE(num < 0 || num >= NR_TRACE_SYSCALLS))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
@@ -411,7 +546,7 @@ static int init_syscall_trace(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls) {
+	if (num < 0 || num >= NR_TRACE_SYSCALLS) {
 		pr_debug("syscall %s metadata not mapped, disabling ftrace event\n",
 				((struct syscall_metadata *)call->data)->name);
 		return -ENOSYS;
@@ -465,7 +600,7 @@ static int __init init_ftrace_syscalls(void)
 	unsigned long addr;
 	int i;
 
-	syscalls_metadata = kcalloc(NR_syscalls, sizeof(*syscalls_metadata),
+	syscalls_metadata = kcalloc(NR_TRACE_SYSCALLS, sizeof(*syscalls_metadata),
 				    GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
@@ -482,14 +617,16 @@ static int __init init_ftrace_syscalls(void)
 		syscalls_metadata[i] = meta;
 	}
 
+	find_compat_meta();
+
 	return 0;
 }
 early_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_TRACE_SYSCALLS);
+static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_TRACE_SYSCALLS);
 static int sys_perf_refcount_enter;
 static int sys_perf_refcount_exit;
 
@@ -502,7 +639,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int rctx;
 	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
@@ -526,9 +663,21 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	if (!rec)
 		return;
 
+
 	rec->nr = syscall_nr;
-	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
-			       (unsigned long *)&rec->args);
+
+	if (unlikely(is_compat_syscall(sys_data))) {
+		unsigned long *args = (unsigned long *)&rec->args;
+		/*
+		 * For compat syscalls, it has 7 args. The first arg
+		 * is to store the original syscall_nr.
+		 */
+		args[0] = syscall_get_nr(current, regs);
+		syscall_get_arguments(current, regs, 0,
+				      sys_data->nb_args - 1, args + 1);
+	} else
+		syscall_get_arguments(current, regs, 0, sys_data->nb_args,
+				      (unsigned long *)&rec->args);
 
 	head = this_cpu_ptr(sys_data->enter_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
@@ -578,7 +727,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int rctx;
 	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))


