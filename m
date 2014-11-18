Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbaKRO6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:58:53 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36937 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbaKRO5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:57:42 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: Steven Honeyman <stevenhoneyman@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] i8k: Fix temperature bug handling in i8k_get_temp()
Date: Tue, 18 Nov 2014 15:56:54 +0100
Message-Id: <1416322614-10308-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <201411181546.51284@pali>
References: <201411181546.51284@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static array prev[] was incorrectly initialized. It should be initialized to
some "invalid" temperature value (above I8K_MAX_TEMP).

Next, function should store "invalid" value to prev[] (above I8K_MAX_TEMP),
not valid (= I8K_MAX_TEMP) because whole temperature bug handling will not
work.

And last part, to not break existing detection of temperature sensors, register
them also if i8k report too high temperature (above I8K_MAX_TEMP). This is
needed because some sensors are sometimes turned off (e.g sensor on GPU which
can be turned off/on) and in this case SMM report too high value.

To prevent reporting "invalid" values to userspace, return -EINVAL. In this case
sensors which are currently turned off (e.g optimus/powerexpress/enduro gpu)
are reported as "N/A" by lm-sensors package.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 7272b08..e34a019 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -298,7 +298,7 @@ static int i8k_get_temp(int sensor)
 	int temp;
 
 #ifdef I8K_TEMPERATURE_BUG
-	static int prev[4];
+	static int prev[4] = { I8K_MAX_TEMP+1, I8K_MAX_TEMP+1, I8K_MAX_TEMP+1, I8K_MAX_TEMP+1 };
 #endif
 	regs.ebx = sensor & 0xff;
 	rc = i8k_smm(&regs);
@@ -317,10 +317,12 @@ static int i8k_get_temp(int sensor)
 	 */
 	if (temp > I8K_MAX_TEMP) {
 		temp = prev[sensor];
-		prev[sensor] = I8K_MAX_TEMP;
+		prev[sensor] = I8K_MAX_TEMP+1;
 	} else {
 		prev[sensor] = temp;
 	}
+	if (temp > I8K_MAX_TEMP)
+		return -ERANGE;
 #endif
 
 	return temp;
@@ -499,6 +501,8 @@ static ssize_t i8k_hwmon_show_temp(struct device *dev,
 	int temp;
 
 	temp = i8k_get_temp(index);
+	if (temp == -ERANGE)
+		return -EINVAL;
 	if (temp < 0)
 		return temp;
 	return sprintf(buf, "%d\n", temp * 1000);
@@ -610,17 +614,17 @@ static int __init i8k_init_hwmon(void)
 
 	/* CPU temperature attributes, if temperature reading is OK */
 	err = i8k_get_temp(0);
-	if (err >= 0)
+	if (err >= 0 || err == -ERANGE)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP1;
 	/* check for additional temperature sensors */
 	err = i8k_get_temp(1);
-	if (err >= 0)
+	if (err >= 0 || err == -ERANGE)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP2;
 	err = i8k_get_temp(2);
-	if (err >= 0)
+	if (err >= 0 || err == -ERANGE)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP3;
 	err = i8k_get_temp(3);
-	if (err >= 0)
+	if (err >= 0 || err == -ERANGE)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP4;
 
 	/* Left fan attributes, if left fan is present */
-- 
1.7.9.5

