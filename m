Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab3K1IKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:10:43 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49495 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3K1IJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:09:59 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-ba-5296fa55fcd2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 3/5] rtc: s5m: Limit endless loop waiting for register update
Date: Thu, 28 Nov 2013 09:09:41 +0100
Message-id: <1385626183-22990-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/xK7qhv6YFGVx5qmSx5OJVdoupD5+w
	WTy7tZfJ4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CzWHrnLbrG/s4PR4nQ3q8XFFV+YHHg8
	ds66y+6xZ+JJNo9NqzrZPO5c28PmcehwB6PHvJOBHn1bVjF6TJ/3k8nj8ya5AM4oLpuU1JzM
	stQifbsEroxjvzpYCz4JVdyf+Ji1gXEVfxcjJ4eEgInEvF0fmSFsMYkL99azdTFycQgJLGWU
	WP/lBCuE08ck8fBPNyNIFZuAscTm5UvAqkQE5jJJTH97lhHEYRbYxSjx9ucusCphgQCJm9O+
	sIHYLAKqEnsnXgGKc3DwCrhLLHsjDGJKCChIzJlkA1LBKeAhsWf+PlYQWwio4ufnOWwTGHkX
	MDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ1a87GJceszrEKMDBqMTDq2A8LUiINbGs
	uDL3EKMEB7OSCK9CMVCINyWxsiq1KD++qDQntfgQIxMHp1QDI0st05bkj594S3o7vmVMuSi6
	McZI04Xz6vFfLRfel3xrXrPlcd4qrrCaa3duHTq97Y+wmQ/7d69V0xwKsla8WyT5/RxX6/0/
	Z9jrJ3hNrnvi8ribQ2/XEg55a8b1JTbdx1/8vLZykbmWZJ9IWXW9u7WNaEib3roY3YXPRWdd
	5jn9t2mVdbGuiRJLcUaioRZzUXEiAKegQUYzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After setting alarm or time the driver is waiting for UDR register to be
cleared indicating that registers data have been transferred.

Limit the endless loop to only 5 retries.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s5m.c |   37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 66686d9..51471c1 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -28,6 +28,16 @@
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/rtc.h>
 
+/*
+ * Maximum number of retries for checking changes in UDR field
+ * of SEC_RTC_UDR_CON register (to limit possible endless loop).
+ *
+ * After writing to RTC registers (setting time or alarm) read the UDR field
+ * in SEC_RTC_UDR_CON register. UDR is auto-cleared when data have
+ * been transferred.
+ */
+#define UDR_READ_RETRY_CNT	5
+
 struct s5m_rtc_info {
 	struct device *dev;
 	struct sec_pmic_dev *s5m87xx;
@@ -84,6 +94,25 @@ static int s5m8767_tm_to_data(struct rtc_time *tm, u8 *data)
 	}
 }
 
+/*
+ * Read RTC_UDR_CON register and wait till UDR field is cleared.
+ * This indicates that time/alarm update ended.
+ */
+static inline int s5m8767_wait_for_udr_update(struct s5m_rtc_info *info)
+{
+	int ret, retry = UDR_READ_RETRY_CNT;
+	unsigned int data;
+
+	do {
+		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
+	} while (--retry && (data & RTC_UDR_MASK) && !ret);
+
+	if (!retry)
+		dev_err(info->dev, "waiting for UDR update, reached max number of retries\n");
+
+	return ret;
+}
+
 static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 {
 	int ret;
@@ -104,9 +133,7 @@ static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 		return ret;
 	}
 
-	do {
-		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
-	} while ((data & RTC_UDR_MASK) && !ret);
+	ret = s5m8767_wait_for_udr_update(info);
 
 	return ret;
 }
@@ -133,9 +160,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 		return ret;
 	}
 
-	do {
-		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
-	} while ((data & RTC_UDR_MASK) && !ret);
+	ret = s5m8767_wait_for_udr_update(info);
 
 	return ret;
 }
-- 
1.7.9.5

