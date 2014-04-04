Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaDDGlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:39 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40996 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDDGl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 17/36] hrtimer: don't check if timer is queued in __remove_hrtimer()
Date: Fri,  4 Apr 2014 12:06:00 +0530
Message-Id: <7c3ae3486aa5b75aa584a49fc96ab9125d7e5391.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__remove_hrtimer() is called from three locations: remove_hrtimer(),
__run_hrtimer() and migrate_hrtimer_list(). And all these guarantee that timer
was queued earlier. And so there is no need to check if the timer is queued or
not in __remove_hrtimer().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1a1fdc0..58b5e3f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -886,8 +886,6 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     unsigned long newstate, int reprogram)
 {
 	struct timerqueue_node *next_timer;
-	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
-		goto out;
 
 	next_timer = timerqueue_getnext(&base->active);
 	timerqueue_del(&base->active, &timer->node);
@@ -903,10 +901,9 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			hrtimer_force_reprogram(base->cpu_base, 1);
 	}
 #endif
+	timer->state = newstate;
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
-out:
-	timer->state = newstate;
 }
 
 /*
-- 
1.7.12.rc2.18.g61b472e

