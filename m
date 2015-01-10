Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbbAJAf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:35:58 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62114 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbbAJAen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:34:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 07/10] time: Try to catch clocksource delta underflows
Date: Fri,  9 Jan 2015 16:34:25 -0800
Message-Id: <1420850068-27828-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case where there is a broken clocksource
where there are multiple actual clocks that
aren't perfectly aligned, we may see small "negative"
deltas when we subtract now from cycle_last.

The values are actually negative with respect to the
clocksource mask value, not necessarily negative
if cast to a s64, but we can check by checking the
delta see if it is a small (relative to the mask)
negative value (again negative relative to the mask).

If so, we assume we jumped backwards somehow and
instead use zero for our delta.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 9740fd8..4acfc7f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -224,6 +224,13 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	/* calculate the delta since the last update_wall_time: */
 	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
 
+	/*
+	 * Try to catch underflows by checking if we are seeing small
+	 * mask-relative negative values.
+	 */
+	if (((~delta+1) & tk->tkr.mask) < (tk->tkr.mask >> 3))
+		delta = 0;
+
 	/* Cap delta value to the max_cycles values to avoid mult overflows */
 	delta = min(delta, tk->tkr.clock->max_cycles);
 
-- 
1.9.1

