Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaGPVFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:59838 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaGPVFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:00 -0400
Message-Id: <20140716205056.189417343@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 47/64] timekeeping: Simplify getboottime()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-simplify-getboottime.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subtracting plain nsec values and converting to timespec is simpler
than the whole timespec math. Not really fastpath code, so the
division is not an issue.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1525,14 +1525,9 @@ out:
 void getboottime(struct timespec *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec boottime = {
-		.tv_sec = tk->wall_to_monotonic.tv_sec +
-				tk->total_sleep_time.tv_sec,
-		.tv_nsec = tk->wall_to_monotonic.tv_nsec +
-				tk->total_sleep_time.tv_nsec
-	};
+	ktime_t t = ktime_sub(tk->offs_real, tk->offs_boot);
 
-	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
+	*ts = ktime_to_timespec(t);
 }
 EXPORT_SYMBOL_GPL(getboottime);
 


