Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3KQQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:26:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56967 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754130Ab3KQQZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 7/10] ACPI / hotplug: Move container-specific code out of the core
Date: Sun, 17 Nov 2013 17:36 +0100
Message-ID: <2547688.l8Q1XKb3Ol@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1421028.Rsfpmhnym3@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Move container-specific uevents from the core hotplug code to the
container scan handler's .attach() and .detach() callbacks.

This way the core will not have to special-case containers and
the uevents will be guaranteed to happen every time a container
is either scanned or trimmed as appropriate.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/container.c |   11 ++++++++---
 drivers/acpi/scan.c      |    8 +-------
 include/acpi/acpi_bus.h  |    7 -------
 3 files changed, 9 insertions(+), 17 deletions(-)

Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -44,19 +44,24 @@ static const struct acpi_device_id conta
 	{"", 0},
 };
 
-static int container_device_attach(struct acpi_device *device,
+static int container_device_attach(struct acpi_device *adev,
 				   const struct acpi_device_id *not_used)
 {
-	/* This is necessary for container hotplug to work. */
+	kobject_uevent(&adev->dev.kobj, KOBJ_ONLINE);
 	return 1;
 }
 
+static void container_device_detach(struct acpi_device *adev)
+{
+	kobject_uevent(&adev->dev.kobj, KOBJ_OFFLINE);
+}
+
 static struct acpi_scan_handler container_handler = {
 	.ids = container_device_ids,
 	.attach = container_device_attach,
+	.detach = container_device_detach,
 	.hotplug = {
 		.enabled = true,
-		.mode = AHM_CONTAINER,
 	},
 };
 
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -206,9 +206,6 @@ static int acpi_scan_hot_remove(struct a
 	acpi_status status;
 	unsigned long long sta;
 
-	if (device->handler && device->handler->hotplug.mode == AHM_CONTAINER)
-		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
-
 	/*
 	 * Carry out two passes here and ignore errors in the first pass,
 	 * because if the devices in question are memory blocks and
@@ -288,10 +285,7 @@ static int acpi_scan_device_check(struct
 		dev_warn(&adev->dev, "Namespace scan failure\n");
 		return error;
 	}
-	if (adev->handler) {
-		if (adev->handler->hotplug.mode == AHM_CONTAINER)
-			kobject_uevent(&adev->dev.kobj, KOBJ_ONLINE);
-	} else {
+	if (!adev->handler) {
 		dev_warn(&adev->dev, "Enumeration failure\n");
 		return -ENODEV;
 	}
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -91,16 +91,9 @@ struct acpi_device;
  * -----------------
  */
 
-enum acpi_hotplug_mode {
-	AHM_GENERIC = 0,
-	AHM_CONTAINER,
-	AHM_COUNT
-};
-
 struct acpi_hotplug_profile {
 	struct kobject kobj;
 	bool enabled:1;
-	enum acpi_hotplug_mode mode;
 	int (*scan_dependent)(struct acpi_device *adev);
 };
 

