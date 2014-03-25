Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaCYIeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:34:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33389 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaCYI10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:27:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] tick: Remove code duplication in tick_handle_periodic()
Date: Tue, 25 Mar 2014 13:56:23 +0530
Message-Id: <be3481e8f3f71df694a4b43623254fc93ca51b59.1395735873.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_handle_periodic() is calling ktime_add() at two places, first before the
infinite loop and then at the end of infinite loop. We can rearrange code a bit
to fix code duplication here.

It looks quite simple and shouldn't break anything, I guess :)

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 20b2fe3..d610ae3 100644
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
 
-- 
1.7.12.rc2.18.g61b472e

