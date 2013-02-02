Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3BBKGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 05:06:42 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49802 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3BBKGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 05:06:40 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] bq27x00_battery: Fix reporting battery temperature
Date: Sat,  2 Feb 2013 11:06:09 +0100
Message-Id: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported temperature can be also negative, so cache value in non negative Kelvin degree.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq27x00_battery.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 36b34ef..4f39dd8 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -299,7 +299,7 @@ static int bq27x00_battery_read_energy(struct bq27x00_device_info *di)
 }
 
 /*
- * Return the battery temperature in tenths of degree Celsius
+ * Return the battery temperature in tenths of degree Kelvin
  * Or < 0 if something fails.
  */
 static int bq27x00_battery_read_temperature(struct bq27x00_device_info *di)
@@ -312,10 +312,8 @@ static int bq27x00_battery_read_temperature(struct bq27x00_device_info *di)
 		return temp;
 	}
 
-	if (bq27xxx_is_chip_version_higher(di))
-		temp -= 2731;
-	else
-		temp = ((temp * 5) - 5463) / 2;
+	if (!bq27xxx_is_chip_version_higher(di))
+		temp = 5 * temp / 2;
 
 	return temp;
 }
@@ -642,6 +640,8 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = bq27x00_simple_value(di->cache.temperature, val);
+		if (ret == 0)
+			val->intval -= 2731;
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
 		ret = bq27x00_simple_value(di->cache.time_to_empty, val);
-- 
1.7.10.4

