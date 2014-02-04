Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936036AbaBDWeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:34:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781AbaBDVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:07:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        robert.hodaszi@digi.com, Peter Chen <peter.chen@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.12 015/133] usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28
Date: Tue,  4 Feb 2014 13:06:56 -0800
Message-Id: <20140204210737.451786372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit 1071055e2a118a81c0b300d7f4af7eba3f7a7c82 upstream.

Due to imx28 needs ARM swp instruction for writing, we set
CI_HDRC_IMX28_WRITE_FIX for imx28.

This patch is needed for stable tree 3.11+

Cc: robert.hodaszi@digi.com
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/ci_hdrc_imx.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -23,6 +23,26 @@
 #include "ci.h"
 #include "ci_hdrc_imx.h"
 
+#define CI_HDRC_IMX_IMX28_WRITE_FIX BIT(0)
+
+struct ci_hdrc_imx_platform_flag {
+	unsigned int flags;
+};
+
+static const struct ci_hdrc_imx_platform_flag imx27_usb_data = {
+};
+
+static const struct ci_hdrc_imx_platform_flag imx28_usb_data = {
+	.flags = CI_HDRC_IMX_IMX28_WRITE_FIX,
+};
+
+static const struct of_device_id ci_hdrc_imx_dt_ids[] = {
+	{ .compatible = "fsl,imx28-usb", .data = &imx28_usb_data},
+	{ .compatible = "fsl,imx27-usb", .data = &imx27_usb_data},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ci_hdrc_imx_dt_ids);
+
 struct ci_hdrc_imx_data {
 	struct usb_phy *phy;
 	struct platform_device *ci_pdev;
@@ -82,6 +102,9 @@ static int ci_hdrc_imx_probe(struct plat
 				  CI_HDRC_DISABLE_STREAMING,
 	};
 	int ret;
+	const struct of_device_id *of_id =
+			of_match_device(ci_hdrc_imx_dt_ids, &pdev->dev);
+	const struct ci_hdrc_imx_platform_flag *imx_platform_flag = of_id->data;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
@@ -121,6 +144,9 @@ static int ci_hdrc_imx_probe(struct plat
 
 	pdata.phy = data->phy;
 
+	if (imx_platform_flag->flags & CI_HDRC_IMX_IMX28_WRITE_FIX)
+		pdata.flags |= CI_HDRC_IMX28_WRITE_FIX;
+
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
 	if (!pdev->dev.coherent_dma_mask)
@@ -187,12 +213,6 @@ static int ci_hdrc_imx_remove(struct pla
 	return 0;
 }
 
-static const struct of_device_id ci_hdrc_imx_dt_ids[] = {
-	{ .compatible = "fsl,imx27-usb", },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, ci_hdrc_imx_dt_ids);
-
 static struct platform_driver ci_hdrc_imx_driver = {
 	.probe = ci_hdrc_imx_probe,
 	.remove = ci_hdrc_imx_remove,


