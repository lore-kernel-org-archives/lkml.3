Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3L2CWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:22:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55524 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab3L2CLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:11 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Vasily Kulikov" <segoon@openwall.com>,
        "Kees Cook" <keescook@chromium.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.229307869@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 060/185] exec/ptrace: fix get_dumpable() incorrect tests
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit d049f74f2dbe71354d43d393ac3a188947811348 upstream.

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
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/include/asm/processor.h | 2 +-
 fs/exec.c                         | 6 ++++++
 include/linux/binfmts.h           | 3 ---
 include/linux/sched.h             | 4 ++++
 kernel/ptrace.c                   | 3 ++-
 5 files changed, 13 insertions(+), 5 deletions(-)

--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -320,7 +320,7 @@ struct thread_struct {
 	regs->loadrs = 0;									\
 	regs->r8 = get_dumpable(current->mm);	/* set "don't zap registers" flag */		\
 	regs->r12 = new_sp - 16;	/* allocate 16 byte scratch area */			\
-	if (unlikely(!get_dumpable(current->mm))) {							\
+	if (unlikely(get_dumpable(current->mm) != SUID_DUMP_USER)) {	\
 		/*										\
 		 * Zap scratch regs to avoid leaking bits between processes with different	\
 		 * uid/privileges.								\
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2032,6 +2032,12 @@ static int __get_dumpable(unsigned long
 	return (ret >= 2) ? 2 : ret;
 }
 
+/*
+ * This returns the actual value of the suid_dumpable flag. For things
+ * that are using this for checking for privilege transitions, it must
+ * test against SUID_DUMP_USER rather than treating it as a boolean
+ * value.
+ */
 int get_dumpable(struct mm_struct *mm)
 {
 	return __get_dumpable(mm->flags);
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -112,9 +112,6 @@ extern void setup_new_exec(struct linux_
 extern void would_dump(struct linux_binprm *, struct file *);
 
 extern int suid_dumpable;
-#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
-#define SUID_DUMP_USER		1	/* Dump as user of process */
-#define SUID_DUMP_ROOT		2	/* Dump as root */
 
 /* Stack area protections */
 #define EXSTACK_DEFAULT   0	/* Whatever the arch defaults to */
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -403,6 +403,10 @@ static inline void arch_pick_mmap_layout
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
+#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
+#define SUID_DUMP_USER		1	/* Dump as user of process */
+#define SUID_DUMP_ROOT		2	/* Dump as root */
+
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -246,7 +246,8 @@ ok:
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable && !task_ns_capable(task, CAP_SYS_PTRACE))
+	if (dumpable != SUID_DUMP_USER &&
+	    !task_ns_capable(task, CAP_SYS_PTRACE))
 		return -EPERM;
 
 	return security_ptrace_access_check(task, mode);

