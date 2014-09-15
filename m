Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbaIOWQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:16:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737AbaIOWQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 165/187] hwmon: (dme1737) Prevent overflow problem when writing large limits
Date: Mon, 15 Sep 2014 15:09:35 -0700
Message-Id: <1410818997-9432-166-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit d58e47d787c09fe5c61af3c6ce7d784762f29c3d upstream.

On platforms with sizeof(int) < sizeof(long), writing a temperature
limit larger than MAXINT will result in unpredictable limit values
written to the chip. Avoid auto-conversion from long to int to fix
the problem.

Voltage limits, fan minimum speed, pwm frequency, pwm ramp rate, and
other attributes have the same problem, fix them as well.

Zone temperature limits are signed, but were cached as u8, causing
unepected values to be reported for negative temperatures. Cache as
s8 to fix the problem.

vrm is an u8, so the written value needs to be limited to [0, 255].

Signed-off-by: Axel Lin <axel.lin@ingics.com>
[Guenter Roeck: Fix zone temperature cache]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/dme1737.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index 4ae3fff..bea0a34 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -247,8 +247,8 @@ struct dme1737_data {
 	u8  pwm_acz[3];
 	u8  pwm_freq[6];
 	u8  pwm_rr[2];
-	u8  zone_low[3];
-	u8  zone_abs[3];
+	s8  zone_low[3];
+	s8  zone_abs[3];
 	u8  zone_hyst[2];
 	u32 alarms;
 };
@@ -277,7 +277,7 @@ static inline int IN_FROM_REG(int reg, int nominal, int res)
 	return (reg * nominal + (3 << (res - 3))) / (3 << (res - 2));
 }
 
-static inline int IN_TO_REG(int val, int nominal)
+static inline int IN_TO_REG(long val, int nominal)
 {
 	return clamp_val((val * 192 + nominal / 2) / nominal, 0, 255);
 }
@@ -293,7 +293,7 @@ static inline int TEMP_FROM_REG(int reg, int res)
 	return (reg * 1000) >> (res - 8);
 }
 
-static inline int TEMP_TO_REG(int val)
+static inline int TEMP_TO_REG(long val)
 {
 	return clamp_val((val < 0 ? val - 500 : val + 500) / 1000, -128, 127);
 }
@@ -308,7 +308,7 @@ static inline int TEMP_RANGE_FROM_REG(int reg)
 	return TEMP_RANGE[(reg >> 4) & 0x0f];
 }
 
-static int TEMP_RANGE_TO_REG(int val, int reg)
+static int TEMP_RANGE_TO_REG(long val, int reg)
 {
 	int i;
 
@@ -331,7 +331,7 @@ static inline int TEMP_HYST_FROM_REG(int reg, int ix)
 	return (((ix == 1) ? reg : reg >> 4) & 0x0f) * 1000;
 }
 
-static inline int TEMP_HYST_TO_REG(int val, int ix, int reg)
+static inline int TEMP_HYST_TO_REG(long val, int ix, int reg)
 {
 	int hyst = clamp_val((val + 500) / 1000, 0, 15);
 
@@ -347,7 +347,7 @@ static inline int FAN_FROM_REG(int reg, int tpc)
 		return (reg == 0 || reg == 0xffff) ? 0 : 90000 * 60 / reg;
 }
 
-static inline int FAN_TO_REG(int val, int tpc)
+static inline int FAN_TO_REG(long val, int tpc)
 {
 	if (tpc) {
 		return clamp_val(val / tpc, 0, 0xffff);
@@ -379,7 +379,7 @@ static inline int FAN_TYPE_FROM_REG(int reg)
 	return (edge > 0) ? 1 << (edge - 1) : 0;
 }
 
-static inline int FAN_TYPE_TO_REG(int val, int reg)
+static inline int FAN_TYPE_TO_REG(long val, int reg)
 {
 	int edge = (val == 4) ? 3 : val;
 
@@ -402,7 +402,7 @@ static int FAN_MAX_FROM_REG(int reg)
 	return 1000 + i * 500;
 }
 
-static int FAN_MAX_TO_REG(int val)
+static int FAN_MAX_TO_REG(long val)
 {
 	int i;
 
@@ -460,7 +460,7 @@ static inline int PWM_ACZ_FROM_REG(int reg)
 	return acz[(reg >> 5) & 0x07];
 }
 
-static inline int PWM_ACZ_TO_REG(int val, int reg)
+static inline int PWM_ACZ_TO_REG(long val, int reg)
 {
 	int acz = (val == 4) ? 2 : val - 1;
 
@@ -476,7 +476,7 @@ static inline int PWM_FREQ_FROM_REG(int reg)
 	return PWM_FREQ[reg & 0x0f];
 }
 
-static int PWM_FREQ_TO_REG(int val, int reg)
+static int PWM_FREQ_TO_REG(long val, int reg)
 {
 	int i;
 
@@ -510,7 +510,7 @@ static inline int PWM_RR_FROM_REG(int reg, int ix)
 	return (rr & 0x08) ? PWM_RR[rr & 0x07] : 0;
 }
 
-static int PWM_RR_TO_REG(int val, int ix, int reg)
+static int PWM_RR_TO_REG(long val, int ix, int reg)
 {
 	int i;
 
@@ -528,7 +528,7 @@ static inline int PWM_RR_EN_FROM_REG(int reg, int ix)
 	return PWM_RR_FROM_REG(reg, ix) ? 1 : 0;
 }
 
-static inline int PWM_RR_EN_TO_REG(int val, int ix, int reg)
+static inline int PWM_RR_EN_TO_REG(long val, int ix, int reg)
 {
 	int en = (ix == 1) ? 0x80 : 0x08;
 
@@ -1481,13 +1481,16 @@ static ssize_t set_vrm(struct device *dev, struct device_attribute *attr,
 		       const char *buf, size_t count)
 {
 	struct dme1737_data *data = dev_get_drvdata(dev);
-	long val;
+	unsigned long val;
 	int err;
 
-	err = kstrtol(buf, 10, &val);
+	err = kstrtoul(buf, 10, &val);
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

