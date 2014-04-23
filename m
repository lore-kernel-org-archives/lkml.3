Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbaDWT6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbaDWT6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:58:37 -0400
From: Eric Paris <eparis@redhat.com>
To: eparis@redhat.com
Cc: Richard Guy Briggs <rgb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH] audit: x86: drop arch from __audit_syscall_entry() interface
Date: Wed, 23 Apr 2014 15:58:24 -0400
Message-Id: <1398283104-29185-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

Since the arch is found locally in __audit_syscall_entry(), there is no need to
pass it in as a parameter.  Delete it from the parameter list.

x86* was the only arch to call __audit_syscall_entry() directly and did so from
assembly code.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com
Signed-off-by: Eric Paris <eparis@redhat.com>

---

As this patch relies on changes in the audit tree, I think it
appropriate to send it through my tree rather than the x86 tree.
---
 arch/x86/ia32/ia32entry.S  | 12 ++++++------
 arch/x86/kernel/entry_32.S | 11 +++++------
 arch/x86/kernel/entry_64.S | 11 +++++------
 include/linux/audit.h      |  5 ++---
 kernel/auditsc.c           |  6 ++----
 5 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb0..f5bdd28 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -186,12 +186,12 @@ sysexit_from_sys_call:
 
 #ifdef CONFIG_AUDITSYSCALL
 	.macro auditsys_entry_common
-	movl %esi,%r9d			/* 6th arg: 4th syscall arg */
-	movl %edx,%r8d			/* 5th arg: 3rd syscall arg */
-	/* (already in %ecx)		   4th arg: 2nd syscall arg */
-	movl %ebx,%edx			/* 3rd arg: 1st syscall arg */
-	movl %eax,%esi			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
+	movl %esi,%r8d			/* 5th arg: 4th syscall arg */
+	movl %ecx,%r9d			/*swap with edx*/
+	movl %edx,%ecx			/* 4th arg: 3rd syscall arg */
+	movl %r9d,%edx			/* 3rd arg: 2nd syscall arg */
+	movl %ebx,%esi			/* 2nd arg: 1st syscall arg */
+	movl %eax,%edi			/* 1st arg: syscall number */
 	call __audit_syscall_entry
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
 	cmpq $(IA32_NR_syscalls-1),%rax
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f46..078053e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -456,12 +456,11 @@ sysenter_audit:
 	jnz syscall_trace_entry
 	addl $4,%esp
 	CFI_ADJUST_CFA_OFFSET -4
-	/* %esi already in 8(%esp)	   6th arg: 4th syscall arg */
-	/* %edx already in 4(%esp)	   5th arg: 3rd syscall arg */
-	/* %ecx already in 0(%esp)	   4th arg: 2nd syscall arg */
-	movl %ebx,%ecx			/* 3rd arg: 1st syscall arg */
-	movl %eax,%edx			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
+	movl %esi,4(%esp)		/* 5th arg: 4th syscall arg */
+	movl %edx,(%esp)		/* 4th arg: 3rd syscall arg */
+	/* %ecx already in %ecx		   3rd arg: 2nd syscall arg */
+	movl %ebx,%edx			/* 2nd arg: 1st syscall arg */
+	/* %eax already in %eax		   1st arg: syscall number */
 	call __audit_syscall_entry
 	pushl_cfi %ebx
 	movl PT_EAX(%esp),%eax		/* reload syscall number */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..8292ff7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -694,12 +694,11 @@ badsys:
 	 * jump back to the normal fast path.
 	 */
 auditsys:
-	movq %r10,%r9			/* 6th arg: 4th syscall arg */
-	movq %rdx,%r8			/* 5th arg: 3rd syscall arg */
-	movq %rsi,%rcx			/* 4th arg: 2nd syscall arg */
-	movq %rdi,%rdx			/* 3rd arg: 1st syscall arg */
-	movq %rax,%rsi			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_X86_64,%edi	/* 1st arg: audit arch */
+	movq %r10,%r8			/* 5th arg: 4th syscall arg */
+	movq %rdx,%rcx			/* 4th arg: 3rd syscall arg */
+	movq %rsi,%rdx			/* 3rd arg: 2nd syscall arg */
+	movq %rdi,%rsi			/* 2nd arg: 1st syscall arg */
+	movq %rax,%rdi			/* 1st arg: syscall number */
 	call __audit_syscall_entry
 	LOAD_ARGS 0		/* reload call-clobbered registers */
 	jmp system_call_fastpath
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 783157b..1ae0089 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -115,8 +115,7 @@ extern void audit_log_session_info(struct audit_buffer *ab);
 				/* Public API */
 extern int  audit_alloc(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
-extern void __audit_syscall_entry(int arch,
-				  int major, unsigned long a0, unsigned long a1,
+extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
 extern struct filename *__audit_reusename(const __user char *uptr);
@@ -148,7 +147,7 @@ static inline void audit_syscall_entry(int major, unsigned long a0,
 				       unsigned long a3)
 {
 	if (unlikely(current->audit_context))
-		__audit_syscall_entry(syscall_get_arch(), major, a0, a1, a2, a3);
+		__audit_syscall_entry(major, a0, a1, a2, a3);
 }
 static inline void audit_syscall_exit(void *pt_regs)
 {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 62823a3..b12a712 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1497,7 +1497,6 @@ void __audit_free(struct task_struct *tsk)
 
 /**
  * audit_syscall_entry - fill in an audit record at syscall entry
- * @arch: architecture type
  * @major: major syscall type (function)
  * @a1: additional syscall register 1
  * @a2: additional syscall register 2
@@ -1512,9 +1511,8 @@ void __audit_free(struct task_struct *tsk)
  * will only be written if another part of the kernel requests that it
  * be written).
  */
-void __audit_syscall_entry(int arch, int major,
-			 unsigned long a1, unsigned long a2,
-			 unsigned long a3, unsigned long a4)
+void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
+			   unsigned long a3, unsigned long a4)
 {
 	struct task_struct *tsk = current;
 	struct audit_context *context = tsk->audit_context;
-- 
1.9.0

