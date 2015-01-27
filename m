Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbbA0Wdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:33:36 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:38166
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680AbbA0Wdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:33:33 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com, tglx@linutronix.de
Cc: Jake Oshins <"[mailto:jakeo@microsoft.com]"@linuxonhyperv.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 3/8] drivers:hv:vmbus drivers:hv:vmbus Allow for more than one MMIO range for children
Date: Tue, 27 Jan 2015 15:46:43 -0800
Message-Id: <1422402408-5504-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1422402408-5504-1-git-send-email-kys@microsoft.com>
References: <1422402376-5463-1-git-send-email-kys@microsoft.com>
 <1422402408-5504-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jake Oshins <[mailto:jakeo@microsoft.com]>

This set of changes finds the _CRS object in the ACPI namespace
that contains memory address space descriptors, intended to convey
to VMBus which ranges of memory-mapped I/O space are available for
child devices, and then builds a resource list that contains all
those ranges.  Without this change, only some of the memory-mapped
I/O space will be available for child devices, and only in some
virtual BIOS configurations (Generation 2 VMs).

Signed-off-by: Jake Oshins <jakeo@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/vmbus_drv.c          |   97 +++++++++++++++++++++++++++++++++------
 drivers/video/fbdev/hyperv_fb.c |    2 +-
 include/linux/hyperv.h          |    2 +-
 3 files changed, 85 insertions(+), 16 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index e334ccc..aebc8fe 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -45,10 +45,7 @@ static struct tasklet_struct msg_dpc;
 static struct completion probe_event;
 static int irq;
 
-struct resource hyperv_mmio = {
-	.name  = "hyperv mmio",
-	.flags = IORESOURCE_MEM,
-};
+struct resource *hyperv_mmio;
 EXPORT_SYMBOL_GPL(hyperv_mmio);
 
 static int vmbus_exists(void)
@@ -915,30 +912,98 @@ void vmbus_device_unregister(struct hv_device *device_obj)
 
 
 /*
- * VMBUS is an acpi enumerated device. Get the the information we
+ * VMBUS is an acpi enumerated device. Get the information we
  * need from DSDT.
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
+		start = res->data.address32.address.minimum;
+		end = res->data.address32.address.maximum;
 		break;
 
 	case ACPI_RESOURCE_TYPE_ADDRESS64:
-		hyperv_mmio.start = res->data.address64.address.minimum;
-		hyperv_mmio.end = res->data.address64.address.maximum;
+		start = res->data.address64.address.minimum;
+		end = res->data.address64.address.maximum;
 		break;
+
+	default:
+		/* Unused resource type */
+		return AE_OK;
+
 	}
+	/*
+	 * Ignore ranges that are below 1MB, as they're not
+	 * necessary or useful here.
+	*/
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
 
 	return AE_OK;
 }
 
+static int vmbus_acpi_remove(struct acpi_device *device)
+{
+	struct resource *cur_res;
+	struct resource *next_res;
+
+	if (hyperv_mmio) {
+		release_resource(hyperv_mmio);
+		for (cur_res = hyperv_mmio; cur_res; cur_res = next_res) {
+			next_res = cur_res->sibling;
+			kfree(cur_res);
+		}
+	}
+
+	return 0;
+}
+
 static int vmbus_acpi_add(struct acpi_device *device)
 {
 	acpi_status result;
 	int ret_val = -ENODEV;
+	struct acpi_device *ancestor;
 
 	hv_acpi_dev = device;
 
@@ -948,23 +1013,26 @@ static int vmbus_acpi_add(struct acpi_device *device)
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
+	for (ancestor = device->parent; ancestor; ancestor = ancestor->parent) {
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
 
 acpi_walk_err:
 	complete(&probe_event);
+	vmbus_acpi_remove(device);
 	return ret_val;
 }
 
@@ -980,6 +1048,7 @@ static struct acpi_driver vmbus_acpi_driver = {
 	.ids = vmbus_acpi_device_ids,
 	.ops = {
 		.add = vmbus_acpi_add,
+		.remove = vmbus_acpi_remove,
 	},
 };
 
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
index 26a32b7..e73cfeb 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1217,7 +1217,7 @@ int hv_vss_init(struct hv_util_service *);
 void hv_vss_deinit(void);
 void hv_vss_onchannelcallback(void *);
 
-extern struct resource hyperv_mmio;
+extern struct resource *hyperv_mmio;
 
 /*
  * Negotiated version with the Host.
-- 
1.7.4.1

