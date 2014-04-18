Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaDRNTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:19:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26417 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbaDRNTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:19:11 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-55-5351264d19bc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 6/6] rtc: s5m: Consolidate two device type switch statements
Date: Fri, 18 Apr 2014 15:18:59 +0200
Message-id: <1397827139-14589-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397827139-14589-1-git-send-email-k.kozlowski@samsung.com>
References: <1397827139-14589-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4FV1ftcBgg5u7DSyWXLzKbrFxxnpW
	i9cvDC3ONr1ht7j/9SijxeVdc9gsZpzfx2Sx9shddov9nR2MFqe7WS0urvjC5MDtsWfiSTaP
	O9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYIvisklJzcksSy3St0vgyth5ZzdzwVOhioYnm1ga
	GLfzdzFyckgImEg82LeBDcIWk7hwbz2QzcUhJLCUUWLvj1YWCKePSaKpo5kVpIpNwFhi8/Il
	YFUiAr8YJb4tWwRWxSxwlFFieu9bJpAqYQF/iaXbtzCC2CwCqhJdt7vBbF4Bd4nL96YxQ+xT
	kFj2ZS2YzSngIbFjazuYLQRUs3HrQ+YJjLwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+du
	YoSE4dcdjEuPWR1iFOBgVOLhvfDVP1iINbGsuDL3EKMEB7OSCO/uvwHBQrwpiZVVqUX58UWl
	OanFhxiZODilGhjXnppwJ/gC0+6W3V0S0TyPK6uMZjR6LA5av30Jz7O8qXNM+LZn3Tkd3uk3
	1+C70p5HKyu+ZqzXvsjX/OjuUcesvWnbYqTTz8VKxDr1O56Z+e/cBhfGy86zGlUC/2w43Ns5
	d9KHN8Wnrs7nfTDh9ortKdKPa9TWbi349mLu2rA+lXMZBWV/WBYfUGIpzkg01GIuKk4EAAh+
	r4chAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In probe the configuration of driver for different chipsets was done in
two switch (pdata->device_type) statements. Consolidate them into one
switch statement to increase code readability.

Additionally check the return value of regmap_irq_get_virq and exit
probe on error.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s5m.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 76287ebd0e35..8f06250a0389 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -666,7 +666,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	struct sec_platform_data *pdata = s5m87xx->pdata;
 	struct s5m_rtc_info *info;
 	const struct regmap_config *regmap_cfg;
-	int ret;
+	int ret, alarm_irq;
 
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "Platform data not supplied\n");
@@ -681,14 +681,17 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	case S2MPS14X:
 		regmap_cfg = &s2mps14_rtc_regmap_config;
 		info->regs = &s2mps_rtc_regs;
+		alarm_irq = S2MPS14_IRQ_RTCA0;
 		break;
 	case S5M8763X:
 		regmap_cfg = &s5m_rtc_regmap_config;
 		info->regs = &s5m_rtc_regs;
+		alarm_irq = S5M8763_IRQ_ALARM0;
 		break;
 	case S5M8767X:
 		regmap_cfg = &s5m_rtc_regmap_config;
 		info->regs = &s5m_rtc_regs;
+		alarm_irq = S5M8767_IRQ_RTCA1;
 		break;
 	default:
 		dev_err(&pdev->dev, "Device type is not supported by RTC driver\n");
@@ -714,25 +717,11 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
-	switch (pdata->device_type) {
-	case S2MPS14X:
-		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
-				S2MPS14_IRQ_RTCA0);
-		break;
-
-	case S5M8763X:
-		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
-				S5M8763_IRQ_ALARM0);
-		break;
-
-	case S5M8767X:
-		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
-				S5M8767_IRQ_RTCA1);
-		break;
-
-	default:
+	info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
+	if (info->irq <= 0) {
 		ret = -EINVAL;
-		dev_err(&pdev->dev, "Unsupported device type: %d\n", ret);
+		dev_err(&pdev->dev, "Failed to get virtual IRQ %d\n",
+				alarm_irq);
 		goto err;
 	}
 
-- 
1.8.3.2

