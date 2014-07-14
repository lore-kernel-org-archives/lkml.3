Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaGNLos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:44:48 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:45221 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaGNLh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:37:29 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 10/13] rtc: max77686: Allow the max77686 rtc to wakeup the system
Date: Mon, 14 Jul 2014 13:36:06 +0200
Message-Id: <1405337769-3741-11-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

The max77686 includes an RTC that keeps power during suspend.  It's
convenient to be able to use it as a wakeup source.

NOTE: due to wakeup ordering problems this patch alone doesn't work so
well on exynos5250-snow.  You also need something that brings the i2c
bus up before the max77686 wakeup runs.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---

Changes since v6: None

Changes since v5:
 - Fix $SUBJECT since the patch does not actually touch the mfd subsys.
   Suggested by Lee Jones.

Changes since v4: None

Changes since v3:
 - Keep the note that this patch needs another change due wakeup
   ordering problems.
---
 drivers/rtc/rtc-max77686.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index d20a7f0..c1c6055 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -583,6 +583,33 @@ static void max77686_rtc_shutdown(struct platform_device *pdev)
 #endif /* MAX77686_RTC_WTSR_SMPL */
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int max77686_rtc_suspend(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct max77686_rtc_info *info = dev_get_drvdata(dev);
+
+		return enable_irq_wake(info->virq);
+	}
+
+	return 0;
+}
+
+static int max77686_rtc_resume(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct max77686_rtc_info *info = dev_get_drvdata(dev);
+
+		return disable_irq_wake(info->virq);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(max77686_rtc_pm_ops,
+			 max77686_rtc_suspend, max77686_rtc_resume);
+
 static const struct platform_device_id rtc_id[] = {
 	{ "max77686-rtc", 0 },
 	{},
@@ -592,6 +619,7 @@ static struct platform_driver max77686_rtc_driver = {
 	.driver		= {
 		.name	= "max77686-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &max77686_rtc_pm_ops,
 	},
 	.probe		= max77686_rtc_probe,
 	.shutdown	= max77686_rtc_shutdown,
-- 
2.0.0.rc2

