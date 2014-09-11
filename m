Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaIKMjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:39:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51689 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755464AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Axel Lin" <axel.lin@ingics.com>,
        "Guenter Roeck" <linux@roeck-us.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.502584958@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 035/131] hwmon: (lm85) Fix various errors on attribute
 writes
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 3248c3b771ddd9d31695da17ba350eb6e1b80a53 upstream.

Temperature limit register writes did not account for negative numbers.
As a result, writing -127000 resulted in -126000 written into the
temperature limit register. This problem affected temp[1-3]_min,
temp[1-3]_max, temp[1-3]_auto_temp_crit, and temp[1-3]_auto_temp_min.

When writing pwm[1-3]_freq, a long variable was auto-converted into an int
without range check. Wiring values larger than MAXINT resulted in unexpected
register values.

When writing temp[1-3]_auto_temp_max, an unsigned long variable was
auto-converted into an int without range check. Writing values larger than
MAXINT resulted in unexpected register values.

vrm is an u8, so the written value needs to be limited to [0, 255].

Cc: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[bwh: Backported to 3.2:
 - Driver is not using clamp_val(); keep using SENSORS_LIMIT() for consistency
 - Driver is not using kstrtoul(); make the minimum change to store_vrm_reg()
   so we can validate the value before assigning]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -157,7 +157,7 @@ static inline u16 FAN_TO_REG(unsigned lo
 
 /* Temperature is reported in .001 degC increments */
 #define TEMP_TO_REG(val)	\
-		SENSORS_LIMIT(SCALE(val, 1000, 1), -127, 127)
+		DIV_ROUND_CLOSEST(SENSORS_LIMIT((val), -127000, 127000), 1000)
 #define TEMPEXT_FROM_REG(val, ext)	\
 		SCALE(((val) << 4) + (ext), 16, 1000)
 #define TEMP_FROM_REG(val)	((val) * 1000)
@@ -190,7 +190,7 @@ static const int lm85_range_map[] = {
 	13300, 16000, 20000, 26600, 32000, 40000, 53300, 80000
 };
 
-static int RANGE_TO_REG(int range)
+static int RANGE_TO_REG(long range)
 {
 	int i;
 
@@ -212,7 +212,7 @@ static const int adm1027_freq_map[8] = {
 	11, 15, 22, 29, 35, 44, 59, 88
 };
 
-static int FREQ_TO_REG(const int *map, int freq)
+static int FREQ_TO_REG(const int *map, unsigned long freq)
 {
 	int i;
 
@@ -443,7 +443,13 @@ static ssize_t store_vrm_reg(struct devi
 		const char *buf, size_t count)
 {
 	struct lm85_data *data = dev_get_drvdata(dev);
-	data->vrm = simple_strtoul(buf, NULL, 10);
+	unsigned long val;
+
+	val = simple_strtoul(buf, NULL, 10);
+	if (val > 255)
+		return -EINVAL;
+
+	data->vrm = val;
 	return count;
 }
 

