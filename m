Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaLUTze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:55:34 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42562 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaLUTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:55:31 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] i8k: Rework error retries
Date: Sun, 21 Dec 2014 20:54:38 +0100
Message-Id: <1419191683-31435-6-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
References: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

Instead of returning a previous value if the SMM code returns
an error when trying to read a temperature, retry once.
If that fails again, return -ENODATA. Also return -ENODATA if an
attempt is made to read the GPU temperature but the GPU is
currently turned off.

Drop the I8K_TEMPERATURE_BUG definition and handle the related bug
unconditionally.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 1854fab..0e332fc 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -5,7 +5,7 @@
  *
  * Hwmon integration:
  * Copyright (C) 2011  Jean Delvare <jdelvare@suse.de>
- * Copyright (C) 2013  Guenter Roeck <linux@roeck-us.net>
+ * Copyright (C) 2013, 2014  Guenter Roeck <linux@roeck-us.net>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -20,6 +20,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -59,8 +60,6 @@
 #define I8K_POWER_AC		0x05
 #define I8K_POWER_BATTERY	0x01
 
-#define I8K_TEMPERATURE_BUG	1
-
 static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 static struct device *i8k_hwmon_dev;
@@ -300,39 +299,41 @@ static int i8k_get_temp_type(int sensor)
 /*
  * Read the cpu temperature.
  */
-static int i8k_get_temp(int sensor)
+static int _i8k_get_temp(int sensor)
 {
-	struct smm_regs regs = { .eax = I8K_SMM_GET_TEMP, };
-	int rc;
-	int temp;
+	struct smm_regs regs = {
+		.eax = I8K_SMM_GET_TEMP,
+		.ebx = sensor & 0xff,
+	};
 
-#ifdef I8K_TEMPERATURE_BUG
-	static int prev[4] = { I8K_MAX_TEMP+1, I8K_MAX_TEMP+1, I8K_MAX_TEMP+1, I8K_MAX_TEMP+1 };
-#endif
-	regs.ebx = sensor & 0xff;
-	rc = i8k_smm(&regs);
-	if (rc < 0)
-		return rc;
+	return i8k_smm(&regs) ? : regs.eax & 0xff;
+}
 
-	temp = regs.eax & 0xff;
+static int i8k_get_temp(int sensor)
+{
+	int temp = _i8k_get_temp(sensor);
 
-#ifdef I8K_TEMPERATURE_BUG
 	/*
 	 * Sometimes the temperature sensor returns 0x99, which is out of range.
-	 * In this case we return (once) the previous cached value. For example:
+	 * In this case we retry (once) before returning an error.
 	 # 1003655137 00000058 00005a4b
 	 # 1003655138 00000099 00003a80 <--- 0x99 = 153 degrees
 	 # 1003655139 00000054 00005c52
 	 */
-	if (temp > I8K_MAX_TEMP) {
-		temp = prev[sensor];
-		prev[sensor] = I8K_MAX_TEMP+1;
-	} else {
-		prev[sensor] = temp;
+	if (temp == 0x99) {
+		msleep(100);
+		temp = _i8k_get_temp(sensor);
 	}
+	/*
+	 * Return -ENODATA for all invalid temperatures.
+	 *
+	 * Known instances are the 0x99 value as seen above as well as
+	 * 0xc1 (193), which may be returned when trying to read the GPU
+	 * temperature if the system supports a GPU and it is currently
+	 * turned off.
+	 */
 	if (temp > I8K_MAX_TEMP)
 		return -ENODATA;
-#endif
 
 	return temp;
 }
-- 
1.7.9.5

