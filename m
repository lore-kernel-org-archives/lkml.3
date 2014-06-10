Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaFJJpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48725 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaFJJpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:13 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: [PATCH 4/7] bq27425: the DesignCapacity register is at a different offset
Date: Tue, 10 Jun 2014 11:44:50 +0200
Message-Id: <1402393493-3559-5-git-send-email-jbe@pengutronix.de>
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

For the BQ27425-g1 this register does not exists at all.
For the BQ27425-g2a this register is at offset 0x3C.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/power/bq27x00_battery.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 39b5194..a5a88f1 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -78,6 +78,9 @@
 #define BQ27425_REG_OFFSET		0x04
 #define BQ27425_REG_SOC			0x20 /* Register address plus offset */
 
+/* register offsets above 0x20 are DEVICE_TYPE 0x0425 specifc */
+#define BQ27425_REG_DCAP		0x40 /* Design capacity plus offset */
+
 #define BQ27000_RS			20 /* Resistor sense */
 #define BQ27x00_POWER_CONSTANT		(256 * 29200 / 1000)
 
@@ -265,9 +268,17 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 {
 	int ilmd;
 
-	if (bq27xxx_is_chip_version_higher(di))
-		ilmd = bq27x00_read(di, BQ27500_REG_DCAP, false);
-	else
+	if (bq27xxx_is_chip_version_higher(di)) {
+		if (di->chip == BQ27425) {
+			if (di->chip_type == BQ27425_g2a)
+				ilmd = bq27x00_read(di, BQ27425_REG_DCAP,
+							false);
+			else
+				ilmd = -ENODATA;
+		} else {
+			ilmd = bq27x00_read(di, BQ27500_REG_DCAP, false);
+		}
+	} else
 		ilmd = bq27x00_read(di, BQ27000_REG_ILMD, true);
 
 	if (ilmd < 0) {
-- 
2.0.0.rc2

