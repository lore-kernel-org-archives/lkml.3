Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaGKNob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:44:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:56128 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaGKNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:29 -0400
Message-Id: <20140711133706.969220744@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 20/55] timekeeping: Use ktime_t data for
 ktime_get_update_offsets_now()
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-use-ktime-for-hrtimer-if.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to juggle with timespecs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1672,14 +1672,14 @@ ktime_t ktime_get_update_offsets_now(kti
 							ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	ktime_t now;
 	unsigned int seq;
-	u64 secs, nsecs;
+	ktime_t base;
+	u64 nsecs;
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 
-		secs = tk->xtime_sec;
+		base = tk->base_mono;
 		nsecs = timekeeping_get_ns(tk);
 
 		*offs_real = tk->offs_real;
@@ -1687,9 +1687,7 @@ ktime_t ktime_get_update_offsets_now(kti
 		*offs_tai = tk->offs_tai;
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
-	now = ktime_sub(now, *offs_real);
-	return now;
+	return ktime_add_ns(base, nsecs);
 }
 #endif
 


