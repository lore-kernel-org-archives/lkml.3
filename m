Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaFXXzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:55:00 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:39824 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaFXXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:54:58 -0400
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, javier.martinez@collabora.co.uk,
        ch.naveen@samsung.com, Doug Anderson <dianders@chromium.org>,
        jg1.han@samsung.com, jdelvare@suse.de, sjg@google.com,
        paul.gortmaker@windriver.com, standby24x7@gmail.com,
        sachin.kamat@linaro.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
Date: Tue, 24 Jun 2014 16:54:52 -0700
Message-Id: <1403654093-24134-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code for the exynos i2c controller registered for the
"noirq" variants.  However during review feedback it was moved to
SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
longer actually "noirq" (despite functions named
exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).

i2c controllers that might have wakeup sources on them seem to need to
resume at noirq time so that the individual drivers can actually read
the i2c bus to handle their wakeup.

NOTE: I took the original review feedback from Wolfram and added
poweroff, thaw, freeze, restore.

This patch has only been compile-tested since I don't have all the
patches needed to make my machine using this i2c driver actually
suspend/resume.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Added missing CONFIG_PM_SLEEP

 drivers/i2c/busses/i2c-exynos5.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 63d2292..348b1cd 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -789,8 +789,16 @@ static int exynos5_i2c_resume_noirq(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(exynos5_i2c_dev_pm_ops, exynos5_i2c_suspend_noirq,
-			 exynos5_i2c_resume_noirq);
+const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
+#ifdef CONFIG_PM_SLEEP
+	.suspend_noirq = exynos5_i2c_suspend_noirq,
+	.resume_noirq = exynos5_i2c_resume_noirq,
+	.freeze_noirq = exynos5_i2c_suspend_noirq,
+	.thaw_noirq = exynos5_i2c_resume_noirq,
+	.poweroff_noirq = exynos5_i2c_suspend_noirq,
+	.restore_noirq = exynos5_i2c_resume_noirq,
+#endif
+};
 
 static struct platform_driver exynos5_i2c_driver = {
 	.probe		= exynos5_i2c_probe,
-- 
2.0.0.526.g5318336

