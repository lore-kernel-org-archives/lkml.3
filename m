Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaF3O03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:26:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaF3O01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:26:27 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH resend v2 1/3] mfd-core: Don't register supplies from add_device, add register_supply_aliases()
Date: Mon, 30 Jun 2014 16:26:07 +0200
Message-Id: <1404138369-23907-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
References: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot register supply alias in mfd_add_device before calling
platform_add_device because platform-dev's name must be set before registering
the aliases which happens from platform_add_device.

So stop registering supply aliases from mfd_add_device, and add a
mfd_register_supply_aliases helper functions for the cell's plaform driver
probe method to use.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/mfd/mfd-core.c   | 37 +++++++++++++++++++++----------------
 include/linux/mfd/core.h |  6 +++++-
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 892d343..03f6fee 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -102,13 +102,6 @@ static int mfd_add_device(struct device *parent, int id,
 	pdev->dev.dma_mask = parent->dma_mask;
 	pdev->dev.dma_parms = parent->dma_parms;
 
-	ret = regulator_bulk_register_supply_alias(
-			&pdev->dev, cell->parent_supplies,
-			parent, cell->parent_supplies,
-			cell->num_parent_supplies);
-	if (ret < 0)
-		goto fail_res;
-
 	if (parent->of_node && cell->of_compatible) {
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
@@ -122,12 +115,12 @@ static int mfd_add_device(struct device *parent, int id,
 		ret = platform_device_add_data(pdev,
 					cell->platform_data, cell->pdata_size);
 		if (ret)
-			goto fail_alias;
+			goto fail_res;
 	}
 
 	ret = mfd_platform_add_cell(pdev, cell, usage_count);
 	if (ret)
-		goto fail_alias;
+		goto fail_res;
 
 	for (r = 0; r < cell->num_resources; r++) {
 		res[r].name = cell->resources[r].name;
@@ -162,17 +155,17 @@ static int mfd_add_device(struct device *parent, int id,
 		if (!cell->ignore_resource_conflicts) {
 			ret = acpi_check_resource_conflict(&res[r]);
 			if (ret)
-				goto fail_alias;
+				goto fail_res;
 		}
 	}
 
 	ret = platform_device_add_resources(pdev, res, cell->num_resources);
 	if (ret)
-		goto fail_alias;
+		goto fail_res;
 
 	ret = platform_device_add(pdev);
 	if (ret)
-		goto fail_alias;
+		goto fail_res;
 
 	if (cell->pm_runtime_no_callbacks)
 		pm_runtime_no_callbacks(&pdev->dev);
@@ -181,10 +174,6 @@ static int mfd_add_device(struct device *parent, int id,
 
 	return 0;
 
-fail_alias:
-	regulator_bulk_unregister_supply_alias(&pdev->dev,
-					       cell->parent_supplies,
-					       cell->num_parent_supplies);
 fail_res:
 	kfree(res);
 fail_device:
@@ -289,5 +278,21 @@ int mfd_clone_cell(const char *cell, const char **clones, size_t n_clones)
 }
 EXPORT_SYMBOL(mfd_clone_cell);
 
+int mfd_register_supply_aliases(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell;
+
+	if (pdev->dev.type != &mfd_dev_type)
+		return -EINVAL;
+
+	cell = mfd_get_cell(pdev);
+
+	return devm_regulator_bulk_register_supply_alias(
+			&pdev->dev, cell->parent_supplies,
+			pdev->dev.parent, cell->parent_supplies,
+			cell->num_parent_supplies);
+}
+EXPORT_SYMBOL(mfd_register_supply_aliases);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ian Molton, Dmitry Baryshkov");
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index f543de9..f05488e 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -61,7 +61,9 @@ struct mfd_cell {
 	bool			pm_runtime_no_callbacks;
 
 	/* A list of regulator supplies that should be mapped to the MFD
-	 * device rather than the child device when requested
+	 * device rather than the child device when requested.
+	 * Drivers using this must call mfd_register_supply_aliases()
+	 * from their probe method.
 	 */
 	const char * const	*parent_supplies;
 	int			num_parent_supplies;
@@ -110,4 +112,6 @@ extern int mfd_add_devices(struct device *parent, int id,
 
 extern void mfd_remove_devices(struct device *parent);
 
+extern int mfd_register_supply_aliases(struct platform_device *pdev);
+
 #endif
-- 
2.0.0

