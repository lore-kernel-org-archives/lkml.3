Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3E0Jmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:42:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3E0Jmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:42:47 -0400
Date: Mon, 27 May 2013 02:42:32 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-5d33b883aed81c6fbcd09c6f7c3619eee850a7e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143435.635040849@linutronix.de>
References: <20130425143435.635040849@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Always verify highres capability
Git-Commit-ID: 5d33b883aed81c6fbcd09c6f7c3619eee850a7e2
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

Commit-ID:  5d33b883aed81c6fbcd09c6f7c3619eee850a7e2
Gitweb:     http://git.kernel.org/tip/5d33b883aed81c6fbcd09c6f7c3619eee850a7e2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:14 +0200

clocksource: Always verify highres capability

If a clocksource has a (wrong) high rating, but can't be used as a
timebase for oneshot tick mode, it is unconditionally selected even
when the system is already in oneshot tick mode. This causes full
system failure.

Verify the clocksource selection against the oneshot mode.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143435.635040849@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..dda5c71 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -553,6 +553,26 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
+static struct clocksource *clocksource_find_best(bool oneshot)
+{
+	struct clocksource *cs;
+
+	if (!finished_booting || list_empty(&clocksource_list))
+		return NULL;
+
+	/*
+	 * We pick the clocksource with the highest rating. If oneshot
+	 * mode is active, we pick the highres valid clocksource with
+	 * the best rating.
+	 */
+	list_for_each_entry(cs, &clocksource_list, list) {
+		if (oneshot && !(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES))
+			continue;
+		return cs;
+	}
+	return NULL;
+}
+
 /**
  * clocksource_select - Select the best clocksource available
  *
@@ -563,12 +583,14 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
  */
 static void clocksource_select(void)
 {
+	bool oneshot = tick_oneshot_mode_active();
 	struct clocksource *best, *cs;
 
-	if (!finished_booting || list_empty(&clocksource_list))
+	/* Find the best suitable clocksource */
+	best = clocksource_find_best(oneshot);
+	if (!best)
 		return;
-	/* First clocksource on the list has the best rating. */
-	best = list_first_entry(&clocksource_list, struct clocksource, list);
+
 	/* Check for the override clocksource. */
 	list_for_each_entry(cs, &clocksource_list, list) {
 		if (strcmp(cs->name, override_name) != 0)
@@ -578,8 +600,7 @@ static void clocksource_select(void)
 		 * capable clocksource if the tick code is in oneshot
 		 * mode (highres or nohz)
 		 */
-		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
-		    tick_oneshot_mode_active()) {
+		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) && oneshot) {
 			/* Override clocksource cannot be used. */
 			printk(KERN_WARNING "Override clocksource %s is not "
 			       "HRT compatible. Cannot switch while in "
