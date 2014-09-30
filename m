Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaI3STL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:19:11 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:39259 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaI3STI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:19:08 -0400
From: Puthikorn Voravootivat <puthik@chromium.org>
To: linux-pm@vger.kernel.org
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Puthikorn Voravootivat <puthik@chromium.org>
Subject: [PATCH] bq27x00_battery: Fix flag reading for bq27742
Date: Tue, 30 Sep 2014 11:18:56 -0700
Message-Id: <1412101136-26037-1-git-send-email-puthik@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the following issues.
- Flag for bq27742 is 2 bytes contracy to 1 byte for older hardware
- Don't read FLAG_CI as bq27742 does not have it
- Use Battery full capacity register as last measure discharge

Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
---
The incremental patch of [PATCH v2] bq27x00_battery: Add support to bq27742
Sorry, I didn't see that the old patch was already applied.
 drivers/power/bq27x00_battery.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 5b9f0ea..e3bacfe 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -254,9 +254,11 @@ static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
 {
 	int flags;
 	bool is_bq27500 = di->chip == BQ27500;
+	bool is_bq27742 = di->chip == BQ27742;
 	bool is_higher = bq27xxx_is_chip_version_higher(di);
+	bool flags_1b = !(is_bq27500 || is_bq27742);
 
-	flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	flags = bq27x00_read(di, BQ27x00_REG_FLAGS, flags_1b);
 	if (flags >= 0 && !is_higher && (flags & BQ27000_FLAG_CI))
 		return -ENODATA;
 
@@ -436,13 +438,14 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	bool is_bq27500 = di->chip == BQ27500;
 	bool is_bq27425 = di->chip == BQ27425;
 	bool is_bq27742 = di->chip == BQ27742;
+	bool flags_1b = !(is_bq27500 || is_bq27742);
 
-	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, flags_1b);
 	if ((cache.flags & 0xff) == 0xff)
 		/* read error */
 		cache.flags = -1;
 	if (cache.flags >= 0) {
-		if (!is_bq27500 && !is_bq27425
+		if (!is_bq27500 && !is_bq27425 && !is_bq27742
 				&& (cache.flags & BQ27000_FLAG_CI)) {
 			dev_info(di->dev, "battery is not calibrated! ignoring capacity values\n");
 			cache.capacity = -ENODATA;
@@ -470,9 +473,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 					bq27x00_battery_read_time(di,
 							BQ27x00_REG_TTF);
 			}
-			if (!is_bq27742)
-				cache.charge_full =
-					bq27x00_battery_read_lmd(di);
+			cache.charge_full = bq27x00_battery_read_lmd(di);
 			cache.health = bq27x00_battery_read_health(di);
 		}
 		cache.temperature = bq27x00_battery_read_temperature(di);
-- 
2.1.0.rc2.206.gedb03e5

