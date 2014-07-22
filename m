Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaGVBtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:49:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53574 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaGVBtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:49:35 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com,
        Andy Lutomirski <luto@amacapital.net>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v3 1/8] seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing
Date: Mon, 21 Jul 2014 18:49:14 -0700
Message-Id: <4a3c579b031c42179f52e0f6de9b8c0ed4150aab.1405992946.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405992946.git.luto@amacapital.net>
References: <cover.1405992946.git.luto@amacapital.net>
In-Reply-To: <cover.1405992946.git.luto@amacapital.net>
References: <cover.1405992946.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The secure_computing function took a syscall number parameter, but
it only paid any attention to that parameter if seccomp mode 1 was
enabled.  Rather than coming up with a kludge to get the parameter
to work in mode 2, just remove the parameter.

To avoid churn in arches that don't have seccomp filters (and may
not even support syscall_get_nr right now), this leaves the
parameter in secure_computing_strict, which is now a real function.

For ARM, this is a bit ugly due to the fact that ARM conditionally
supports seccomp filters.  Fixing that would probably only be a
couple of lines of code, but it should be coordinated with the audit
maintainers.

This will be a slight slowdown on some arches.  The right fix is to
pass in all of seccomp_data instead of trying to make just the
syscall nr part be fast.

This is a prerequisite for making two-phase seccomp work cleanly.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: x86@kernel.org
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/arm/kernel/ptrace.c      |  7 ++++-
 arch/mips/kernel/ptrace.c     |  2 +-
 arch/s390/kernel/ptrace.c     |  2 +-
 arch/x86/kernel/ptrace.c      |  2 +-
 arch/x86/kernel/vsyscall_64.c |  2 +-
 include/linux/seccomp.h       | 21 +++++++-------
 kernel/seccomp.c              | 64 ++++++++++++++++++++++++++++++-------------
 7 files changed, 66 insertions(+), 34 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 0c27ed6..5e772a2 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -933,8 +933,13 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 	current_thread_info()->syscall = scno;
 
 	/* Do the secure computing check first; failures should be fast. */
-	if (secure_computing(scno) == -1)
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+	if (secure_computing() == -1)
 		return -1;
+#else
+	/* XXX: remove this once OABI gets fixed */
+	secure_computing_strict(scno);
+#endif
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index f639ccd..808bafc 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -639,7 +639,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall)
 	long ret = 0;
 	user_exit();
 
-	if (secure_computing(syscall) == -1)
+	if (secure_computing() == -1)
 		return -1;
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 2d716734..7ab8b91 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -795,7 +795,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	long ret = 0;
 
 	/* Do the secure computing check first. */
