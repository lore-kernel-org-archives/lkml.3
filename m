Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaKFQof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:44:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56239 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaKFQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:44:23 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH v5 18/48] mfd: twl4030-power: Register with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:02 -0800
Message-Id: <1415292213-28652-19-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.545BA567.01DB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 109
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

Make twl4030_power_off static as it is only called from the twl4030-power
driver. Drop remove function as it is no longer needed.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: linux-omap@vger.kernel.org
Acked-by: Lee Jones <lee.jones@linaro.org>
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
- Use dev_warn instead of dev_err
- Use devm_register_power_off_handler
- Drop remove function as it is no longer needed.

 drivers/mfd/twl4030-power.c | 25 +++++++++++++++----------
 include/linux/i2c/twl.h     |  1 -
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index cf92a6d..88fd33c 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -25,9 +25,9 @@
  */
 
 #include <linux/module.h>
-#include <linux/pm.h>
 #include <linux/i2c/twl.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 
@@ -611,7 +611,7 @@ twl4030_power_configure_resources(const struct twl4030_power_data *pdata)
  * After a successful execution, TWL shuts down the power to the SoC
  * and all peripherals connected to it.
  */
-void twl4030_power_off(void)
+static void twl4030_power_off(struct power_off_handler_block *this)
 {
 	int err;
 
@@ -621,6 +621,11 @@ void twl4030_power_off(void)
 		pr_err("TWL4030 Unable to power off\n");
 }
 
+static struct power_off_handler_block twl4030_power_off_hb = {
+	.handler = twl4030_power_off,
+	.priority = POWER_OFF_PRIORITY_LOW,
+};
+
 static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
 					struct device_node *node)
 {
@@ -839,7 +844,9 @@ static int twl4030_power_probe(struct platform_device *pdev)
 	}
 
 	/* Board has to be wired properly to use this feature */
-	if (twl4030_power_use_poweroff(pdata, node) && !pm_power_off) {
+	if (twl4030_power_use_poweroff(pdata, node)) {
+		int ret;
+
 		/* Default for SEQ_OFFSYNC is set, lets ensure this */
 		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
 				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
@@ -856,7 +863,11 @@ static int twl4030_power_probe(struct platform_device *pdev)
 			}
 		}
 
-		pm_power_off = twl4030_power_off;
+		ret = devm_register_power_off_handler(&pdev->dev,
+						      &twl4030_power_off_hb);
+		if (ret)
+			dev_warn(&pdev->dev,
+				 "Failed to register power-off handler\n");
 	}
 
 relock:
@@ -870,11 +881,6 @@ relock:
 	return err;
 }
 
-static int twl4030_power_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static struct platform_driver twl4030_power_driver = {
 	.driver = {
 		.name	= "twl4030_power",
@@ -882,7 +888,6 @@ static struct platform_driver twl4030_power_driver = {
 		.of_match_table = of_match_ptr(twl4030_power_of_match),
 	},
 	.probe		= twl4030_power_probe,
-	.remove		= twl4030_power_remove,
 };
 
 module_platform_driver(twl4030_power_driver);
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 8cfb50f..f8544f1 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -680,7 +680,6 @@ struct twl4030_power_data {
 };
 
 extern int twl4030_remove_script(u8 flags);
-extern void twl4030_power_off(void);
 
 struct twl4030_codec_data {
 	unsigned int digimic_delay; /* in ms */
-- 
1.9.1

