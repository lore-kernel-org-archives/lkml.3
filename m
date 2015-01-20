Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbbATUyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:54:45 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:43113
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbbATUyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:54:44 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 15:54:44 EST
x-originating-ip: 72.167.245.219
From: Jake Oshins <jakeo@microsoft.com>
To: gregkh@linuxfoundation.org, kys@microsoft.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, vkuznets@redhat.com
Cc: Jake Oshins <jakeo@microsoft.com>
Subject: [PATCH 1/1] drivers:hv:vmbus Allow for more than one MMIO range for children.
Date: Tue, 20 Jan 2015 13:59:40 -0800
Message-Id: <1421791180-18810-1-git-send-email-jakeo@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jake Oshins <jakeo@microsoft.com>
---
 drivers/hv/vmbus_drv.c          | 85 +++++++++++++++++++++++++++++++++--------
 drivers/video/fbdev/hyperv_fb.c |  2 +-
 include/linux/hyperv.h          |  2 +-
 3 files changed, 72 insertions(+), 17 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4d6b269..ba5b7a1 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -43,10 +43,7 @@ static struct tasklet_struct msg_dpc;
 static struct completion probe_event;
 static int irq;
 
-struct resource hyperv_mmio = {
-	.name  = "hyperv mmio",
-	.flags = IORESOURCE_MEM,
-};
+struct resource *hyperv_mmio;
 EXPORT_SYMBOL_GPL(hyperv_mmio);
 
 static int vmbus_exists(void)
@@ -849,23 +846,74 @@ void vmbus_device_unregister(struct hv_device *device_obj)
 
 
 /*
- * VMBUS is an acpi enumerated device. Get the the information we
- * need from DSDT.
+ * VMBUS is an acpi enumerated device. Get the
+ * information we need from DSDT.
  */
 
 static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
 {
+	resource_size_t start = 0;
+	resource_size_t end = 0;
+	struct resource *new_res;
+	struct resource **old_res = &hyperv_mmio;
+
 	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
 		irq = res->data.irq.interrupts[0];
+		return AE_OK;
+
+	/*
+	 * "Address" descriptors are for bus windows. Ignore
+	 * "memory" descriptors, which are for registers on
+	 * devices.
+	 */
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+		start = res->data.address32.minimum;
+		end = res->data.address32.maximum;
 		break;
 
 	case ACPI_RESOURCE_TYPE_ADDRESS64:
-		hyperv_mmio.start = res->data.address64.minimum;
-		hyperv_mmio.end = res->data.address64.maximum;
+		start = res->data.address64.minimum;
+		end = res->data.address64.maximum;
 		break;
+
+	default:
+		/* Unused resource type */
+		return AE_OK;
 	}
 
+	/*
+	 * Ignore ranges that are below 1MB, as they're not
+	 * necessary or useful here.
+	 */
+	if (end < 0x100000)
+		return AE_OK;
+
+	new_res = kzalloc(sizeof(*new_res), GFP_ATOMIC);
+	if (!new_res)
+		return AE_NO_MEMORY;
+
+	new_res->name = "hyperv mmio";
+	new_res->flags = IORESOURCE_MEM;
+	new_res->start = start;
+	new_res->end = end;
+
+	do {
+		if (!*old_res) {
+			*old_res = new_res;
+			break;
+		}
+
+		if ((*old_res)->start > new_res->end) {
+			new_res->sibling = *old_res;
+			*old_res = new_res;
+			break;
+		}
+
+		old_res = &(*old_res)->sibling;
+
+	} while (1);
+
 	return AE_OK;
 }
 
@@ -873,6 +921,7 @@ static int vmbus_acpi_add(struct acpi_device *device)
 {
 	acpi_status result;
 	int ret_val = -ENODEV;
+	struct acpi_device *ancestor;
 
 	hv_acpi_dev = device;
 
@@ -882,18 +931,22 @@ static int vmbus_acpi_add(struct acpi_device *device)
 	if (ACPI_FAILURE(result))
 		goto acpi_walk_err;
 	/*
-	 * The parent of the vmbus acpi device (Gen2 firmware) is the VMOD that
-	 * has the mmio ranges. Get that.
+	 * Some ancestor of the vmbus acpi device (Gen1 or Gen2
+	 * firmware) is the VMOD that has the mmio ranges. Get that.
 	 */
-	if (device->parent) {
-		result = acpi_walk_resources(device->parent->handle,
+	for (ancestor = device->parent;
+		ancestor;
+		ancestor = ancestor->parent) {
+		result = acpi_walk_resources(ancestor->handle,
 					METHOD_NAME__CRS,
 					vmbus_walk_resources, NULL);
 
 		if (ACPI_FAILURE(result))
-			goto acpi_walk_err;
-		if (hyperv_mmio.start && hyperv_mmio.end)
-			request_resource(&iomem_resource, &hyperv_mmio);
+			continue;
+		if (hyperv_mmio) {
+			request_resource(&iomem_resource, hyperv_mmio);
+			break;
+		}
 	}
 	ret_val = 0;
 
@@ -962,6 +1015,8 @@ static void __exit vmbus_exit(void)
 	hv_remove_vmbus_irq();
 	vmbus_free_channels();
 	bus_unregister(&hv_bus);
+	if (hyperv_mmio)
+		release_resource(hyperv_mmio);
 	hv_cleanup();
 	acpi_bus_unregister_driver(&vmbus_acpi_driver);
 }
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 4254336..003c8f0 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -686,7 +686,7 @@ static int hvfb_getmem(struct fb_info *info)
 	par->mem.name = KBUILD_MODNAME;
 	par->mem.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	if (gen2vm) {
-		ret = allocate_resource(&hyperv_mmio, &par->mem,
+		ret = allocate_resource(hyperv_mmio, &par->mem,
 					screen_fb_size,
 					0, -1,
 					screen_fb_size,
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 476c685..8903689 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1178,7 +1178,7 @@ int hv_vss_init(struct hv_util_service *);
 void hv_vss_deinit(void);
 void hv_vss_onchannelcallback(void *);
 
-extern struct resource hyperv_mmio;
+extern struct resource *hyperv_mmio;
 
 /*
  * Negotiated version with the Host.
-- 
1.9.1

