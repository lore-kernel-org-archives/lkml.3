Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaC1Lnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:43:50 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54803 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaC1Lnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 16/16] hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
Date: Fri, 28 Mar 2014 17:11:35 +0530
Message-Id: <c2108011e02e39d0be889be658046e0de44f7c79.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use base->hres_active directly when we already have a pointer to base instead of
calling hrtimer_hres_active(). As that would lead to:

	__this_cpu_read(hrtimer_bases.hres_active)

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 83e5f2d..f379821 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -883,7 +883,7 @@ static void __remove_hrtimer(struct hrtimer *timer, unsigned long newstate,
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Reprogram the clock event device. if enabled */
-	if (reprogram && hrtimer_hres_active() &&
+	if (reprogram && base->cpu_base->hres_active &&
 	    &timer->node == timerqueue_getnext(&base->active)) {
 		ktime_t expires;
 
@@ -1107,7 +1107,7 @@ ktime_t hrtimer_get_next_event(void)
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (!hrtimer_hres_active()) {
+	if (!cpu_base->hres_active) {
 		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 			struct hrtimer *timer;
 			struct timerqueue_node *next;
@@ -1437,7 +1437,7 @@ void hrtimer_run_queues(void)
 	struct hrtimer_clock_base *base;
 	int index, gettime = 1;
 
-	if (hrtimer_hres_active())
+	if (cpu_base->hres_active)
 		return;
 
 	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
-- 
1.7.12.rc2.18.g61b472e

