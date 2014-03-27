Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaC0XbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:31:12 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57703 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbaC0XbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:31:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] time: Revert to calling clock_was_set_delayed() while in irq context
Date: Thu, 27 Mar 2014 16:30:49 -0700
Message-Id: <1395963049-11923-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

After testing a patch queued for 3.15, I noticed there was a WARNON
message that I realized was triggered by one of my patches that came
in the 3.14 merge window. I'm not very happy to find this now, but
sadly here it is. The fix is luckily fairly simple and just falls
back to previous behavior.

For tip/timers/urgent.

thanks
-john

In commit 47a1b796306356f35 (tick/timekeeping: Call update_wall_time
outside the jiffies lock), we moved to calling clock_was_set() due
to the fact that we were no longer holding the timekeeping or jiffies
lock.

However, there is still the problem that clock_was_set() triggers
an IPI, which cannot be done from the timer's hard irq context,
and will generate WARN_ON warnings.

Apparently in my earlier testing, I'm guessing I didn't bump the dmesg
log level, so I somehow missed the WARN_ONs.

Thus we need to revert back to calling clock_was_set_delayed().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..5b40279 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1435,7 +1435,8 @@ void update_wall_time(void)
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	if (clock_set)
-		clock_was_set();
+		/* Have to call _delayed version, since in irq context*/
+		clock_was_set_delayed();
 }
 
 /**
-- 
1.8.3.2

