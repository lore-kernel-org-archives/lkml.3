Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746Ab3JPLBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:01:34 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:55747 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596Ab3JPLAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:00:12 -0400
From: Robert Richter <rric@kernel.org>
To: linux-edac@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH 1/5] edac, highbank: Fix interrupt setup of mem and l2 controller
Date: Wed, 16 Oct 2013 12:59:34 +0200
Message-Id: <1381921178-28511-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381921178-28511-1-git-send-email-rric@kernel.org>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Register and enable interrupts after the edac registration. Otherwise
incomming ecc error interrupts lead to crashes during device setup.

Fixing this in drivers for mc and l2.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 drivers/edac/highbank_l2_edac.c | 18 ++++++++++--------
 drivers/edac/highbank_mc_edac.c | 18 ++++++++++--------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/highbank_l2_edac.c b/drivers/edac/highbank_l2_edac.c
index c2bd8c6..10d3d29 100644
--- a/drivers/edac/highbank_l2_edac.c
+++ b/drivers/edac/highbank_l2_edac.c
@@ -90,28 +90,30 @@ static int highbank_l2_err_probe(struct platform_device *pdev)
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
diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index 4695dd2..7a78307 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -189,14 +189,6 @@ static int highbank_mc_probe(struct platform_device *pdev)
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
@@ -217,10 +209,20 @@ static int highbank_mc_probe(struct platform_device *pdev)
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
-- 
1.8.4.rc3

