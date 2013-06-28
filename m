Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3F1Wpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:45:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54515 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab3F1Wpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:45:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 3/3] ACPI / dock: Do not leak memory on falilures to add a dock station
Date: Sat, 29 Jun 2013 00:54:55 +0200
Message-ID: <2313676.eIEW9yukxj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1515394.L46AJCfCTt@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1515394.L46AJCfCTt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The function creating and registering dock station objects,
dock_add(), leaks memory if there's an error after it's walked
the ACPI namespace calling find_dock_devices(), because it doesn't
free the list of dependent devices it's just created in those cases.

Fix that issue by adding the missing code to free the list of
dependent devices on errors.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -119,6 +119,16 @@ add_dock_dependent_device(struct dock_st
 	return 0;
 }
 
+static void remove_dock_dependent_devices(struct dock_station *ds)
+{
+	struct dock_dependent_device *dd, *aux;
+
+	list_for_each_entry_safe(dd, aux, &ds->dependent_devices, list) {
+		list_del(&dd->list);
+		kfree(dd);
+	}
+}
+
 /**
  * dock_init_hotplug - Initialize a hotplug device on a docking station.
  * @dd: Dock-dependent device.
@@ -1008,6 +1018,7 @@ static int __init dock_add(acpi_handle h
 	return 0;
 
 err_rmgroup:
+	remove_dock_dependent_devices(dock_station);
 	sysfs_remove_group(&dd->dev.kobj, &dock_attribute_group);
 err_unregister:
 	platform_device_unregister(dd);

