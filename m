Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab3JOTYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:24:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41397 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933495Ab3JOTX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:23:57 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, lee.jones@linaro.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3 v2] mfd: Allow mapping regulator supplies to MFD device from children
Date: Tue, 15 Oct 2013 20:14:21 +0100
Message-Id: <1381864462-26167-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occasionally, it is useful to map supplies from a child device onto the
MFD device. A typical usecase for this would be if the MFD device is
represented as a single node in device tree. All supplies will be
defined in device tree as existing on the MFD device. When a child
depends on frameworks which might have no knowledge of MFD to lookup
supplies on its behalf the supply will not be found.

This patch adds a list of supplies that should be looked up on the
parent rather than the child as part of the mfd_cell structure.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/mfd-core.c   |   22 +++++++++++++++++-----
 include/linux/mfd/core.h |    6 ++++++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index f421586..adc8ea3 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/irqdomain.h>
 #include <linux/of.h>
+#include <linux/regulator/consumer.h>
 
 static struct device_type mfd_dev_type = {
 	.name	= "mfd_device",
@@ -99,6 +100,13 @@ static int mfd_add_device(struct device *parent, int id,
 	pdev->dev.dma_mask = parent->dma_mask;
 	pdev->dev.dma_parms = parent->dma_parms;
 
+	ret = devm_regulator_bulk_register_supply_alias(
+			&pdev->dev, cell->parent_supplies,
+			parent, cell->parent_supplies,
+			cell->num_parent_supplies);
+	if (ret < 0)
+		goto fail_res;
+
 	if (parent->of_node && cell->of_compatible) {
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
@@ -112,12 +120,12 @@ static int mfd_add_device(struct device *parent, int id,
 		ret = platform_device_add_data(pdev,
 					cell->platform_data, cell->pdata_size);
 		if (ret)
-			goto fail_res;
+			goto fail_alias;
 	}
 
 	ret = mfd_platform_add_cell(pdev, cell);
 	if (ret)
-		goto fail_res;
+		goto fail_alias;
 
 	for (r = 0; r < cell->num_resources; r++) {
 		res[r].name = cell->resources[r].name;
@@ -152,17 +160,17 @@ static int mfd_add_device(struct device *parent, int id,
 		if (!cell->ignore_resource_conflicts) {
 			ret = acpi_check_resource_conflict(&res[r]);
 			if (ret)
-				goto fail_res;
+				goto fail_alias;
 		}
 	}
 
 	ret = platform_device_add_resources(pdev, res, cell->num_resources);
 	if (ret)
-		goto fail_res;
+		goto fail_alias;
 
 	ret = platform_device_add(pdev);
 	if (ret)
-		goto fail_res;
+		goto fail_alias;
 
 	if (cell->pm_runtime_no_callbacks)
 		pm_runtime_no_callbacks(&pdev->dev);
@@ -171,6 +179,10 @@ static int mfd_add_device(struct device *parent, int id,
 
 	return 0;
 
+fail_alias:
+	devm_regulator_bulk_unregister_supply_alias(&pdev->dev,
+						    cell->parent_supplies,
+						    cell->num_parent_supplies);
 fail_res:
 	kfree(res);
 fail_device:
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index cebe97e..7314fc4 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -59,6 +59,12 @@ struct mfd_cell {
 	 * pm_runtime_no_callbacks().
 	 */
 	bool			pm_runtime_no_callbacks;
+
+	/* A list of regulator supplies that should be mapped to the MFD
+	 * device rather than the child device when requested
+	 */
+	const char		**parent_supplies;
+	int			num_parent_supplies;
 };
 
 /*
-- 
1.7.2.5

