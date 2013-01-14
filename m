Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3ANIpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:45:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:12930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab3ANIpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:45:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,466,1355126400"; 
   d="scan'208";a="271665643"
Subject: [PATCH] PM / Runtime: Fix the twice judgement in
 rpm_suspend/resume()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jan 2013 01:48:18 +0800
Message-ID: <1358185698.1223.13.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In function rpm_suspend/resume(), when going into the for(;;),
the pre-condition judgement has been done, and the variable runtime_status
are always protected by &power.lock, so it is not necessary to judge
them again before unlock_irq &power.lock in for(;;).

This patch clean them up.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/runtime.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 3148b10..32d6497 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -377,14 +377,14 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 		for (;;) {
 			prepare_to_wait(&dev->power.wait_queue, &wait,
 					TASK_UNINTERRUPTIBLE);
-			if (dev->power.runtime_status != RPM_SUSPENDING)
-				break;
 
 			spin_unlock_irq(&dev->power.lock);
 
 			schedule();
 
 			spin_lock_irq(&dev->power.lock);
+			if (dev->power.runtime_status != RPM_SUSPENDING)
+				break;
 		}
 		finish_wait(&dev->power.wait_queue, &wait);
 		goto repeat;
@@ -557,15 +557,15 @@ static int rpm_resume(struct device *dev, int rpmflags)
 		for (;;) {
 			prepare_to_wait(&dev->power.wait_queue, &wait,
 					TASK_UNINTERRUPTIBLE);
-			if (dev->power.runtime_status != RPM_RESUMING
-			    && dev->power.runtime_status != RPM_SUSPENDING)
-				break;
 
 			spin_unlock_irq(&dev->power.lock);
 
 			schedule();
 
 			spin_lock_irq(&dev->power.lock);
+			if (dev->power.runtime_status != RPM_RESUMING
+			    && dev->power.runtime_status != RPM_SUSPENDING)
+				break;
 		}
 		finish_wait(&dev->power.wait_queue, &wait);
 		goto repeat;
@@ -989,15 +989,15 @@ static void __pm_runtime_barrier(struct device *dev)
 		for (;;) {
 			prepare_to_wait(&dev->power.wait_queue, &wait,
 					TASK_UNINTERRUPTIBLE);
-			if (dev->power.runtime_status != RPM_SUSPENDING
-			    && dev->power.runtime_status != RPM_RESUMING
-			    && !dev->power.idle_notification)
-				break;
 			spin_unlock_irq(&dev->power.lock);
 
 			schedule();
 
 			spin_lock_irq(&dev->power.lock);
+			if (dev->power.runtime_status != RPM_SUSPENDING
+			    && dev->power.runtime_status != RPM_RESUMING
+			    && !dev->power.idle_notification)
+				break;
 		}
 		finish_wait(&dev->power.wait_queue, &wait);
 	}
-- 
1.7.0.4



