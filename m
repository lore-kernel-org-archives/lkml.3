Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab3EAKFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:05:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3EAKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:05:07 -0400
Date: Wed, 1 May 2013 03:03:36 -0700
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-55eaa7c1f511af5fb6ef808b5328804f4d4e5243@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dave@sr71.net, fweisbec@gmail.com,
        tglx@linutronix.de, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, dave@sr71.net, fweisbec@gmail.com,
        tglx@linutronix.de, sgruszka@redhat.com
In-Reply-To: <20130430151441.GC10465@redhat.com>
References: <20130430151441.GC10465@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Avoid cputime scaling overflow
Git-Commit-ID: 55eaa7c1f511af5fb6ef808b5328804f4d4e5243
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

Commit-ID:  55eaa7c1f511af5fb6ef808b5328804f4d4e5243
Gitweb:     http://git.kernel.org/tip/55eaa7c1f511af5fb6ef808b5328804f4d4e5243
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 30 Apr 2013 17:14:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 19:13:04 +0200

sched: Avoid cputime scaling overflow

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
---
 kernel/sched/cputime.c | 57 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 33508dc..e9198ab 100644
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
 
