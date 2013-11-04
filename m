Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3KDN0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:26:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59448 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752535Ab3KDN0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:26:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [Update][PATCH 5/6] ACPI / hotplug: Make acpi_bus_hot_remove_device() internal
Date: Mon, 04 Nov 2013 14:36:49 +0100
Message-ID: <3547159.OBIzEY7xch@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2970389.SeMGM45Qln@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Notice that handle_root_bridge_removal() is the only user of
acpi_bus_hot_remove_device(), so it doesn't have to be exported
any more and can be made internal to the ACPI core.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    1 +
 drivers/acpi/pci_root.c |    2 ++
 drivers/acpi/scan.c     |    1 -
 include/acpi/acpi_bus.h |    1 -
 4 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -92,6 +92,7 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 int acpi_bind_one(struct device *dev, acpi_handle handle);
 int acpi_unbind_one(struct device *dev);
+void acpi_bus_hot_remove_device(void *context);
 
 /* --------------------------------------------------------------------------
                                   Power Resource
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -386,7 +386,6 @@ int acpi_scan_add_handler(struct acpi_sc
 int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_scan(acpi_handle handle);
-void acpi_bus_hot_remove_device(void *context);
 void acpi_bus_trim(struct acpi_device *start);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
 int acpi_match_device_ids(struct acpi_device *device,
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -467,7 +467,6 @@ void acpi_bus_hot_remove_device(void *co
 {
 	__acpi_bus_hot_remove_device(context, ACPI_NOTIFY_EJECT_REQUEST);
 }
-EXPORT_SYMBOL(acpi_bus_hot_remove_device);
 
 static ssize_t real_power_state_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -39,6 +39,8 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/apei.h>
 
+#include "internal.h"
+
 #define PREFIX "ACPI: "
 
 #define _COMPONENT		ACPI_PCI_COMPONENT
