Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab3JPLBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:01:09 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46627 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543Ab3JPLAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:00:16 -0400
From: Robert Richter <rric@kernel.org>
To: linux-edac@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH 4/5] edac, highbank: Improve and unify naming
Date: Wed, 16 Oct 2013 12:59:37 +0200
Message-Id: <1381921178-28511-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381921178-28511-1-git-send-email-rric@kernel.org>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Assinging correct names of the 'hb_mc_edac' and 'hb_l2_edac' edac
modules for module, controller and device. Reported values for
Highbank in dmesg are now:

 EDAC MC0: Giving out device to module hb_mc_edac controller
 calxeda,hb-ddr-ctrl: DEV fff00000.memory-controller (INTERRUPT)

 EDAC DEVICE0: Giving out device to module hb_l2_edac controller
 calxeda,hb-sregs-l2-ecc: DEV fff3c200.sregs (INTERRUPT)

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 drivers/edac/highbank_l2_edac.c | 17 ++++++++++-------
 drivers/edac/highbank_mc_edac.c |  5 +++--
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/highbank_l2_edac.c b/drivers/edac/highbank_l2_edac.c
index 10d3d29..2f19366 100644
--- a/drivers/edac/highbank_l2_edac.c
+++ b/drivers/edac/highbank_l2_edac.c
@@ -50,8 +50,15 @@ static irqreturn_t highbank_l2_err_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static const struct of_device_id hb_l2_err_of_match[] = {
+	{ .compatible = "calxeda,hb-sregs-l2-ecc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, hb_l2_err_of_match);
+
 static int highbank_l2_err_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *id;
 	struct edac_device_ctl_info *dci;
 	struct hb_l2_drvdata *drvdata;
 	struct resource *r;
@@ -90,7 +97,9 @@ static int highbank_l2_err_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	dci->mod_name = dev_name(&pdev->dev);
+	id = of_match_device(hb_l2_err_of_match, &pdev->dev);
+	dci->mod_name = pdev->dev.driver->name;
+	dci->ctl_name = id ? id->compatible : "unknown";
 	dci->dev_name = dev_name(&pdev->dev);
 
 	if (edac_device_add_device(dci))
@@ -129,12 +138,6 @@ static int highbank_l2_err_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id hb_l2_err_of_match[] = {
-	{ .compatible = "calxeda,hb-sregs-l2-ecc", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, hb_l2_err_of_match);
-
 static struct platform_driver highbank_l2_edac_driver = {
 	.probe = highbank_l2_err_probe,
 	.remove = highbank_l2_err_remove,
diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index 79cb872..8221191 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -233,9 +233,10 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	mci->mtype_cap = MEM_FLAG_DDR3;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_SECDED;
-	mci->mod_name = dev_name(&pdev->dev);
+	mci->mod_name = pdev->dev.driver->name;
 	mci->mod_ver = "1";
-	mci->ctl_name = dev_name(&pdev->dev);
+	mci->ctl_name = id->compatible;
+	mci->dev_name = dev_name(&pdev->dev);
 	mci->scrub_mode = SCRUB_SW_SRC;
 
 	/* Only a single 4GB DIMM is supported */
-- 
1.8.4.rc3

