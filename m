Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaFEAlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:41:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaFDXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linaro-networking@linaro.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 052/228] hrtimer: Set expiry time before switch_hrtimer_base()
Date: Wed,  4 Jun 2014 16:21:21 -0700
Message-Id: <20140604232349.750287014@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/hrtimer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1003,11 +1003,8 @@ int __hrtimer_start_range_ns(struct hrti
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
@@ -1022,6 +1019,9 @@ int __hrtimer_start_range_ns(struct hrti
 
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);


