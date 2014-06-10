Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaFJJp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48750 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaFJJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:21 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: [PATCH 7/7] bq27xxx: enable hot-plug support
Date: Tue, 10 Jun 2014 11:44:53 +0200
Message-Id: <1402393493-3559-8-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
References: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These kind of devices can be part of the attached battery or part of the board
with an externally attached battery. In both cases we must consider a battery
change can be handled and at least the battery connection state gets
reported correctly.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/power/bq27x00_battery.c | 58 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 0a02d86..5a6c00d 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -188,6 +188,14 @@ static void bq27245_init_cache(struct bq27x00_reg_cache *cache)
 		cache->power_avg = cache->health = -ENODATA;
 }
 
+static void bq27xxx_is_gone(struct bq27x00_device_info *di)
+{
+	di->dev_accessible = false;
+	bq27245_init_cache(&di->cache);
+	di->last_update = jiffies;
+	power_supply_changed(&di->bat);
+}
+
 static void bq27xxx_is_awake(struct bq27x00_device_info *di)
 {
 	di->dev_accessible = true;
@@ -220,8 +228,10 @@ static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
 	else
 		rsoc = bq27x00_read(di, BQ27000_REG_RSOC, true);
 
-	if (rsoc < 0)
+	if (rsoc < 0) {
 		dev_dbg(di->dev, "error reading relative State-of-Charge\n");
+		bq27xxx_is_gone(di);
+	}
 
 	return rsoc;
 }
@@ -238,6 +248,7 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
 	if (charge < 0) {
 		dev_dbg(di->dev, "error reading charge register %02x: %d\n",
 			reg, charge);
+		bq27xxx_is_gone(di);
 		return charge;
 	}
 
@@ -260,6 +271,10 @@ static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
 	bool is_higher = bq27xxx_is_chip_version_higher(di);
 
 	flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	if (flags < 0) {
+		bq27xxx_is_gone(di);
+		return flags;
+	}
 	if (flags >= 0 && !is_higher && (flags & BQ27000_FLAG_CI))
 		return -ENODATA;
 
@@ -272,7 +287,12 @@ static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
  */
 static inline int bq27x00_battery_read_lmd(struct bq27x00_device_info *di)
 {
-	return bq27x00_battery_read_charge(di, BQ27x00_REG_LMD);
+	int reg;
+
+	reg = bq27x00_battery_read_charge(di, BQ27x00_REG_LMD);
+	if (reg < 0)
+		bq27xxx_is_gone(di);
+	return reg;
 }
 
 /*
@@ -298,6 +318,7 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 
 	if (ilmd < 0) {
 		dev_dbg(di->dev, "error reading initial last measured discharge\n");
+		bq27xxx_is_gone(di);
 		return ilmd;
 	}
 
@@ -320,6 +341,7 @@ static int bq27x00_battery_read_energy(struct bq27x00_device_info *di)
 	ae = bq27x00_read(di, BQ27x00_REG_AE, false);
 	if (ae < 0) {
 		dev_dbg(di->dev, "error reading available energy\n");
+		bq27xxx_is_gone(di);
 		return ae;
 	}
 
@@ -342,6 +364,7 @@ static int bq27x00_battery_read_temperature(struct bq27x00_device_info *di)
 	temp = bq27x00_read(di, BQ27x00_REG_TEMP, false);
 	if (temp < 0) {
 		dev_err(di->dev, "error reading temperature\n");
+		bq27xxx_is_gone(di);
 		return temp;
 	}
 
@@ -360,8 +383,10 @@ static int bq27x00_battery_read_cyct(struct bq27x00_device_info *di)
 	int cyct;
 
 	cyct = bq27x00_read(di, BQ27x00_REG_CYCT, false);
-	if (cyct < 0)
+	if (cyct < 0) {
 		dev_err(di->dev, "error reading cycle count total\n");
+		bq27xxx_is_gone(di);
+	}
 
 	return cyct;
 }
@@ -378,6 +403,7 @@ static int bq27x00_battery_read_time(struct bq27x00_device_info *di, u8 reg)
 	if (tval < 0) {
 		dev_dbg(di->dev, "error reading time register %02x: %d\n",
 			reg, tval);
+		bq27xxx_is_gone(di);
 		return tval;
 	}
 
@@ -399,6 +425,7 @@ static int bq27x00_battery_read_pwr_avg(struct bq27x00_device_info *di, u8 reg)
 	if (tval < 0) {
 		dev_dbg(di->dev, "error reading power avg register  %02x: %d\n",
 			reg, tval);
+		bq27xxx_is_gone(di);
 		return tval;
 	}
 
@@ -419,6 +446,7 @@ static int bq27x00_battery_read_health(struct bq27x00_device_info *di)
 	tval = bq27x00_read(di, BQ27x00_REG_FLAGS, false);
 	if (tval < 0) {
 		dev_dbg(di->dev, "error reading flag register:%d\n", tval);
+		bq27xxx_is_gone(di);
 		return tval;
 	}
 
@@ -446,8 +474,29 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	struct bq27x00_reg_cache cache = {0, };
 	bool is_bq27500 = di->chip == BQ27500;
 	bool is_bq27425 = di->chip == BQ27425;
+	int reg;
+
+	reg = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	if (di->dev_accessible == false) {
+		/* check, if the device is present now */
+		if (reg < 0) {
+			dev_dbg(di->dev, "BQ27xxx still not present\n");
+			goto out; /* no, still not present */
+		}
+
+		/* it seems present now */
+		bq27xxx_is_awake(di);
+		dev_dbg(di->dev, "BQ27xxx detected\n");
+	}
+
+	if (reg < 0) {
+		/* it seems gone now */
+		dev_dbg(di->dev, "BQ27xxx is gone\n");
+		bq27xxx_is_gone(di);
+		return;
+	}
 
-	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	cache.flags = reg;
 	if (cache.flags >= 0) {
 		if (!is_bq27500 && !is_bq27425
 				&& (cache.flags & BQ27000_FLAG_CI)) {
@@ -492,6 +541,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 		power_supply_changed(&di->bat);
 	}
 
+out:
 	di->last_update = jiffies;
 }
 
-- 
2.0.0.rc2

