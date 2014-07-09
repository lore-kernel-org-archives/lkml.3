Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaGIG4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:56:07 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:34733 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaGIG4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:56:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 2/7] hrtimer: don't check for active hrtimer after adding it
Date: Wed,  9 Jul 2014 12:25:34 +0530
Message-Id: <13861232628603285a2734e32b309abd73c8741c.1404888801.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
only special case is when the hrtimer was in past. If it is getting enqueued to
local CPUs's clock-base, we raise a softirq and exit, else we handle that on
next interrupt on remote CPU.

At several places in the kernel, we try to make sure if hrtimer was added
properly or not by calling hrtimer_active(), like:

	hrtimer_start(timer, expires, mode);
	if (hrtimer_active(timer)) {
		/* Added successfully */
	} else {
		/* Was added in the past */
	}

As hrtimer_start*() never fails, hrtimer_active() is guaranteed to return '1'.
So, there is no point calling hrtimer_active().

This patch updates hrtimer core to get this fixed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cf40209..a76f962 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1555,8 +1555,6 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		hrtimer_start_expires(&t->timer, mode);
-		if (!hrtimer_active(&t->timer))
-			t->task = NULL;
 
 		if (likely(t->task))
 			freezable_schedule();
@@ -1837,8 +1835,6 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
 	hrtimer_init_sleeper(&t, current);
 
 	hrtimer_start_expires(&t.timer, mode);
-	if (!hrtimer_active(&t.timer))
-		t.task = NULL;
 
 	if (likely(t.task))
 		schedule();
-- 
2.0.0.rc2

