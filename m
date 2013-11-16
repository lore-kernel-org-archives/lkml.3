Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3KPTBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 14:01:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab3KPTBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 14:01:07 -0500
Date: Sat, 16 Nov 2013 20:01:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "security@kernel.org" <security@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>,
        Petr Matousek <pmatouse@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Alex Kelly <alex.page.kelly@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 2/3] kill MMF_DUMPABLE and MMF_DUMP_SECURELY
Message-ID: <20131116190141.GC22666@redhat.com>
References: <20131101232521.GA23119@www.outflux.net> <20131114170337.GA11068@redhat.com> <CAGXu5jLXpLqjCAMFwKp7t7GpMq4+WBqNzSFC=up+CBvgGDuFCw@mail.gmail.com> <20131115203652.GA13476@redhat.com> <CAGXu5j+=LZYAczLVawGPAxd=9VX1FupWZq+2858GsrD1YprL3w@mail.gmail.com> <20131116190057.GA22666@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131116190057.GA22666@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody actually needs MMF_DUMPABLE/MMF_DUMP_SECURELY, there
are only used to enforce the encoding of SUID_DUMP_* enum in
mm->flags & MMF_DUMPABLE_MASK.

Now that set_dumpable() updates both bits atomically we can
kill them and simply store the value "as is" in 2 lower bits.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c             |   18 +++---------------
 include/linux/sched.h |    4 +---
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 613c9dc..5303005 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1620,8 +1620,7 @@ void set_binfmt(struct linux_binfmt *new)
 EXPORT_SYMBOL(set_binfmt);
 
 /*
- * set_dumpable converts traditional three-value dumpable to two flags and
- * stores them into mm->flags.
+ * set_dumpable stores three-value SUID_DUMP_* into mm->flags.
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
@@ -1629,24 +1628,13 @@ void set_dumpable(struct mm_struct *mm, int value)
 
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


