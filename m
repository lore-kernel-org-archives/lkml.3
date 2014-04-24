Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaDXXFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:05:46 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44333 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbaDXXEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:04:49 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 2/3] [RFC] timekeeping: Use cached ntp_tick_length when accumulating error
Date: Thu, 24 Apr 2014 16:04:36 -0700
Message-Id: <1398380677-8684-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By caching the ntp_tick_length() when we correct the frequency error,
and then using that cached value to accumulate error, we avoid large
initial errors when the tick length is changed.

This makes convergence happen much faster in the simulator, since the
initial error doesn't have to be slowly whittled away.

This initially seems like an accounting error, but Miroslav pointed out
that ntp_tick_length() can change mid-tick, so when we apply it in the
error accumulation, we are applying any recent change to the entire tick.

This approach chooses to apply changes in the ntp_tick_length() only to
the next tick, which allows us to calculate the freq correction before
using the new tick length, which avoids accummulating error.

Credit to Miroslav for pointing this out and providing the original patch
this functionality has been pulled out from, along with the rational.

Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Reported-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeper_internal.h | 7 +++++++
 kernel/time/timekeeping.c           | 4 +++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index c1825eb..83fd40f 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -34,6 +34,13 @@ struct timekeeper {
 	/* Clock shifted nano seconds */
 	u64			xtime_nsec;
 
+	/* The ntp_tick_length() value currently being used.
+	 * This cached copy ensures we consistently apply the tick
+	 * length for an entire tick, as ntp_tick_length may change
+	 * mid-tick, and we don't want to apply that new value to
+	 * the tick in progress.
+	 */
+	u64			ntp_tick;
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64			ntp_error;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 9aa8ccf..a130d00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -148,6 +148,7 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 	 * to counteract clock drifting.
 	 */
 	tk->mult = clock->mult;
+	tk->ntp_tick = ntpinterval << tk->ntp_error_shift;
 }
 
 /* Timekeeper helper functions. */
@@ -1138,6 +1139,7 @@ static __always_inline void timekeeping_freqadjust(struct timekeeper *tk,
 	bool negative;
 	u32 adj;
 
+	tk->ntp_tick = ntp_tick_length();
 	/* Calculate current error per tick */
 	tick_error = ntp_tick_length() >> tk->ntp_error_shift;
 	tick_error -= (tk->xtime_interval + tk->xtime_remainder);
@@ -1292,7 +1294,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	tk->ntp_error += ntp_tick_length() << shift;
+	tk->ntp_error += tk->ntp_tick << shift;
 	tk->ntp_error -= (tk->xtime_interval + tk->xtime_remainder) <<
 						(tk->ntp_error_shift + shift);
 
-- 
1.8.3.2

