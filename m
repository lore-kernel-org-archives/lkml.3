Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaGKNs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:48:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:56272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaGKNpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:45:10 -0400
Message-Id: <20140711133709.245458528@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:45:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [patch 47/55] hangcheck-timer: Use ktime_get_raw_ns()
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=hangcheck-timer-get-rid-of-cruft.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the nanoseconds based interface instead of converting timespecs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hangcheck-timer.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

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
 
@@ -129,9 +129,7 @@ extern unsigned long long monotonic_cloc
 #else
 static inline unsigned long long monotonic_clock(void)
 {
-	struct timespec ts;
-	getrawmonotonic(&ts);
-	return timespec_to_ns(&ts);
+	return ktime_get_raw_ns();
 }
 #endif  /* HAVE_MONOTONIC */
 
@@ -186,9 +184,9 @@ static int __init hangcheck_init(void)
 	printk("Hangcheck: starting hangcheck timer %s (tick is %d seconds, margin is %d seconds).\n",
 	       VERSION_STR, hangcheck_tick, hangcheck_margin);
 #if defined (HAVE_MONOTONIC)
-	printk("Hangcheck: Using monotonic_clock().\n");
+	printk("Hangcheck: Using monotonic clock\n");
 #else
-	printk("Hangcheck: Using getrawmonotonic().\n");
+	printk("Hangcheck: Using raw monotonic clock.\n");
 #endif  /* HAVE_MONOTONIC */
 	hangcheck_tsc_margin =
 		(unsigned long long)(hangcheck_margin + hangcheck_tick);


