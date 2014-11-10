Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaKJBoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:44:12 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39015 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaKJBoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:44:06 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Zhang Qing <zhangqing@rock-chips.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v6 19/48] mfd: rk808: Register power-off handler with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:36 -0800
Message-Id: <1415583785-6980-20-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54601866.00B6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 118
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

Cc: Chris Zhong <zyw@rock-chips.com>
Cc: Zhang Qing <zhangqing@rock-chips.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
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
v2:
- New patch

 drivers/mfd/rk808.c       | 26 ++++++++++++--------------
 include/linux/mfd/rk808.h |  2 ++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
index bd02150..93ffcf0 100644
--- a/drivers/mfd/rk808.c
+++ b/drivers/mfd/rk808.c
@@ -21,6 +21,7 @@
 #include <linux/mfd/rk808.h>
 #include <linux/mfd/core.h>
 #include <linux/module.h>
+#include <linux/pm.h>
 #include <linux/regmap.h>
 
 struct rk808_reg_data {
@@ -147,23 +148,16 @@ static struct regmap_irq_chip rk808_irq_chip = {
 	.init_ack_masked = true,
 };
 
-static struct i2c_client *rk808_i2c_client;
-static void rk808_device_shutdown(void)
+static void rk808_device_shutdown(struct power_off_handler_block *this)
 {
+	struct rk808 *rk808 = container_of(this, struct rk808, power_off_hb);
 	int ret;
-	struct rk808 *rk808 = i2c_get_clientdata(rk808_i2c_client);
-
-	if (!rk808) {
-		dev_warn(&rk808_i2c_client->dev,
-			 "have no rk808, so do nothing here\n");
-		return;
-	}
 
 	ret = regmap_update_bits(rk808->regmap,
 				 RK808_DEVCTRL_REG,
 				 DEV_OFF_RST, DEV_OFF_RST);
 	if (ret)
-		dev_err(&rk808_i2c_client->dev, "power off error!\n");
+		dev_err(&rk808->i2c->dev, "power off error!\n");
 }
 
 static int rk808_probe(struct i2c_client *client,
@@ -222,9 +216,14 @@ static int rk808_probe(struct i2c_client *client,
 
 	pm_off = of_property_read_bool(np,
 				"rockchip,system-power-controller");
-	if (pm_off && !pm_power_off) {
-		rk808_i2c_client = client;
-		pm_power_off = rk808_device_shutdown;
+	if (pm_off) {
+		rk808->power_off_hb.handler = rk808_device_shutdown;
+		rk808->power_off_hb.priority = POWER_OFF_PRIORITY_LOW;
+		ret = devm_register_power_off_handler(&client->dev,
+						      &rk808->power_off_hb);
+		if (ret)
+			dev_warn(&client->dev,
+				 "Failed to register power-off handler\n");
 	}
 
 	return 0;
@@ -240,7 +239,6 @@ static int rk808_remove(struct i2c_client *client)
 
 	regmap_del_irq_chip(client->irq, rk808->irq_data);
 	mfd_remove_devices(&client->dev);
-	pm_power_off = NULL;
 
 	return 0;
 }
diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
index fb09312..a6619f2 100644
--- a/include/linux/mfd/rk808.h
+++ b/include/linux/mfd/rk808.h
@@ -19,6 +19,7 @@
 #ifndef __LINUX_REGULATOR_rk808_H
 #define __LINUX_REGULATOR_rk808_H
 
+#include <linux/pm.h>
 #include <linux/regulator/machine.h>
 #include <linux/regmap.h>
 
@@ -192,5 +193,6 @@ struct rk808 {
 	struct i2c_client *i2c;
 	struct regmap_irq_chip_data *irq_data;
 	struct regmap *regmap;
+	struct power_off_handler_block power_off_hb;
 };
 #endif /* __LINUX_REGULATOR_rk808_H */
-- 
1.9.1

