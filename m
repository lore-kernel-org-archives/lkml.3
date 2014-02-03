Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaBCXgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:36:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58299 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753414AbaBCX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 16/24][New] ACPI / hotplug / PCI: Do not pass ACPI handle to hotplug_event()
Date: Tue, 04 Feb 2014 00:34:07 +0100
Message-ID: <5511377.gn3BWNPSGH@vostro.rjw.lan>
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

Since hotplug_event() can get the ACPI handle needed for debug
printouts from its context argument, there's no need to pass the
handle to it.  Moreover, the second argument's type may be changed
to (struct acpiphp_context *), because that's what is always passed
to hotplug_event() as the second argument anyway.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -63,7 +63,7 @@ static DEFINE_MUTEX(acpiphp_context_lock
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
-static void hotplug_event(acpi_handle handle, u32 type, void *data);
+static void hotplug_event(u32 type, struct acpiphp_context *context);
 static void free_bridge(struct kref *kref);
 
 static void acpiphp_context_handler(acpi_handle handle, void *context)
@@ -225,7 +225,7 @@ static void dock_event(acpi_handle handl
 	acpiphp_put_context(context);
 	mutex_unlock(&acpiphp_context_lock);
 
-	hotplug_event(handle, type, data);
+	hotplug_event(type, context);
 
 	put_bridge(context->func.parent);
 }
@@ -813,9 +813,9 @@ void acpiphp_check_host_bridge(acpi_hand
 
 static int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot);
 
-static void hotplug_event(acpi_handle handle, u32 type, void *data)
+static void hotplug_event(u32 type, struct acpiphp_context *context)
 {
-	struct acpiphp_context *context = data;
+	acpi_handle handle = context->adev->handle;
 	struct acpiphp_func *func = &context->func;
 	struct acpiphp_slot *slot = func->slot;
 	struct acpiphp_bridge *bridge;
@@ -870,14 +870,14 @@ static void hotplug_event(acpi_handle ha
 static void hotplug_event_work(void *data, u32 type)
 {
 	struct acpiphp_context *context = data;
-	acpi_handle handle = context->adev->handle;
 
 	acpi_scan_lock_acquire();
 
-	hotplug_event(handle, type, context);
+	hotplug_event(type, context);
 
 	acpi_scan_lock_release();
-	acpi_evaluate_hotplug_ost(handle, type, ACPI_OST_SC_SUCCESS, NULL);
+	acpi_evaluate_hotplug_ost(context->adev->handle, type,
+				  ACPI_OST_SC_SUCCESS, NULL);
 	put_bridge(context->func.parent);
 }
 
