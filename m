Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaDDGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:28 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57787 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaDDGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 14/36] hrtimer: reorder code in __remove_hrtimer()
Date: Fri,  4 Apr 2014 12:05:57 +0530
Message-Id: <4914d5607cdedd99b5886b586bd178df601d8dbf.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorders code within __remove_hrtimer() routine to achieve this:
- no need to check if timer is the next timer to expire when high resolution
  mode isn't configured in kernel. So, move this check within the #ifdef/endif
  block.
- Validate 'reprogram' and hrtimer_hres_active() first as without these we don't
  need to check if 'timer' is the next one to fire.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 476ad5d..833db9f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -891,19 +891,18 @@ static void __remove_hrtimer(struct hrtimer *timer,
 
 	next_timer = timerqueue_getnext(&base->active);
 	timerqueue_del(&base->active, &timer->node);
-	if (&timer->node == next_timer) {
+
 #ifdef CONFIG_HIGH_RES_TIMERS
-		/* Reprogram the clock event device. if enabled */
-		if (reprogram && base->cpu_base->hres_active) {
-			ktime_t expires;
-
-			expires = ktime_sub(hrtimer_get_expires(timer),
-					    base->offset);
-			if (base->cpu_base->expires_next.tv64 == expires.tv64)
-				hrtimer_force_reprogram(base->cpu_base, 1);
-		}
-#endif
+	/* Reprogram the clock event device. if enabled */
+	if (reprogram && base->cpu_base->hres_active &&
+	    &timer->node == next_timer) {
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

