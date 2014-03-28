Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaC1Ihp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:37:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaC1Ihg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:37:36 -0400
Date: Fri, 28 Mar 2014 01:37:14 -0700
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-cab5e127eef040399902caa8e1510795583fa03a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <1395963049-11923-1-git-send-email-john.stultz@linaro.org>
References: <1395963049-11923-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Revert to calling clock_was_set_delayed
 () while in irq context
Git-Commit-ID: cab5e127eef040399902caa8e1510795583fa03a
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

Commit-ID:  cab5e127eef040399902caa8e1510795583fa03a
Gitweb:     http://git.kernel.org/tip/cab5e127eef040399902caa8e1510795583fa03a
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Thu, 27 Mar 2014 16:30:49 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 28 Mar 2014 08:07:07 +0100

time: Revert to calling clock_was_set_delayed() while in irq context

In commit 47a1b796306356f35 ("tick/timekeeping: Call
update_wall_time outside the jiffies lock"), we moved to calling
clock_was_set() due to the fact that we were no longer holding
the timekeeping or jiffies lock.

However, there is still the problem that clock_was_set()
triggers an IPI, which cannot be done from the timer's hard irq
context, and will generate WARN_ON warnings.

Apparently in my earlier testing, I'm guessing I didn't bump the
dmesg log level, so I somehow missed the WARN_ONs.

Thus we need to revert back to calling clock_was_set_delayed().

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1395963049-11923-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
