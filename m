Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab3CRGAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 02:00:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:18847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3CRGAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 02:00:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,862,1355126400"; 
   d="scan'208";a="280879110"
Subject: [PATCH] pm: print the name of failed suspend function for platform
 device
From: Li Fei <fei.li@intel.com>
To: gregkh@linuxfoundation.org, rjw@sisk.pl, akpm@linux-foundation.org,
        ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Mar 2013 13:58:23 +0800
Message-ID: <1363586303.9792.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
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




