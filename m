Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab3DYUex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:34:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:45971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab3DYUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:45 -0400
Message-Id: <20130425143435.696321912@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 03/15] clocksource: Let timekeeping_notify return success/error
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-verify-timekeeping-notify.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timekeeping_notify() can fail due cs->enable() failure. Though the
caller does not notice and happily keeps the wrong clocksource as the
current one.

Let the caller know about failure, so the current clocksource will be
shown correctly in sysfs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |    2 +-
 kernel/time/clocksource.c   |    6 +++---
 kernel/time/timekeeping.c   |    5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

Index: tip/include/linux/clocksource.h
===================================================================
--- tip.orig/include/linux/clocksource.h
+++ tip/include/linux/clocksource.h
@@ -321,7 +321,7 @@ static inline void __clocksource_updatef
 }
 
 
-extern void timekeeping_notify(struct clocksource *clock);
+extern int timekeeping_notify(struct clocksource *clock);
 
 extern cycle_t clocksource_mmio_readl_up(struct clocksource *);
 extern cycle_t clocksource_mmio_readl_down(struct clocksource *);
Index: tip/kernel/time/clocksource.c
===================================================================
--- tip.orig/kernel/time/clocksource.c
+++ tip/kernel/time/clocksource.c
@@ -611,10 +611,10 @@ static void clocksource_select(void)
 			best = cs;
 		break;
 	}
-	if (curr_clocksource != best) {
-		printk(KERN_INFO "Switching to clocksource %s\n", best->name);
+
+	if (curr_clocksource != best && !timekeeping_notify(best)) {
+		pr_info("Switched to clocksource %s\n", best->name);
 		curr_clocksource = best;
-		timekeeping_notify(curr_clocksource);
 	}
 }
 
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -648,14 +648,15 @@ static int change_clocksource(void *data
  * This function is called from clocksource.c after a new, better clock
  * source has been registered. The caller holds the clocksource_mutex.
  */
-void timekeeping_notify(struct clocksource *clock)
+int timekeeping_notify(struct clocksource *clock)
 {
 	struct timekeeper *tk = &timekeeper;
 
 	if (tk->clock == clock)
-		return;
+		return 0;
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
+	return tk->clock == clock ? 0 : -1;
 }
 
 /**


