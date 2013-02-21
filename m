Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab3BUWwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:52:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:53449 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab3BUWvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:41 -0500
Message-Id: <20130221224231.238540952@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 8/8] timekeeping: Shorten seq_count region
References: <20130221220147.719832397@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-shorten-seq-count-region.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten the seqcount write hold region to the actual update of the
timekeeper and the related data (e.g vsyscall).

On a contemporary x86 system this reduces the maximum latencies on
Preempt-RT from 8us to 4us on the non-timekeeping cores.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-3.6/kernel/time/timekeeping.c
===================================================================
--- linux-3.6.orig/kernel/time/timekeeping.c
+++ linux-3.6/kernel/time/timekeeping.c
@@ -1190,7 +1190,6 @@ static void update_wall_time(void)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1242,6 +1241,7 @@ static void update_wall_time(void)
 	 */
 	accumulate_nsecs_to_secs(tk);
 
+	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
 	clock->cycle_last = tk->cycle_last;
 	/*
@@ -1256,9 +1256,8 @@ static void update_wall_time(void)
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
 	timekeeping_update(real_tk, false, false);
-
-out:
 	write_seqcount_end(&timekeeper_seq);
+out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 


