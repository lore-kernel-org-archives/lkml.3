Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbaDXRfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:35:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55334 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbaDXRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:35:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, carlo@caione.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] mfd: core: Don't use devres functions before device is added
Date: Thu, 24 Apr 2014 18:27:25 +0100
Message-Id: <1398360445-27107-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The supply aliases for the MFD devices were being added using devres but
the device hasn't been added at this point and as such we can't use
devres.

The MFD already has a function that removes devices this patch uses the
non-devres versions of the supply alias functions and adds an unregister
in mfd_remove_devices_fn.

Reported-by: Carlo Caione <carlo@caione.org>
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/mfd-core.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 2676492..892d343 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -102,7 +102,7 @@ static int mfd_add_device(struct device *parent, int id,
 	pdev->dev.dma_mask = parent->dma_mask;
 	pdev->dev.dma_parms = parent->dma_parms;
 
-	ret = devm_regulator_bulk_register_supply_alias(
+	ret = regulator_bulk_register_supply_alias(
 			&pdev->dev, cell->parent_supplies,
 			parent, cell->parent_supplies,
 			cell->num_parent_supplies);
@@ -182,9 +182,9 @@ static int mfd_add_device(struct device *parent, int id,
 	return 0;
 
 fail_alias:
-	devm_regulator_bulk_unregister_supply_alias(&pdev->dev,
-						    cell->parent_supplies,
-						    cell->num_parent_supplies);
+	regulator_bulk_unregister_supply_alias(&pdev->dev,
+					       cell->parent_supplies,
+					       cell->num_parent_supplies);
 fail_res:
 	kfree(res);
 fail_device:
@@ -238,6 +238,9 @@ static int mfd_remove_devices_fn(struct device *dev, void *c)
 	pdev = to_platform_device(dev);
 	cell = mfd_get_cell(pdev);
 
+	regulator_bulk_unregister_supply_alias(dev, cell->parent_supplies,
+					       cell->num_parent_supplies);
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;
-- 
1.7.2.5

