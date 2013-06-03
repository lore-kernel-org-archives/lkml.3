Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab3FCWMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:12:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab3FCWLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:55 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qKcVc-vmK8sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=BfDxV18uEMUA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=bBmCkCVWAAAA:8 a=f3sFeNDE-ck_AaCaTmYA:9 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221153.655422077@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [09/65] math64: New div64_u64_rem helper
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0009-math64-New-div64_u64_rem-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

[ Upstream commit f792685006274a850e6cc0ea9ade275ccdfc90bc ]

Provide an extended version of div64_u64() that
also returns the remainder of the division.

We are going to need this to refine the cputime
scaling code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.7.10.4


