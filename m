Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbaJ3Lh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:37:56 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49942 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759370AbaJ3Lgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:52 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_pci
Date: Thu, 30 Oct 2014 12:36:45 +0100
Message-Id: <1414669007-9850-5-git-send-email-antoine.tenart@free-electrons.com>
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
 drivers/usb/chipidea/ci_hdrc_pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
index 241ae3444fde..d2ffc651b650 100644
--- a/drivers/usb/chipidea/ci_hdrc_pci.c
+++ b/drivers/usb/chipidea/ci_hdrc_pci.c
@@ -51,16 +51,22 @@ static struct ci_hdrc_platform_data penwell_pci_platdata = {
 static int ci_hdrc_pci_probe(struct pci_dev *pdev,
 				       const struct pci_device_id *id)
 {
-	struct ci_hdrc_platform_data *platdata = (void *)id->driver_data;
+	struct ci_hdrc_platform_data *ci_pdata_default =
+			(void *)id->driver_data;
+	struct ci_hdrc_platform_data *ci_pdata;
 	struct platform_device *plat_ci;
 	struct resource res[3];
 	int retval = 0, nres = 2;
 
-	if (!platdata) {
+	if (!ci_pdata_default) {
 		dev_err(&pdev->dev, "device doesn't provide driver data\n");
 		return -ENODEV;
 	}
 
+	ci_pdata = ci_hdrc_get_platdata(&pdev->dev, ci_pdata_default);
+	if (IS_ERR(ci_pdata))
+		return PTR_ERR(ci_pdata);
+
 	retval = pcim_enable_device(pdev);
 	if (retval)
 		return retval;
@@ -80,7 +86,7 @@ static int ci_hdrc_pci_probe(struct pci_dev *pdev,
 	res[1].start	= pdev->irq;
 	res[1].flags	= IORESOURCE_IRQ;
 
-	plat_ci = ci_hdrc_add_device(&pdev->dev, res, nres, platdata);
+	plat_ci = ci_hdrc_add_device(&pdev->dev, res, nres, ci_pdata);
 	if (IS_ERR(plat_ci)) {
 		dev_err(&pdev->dev, "ci_hdrc_add_device failed!\n");
 		return PTR_ERR(plat_ci);
-- 
2.1.0

