Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab3EOQB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:01:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59432 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab3EOQBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:01:54 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [Resend/PATCHv5 3/3] arm: omap2+: omap_device: remove no_idle_on_suspend
Date: Wed, 15 May 2013 21:31:13 +0530
Message-ID: <1368633673-32308-4-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368633673-32308-1-git-send-email-sourav.poddar@ti.com>
References: <1368633673-32308-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove "no_idle_on_suspend" check, since respective
driver should be able to prevent idling of an
omap device whenever required.

Driver's can get same behavior by just returning -EBUSY
from their ->runtime_suspend only during suspend.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/omap_device.c |    9 ++-------
 arch/arm/mach-omap2/omap_device.h |   10 ----------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index e6d2307..68be532 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -170,9 +170,6 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
 			r->name = dev_name(&pdev->dev);
 	}
 
-	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
-		omap_device_disable_idle_on_suspend(pdev);
-
 	pdev->dev.pm_domain = &omap_device_pm_domain;
 
 odbfd_exit1:
@@ -621,8 +618,7 @@ static int _od_suspend_noirq(struct device *dev)
 
 	if (!ret && !pm_runtime_status_suspended(dev)) {
 		if (pm_generic_runtime_suspend(dev) == 0) {
-			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
-				omap_device_idle(pdev);
+			omap_device_idle(pdev);
 			od->flags |= OMAP_DEVICE_SUSPENDED;
 		}
 	}
@@ -638,8 +634,7 @@ static int _od_resume_noirq(struct device *dev)
 	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
 	    !pm_runtime_status_suspended(dev)) {
 		od->flags &= ~OMAP_DEVICE_SUSPENDED;
-		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
-			omap_device_enable(pdev);
+		omap_device_enable(pdev);
 		pm_generic_runtime_resume(dev);
 	}
 
diff --git a/arch/arm/mach-omap2/omap_device.h b/arch/arm/mach-omap2/omap_device.h
index 044c31d..17ca1ae 100644
--- a/arch/arm/mach-omap2/omap_device.h
+++ b/arch/arm/mach-omap2/omap_device.h
@@ -38,7 +38,6 @@ extern struct dev_pm_domain omap_device_pm_domain;
 
 /* omap_device.flags values */
 #define OMAP_DEVICE_SUSPENDED		BIT(0)
-#define OMAP_DEVICE_NO_IDLE_ON_SUSPEND	BIT(1)
 
 /**
  * struct omap_device - omap_device wrapper for platform_devices
@@ -101,13 +100,4 @@ static inline struct omap_device *to_omap_device(struct platform_device *pdev)
 {
 	return pdev ? pdev->archdata.od : NULL;
 }
-
-static inline
-void omap_device_disable_idle_on_suspend(struct platform_device *pdev)
-{
-	struct omap_device *od = to_omap_device(pdev);
-
-	od->flags |= OMAP_DEVICE_NO_IDLE_ON_SUSPEND;
-}
-
 #endif
-- 
1.7.1

