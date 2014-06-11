Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaFKX7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:35993 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaFKX7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:15 -0400
Message-Id: <20140611234606.931409215@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 03/13] delayacct: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=kernel-delayacct-use-ktime-get.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts(). Remove the
silly wrapper while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/delayacct.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

Index: linux/kernel/delayacct.c
===================================================================
--- linux.orig/kernel/delayacct.c
+++ linux/kernel/delayacct.c
@@ -46,16 +46,6 @@ void __delayacct_tsk_init(struct task_st
 }
 
 /*
- * Start accounting for a delay statistic using
- * its starting timestamp (@start)
- */
-
-static inline void delayacct_start(struct timespec *start)
-{
-	do_posix_clock_monotonic_gettime(start);
-}
-
-/*
  * Finish delay accounting for a statistic using
  * its timestamps (@start, @end), accumalator (@total) and @count
  */
@@ -67,7 +57,7 @@ static void delayacct_end(struct timespe
 	s64 ns;
 	unsigned long flags;
 
-	do_posix_clock_monotonic_gettime(end);
+	ktime_get_ts(end);
 	ts = timespec_sub(*end, *start);
 	ns = timespec_to_ns(&ts);
 	if (ns < 0)
@@ -81,7 +71,7 @@ static void delayacct_end(struct timespe
 
 void __delayacct_blkio_start(void)
 {
-	delayacct_start(&current->delays->blkio_start);
+	ktime_get_ts(&current->delays->blkio_start);
 }
 
 void __delayacct_blkio_end(void)
@@ -169,7 +159,7 @@ __u64 __delayacct_blkio_ticks(struct tas
 
 void __delayacct_freepages_start(void)
 {
-	delayacct_start(&current->delays->freepages_start);
+	ktime_get_ts(&current->delays->freepages_start);
 }
 
 void __delayacct_freepages_end(void)


