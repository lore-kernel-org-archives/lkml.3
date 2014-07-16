Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaGPVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:15:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:59740 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaGPVEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:37 -0400
Message-Id: <20140716205054.876986865@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 32/64] delayacct: Make accounting nanosecond based
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=delayacct-use-ktimet.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the timespec juggling and calculate with plain nanoseconds.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    4 ++--
 kernel/delayacct.c    |   34 ++++++++++++----------------------
 2 files changed, 14 insertions(+), 24 deletions(-)

Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -813,7 +813,7 @@ struct task_delay_info {
 	 * associated with the operation is added to XXX_delay.
 	 * XXX_delay contains the accumulated delay time in nanoseconds.
 	 */
-	struct timespec blkio_start, blkio_end;	/* Shared by blkio, swapin */
+	u64 blkio_start;	/* Shared by blkio, swapin */
 	u64 blkio_delay;	/* wait for sync block io completion */
 	u64 swapin_delay;	/* wait for swapin block io completion */
 	u32 blkio_count;	/* total count of the number of sync block */
@@ -821,7 +821,7 @@ struct task_delay_info {
 	u32 swapin_count;	/* total count of the number of swapin block */
 				/* io operations performed */
 
-	struct timespec freepages_start, freepages_end;
+	u64 freepages_start;
 	u64 freepages_delay;	/* wait for memory reclaim */
 	u32 freepages_count;	/* total count of memory reclaim */
 };
Index: tip/kernel/delayacct.c
===================================================================
--- tip.orig/kernel/delayacct.c
+++ tip/kernel/delayacct.c
@@ -46,32 +46,25 @@ void __delayacct_tsk_init(struct task_st
 }
 
 /*
- * Finish delay accounting for a statistic using
- * its timestamps (@start, @end), accumalator (@total) and @count
+ * Finish delay accounting for a statistic using its timestamps (@start),
+ * accumalator (@total) and @count
  */
-
-static void delayacct_end(struct timespec *start, struct timespec *end,
-				u64 *total, u32 *count)
+static void delayacct_end(u64 *start, u64 *total, u32 *count)
 {
-	struct timespec ts;
-	s64 ns;
+	s64 ns = ktime_get_ns() - *start;
 	unsigned long flags;
 
-	ktime_get_ts(end);
-	ts = timespec_sub(*end, *start);
-	ns = timespec_to_ns(&ts);
-	if (ns < 0)
-		return;
-
-	spin_lock_irqsave(&current->delays->lock, flags);
-	*total += ns;
-	(*count)++;
-	spin_unlock_irqrestore(&current->delays->lock, flags);
+	if (ns > 0) {
+		spin_lock_irqsave(&current->delays->lock, flags);
+		*total += ns;
+		(*count)++;
+		spin_unlock_irqrestore(&current->delays->lock, flags);
+	}
 }
 
 void __delayacct_blkio_start(void)
 {
-	ktime_get_ts(&current->delays->blkio_start);
+	current->delays->blkio_start = ktime_get_ns();
 }
 
 void __delayacct_blkio_end(void)
@@ -79,12 +72,10 @@ void __delayacct_blkio_end(void)
 	if (current->delays->flags & DELAYACCT_PF_SWAPIN)
 		/* Swapin block I/O */
 		delayacct_end(&current->delays->blkio_start,
-			&current->delays->blkio_end,
 			&current->delays->swapin_delay,
 			&current->delays->swapin_count);
 	else	/* Other block I/O */
 		delayacct_end(&current->delays->blkio_start,
-			&current->delays->blkio_end,
 			&current->delays->blkio_delay,
 			&current->delays->blkio_count);
 }
@@ -159,13 +150,12 @@ __u64 __delayacct_blkio_ticks(struct tas
 
 void __delayacct_freepages_start(void)
 {
-	ktime_get_ts(&current->delays->freepages_start);
+	current->delays->freepages_start = ktime_get_ns();
 }
 
 void __delayacct_freepages_end(void)
 {
 	delayacct_end(&current->delays->freepages_start,
-			&current->delays->freepages_end,
 			&current->delays->freepages_delay,
 			&current->delays->freepages_count);
 }


