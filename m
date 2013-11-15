Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab3KOLy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:54:59 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:55199 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3KOLyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:54:51 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] rtc: s5m-rtc: Fix info->rtc assignment
Date: Fri, 15 Nov 2013 12:54:38 +0100
Message-Id: <1384516479-31791-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/rtc/rtc-s5m.c: In function ‘s5m_rtc_probe’:
drivers/rtc/rtc-s5m.c:545: warning: assignment from incompatible pointer type

struct s5m_rtc_info.rtc has type "struct regmap *", while
struct sec_pmic_dev.rtc has type "struct i2c_client *".

Probably the author wanted to assign "struct sec_pmic_dev.regmap", which
has the correct type.

Also, as "rtc" doesn't make much sense as a name for a regmap, rename it to
"regmap".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
I would be really surprised if this driver didn't just crash...
Please test. Thanks!

 drivers/rtc/rtc-s5m.c |   54 ++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index b7fd02bc0a14..1dfa488e67ff 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -31,7 +31,7 @@
 struct s5m_rtc_info {
 	struct device *dev;
 	struct sec_pmic_dev *s5m87xx;
-	struct regmap *rtc;
+	struct regmap *regmap;
 	struct rtc_device *rtc_dev;
 	int irq;
 	int device_type;
@@ -89,7 +89,7 @@ static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to read update reg(%d)\n", ret);
 		return ret;
@@ -98,14 +98,14 @@ static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 	data |= RTC_TIME_EN_MASK;
 	data |= RTC_UDR_MASK;
 
-	ret = regmap_write(info->rtc, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to write update reg(%d)\n", ret);
 		return ret;
 	}
 
 	do {
-		ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	} while ((data & RTC_UDR_MASK) && !ret);
 
 	return ret;
@@ -116,7 +116,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read update reg(%d)\n",
 			__func__, ret);
@@ -126,7 +126,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 	data &= ~RTC_TIME_EN_MASK;
 	data |= RTC_UDR_MASK;
 
-	ret = regmap_write(info->rtc, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 			__func__, ret);
@@ -134,7 +134,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 	}
 
 	do {
-		ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	} while ((data & RTC_UDR_MASK) && !ret);
 
 	return ret;
@@ -178,7 +178,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	u8 data[8];
 	int ret;
 
-	ret = regmap_bulk_read(info->rtc, SEC_RTC_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -226,7 +226,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		1900 + tm->tm_year, 1 + tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec, tm->tm_wday);
 
-	ret = regmap_raw_write(info->rtc, SEC_RTC_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, SEC_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -242,20 +242,20 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned int val;
 	int ret, i;
 
-	ret = regmap_bulk_read(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
 	switch (info->device_type) {
 	case S5M8763X:
 		s5m8763_data_to_tm(data, &alrm->time);
-		ret = regmap_read(info->rtc, SEC_ALARM0_CONF, &val);
+		ret = regmap_read(info->regmap, SEC_ALARM0_CONF, &val);
 		if (ret < 0)
 			return ret;
 
 		alrm->enabled = !!val;
 
-		ret = regmap_read(info->rtc, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 
@@ -278,7 +278,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		}
 
 		alrm->pending = 0;
-		ret = regmap_read(info->rtc, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 		break;
@@ -301,7 +301,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 	int ret, i;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -312,14 +312,14 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 
 	switch (info->device_type) {
 	case S5M8763X:
-		ret = regmap_write(info->rtc, SEC_ALARM0_CONF, 0);
+		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, 0);
 		break;
 
 	case S5M8767X:
 		for (i = 0; i < 7; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->rtc, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 
@@ -341,7 +341,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 	u8 alarm0_conf;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -353,7 +353,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 	switch (info->device_type) {
 	case S5M8763X:
 		alarm0_conf = 0x77;
-		ret = regmap_write(info->rtc, SEC_ALARM0_CONF, alarm0_conf);
+		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, alarm0_conf);
 		break;
 
 	case S5M8767X:
@@ -368,7 +368,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 		if (data[RTC_YEAR1] & 0x7f)
 			data[RTC_YEAR1] |= ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->rtc, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 		ret = s5m8767_rtc_set_alarm_reg(info);
@@ -410,7 +410,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		return ret;
 
-	ret = regmap_raw_write(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -455,7 +455,7 @@ static const struct rtc_class_ops s5m_rtc_ops = {
 static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->rtc, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
 				 WTSR_ENABLE_MASK,
 				 enable ? WTSR_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -466,7 +466,7 @@ static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->rtc, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
 				 SMPL_ENABLE_MASK,
 				 enable ? SMPL_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -481,7 +481,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 	int ret;
 	struct rtc_time tm;
 
-	ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &tp_read);
+	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &tp_read);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read control reg(%d)\n",
 			__func__, ret);
@@ -493,7 +493,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 
 	info->rtc_24hr_mode = 1;
-	ret = regmap_raw_write(info->rtc, SEC_ALARM0_CONF, data, 2);
+	ret = regmap_raw_write(info->regmap, SEC_ALARM0_CONF, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 			__func__, ret);
@@ -515,7 +515,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 		ret = s5m_rtc_set_time(info->dev, &tm);
 	}
 
-	ret = regmap_update_bits(info->rtc, SEC_RTC_UDR_CON,
+	ret = regmap_update_bits(info->regmap, SEC_RTC_UDR_CON,
 				 RTC_TCON_MASK, tp_read | RTC_TCON_MASK);
 	if (ret < 0)
 		dev_err(info->dev, "%s: fail to update TCON reg(%d)\n",
@@ -542,7 +542,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->rtc = s5m87xx->rtc;
+	info->regmap = s5m87xx->regmap;
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
@@ -596,7 +596,7 @@ static void s5m_rtc_shutdown(struct platform_device *pdev)
 	if (info->wtsr_smpl) {
 		for (i = 0; i < 3; i++) {
 			s5m_rtc_enable_wtsr(info, false);
-			regmap_read(info->rtc, SEC_WTSR_SMPL_CNTL, &val);
+			regmap_read(info->regmap, SEC_WTSR_SMPL_CNTL, &val);
 			pr_debug("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
 			if (val & WTSR_ENABLE_MASK)
 				pr_emerg("%s: fail to disable WTSR\n",
-- 
1.7.9.5

