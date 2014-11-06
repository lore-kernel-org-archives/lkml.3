Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaKFQon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:44:43 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56266 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaKFQod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:44:33 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v5 22/48] power/reset: restart-poweroff: Register with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:06 -0800
Message-Id: <1415292213-28652-23-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.545BA570.0267,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 127
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
directly.  Register as power-off handler of last resort since the driver
does not really power off the system but executes a restart.

Drop remove function since it is no longer needed.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Andrew Lunn <andrew@lunn.ch>
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
- Use define to sepcify poweroff handler priority
- Use devm_register_power_off_handler
- Drop remove function since it is no longer needed

 drivers/power/reset/restart-poweroff.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
index edd707e..ef2a602 100644
--- a/drivers/power/reset/restart-poweroff.c
+++ b/drivers/power/reset/restart-poweroff.c
@@ -15,34 +15,24 @@
 #include <linux/platform_device.h>
 #include <linux/of_platform.h>
 #include <linux/module.h>
+#include <linux/pm.h>
 #include <linux/reboot.h>
-#include <asm/system_misc.h>
 
-static void restart_poweroff_do_poweroff(void)
+static void restart_poweroff_do_poweroff(struct power_off_handler_block *this)
 {
 	reboot_mode = REBOOT_HARD;
 	machine_restart(NULL);
 }
 
-static int restart_poweroff_probe(struct platform_device *pdev)
-{
-	/* If a pm_power_off function has already been added, leave it alone */
-	if (pm_power_off != NULL) {
-		dev_err(&pdev->dev,
-			"pm_power_off function already registered");
-		return -EBUSY;
-	}
-
-	pm_power_off = &restart_poweroff_do_poweroff;
-	return 0;
-}
+static struct power_off_handler_block restart_power_off_handler = {
+	.handler = restart_poweroff_do_poweroff,
+	.priority = POWER_OFF_PRIORITY_FALLBACK,
+};
 
-static int restart_poweroff_remove(struct platform_device *pdev)
+static int restart_poweroff_probe(struct platform_device *pdev)
 {
-	if (pm_power_off == &restart_poweroff_do_poweroff)
-		pm_power_off = NULL;
-
-	return 0;
+	return devm_register_power_off_handler(&pdev->dev,
+					      &restart_power_off_handler);
 }
 
 static const struct of_device_id of_restart_poweroff_match[] = {
@@ -52,7 +42,6 @@ static const struct of_device_id of_restart_poweroff_match[] = {
 
 static struct platform_driver restart_poweroff_driver = {
 	.probe = restart_poweroff_probe,
-	.remove = restart_poweroff_remove,
 	.driver = {
 		.name = "poweroff-restart",
 		.owner = THIS_MODULE,
-- 
1.9.1

