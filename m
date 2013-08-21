Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3HUPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:09:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3HUPJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:09:26 -0400
Date: Wed, 21 Aug 2013 11:09:16 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH] math64: New separate div64_u64_rem helper
Message-ID: <20130821150916.GA11431@redhat.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
 <20130820070045.GA1665@redhat.com>
 <20130820080910.GA11072@gmail.com>
 <20130820192508.GA4799@redhat.com>
 <20130821072122.GA27360@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821072122.GA27360@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f792685006274a850e6cc0ea9ade275ccdfc90bc ("math64: New
div64_u64_rem helper") implemented div64_u64 in terms of div64_u64_rem.
But div64_u64_rem was removed because it slowed down div64_u64 (and
there were no other users of div64_u64_rem).

Device Mapper's I/O statistics support has a need for div64_u64_rem;
reintroduce this helper as a separate method that doesn't slow down
div64_u64, especially on 32-bit systems.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair Kergon <agk@redhat.com>
---
 include/linux/math64.h |   13 +++++++++++++
 lib/div64.c            |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 2913b86..69ed5f5 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -31,6 +31,15 @@ static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 }
 
 /**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
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
@@ -63,6 +72,10 @@ static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
 #endif
 
+#ifndef div64_u64_rem
+extern u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder);
+#endif
+
 #ifndef div64_u64
 extern u64 div64_u64(u64 dividend, u64 divisor);
 #endif
diff --git a/lib/div64.c b/lib/div64.c
index a163b6c..4382ad7 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -79,6 +79,46 @@ EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
+ * @dividend:	64bit dividend
+ * @divisor:	64bit divisor
+ * @remainder:  64bit remainder
+ *
+ * This implementation is a comparable to algorithm used by div64_u64.
+ * But this operation, which includes math for calculating the remainder,
+ * is kept distinct to avoid slowing down the div64_u64 operation on 32bit
+ * systems.
+ */
+#ifndef div64_u64_rem
+u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+{
+	u32 high = divisor >> 32;
+	u64 quot;
+
+	if (high == 0) {
+		u32 rem32;
+		quot = div_u64_rem(dividend, divisor, &rem32);
+		*remainder = rem32;
+	} else {
+		int n = 1 + fls(high);
+		quot = div_u64(dividend >> n, divisor >> n);
+
+		if (quot != 0)
+			quot--;
+
+		*remainder = dividend - quot * divisor;
+		if (*remainder >= divisor) {
+			quot++;
+			*remainder -= divisor;
+		}
+	}
+
+	return quot;
+}
+EXPORT_SYMBOL(div64_u64_rem);
+#endif
+
+/**
  * div64_u64 - unsigned 64bit divide with 64bit divisor
  * @dividend:	64bit dividend
  * @divisor:	64bit divisor
-- 
1.7.4.4

