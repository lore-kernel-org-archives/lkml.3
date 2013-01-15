Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab3AOWzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:55:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:47764 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934134Ab3AOWzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:55:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Peter Tyser <ptyser@xes-inc.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 15/71] mfd: Only unregister platform devices allocated by the mfd core
Date: Tue, 15 Jan 2013 14:54:12 -0800
Message-Id: <20130115225341.543197254@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/mfd-core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -18,6 +18,10 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
+static struct device_type mfd_dev_type = {
+	.name	= "mfd_device",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -87,6 +91,7 @@ static int mfd_add_device(struct device
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	pdev->dev.type = &mfd_dev_type;
 
 	if (cell->pdata_size) {
 		ret = platform_device_add_data(pdev,
@@ -182,10 +187,16 @@ EXPORT_SYMBOL(mfd_add_devices);
 
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


