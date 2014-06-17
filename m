Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966053AbaFQVrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:47:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965975AbaFQVrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linaro-networking@linaro.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 108/212] hrtimer: Set expiry time before switch_hrtimer_base()
Date: Tue, 17 Jun 2014 14:43:22 -0700
Message-Id: <1403041506-13646-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 84ea7fe37908254c3bd90910921f6e1045c1747a upstream.

switch_hrtimer_base() calls hrtimer_check_target() which ensures that
we do not migrate a timer to a remote cpu if the timer expires before
the current programmed expiry time on that remote cpu.

But __hrtimer_start_range_ns() calls switch_hrtimer_base() before the
new expiry time is set. So the sanity check in hrtimer_check_target()
is operating on stale or even uninitialized data.

Update expiry time before calling switch_hrtimer_base().

[ tglx: Rewrote changelog once again ]

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: linaro-networking@linaro.org
Cc: fweisbec@gmail.com
Cc: arvind.chauhan@arm.com
Link: http://lkml.kernel.org/r/81999e148745fc51bbcd0615823fbab9b2e87e23.1399882253.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/hrtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6de65d8..aa14922 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1002,11 +1002,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	/* Remove an active timer from the queue: */
 	ret = remove_hrtimer(timer, base);
 
-	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
-
 	if (mode & HRTIMER_MODE_REL) {
-		tim = ktime_add_safe(tim, new_base->get_time());
+		tim = ktime_add_safe(tim, base->get_time());
 		/*
 		 * CONFIG_TIME_LOW_RES is a temporary way for architectures
 		 * to signal that they simply return xtime in
@@ -1021,6 +1018,9 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
-- 
1.9.1

