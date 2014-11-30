Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaK3VCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:02:05 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58674 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaK3VCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:02:01 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/3] i8k: Rework error retries
Date: Sun, 30 Nov 2014 13:00:39 -0800
Message-Id: <1417381240-7641-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
References: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020202.547B85C9.0033,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 11
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 2
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of returning a previous value if the SMM code returns
an error when trying to read a temperature, retry once.
If that fails again, return -ENODATA. Also return -ENODATA if an
attempt is made to read the GPU temperature but the GPU is
currently turned off.

Drop the I8K_TEMPERATURE_BUG definition and handle the related bug
unconditionally.

Cc: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Applies on top of Pali's patch series. 

 drivers/char/i8k.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 3464192..cdb2dc7 100644
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
1.9.1

