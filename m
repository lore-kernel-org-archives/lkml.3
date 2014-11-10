Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKJBy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:54:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:38954 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaKJBnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:43:51 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 12/48] mfd: ab8500-sysctrl: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:29 -0800
Message-Id: <1415583785-6980-13-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=1.5
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54601856.0178,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 81
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

sysctrl_dev is set prior to power-off handler registration, and the
power-off handler is unregistered prior to clearing sysrctrl_dev.
It is therefore not necessary to check if sysctrl_dev is NULL in the
power-off handler, and the check was removed. Setting sysctrl_dev to NULL
in the remove function was also removed as unnecessary. With those changes,
devm_register_power_off_handler can be used to register the poeroff handler.
The now empty remove function was retained since the ab8500_restart function,
which is currently unused, would likely need some cleanup if it was ever used.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- Moved ab8500_power_off_hb to avoid conflict in -next.
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
v2:
- Use define to specify poweroff handler priority
- Use devm_register_power_off_handler
- Use dev_warn instead of dev_err
- Since we use devm_register_power_off_handler,
  we need to check if sysctrl_dev in the poweroff handler to avoid
  a race condition on unload, so this check is no longer removed

 drivers/mfd/ab8500-sysctrl.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 8e0dae5..064821e 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -23,7 +23,7 @@
 
 static struct device *sysctrl_dev;
 
-static void ab8500_power_off(void)
+static void ab8500_power_off(struct power_off_handler_block *this)
 {
 	sigset_t old;
 	sigset_t all;
@@ -180,11 +180,17 @@ int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
 }
 EXPORT_SYMBOL(ab8500_sysctrl_write);
 
+static struct power_off_handler_block ab8500_power_off_hb = {
+	.handler = ab8500_power_off,
+	.priority = POWER_OFF_PRIORITY_LOW,
+};
+
 static int ab8500_sysctrl_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *plat;
 	struct ab8500_sysctrl_platform_data *pdata;
+	int err;
 
 	plat = dev_get_platdata(pdev->dev.parent);
 
@@ -193,8 +199,10 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 
 	sysctrl_dev = &pdev->dev;
 
-	if (!pm_power_off)
-		pm_power_off = ab8500_power_off;
+	err = devm_register_power_off_handler(sysctrl_dev,
+					      &ab8500_power_off_hb);
+	if (err)
+		dev_warn(&pdev->dev, "Failed to register power-off handler\n");
 
 	pdata = plat->sysctrl;
 	if (pdata) {
@@ -228,9 +236,6 @@ static int ab8500_sysctrl_remove(struct platform_device *pdev)
 {
 	sysctrl_dev = NULL;
 
-	if (pm_power_off == ab8500_power_off)
-		pm_power_off = NULL;
-
 	return 0;
 }
 
-- 
1.9.1

