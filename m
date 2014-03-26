Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaCZABZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:01:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaCZABH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:01:07 -0400
Date: Tue, 25 Mar 2014 17:00:53 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-b97f0291a2504291aef850077f98cab68a5a2f33@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <be3481e8f3f71df694a4b43623254fc93ca51b59.1395735873.git.viresh.kumar@linaro.org>
References: <be3481e8f3f71df694a4b43623254fc93ca51b59.1395735873.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Remove code duplication in tick_handle_periodic()
Git-Commit-ID: b97f0291a2504291aef850077f98cab68a5a2f33
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

Commit-ID:  b97f0291a2504291aef850077f98cab68a5a2f33
Gitweb:     http://git.kernel.org/tip/b97f0291a2504291aef850077f98cab68a5a2f33
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 25 Mar 2014 13:56:23 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Mar 2014 00:56:49 +0100

tick: Remove code duplication in tick_handle_periodic()

tick_handle_periodic() is calling ktime_add() at two places, first before the
infinite loop and then at the end of infinite loop. We can rearrange code a bit
to fix code duplication here.

It looks quite simple and shouldn't break anything, I guess :)

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Link: http://lkml.kernel.org/r/be3481e8f3f71df694a4b43623254fc93ca51b59.1395735873.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-common.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0fec634..0156612 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -98,18 +98,19 @@ static void tick_periodic(int cpu)
 void tick_handle_periodic(struct clock_event_device *dev)
 {
 	int cpu = smp_processor_id();
-	ktime_t next;
+	ktime_t next = dev->next_event;
 
 	tick_periodic(cpu);
 
 	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
 		return;
-	/*
-	 * Setup the next period for devices, which do not have
-	 * periodic mode:
-	 */
-	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
+		/*
+		 * Setup the next period for devices, which do not have
+		 * periodic mode:
+		 */
+		next = ktime_add(next, tick_period);
+
 		if (!clockevents_program_event(dev, next, false))
 			return;
 		/*
@@ -123,7 +124,6 @@ void tick_handle_periodic(struct clock_event_device *dev)
 		 */
 		if (timekeeping_valid_for_hres())
 			tick_periodic(cpu);
-		next = ktime_add(next, tick_period);
 	}
 }
 
