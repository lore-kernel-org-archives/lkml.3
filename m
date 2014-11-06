Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaKFQ7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:59:43 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56255 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaKFQo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:44:28 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v5 20/48] mfd: rn5t618: Register power-off handler with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:04 -0800
Message-Id: <1415292213-28652-21-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.545BA56C.00AA,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 120
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

Cc: Beniamino Galvani <b.galvani@gmail.com>
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
- New patch

 drivers/mfd/rn5t618.c       | 28 ++++++++++++----------------
 include/linux/mfd/rn5t618.h |  2 ++
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/rn5t618.c b/drivers/mfd/rn5t618.c
index 6668571..1492025 100644
--- a/drivers/mfd/rn5t618.c
+++ b/drivers/mfd/rn5t618.c
@@ -15,6 +15,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/rn5t618.h>
 #include <linux/module.h>
+#include <linux/pm.h>
 #include <linux/regmap.h>
 
 static const struct mfd_cell rn5t618_cells[] = {
@@ -47,15 +48,16 @@ static const struct regmap_config rn5t618_regmap_config = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
-static struct rn5t618 *rn5t618_pm_power_off;
-
-static void rn5t618_power_off(void)
+static void rn5t618_power_off(struct power_off_handler_block *this)
 {
+	struct rn5t618 *rn5t618 = container_of(this, struct rn5t618,
+					       power_off_hb);
+
 	/* disable automatic repower-on */
-	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_REPCNT,
+	regmap_update_bits(rn5t618->regmap, RN5T618_REPCNT,
 			   RN5T618_REPCNT_REPWRON, 0);
 	/* start power-off sequence */
-	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_SLPCNT,
+	regmap_update_bits(rn5t618->regmap, RN5T618_SLPCNT,
 			   RN5T618_SLPCNT_SWPWROFF, RN5T618_SLPCNT_SWPWROFF);
 }
 
@@ -85,23 +87,17 @@ static int rn5t618_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	if (!pm_power_off) {
-		rn5t618_pm_power_off = priv;
-		pm_power_off = rn5t618_power_off;
-	}
+	priv->power_off_hb.handler = rn5t618_power_off;
+	priv->power_off_hb.priority = POWER_OFF_PRIORITY_LOW;
+	ret = devm_register_power_off_handler(&i2c->dev, &priv->power_off_hb);
+	if (ret)
+		dev_warn(&i2c->dev, "Failed to register power-off handler\n");
 
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
index c72d534..87e34b3 100644
--- a/include/linux/mfd/rn5t618.h
+++ b/include/linux/mfd/rn5t618.h
@@ -14,6 +14,7 @@
 #ifndef __LINUX_MFD_RN5T618_H
 #define __LINUX_MFD_RN5T618_H
 
+#include <linux/pm.h>
 #include <linux/regmap.h>
 
 #define RN5T618_LSIVER			0x00
@@ -223,6 +224,7 @@ enum {
 
 struct rn5t618 {
 	struct regmap *regmap;
+	struct power_off_handler_block power_off_hb;
 };
 
 #endif /* __LINUX_MFD_RN5T618_H */
-- 
1.9.1

