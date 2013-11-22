Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3KVUNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:13:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:13:32 -0500
Date: Fri, 22 Nov 2013 12:12:38 -0800
From: tip-bot for Martin Schwidefsky <tipbot@zytor.com>
Message-ID: <tip-4be77398ac9d948773116b6be4a3c91b3d6ea18c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, richardcochran@gmail.com, pjt@google.com,
        schwidefsky@de.ibm.com, tony.luck@intel.com, john.stultz@linaro.org,
        luto@amacapital.net, benh@kernel.crashing.org, rostedt@goodmis.org,
        fenghua.yu@intel.com, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com, pjt@google.com,
        richardcochran@gmail.com, tony.luck@intel.com, luto@amacapital.net,
        john.stultz@linaro.org, benh@kernel.crashing.org, rostedt@goodmis.org,
        fenghua.yu@intel.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1385149491-20307-1-git-send-email-john.stultz@linaro.org>
References: <1385149491-20307-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Fix 1ns/tick drift w/
  GENERIC_TIME_VSYSCALL_OLD
Git-Commit-ID: 4be77398ac9d948773116b6be4a3c91b3d6ea18c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 22 Nov 2013 12:12:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4be77398ac9d948773116b6be4a3c91b3d6ea18c
Gitweb:     http://git.kernel.org/tip/4be77398ac9d948773116b6be4a3c91b3d6ea18c
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 22 Nov 2013 11:44:51 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 22 Nov 2013 21:08:11 +0100

time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

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
clock steering to keep the clock accurate.

While this fix removes the regression added in 1e75fa8be9f, the
ideal solution is to move away from GENERIC_TIME_VSYSCALL_OLD
and use the new VSYSCALL method, which avoids entirely the
nanosecond granular rounding, and the resulting short-term clock
adjustment oscillation needed to keep long term accurate time.

[ jstultz: Many thanks to Martin for his efforts identifying this
  	   subtle bug, and providing the fix. ]

Originally-from: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Paul Turner <pjt@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable <stable@vger.kernel.org>  #v3.6+
Link: http://lkml.kernel.org/r/1385149491-20307-1-git-send-email-john.stultz@linaro.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
