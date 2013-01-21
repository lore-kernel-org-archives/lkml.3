Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3AUKP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:15:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3AUKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:51 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 03/33] MIPS: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:08:56 +0100
Message-Id: <1358762966-20791-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:G56bKa1q85yUSC5wKFRWGTzobspycbJI9P3mIEzhaXh
 ruC3P8EYVbOoZXaJ9l5e9tvMrh9y8otsjKx1yDhJFx6N8cDCqJ
 VwtqkYzFc3wxELLQQT+Ku6Q64bVLKXyKGe7uAjknIO8V45YLq2
 vBm2KS3D6n2csGbbflb+tb2BcgLvdS6qsoPhi1PTWTSCkJiCTQ
 vFNDQnRuDvPZNJZbi9uWa9c7dj7sy5MIkuz1jcFGr/EkFqJ98p
 quQIhvrb4f8jlYeEMR14RU+RYD+mXoWlSrTIHxv1noSLtMkTPX
 zAQE0qacSnm/eTy/v2xwPLSFi+vfDqXMVreXEYWkbFNuqSUWgJ
 u3wD1rJCqw1G2wj55XQqKJNJ7IA4HE37ijml6m0bZvLesub+/A
 F/CEC2g0FLFe5OHFSvm+QqZpBrNnxuYXasexP6MaWnba5rkqxJ
 zWkag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/lantiq/xway/dma.c  |  5 +++--
 arch/mips/lantiq/xway/gptu.c |  8 +++-----
 arch/mips/pci/pci-lantiq.c   | 12 ++++++------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index e44a186..08f7ebd 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -21,6 +21,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 
 #include <lantiq_soc.h>
 #include <xway_dma.h>
@@ -223,8 +224,8 @@ ltq_dma_init(struct platform_device *pdev)
 		panic("Failed to get dma resource");
 
 	/* remap dma register range */
-	ltq_dma_membase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ltq_dma_membase)
+	ltq_dma_membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ltq_dma_membase))
 		panic("Failed to remap dma resource");
 
 	/* power up and reset the dma engine */
diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index e30b1ed..9861c86 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -150,11 +150,9 @@ static int gptu_probe(struct platform_device *pdev)
 	}
 
 	/* remap gptu register range */
-	gptu_membase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!gptu_membase) {
-		dev_err(&pdev->dev, "Failed to remap resource\n");
-		return -ENOMEM;
-	}
+	gptu_membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(gptu_membase))
+		return PTR_ERR(gptu_membase);
 
 	/* enable our clock */
 	clk = clk_get(&pdev->dev, NULL);
diff --git a/arch/mips/pci/pci-lantiq.c b/arch/mips/pci/pci-lantiq.c
index 9568178..910fb4c 100644
--- a/arch/mips/pci/pci-lantiq.c
+++ b/arch/mips/pci/pci-lantiq.c
@@ -214,13 +214,13 @@ static int ltq_pci_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	ltq_pci_membase = devm_request_and_ioremap(&pdev->dev, res_bridge);
-	ltq_pci_mapped_cfg = devm_request_and_ioremap(&pdev->dev, res_cfg);
+	ltq_pci_membase = devm_ioremap_resource(&pdev->dev, res_bridge);
+	if (IS_ERR(ltq_pci_membase))
+		return PTR_ERR(ltq_pci_membase);
 
-	if (!ltq_pci_membase || !ltq_pci_mapped_cfg) {
-		dev_err(&pdev->dev, "failed to remap resources\n");
-		return -ENOMEM;
-	}
+	ltq_pci_mapped_cfg = devm_ioremap_resource(&pdev->dev, res_cfg);
+	if (IS_ERR(ltq_pci_mapped_cfg))
+		return PTR_ERR(ltq_pci_mapped_cfg);
 
 	ltq_pci_startup(pdev);
 
-- 
1.8.1.1

