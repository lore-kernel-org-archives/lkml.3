Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab3EQWXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:23:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab3EQVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Dave Hansen <dave@sr71.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        rostedt@goodmis.org
Subject: [ 020/102] sched: Avoid cputime scaling overflow
Date: Fri, 17 May 2013 14:35:35 -0700
Message-Id: <20130517213246.499823072@linuxfoundation.org>
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

commit 55eaa7c1f511af5fb6ef808b5328804f4d4e5243 upstream.

Here is patch, which adds Linus's cputime scaling algorithm to the
kernel.

This is a follow up (well, fix) to commit
d9a3c9823a2e6a543eb7807fb3d15d8233817ec5 ("sched: Lower chances
of cputime scaling overflow") which commit tried to avoid
multiplication overflow, but did not guarantee that the overflow
would not happen.

Linus crated a different algorithm, which completely avoids the
multiplication overflow by dropping precision when numbers are
big.

It was tested by me and it gives good relative error of
scaled numbers. Testing method is described here:
http://marc.info/?l=linux-kernel&m=136733059505406&w=2

Originally-From: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: Dave Hansen <dave@sr71.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130430151441.GC10465@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cputime.c |   57 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 22 deletions(-)

--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -522,34 +522,47 @@ EXPORT_SYMBOL_GPL(vtime_account_irq_ente
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
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
 


