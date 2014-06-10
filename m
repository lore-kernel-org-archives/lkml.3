Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaFJJpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48712 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaFJJpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:10 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: [PATCH 2/7] bq27425: add support to read the control registers
Date: Tue, 10 Jun 2014 11:44:48 +0200
Message-Id: <1402393493-3559-3-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
References: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These kind of registers need a special sequence to be accessed.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/power/bq27x00_battery.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index f3de29e..58644de 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -70,6 +70,9 @@
 #define BQ27500_FLAG_FC			BIT(9)
 #define BQ27500_FLAG_OTC		BIT(15)
 
+/* bq27425 control commands */
+#define BQ27425_CONTROL			0x00
+
 /* bq27425 register addresses are same as bq27x00 addresses minus 4 */
 #define BQ27425_REG_OFFSET		0x04
 #define BQ27425_REG_SOC			0x20 /* Register address plus offset */
@@ -80,6 +83,7 @@
 struct bq27x00_device_info;
 struct bq27x00_access_methods {
 	int (*read)(struct bq27x00_device_info *di, u8 reg, bool single);
+	int (*reads)(struct bq27x00_device_info *di, u16 creg);
 };
 
 enum bq27x00_chip { BQ27000, BQ27500, BQ27425};
@@ -782,6 +786,42 @@ static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg, bool single)
 	return ret;
 }
 
+static int bq27425_read_i2c_control(struct bq27x00_device_info *di, u16 creg)
+{
+	struct i2c_client *client = to_i2c_client(di->dev);
+	struct i2c_msg msg[2];
+	unsigned char cntl[3];
+	unsigned char data[2];
+	int ret;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	cntl[0] = BQ27425_CONTROL; /* CNTL command */
+	put_unaligned_le16(creg, &cntl[1]); /* CNTL DATA */
+	msg[0].buf = cntl;
+	msg[0].len = sizeof(cntl);
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].buf = data;
+	msg[1].len = sizeof(data);
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0)
+		return ret;
+
+	udelay(100); /* at least 66 µs pause */
+
+	msg[0].len = 1; /* only the command again, not the subcommand */
+
+	ret = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
+	if (ret < 0)
+		return ret;
+
+	return get_unaligned_le16(data);
+}
 static int bq27x00_battery_probe(struct i2c_client *client,
 				 const struct i2c_device_id *id)
 {
@@ -816,6 +856,8 @@ static int bq27x00_battery_probe(struct i2c_client *client,
 	di->chip = id->driver_data;
 	di->bat.name = name;
 	di->bus.read = &bq27x00_read_i2c;
+	if (di->chip == BQ27425)
+		di->bus.reads = bq27425_read_i2c_control;
 
 	retval = bq27x00_powersupply_init(di);
 	if (retval)
-- 
2.0.0.rc2

