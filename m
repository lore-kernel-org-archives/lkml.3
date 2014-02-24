Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBXKZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:25:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaBXKZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:25:48 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, abgupta@microsoft.com, haiyangz@microsoft.com,
        jasowang@redhat.com, tomi.valkeinen@ti.com,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...)
Subject: [PATCH v2 1/5] Drivers: hv: vmbus: Extract the mmio information from DSDT
Date: Mon, 24 Feb 2014 11:25:12 +0100
Message-Id: <1393237516-28545-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
References: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

On Gen2 firmware, Hyper-V does not emulate the PCI bus. However, the MMIO
information is packaged up in DSDT. Extract this information and export it
for use by the synthetic framebuffer driver. This is the only driver that
needs this currently.

In this version of the patch mmio, I have updated the hyperv header file
(linux/hyperv.h) with mmio definitions.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/vmbus_drv.c | 45 ++++++++++++++++++++++++++++++++-------------
 include/linux/hyperv.h |  3 +++
 2 files changed, 35 insertions(+), 13 deletions(-)

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
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 344883d..be3028f 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1459,6 +1459,9 @@ int hv_vss_init(struct hv_util_service *);
 void hv_vss_deinit(void);
 void hv_vss_onchannelcallback(void *);
 
+extern u64 hyperv_mmio_start;
+extern u64 hyperv_mmio_size;
+
 /*
  * Negotiated version with the Host.
  */
-- 
1.8.3.1

