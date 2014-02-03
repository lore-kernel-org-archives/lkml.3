Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaBCX2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:28:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63028 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751864AbaBCX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 24/24][New] ACPI / hotplug / PCI: Rework acpiphp_check_host_bridge()
Date: Tue, 04 Feb 2014 00:41:54 +0100
Message-ID: <7962756.Dx5cJ92CrE@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <7532948.aJNUotNMpR@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <20140203104408.GQ18029@intel.com> <7532948.aJNUotNMpR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since the only existing caller of acpiphp_check_host_bridge(),
which is acpi_pci_root_scan_dependent(), already has a struct
acpi_device pointer needed to obtain the ACPIPHP context, it
doesn't make sense to execute acpi_bus_get_device() on its
handle in acpiphp_handle_to_bridge() just in order to get that
pointer back.

For this reason, modify acpiphp_check_host_bridge() to take
a struct acpi_device pointer as its argument and rearrange the
code accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/pci_root.c            |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c |   11 +++--------
 include/linux/pci-acpi.h           |    4 ++--
 3 files changed, 6 insertions(+), 11 deletions(-)

Index: linux-pm/include/linux/pci-acpi.h
===================================================================
--- linux-pm.orig/include/linux/pci-acpi.h
+++ linux-pm/include/linux/pci-acpi.h
@@ -59,12 +59,12 @@ static inline void acpi_pci_slot_remove(
 void acpiphp_init(void);
 void acpiphp_enumerate_slots(struct pci_bus *bus);
 void acpiphp_remove_slots(struct pci_bus *bus);
-void acpiphp_check_host_bridge(acpi_handle handle);
+void acpiphp_check_host_bridge(struct acpi_device *adev);
 #else
 static inline void acpiphp_init(void) { }
 static inline void acpiphp_enumerate_slots(struct pci_bus *bus) { }
 static inline void acpiphp_remove_slots(struct pci_bus *bus) { }
-static inline void acpiphp_check_host_bridge(acpi_handle handle) { }
+static inline void acpiphp_check_host_bridge(struct acpi_device *adev) { }
 #endif
 
 #else	/* CONFIG_ACPI */
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -51,7 +51,7 @@ static void acpi_pci_root_remove(struct
 
 static int acpi_pci_root_scan_dependent(struct acpi_device *adev)
 {
-	acpiphp_check_host_bridge(adev->handle);
+	acpiphp_check_host_bridge(adev);
 	return 0;
 }
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -378,15 +378,11 @@ static acpi_status register_slot(acpi_ha
 	return AE_OK;
 }
 
-static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
+static struct acpiphp_bridge *acpiphp_dev_to_bridge(struct acpi_device *adev)
 {
-	struct acpi_device *adev = acpi_bus_get_acpi_device(handle);
 	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge = NULL;
 
-	if (!adev)
-		return NULL;
-
 	acpi_lock_hp_context();
 	context = acpiphp_get_context(adev);
 	if (context) {
@@ -397,7 +393,6 @@ static struct acpiphp_bridge *acpiphp_ha
 		acpiphp_put_context(context);
 	}
 	acpi_unlock_hp_context();
-	acpi_bus_put_acpi_device(adev);
 	return bridge;
 }
 
@@ -764,11 +759,11 @@ static void acpiphp_sanitize_bus(struct
  * ACPI event handlers
  */
 
-void acpiphp_check_host_bridge(acpi_handle handle)
+void acpiphp_check_host_bridge(struct acpi_device *adev)
 {
 	struct acpiphp_bridge *bridge;
 
-	bridge = acpiphp_handle_to_bridge(handle);
+	bridge = acpiphp_dev_to_bridge(adev);
 	if (bridge) {
 		pci_lock_rescan_remove();
 

