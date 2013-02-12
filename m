Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab3BLVTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:19:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab3BLVTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:19:00 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hqiEhKLnIewA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=8y2aSOAn6GUA:10 a=D19gQVrFAAAA:8 a=5IgVrKtEPMu0tqqnlLAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360703939.21867.99.camel@gandalf.local.home>
Subject: [RFC][PATCH v2] tracing/syscalls: Allow archs to ignore tracing
 compat syscalls
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 12 Feb 2013 16:18:59 -0500
In-Reply-To: <511A9DD9.7090805@linux.intel.com>
References: <1360692087.21867.42.camel@gandalf.local.home>
	  <511A85E8.7030303@linux.intel.com>
	 <1360694555.21867.69.camel@gandalf.local.home>
	 <511A9A64.3040108@linux.intel.com> <511A9DD9.7090805@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Peter, how about this patch. Instead of showing garbage, just never
  trace compat syscalls, if the arch needs to ignore it.

  However, users can still use the raw_syscall interface if they need to
  trace them.
]

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

But the real solution is to rewrite the syscall internals and come up
with a fixed solution. One that doesn't require all the kluge that the
current solution has.

Thus for now, instead of outputting incorrect data, simply ignore them.
With this patch the changes now have:

#> grep lls /debug/tracing/trace
#>

Compat system calls simply are not traced. If users need compat
syscalls, then they should just use the raw syscall tracepoints.

For an architecture to make their compat syscalls ignored, it must
define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS (done in asm/ftrace.h) and also
define an arch_trace_is_compat_syscall() function that will return true
if the current task should ignore tracing the syscall.

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
 arch/x86/include/asm/ftrace.h      |   24 ++++++++++++++++++
 arch/x86/include/asm/thread_info.h |    1 
 kernel/trace/trace_syscalls.c      |   49 +++++++++++++++++++++++++++++++++----
 3 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 86cb51e..84cf504 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -72,4 +72,28 @@ int ftrace_int3_handler(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
+
+#if !defined(__ASSEMBLY__) && !defined(COMPILE_OFFSETS)
+
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_IA32_EMULATION)
+#include <asm/compat.h>
+
+/*
+ * Because ia32 syscalls do not map to x86_64 syscall numbers
+ * this screws up the trace output when tracing a ia32 task.
+ * Instead of reporting bogus syscalls, just do not trace them.
+ *
+ * If the user realy wants these, then they should use the
+ * raw syscall tracepoints with filtering.
+ */
+#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
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
index 5329e13e..6965c41 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,5 +1,6 @@
 #include <trace/syscall.h>
 #include <trace/events/syscalls.h>
+#include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>	/* for MODULE_NAME_LEN via KSYM_SYMBOL_LEN */
@@ -10,6 +11,12 @@
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
@@ -47,6 +54,38 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 }
 #endif
 
+#ifdef ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
+/*
+ * Some architectures that allow for 32bit applications
+ * to run on a 64bit kernel, do not map the syscalls for
+ * the 32bit tasks the same as they do for 64bit tasks.
+ *
+ *     *cough*x86*cough*
+ *
+ * In such a case, instead of reporting the wrong syscalls,
+ * simply ignore them.
+ *
+ * For an arch to ignore the compat syscalls it needs to
+ * define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS as well as
+ * define the function arch_trace_is_compat_syscall() to let
+ * the tracing system know that it should ignore it.
+ */
+static int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	if (unlikely(arch_trace_is_compat_syscall(regs)))
+		return -1;
+
+	return syscall_get_nr(task, regs);
+}
+#else
+static inline int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return syscall_get_nr(task, regs);
+}
+#endif /* ARCH_TRACE_COMPAT_RAW */
+
 static __init struct syscall_metadata *
 find_syscall_meta(unsigned long syscall)
 {
@@ -276,10 +315,10 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
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
@@ -313,7 +352,7 @@ static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	struct ring_buffer *buffer;
 	int syscall_nr;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
@@ -502,7 +541,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int rctx;
 	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
@@ -578,7 +617,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int rctx;
 	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))


