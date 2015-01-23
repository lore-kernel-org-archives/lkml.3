Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbbAWAJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:09:37 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48376 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbbAWAJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:33 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/12] clocksource: Simplify clocks_calc_max_nsecs logic
Date: Thu, 22 Jan 2015 16:09:16 -0800
Message-Id: <1421971767-17707-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous clocks_calc_max_nsecs had some unecessarily
complex bit logic to find the max interval that could cause
multiplication overflows. Since this is not in the hot
path, just do the divide to make it easier to read.

The previous implementation also had a subtle issue
that it avoided overflows into signed 64bit values, where
as the intervals are always unsigned. This resulted in
overly conservative intervals, which other saftey margins
were then added to, reducing the intended interval length.

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
 kernel/time/clocksource.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index b79f39b..c14cd03 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -552,19 +552,10 @@ u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
 
 	/*
 	 * Calculate the maximum number of cycles that we can pass to the
-	 * cyc2ns function without overflowing a 64-bit signed result. The
-	 * maximum number of cycles is equal to ULLONG_MAX/(mult+maxadj)
-	 * which is equivalent to the below.
-	 * max_cycles < (2^63)/(mult + maxadj)
-	 * max_cycles < 2^(log2((2^63)/(mult + maxadj)))
-	 * max_cycles < 2^(log2(2^63) - log2(mult + maxadj))
-	 * max_cycles < 2^(63 - log2(mult + maxadj))
-	 * max_cycles < 1 << (63 - log2(mult + maxadj))
-	 * Please note that we add 1 to the result of the log2 to account for
-	 * any rounding errors, ensure the above inequality is satisfied and
-	 * no overflow will occur.
+	 * cyc2ns function without overflowing a 64-bit result.
 	 */
-	max_cycles = 1ULL << (63 - (ilog2(mult + maxadj) + 1));
+	max_cycles = ULLONG_MAX;
+	do_div(max_cycles, mult+maxadj);
 
 	/*
 	 * The actual maximum number of cycles we can defer the clocksource is
-- 
1.9.1

