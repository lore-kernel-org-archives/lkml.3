Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaJUEWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:22:34 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33725 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbaJUEOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:14:05 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 22/47] power/reset: restart-poweroff: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:38 -0700
Message-Id: <1413864783-3271-23-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD8C.0136,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 128
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

Register with kernel poweroff handler instead of setting pm_power_off
directly.  Register as poweroff handler of last resort since the driver
does not really power off the system but executes a restart.

Drop remove function since it is no longer needed.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to sepcify poweroff handler priority
- Use devm_register_power_off_handler
- Drop remove function since it is no longer needed

 drivers/power/reset/restart-poweroff.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
index edd707e..e8f8e59 100644
--- a/drivers/power/reset/restart-poweroff.c
+++ b/drivers/power/reset/restart-poweroff.c
@@ -12,37 +12,31 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/notifier.h>
 #include <linux/platform_device.h>
 #include <linux/of_platform.h>
 #include <linux/module.h>
+#include <linux/pm.h>
 #include <linux/reboot.h>
-#include <asm/system_misc.h>
 
-static void restart_poweroff_do_poweroff(void)
+static int restart_poweroff_do_poweroff(struct notifier_block *this,
+					unsigned long unused1, void *unused2)
 {
 	reboot_mode = REBOOT_HARD;
 	machine_restart(NULL);
-}
-
-static int restart_poweroff_probe(struct platform_device *pdev)
-{
-	/* If a pm_power_off function has already been added, leave it alone */
-	if (pm_power_off != NULL) {
-		dev_err(&pdev->dev,
-			"pm_power_off function already registered");
-		return -EBUSY;
-	}
 
-	pm_power_off = &restart_poweroff_do_poweroff;
-	return 0;
+	return NOTIFY_DONE;
 }
 
-static int restart_poweroff_remove(struct platform_device *pdev)
-{
-	if (pm_power_off == &restart_poweroff_do_poweroff)
-		pm_power_off = NULL;
+static struct notifier_block restart_power_off_handler = {
+	.notifier_call = restart_poweroff_do_poweroff,
+	.priority = POWEROFF_PRIORITY_FALLBACK,
+};
 
-	return 0;
+static int restart_poweroff_probe(struct platform_device *pdev)
+{
+	return devm_register_power_off_handler(&pdev->dev,
+					      &restart_power_off_handler);
 }
 
 static const struct of_device_id of_restart_poweroff_match[] = {
@@ -52,7 +46,6 @@ static const struct of_device_id of_restart_poweroff_match[] = {
 
 static struct platform_driver restart_poweroff_driver = {
 	.probe = restart_poweroff_probe,
-	.remove = restart_poweroff_remove,
 	.driver = {
 		.name = "poweroff-restart",
 		.owner = THIS_MODULE,
-- 
1.9.1

