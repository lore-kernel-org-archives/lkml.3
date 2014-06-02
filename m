Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaFBJJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:09:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38696 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbaFBJJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:09:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: core: Add the option to order destruction of MFD cells
Date: Mon,  2 Jun 2014 10:01:43 +0100
Message-Id: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes MFD children will have interdependancies. For example an MFD
device might contain a regulator cell and another cell which requires
that regulator to function. Probe deferral will ensure that these
devices probe in the correct order, however currently nothing ensures
they are destroyed in the correct order. As such it is possible for a
cell to be destroyed whilst another cell still expects it to exist. For
example the cell mentioned earlier would attempt to do a regulator_put
as part of its own tear-down but the regulator may have already been
destroyed.

This patch add a field remove_level to the mfd_cell data structure which
allows users to group the destruction of the MFD cells. Cells with a
lower remove_level will be destroyed first. This approach also doesn't
alter the destruction order for existing devices, so should be
no-op for devices not explicitly using it.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/mfd-core.c   |   33 +++++++++++++++++++++++++++++----
 include/linux/mfd/core.h |    3 +++
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 2676492..0c12787 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -226,11 +226,19 @@ fail:
 }
 EXPORT_SYMBOL(mfd_add_devices);
 
+struct mfd_remove_data {
+	atomic_t *cnts;
+
+	int level;
+	int next_level;
+};
+
 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
 	struct platform_device *pdev;
 	const struct mfd_cell *cell;
-	atomic_t **usage_count = c;
+	struct mfd_remove_data *rd = c;
+	atomic_t **usage_count = &rd->cnts;
 
 	if (dev->type != &mfd_dev_type)
 		return 0;
@@ -238,6 +246,15 @@ static int mfd_remove_devices_fn(struct device *dev, void *c)
 	pdev = to_platform_device(dev);
 	cell = mfd_get_cell(pdev);
 
+	if (rd->level < cell->remove_level) {
+		if (!rd->next_level || rd->next_level > cell->remove_level)
+			rd->next_level = cell->remove_level;
+
+		return 0;
+	}
+
+	dev_dbg(dev, "Removing from MFD\n");
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;
@@ -248,10 +265,18 @@ static int mfd_remove_devices_fn(struct device *dev, void *c)
 
 void mfd_remove_devices(struct device *parent)
 {
-	atomic_t *cnts = NULL;
+	struct mfd_remove_data rd = {};
+
+	do {
+		rd.level = rd.next_level;
+		rd.next_level = 0;
+
+		dev_dbg(parent, "Running remove for level: %d\n", rd.level);
+
+		device_for_each_child(parent, &rd, mfd_remove_devices_fn);
+	} while (rd.next_level);
 
-	device_for_each_child(parent, &cnts, mfd_remove_devices_fn);
-	kfree(cnts);
+	kfree(rd.cnts);
 }
 EXPORT_SYMBOL(mfd_remove_devices);
 
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index bdba8c6..40586a6 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -65,6 +65,9 @@ struct mfd_cell {
 	 */
 	const char		**parent_supplies;
 	int			num_parent_supplies;
+
+	/* Cells with a lower remove level will be destroyed first */
+	int			remove_level;
 };
 
 /*
-- 
1.7.2.5

