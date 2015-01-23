Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbbAWAJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:09:47 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47123 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbbAWAJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:44 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 09/12] clocksource: Improve clocksource watchdog reporting
Date: Thu, 22 Jan 2015 16:09:24 -0800
Message-Id: <1421971767-17707-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource watchdog reporting has been less helpful
then desired, as it just printed the delta between
the two clocksources. This prevents any useful analysis
of why the skew occurred.

Thus this patch tries to improve the output when we
mark a clocksource as unstable, printing out the cycle
last and now values for both the current clocksource
and the watchdog clocksource. This will allow us to see
if the result was due to a false positive caused by
a problematic watchdog.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/clocksource.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c2f8639..4aca66d 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -218,13 +218,6 @@ static void __clocksource_unstable(struct clocksource *cs)
 		schedule_work(&watchdog_work);
 }
 
-static void clocksource_unstable(struct clocksource *cs, int64_t delta)
-{
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
-	__clocksource_unstable(cs);
-}
-
 /**
  * clocksource_mark_unstable - mark clocksource unstable via watchdog
  * @cs:		clocksource to be marked unstable
@@ -250,7 +243,7 @@ void clocksource_mark_unstable(struct clocksource *cs)
 static void clocksource_watchdog(unsigned long data)
 {
 	struct clocksource *cs;
-	cycle_t csnow, wdnow, delta;
+	cycle_t csnow, wdnow, cslast, wdlast, delta;
 	int64_t wd_nsec, cs_nsec;
 	int next_cpu, reset_pending;
 
@@ -289,6 +282,8 @@ static void clocksource_watchdog(unsigned long data)
 
 		delta = clocksource_delta(csnow, cs->cs_last, cs->mask);
 		cs_nsec = clocksource_cyc2ns(delta, cs->mult, cs->shift);
+		wdlast = cs->wd_last; /* save these incase we print them */
+		cslast = cs->cs_last;
 		cs->cs_last = csnow;
 		cs->wd_last = wdnow;
 
@@ -297,7 +292,15 @@ static void clocksource_watchdog(unsigned long data)
 
 		/* Check the deviation from the watchdog clocksource. */
 		if ((abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD)) {
-			clocksource_unstable(cs, cs_nsec - wd_nsec);
+			pr_warn("Watchdog: clocksource %s unstable\n",
+				cs->name);
+			pr_warn("	"
+				"%s wd_now: %llx wd_last: %llx mask: %llx\n",
+				watchdog->name, wdnow, wdlast, watchdog->mask);
+			pr_warn("	"
+				"%s cs_now: %llx cs_last: %llx mask: %llx\n",
+				cs->name, csnow, cslast, cs->mask);
+			__clocksource_unstable(cs);
 			continue;
 		}
 
-- 
1.9.1

