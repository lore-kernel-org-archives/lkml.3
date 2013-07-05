Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab3GEWnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:43:50 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:47277
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab3GEWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:43:49 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: linux@arm.linux.org.uk, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] arm: Convert scoop platform and bus legacy pm_ops to dev_pm_ops
Date: Fri,  5 Jul 2013 16:43:43 -0600
Message-Id: <1373064223-13510-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert arch/arm/common/scoop platform and bus legacy pm_ops to dev_pm_ops.
This change also updates the use of COMFIG_PM to CONFIG_PM_SLEEP as this
platform and bus code implements PM_SLEEP ops and not the PM_RUNTIME ops.
Compile tested.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 arch/arm/common/scoop.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index a5c3dc3..8d64fcb 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -141,7 +141,7 @@ EXPORT_SYMBOL(reset_scoop);
 EXPORT_SYMBOL(read_scoop_reg);
 EXPORT_SYMBOL(write_scoop_reg);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static void check_scoop_reg(struct scoop_dev *sdev)
 {
 	unsigned short mcr;
@@ -151,9 +151,9 @@ static void check_scoop_reg(struct scoop_dev *sdev)
 		iowrite16(0x0101, sdev->base + SCOOP_MCR);
 }
 
-static int scoop_suspend(struct platform_device *dev, pm_message_t state)
+static int scoop_suspend(struct device *dev)
 {
-	struct scoop_dev *sdev = platform_get_drvdata(dev);
+	struct scoop_dev *sdev = platform_get_drvdata(to_platform_device(dev));
 
 	check_scoop_reg(sdev);
 	sdev->scoop_gpwr = ioread16(sdev->base + SCOOP_GPWR);
@@ -162,18 +162,16 @@ static int scoop_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int scoop_resume(struct platform_device *dev)
+static int scoop_resume(struct device *dev)
 {
-	struct scoop_dev *sdev = platform_get_drvdata(dev);
+	struct scoop_dev *sdev = platform_get_drvdata(to_platform_device(dev));
 
 	check_scoop_reg(sdev);
 	iowrite16(sdev->scoop_gpwr, sdev->base + SCOOP_GPWR);
 
 	return 0;
 }
-#else
-#define scoop_suspend	NULL
-#define scoop_resume	NULL
+static SIMPLE_DEV_PM_OPS(scoop_dev_pm_ops, scoop_suspend, scoop_resume);
 #endif
 
 static int scoop_probe(struct platform_device *pdev)
@@ -269,10 +267,11 @@ static int scoop_remove(struct platform_device *pdev)
 static struct platform_driver scoop_driver = {
 	.probe		= scoop_probe,
 	.remove		= scoop_remove,
-	.suspend	= scoop_suspend,
-	.resume		= scoop_resume,
 	.driver		= {
 		.name	= "sharp-scoop",
+#ifdef CONFIG_PM_SLEEP
+		.pm	= &scoop_dev_pm_ops,
+#endif
 	},
 };
 
-- 
1.7.10.4

