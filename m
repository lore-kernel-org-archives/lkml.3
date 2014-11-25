Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaKYGVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:21:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaKYGVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:21:50 -0500
Date: Mon, 24 Nov 2014 22:21:35 -0800
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-cb2aa63469f81426c7406227be70b628b42f7a05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, fengguang.wu@intel.com,
        pang.xunlei@linaro.org, mingo@kernel.org, tglx@linutronix.de,
        john.stultz@linaro.org
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pang.xunlei@linaro.org, fengguang.wu@intel.com, tglx@linutronix.de,
        john.stultz@linaro.org
In-Reply-To: <1416890145-30048-1-git-send-email-john.stultz@linaro.org>
References: <1416890145-30048-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Fix sign bug in NTP mult overflow warning
Git-Commit-ID: cb2aa63469f81426c7406227be70b628b42f7a05
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

Commit-ID:  cb2aa63469f81426c7406227be70b628b42f7a05
Gitweb:     http://git.kernel.org/tip/cb2aa63469f81426c7406227be70b628b42f7a05
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Mon, 24 Nov 2014 20:35:45 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 25 Nov 2014 07:18:34 +0100

time: Fix sign bug in NTP mult overflow warning

In commit 6067dc5a8c2b ("time: Avoid possible NTP adjustment
mult overflow") a new check was added to watch for adjustments
that could cause a mult overflow.

Unfortunately the check compares a signed with unsigned value
and ignored the case where the adjustment was negative, which
causes spurious warn-ons on some systems (and seems like it
would result in problematic time adjustments there as well, due
to the early return).

Thus this patch adds a check to make sure the adjustment is
positive before we check for an overflow, and resovles the issue
in my testing.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Debugged-by: pang.xunlei <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1416890145-30048-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
