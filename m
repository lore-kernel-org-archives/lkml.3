Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab3DYUfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:35:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:45966 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126Ab3DYUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:44 -0400
Message-Id: <20130425143435.635040849@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 02/15] clocksource: Always verify highres capability
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-verify-highres-capability.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a clocksource has a (wrong) high rating, but can't be used as a
timebase for oneshot tick mode, it is unconditionally selected even
when the system is already in oneshot tick mode. This causes full
system failure.

Verify the clocksource selection against the oneshot mode.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

Index: tip/kernel/time/clocksource.c
===================================================================
--- tip.orig/kernel/time/clocksource.c
+++ tip/kernel/time/clocksource.c
@@ -553,6 +553,26 @@ static u64 clocksource_max_deferment(str
 
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
@@ -563,12 +583,14 @@ static u64 clocksource_max_deferment(str
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


