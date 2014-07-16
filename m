Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaGPVRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:17:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:59700 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaGPVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:25 -0400
Message-Id: <20140716205054.186174638@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 24/64] timerfd: Use ktime_mono_to_real()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=fs-timerfd-use-ktime-mono-to-real.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a few other use cases of ktime_get_monotonic_offset() which
can be optimized with ktime_mono_to_real(). The timerfd code uses the
offset only for comparison, so we can use ktime_mono_to_real(0) for
this as well.

Funny enough text size shrinks with that on ARM and x8664 !?

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/timerfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: tip/fs/timerfd.c
===================================================================
--- tip.orig/fs/timerfd.c
+++ tip/fs/timerfd.c
@@ -92,7 +92,7 @@ static enum alarmtimer_restart timerfd_a
  */
 void timerfd_clock_was_set(void)
 {
-	ktime_t moffs = ktime_get_monotonic_offset();
+	ktime_t moffs = ktime_mono_to_real((ktime_t){ .tv64 = 0 });
 	struct timerfd_ctx *ctx;
 	unsigned long flags;
 
@@ -125,7 +125,7 @@ static bool timerfd_canceled(struct time
 {
 	if (!ctx->might_cancel || ctx->moffs.tv64 != KTIME_MAX)
 		return false;
-	ctx->moffs = ktime_get_monotonic_offset();
+	ctx->moffs = ktime_mono_to_real((ktime_t){ .tv64 = 0 });
 	return true;
 }
 
@@ -336,7 +336,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	else
 		hrtimer_init(&ctx->t.tmr, clockid, HRTIMER_MODE_ABS);
 
-	ctx->moffs = ktime_get_monotonic_offset();
+	ctx->moffs = ktime_mono_to_real((ktime_t){ .tv64 = 0 });
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
 			       O_RDWR | (flags & TFD_SHARED_FCNTL_FLAGS));


