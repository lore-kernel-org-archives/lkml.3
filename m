Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3AOGWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:22:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:42838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab3AOGWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:22:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,471,1355126400"; 
   d="scan'208";a="243888849"
Subject: [PATCH] PM / Runtime: return the right value when deferred_resume
 is true in rpm_suspend()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@sisk.pl, stern@rowland.harvard.edu
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jan 2013 23:26:11 +0800
Message-ID: <1358263571.1223.26.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the case that in rpm_suspend() and deferred_resume is true,
the rpm_resume() will be called, and if rpm_resume() return error,
at this time, the device is still in SUSPENDED state.

In this case it is still an suspend succeeding case, we should
return non-error instead of EAGAIN.

An example like below for this case:
CPU1:                                                      CPU2:
pm_runtime_get_sync()
pm_runtime_put_sync_suspend()
  rpm_suspend()
    __update_runtime_status(dev, RPM_SUSPENDING)
    rpm_callback()
        spin_unlock_irq()
          ...                                               pm_runtime_get()
                                                              spin_lock_irqsave()
          cb()                                                rpm_resume()
          ...                                                   dev->power.deferred_resume = true
                                                              spin_unlock_irqrestore()
        spin_lock_irq()
    __update_runtime_status(dev, RPM_SUSPENDED)
    rpm_resume() is called due to deferred_resume is true

Here if rpm_resume() failed in CPU1, the runtime_status is still SUSPENDED,
we should return 0 in this case.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/runtime.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 3148b10..0adc713 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -436,9 +436,11 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 
 	if (dev->power.deferred_resume) {
 		dev->power.deferred_resume = false;
-		rpm_resume(dev, 0);
-		retval = -EAGAIN;
-		goto out;
+		if (rpm_resume(dev, 0) >= 0) {
+			/* In case resuming succeeded, return EAGAIN error */
+			retval = -EAGAIN;
+			goto out;
+		}
 	}
 
 	/* Maybe the parent is now able to suspend. */
-- 
1.7.0.4



