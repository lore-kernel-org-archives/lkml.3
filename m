Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaKYEgC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 23:36:02 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55522 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaKYEgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 23:36:00 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] time: Fix sign bug in ntp mult overflow warning
Date: Mon, 24 Nov 2014 20:35:45 -0800
Message-Id: <1416890145-30048-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141122184506.GC29361@wfg-t540p.sh.intel.com>
References: <20141122184506.GC29361@wfg-t540p.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 6067dc5a8c2b ("time: Avoid possible NTP adjustment mult
overflow") a new check was added to watch for adjustments that could
cause a mult overflow.

Unfortunately the check compares a signed with unsigned value and
ignored the case where the adjustment was negative, which causes
spurious warn-ons on some systems (and seems like it would result in
problematic time adjustments there as well, due to the early
return).

Thus this patch adds a check to make sure the adjustment is positive
before we check for an overflow, and resovles the issue in my
testing.

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Debugged-by: pang.xunlei <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 29a7d67..2dc0646 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1330,7 +1330,7 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
-	if (tk->tkr.mult + mult_adj < mult_adj) {
+	if ((mult_adj > 0) && (tk->tkr.mult + mult_adj < mult_adj)) {
 		/* NTP adjustment caused clocksource mult overflow */
 		WARN_ON_ONCE(1);
 		return;
-- 
1.9.1