-	if (secure_computing(regs->gprs[2])) {
+	if (secure_computing()) {
 		/* seccomp failures shouldn't expose any additional code. */
 		ret = -1;
 		goto out;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 678c0ad..93c182a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1471,7 +1471,7 @@ long syscall_trace_enter(struct pt_regs *regs)
 		regs->flags |= X86_EFLAGS_TF;
 
 	/* do the secure computing check first */
-	if (secure_computing(regs->orig_ax)) {
+	if (secure_computing()) {
 		/* seccomp failures shouldn't expose any additional code. */
 		ret = -1L;
 		goto out;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ea5b570..23c0c23 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -216,7 +216,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	 */
 	regs->orig_ax = syscall_nr;
 	regs->ax = -ENOSYS;
-	tmp = secure_computing(syscall_nr);
+	tmp = secure_computing();
 	if ((!tmp && regs->orig_ax != syscall_nr) || regs->ip != address) {
 		warn_bad_vsyscall(KERN_DEBUG, regs,
 				  "seccomp tried to change syscall nr or ip");
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 5d586a4..aa3c040 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -27,19 +27,17 @@ struct seccomp {
 	struct seccomp_filter *filter;
 };
 
-extern int __secure_computing(int);
-static inline int secure_computing(int this_syscall)
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+extern int __secure_computing(void);
+static inline int secure_computing(void)
 {
 	if (unlikely(test_thread_flag(TIF_SECCOMP)))
-		return  __secure_computing(this_syscall);
+		return  __secure_computing();
 	return 0;
 }
-
-/* A wrapper for architectures supporting only SECCOMP_MODE_STRICT. */
-static inline void secure_computing_strict(int this_syscall)
-{
-	BUG_ON(secure_computing(this_syscall) != 0);
-}
+#else
+extern void secure_computing_strict(int this_syscall);
+#endif
 
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long, char __user *);
@@ -56,8 +54,11 @@ static inline int seccomp_mode(struct seccomp *s)
 struct seccomp { };
 struct seccomp_filter { };
 
-static inline int secure_computing(int this_syscall) { return 0; }
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+static inline int secure_computing(void) { return 0; }
+#else
 static inline void secure_computing_strict(int this_syscall) { return; }
+#endif
 
 static inline long prctl_get_seccomp(void)
 {
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 74f4601..861d7ee 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -23,8 +23,11 @@
 
 /* #define SECCOMP_DEBUG 1 */
 
-#ifdef CONFIG_SECCOMP_FILTER
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
+#endif
+
+#ifdef CONFIG_SECCOMP_FILTER
 #include <linux/filter.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
@@ -172,7 +175,7 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  *
  * Returns valid seccomp BPF response codes.
  */
-static u32 seccomp_run_filters(int syscall)
+static u32 seccomp_run_filters(void)
 {
 	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
 	struct seccomp_data sd;
@@ -564,10 +567,43 @@ static int mode1_syscalls_32[] = {
 };
 #endif
 
-int __secure_computing(int this_syscall)
+static void __secure_computing_strict(int this_syscall)
+{
+	int *syscall_whitelist = mode1_syscalls;
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		syscall_whitelist = mode1_syscalls_32;
+#endif
+	do {
+		if (*syscall_whitelist == this_syscall)
+			return;
+	} while (*++syscall_whitelist);
+
+#ifdef SECCOMP_DEBUG
+	dump_stack();
+#endif
+	audit_seccomp(this_syscall, SIGKILL, SECCOMP_RET_KILL);
+	do_exit(SIGKILL);
+}
+
+#ifndef CONFIG_HAVE_ARCH_SECCOMP_FILTER
+void secure_computing_strict(int this_syscall)
+{
+	int mode = current->seccomp.mode;
+
+	if (mode == 0)
+		return;
+	else if (mode == SECCOMP_MODE_STRICT)
+		__secure_computing_strict(this_syscall);
+	else
+		BUG();
+}
+#else
+int __secure_computing(void)
 {
+	struct pt_regs *regs = task_pt_regs(current);
+	int this_syscall = syscall_get_nr(current, regs);
 	int exit_sig = 0;
-	int *syscall;
 	u32 ret;
 
 	/*
@@ -578,23 +614,12 @@ int __secure_computing(int this_syscall)
 
 	switch (current->seccomp.mode) {
 	case SECCOMP_MODE_STRICT:
-		syscall = mode1_syscalls;
-#ifdef CONFIG_COMPAT
-		if (is_compat_task())
-			syscall = mode1_syscalls_32;
-#endif
-		do {
-			if (*syscall == this_syscall)
-				return 0;
-		} while (*++syscall);
-		exit_sig = SIGKILL;
-		ret = SECCOMP_RET_KILL;
-		break;
+		__secure_computing_strict(this_syscall);
+		return 0;
 #ifdef CONFIG_SECCOMP_FILTER
 	case SECCOMP_MODE_FILTER: {
 		int data;
-		struct pt_regs *regs = task_pt_regs(current);
-		ret = seccomp_run_filters(this_syscall);
+		ret = seccomp_run_filters();
 		data = ret & SECCOMP_RET_DATA;
 		ret &= SECCOMP_RET_ACTION;
 		switch (ret) {
@@ -652,9 +677,10 @@ int __secure_computing(int this_syscall)
 #ifdef CONFIG_SECCOMP_FILTER
 skip:
 	audit_seccomp(this_syscall, exit_sig, ret);
-#endif
 	return -1;
+#endif
 }
+#endif /* CONFIG_HAVE_ARCH_SECCOMP_FILTER */
 
 long prctl_get_seccomp(void)
 {
-- 
1.9.3

