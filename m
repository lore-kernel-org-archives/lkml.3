Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098Ab3DKNqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:46:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59810
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200Ab3DKNqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:46:16 -0400
Message-ID: <1365687946.8824.3.camel@laptop>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling
 overflow
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Apr 2013 15:45:46 +0200
In-Reply-To: <20130326140147.GB2029@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	 <20130326140147.GB2029@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 15:01 +0100, Stanislaw Gruszka wrote:
> Thoughts?

Would something like the below work?

(warning: it's never even been near a compiler)

---
 kernel/sched/cputime.c | 78 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 699d597..465f6db 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -522,35 +522,67 @@ void account_idle_ticks(unsigned long ticks)
 }
 
 /*
- * Perform (stime * rtime) / total with reduced chances
- * of multiplication overflows by using smaller factors
- * like quotient and remainders of divisions between
- * rtime and total.
+ * Perform: (stime * rtime) / total
  */
 static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
 {
-	u64 rem, res, scaled;
+	int stime_fls = fls64(stime);
+	int total_fls = fls64(total);
+	int rtime_fls = fls64(rtime);
+	int shift, res_fls;
+	u32 rtime_hi = rtime >> 32, rtime_lo = rtime;
+	u64 hi, lo, t;
 
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
+	/*
+	 * Since the stime:utime ratio is already an approximation through
+	 * the sampling, reducing its resolution isn't too big a deal.
+	 * And since total = stime+utime; the total_fls will be the biggest
+	 * of the two;
+	 */
+	if (total_fls > 32) {
+		shift = total_fls - 32; /* a = 2^shift */
+		stime >>= shift;
+		total >>= shift;
+		stime_fls -= shift;
+		total_fls -= shift;
+	}
+
+	/*
+	 * Since we limited stime to 32bits the multiplication reduced to 96bit.
+	 *   stime * rtime = stime * (rl + rh * 2^32) = 
+	 *                   stime * rl + stime * rh * 2^32
+	 */
+	lo = stime * rtime_lo;
+	hi = stime * rtime_hi;
+	t = hi << 32;
+	lo += t;
+	if (lo < t) /* overflow */
+		hi += 0x100000000L;
+	hi >>= 32;
+	
+	/*
+	 * Pick the 64 most significant bits for division into @lo.
+	 * 
+	 * NOTE: res_fls is an approximation (upper-bound) do we want to
+	 *       properly calculate?
+	 */
+	shift = 0;
+	res_fls = stime_fls + rtime_fls;
+	if (res_fls > 64) {
+		shift = res_fls - 64; /* b = 2^shift */
+		lo >>= shift;
+		hi <<= 64 - shift;
+		lo |= hi;
 	}
 
-	return (__force cputime_t) scaled;
+	/*
+	 * So here we do:
+	 *
+	 *    ((stime / a) * rtime / b)
+	 *    --------------------------- / b
+	 *           (total / a)
+	 */
+	return div_u64(lo, total) >> shift;
 }
 
 /*


