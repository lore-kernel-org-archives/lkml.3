Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaJUENs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:13:48 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33619 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaJUENo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:44 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 13/47] mfd: max8907: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:29 -0700
Message-Id: <1413864783-3271-14-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5445DD78.000D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 72
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

Note that this patch fixes a problem on driver unload as side effect:
The old code did not restore or clean up pm_power_off on remove,
meaning the pointer was left in an undefined state.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority
- Use dev_warn instead of dev_err

 drivers/mfd/max8907.c       | 24 ++++++++++++++++++------
 include/linux/mfd/max8907.h |  2 ++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
index 232749c..daacdbc 100644
--- a/drivers/mfd/max8907.c
+++ b/drivers/mfd/max8907.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/pm.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
@@ -177,11 +178,16 @@ static const struct regmap_irq_chip max8907_rtc_irq_chip = {
 	.num_irqs = ARRAY_SIZE(max8907_rtc_irqs),
 };
 
-static struct max8907 *max8907_pm_off;
-static void max8907_power_off(void)
+static int max8907_power_off(struct notifier_block *this, unsigned long unused1,
+			     void *unused2)
 {
-	regmap_update_bits(max8907_pm_off->regmap_gen, MAX8907_REG_RESET_CNFG,
+	struct max8907 *max8907 = container_of(this, struct max8907,
+					       poweroff_nb);
+
+	regmap_update_bits(max8907->regmap_gen, MAX8907_REG_RESET_CNFG,
 			MAX8907_MASK_POWER_OFF, MAX8907_MASK_POWER_OFF);
+
+	return NOTIFY_DONE;
 }
 
 static int max8907_i2c_probe(struct i2c_client *i2c,
@@ -267,9 +273,13 @@ static int max8907_i2c_probe(struct i2c_client *i2c,
 		goto err_add_devices;
 	}
 
-	if (pm_off && !pm_power_off) {
-		max8907_pm_off = max8907;
-		pm_power_off = max8907_power_off;
+	if (pm_off) {
+		max8907->poweroff_nb.notifier_call = max8907_power_off;
+		max8907->poweroff_nb.priority = POWEROFF_PRIORITY_LOW;
+		ret = register_power_off_handler(&max8907->poweroff_nb);
+		if (ret)
+			dev_warn(&i2c->dev,
+				 "Failed to register poweroff handler");
 	}
 
 	return 0;
@@ -293,6 +303,8 @@ static int max8907_i2c_remove(struct i2c_client *i2c)
 {
 	struct max8907 *max8907 = i2c_get_clientdata(i2c);
 
+	unregister_power_off_handler(&max8907->poweroff_nb);
+
 	mfd_remove_devices(max8907->dev);
 
 	regmap_del_irq_chip(max8907->i2c_gen->irq, max8907->irqc_rtc);
diff --git a/include/linux/mfd/max8907.h b/include/linux/mfd/max8907.h
index b06f7a6..016428e 100644
--- a/include/linux/mfd/max8907.h
+++ b/include/linux/mfd/max8907.h
@@ -13,6 +13,7 @@
 #define __LINUX_MFD_MAX8907_H
 
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 #include <linux/pm.h>
 
 #define MAX8907_GEN_I2C_ADDR		(0x78 >> 1)
@@ -247,6 +248,7 @@ struct max8907 {
 	struct regmap_irq_chip_data	*irqc_chg;
 	struct regmap_irq_chip_data	*irqc_on_off;
 	struct regmap_irq_chip_data	*irqc_rtc;
+	struct notifier_block		poweroff_nb;
 };
 
 #endif
-- 
1.9.1

