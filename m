Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3LJICO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:02:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3LJICF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andy Lutomirski <luto@amacapital.net>, Paul Turner <pjt@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.12 39/62] time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD
Date: Tue, 10 Dec 2013 00:01:10 -0800
Message-Id: <20131210080100.182961820@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 4be77398ac9d948773116b6be4a3c91b3d6ea18c upstream.

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
Link: http://lkml.kernel.org/r/1385149491-20307-1-git-send-email-john.stultz@linaro.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1347,7 +1347,7 @@ static inline void old_vsyscall_fixup(st
 	tk->xtime_nsec -= remainder;
 	tk->xtime_nsec += 1ULL << tk->shift;
 	tk->ntp_error += remainder << tk->ntp_error_shift;
-
+	tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
 }
 #else
 #define old_vsyscall_fixup(tk)


