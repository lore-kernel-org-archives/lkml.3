Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab3D3Jfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854Ab3D3JfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:35:09 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 1/4] sched: Avoid cputime scaling overflow
Date: Tue, 30 Apr 2013 11:35:04 +0200
Message-Id: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is patch, which add Linus cputime scaling algorithm to the kernel.

This is follow up of commit d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
"sched: Lower chances of cputime scaling overflow" which try to avoid
multiplication overflow, but not guarantee that the overflow will not
happen.

Linus crated different algorithm, which avoid completely multiplication
overflow by dropping precision when numbers are big. It was tested
by me and it gives good relative error of scaled numbers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sched/cputime.c | 57 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ea32f02..b3dd984 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -506,34 +506,47 @@ void account_idle_ticks(unsigned long ticks)
 }
 
 /*
- * Perform (stime * rtime) / total with reduced chances
- * of multiplication overflows by using smaller factors
- * like quotient and remainders of divisions between
- * rtime and total.
+ * Perform (stime * rtime) / total, but avoid multiplication overflow by
+ * loosing precision when the numbers are big.
  */
 static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
 {
-	u64 rem, res, scaled;
+	u64 scaled;
 
-	if (rtime >= total) {
-		/*
-		 * Scale up to rtime / total then add
-		 * the remainder scaled to stime / total.
-		 */
-		res = div64_u64_rem(rtime, total, &rem);
-		scaled = stime * res;
-		scaled += div64_u64(stime * rem, total);
-	} else {
-		/*
-		 * Same in reverse: scale down to total / rtime
-		 * then substract that result scaled to
-		 * to the remaining part.
-		 */
-		res = div64_u64_rem(total, rtime, &rem);
-		scaled = div64_u64(stime, res);
-		scaled -= div64_u64(scaled * rem, total);
+	for (;;) {
+		/* Make sure "rtime" is the bigger of stime/rtime */
+		if (stime > rtime) {
+			u64 tmp = rtime; rtime = stime; stime = tmp;
+		}
+
+		/* Make sure 'total' fits in 32 bits */
+		if (total >> 32)
+			goto drop_precision;
+
+		/* Does rtime (and thus stime) fit in 32 bits? */
+		if (!(rtime >> 32))
+			break;
+
+		/* Can we just balance rtime/stime rather than dropping bits? */
+		if (stime >> 31)
+			goto drop_precision;
+
+		/* We can grow stime and shrink rtime and try to make them both fit */
+		stime <<= 1;
+		rtime >>= 1;
+		continue;
+
+drop_precision:
+		/* We drop from rtime, it has more bits than stime */
+		rtime >>= 1;
+		total >>= 1;
 	}
 
+	/*
+	 * Make sure gcc understands that this is a 32x32->64 multiply,
+	 * followed by a 64/32->64 divide.
+	 */
+	scaled = div_u64((u64) (u32) stime * (u64) (u32) rtime, (u32)total);
 	return (__force cputime_t) scaled;
 }
 
-- 
1.7.11.7

