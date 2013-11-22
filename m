Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3KVTpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:45:06 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59056 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3KVTpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:45:02 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andy Lutomirski <luto@amacapital.net>, Paul Turner <pjt@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD
Date: Fri, 22 Nov 2013 11:44:51 -0800
Message-Id: <1385149491-20307-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Since commit 1e75fa8be9f (time: Condense timekeeper.xtime
into xtime_sec - merged in v3.6), there has been an problem
with the error accounting in the timekeeping code, such that
when truncating to nanoseconds, we round up to the next nsec,
but the balancing adjustment to the ntp_error value was dropped.

This causes 1ns per tick drift forward of the clock.

In 3.7, this logic was isolated to only GENERIC_TIME_VSYSCALL_OLD
architectures (s390, ia64, powerpc).

The fix is simply to balance the accounting and to subtract the
added nanosecond from ntp_error. This allows the internal long-term
clock steering to keep the clock accuate.

While this fix removes the regression added in 1e75fa8be9f, the
ideal solution is to move away from GENERIC_TIME_VSYSCALL_OLD
and use the new VSYSCALL method, which avoids entirely the
nanosecond granular rounding, and the resulting short-term clock
adjustment oscillation needed to keep long term accurate time.

Many thanks to Martin for his efforts identifying this subtle bug,
and providing the fix.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable <stable@vger.kernel.org>  #v3.6+
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3abf534..87b4f00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1347,7 +1347,7 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
 	tk->xtime_nsec -= remainder;
 	tk->xtime_nsec += 1ULL << tk->shift;
 	tk->ntp_error += remainder << tk->ntp_error_shift;
-
+	tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
 }
 #else
 #define old_vsyscall_fixup(tk)
-- 
1.8.3.2

