Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaELIwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:52:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaELIw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:52:29 -0400
Date: Mon, 12 May 2014 01:51:58 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-84ea7fe37908254c3bd90910921f6e1045c1747a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <81999e148745fc51bbcd0615823fbab9b2e87e23.1399882253.git.viresh.kumar@linaro.org>
References: <81999e148745fc51bbcd0615823fbab9b2e87e23.1399882253.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer:
  Set expiry time before switch_hrtimer_base()
Git-Commit-ID: 84ea7fe37908254c3bd90910921f6e1045c1747a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84ea7fe37908254c3bd90910921f6e1045c1747a
Gitweb:     http://git.kernel.org/tip/84ea7fe37908254c3bd90910921f6e1045c1747a
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Mon, 12 May 2014 13:42:29 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 12 May 2014 10:47:39 +0200

hrtimer: Set expiry time before switch_hrtimer_base()

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6b715c0..e0501fe 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -990,11 +990,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
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
@@ -1009,6 +1006,9 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
