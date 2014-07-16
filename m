Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaGPVFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:59853 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaGPVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:04 -0400
Message-Id: <20140716205056.454252756@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch V2 50/64] hangcheck-timer: Use ktime_get_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=hangcheck-timer-get-rid-of-cruft.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in having a S390 private implementation and there is
no point in using the raw monotonic time. The NTP freqeuency
adjustment of CLOCK_MONOTONIC is really not doing any harm for the
hang check timer.

Use ktime_get_ns() for everything and get rid of the timespec
conversions.

V2: Drop the raw monotonic and the S390 special case

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/char/hangcheck-timer.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

Index: tip/drivers/char/hangcheck-timer.c
===================================================================
--- tip.orig/drivers/char/hangcheck-timer.c
+++ tip/drivers/char/hangcheck-timer.c
@@ -49,7 +49,7 @@
 #include <asm/uaccess.h>
 #include <linux/sysrq.h>
 #include <linux/timer.h>
-#include <linux/time.h>
+#include <linux/hrtimer.h>
 
 #define VERSION_STR "0.9.1"
 
@@ -117,24 +117,7 @@ __setup("hcheck_reboot", hangcheck_parse
 __setup("hcheck_dump_tasks", hangcheck_parse_dump_tasks);
 #endif /* not MODULE */
 
-#if defined(CONFIG_S390)
-# define HAVE_MONOTONIC
-# define TIMER_FREQ 1000000000ULL
-#else
-# define TIMER_FREQ 1000000000ULL
-#endif
-
-#ifdef HAVE_MONOTONIC
-extern unsigned long long monotonic_clock(void);
-#else
-static inline unsigned long long monotonic_clock(void)
-{
-	struct timespec ts;
-	getrawmonotonic(&ts);
-	return timespec_to_ns(&ts);
-}
-#endif  /* HAVE_MONOTONIC */
-
+#define TIMER_FREQ 1000000000ULL
 
 /* Last time scheduled */
 static unsigned long long hangcheck_tsc, hangcheck_tsc_margin;
@@ -143,12 +126,11 @@ static void hangcheck_fire(unsigned long
 
 static DEFINE_TIMER(hangcheck_ticktock, hangcheck_fire, 0, 0);
 
-
 static void hangcheck_fire(unsigned long data)
 {
 	unsigned long long cur_tsc, tsc_diff;
 
-	cur_tsc = monotonic_clock();
+	cur_tsc = ktime_get_ns();
 
 	if (cur_tsc > hangcheck_tsc)
 		tsc_diff = cur_tsc - hangcheck_tsc;
@@ -177,7 +159,7 @@ static void hangcheck_fire(unsigned long
 			tsc_diff, tsc_diff - hangcheck_tick*TIMER_FREQ);
 #endif
 	mod_timer(&hangcheck_ticktock, jiffies + (hangcheck_tick*HZ));
-	hangcheck_tsc = monotonic_clock();
+	hangcheck_tsc = ktime_get_ns();
 }
 
 
@@ -185,16 +167,11 @@ static int __init hangcheck_init(void)
 {
 	printk("Hangcheck: starting hangcheck timer %s (tick is %d seconds, margin is %d seconds).\n",
 	       VERSION_STR, hangcheck_tick, hangcheck_margin);
-#if defined (HAVE_MONOTONIC)
-	printk("Hangcheck: Using monotonic_clock().\n");
-#else
-	printk("Hangcheck: Using getrawmonotonic().\n");
-#endif  /* HAVE_MONOTONIC */
 	hangcheck_tsc_margin =
 		(unsigned long long)(hangcheck_margin + hangcheck_tick);
 	hangcheck_tsc_margin *= (unsigned long long)TIMER_FREQ;
 
-	hangcheck_tsc = monotonic_clock();
+	hangcheck_tsc = ktime_get_ns();
 	mod_timer(&hangcheck_ticktock, jiffies + (hangcheck_tick*HZ));
 
 	return 0;


