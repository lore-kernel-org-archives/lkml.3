Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3KMXF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:05:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52100 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751066Ab3KMXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:05:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/3] ACPI / hotplug: Fix PCI host bridge hot removal
Date: Thu, 14 Nov 2013 00:16:58 +0100
Message-ID: <3206422.AfXMUDqMXZ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since the PCI host bridge scan handler does not set hotplug.enabled,
the check of it in acpi_bus_device_eject() effectively prevents the
root bridge hot removal from working after commit a3b1b1ef78cd
(ACPI / hotplug: Merge device hot-removal routines).  However, that
check is not necessary, because the other acpi_bus_device_eject()
users, acpi_hotplug_notify_cb and acpi_eject_store(), do the same
check by themselves before executing that function.

For this reason, remove the scan handler check from
acpi_bus_device_eject() to make PCI hot bridge hot removal work
again.

Fixes: a3b1b1ef78cd (ACPI / hotplug: Merge device hot-removal routines)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -289,24 +289,17 @@ void acpi_bus_device_eject(void *data, u
 {
 	struct acpi_device *device = data;
 	acpi_handle handle = device->handle;
-	struct acpi_scan_handler *handler;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	int error;
 
 	lock_device_hotplug();
 	mutex_lock(&acpi_scan_lock);
 
-	handler = device->handler;
-	if (!handler || !handler->hotplug.enabled) {
-		put_device(&device->dev);
-		goto err_support;
-	}
-
 	if (ost_src == ACPI_NOTIFY_EJECT_REQUEST)
 		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
 					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 
-	if (handler->hotplug.mode == AHM_CONTAINER)
+	if (device->handler && device->handler->hotplug.mode == AHM_CONTAINER)
 		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 
 	error = acpi_scan_hot_remove(device);

