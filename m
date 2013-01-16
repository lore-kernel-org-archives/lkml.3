Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3APP7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3APP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 038/222] mfd: Only unregister platform devices allocated by the mfd core
Date: Wed, 16 Jan 2013 13:53:58 -0200
Message-Id: <1358351822-7675-39-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit b9fbb62eb61452d728c39b2e5020739c575aac53 upstream.

mfd_remove_devices would iterate over all devices sharing a parent with
an mfd device regardless of whether they were allocated by the mfd core
or not. This especially caused problems when the device structure was
not contained within a platform_device, because to_platform_device is
used on each device pointer.

This patch defines a device_type for mfd devices and checks this is
present from mfd_remove_devices_fn before processing the device.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Tested-by: Peter Tyser <ptyser@xes-inc.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mfd/mfd-core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index ffc3d48..ef80da6 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -19,6 +19,10 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
+static struct device_type mfd_dev_type = {
+	.name	= "mfd_device",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -88,6 +92,7 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	pdev->dev.type = &mfd_dev_type;
 
 	if (cell->pdata_size) {
 		ret = platform_device_add_data(pdev,
@@ -183,10 +188,16 @@ EXPORT_SYMBOL(mfd_add_devices);
 
 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct platform_device *pdev;
+	const struct mfd_cell *cell;
 	atomic_t **usage_count = c;
 
+	if (dev->type != &mfd_dev_type)
+		return 0;
+
+	pdev = to_platform_device(dev);
+	cell = mfd_get_cell(pdev);
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;
-- 
1.7.9.5

