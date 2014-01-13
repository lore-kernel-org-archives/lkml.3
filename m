Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaAMVig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:38:36 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:38722 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbaAMVie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:38:34 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCHv1] driver core/platform: don't leak memory allocated for dma_mask
Date: Mon, 13 Jan 2014 22:38:05 +0100
Message-Id: <1389649085-7365-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386886207-2735-1-git-send-email-ydroneaud@opteya.com>
References: <1386886207-2735-1-git-send-email-ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a dma_mask is provided as part of platform_device_info,
platform_device_register_full() allocate memory for a u64
using kmalloc().

A comment in the code state that "[t]his memory isn't freed
when the device is put".

It's never a good thing to leak memory, but there's only very
few users of platform_device_info's dma_mask, and those are mostly
"static" devices that are not going to be plugged/unplugged.

So memory leak is not really an issue, but allocating 8 bytes
through kmalloc() seems overkill, so this patch moves dma_mask
after the platform_device struct, dynamically allocated along
the name buffer.

With dma_mask part of the memory allocated for the platform_device
struct, like name buffer, it will be released with it:
no memory leak, no small allocation.

The drawback is the additional code needed to handle
dma_mask allocation:

Before (on next-20140113 with gcc-4.8):
   text	   data	    bss	    dec	    hex	filename
   5600	    472	     32	   6104	   17d8	obj-arm/drivers/base/platform.o
   5927	    532	     32	   6491	   195b	obj-i386/drivers/base/platform.o
   7036	    960	     48	   8044	   1f6c	obj-x86_64/drivers/base/platform.o

After:
   text	   data	    bss	    dec	    hex	filename
   5672	    472	     32	   6176	   1820	obj-arm/drivers/base/platform.o
   6007	    532	     32	   6571	   19ab	obj-i386/drivers/base/platform.o
   7132	    960	     48	   8140	   1fcc	obj-x86_64/drivers/base/platform.o

Changes from v0 [1]:
- small rewrite to squeeze the patch to a bare minimal

[1] http://lkml.kernel.org/r/1386886207-2735-1-git-send-email-ydroneaud@opteya.com

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/base/platform.c | 82 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 20 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3a94b799f166..0741be056885 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
 
 struct platform_object {
 	struct platform_device pdev;
-	char name[1];
+	char payload[0];
 };
 
 /**
@@ -186,6 +186,25 @@ static void platform_device_release(struct device *dev)
 	kfree(pa);
 }
 
+static struct platform_object *platform_object_alloc(size_t payload)
+{
+	struct platform_object *pa;
+
+	pa = kzalloc(sizeof(*pa) + payload, GFP_KERNEL);
+
+	return pa;
+}
+
+static void platform_object_init(struct platform_object *pa,
+				 const char *name, int id)
+{
+	pa->pdev.name = name;
+	pa->pdev.id = id;
+	device_initialize(&pa->pdev.dev);
+	pa->pdev.dev.release = platform_device_release;
+	arch_setup_pdev_archdata(&pa->pdev);
+}
+
 /**
  * platform_device_alloc - create a platform device
  * @name: base name of the device we're adding
@@ -198,14 +217,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 {
 	struct platform_object *pa;
 
-	pa = kzalloc(sizeof(struct platform_object) + strlen(name), GFP_KERNEL);
+	pa = platform_object_alloc(strlen(name) + 1);
 	if (pa) {
-		strcpy(pa->name, name);
-		pa->pdev.name = pa->name;
-		pa->pdev.id = id;
-		device_initialize(&pa->pdev.dev);
-		pa->pdev.dev.release = platform_device_release;
-		arch_setup_pdev_archdata(&pa->pdev);
+		strcpy(pa->payload, name);
+		platform_object_init(pa, pa->payload, id);
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -213,6 +228,39 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 EXPORT_SYMBOL_GPL(platform_device_alloc);
 
 /**
+ * platform_device_dmamask_alloc - create a platform device suitable to hold a dmamask
+ * @name: base name of the device we're adding
+ * @id: instance id
+ *
+ * Create a platform device object which can have other objects attached
+ * to it, and which will have attached objects freed when it is released.
+ */
+static struct platform_device *platform_device_dmamask_alloc(const char *name,
+							     int id)
+{
+	struct platform_object *pa;
+	const size_t padding = (((offsetof(struct platform_object, payload) +
+				  (__alignof__(u64) - 1)) &
+				 ~(__alignof__(u64) - 1)) -
+				offsetof(struct platform_object, payload));
+
+	pa = platform_object_alloc(padding + sizeof(u64) + strlen(name) + 1);
+	if (pa) {
+		char *payload = pa->payload + padding;
+		/*
+		 * Conceptually dma_mask in struct device should not be a pointer.
+		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
+		 */
+		pa->pdev.dev.dma_mask = (void *)payload;
+		payload += sizeof(u64);
+		strcpy(payload, name);
+		platform_object_init(pa, payload, id);
+	}
+
+	return pa ? &pa->pdev : NULL;
+}
+
+/**
  * platform_device_add_resources - add resources to a platform device
  * @pdev: platform device allocated by platform_device_alloc to add resources to
  * @res: set of resources that needs to be allocated for the device
@@ -427,7 +475,12 @@ struct platform_device *platform_device_register_full(
 	int ret = -ENOMEM;
 	struct platform_device *pdev;
 
-	pdev = platform_device_alloc(pdevinfo->name, pdevinfo->id);
+	if (!pdevinfo->dma_mask)
+		pdev = platform_device_alloc(pdevinfo->name, pdevinfo->id);
+	else
+		pdev = platform_device_dmamask_alloc(pdevinfo->name,
+						     pdevinfo->id);
+
 	if (!pdev)
 		goto err_alloc;
 
@@ -435,17 +488,6 @@ struct platform_device *platform_device_register_full(
 	ACPI_COMPANION_SET(&pdev->dev, pdevinfo->acpi_node.companion);
 
 	if (pdevinfo->dma_mask) {
-		/*
-		 * This memory isn't freed when the device is put,
-		 * I don't have a nice idea for that though.  Conceptually
-		 * dma_mask in struct device should not be a pointer.
-		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
-		 */
-		pdev->dev.dma_mask =
-			kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
-		if (!pdev->dev.dma_mask)
-			goto err;
-
 		*pdev->dev.dma_mask = pdevinfo->dma_mask;
 		pdev->dev.coherent_dma_mask = pdevinfo->dma_mask;
 	}
-- 
1.8.4.2

