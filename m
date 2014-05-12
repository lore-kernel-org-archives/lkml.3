Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaELBmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:47 -0400
Received: from 1wt.eu ([62.212.114.60]:34610 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbaELBmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:43 -0400
Message-Id: <20140512003206.050590639@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 129/143] exec/ptrace: fix get_dumpable() incorrect tests
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit d049f74f2dbe71354d43d393ac3a188947811348 upstream

The get_dumpable() return value is not boolean.  Most users of the
function actually want to be testing for non-SUID_DUMP_USER(1) rather than
SUID_DUMP_DISABLE(0).  The SUID_DUMP_ROOT(2) is also considered a
protected state.  Almost all places did this correctly, excepting the two
places fixed in this patch.

Wrong logic:
    if (dumpable == SUID_DUMP_DISABLE) { /* be protective */ }
        or
    if (dumpable == 0) { /* be protective */ }
        or
    if (!dumpable) { /* be protective */ }

Correct logic:
    if (dumpable != SUID_DUMP_USER) { /* be protective */ }
        or
    if (dumpable != 1) { /* be protective */ }

Without this patch, if the system had set the sysctl fs/suid_dumpable=2, a
user was able to ptrace attach to processes that had dropped privileges to
that user.  (This may have been partially mitigated if Yama was enabled.)

The macros have been moved into the file that declares get/set_dumpable(),
which means things like the ia64 code can see them too.

CVE-2013-2929

Reported-by: Vasily Kulikov <segoon@openwall.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/ia64/include/asm/processor.h | 2 +-
 fs/exec.c                         | 6 ++++++
 include/linux/binfmts.h           | 3 ---
 include/linux/sched.h             | 4 ++++
 kernel/ptrace.c                   | 2 +-
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 3eaeedf..d77b342 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -361,7 +361,7 @@ struct thread_struct {
 	regs->loadrs = 0;									\
 	regs->r8 = get_dumpable(current->mm);	/* set "don't zap registers" flag */		\
 	regs->r12 = new_sp - 16;	/* allocate 16 byte scratch area */			\
-	if (unlikely(!get_dumpable(current->mm))) {							\
+	if (unlikely(get_dumpable(current->mm) != SUID_DUMP_USER)) {	\
 		/*										\
 		 * Zap scratch regs to avoid leaking bits between processes with different	\
 		 * uid/privileges.								\
diff --git a/fs/exec.c b/fs/exec.c
index feb2435..c32ae34 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1793,6 +1793,12 @@ void set_dumpable(struct mm_struct *mm, int value)
 	}
 }
 
+/*
+ * This returns the actual value of the suid_dumpable flag. For things
+ * that are using this for checking for privilege transitions, it must
+ * test against SUID_DUMP_USER rather than treating it as a boolean
+ * value.
+ */
 int get_dumpable(struct mm_struct *mm)
 {
 	int ret;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 9ffffec..8eab628 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -107,9 +107,6 @@ extern int flush_old_exec(struct linux_binprm * bprm);
 extern void setup_new_exec(struct linux_binprm * bprm);
 
 extern int suid_dumpable;
-#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
-#define SUID_DUMP_USER		1	/* Dump as user of process */
-#define SUID_DUMP_ROOT		2	/* Dump as root */
 
 /* Stack area protections */
 #define EXSTACK_DEFAULT   0	/* Whatever the arch defaults to */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 73c3b9b..56e1771 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -442,6 +442,10 @@ static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
+#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
+#define SUID_DUMP_USER		1	/* Dump as user of process */
+#define SUID_DUMP_ROOT		2	/* Dump as root */
+
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d9c8c47..4185220 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -187,7 +187,7 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable && !capable(CAP_SYS_PTRACE))
+	if (dumpable != SUID_DUMP_USER && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
 	return security_ptrace_access_check(task, mode);
-- 
1.7.12.2.21.g234cd45.dirty



