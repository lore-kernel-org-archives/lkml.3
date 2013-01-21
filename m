Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3AUKKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:10:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3AUKKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:16 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org
Subject: [PATCH 27/33] thermal: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:20 +0100
Message-Id: <1358762966-20791-28-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:8U4KfrF23DVdkgGjiag2Fb0d8WVP5rsYYOmD2rSWP94
 8jtR60e6IGsC7k6CuJOmquMzQHZCmMA4s20Z1oOM0jGJNWv8uh
 Ig79b2d2XrwVtFOUZhXHt45tHcT8Lf3aWbk2gvbCSUHe58lnHZ
 pf9ZKuuNrmDnHtu4llvEF4aRyTXXtD1wP7kp+OYxMVcGx6MP8p
 MJ52Dx7+slh1bURrXbnc55oBWVSwgiIyPvH+SWMoSzRiWvVQBc
 SQh8otL8tzQkQh4mzTsCP18rs31rFpWfoDwx9tGK49YFbnyXeT
 S83Xpowp7j5wLd7pbtjxKDLFHHHPfQs9545ttxeK49mZj6XgaW
 +EAyNiKcBXJbYB5DT3pSRLyJrAmxsLy8wxGqM62VwYfi8wLBNN
 NwSgFnNZOlWLjRg0V6DCDwnMBoF0nsGwVX0KK8INW2G4QKP/yl
 Ay1HJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
---
 drivers/thermal/exynos_thermal.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 224751e..bada130 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -866,11 +866,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	data->base = devm_request_and_ioremap(&pdev->dev, data->mem);
-	if (!data->base) {
-		dev_err(&pdev->dev, "Failed to ioremap memory\n");
-		return -ENODEV;
-	}
+	data->base = devm_ioremap_resource(&pdev->dev, data->mem);
+	if (IS_ERR(data->base))
+		return PTR_ERR(data->base);
 
 	ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
 		IRQF_TRIGGER_RISING, "exynos-tmu", data);
-- 
1.8.1.1

