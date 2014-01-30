Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaA2Xbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:31:36 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49267
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbaA2Xbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:31:35 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Extract the mmio information from VMOD
Date: Wed, 29 Jan 2014 16:21:38 -0800
Message-Id: <1391041298-12973-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Gen2 firmware, Hyper-V does not emulate the PCI bus. However, the MMIO
information is packaged up in DSDT. Extract this information and export it
for use by the synthetic framebuffer driver. This is the only driver that
needs this currently.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/vmbus_drv.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 077bb1b..b37c91b 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -43,6 +43,10 @@ static struct acpi_device  *hv_acpi_dev;
 static struct tasklet_struct msg_dpc;
 static struct completion probe_event;
 static int irq;
+u64 hyperv_mmio_start;
+EXPORT_SYMBOL_GPL(hyperv_mmio_start);
+u64 hyperv_mmio_size;
+EXPORT_SYMBOL_GPL(hyperv_mmio_size);
 
 static int vmbus_exists(void)
 {
@@ -886,18 +890,19 @@ void vmbus_device_unregister(struct hv_device *device_obj)
 
 
 /*
- * VMBUS is an acpi enumerated device. Get the the IRQ information
- * from DSDT.
+ * VMBUS is an acpi enumerated device. Get the the information we
+ * need from DSDT.
  */
 
-static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *irq)
+static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
 {
+	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_IRQ:
+		irq = res->data.irq.interrupts[0];
 
-	if (res->type == ACPI_RESOURCE_TYPE_IRQ) {
-		struct acpi_resource_irq *irqp;
-		irqp = &res->data.irq;
-
-		*((unsigned int *)irq) = irqp->interrupts[0];
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+		hyperv_mmio_start = res->data.address64.minimum;
+		hyperv_mmio_size = res->data.address64.address_length;
 	}
 
 	return AE_OK;
@@ -906,18 +911,32 @@ static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *irq)
 static int vmbus_acpi_add(struct acpi_device *device)
 {
 	acpi_status result;
+	int ret_val = -ENODEV;
 
 	hv_acpi_dev = device;
 
 	result = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
-					vmbus_walk_resources, &irq);
+					vmbus_walk_resources, NULL);
 
-	if (ACPI_FAILURE(result)) {
-		complete(&probe_event);
-		return -ENODEV;
+	if (ACPI_FAILURE(result))
+		goto acpi_walk_err;
+	/*
+	 * The parent of the vmbus acpi device (Gen2 firmware) is the VMOD that
+	 * has the mmio ranges. Get that.
+	 */
+	if (device->parent) {
+		result = acpi_walk_resources(device->parent->handle,
+					METHOD_NAME__CRS,
+					vmbus_walk_resources, NULL);
+
+		if (ACPI_FAILURE(result))
+			goto acpi_walk_err;
 	}
+	ret_val = 0;
+
+acpi_walk_err:
 	complete(&probe_event);
-	return 0;
+	return ret_val;
 }
 
 static const struct acpi_device_id vmbus_acpi_device_ids[] = {
-- 
1.7.4.1

