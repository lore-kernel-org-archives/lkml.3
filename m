Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaDDGmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:04 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:44653 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaDDGl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:57 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 22/36] hrtimer: clear active_bases as soon as the timer is removed
Date: Fri,  4 Apr 2014 12:06:05 +0530
Message-Id: <31d5cab755a1401e8c5e0b5041087c889f804693.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timers are removed from the red-black trees from __remove_hrtimer() and after
removing timer from the tree, it calls hrtimer_force_reprogram() which might use
value of cpu_base->active_bases. If the timer being removed is the last one on
that clock base, then cpu_base->active_bases wouldn't give the right value, as
there are no timers queued on the base but active base still marks it as active.

So, clear entry from active_bases as soon as timer is removed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2d5bb9d..379d21a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -895,6 +895,9 @@ static void __remove_hrtimer(struct hrtimer *timer,
 	next_timer = timerqueue_getnext(&base->active);
 	timerqueue_del(&base->active, &timer->node);
 
+	if (!timerqueue_getnext(&base->active))
+		base->cpu_base->active_bases &= ~(1 << base->index);
+
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Reprogram the clock event device. if enabled */
 	if (reprogram && base->cpu_base->hres_active &&
@@ -907,8 +910,6 @@ static void __remove_hrtimer(struct hrtimer *timer,
 	}
 #endif
 	timer->state = newstate;
-	if (!timerqueue_getnext(&base->active))
-		base->cpu_base->active_bases &= ~(1 << base->index);
 }
 
 /*
-- 
1.7.12.rc2.18.g61b472e

