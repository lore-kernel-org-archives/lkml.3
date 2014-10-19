Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaJSOrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 10:47:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53162 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaJSOrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 10:47:18 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Honeyman <stevenhoneyman@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] i8k: Ignore temperature sensors which report invalid values
Date: Sun, 19 Oct 2014 16:46:54 +0200
Message-Id: <1413730014-30945-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some machines some temperature sensors report too high values which are
invalid. When value is invalid function i8k_get_temp() returns previous
value and at next call it returns I8K_MAX_TEMP.

With this patch also firt i8k_get_temp() call returns I8K_MAX_TEMP and
i8k_init_hwmon() will ignore all sensor ids which report incorrect values.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 7272b08..bc327fa 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -298,7 +298,7 @@ static int i8k_get_temp(int sensor)
 	int temp;
 
 #ifdef I8K_TEMPERATURE_BUG
-	static int prev[4];
+	static int prev[4] = { I8K_MAX_TEMP, I8K_MAX_TEMP, I8K_MAX_TEMP, I8K_MAX_TEMP };
 #endif
 	regs.ebx = sensor & 0xff;
 	rc = i8k_smm(&regs);
@@ -610,17 +610,17 @@ static int __init i8k_init_hwmon(void)
 
 	/* CPU temperature attributes, if temperature reading is OK */
 	err = i8k_get_temp(0);
-	if (err >= 0)
+	if (err >= 0 && err < I8K_MAX_TEMP)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP1;
 	/* check for additional temperature sensors */
 	err = i8k_get_temp(1);
-	if (err >= 0)
+	if (err >= 0 && err < I8K_MAX_TEMP)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP2;
 	err = i8k_get_temp(2);
-	if (err >= 0)
+	if (err >= 0 && err < I8K_MAX_TEMP)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP3;
 	err = i8k_get_temp(3);
-	if (err >= 0)
+	if (err >= 0 && err < I8K_MAX_TEMP)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP4;
 
 	/* Left fan attributes, if left fan is present */
-- 
1.7.9.5

