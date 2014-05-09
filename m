Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaEIIk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:40:59 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:61776 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaEIIk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:40:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] hrtimer: reprogram event for expires=KTIME_MAX in hrtimer_force_reprogram()
Date: Fri,  9 May 2014 14:10:22 +0530
Message-Id: <189ea71f724d00995a73e63c8ed9ff5b7857a69d.1399623699.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1399623699.git.viresh.kumar@linaro.org>
References: <cover.1399623699.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1399623699.git.viresh.kumar@linaro.org>
References: <cover.1399623699.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hrtimer_force_reprogram(), we are reprogramming event device only if the next
timer event is before KTIME_MAX. But what if it is equal to KTIME_MAX? As we
aren't reprogramming it again, it will be set to the last value it was, probably
tick interval, i.e. few milliseconds.

And we will get a interrupt due to that, wouldn't have any hrtimers to service
and return without doing much. But the implementation of event device's driver
may make it more stupid. For example: drivers/clocksource/arm_arch_timer.c
disables the event device only on SHUTDOWN/UNUSED requests in set-mode.
Otherwise, it will keep giving interrupts at tick interval even if
hrtimer_interrupt() didn't reprogram tick..

To get this fixed, lets reprogram event device even for KTIME_MAX, so that the
timer is scheduled for long enough.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6b715c0..b21085c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -591,8 +591,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 	if (cpu_base->hang_detected)
 		return;
 
-	if (cpu_base->expires_next.tv64 != KTIME_MAX)
-		tick_program_event(cpu_base->expires_next, 1);
+	tick_program_event(cpu_base->expires_next, 1);
 }
 
 /*
-- 
2.0.0.rc2

