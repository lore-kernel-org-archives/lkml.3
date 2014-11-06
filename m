Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaKFQ5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:57:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56315 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaKFQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:44:37 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v5 24/48] power/reset: as3722-poweroff: Register with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:08 -0800
Message-Id: <1415292213-28652-25-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.545BA575.01BC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 139
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel power-off handler instead of setting pm_power_off
directly. Register with low priority to reflect that the original code
only sets pm_power_off if it was not already set.

Drop remove function since it is no longer needed.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v5:
- Rebase to v3.18-rc3
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use define to specify poweroff handler priority
- Use devm_register_power_off_handler
- Drop remove function since it is no longer needed

 drivers/power/reset/as3722-poweroff.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/power/reset/as3722-poweroff.c b/drivers/power/reset/as3722-poweroff.c
index 6849711..bd4965b 100644
--- a/drivers/power/reset/as3722-poweroff.c
+++ b/drivers/power/reset/as3722-poweroff.c
@@ -20,28 +20,25 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 
 struct as3722_poweroff {
 	struct device *dev;
 	struct as3722 *as3722;
+	struct power_off_handler_block power_off_hb;
 };
 
-static struct as3722_poweroff *as3722_pm_poweroff;
-
-static void as3722_pm_power_off(void)
+static void as3722_power_off(struct power_off_handler_block *this)
 {
+	struct as3722_poweroff *as3722_poweroff =
+		container_of(this, struct as3722_poweroff, power_off_hb);
 	int ret;
 
-	if (!as3722_pm_poweroff) {
-		pr_err("AS3722 poweroff is not initialised\n");
-		return;
-	}
-
-	ret = as3722_update_bits(as3722_pm_poweroff->as3722,
+	ret = as3722_update_bits(as3722_poweroff->as3722,
 		AS3722_RESET_CONTROL_REG, AS3722_POWER_OFF, AS3722_POWER_OFF);
 	if (ret < 0)
-		dev_err(as3722_pm_poweroff->dev,
+		dev_err(as3722_poweroff->dev,
 			"RESET_CONTROL_REG update failed, %d\n", ret);
 }
 
@@ -63,20 +60,11 @@ static int as3722_poweroff_probe(struct platform_device *pdev)
 
 	as3722_poweroff->as3722 = dev_get_drvdata(pdev->dev.parent);
 	as3722_poweroff->dev = &pdev->dev;
-	as3722_pm_poweroff = as3722_poweroff;
-	if (!pm_power_off)
-		pm_power_off = as3722_pm_power_off;
-
-	return 0;
-}
-
-static int as3722_poweroff_remove(struct platform_device *pdev)
-{
-	if (pm_power_off == as3722_pm_power_off)
-		pm_power_off = NULL;
-	as3722_pm_poweroff = NULL;
+	as3722_poweroff->power_off_hb.handler = as3722_power_off;
+	as3722_poweroff->power_off_hb.priority = POWER_OFF_PRIORITY_LOW;
 
-	return 0;
+	return devm_register_power_off_handler(&pdev->dev,
+					      &as3722_poweroff->power_off_hb);
 }
 
 static struct platform_driver as3722_poweroff_driver = {
@@ -85,7 +73,6 @@ static struct platform_driver as3722_poweroff_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = as3722_poweroff_probe,
-	.remove = as3722_poweroff_remove,
 };
 
 module_platform_driver(as3722_poweroff_driver);
-- 
1.9.1

