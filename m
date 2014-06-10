Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaFJJpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48729 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaFJJpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:13 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: [PATCH 3/7] bq27425: add support for different firmware chip types
Date: Tue, 10 Jun 2014 11:44:49 +0200
Message-Id: <1402393493-3559-4-git-send-email-jbe@pengutronix.de>
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

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/power/bq27x00_battery.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 58644de..39b5194 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -72,6 +72,7 @@
 
 /* bq27425 control commands */
 #define BQ27425_CONTROL			0x00
+# define BQ27425_DEVICE_TYPE		0x0001
 
 /* bq27425 register addresses are same as bq27x00 addresses minus 4 */
 #define BQ27425_REG_OFFSET		0x04
@@ -87,6 +88,7 @@ struct bq27x00_access_methods {
 };
 
 enum bq27x00_chip { BQ27000, BQ27500, BQ27425};
+enum bq27425_chip_type { BQ27425_unknown, BQ27425_g1, BQ27425_g2a};
 
 struct bq27x00_reg_cache {
 	int temperature;
@@ -106,6 +108,7 @@ struct bq27x00_device_info {
 	struct device 		*dev;
 	int			id;
 	enum bq27x00_chip	chip;
+	enum bq27425_chip_type	chip_type;
 
 	struct bq27x00_reg_cache cache;
 	int charge_design_full;
@@ -698,6 +701,28 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 {
 	int ret;
 
+	if (di->chip == BQ27425) {
+		/* detect chip type */
+		ret = di->bus.reads(di, BQ27425_DEVICE_TYPE);
+		if (ret < 0) {
+			dev_err(di->dev, "Fail to detect BQ27425's type\n");
+			/* try to continue */
+		} else {
+			switch (ret) {
+			case 0x0410:
+				di->chip_type = BQ27425_g1;
+				break;
+			case 0x0425:
+				di->chip_type = BQ27425_g2a;
+				break;
+			default:
+				dev_err(di->dev, "Unknown BQ27425 type: "
+						"%04X\n", ret);
+				/* try to continue */
+			}
+		}
+	}
+
 	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
 	if (di->chip == BQ27425) {
 		di->bat.properties = bq27425_battery_props;
-- 
2.0.0.rc2

