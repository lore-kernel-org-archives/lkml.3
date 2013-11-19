Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3KSOrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:47:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab3KSOmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:19 -0500
Date: Tue, 19 Nov 2013 15:43:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>, Petr Matousek <pmatouse@redhat.com>,
        Vasily Kulikov <segoon@openwall.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] make __get_dumpable/get_dumpable inline, kill
	fs/coredump.h
Message-ID: <20131119144321.GA28872@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119144300.GA28842@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Remove fs/coredump.h. It is not clear why do we need it,
   it only declares __get_dumpable(), signal.c includes it
   for no reason.

2. Now that get_dumpable() and __get_dumpable() are really
   trivial make them inline in linux/sched.h.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/coredump.c         |    1 -
 fs/coredump.h         |    6 ------
 fs/exec.c             |   18 ------------------
 include/linux/sched.h |   21 +++++++++++++++++----
 4 files changed, 17 insertions(+), 29 deletions(-)
 delete mode 100644 fs/coredump.h

diff --git a/fs/coredump.c b/fs/coredump.c
index 9bdeca1..4bc92c7 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -40,7 +40,6 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
-#include "coredump.h"
 
 #include <trace/events/sched.h>
 
diff --git a/fs/coredump.h b/fs/coredump.h
deleted file mode 100644
index e39ff07..0000000
--- a/fs/coredump.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _FS_COREDUMP_H
-#define _FS_COREDUMP_H
-
-extern int __get_dumpable(unsigned long mm_flags);
-
-#endif
diff --git a/fs/exec.c b/fs/exec.c
index 6ce1f86..1dee8ef 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -62,7 +62,6 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
-#include "coredump.h"
 
 #include <trace/events/sched.h>
 
@@ -1616,7 +1615,6 @@ void set_binfmt(struct linux_binfmt *new)
 	if (new)
 		__module_get(new->module);
 }
-
 EXPORT_SYMBOL(set_binfmt);
 
 /*
@@ -1635,22 +1633,6 @@ void set_dumpable(struct mm_struct *mm, int value)
 	} while (cmpxchg(&mm->flags, old, new) != old);
 }
 
-int __get_dumpable(unsigned long mm_flags)
-{
-	return mm_flags & MMF_DUMPABLE_MASK;
-}
-
-/*
- * This returns the actual value of the suid_dumpable flag. For things
- * that are using this for checking for privilege transitions, it must
- * test against SUID_DUMP_USER rather than treating it as a boolean
- * value.
- */
-int get_dumpable(struct mm_struct *mm)
-{
-	return __get_dumpable(mm->flags);
-}
-
 SYSCALL_DEFINE3(execve,
 		const char __user *, filename,
 		const char __user *const __user *, argv,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 828c00d..34c1903 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -317,10 +317,6 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 #endif
 
-
-extern void set_dumpable(struct mm_struct *mm, int value);
-extern int get_dumpable(struct mm_struct *mm);
-
 #define SUID_DUMP_DISABLE	0	/* No setuid dumping */
 #define SUID_DUMP_USER		1	/* Dump as user of process */
 #define SUID_DUMP_ROOT		2	/* Dump as root */
@@ -331,6 +327,23 @@ extern int get_dumpable(struct mm_struct *mm);
 #define MMF_DUMPABLE_BITS 2
 #define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
 
+extern void set_dumpable(struct mm_struct *mm, int value);
+/*
+ * This returns the actual value of the suid_dumpable flag. For things
+ * that are using this for checking for privilege transitions, it must
+ * test against SUID_DUMP_USER rather than treating it as a boolean
+ * value.
+ */
+static inline int __get_dumpable(unsigned long mm_flags)
+{
+	return mm_flags & MMF_DUMPABLE_MASK;
+}
+
+static inline int get_dumpable(struct mm_struct *mm)
+{
+	return __get_dumpable(mm->flags);
+}
+
 /* coredump filter bits */
 #define MMF_DUMP_ANON_PRIVATE	2
 #define MMF_DUMP_ANON_SHARED	3
-- 
1.5.5.1

