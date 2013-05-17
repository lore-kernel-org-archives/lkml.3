Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab3EQWYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:24:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab3EQVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 018/102] math64: New div64_u64_rem helper
Date: Fri, 17 May 2013 14:35:33 -0700
Message-Id: <20130517213246.276777562@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit f792685006274a850e6cc0ea9ade275ccdfc90bc upstream.

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
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/math64.h |   19 ++++++++++++++++++-
 lib/div64.c            |   19 +++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -30,6 +30,15 @@ static inline s64 div_s64_rem(s64 divide
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
@@ -61,8 +70,16 @@ static inline u64 div_u64_rem(u64 divide
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


