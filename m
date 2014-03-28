Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaC1LnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:43:13 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62200 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaC1LnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/16] hrtimer: don't check if timer is queued in __remove_hrtimer()
Date: Fri, 28 Mar 2014 17:11:30 +0530
Message-Id: <b5cb05736835e9826ededf9b4b7b837e8ee1627a.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__remove_hrtimer() is called from three locations: remove_hrtimer(),
__run_hrtimer() and migrate_hrtimer_list(). And all these guarantee that timer
was queued earlier. And so there is no need to check if the timer is queued or
not in __remove_hrtimer().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2702185..04f8e44 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -875,9 +875,6 @@ static void __remove_hrtimer(struct hrtimer *timer, unsigned long newstate,
 {
 	struct hrtimer_clock_base *base = timer->base;
 
-	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
-		goto out;
-
 	timerqueue_del(&base->active, &timer->node);
 
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -891,10 +888,9 @@ static void __remove_hrtimer(struct hrtimer *timer, unsigned long newstate,
 			hrtimer_force_reprogram(base->cpu_base, 1);
 	}
 #endif
+	timer->state = newstate;
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
-out:
-	timer->state = newstate;
 }
 
 /* remove hrtimer, called with base lock held */
-- 
1.7.12.rc2.18.g61b472e

