Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3GDFgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:36:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:26435 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab3GDFgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="360319281"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, hpa@linux.intel.com, tim.c.chen@linux.intel.com
Cc: linux-kernel@vger.kernel.org, andi.kleen@intel.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu
Subject: [PATCH 3/3] clocksource: fix can not set tsc as clocksource bug
Date: Thu,  4 Jul 2013 13:34:16 +0800
Message-Id: <1372916056-24301-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5d33b883aed81c6fbcd09c6f7c3619eee850a7e2
    clocksource: Always verify highres capability

This commit will reject a clock to be system clocksource if it has no
CLOCK_SOURCE_VALID_FOR_HRES flags. Then the tsc to be rejected as
clocksource, because this flag for tsc is set in clocksource_watchdog
which run after the tsc register.
TSC registered in tsc_refine_calibration_work() and started the watchdog
at that time.

This patch re-select the clocksource after we make sure the tsc has this
flag. Fixed this bug.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/time/clocksource.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9d6c333..3ad9f29 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -308,6 +308,8 @@ static void clocksource_watchdog(unsigned long data)
 			 * transition into high-res mode:
 			 */
 			tick_clock_notify();
+			if (finished_booting)
+				schedule_work(&watchdog_work);
 		}
 	}
 
@@ -404,6 +406,7 @@ static void clocksource_dequeue_watchdog(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
+static void clocksource_select(void);
 static int clocksource_watchdog_kthread(void *data)
 {
 	struct clocksource *cs, *tmp;
@@ -412,11 +415,14 @@ static int clocksource_watchdog_kthread(void *data)
 
 	mutex_lock(&clocksource_mutex);
 	spin_lock_irqsave(&watchdog_lock, flags);
-	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
+	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
 			list_del_init(&cs->wd_list);
 			list_add(&cs->wd_list, &unstable);
 		}
+		if (cs->flags & CLOCK_SOURCE_VALID_FOR_HRES)
+			clocksource_select();
+	}
 	/* Check if the watchdog timer needs to be stopped. */
 	clocksource_stop_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
-- 
1.7.12

