Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaGPVPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:15:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:59747 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaGPVEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:38 -0400
Message-Id: <20140716205054.965730772@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 33/64] delayacct: Remove braindamaged type conversions
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=delayacct-simplify.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting cputime to timespec and timespec to nanoseconds makes no
sense. Use cputime_to_ns() and be done with it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/delayacct.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

Index: tip/kernel/delayacct.c
===================================================================
--- tip.orig/kernel/delayacct.c
+++ tip/kernel/delayacct.c
@@ -82,23 +82,19 @@ void __delayacct_blkio_end(void)
 
 int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 {
-	s64 tmp;
-	unsigned long t1;
-	unsigned long long t2, t3;
-	unsigned long flags;
-	struct timespec ts;
 	cputime_t utime, stime, stimescaled, utimescaled;
+	unsigned long long t2, t3;
+	unsigned long flags, t1;
+	s64 tmp;
 
-	tmp = (s64)d->cpu_run_real_total;
 	task_cputime(tsk, &utime, &stime);
-	cputime_to_timespec(utime + stime, &ts);
-	tmp += timespec_to_ns(&ts);
+	tmp = (s64)d->cpu_run_real_total;
+	tmp += cputime_to_nsecs(utime + stime);
 	d->cpu_run_real_total = (tmp < (s64)d->cpu_run_real_total) ? 0 : tmp;
 
-	tmp = (s64)d->cpu_scaled_run_real_total;
 	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
-	cputime_to_timespec(utimescaled + stimescaled, &ts);
-	tmp += timespec_to_ns(&ts);
+	tmp = (s64)d->cpu_scaled_run_real_total;
+	tmp += cputime_to_nsecs(utimescaled + stimescaled);
 	d->cpu_scaled_run_real_total =
 		(tmp < (s64)d->cpu_scaled_run_real_total) ? 0 : tmp;
 


