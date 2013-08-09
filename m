Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030962Ab3HIT4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:56:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030899Ab3HIT4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:56:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/2] Revert "Revert "math64: New div64_u64_rem helper""
Date: Fri,  9 Aug 2013 15:56:03 -0400
Message-Id: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f3002134158092178be81339ec5a22ff80e6c308.

div64_u64_rem was removed because there were no other users.

But Device Mapper's I/O statistics support has a need for
div64_u64_rem; reintroduce this helper.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/math64.h |   19 ++++++++++++++++++-
 lib/div64.c            |   19 +++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index b8ba855..931a619 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -30,6 +30,15 @@ static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 }
 
 /**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor
+ */
+static inline u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
  * div64_u64 - unsigned 64bit divide with 64bit divisor
  */
 static inline u64 div64_u64(u64 dividend, u64 divisor)
@@ -61,8 +70,16 @@ static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
 #endif
 
+#ifndef div64_u64_rem
+extern u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder);
+#endif
+
 #ifndef div64_u64
-extern u64 div64_u64(u64 dividend, u64 divisor);
+static inline u64 div64_u64(u64 dividend, u64 divisor)
+{
+	u64 remainder;
+	return div64_u64_rem(dividend, divisor, &remainder);
+}
 #endif
 
 #ifndef div64_s64
diff --git a/lib/div64.c b/lib/div64.c
index a163b6c..3af5728 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -79,9 +79,10 @@ EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /**
- * div64_u64 - unsigned 64bit divide with 64bit divisor
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor and 64bit remainder
  * @dividend:	64bit dividend
  * @divisor:	64bit divisor
+ * @remainder:  64bit remainder
  *
  * This implementation is a modified version of the algorithm proposed
  * by the book 'Hacker's Delight'.  The original source and full proof
@@ -89,27 +90,33 @@ EXPORT_SYMBOL(div_s64_rem);
  *
  * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c.txt'
  */
-#ifndef div64_u64
-u64 div64_u64(u64 dividend, u64 divisor)
+#ifndef div64_u64_rem
+u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
 {
 	u32 high = divisor >> 32;
 	u64 quot;
 
 	if (high == 0) {
-		quot = div_u64(dividend, divisor);
+		u32 rem32;
+		quot = div_u64_rem(dividend, divisor, &rem32);
+		*remainder = rem32;
 	} else {
 		int n = 1 + fls(high);
 		quot = div_u64(dividend >> n, divisor >> n);
 
 		if (quot != 0)
 			quot--;
-		if ((dividend - quot * divisor) >= divisor)
+
+		*remainder = dividend - quot * divisor;
+		if (*remainder >= divisor) {
 			quot++;
+			*remainder -= divisor;
+		}
 	}
 
 	return quot;
 }
-EXPORT_SYMBOL(div64_u64);
+EXPORT_SYMBOL(div64_u64_rem);
 #endif
 
 /**
-- 
1.7.1

