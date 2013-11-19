Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3KSOmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KSOmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:16 -0500
Date: Tue, 19 Nov 2013 15:43:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>, Petr Matousek <pmatouse@redhat.com>,
        Vasily Kulikov <segoon@openwall.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] kill MMF_DUMPABLE and MMF_DUMP_SECURELY
Message-ID: <20131119144318.GA28865@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119144300.GA28842@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody actually needs MMF_DUMPABLE/MMF_DUMP_SECURELY, they
are only used to enforce the encoding of SUID_DUMP_* enum
in mm->flags & MMF_DUMPABLE_MASK.

Now that set_dumpable() updates both bits atomically we can
kill them and simply store the value "as is" in 2 lower bits.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/exec.c             |   21 ++++++---------------
 include/linux/sched.h |    4 +---
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 613c9dc..6ce1f86 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1620,33 +1620,24 @@ void set_binfmt(struct linux_binfmt *new)
 EXPORT_SYMBOL(set_binfmt);
 
 /*
- * set_dumpable converts traditional three-value dumpable to two flags and
- * stores them into mm->flags.
+ * set_dumpable stores three-value SUID_DUMP_* into mm->flags.
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
 	unsigned long old, new;
 
+	if (WARN_ON((unsigned)value > SUID_DUMP_ROOT))
+		return;
+
 	do {
 		old = ACCESS_ONCE(mm->flags);
-		new = old & ~MMF_DUMPABLE_MASK;
-
-		switch (value) {
-		case SUID_DUMP_ROOT:
-			new |= (1 << MMF_DUMP_SECURELY);
-		case SUID_DUMP_USER:
-			new |= (1<< MMF_DUMPABLE);
-		}
-
+		new = (old & ~MMF_DUMPABLE_MASK) | value;
 	} while (cmpxchg(&mm->flags, old, new) != old);
 }
 
 int __get_dumpable(unsigned long mm_flags)
 {
-	int ret;
-
-	ret = mm_flags & MMF_DUMPABLE_MASK;
-	return (ret > SUID_DUMP_USER) ? SUID_DUMP_ROOT : ret;
+	return mm_flags & MMF_DUMPABLE_MASK;
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 838a3d9..828c00d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -326,10 +326,8 @@ extern int get_dumpable(struct mm_struct *mm);
 #define SUID_DUMP_ROOT		2	/* Dump as root */
 
 /* mm flags */
-/* dumpable bits */
-#define MMF_DUMPABLE      0  /* core dump is permitted */
-#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
 
+/* for SUID_DUMP_* above */
 #define MMF_DUMPABLE_BITS 2
 #define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
 
-- 
1.5.5.1

