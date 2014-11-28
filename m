Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaK1SYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:42 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48832 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaK1SYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:40 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 16/30] binfmt: Convert obsolete cputime type to nsecs
Date: Fri, 28 Nov 2014 19:23:46 +0100
Message-Id: <1417199040-21044-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/binfmt_elf.c        | 26 ++++++++++----------------
 fs/binfmt_elf_fdpic.c  | 16 ++++++++--------
 fs/compat_binfmt_elf.c | 20 +++++++++++---------
 3 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 646cfc3..4123f23 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1283,8 +1283,6 @@ static void fill_note(struct memelfnote *note, const char *name, int type,
 static void fill_prstatus(struct elf_prstatus *prstatus,
 		struct task_struct *p, long signr)
 {
-	struct timeval tv;
-
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
@@ -1295,29 +1293,25 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
-		struct task_cputime_t cputime;
+		struct task_cputime cputime;
 
 		/*
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime_t(p, &cputime);
-		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
-		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
+		thread_group_cputime(p, &cputime);
+		prstatus->pr_utime = ns_to_timeval(cputime.utime);
+		prstatus->pr_stime = ns_to_timeval(cputime.stime);
 	} else {
-		cputime_t utime, stime;
+		u64 utime, stime;
 
-		task_cputime_t(p, &utime, &stime);
-		cputime_to_timeval(utime, &prstatus->pr_utime);
-		cputime_to_timeval(stime, &prstatus->pr_stime);
+		task_cputime(p, &utime, &stime);
+		prstatus->pr_utime = ns_to_timeval(utime);
+		prstatus->pr_stime = ns_to_timeval(stime);
 	}
-	tv = ns_to_timeval(p->signal->cutime);
-	prstatus->pr_cutime.tv_sec = tv.tv_sec;
-	prstatus->pr_cutime.tv_usec = tv.tv_usec;
 
-	tv = ns_to_timeval(p->signal->cstime);
-	prstatus->pr_cstime.tv_sec = tv.tv_sec;
-	prstatus->pr_cstime.tv_usec = tv.tv_usec;
+	prstatus->pr_cutime = ns_to_timeval(p->signal->cutime);
+	prstatus->pr_cstime = ns_to_timeval(p->signal->cstime);
 }
 
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index fecdb6d..de4bb4c 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1336,21 +1336,21 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
-		struct task_cputime_t cputime;
+		struct task_cputime cputime;
 
 		/*
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime_t(p, &cputime);
-		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
-		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
+		thread_group_cputime(p, &cputime);
+		prstatus->pr_utime = ns_to_timeval(cputime.utime);
+		prstatus->pr_stime = ns_to_timeval(cputime.stime);
 	} else {
-		cputime_t utime, stime;
+		u64 utime, stime;
 
-		task_cputime_t(p, &utime, &stime);
-		cputime_to_timeval(utime, &prstatus->pr_utime);
-		cputime_to_timeval(stime, &prstatus->pr_stime);
+		task_cputime(p, &utime, &stime);
+		prstatus->pr_utime = ns_to_timeval(utime);
+		prstatus->pr_stime = ns_to_timeval(stime);
 	}
 	prstatus->pr_cutime = ns_to_timeval(p->signal->cutime);
 	prstatus->pr_cstime = ns_to_timeval(p->signal->cstime);
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 4d24d17..73fa05d 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -52,21 +52,23 @@
 #define elf_prpsinfo	compat_elf_prpsinfo
 
 /*
- * Compat version of cputime_to_compat_timeval, perhaps this
+ * Compat version of ns_to_timeval, perhaps this
  * should be an inline in <linux/compat.h>.
  */
-static void cputime_to_compat_timeval(const cputime_t cputime,
-				      struct compat_timeval *value)
+static struct compat_timeval ns_to_compat_timeval(const s64 nsec)
 {
 	struct timeval tv;
-	cputime_to_timeval(cputime, &tv);
-	value->tv_sec = tv.tv_sec;
-	value->tv_usec = tv.tv_usec;
+	struct compat_timeval ctv;
+
+	tv = ns_to_timeval(nsec);
+	ctv.tv_sec = tv.tv_sec;
+	ctv.tv_usec = tv.tv_usec;
+
+	return ctv;
 }
 
-#undef cputime_to_timeval
-#define cputime_to_timeval cputime_to_compat_timeval
-
+#undef ns_to_timeval
+#define ns_to_timeval ns_to_compat_timeval
 
 /*
  * To use this file, asm/elf.h must define compat_elf_check_arch.
-- 
2.1.3

