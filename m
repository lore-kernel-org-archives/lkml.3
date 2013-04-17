Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966221Ab3DQLfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:35:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53283 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965979Ab3DQLfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:35:10 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 4/6] arm: mach-omap2: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check
Date: Wed, 17 Apr 2013 17:04:25 +0530
Message-ID: <1366198467-6757-5-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since UART was the only one making
use of it. Now serial core/driver takes care of the case when "no_console_suspend" 
is used in the bootargs and you need to keep the clock enable for console even while suspend.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/mach-omap2/omap_device.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index 381be7a..d6dce8f 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -620,11 +620,8 @@ static int _od_suspend_noirq(struct device *dev)
 	ret = pm_generic_suspend_noirq(dev);
 
 	if (!ret && !pm_runtime_status_suspended(dev)) {
-		if (pm_generic_runtime_suspend(dev) == 0) {
-			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
-				omap_device_idle(pdev);
+		if (pm_generic_runtime_suspend(dev) == 0)
 			od->flags |= OMAP_DEVICE_SUSPENDED;
-		}
 	}
 
 	return ret;
@@ -638,8 +635,6 @@ static int _od_resume_noirq(struct device *dev)
 	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
 	    !pm_runtime_status_suspended(dev)) {
 		od->flags &= ~OMAP_DEVICE_SUSPENDED;
-		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
-			omap_device_enable(pdev);
 		pm_generic_runtime_resume(dev);
 	}
 
-- 
1.7.1

