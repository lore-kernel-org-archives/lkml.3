Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaFGBcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36097 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, arvind.chauhan@arm.com,
        "Viresh Kumar" <viresh.kumar@linaro.org>, linaro-networking@linaro.org,
        "Thomas Gleixner" <tglx@linutronix.de>, fweisbec@gmail.com,
        linaro-kernel@lists.linaro.org
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.60149753@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 64/92] hrtimer: Set expiry time before switch_hrtimer_base()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/hrtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -980,11 +980,8 @@ int __hrtimer_start_range_ns(struct hrti
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
@@ -999,6 +996,9 @@ int __hrtimer_start_range_ns(struct hrti
 
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);

