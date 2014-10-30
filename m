Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbaJ3Li1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:38:27 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49937 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759328AbaJ3Lgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:52 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_msm
Date: Thu, 30 Oct 2014 12:36:44 +0100
Message-Id: <1414669007-9850-4-git-send-email-antoine.tenart@free-electrons.com>
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
 drivers/usb/chipidea/ci_hdrc_msm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index 3edf969ed797..32eeab404911 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -55,10 +55,15 @@ static struct ci_hdrc_platform_data ci_hdrc_msm_platdata = {
 static int ci_hdrc_msm_probe(struct platform_device *pdev)
 {
 	struct platform_device *plat_ci;
+	struct ci_hdrc_platform_data *ci_pdata;
 	struct usb_phy *phy;
 
 	dev_dbg(&pdev->dev, "ci_hdrc_msm_probe\n");
 
+	ci_pdata = ci_hdrc_get_platdata(&pdev->dev, &ci_hdrc_msm_platdata);
+	if (IS_ERR(ci_pdata))
+		return PTR_ERR(ci_pdata);
+
 	/*
 	 * OTG(PHY) driver takes care of PHY initialization, clock management,
 	 * powering up VBUS, mapping of registers address space and power
@@ -68,11 +73,10 @@ static int ci_hdrc_msm_probe(struct platform_device *pdev)
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
-	ci_hdrc_msm_platdata.usb_phy = phy;
+	ci_pdata->usb_phy = phy;
 
 	plat_ci = ci_hdrc_add_device(&pdev->dev,
-				pdev->resource, pdev->num_resources,
-				&ci_hdrc_msm_platdata);
+				pdev->resource, pdev->num_resources, ci_pdata);
 	if (IS_ERR(plat_ci)) {
 		dev_err(&pdev->dev, "ci_hdrc_add_device failed!\n");
 		return PTR_ERR(plat_ci);
-- 
2.1.0

