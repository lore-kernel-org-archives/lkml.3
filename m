Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaKJBv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:51:57 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39043 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaKJBoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:44:15 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v6 23/48] power/reset: gpio-poweroff: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:40 -0800
Message-Id: <1415583785-6980-24-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.5460186F.0101,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 138
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

Other changes:

Drop note that there can not be an additional instance of this driver.
The original reason no longer applies, it should be obvious that there
can only be one instance of the driver if static variables are used to
reflect its state, and support for multiple instances can now be added
easily if needed by avoiding static variables.

Do not create an error message if another power-off handler has already
been registered. This is perfectly normal and acceptable.

Drop remove function since it is no longer needed.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
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
v2;
- Use define to specify poweroff handler priority
- Use devm_register_power_off_handler
- Drop remove function as it is no longer needed

 drivers/power/reset/gpio-poweroff.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/power/reset/gpio-poweroff.c b/drivers/power/reset/gpio-poweroff.c
index ce849bc..4d480d2 100644
--- a/drivers/power/reset/gpio-poweroff.c
+++ b/drivers/power/reset/gpio-poweroff.c
@@ -14,18 +14,16 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of_platform.h>
 #include <linux/module.h>
 
-/*
- * Hold configuration here, cannot be more than one instance of the driver
- * since pm_power_off itself is global.
- */
 static struct gpio_desc *reset_gpio;
 
-static void gpio_poweroff_do_poweroff(void)
+static void gpio_poweroff_do_poweroff(struct power_off_handler_block *this)
+
 {
 	BUG_ON(!reset_gpio);
 
@@ -45,17 +43,15 @@ static void gpio_poweroff_do_poweroff(void)
 	WARN_ON(1);
 }
 
+static struct power_off_handler_block gpio_power_off_hb = {
+	.handler = gpio_poweroff_do_poweroff,
+	.priority = POWER_OFF_PRIORITY_LOW,
+};
+
 static int gpio_poweroff_probe(struct platform_device *pdev)
 {
 	bool input = false;
-
-	/* If a pm_power_off function has already been added, leave it alone */
-	if (pm_power_off != NULL) {
-		dev_err(&pdev->dev,
-			"%s: pm_power_off function already registered",
-		       __func__);
-		return -EBUSY;
-	}
+	int err;
 
 	reset_gpio = devm_gpiod_get(&pdev->dev, NULL);
 	if (IS_ERR(reset_gpio))
@@ -77,16 +73,11 @@ static int gpio_poweroff_probe(struct platform_device *pdev)
 		}
 	}
 
-	pm_power_off = &gpio_poweroff_do_poweroff;
-	return 0;
-}
-
-static int gpio_poweroff_remove(struct platform_device *pdev)
-{
-	if (pm_power_off == &gpio_poweroff_do_poweroff)
-		pm_power_off = NULL;
+	err = devm_register_power_off_handler(&pdev->dev, &gpio_power_off_hb);
+	if (err)
+		dev_err(&pdev->dev, "Failed to register power-off handler\n");
 
-	return 0;
+	return err;
 }
 
 static const struct of_device_id of_gpio_poweroff_match[] = {
@@ -96,7 +87,6 @@ static const struct of_device_id of_gpio_poweroff_match[] = {
 
 static struct platform_driver gpio_poweroff_driver = {
 	.probe = gpio_poweroff_probe,
-	.remove = gpio_poweroff_remove,
 	.driver = {
 		.name = "poweroff-gpio",
 		.owner = THIS_MODULE,
-- 
1.9.1

