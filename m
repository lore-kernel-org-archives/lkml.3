Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaBSBSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:18:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62681 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751592AbaBSBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 8/9] ACPI / dock: Drop remove_dock_dependent_devices()
Date: Wed, 19 Feb 2014 02:32:12 +0100
Message-ID: <3723851.WP79lXh8Px@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3011875.q18rCmXyYX@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since remove_dock_dependent_devices() is only called from acpi_dock_add()
and it only is called if the add_dock_dependent_device() adding the
dock station to its own list of dependent devices has failed, it is not
really necessary, because the dock station's list of dependent devices
is guaranteed to be empty at that point.  Drop it, then.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -114,16 +114,6 @@ static int add_dock_dependent_device(str
 	return 0;
 }
 
-static void remove_dock_dependent_devices(struct dock_station *ds)
-{
-	struct dock_dependent_device *dd, *aux;
-
-	list_for_each_entry_safe(dd, aux, &ds->dependent_devices, list) {
-		list_del(&dd->list);
-		kfree(dd);
-	}
-}
-
 static void dock_hotplug_event(struct dock_dependent_device *dd, u32 event,
 			       enum dock_callback_type cb_type)
 {
@@ -674,8 +664,8 @@ void acpi_dock_add(struct acpi_device *a
 	return;
 
 err_rmgroup:
-	remove_dock_dependent_devices(dock_station);
 	sysfs_remove_group(&dd->dev.kobj, &dock_attribute_group);
+
 err_unregister:
 	platform_device_unregister(dd);
 	acpi_handle_err(handle, "%s encountered error %d\n", __func__, ret);

