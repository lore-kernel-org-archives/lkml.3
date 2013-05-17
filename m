Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3EQVh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab3EQVhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@sr71.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, rostedt@goodmis.org
Subject: [ 022/102] Revert "math64: New div64_u64_rem helper"
Date: Fri, 17 May 2013 14:35:37 -0700
Message-Id: <20130517213246.719151234@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit f3002134158092178be81339ec5a22ff80e6c308 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/math64.h |   19 +------------------
 lib/div64.c            |   19 ++++++-------------
 2 files changed, 7 insertions(+), 31 deletions(-)

--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -30,15 +30,6 @@ static inline s64 div_s64_rem(s64 divide
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
@@ -70,16 +61,8 @@ static inline u64 div_u64_rem(u64 divide
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


