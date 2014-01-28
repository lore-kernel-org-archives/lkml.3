Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaA1XvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:51:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54276 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755958AbaA1Xu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:50:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [Resend][PATCH 2/5][RFT] ACPI / hotplug: Introduce acpi_install_hotplug_notify_handler()
Date: Wed, 29 Jan 2014 00:59:04 +0100
Message-ID: <4728352.8ucNUQddoh@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1693151.2qrLZHyp0o@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1508034.JFmpIOzjVZ@vostro.rjw.lan> <1693151.2qrLZHyp0o@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Introduce a helper routine for installing acpi_hotplug_notify_cb()
as an ACPI notify handler for the given ACPI namespace node and make
acpi_scan_init_hotplug() use it.

This is to make subsequent changes easier to follow.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c     |   15 +++++++++++++--
 include/acpi/acpi_bus.h |    2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -523,6 +523,18 @@ static void acpi_hotplug_notify_cb(acpi_
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
+void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data)
+{
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				    acpi_hotplug_notify_cb, data);
+}
+
+void acpi_remove_hotplug_notify_handler(acpi_handle handle)
+{
+	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				   acpi_hotplug_notify_cb);
+}
+
 static ssize_t real_power_state_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
@@ -1961,8 +1973,7 @@ static void acpi_scan_init_hotplug(acpi_
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
 		if (handler) {
-			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					acpi_hotplug_notify_cb, handler);
+			acpi_install_hotplug_notify_handler(handle, handler);
 			break;
 		}
 	}
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -434,6 +434,8 @@ static inline bool acpi_device_enumerate
 typedef void (*acpi_hp_callback)(void *data, u32 src);
 
 acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
+void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data);
+void acpi_remove_hotplug_notify_handler(acpi_handle handle);
 
 /**
  * module_acpi_driver(acpi_driver) - Helper macro for registering an ACPI driver

