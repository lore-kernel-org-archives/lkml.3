Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3EAKH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:07:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3EAKHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:07:50 -0400
Date: Wed, 1 May 2013 03:07:14 -0700
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-f3002134158092178be81339ec5a22ff80e6c308@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, dave@sr71.net,
        fweisbec@gmail.com, tglx@linutronix.de, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, dave@sr71.net,
        fweisbec@gmail.com, tglx@linutronix.de, sgruszka@redhat.com
In-Reply-To: <1367314507-9728-4-git-send-email-sgruszka@redhat.com>
References: <1367314507-9728-4-git-send-email-sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] Revert "math64: New div64_u64_rem helper"
Git-Commit-ID: f3002134158092178be81339ec5a22ff80e6c308
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3002134158092178be81339ec5a22ff80e6c308
Gitweb:     http://git.kernel.org/tip/f3002134158092178be81339ec5a22ff80e6c308
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 30 Apr 2013 11:35:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 19:13:05 +0200

Revert "math64: New div64_u64_rem helper"

This reverts commit f792685006274a850e6cc0ea9ade275ccdfc90bc.

The cputime scaling code was changed/fixed and does not need the
div64_u64_rem() primitive anymore. It has no other users, so let's
remove them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1367314507-9728-4-git-send-email-sgruszka@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/math64.h | 19 +------------------
 lib/div64.c            | 19 ++++++-------------
 2 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 931a619..b8ba855 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -30,15 +30,6 @@ static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 }
 
 /**
- * div64_u64_rem - unsigned 64bit divide with 64bit divisor
- */
-static inline u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
-/**
  * div64_u64 - unsigned 64bit divide with 64bit divisor
  */
 static inline u64 div64_u64(u64 dividend, u64 divisor)
@@ -70,16 +61,8 @@ static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
 #endif
 
-#ifndef div64_u64_rem
-extern u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder);
-#endif
-
 #ifndef div64_u64
-static inline u64 div64_u64(u64 dividend, u64 divisor)
-{
-	u64 remainder;
-	return div64_u64_rem(dividend, divisor, &remainder);
-}
+extern u64 div64_u64(u64 dividend, u64 divisor);
 #endif
 
 #ifndef div64_s64
diff --git a/lib/div64.c b/lib/div64.c
index 3af5728..a163b6c 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -79,10 +79,9 @@ EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /**
- * div64_u64_rem - unsigned 64bit divide with 64bit divisor and 64bit remainder
+ * div64_u64 - unsigned 64bit divide with 64bit divisor
  * @dividend:	64bit dividend
  * @divisor:	64bit divisor
- * @remainder:  64bit remainder
  *
  * This implementation is a modified version of the algorithm proposed
  * by the book 'Hacker's Delight'.  The original source and full proof
@@ -90,33 +89,27 @@ EXPORT_SYMBOL(div_s64_rem);
  *
  * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c.txt'
  */
-#ifndef div64_u64_rem
-u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+#ifndef div64_u64
+u64 div64_u64(u64 dividend, u64 divisor)
 {
 	u32 high = divisor >> 32;
 	u64 quot;
 
 	if (high == 0) {
-		u32 rem32;
-		quot = div_u64_rem(dividend, divisor, &rem32);
-		*remainder = rem32;
+		quot = div_u64(dividend, divisor);
 	} else {
 		int n = 1 + fls(high);
 		quot = div_u64(dividend >> n, divisor >> n);
 
 		if (quot != 0)
 			quot--;
-
-		*remainder = dividend - quot * divisor;
-		if (*remainder >= divisor) {
+		if ((dividend - quot * divisor) >= divisor)
 			quot++;
-			*remainder -= divisor;
-		}
 	}
 
 	return quot;
 }
-EXPORT_SYMBOL(div64_u64_rem);
+EXPORT_SYMBOL(div64_u64);
 #endif
 
 /**
