Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaKJBoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:44:04 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:38990 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaKJBn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:43:59 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH v6 16/48] mfd: tps6586x: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:33 -0800
Message-Id: <1415583785-6980-17-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5460185F.013E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 103
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

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: linux-omap@vger.kernel.org
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
- Use define to specify poweroff handler priority
- Use dev_warn instead of dev_err

 drivers/mfd/tps6586x.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 8e1dbc4..f11165f 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/regmap.h>
 #include <linux/of.h>
 
@@ -133,6 +134,8 @@ struct tps6586x {
 	u32			irq_en;
 	u8			mask_reg[5];
 	struct irq_domain	*irq_domain;
+
+	struct power_off_handler_block power_off_hb;
 };
 
 static inline struct tps6586x *dev_to_tps6586x(struct device *dev)
@@ -472,13 +475,15 @@ static const struct regmap_config tps6586x_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static struct device *tps6586x_dev;
-static void tps6586x_power_off(void)
+static void tps6586x_power_off(struct power_off_handler_block *this)
 {
-	if (tps6586x_clr_bits(tps6586x_dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT))
+	struct tps6586x *tps6586x = container_of(this, struct tps6586x,
+						 power_off_hb);
+
+	if (tps6586x_clr_bits(tps6586x->dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT))
 		return;
 
-	tps6586x_set_bits(tps6586x_dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
+	tps6586x_set_bits(tps6586x->dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
 }
 
 static void tps6586x_print_version(struct i2c_client *client, int version)
@@ -575,9 +580,13 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
 		goto err_add_devs;
 	}
 
-	if (pdata->pm_off && !pm_power_off) {
-		tps6586x_dev = &client->dev;
-		pm_power_off = tps6586x_power_off;
+	if (pdata->pm_off) {
+		tps6586x->power_off_hb.handler = tps6586x_power_off;
+		tps6586x->power_off_hb.priority = POWER_OFF_PRIORITY_LOW;
+		ret = register_power_off_handler(&tps6586x->power_off_hb);
+		if (ret)
+			dev_warn(&client->dev,
+				 "failed to register power-off handler\n");
 	}
 
 	return 0;
@@ -594,6 +603,8 @@ static int tps6586x_i2c_remove(struct i2c_client *client)
 {
 	struct tps6586x *tps6586x = i2c_get_clientdata(client);
 
+	unregister_power_off_handler(&tps6586x->power_off_hb);
+
 	tps6586x_remove_subdevs(tps6586x);
 	mfd_remove_devices(tps6586x->dev);
 	if (client->irq)
-- 
1.9.1

