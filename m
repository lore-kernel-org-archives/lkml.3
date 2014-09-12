Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaILIWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:22:05 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36835 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaILIR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:17:58 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RESEND v9 2/5] rtc: max77686: Remove dead code for SMPL and WTSR.
Date: Fri, 12 Sep 2014 10:17:40 +0200
Message-Id: <1410509864-10019-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77686 RTC chip has two features called SMPL (Sudden Momentary
Power Loss) and WTSR (Watchdog Timeout and Software Resets).
Support for these features seems to be implemented in the driver but
compilation is disabled using a C pre-processor conditional.

This code has been disabled since the driver was original merged in
commit fca1dd03 ("rtc: max77686: add Maxim 77686 driver").

So, since this code has never been built, let's just remove it.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-max77686.c | 101 ---------------------------------------------
 1 file changed, 101 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index c1c6055..7bb5433 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -32,15 +32,6 @@
 #define RTC_UDR_MASK			(1 << RTC_UDR_SHIFT)
 #define RTC_RBUDR_SHIFT			4
 #define RTC_RBUDR_MASK			(1 << RTC_RBUDR_SHIFT)
-/* WTSR and SMPL Register */
-#define WTSRT_SHIFT			0
-#define SMPLT_SHIFT			2
-#define WTSR_EN_SHIFT			6
-#define SMPL_EN_SHIFT			7
-#define WTSRT_MASK			(3 << WTSRT_SHIFT)
-#define SMPLT_MASK			(3 << SMPLT_SHIFT)
-#define WTSR_EN_MASK			(1 << WTSR_EN_SHIFT)
-#define SMPL_EN_MASK			(1 << SMPL_EN_SHIFT)
 /* RTC Hour register */
 #define HOUR_PM_SHIFT			6
 #define HOUR_PM_MASK			(1 << HOUR_PM_SHIFT)
@@ -49,7 +40,6 @@
 #define ALARM_ENABLE_MASK		(1 << ALARM_ENABLE_SHIFT)
 
 #define MAX77686_RTC_UPDATE_DELAY	16
-#undef MAX77686_RTC_WTSR_SMPL
 
 enum {
 	RTC_SEC = 0,
@@ -412,64 +402,6 @@ static const struct rtc_class_ops max77686_rtc_ops = {
 	.alarm_irq_enable = max77686_rtc_alarm_irq_enable,
 };
 
-#ifdef MAX77686_RTC_WTSR_SMPL
-static void max77686_rtc_enable_wtsr(struct max77686_rtc_info *info, bool enable)
-{
-	int ret;
-	unsigned int val, mask;
-
-	if (enable)
-		val = (1 << WTSR_EN_SHIFT) | (3 << WTSRT_SHIFT);
-	else
-		val = 0;
-
-	mask = WTSR_EN_MASK | WTSRT_MASK;
-
-	dev_info(info->dev, "%s: %s WTSR\n", __func__,
-			enable ? "enable" : "disable");
-
-	ret = regmap_update_bits(info->max77686->rtc_regmap,
-				 MAX77686_WTSR_SMPL_CNTL, mask, val);
-	if (ret < 0) {
-		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
-				__func__, ret);
-		return;
-	}
-
-	max77686_rtc_update(info, MAX77686_RTC_WRITE);
-}
-
-static void max77686_rtc_enable_smpl(struct max77686_rtc_info *info, bool enable)
-{
-	int ret;
-	unsigned int val, mask;
-
-	if (enable)
-		val = (1 << SMPL_EN_SHIFT) | (0 << SMPLT_SHIFT);
-	else
-		val = 0;
-
-	mask = SMPL_EN_MASK | SMPLT_MASK;
-
-	dev_info(info->dev, "%s: %s SMPL\n", __func__,
-			enable ? "enable" : "disable");
-
-	ret = regmap_update_bits(info->max77686->rtc_regmap,
-				 MAX77686_WTSR_SMPL_CNTL, mask, val);
-	if (ret < 0) {
-		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
-				__func__, ret);
-		return;
-	}
-
-	max77686_rtc_update(info, MAX77686_RTC_WRITE);
-
-	val = 0;
-	regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
-	dev_info(info->dev, "%s: WTSR_SMPL(0x%02x)\n", __func__, val);
-}
-#endif /* MAX77686_RTC_WTSR_SMPL */
-
 static int max77686_rtc_init_reg(struct max77686_rtc_info *info)
 {
 	u8 data[2];
@@ -519,11 +451,6 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 		goto err_rtc;
 	}
 
-#ifdef MAX77686_RTC_WTSR_SMPL
-	max77686_rtc_enable_wtsr(info, true);
-	max77686_rtc_enable_smpl(info, true);
-#endif
-
 	device_init_wakeup(&pdev->dev, 1);
 
 	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max77686-rtc",
@@ -556,33 +483,6 @@ err_rtc:
 	return ret;
 }
 
-static void max77686_rtc_shutdown(struct platform_device *pdev)
-{
-#ifdef MAX77686_RTC_WTSR_SMPL
-	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
-	int i;
-	u8 val = 0;
-
-	for (i = 0; i < 3; i++) {
-		max77686_rtc_enable_wtsr(info, false);
-		regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
-		dev_info(info->dev, "%s: WTSR_SMPL reg(0x%02x)\n", __func__,
-				val);
-		if (val & WTSR_EN_MASK) {
-			dev_emerg(info->dev, "%s: fail to disable WTSR\n",
-					__func__);
-		} else {
-			dev_info(info->dev, "%s: success to disable WTSR\n",
-					__func__);
-			break;
-		}
-	}
-
-	/* Disable SMPL when power off */
-	max77686_rtc_enable_smpl(info, false);
-#endif /* MAX77686_RTC_WTSR_SMPL */
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int max77686_rtc_suspend(struct device *dev)
 {
@@ -622,7 +522,6 @@ static struct platform_driver max77686_rtc_driver = {
 		.pm	= &max77686_rtc_pm_ops,
 	},
 	.probe		= max77686_rtc_probe,
-	.shutdown	= max77686_rtc_shutdown,
 	.id_table	= rtc_id,
 };
 
-- 
2.0.0.rc2

