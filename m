Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbaFSEzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:55:09 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:41361 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979AbaFSEzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:55:06 -0400
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, javier.martinez@collabora.co.uk,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: s3c2410: resume the I2C controller earlier
Date: Wed, 18 Jun 2014 21:54:51 -0700
Message-Id: <1403153691-15606-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Palatin <vpalatin@chromium.org>

When the wake-up is triggered by the PMIC RTC, the RTC driver is trying
to read the PMIC interrupt status over I2C and fails because the I2C
controller is not resumed yet.
Let's resume the I2C controller earlier in the _noirq phase
(as other hardwares are doing), so we can properly get the wake-up
condition.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/i2c/busses/i2c-s3c2410.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index e828a1d..b904132 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1267,7 +1267,7 @@ static int s3c24xx_i2c_suspend_noirq(struct device *dev)
 	return 0;
 }
 
-static int s3c24xx_i2c_resume(struct device *dev)
+static int s3c24xx_i2c_resume_noirq(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
@@ -1285,7 +1285,7 @@ static int s3c24xx_i2c_resume(struct device *dev)
 static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 #ifdef CONFIG_PM_SLEEP
 	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
-	.resume = s3c24xx_i2c_resume,
+	.resume_noirq = s3c24xx_i2c_resume_noirq,
 #endif
 };
 
-- 
2.0.0.526.g5318336

