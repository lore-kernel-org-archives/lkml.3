Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaKUTsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:48:32 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34335 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaKUTog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:36 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 02/12] time: Avoid possible NTP adjustment mult overflow.
Date: Fri, 21 Nov 2014 11:44:08 -0800
Message-Id: <1416599058-13836-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "pang.xunlei" <pang.xunlei@linaro.org>

Ideally, __clocksource_updatefreq_scale, selects the largest shift
value possible for a clocksource. This results in the mult memember of
struct clocksource being particularly large, although not so large
that NTP would adjust the clock to cause it to overflow.

That said, nothing actually prohibits an overflow from occuring, its
just that it "shouldn't" occur.

So while very unlikely, and so far never observed, the value of
(cs->mult+cs->maxadj) may have a chance to reach very near 0xFFFFFFFF,
so there is a possibility it may overflow when doing NTP positive
adjustment

See the following detail: When NTP slewes the clock, kernel goes
through update_wall_time()->...->timekeeping_apply_adjustment():
	tk->tkr.mult += mult_adj;

Since there is no guard against it, its possible tk->tkr.mult may
overflow during this operation.

This patch avoids any possible mult overflow by judging the overflow
case before adding mult_adj to mult, also adds the WARNING message
when capturing such case.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
[jstultz: Reworded commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 6 ++++++
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
1.9.1

