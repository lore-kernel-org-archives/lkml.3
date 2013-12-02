Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3LBTOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3LBTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH 3.10 103/173] edac, highbank: Fix interrupt setup of mem and l2 controller
Date: Mon,  2 Dec 2013 11:11:26 -0800
Message-Id: <20131202191155.827008452@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@linaro.org>

commit a72b8859fd3941cc1d2940d5c43026d2c6fb959e upstream.

Register and enable interrupts after the edac registration. Otherwise
incomming ecc error interrupts lead to crashes during device setup.

Fixing this in drivers for mc and l2.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/highbank_l2_edac.c |   18 ++++++++++--------
 drivers/edac/highbank_mc_edac.c |   18 ++++++++++--------
 2 files changed, 20 insertions(+), 16 deletions(-)

--- a/drivers/edac/highbank_l2_edac.c
+++ b/drivers/edac/highbank_l2_edac.c
@@ -90,28 +90,30 @@ static int highbank_l2_err_probe(struct
 		goto err;
 	}
 
+	dci->mod_name = dev_name(&pdev->dev);
+	dci->dev_name = dev_name(&pdev->dev);
+
+	if (edac_device_add_device(dci))
+		goto err;
+
 	drvdata->db_irq = platform_get_irq(pdev, 0);
 	res = devm_request_irq(&pdev->dev, drvdata->db_irq,
 			       highbank_l2_err_handler,
 			       0, dev_name(&pdev->dev), dci);
 	if (res < 0)
-		goto err;
+		goto err2;
 
 	drvdata->sb_irq = platform_get_irq(pdev, 1);
 	res = devm_request_irq(&pdev->dev, drvdata->sb_irq,
 			       highbank_l2_err_handler,
 			       0, dev_name(&pdev->dev), dci);
 	if (res < 0)
-		goto err;
-
-	dci->mod_name = dev_name(&pdev->dev);
-	dci->dev_name = dev_name(&pdev->dev);
-
-	if (edac_device_add_device(dci))
-		goto err;
+		goto err2;
 
 	devres_close_group(&pdev->dev, NULL);
 	return 0;
+err2:
+	edac_device_del_device(&pdev->dev);
 err:
 	devres_release_group(&pdev->dev, NULL);
 	edac_device_free_ctl_info(dci);
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -189,14 +189,6 @@ static int highbank_mc_probe(struct plat
 		goto err;
 	}
 
-	irq = platform_get_irq(pdev, 0);
-	res = devm_request_irq(&pdev->dev, irq, highbank_mc_err_handler,
-			       0, dev_name(&pdev->dev), mci);
-	if (res < 0) {
-		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
-		goto err;
-	}
-
 	mci->mtype_cap = MEM_FLAG_DDR3;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_SECDED;
@@ -217,10 +209,20 @@ static int highbank_mc_probe(struct plat
 	if (res < 0)
 		goto err;
 
+	irq = platform_get_irq(pdev, 0);
+	res = devm_request_irq(&pdev->dev, irq, highbank_mc_err_handler,
+			       0, dev_name(&pdev->dev), mci);
+	if (res < 0) {
+		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
+		goto err2;
+	}
+
 	highbank_mc_create_debugfs_nodes(mci);
 
 	devres_close_group(&pdev->dev, NULL);
 	return 0;
+err2:
+	edac_mc_del_mc(&pdev->dev);
 err:
 	devres_release_group(&pdev->dev, NULL);
 	edac_mc_free(mci);


