Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab3DYUdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:33:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:46003 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab3DYUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:48 -0400
Message-Id: <20130425143436.029915527@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 08/15] clocksource: Let clocksource_unregister() return
 success/error
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-unregister-return-success-error.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unregister call can fail, if the clocksource is the current one
and there is no replacement clocksource available. It can also fail,
if the clocksource is the watchdog clocksource and I'm not going to
provide support for this.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |    2 +-
 kernel/time/clocksource.c   |   33 ++++++++++++---------------------
 2 files changed, 13 insertions(+), 22 deletions(-)

Index: tip/include/linux/clocksource.h
===================================================================
--- tip.orig/include/linux/clocksource.h
+++ tip/include/linux/clocksource.h
@@ -282,7 +282,7 @@ static inline s64 clocksource_cyc2ns(cyc
 
 
 extern int clocksource_register(struct clocksource*);
-extern void clocksource_unregister(struct clocksource*);
+extern int clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
Index: tip/kernel/time/clocksource.c
===================================================================
--- tip.orig/kernel/time/clocksource.c
+++ tip/kernel/time/clocksource.c
@@ -389,28 +389,17 @@ static void clocksource_enqueue_watchdog
 
 static void clocksource_dequeue_watchdog(struct clocksource *cs)
 {
-	struct clocksource *tmp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&watchdog_lock, flags);
-	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
-		/* cs is a watched clocksource. */
-		list_del_init(&cs->wd_list);
-	} else if (cs == watchdog) {
-		/* Reset watchdog cycles */
-		clocksource_reset_watchdog();
-		/* Current watchdog is removed. Find an alternative. */
-		watchdog = NULL;
-		list_for_each_entry(tmp, &clocksource_list, list) {
-			if (tmp == cs || tmp->flags & CLOCK_SOURCE_MUST_VERIFY)
-				continue;
-			if (!watchdog || tmp->rating > watchdog->rating)
-				watchdog = tmp;
+	if (cs != watchdog) {
+		if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+			/* cs is a watched clocksource. */
+			list_del_init(&cs->wd_list);
+			/* Check if the watchdog timer needs to be stopped. */
+			clocksource_stop_watchdog();
 		}
 	}
-	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
-	/* Check if the watchdog timer needs to be stopped. */
-	clocksource_stop_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
@@ -831,13 +820,15 @@ static int clocksource_unbind(struct clo
  * clocksource_unregister - remove a registered clocksource
  * @cs:	clocksource to be unregistered
  */
-void clocksource_unregister(struct clocksource *cs)
+int clocksource_unregister(struct clocksource *cs)
 {
+	int ret = 0;
+
 	mutex_lock(&clocksource_mutex);
-	clocksource_dequeue_watchdog(cs);
-	list_del(&cs->list);
-	clocksource_select(false);
+	if (!list_empty(&cs->list))
+		ret = clocksource_unbind(cs);
 	mutex_unlock(&clocksource_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(clocksource_unregister);
 


