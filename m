Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab3BZSX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:23:59 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57560 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759814Ab3BZSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:23:55 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 26 Feb 2013 12:23:53 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v5 06/12] hwmon: (nct6775) Add support for fan debounce module parameter
Date: Tue, 26 Feb 2013 10:23:34 -0800
Message-Id: <1361903020-18526-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
References: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If set, fan debounce is enabled when loading the driver.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/nct6775.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index 828ed47..ac8be97 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -72,6 +72,10 @@ static unsigned short force_id;
 module_param(force_id, ushort, 0);
 MODULE_PARM_DESC(force_id, "Override the detected device ID");
 
+static unsigned short fan_debounce;
+module_param(fan_debounce, ushort, 0);
+MODULE_PARM_DESC(fan_debounce, "Enable debouncing for fan RPM signal");
+
 #define DRVNAME "nct6775"
 
 /*
@@ -183,6 +187,8 @@ static const u16 NCT6775_REG_IN[] = {
 #define NCT6775_REG_FANDIV1		0x506
 #define NCT6775_REG_FANDIV2		0x507
 
+#define NCT6775_REG_CR_FAN_DEBOUNCE	0xf0
+
 static const u16 NCT6775_REG_ALARM[NUM_REG_ALARM] = { 0x459, 0x45A, 0x45B };
 
 /* 0..15 voltages, 16..23 fans, 24..31 temperatures */
@@ -2107,6 +2113,28 @@ static int nct6775_probe(struct platform_device *pdev)
 	 */
 	superio_select(sio_data->sioreg, NCT6775_LD_VID);
 	data->vid = superio_inb(sio_data->sioreg, 0xe3);
+
+	if (fan_debounce) {
+		u8 tmp;
+
+		superio_select(sio_data->sioreg, NCT6775_LD_HWM);
+		tmp = superio_inb(sio_data->sioreg,
+				  NCT6775_REG_CR_FAN_DEBOUNCE);
+		switch (data->kind) {
+		case nct6775:
+			tmp |= 0x1e;
+			break;
+		case nct6776:
+		case nct6779:
+			tmp |= 0x3e;
+			break;
+		}
+		superio_outb(sio_data->sioreg, NCT6775_REG_CR_FAN_DEBOUNCE,
+			     tmp);
+		dev_info(&pdev->dev, "Enabled fan debounce for chip %s\n",
+			 data->name);
+	}
+
 	superio_exit(sio_data->sioreg);
 
 	err = device_create_file(dev, &dev_attr_cpu0_vid);
-- 
1.7.9.7

