Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbaIOW1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:27:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbaIOWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 121/187] hwmon: (lm85) Fix various errors on attribute writes
Date: Mon, 15 Sep 2014 15:08:51 -0700
Message-Id: <1410818997-9432-122-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/lm85.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index 3894c40..b9d6e7d 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -158,7 +158,7 @@ static inline u16 FAN_TO_REG(unsigned long val)
 
 /* Temperature is reported in .001 degC increments */
 #define TEMP_TO_REG(val)	\
-		clamp_val(SCALE(val, 1000, 1), -127, 127)
+		DIV_ROUND_CLOSEST(clamp_val((val), -127000, 127000), 1000)
 #define TEMPEXT_FROM_REG(val, ext)	\
 		SCALE(((val) << 4) + (ext), 16, 1000)
 #define TEMP_FROM_REG(val)	((val) * 1000)
@@ -192,7 +192,7 @@ static const int lm85_range_map[] = {
 	13300, 16000, 20000, 26600, 32000, 40000, 53300, 80000
 };
 
-static int RANGE_TO_REG(int range)
+static int RANGE_TO_REG(long range)
 {
 	int i;
 
@@ -214,7 +214,7 @@ static const int adm1027_freq_map[8] = { /* 1 Hz */
 	11, 15, 22, 29, 35, 44, 59, 88
 };
 
-static int FREQ_TO_REG(const int *map, int freq)
+static int FREQ_TO_REG(const int *map, unsigned long freq)
 {
 	int i;
 
@@ -463,6 +463,9 @@ static ssize_t store_vrm_reg(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 
+	if (val > 255)
+		return -EINVAL;
+
 	data->vrm = val;
 	return count;
 }
-- 
1.9.1

