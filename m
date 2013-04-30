Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab3D3JfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759919Ab3D3JfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:35:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 4/4] Revert "math64: New div64_u64_rem helper"
Date: Tue, 30 Apr 2013 11:35:07 +0200
Message-Id: <1367314507-9728-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
References: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f792685006274a850e6cc0ea9ade275ccdfc90bc.

Scaling cputime code was changed and does not need div64_u64_rem
primitives. They seems to have no other users, so let's remove them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
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
-- 
1.7.11.7

