Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161633Ab3BOMsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:48:42 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34634 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161549Ab3BOMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:47:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 36/40] pm2301-charger: Wake device on register access
Date: Fri, 15 Feb 2013 12:45:06 +0000
Message-Id: <1360932310-30065-37-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

When USB  Dedicated or Standard host chargers are plugged into
the device, chargealg attempts to disable the PM2301 AC charger,
However, disabling PM2301 was failing because of it being in
runtime suepend mode & LPN pin being low.

Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/pm2301_charger.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index f99a0c8..ea9870d 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -128,13 +128,9 @@ static void clear_lpn_pin(struct pm2xxx_charger *pm2)
 static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 {
 	int ret;
-	/*
-	 * When AC adaptor is unplugged, the host
-	 * must put LPN high to be able to
-	 * communicate by I2C with PM2301
-	 * and receive I2C "acknowledge" from PM2301.
-	 */
-	mutex_lock(&pm2->lock);
+
+	/* wake up the device */
+	pm_runtime_get_sync(pm2->dev);
 
 	ret = i2c_smbus_read_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
 				1, val);
@@ -142,7 +138,6 @@ static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 		dev_err(pm2->dev, "Error reading register at 0x%x\n", reg);
 	else
 		ret = 0;
-	mutex_unlock(&pm2->lock);
 
 	return ret;
 }
@@ -150,13 +145,9 @@ static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 static int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 {
 	int ret;
-	/*
-	 * When AC adaptor is unplugged, the host
-	 * must put LPN high to be able to
-	 * communicate by I2C with PM2301
-	 * and receive I2C "acknowledge" from PM2301.
-	 */
-	mutex_lock(&pm2->lock);
+
+	/* wake up the device */
+	pm_runtime_get_sync(pm2->dev);
 
 	ret = i2c_smbus_write_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
 				1, &val);
@@ -164,7 +155,6 @@ static int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 		dev_err(pm2->dev, "Error writing register at 0x%x\n", reg);
 	else
 		ret = 0;
-	mutex_unlock(&pm2->lock);
 
 	return ret;
 }
-- 
1.7.10.4

