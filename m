Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab3DYUbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:31:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:45985 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313Ab3DYUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:46 -0400
Message-Id: <20130425143435.834965397@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 05/15] clocksource: Allow clocksource select to skip current
 clocksource
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-allow-clocksource-select-to-skip-current.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for clocksource unbind support.

Modify clocksource_select, so it skips the current clocksource on
request and tries to find a fallback clocksource. Convert all existing
users. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

Index: tip/kernel/time/clocksource.c
===================================================================
--- tip.orig/kernel/time/clocksource.c
+++ tip/kernel/time/clocksource.c
@@ -553,7 +553,7 @@ static u64 clocksource_max_deferment(str
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
-static struct clocksource *clocksource_find_best(bool oneshot)
+static struct clocksource *clocksource_find_best(bool oneshot, bool skipcur)
 {
 	struct clocksource *cs;
 
@@ -566,6 +566,8 @@ static struct clocksource *clocksource_f
 	 * the best rating.
 	 */
 	list_for_each_entry(cs, &clocksource_list, list) {
+		if (skipcur && cs == curr_clocksource)
+			continue;
 		if (oneshot && !(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES))
 			continue;
 		return cs;
@@ -581,18 +583,20 @@ static struct clocksource *clocksource_f
  * Select the clocksource with the best rating, or the clocksource,
  * which is selected by userspace override.
  */
-static void clocksource_select(void)
+static void clocksource_select(bool skipcur)
 {
 	bool oneshot = tick_oneshot_mode_active();
 	struct clocksource *best, *cs;
 
 	/* Find the best suitable clocksource */
-	best = clocksource_find_best(oneshot);
+	best = clocksource_find_best(oneshot, skipcur);
 	if (!best)
 		return;
 
 	/* Check for the override clocksource. */
 	list_for_each_entry(cs, &clocksource_list, list) {
+		if (skipcur && cs == curr_clocksource)
+			continue;
 		if (strcmp(cs->name, override_name) != 0)
 			continue;
 		/*
@@ -620,7 +624,7 @@ static void clocksource_select(void)
 
 #else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
-static inline void clocksource_select(void) { }
+static inline void clocksource_select(bool skipcur) { }
 
 #endif
 
@@ -645,7 +649,7 @@ static int __init clocksource_done_booti
 	clocksource_watchdog_kthread(NULL);
 
 	mutex_lock(&clocksource_mutex);
-	clocksource_select();
+	clocksource_select(false);
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
@@ -739,7 +743,7 @@ int __clocksource_register_scale(struct 
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_enqueue_watchdog(cs);
-	clocksource_select();
+	clocksource_select(false);
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
@@ -766,7 +770,7 @@ int clocksource_register(struct clocksou
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_enqueue_watchdog(cs);
-	clocksource_select();
+	clocksource_select(false);
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
@@ -777,7 +781,7 @@ static void __clocksource_change_rating(
 	list_del(&cs->list);
 	cs->rating = rating;
 	clocksource_enqueue(cs);
-	clocksource_select();
+	clocksource_select(false);
 }
 
 /**
@@ -802,7 +806,7 @@ void clocksource_unregister(struct clock
 	mutex_lock(&clocksource_mutex);
 	clocksource_dequeue_watchdog(cs);
 	list_del(&cs->list);
-	clocksource_select();
+	clocksource_select(false);
 	mutex_unlock(&clocksource_mutex);
 }
 EXPORT_SYMBOL(clocksource_unregister);
@@ -858,7 +862,7 @@ static ssize_t sysfs_override_clocksourc
 	if (count > 0)
 		memcpy(override_name, buf, count);
 	override_name[count] = 0;
-	clocksource_select();
+	clocksource_select(false);
 
 	mutex_unlock(&clocksource_mutex);
 


