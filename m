Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaC0Fy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:54:56 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35614 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaC0Fyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:54:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 Resend] hrtimer: use ffs() to iterate over valid bits from active_bases
Date: Thu, 27 Mar 2014 11:24:47 +0530
Message-Id: <16126ce574322be7733522e6aacab0f45ebd9db5.1395899588.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <8aa380361c07844f7b274e472f542ae2171bb39a.1395899293.git.viresh.kumar@linaro.org>
References: <8aa380361c07844f7b274e472f542ae2171bb39a.1395899293.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are iterating over all possible (currently four) bits of
active_bases to see if corresponding clock bases are active. This is good enough
for cases where 3 or 4 bases are used but if only 1 or 2 are used then it makes
more sense to use ffs() to find the right bit directly.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V3->Resend: s/__ffs/ffs in commit log :(

V2->V3: Use ffs() instead of __ffs() and decrement 'i' later.

V1->V2: Instead of removing active_bases use __ffs() on it to make loop more
efficient.

 kernel/hrtimer.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index acfef5f..2aad8a7 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1265,6 +1265,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
+	unsigned long active_bases = cpu_base->active_bases;
 	int i, retries = 0;
 
 	BUG_ON(!cpu_base->hres_active);
@@ -1284,15 +1285,11 @@ retry:
 	 */
 	cpu_base->expires_next.tv64 = KTIME_MAX;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		struct hrtimer_clock_base *base;
+	while ((i = ffs(active_bases))) {
+		struct hrtimer_clock_base *base = cpu_base->clock_base + --i;
 		struct timerqueue_node *node;
 		ktime_t basenow;
 
-		if (!(cpu_base->active_bases & (1 << i)))
-			continue;
-
-		base = cpu_base->clock_base + i;
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = timerqueue_getnext(&base->active))) {
@@ -1327,6 +1324,8 @@ retry:
 
 			__run_hrtimer(timer, &basenow);
 		}
+
+		active_bases &= ~(1 << i);
 	}
 
 	/*
-- 
1.7.12.rc2.18.g61b472e

