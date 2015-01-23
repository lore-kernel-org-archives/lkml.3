Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbbAWAJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:09:42 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40305 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbbAWAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:37 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 03/12] clocksource: Remove clocksource_max_deferment()
Date: Thu, 22 Jan 2015 16:09:18 -0800
Message-Id: <1421971767-17707-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource_max_deferment() doesn't do anything useful
anymore, so zap it.

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
 kernel/time/clocksource.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e837ffd1..0696559 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -575,20 +575,6 @@ u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
 	return max_nsecs;
 }
 
-/**
- * clocksource_max_deferment - Returns max time the clocksource should be deferred
- * @cs:         Pointer to clocksource
- *
- */
-static u64 clocksource_max_deferment(struct clocksource *cs)
-{
-	u64 max_nsecs;
-
-	max_nsecs = clocks_calc_max_nsecs(cs->mult, cs->shift, cs->maxadj,
-					  cs->mask);
-	return max_nsecs;
-}
-
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
 static struct clocksource *clocksource_find_best(bool oneshot, bool skipcur)
@@ -760,7 +746,8 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 		cs->maxadj = clocksource_max_adjustment(cs);
 	}
 
-	cs->max_idle_ns = clocksource_max_deferment(cs);
+	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
+						 cs->maxadj, cs->mask);
 }
 EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
 
@@ -807,7 +794,8 @@ int clocksource_register(struct clocksource *cs)
 		cs->name);
 
 	/* calculate max idle time permitted for this clocksource */
-	cs->max_idle_ns = clocksource_max_deferment(cs);
+	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
+						 cs->maxadj, cs->mask);
 
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
-- 
1.9.1

