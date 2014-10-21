Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaJUENq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:13:46 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33606 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaJUENm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:42 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 12/47] mfd: ab8500-sysctrl: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:28 -0700
Message-Id: <1413864783-3271-13-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=1.5
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5445DD75.0194,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 66
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
directly. Register with low priority to reflect that the original code
only sets pm_power_off if it was not already set.

sysctrl_dev is set prior to poweroff handler registration, and the
poweroff handler is unregistered prior to clearing sysrctrl_dev.
It is therefore not necessary to check if sysctrl_dev is NULL in the
poweroff handler, and the check was removed. Setting sysctrl_dev to NULL
in the remove function was also removed as unnecessary. With those changes,
devm_register_power_off_handler can be used to register the poeroff handler.
The now empty remove function was retained since the ab8500_restart function,
which is currently unused, would likely need some cleanup if it was ever used.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority
- Use devm_register_power_off_handler
- Use dev_warn instead of dev_err
- Since we use devm_register_power_off_handler,
  we need to check if sysctrl_dev in the poweroff handler to avoid
  a race condition on unload, so this check is no longer removed

 drivers/mfd/ab8500-sysctrl.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 8e0dae5..dc634d5 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -6,6 +6,7 @@
 
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/reboot.h>
@@ -23,7 +24,8 @@
 
 static struct device *sysctrl_dev;
 
-static void ab8500_power_off(void)
+static int ab8500_power_off(struct notifier_block *this, unsigned long unused1,
+			    void *unused2)
 {
 	sigset_t old;
 	sigset_t all;
@@ -36,7 +38,7 @@ static void ab8500_power_off(void)
 
 	if (sysctrl_dev == NULL) {
 		pr_err("%s: sysctrl not initialized\n", __func__);
-		return;
+		return NOTIFY_DONE;
 	}
 
 	/*
@@ -83,8 +85,15 @@ shutdown:
 					 AB8500_STW4500CTRL1_SWRESET4500N);
 		(void)sigprocmask(SIG_SETMASK, &old, NULL);
 	}
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block ab8500_poweroff_nb = {
+	.notifier_call = ab8500_power_off,
+	.priority = POWEROFF_PRIORITY_LOW,
+};
+
 /*
  * Use the AB WD to reset the platform. It will perform a hard
  * reset instead of a soft reset. Write the reset reason to
@@ -185,6 +194,7 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *plat;
 	struct ab8500_sysctrl_platform_data *pdata;
+	int err;
 
 	plat = dev_get_platdata(pdev->dev.parent);
 
@@ -193,8 +203,9 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 
 	sysctrl_dev = &pdev->dev;
 
-	if (!pm_power_off)
-		pm_power_off = ab8500_power_off;
+	err = devm_register_power_off_handler(sysctrl_dev, &ab8500_poweroff_nb);
+	if (err)
+		dev_warn(&pdev->dev, "Failed to register poweroff handler\n");
 
 	pdata = plat->sysctrl;
 	if (pdata) {
@@ -228,9 +239,6 @@ static int ab8500_sysctrl_remove(struct platform_device *pdev)
 {
 	sysctrl_dev = NULL;
 
-	if (pm_power_off == ab8500_power_off)
-		pm_power_off = NULL;
-
 	return 0;
 }
 
-- 
1.9.1

