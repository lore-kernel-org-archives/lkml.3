Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaJUEN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:13:56 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33668 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaJUENx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:53 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 17/47] mfd: tps65910: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:33 -0700
Message-Id: <1413864783-3271-18-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5445DD80.0122,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 99
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

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority
- Use dev_warn instead of dev_err

 drivers/mfd/tps65910.c       | 27 ++++++++++++++++++---------
 include/linux/mfd/tps65910.h |  3 +++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 7612d89..88ea108 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -23,6 +23,8 @@
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/mfd/core.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/regmap.h>
 #include <linux/mfd/tps65910.h>
 #include <linux/of.h>
@@ -437,19 +439,20 @@ struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 }
 #endif
 
-static struct i2c_client *tps65910_i2c_client;
-static void tps65910_power_off(void)
+static int tps65910_power_off(struct notifier_block *this,
+			      unsigned long unused1, void *unused2)
 {
-	struct tps65910 *tps65910;
-
-	tps65910 = dev_get_drvdata(&tps65910_i2c_client->dev);
+	struct tps65910 *tps65910 = container_of(this, struct tps65910,
+						 poweroff_nb);
 
 	if (tps65910_reg_set_bits(tps65910, TPS65910_DEVCTRL,
 			DEVCTRL_PWR_OFF_MASK) < 0)
-		return;
+		return NOTIFY_DONE;
 
 	tps65910_reg_clear_bits(tps65910, TPS65910_DEVCTRL,
 			DEVCTRL_DEV_ON_MASK);
+
+	return NOTIFY_DONE;
 }
 
 static int tps65910_i2c_probe(struct i2c_client *i2c,
@@ -505,9 +508,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910_ck32k_init(tps65910, pmic_plat_data);
 	tps65910_sleepinit(tps65910, pmic_plat_data);
 
-	if (pmic_plat_data->pm_off && !pm_power_off) {
-		tps65910_i2c_client = i2c;
-		pm_power_off = tps65910_power_off;
+	if (pmic_plat_data->pm_off) {
+		tps65910->poweroff_nb.notifier_call = tps65910_power_off;
+		tps65910->poweroff_nb.priority = POWEROFF_PRIORITY_LOW;
+		ret = register_power_off_handler(&tps65910->poweroff_nb);
+		if (ret)
+			dev_warn(&i2c->dev,
+				 "failed to register poweroff handler\n");
 	}
 
 	ret = mfd_add_devices(tps65910->dev, -1,
@@ -527,6 +534,8 @@ static int tps65910_i2c_remove(struct i2c_client *i2c)
 {
 	struct tps65910 *tps65910 = i2c_get_clientdata(i2c);
 
+	unregister_power_off_handler(&tps65910->poweroff_nb);
+
 	tps65910_irq_exit(tps65910);
 	mfd_remove_devices(tps65910->dev);
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 6483a6f..65cae2c 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -905,6 +905,9 @@ struct tps65910 {
 	/* IRQ Handling */
 	int chip_irq;
 	struct regmap_irq_chip_data *irq_data;
+
+	/* Poweroff handling */
+	struct notifier_block poweroff_nb;
 };
 
 struct tps65910_platform_data {
-- 
1.9.1

