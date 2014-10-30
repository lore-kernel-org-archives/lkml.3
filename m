Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbaJ3Lit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:38:49 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49933 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759312AbaJ3Lgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:51 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_imx
Date: Thu, 30 Oct 2014 12:36:43 +0100
Message-Id: <1414669007-9850-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced ci_hdrc_get_platdata function to help setup the
chipidea internal ci_hdrc_platform_data structure.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 6f8b1b1045b5..25f3b465cb73 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -103,7 +103,8 @@ static struct imx_usbmisc_data *usbmisc_get_init_data(struct device *dev)
 static int ci_hdrc_imx_probe(struct platform_device *pdev)
 {
 	struct ci_hdrc_imx_data *data;
-	struct ci_hdrc_platform_data pdata = {
+	struct ci_hdrc_platform_data *ci_pdata;
+	struct ci_hdrc_platform_data ci_pdata_default = {
 		.name		= dev_name(&pdev->dev),
 		.capoffset	= DEF_CAPOFFSET,
 		.flags		= CI_HDRC_REQUIRE_TRANSCEIVER |
@@ -114,6 +115,10 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 			of_match_device(ci_hdrc_imx_dt_ids, &pdev->dev);
 	const struct ci_hdrc_imx_platform_flag *imx_platform_flag = of_id->data;
 
+	ci_pdata = ci_hdrc_get_platdata(&pdev->dev, &ci_pdata_default);
+	if (IS_ERR(ci_pdata))
+		return PTR_ERR(ci_pdata);
+
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		dev_err(&pdev->dev, "Failed to allocate ci_hdrc-imx data!\n");
@@ -147,10 +152,10 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	pdata.usb_phy = data->phy;
+	ci_pdata->usb_phy = data->phy;
 
 	if (imx_platform_flag->flags & CI_HDRC_IMX_IMX28_WRITE_FIX)
-		pdata.flags |= CI_HDRC_IMX28_WRITE_FIX;
+		ci_pdata->flags |= CI_HDRC_IMX28_WRITE_FIX;
 
 	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
@@ -166,8 +171,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	}
 
 	data->ci_pdev = ci_hdrc_add_device(&pdev->dev,
-				pdev->resource, pdev->num_resources,
-				&pdata);
+				pdev->resource, pdev->num_resources, ci_pdata);
 	if (IS_ERR(data->ci_pdev)) {
 		ret = PTR_ERR(data->ci_pdev);
 		dev_err(&pdev->dev,
-- 
2.1.0

