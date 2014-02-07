Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaBGMjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:39:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41988 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbaBGLuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: robert.hodaszi@digi.com, Peter Chen <peter.chen@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/233] usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28
Date: Fri,  7 Feb 2014 11:45:42 +0000
Message-Id: <1391773652-25214-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 14362c0..87e310f 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -27,6 +27,26 @@
 #define pdev_to_phy(pdev) \
 	((struct usb_phy *)platform_get_drvdata(pdev))
 
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
@@ -98,6 +118,9 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	};
 	struct resource *res;
 	int ret;
+	const struct of_device_id *of_id =
+			of_match_device(ci_hdrc_imx_dt_ids, &pdev->dev);
+	const struct ci_hdrc_imx_platform_flag *imx_platform_flag = of_id->data;
 
 	if (of_find_property(pdev->dev.of_node, "fsl,usbmisc", NULL)
 		&& !usbmisc_ops)
@@ -157,6 +180,9 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 
 	pdata.phy = data->phy;
 
+	if (imx_platform_flag->flags & CI_HDRC_IMX_IMX28_WRITE_FIX)
+		pdata.flags |= CI_HDRC_IMX28_WRITE_FIX;
+
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
 	if (!pdev->dev.coherent_dma_mask)
@@ -228,12 +254,6 @@ static int ci_hdrc_imx_remove(struct platform_device *pdev)
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
-- 
1.8.3.2

