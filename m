Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3KSOmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KSOmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:12 -0500
Date: Tue, 19 Nov 2013 15:43:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>, Petr Matousek <pmatouse@redhat.com>,
        Vasily Kulikov <segoon@openwall.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] set_dumpable: fix the theoretical race with itself
Message-ID: <20131119144315.GA28862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119144300.GA28842@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_dumpable() updates MMF_DUMPABLE_MASK in a non-trivial way to
ensure that get_dumpable() can't observe the intermediate state,
but this all can't help if multiple threads call set_dumpable()
at the same time.

And in theory commit_creds()->set_dumpable(SUID_DUMP_ROOT) racing
with sys_prctl()->set_dumpable(SUID_DUMP_DISABLE) can result in
SUID_DUMP_USER.

Change this code to update both bits atomically via cmpxchg().

Note: this assumes that it is safe to mix bitops and cmpxchg. IOW,
if, say, an architecture implements cmpxchg() using the locking
(like arch/parisc/lib/bitops.c does), then it should use the same
locks for set_bit/etc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/exec.c |   49 +++++++++++++++----------------------------------
 1 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index bb8afc1..613c9dc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1621,43 +1621,24 @@ EXPORT_SYMBOL(set_binfmt);
 
 /*
  * set_dumpable converts traditional three-value dumpable to two flags and
- * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
- * these bits are not changed atomically.  So get_dumpable can observe the
- * intermediate state.  To avoid doing unexpected behavior, get get_dumpable
- * return either old dumpable or new one by paying attention to the order of
- * modifying the bits.
- *
- * dumpable |   mm->flags (binary)
- * old  new | initial interim  final
- * ---------+-----------------------
- *  0    1  |   00      01      01
- *  0    2  |   00      10(*)   11
- *  1    0  |   01      00      00
- *  1    2  |   01      11      11
- *  2    0  |   11      10(*)   00
- *  2    1  |   11      11      01
- *
- * (*) get_dumpable regards interim value of 10 as 11.
+ * stores them into mm->flags.
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
-	switch (value) {
-	case SUID_DUMP_DISABLE:
-		clear_bit(MMF_DUMPABLE, &mm->flags);
-		smp_wmb();
-		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
-		break;
-	case SUID_DUMP_USER:
-		set_bit(MMF_DUMPABLE, &mm->flags);
-		smp_wmb();
-		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
-		break;
-	case SUID_DUMP_ROOT:
-		set_bit(MMF_DUMP_SECURELY, &mm->flags);
-		smp_wmb();
-		set_bit(MMF_DUMPABLE, &mm->flags);
-		break;
-	}
+	unsigned long old, new;
+
+	do {
+		old = ACCESS_ONCE(mm->flags);
+		new = old & ~MMF_DUMPABLE_MASK;
+
+		switch (value) {
+		case SUID_DUMP_ROOT:
+			new |= (1 << MMF_DUMP_SECURELY);
+		case SUID_DUMP_USER:
+			new |= (1<< MMF_DUMPABLE);
+		}
+
+	} while (cmpxchg(&mm->flags, old, new) != old);
 }
 
 int __get_dumpable(unsigned long mm_flags)
-- 
1.5.5.1

