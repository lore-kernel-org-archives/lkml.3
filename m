Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaJUEWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:22:35 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33705 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbaJUEN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:59 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 20/47] mfd: rn5t618: Register poweroff handler with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:36 -0700
Message-Id: <1413864783-3271-21-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD87.00F5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 116
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

Cc: Beniamino Galvani <b.galvani@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: New patch

 drivers/mfd/rn5t618.c       | 32 ++++++++++++++++----------------
 include/linux/mfd/rn5t618.h |  2 ++
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/rn5t618.c b/drivers/mfd/rn5t618.c
index 6668571..045cd43 100644
--- a/drivers/mfd/rn5t618.c
+++ b/drivers/mfd/rn5t618.c
@@ -15,6 +15,8 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/rn5t618.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/regmap.h>
 
 static const struct mfd_cell rn5t618_cells[] = {
@@ -47,16 +49,20 @@ static const struct regmap_config rn5t618_regmap_config = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
-static struct rn5t618 *rn5t618_pm_power_off;
-
-static void rn5t618_power_off(void)
+static int rn5t618_power_off(struct notifier_block *this,
+			     unsigned long unused1, void *unused2)
 {
+	struct rn5t618 *rn5t618 = container_of(this, struct rn5t618,
+					       poweroff_nb);
+
 	/* disable automatic repower-on */
-	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_REPCNT,
+	regmap_update_bits(rn5t618->regmap, RN5T618_REPCNT,
 			   RN5T618_REPCNT_REPWRON, 0);
 	/* start power-off sequence */
-	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_SLPCNT,
+	regmap_update_bits(rn5t618->regmap, RN5T618_SLPCNT,
 			   RN5T618_SLPCNT_SWPWROFF, RN5T618_SLPCNT_SWPWROFF);
+
+	return NOTIFY_DONE;
 }
 
 static int rn5t618_i2c_probe(struct i2c_client *i2c,
@@ -85,23 +91,17 @@ static int rn5t618_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	if (!pm_power_off) {
-		rn5t618_pm_power_off = priv;
-		pm_power_off = rn5t618_power_off;
-	}
+	priv->poweroff_nb.notifier_call = rn5t618_power_off;
+	priv->poweroff_nb.priority = POWEROFF_PRIORITY_LOW;
+	ret = devm_register_power_off_handler(&i2c->dev, &priv->poweroff_nb);
+	if (ret)
+		dev_warn(&i2c->dev, "Failed to register poweroff handler\n");
 
 	return 0;
 }
 
 static int rn5t618_i2c_remove(struct i2c_client *i2c)
 {
-	struct rn5t618 *priv = i2c_get_clientdata(i2c);
-
-	if (priv == rn5t618_pm_power_off) {
-		rn5t618_pm_power_off = NULL;
-		pm_power_off = NULL;
-	}
-
 	mfd_remove_devices(&i2c->dev);
 	return 0;
 }
diff --git a/include/linux/mfd/rn5t618.h b/include/linux/mfd/rn5t618.h
index c72d534..3b0f0e6 100644
--- a/include/linux/mfd/rn5t618.h
+++ b/include/linux/mfd/rn5t618.h
@@ -14,6 +14,7 @@
 #ifndef __LINUX_MFD_RN5T618_H
 #define __LINUX_MFD_RN5T618_H
 
+#include <linux/notifier.h>
 #include <linux/regmap.h>
 
 #define RN5T618_LSIVER			0x00
@@ -223,6 +224,7 @@ enum {
 
 struct rn5t618 {
 	struct regmap *regmap;
+	struct notifier_block poweroff_nb;
 };
 
 #endif /* __LINUX_MFD_RN5T618_H */
-- 
1.9.1

