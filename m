Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab3BFXBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:01:48 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:11642 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3BFXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:01:15 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl, linux-acpi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, bhelgaas@google.com,
        mika.westerberg@linux.intel.com, matthew.garrett@nebula.com,
        yinghai@kernel.org, liuj97@gmail.com, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 02/02] ACPI: Register container drv as scan driver
Date: Wed,  6 Feb 2013 15:50:56 -0700
Message-Id: <1360191056-13293-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360191056-13293-1-git-send-email-toshi.kani@hp.com>
References: <1360191056-13293-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to register the ACPI container driver as an ACPI scan driver
so that sysfs eject of container devices works.

Fixed a typo in the acpi_container_init() prototype definition.
Removed struct acpi_container, which is no longer used.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---

This patch applies on top of the patch below.
https://lkml.org/lkml/2013/2/3/318

---
 drivers/acpi/container.c |   23 +++++++++++++++++++++++
 drivers/acpi/internal.h  |    2 +-
 include/acpi/container.h |    8 --------
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index bcde1f3..f493180 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -41,6 +41,10 @@
 #define _COMPONENT			ACPI_CONTAINER_COMPONENT
 ACPI_MODULE_NAME("container");
 
+static int container_device_attach(struct acpi_device *device,
+				const struct acpi_device_id *not_used);
+static void container_device_detach(struct acpi_device *device);
+
 static const struct acpi_device_id container_device_ids[] = {
 	{"ACPI0004", 0},
 	{"PNP0A05", 0},
@@ -48,6 +52,12 @@ static const struct acpi_device_id container_device_ids[] = {
 	{"", 0},
 };
 
+static struct acpi_scan_handler container_device_handler = {
+	.ids = container_device_ids,
+	.attach = container_device_attach,
+	.detach = container_device_detach,
+};
+
 static int is_device_present(acpi_handle handle)
 {
 	acpi_handle temp;
@@ -66,6 +76,17 @@ static int is_device_present(acpi_handle handle)
 	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
 }
 
+static int container_device_attach(struct acpi_device *device,
+				const struct acpi_device_id *not_used)
+{
+	return 1;
+}
+
+static void container_device_detach(struct acpi_device *device)
+{
+	return;
+}
+
 static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 {
 	struct acpi_device *device = NULL;
@@ -167,4 +188,6 @@ void __init acpi_container_init(void)
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
 			    acpi_container_register_notify_handler, NULL,
 			    NULL, NULL);
+
+	acpi_scan_add_handler(&container_device_handler);
 }
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 78fbf26..cbc0638 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -40,7 +40,7 @@ void acpi_memory_hotplug_init(void);
 #else
 static inline void acpi_memory_hotplug_init(void) {}
 #endif
-#ifdef ACPI_CONTAINER
+#ifdef CONFIG_ACPI_CONTAINER
 void acpi_container_init(void);
 #else
 static inline void acpi_container_init(void) {}
diff --git a/include/acpi/container.h b/include/acpi/container.h
index a703f14..0a464d2 100644
--- a/include/acpi/container.h
+++ b/include/acpi/container.h
@@ -1,12 +1,4 @@
 #ifndef __ACPI_CONTAINER_H
 #define __ACPI_CONTAINER_H
 
-#include <linux/kernel.h>
-
-struct acpi_container {
-	acpi_handle handle;
-	unsigned long sun;
-	int state;
-};
-
 #endif				/* __ACPI_CONTAINER_H */
