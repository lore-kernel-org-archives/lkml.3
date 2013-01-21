Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3AUKKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:10:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3AUKJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:56 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 04/33] amba: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:08:57 +0100
Message-Id: <1358762966-20791-5-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:ekOLDa1q86qq/tOnfd86/1WJGx/4F39nsZYJTXMCXwp
 zd3NRBPT0uwXOPt2i0e+/QOUbpRXOMFPS1DuwTtI0xEwY9pOoq
 nShg1bhuvLUTH8VskDZRwYDNENDnFHt4jAzheO/QaDP3V7+4/W
 ZHuQa01qvmpJtdouxoufQydDUnr8Ug19uivbiywN58gAbLR9VK
 ZfNvFxe7+GzumixYO0vcZFR4VvnS53xv35dvsf4pBgSpr335p8
 pGwnzlYV96phph4DQBWEasBJNVGH1FsJn7Yufg5qoFRJcee99O
 S3eUTSWVjLxP930/fAk9b1rPA8CvQbrmlQjKDemZUSGzGVTp1j
 83zpm96m1CKG/tch4MEtQRFT3dlhg38+dwO1gYWbtQ0f+UeVwo
 2/OpaBCg+aFiSh7vcUKbRlir2IkkMi7nEjfuPWjvcMyrOmTJEx
 Wv8Pw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 drivers/amba/tegra-ahb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index 536c166..ab92785 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -257,9 +258,9 @@ static int tegra_ahb_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	ahb->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ahb->regs)
-		return -EBUSY;
+	ahb->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ahb->regs))
+		return PTR_ERR(ahb->regs);
 
 	ahb->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ahb);
-- 
1.8.1.1

