Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaB1NAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:00:24 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21417 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaB1NAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:00:19 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-98-531088612907
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/5] rtc: s5m: Use shorter time of register update
Date: Fri, 28 Feb 2014 14:00:06 +0100
Message-id: <1393592408-27181-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
References: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Vd3EDoFgg8e75CyWXLzKbrFxxnpW
	i9cvDC3ONr1ht7j/9SijxeVdc9gs1h65y26xv7OD0eJ0N6vFxRVfmCzWz3jN4sDtsWfiSTaP
	O9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYIvisklJzcksSy3St0vgyvg56TFjwUKBil8vNrI0
	MB7l7WLk5JAQMJH48fkhE4QtJnHh3nq2LkYuDiGBpYwSR6d0M0M4fUwSH/c2sYFUsQkYS2xe
	vgSsSkTgKqPExCWL2UESzALPGSWefg8HsYUFnCSenlsINpZFQFXi2IEeRhCbV8BdYtHxw6xd
	jBxA6xQk5kyyAQlzCnhInHw+hRXEFgIqubd6K/MERt4FjAyrGEVTS5MLipPSc430ihNzi0vz
	0vWS83M3MUJC8OsOxqXHrA4xCnAwKvHwTvDkDxZiTSwrrsw9xCjBwawkwvukSSBYiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA6P/5GcbLM4+WV3P+FwjJV/vbMyzQDHxLKGLx9S/iZ4Sv3N1w25h
	2bh934Tc5l1Jc/vD1JLBMjlObVNF3w7Bd+7T7T9fm2Ois+8u50pXm2Kx7ctFLq42Sm5z+DtZ
	PWHLv1S7rcJ3150IElTZ9sVC3O2ddu+a7zy5J5e5M+caaETsW1GwbsmbLGslluKMREMt5qLi
	RAAhWXsTHwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the time needed for updating alarm and time registers to 0.45 ms.
The default is 7.32 ms which is too long and leads to warnings when
setting alarm or time:
s5m-rtc: waiting for UDR update, reached max number of retries

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-s5m.c           |    7 +++++++
 include/linux/mfd/samsung/rtc.h |   10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index b1627e9ab8f0..109d57800157 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -504,6 +504,13 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 	u8 data[2];
 	int ret;
 
+	/* UDR update time. Default of 7.32 ms is to long. */
+	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
+			S5M_RTC_UDR_T_MASK, S5M_RTC_UDR_T_450_US);
+	if (ret < 0)
+		dev_err(info->dev, "%s: fail to change UDR time: %d\n",
+				__func__, ret);
+
 	/* Set RTC control register : Binary mode, 24hour mode */
 	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
diff --git a/include/linux/mfd/samsung/rtc.h b/include/linux/mfd/samsung/rtc.h
index 207fcfbde82e..b6401e7661c7 100644
--- a/include/linux/mfd/samsung/rtc.h
+++ b/include/linux/mfd/samsung/rtc.h
@@ -111,6 +111,16 @@ enum s2mps_rtc_reg {
 #define RTC_TCON_MASK		(1 << RTC_TCON_SHIFT)
 #define S5M_RTC_TIME_EN_SHIFT	3
 #define S5M_RTC_TIME_EN_MASK	(1 << S5M_RTC_TIME_EN_SHIFT)
+/*
+ * UDR_T field in S5M_RTC_UDR_CON register determines the time needed
+ * for updating alarm and time registers. Default is 7.32 ms.
+ */
+#define S5M_RTC_UDR_T_SHIFT	6
+#define S5M_RTC_UDR_T_MASK	(0x3 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_7320_US	(0x0 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_1830_US	(0x1 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_3660_US	(0x2 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_450_US	(0x3 << S5M_RTC_UDR_T_SHIFT)
 
 /* RTC Hour register */
 #define HOUR_PM_SHIFT		6
-- 
1.7.9.5

