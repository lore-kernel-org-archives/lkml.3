Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3AUKNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:13:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3AUKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:18 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH 26/33] staging: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:19 +0100
Message-Id: <1358762966-20791-27-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:d5+L7e9O/vvwUzJpYMw3RnR5xSoF8N62dHrjQ6KHwV1
 AxZfmzUCNK97w37yyN2ch5ZwBtL0KkDkYVv+WnH8yoUL0kMUrO
 d/puKm5mynQjgtCdy9l8j7qWXZltXPMMohOD4VNVE/PIyrOrGT
 BRMU9MFKnvH6UZZJAvCdcBxe1l2Vay4tzft85tyxo6EJh51NEM
 45jsaXzBa7T8sLmX6CuWmP+c2jdpFel5FdAk96NnK4ddgAuRy/
 1aekumybhWdEDrbn7GR1ZwJ/Z6a6UqaYPNpmq6E22NMkHAfPzq
 MlADE5L0O4SjlMwnqrEixVPYdf4UEaMdkFD1E3RTZrQU5M3Lpp
 Lo/K2Mp1ibNWJFUBWmDsrXlZ5nfXJiab0cIMOUQukd26ly+sKZ
 dBpzkY+mSPZR8lTD/Yvgn67pNdJUl6DvLKM9WEh3Y07U29G6eD
 ngevm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/iio/adc/mxs-lradc.c         |  7 ++++---
 drivers/staging/nvec/nvec.c                 |  8 +++-----
 drivers/staging/omap-thermal/omap-bandgap.c | 11 ++++-------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index c5ceb9d..3d562da 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -15,6 +15,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -487,9 +488,9 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 	/* Grab the memory area */
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lradc->dev = &pdev->dev;
-	lradc->base = devm_request_and_ioremap(dev, iores);
-	if (!lradc->base) {
-		ret = -EADDRNOTAVAIL;
+	lradc->base = devm_ioremap_resource(dev, iores);
+	if (IS_ERR(lradc->base)) {
+		ret = PTR_ERR(lradc->base);
 		goto err_addr;
 	}
 
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 2830946..492e0b6 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -759,11 +759,9 @@ static int tegra_nvec_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base) {
-		dev_err(&pdev->dev, "Can't ioremap I2C region\n");
-		return -ENOMEM;
-	}
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 8346e345..21fd91b 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -820,15 +820,12 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res)
 			break;
-		chunk = devm_request_and_ioremap(&pdev->dev, res);
+		chunk = devm_ioremap_resource(&pdev->dev, res);
 		if (i == 0)
 			bg_ptr->base = chunk;
-		if (!chunk) {
-			dev_err(&pdev->dev,
-				"failed to request the IO (%d:%pR).\n",
-				i, res);
-			return ERR_PTR(-EADDRNOTAVAIL);
-		}
+		if (IS_ERR(chunk))
+			return ERR_CAST(chunk);
+		
 		i++;
 	} while (res);
 
-- 
1.8.1.1

