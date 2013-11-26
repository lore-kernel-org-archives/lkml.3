Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3KZNve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:51:34 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26606 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab3KZNur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:50:47 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-9d-5294a730a313
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/5] rtc: s5m: Limit endless loop waiting for register update
Date: Tue, 26 Nov 2013 14:50:26 +0100
Message-id: <1385473828-31078-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4FV2D5VOCDP78Y7JYcvEqu8WzW3uZ
	LF6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF/s4ORovT3awWF1d8YXLg8tgz8SSbx51re9g8
	Dh3uYPSYdzLQo2/LKkaP6fN+Mnl83iQXwB7FZZOSmpNZllqkb5fAlXHsVwdrwSehivsTH7M2
	MK7i72Lk5JAQMJGY/uITI4QtJnHh3nq2LkYuDiGBpYwSuy/3skM4fUwSvz/dZgOpYhMwlti8
	fAlYlYjAVUaJiUsWg1UxC+xilHj7cxfQLA4OYQFfiZUv8kAaWARUJZZf6GYGsXkF3CUev/nD
	DFIiIaAgMWeSDUiYU8BDYmbPMhYQWwio5NzBXUwTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7N
	S9dLzs/dxAgJwa87GJceszrEKMDBqMTDK9E5OUiINbGsuDL3EKMEB7OSCG/s9ClBQrwpiZVV
	qUX58UWlOanFhxiZODilGhizzb7c4lpfekJjIgNz5U/PN/PyA5zjolWLm+O9ZZ8uijskGn3M
	X3P1j09+Myzzq/VFN7/7+3vbo8uu0j+L28RvcaixB1zPNNV5aS/R2/3tUdF9TvsVvGu7eIqF
	ZjGmbc98xtIUXyOvYfLw0nXPpaUL4j8fXSNxUFZR5tXFppwloX+ndYSEJSmxFGckGmoxFxUn
	AgClHcAPHwIAAA==
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

