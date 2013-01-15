Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab3AOW2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:28:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:41435 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757643Ab3AOW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Peter Tyser <ptyser@xes-inc.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 052/221] mfd: Only unregister platform devices allocated by the mfd core
Date: Tue, 15 Jan 2013 10:49:39 -0800
Message-Id: <20130115185001.780484285@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -21,6 +21,10 @@
 #include <linux/irqdomain.h>
 #include <linux/of.h>
 
+static struct device_type mfd_dev_type = {
+	.name	= "mfd_device",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -91,6 +95,7 @@ static int mfd_add_device(struct device
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	pdev->dev.type = &mfd_dev_type;
 
 	if (parent->of_node && cell->of_compatible) {
 		for_each_child_of_node(parent->of_node, np) {
@@ -204,10 +209,16 @@ EXPORT_SYMBOL(mfd_add_devices);
 
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


