Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab3BEFOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:14:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:34742 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab3BEFOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:14:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="282833915"
Subject: [PATCH] pm: print the name of failed suspend function for platform
 device
From: fli24 <fei.li@intel.com>
To: gregkh@linuxfoundation.org, rjw@sisk.pl, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Feb 2013 13:13:03 +0800
Message-ID: <1360041183.15311.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Print more info when platform device suspend function failed.
Without this patch, we can not get the real platform device suspend
API info.

Example without this patch:
pm_op(): platform_pm_suspend+0x0/0x50 returns -11
PM: Device power.0 failed to suspend: error -11

And with this patch:
platform_pm_suspend(): power_suspend+0x0/0x30 returns -11
pm_op(): platform_pm_suspend+0x0/0x80 returns -11
PM: Device power.0 failed to suspend: error -11

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 drivers/base/platform.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c0b8df3..96a452a 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -747,8 +747,10 @@ static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 	struct platform_device *pdev = to_platform_device(dev);
 	int ret = 0;
 
-	if (dev->driver && pdrv->suspend)
+	if (dev->driver && pdrv->suspend) {
 		ret = pdrv->suspend(pdev, mesg);
+		suspend_report_result(pdrv->suspend, ret);
+	}
 
 	return ret;
 }
@@ -778,10 +780,13 @@ int platform_pm_suspend(struct device *dev)
 		return 0;
 
 	if (drv->pm) {
-		if (drv->pm->suspend)
+		if (drv->pm->suspend) {
 			ret = drv->pm->suspend(dev);
+			suspend_report_result(drv->pm->suspend, ret);
+		}
 	} else {
 		ret = platform_legacy_suspend(dev, PMSG_SUSPEND);
+		suspend_report_result(platform_legacy_suspend, ret);
 	}
 
 	return ret;
@@ -818,10 +823,13 @@ int platform_pm_freeze(struct device *dev)
 		return 0;
 
 	if (drv->pm) {
-		if (drv->pm->freeze)
+		if (drv->pm->freeze) {
 			ret = drv->pm->freeze(dev);
+			suspend_report_result(drv->pm->freeze, ret);
+		}
 	} else {
 		ret = platform_legacy_suspend(dev, PMSG_FREEZE);
+		suspend_report_result(platform_legacy_suspend, ret);
 	}
 
 	return ret;
@@ -854,10 +862,13 @@ int platform_pm_poweroff(struct device *dev)
 		return 0;
 
 	if (drv->pm) {
-		if (drv->pm->poweroff)
+		if (drv->pm->poweroff) {
 			ret = drv->pm->poweroff(dev);
+			suspend_report_result(drv->pm->poweroff, ret);
+		}
 	} else {
 		ret = platform_legacy_suspend(dev, PMSG_HIBERNATE);
+		suspend_report_result(platform_legacy_suspend, ret);
 	}
 
 	return ret;
-- 
1.7.4.1





