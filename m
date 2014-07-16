Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaGPVOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:14:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:59774 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaGPVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:45 -0400
Message-Id: <20140716205055.320349882@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [patch V2 37/64] misc: ioc4: Use ktime_get_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=misc-ioc4-remove-silly-time-stamp-dance.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ever recurring:
        ts = ktime_get_ts();
        ns = timespec_to_ns(&ts);
with
        ns = ktime_get_ns();

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ioc4.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: tip/drivers/misc/ioc4.c
===================================================================
--- tip.orig/drivers/misc/ioc4.c
+++ tip/drivers/misc/ioc4.c
@@ -145,7 +145,6 @@ ioc4_clock_calibrate(struct ioc4_driver_
 	union ioc4_int_out int_out;
 	union ioc4_gpcr gpcr;
 	unsigned int state, last_state = 1;
-	struct timespec start_ts, end_ts;
 	uint64_t start, end, period;
 	unsigned int count = 0;
 
@@ -174,10 +173,10 @@ ioc4_clock_calibrate(struct ioc4_driver_
 		if (!last_state && state) {
 			count++;
 			if (count == IOC4_CALIBRATE_END) {
-				ktime_get_ts(&end_ts);
+				end = ktime_get_ns();
 				break;
 			} else if (count == IOC4_CALIBRATE_DISCARD)
-				ktime_get_ts(&start_ts);
+				start = ktime_get_ns();
 		}
 		last_state = state;
 	} while (1);
@@ -192,8 +191,6 @@ ioc4_clock_calibrate(struct ioc4_driver_
 	 *    by which the IOC4 generates the square wave, to get the
 	 *    period of an IOC4 INT_OUT count.
 	 */
-	end = end_ts.tv_sec * NSEC_PER_SEC + end_ts.tv_nsec;
-	start = start_ts.tv_sec * NSEC_PER_SEC + start_ts.tv_nsec;
 	period = (end - start) /
 		(IOC4_CALIBRATE_CYCLES * 2 * (IOC4_CALIBRATE_COUNT + 1));
 


