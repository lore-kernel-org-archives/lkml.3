Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3FLXTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:19:20 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35480 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab3FLXS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:18:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 1/5] ACPI / scan: Do not bind ACPI drivers to objects with scan handlers
Date: Thu, 13 Jun 2013 01:23:48 +0200
Message-ID: <2446620.VEz51x3fQo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1417592.vuSG0cUIGo@vostro.rjw.lan>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

ACPI drivers generally should not be bound to device objects having
scan handlers attatched to them.

However, there is one exception which is the container scan handler.
Namely, it turns out that some BIOSes (on ia64 HP rx2600 in
particular) put container device IDs into the same objects along with
some other more specific ones which makes those device objects match
the container scan handler as well as some other scan handlers or
ACPI drivers.  Fortunately, though, the container scan handler is
only needed for hotplug to work and it doesn't actually do anything
to the device objects in question, so it is really OK to have both
the container scan handler and something else attached to the same
device object at the same time.

Following that, make acpi_device_probe() fail with -EINVAL if the
device object being probed has an ACPI scan handler that is not the
container scan handler attached to it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/container.c |    5 +++--
 drivers/acpi/internal.h  |   10 ++++++++++
 drivers/acpi/scan.c      |    4 ++++
 drivers/acpi/video.c     |    3 ---
 4 files changed, 17 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -51,7 +51,7 @@ static int container_device_attach(struc
 	return 1;
 }
 
-static struct acpi_scan_handler container_handler = {
+struct acpi_scan_handler container_scan_handler = {
 	.ids = container_device_ids,
 	.attach = container_device_attach,
 	.hotplug = {
@@ -62,5 +62,6 @@ static struct acpi_scan_handler containe
 
 void __init acpi_container_init(void)
 {
-	acpi_scan_add_handler_with_hotplug(&container_handler, "container");
+	acpi_scan_add_handler_with_hotplug(&container_scan_handler,
+					   "container");
 }
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -37,8 +37,18 @@ void acpi_processor_init(void);
 void acpi_platform_init(void);
 int acpi_sysfs_init(void);
 #ifdef CONFIG_ACPI_CONTAINER
+extern struct acpi_scan_handler container_scan_handler;
+
+static inline struct acpi_scan_handler *acpi_container_scan_handler(void)
+{
+	return &container_scan_handler;
+}
 void acpi_container_init(void);
 #else
+static inline struct acpi_scan_handler *acpi_container_scan_handler(void)
+{
+	return NULL;
+}
 static inline void acpi_container_init(void) {}
 #endif
 #ifdef CONFIG_ACPI_HOTPLUG_MEMORY
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -939,6 +939,10 @@ static int acpi_device_probe(struct devi
 	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
 	int ret;
 
+	if (acpi_dev->handler
+	    && acpi_dev->handler != acpi_container_scan_handler())
+		return -EINVAL;
+
 	if (!acpi_drv->ops.add)
 		return -ENOSYS;
 
Index: linux-pm/drivers/acpi/video.c
===================================================================
--- linux-pm.orig/drivers/acpi/video.c
+++ linux-pm/drivers/acpi/video.c
@@ -1722,9 +1722,6 @@ static int acpi_video_bus_add(struct acp
 	int error;
 	acpi_status status;
 
-	if (device->handler)
-		return -EINVAL;
-
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE,
 				device->parent->handle, 1,
 				acpi_video_bus_match, NULL,

