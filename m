Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaJIHKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:10:20 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:64311 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIHKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:10:13 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH 1/2] time: Fix NTP adjustment mult overflow.
Date: Thu,  9 Oct 2014 15:04:30 +0800
Message-Id: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mult memember of struct clocksource should always be a large u32 number when calculated through
__clocksource_updatefreq_scale(). The value of (cs->mult+cs->maxadj) may have a chance to reach very
near 0xFFFFFFFF. For instance, 555MHz oscillator: cs->mult is 0xE6A17102, cs->maxadj is 0x195E8EFD,
cs->mult+cs->maxadj is 0xFFFFFFFF. Such oscillators would probably exist on some processors like
MIPS which use CP0 compare/count CPU clock as the clock source.

Clocksource might encounter large frequency adjustment due to the hardware unstability, environment
temperature, software deviation, NTP algorithm accuracy, etc. When NTP slewes the clock, kernel goes
through update_wall_time()->...->timekeeping_apply_adjustment(): tk->tkr.mult += mult_adj;
Unfortunately, tk->tkr.mult may overflow after this operation, though such cases are next to impossible
to happen in practice.

This patch avoids mult overflow by judging the overflow case before adding mult_adj to mult, also adds the
WARNING message when capturing such case.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/time/timekeeping.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..cad61b3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1332,6 +1332,12 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
+	if (tk->tkr.mult + mult_adj < mult_adj) {
+		/* NTP adjustment caused clocksource mult overflow */
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	tk->tkr.mult += mult_adj;
 	tk->xtime_interval += interval;
 	tk->tkr.xtime_nsec -= offset;
-- 
1.7.10.4

