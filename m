Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaC1LmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:06 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52276 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaC1LmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 02/16] hrtimer: reorder code in __remove_hrtimer()
Date: Fri, 28 Mar 2014 17:11:21 +0530
Message-Id: <9ea86197955aee2b751ccb5a8ea746dbd3244850.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorders code within __remove_hrtimer() routine to achieve this:
- no need to check if timer is the next timer to expire when high resolution
  mode isn't configured in kernel.
- no need of local variable 'next_timer'
- Validate 'reprogram' and hrtimer_hres_active() first as without these we don't
  need to check if timer is the next timer to fire.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a710638..6476152 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -887,25 +887,22 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
-	struct timerqueue_node *next_timer;
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
-	next_timer = timerqueue_getnext(&base->active);
 	timerqueue_del(&base->active, &timer->node);
-	if (&timer->node == next_timer) {
+
 #ifdef CONFIG_HIGH_RES_TIMERS
-		/* Reprogram the clock event device. if enabled */
-		if (reprogram && hrtimer_hres_active()) {
-			ktime_t expires;
-
-			expires = ktime_sub(hrtimer_get_expires(timer),
-					    base->offset);
-			if (base->cpu_base->expires_next.tv64 == expires.tv64)
-				hrtimer_force_reprogram(base->cpu_base, 1);
-		}
-#endif
+	/* Reprogram the clock event device. if enabled */
+	if (reprogram && hrtimer_hres_active() &&
+	    &timer->node == timerqueue_getnext(&base->active)) {
+		ktime_t expires;
+
+		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		if (base->cpu_base->expires_next.tv64 == expires.tv64)
+			hrtimer_force_reprogram(base->cpu_base, 1);
 	}
+#endif
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
-- 
1.7.12.rc2.18.g61b472e

