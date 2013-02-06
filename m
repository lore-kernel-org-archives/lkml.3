Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3BFTo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:44:27 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46057 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab3BFToX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:44:23 -0500
Date: Wed, 6 Feb 2013 11:44:05 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Chen Gang <gang.chen@asianux.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Doug Ledford <dledford@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] remove redundant defines for dumpable states
Message-ID: <20130206194405.GA739@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing SUID_DUMP_* defines duplicate the newer SUID_DUMPABLE_*
defines introduced in 54b501992dd2a839e94e76aa392c392b55080ce8. Remove
the new ones, and use the prior values instead.

Reported-by: Chen Gang <gang.chen@asianux.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/coredump.c         |    2 +-
 fs/exec.c             |   10 +++++-----
 fs/proc/internal.h    |    3 ++-
 include/linux/sched.h |    5 -----
 kernel/sysctl.c       |    2 +-
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
index 20df02c..58841fe 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1111,7 +1111,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
-		set_dumpable(current->mm, SUID_DUMPABLE_ENABLED);
+		set_dumpable(current->mm, SUID_DUMP_USER);
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
@@ -1639,17 +1639,17 @@ EXPORT_SYMBOL(set_binfmt);
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
@@ -1662,7 +1662,7 @@ int __get_dumpable(unsigned long mm_flags)
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
index d211247..03ffbdb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -376,11 +376,6 @@ static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
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
1.7.9.5


-- 
Kees Cook
Chrome OS Security
