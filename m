Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab3LFXRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:17:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762Ab3LFXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:17:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Doug Ledford <dledford@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 107/152] coredump: remove redundant defines for dumpable states
Date: Fri,  6 Dec 2013 15:10:31 -0800
Message-Id: <1386371476-2477-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit e579d2c259be42b6f29458327e5153b22414b031 upstream.

The existing SUID_DUMP_* defines duplicate the newer SUID_DUMPABLE_*
defines introduced in 54b501992dd2 ("coredump: warn about unsafe
suid_dumpable / core_pattern combo").  Remove the new ones, and use the
prior values instead.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Chen Gang <gang.chen@asianux.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8 stable prereq for
  d049f74 exec/ptrace: fix get_dumpable() incorrect tests ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/coredump.c         |  2 +-
 fs/exec.c             | 10 +++++-----
 fs/proc/internal.h    |  3 ++-
 include/linux/sched.h |  5 -----
 kernel/sysctl.c       |  2 +-
 5 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1774932..57b9bd6 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -501,7 +501,7 @@ void do_coredump(siginfo_t *siginfo)
 	 * so we dump it as root in mode 2, and only into a controlled
 	 * environment (pipe handler or fully qualified path).
 	 */
-	if (__get_dumpable(cprm.mm_flags) == SUID_DUMPABLE_SAFE) {
+	if (__get_dumpable(cprm.mm_flags) == SUID_DUMP_ROOT) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
diff --git a/fs/exec.c b/fs/exec.c
index 0b5038a..40418c9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1114,7 +1114,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
-		set_dumpable(current->mm, SUID_DUMPABLE_ENABLED);
+		set_dumpable(current->mm, SUID_DUMP_USER);
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
@@ -1644,17 +1644,17 @@ EXPORT_SYMBOL(set_binfmt);
 void set_dumpable(struct mm_struct *mm, int value)
 {
 	switch (value) {
-	case SUID_DUMPABLE_DISABLED:
+	case SUID_DUMP_DISABLE:
 		clear_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case SUID_DUMPABLE_ENABLED:
+	case SUID_DUMP_USER:
 		set_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case SUID_DUMPABLE_SAFE:
+	case SUID_DUMP_ROOT:
 		set_bit(MMF_DUMP_SECURELY, &mm->flags);
 		smp_wmb();
 		set_bit(MMF_DUMPABLE, &mm->flags);
@@ -1667,7 +1667,7 @@ int __get_dumpable(unsigned long mm_flags)
 	int ret;
 
 	ret = mm_flags & MMF_DUMPABLE_MASK;
-	return (ret > SUID_DUMPABLE_ENABLED) ? SUID_DUMPABLE_SAFE : ret;
+	return (ret > SUID_DUMP_USER) ? SUID_DUMP_ROOT : ret;
 }
 
 int get_dumpable(struct mm_struct *mm)
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 252544c..85ff3a4 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -11,6 +11,7 @@
 
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
+#include <linux/binfmts.h>
 struct  ctl_table_header;
 struct  mempolicy;
 
@@ -108,7 +109,7 @@ static inline int task_dumpable(struct task_struct *task)
 	if (mm)
 		dumpable = get_dumpable(mm);
 	task_unlock(task);
-	if (dumpable == SUID_DUMPABLE_ENABLED)
+	if (dumpable == SUID_DUMP_USER)
 		return 1;
 	return 0;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index caa76ae..6019ecc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -378,11 +378,6 @@ static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
-/* get/set_dumpable() values */
-#define SUID_DUMPABLE_DISABLED	0
-#define SUID_DUMPABLE_ENABLED	1
-#define SUID_DUMPABLE_SAFE	2
-
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..585015f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2083,7 +2083,7 @@ int proc_dointvec_minmax(struct ctl_table *table, int write,
 static void validate_coredump_safety(void)
 {
 #ifdef CONFIG_COREDUMP
-	if (suid_dumpable == SUID_DUMPABLE_SAFE &&
+	if (suid_dumpable == SUID_DUMP_ROOT &&
 	    core_pattern[0] != '/' && core_pattern[0] != '|') {
 		printk(KERN_WARNING "Unsafe core_pattern used with "\
 			"suid_dumpable=2. Pipe handler or fully qualified "\
-- 
1.8.3.2

