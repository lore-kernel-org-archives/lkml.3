Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaLURYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:24:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52524 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaLURYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:24:06 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v4] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sun, 21 Dec 2014 18:23:50 +0100
Message-Id: <1419182630-20211-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com>
References: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new function i8k_get_fan_nominal_speed() for doing SMM call
which will return nominal fan RPM for specified fan speed. It returns nominal
RPM value at which fan operate when speed (0, 1, 2, 3) is set. It looks like
RPM value is not accurate, but still provides very useful information.

First it can be used to validate if certain fan speed could be accepted by SMM
for setting fan speed and we can use this routine to detect maximal fan speed.

Second it returns RPM value, so we can check if value looks correct with
multiplier 30 or multiplier 1 (until now only these two multiplier were used).
If RPM value with multiplier 30 is too high, then multiplier 1 is used.

In case when SMM reports that new function is not supported we will fallback
to old hardcoded values. Maximal fan speed would be 2 and RPM multiplier 30.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |   85 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 11 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 175bb9f..49e756e 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -6,6 +6,7 @@
  * Hwmon integration:
  * Copyright (C) 2011  Jean Delvare <jdelvare@suse.de>
  * Copyright (C) 2013, 2014  Guenter Roeck <linux@roeck-us.net>
+ * Copyright (C) 2014  Pali Rohár <pali.rohar@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -42,12 +43,14 @@
 #define I8K_SMM_SET_FAN		0x01a3
 #define I8K_SMM_GET_FAN		0x00a3
 #define I8K_SMM_GET_SPEED	0x02a3
+#define I8K_SMM_GET_NOM_SPEED	0x04a3
 #define I8K_SMM_GET_TEMP	0x10a3
 #define I8K_SMM_GET_TEMP_TYPE	0x11a3
 #define I8K_SMM_GET_DELL_SIG1	0xfea3
 #define I8K_SMM_GET_DELL_SIG2	0xffa3
 
 #define I8K_FAN_MULT		30
+#define I8K_FAN_MAX_RPM		30000
 #define I8K_MAX_TEMP		127
 
 #define I8K_FN_NONE		0x00
@@ -64,7 +67,7 @@ static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 static struct device *i8k_hwmon_dev;
 static u32 i8k_hwmon_flags;
-static uint i8k_fan_mult;
+static uint i8k_fan_mult = I8K_FAN_MULT;
 static uint i8k_pwm_mult;
 static uint i8k_fan_max = I8K_FAN_HIGH;
 
@@ -95,13 +98,13 @@ static bool power_status;
 module_param(power_status, bool, 0600);
 MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
 
-static uint fan_mult = I8K_FAN_MULT;
+static uint fan_mult;
 module_param(fan_mult, uint, 0);
-MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
+MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with (default: autodetect)");
 
-static uint fan_max = I8K_FAN_HIGH;
+static uint fan_max;
 module_param(fan_max, uint, 0);
-MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
+MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed (default: autodetect)");
 
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static long i8k_ioctl(struct file *, unsigned int, unsigned long);
@@ -276,6 +279,17 @@ static int i8k_get_fan_speed(int fan)
 }
 
 /*
+ * Read the fan nominal rpm for specific fan speed.
+ */
+static int i8k_get_fan_nominal_speed(int fan, int speed)
+{
+	struct smm_regs regs = { .eax = I8K_SMM_GET_NOM_SPEED, };
+
+	regs.ebx = (fan & 0xff) | (speed << 8);
+	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * i8k_fan_mult;
+}
+
+/*
  * Set the fan speed (off, low, high). Returns the new fan status.
  */
 static int i8k_set_fan(int fan, int speed)
@@ -855,6 +869,7 @@ MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
 static int __init i8k_probe(void)
 {
 	const struct dmi_system_id *id;
+	int fan, val, ret;
 
 	/*
 	 * Get DMI information
@@ -883,19 +898,67 @@ static int __init i8k_probe(void)
 			return -ENODEV;
 	}
 
-	i8k_fan_mult = fan_mult;
-	i8k_fan_max = fan_max ? : I8K_FAN_HIGH;	/* Must not be 0 */
+	/*
+	 * Autodetect fan multiplier and maximal fan speed from dmi config
+	 * Values specified in module parameters override values from dmi
+	 */
 	id = dmi_first_match(i8k_dmi_table);
 	if (id && id->driver_data) {
 		const struct i8k_config_data *conf = id->driver_data;
+		if (!fan_mult && conf->fan_mult)
+			fan_mult = conf->fan_mult;
+		if (!fan_max && conf->fan_max)
+			fan_max = conf->fan_max;
+	}
 
-		if (fan_mult == I8K_FAN_MULT && conf->fan_mult)
-			i8k_fan_mult = conf->fan_mult;
-		if (fan_max == I8K_FAN_HIGH && conf->fan_max)
-			i8k_fan_max = conf->fan_max;
+	if (!fan_max) {
+		/*
+		 * Autodetect maximal fan speed value
+		 * Speed value is valid if i8k_get_fan_nominal_speed() not fail
+		 */
+		for (fan = 0; fan < 2; ++fan) {
+			for (val = 1; val < 256; ++val) {
+				if (i8k_get_fan_nominal_speed(fan, val) < 0)
+					break;
+				fan_max = val; /* Must not be 0 */
+			}
+			if (fan_max) {
+				i8k_fan_max = fan_max;
+				break;
+			}
+		}
+	} else {
+		/* Maximal fan speed was specified in module param or in dmi */
+		i8k_fan_max = fan_max;
 	}
+
 	i8k_pwm_mult = DIV_ROUND_UP(255, i8k_fan_max);
 
+	if (!fan_mult) {
+		/*
+		 * Autodetect fan multiplier based on nominal rpm
+		 * If fan reports rpm value too high then set multiplier to 1
+		 *
+		 * Try also setting multiplier from current rpm, but this will
+		 * work only in case when fan is not turned off. It is better
+		 * then nothing for machines which does not support nominal rpm
+		 * SMM function.
+		 */
+		for (fan = 0; fan < 2; ++fan) {
+			ret = i8k_get_fan_nominal_speed(fan, i8k_fan_max);
+			if (ret < 0)
+				ret = i8k_get_fan_speed(fan);
+			if (ret < 0)
+				continue;
+			if (ret > I8K_FAN_MAX_RPM)
+				i8k_fan_mult = 1;
+			break;
+		}
+	} else {
+		/* Fan multiplier was specified in module param or in dmi */
+		i8k_fan_mult = fan_mult;
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5

