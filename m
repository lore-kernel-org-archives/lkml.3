Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3AUKRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:17:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3AUKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:45 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Chris Ball <cjb@laptop.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 18/33] mmc: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:11 +0100
Message-Id: <1358762966-20791-19-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:1kTybBPnjeHa9zxc0sMLM4pCtNwFyxvRaJLu/RcFDay
 XOUJebwcrso/4uTOMQTGKpu9TvakyZddYRULixlMTEQZyRq8Yw
 +2geQbXTPQKgeFnDJ9rddFr2vDczONJkVr52dJEwWVcwdCOtG/
 FYPglMPqReUFr8XBS7OIE06dxGDHc5PtVT49D/EF87pqXgzU7w
 2/yxSIfWHrV+APsKoqOwNmPPRZCBKl30XBfqbTSJEApP/GgSne
 oADbTiqUMGlmNMo1cebe+jgDvzT8ML3YPq9uck910Dva5/m5ZG
 y8666WwzDkhWSWad4SKSL9STzeUjqzrUkiUlac4+c8KR3YtjGR
 GDgPqcx3l+fE1i+f6G+hSRee/pG/O5+kc1YtFSXCGre8hEurGd
 XKpcKZWt/3fF/UdjElgGd2U0YR7YIG7/k/SvYV5uI8m05dx9/3
 TSEws
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Chris Ball <cjb@laptop.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/host/dw_mmc-pltfm.c | 7 ++++---
 drivers/mmc/host/mxs-mmc.c      | 6 +++---
 drivers/mmc/host/sdhci-s3c.c    | 7 +++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
index 5e1fb1d..41c27b7 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.c
+++ b/drivers/mmc/host/dw_mmc-pltfm.c
@@ -10,6 +10,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/io.h>
@@ -46,9 +47,9 @@ int dw_mci_pltfm_register(struct platform_device *pdev,
 	host->dev = &pdev->dev;
 	host->irq_flags = 0;
 	host->pdata = pdev->dev.platform_data;
-	host->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!host->regs)
-		return -ENOMEM;
+	host->regs = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(host->regs))
+		return PTR_ERR(host->regs);
 
 	if (drv_data && drv_data->init) {
 		ret = drv_data->init(host);
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 206fe49..5b66555 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -614,9 +614,9 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 	host = mmc_priv(mmc);
 	ssp = &host->ssp;
 	ssp->dev = &pdev->dev;
-	ssp->base = devm_request_and_ioremap(&pdev->dev, iores);
-	if (!ssp->base) {
-		ret = -EADDRNOTAVAIL;
+	ssp->base = devm_ioremap_resource(&pdev->dev, iores);
+	if (IS_ERR(ssp->base)) {
+		ret = PTR_ERR(ssp->base);
 		goto out_mmc_free;
 	}
 
diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index 82a8de1..a0c6214 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -651,10 +651,9 @@ static int sdhci_s3c_probe(struct platform_device *pdev)
 #endif
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	host->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
-	if (!host->ioaddr) {
-		dev_err(dev, "failed to map registers\n");
-		ret = -ENXIO;
+	host->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->ioaddr)) {
+		ret = PTR_ERR(host->ioaddr);
 		goto err_req_regs;
 	}
 
-- 
1.8.1.1

