Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaGPVER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:59657 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaGPVEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:13 -0400
Message-Id: <20140716205053.514827613@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 16/64] timekeeping: Use ktime_t based data for ktime_get()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-use-ktime-based-for-ktime-get.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speed up ktime_get() by using ktime_t based data. Text size shrinks by
64 bytes on x8664.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -407,18 +407,19 @@ ktime_t ktime_get(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
-	s64 secs, nsecs;
+	ktime_t base;
+	s64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
-		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
-		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
+		base = tk->base_mono;
+		nsecs = timekeeping_get_ns(tk);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	return ktime_set(secs, nsecs);
+	return ktime_add_ns(base, nsecs);
 }
 EXPORT_SYMBOL_GPL(ktime_get);
 


