Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaBCX2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:28:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63191 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753801AbaBCX2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 4/24][New] ACPI / hotplug / PCI: Fix bridge removal race in handle_hotplug_event()
Date: Tue, 04 Feb 2014 00:18:03 +0100
Message-ID: <1460941.uPM2Zn8FLA@vostro.rjw.lan>
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

If a PCI bridge with an ACPIPHP context attached is removed via
sysfs, the code path executed as a result is the following:

pci_stop_and_remove_bus_device_locked
 pci_remove_bus
  pcibios_remove_bus
   acpi_pci_remove_bus
    acpiphp_remove_slots
     cleanup_bridge
     put_bridge
      free_bridge
       acpiphp_put_context (for each child, under context lock)
        kfree (child context)

Now, if a hotplug notify is dispatched for one of the bridge's
children and the timing is such that handle_hotplug_event() for
that notify is executed while free_bridge() above is running,
the get_bridge(context->func.parent) in handle_hotplug_event()
will not really help, because it is too late to prevent the bridge
from going away and the child's context may be freed before
hotplug_event_work() scheduled from handle_hotplug_event()
dereferences the pointer to it passed via the data argument.
That will cause a kernel crash to happpen in hotplug_event_work().

To prevent that from happening, make handle_hotplug_event()
check the is_going_away flag of the function's parent bridge
(under acpiphp_context_lock) and bail out if it's set.  Also,
make cleanup_bridge() set the bridge's is_going_away flag under
acpiphp_context_lock so that it cannot be changed between the
check and the subsequent get_bridge(context->func.parent) in
handle_hotplug_event().

Then, in the above scenario, handle_hotplug_event() will notice
that context->func.parent->is_going_away is already set and it
will exit immediately preventing the crash from happening.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -441,7 +441,9 @@ static void cleanup_bridge(struct acpiph
 	list_del(&bridge->list);
 	mutex_unlock(&bridge_mutex);
 
+	mutex_lock(&acpiphp_context_lock);
 	bridge->is_going_away = true;
+	mutex_unlock(&acpiphp_context_lock);
 }
 
 /**
@@ -941,6 +943,7 @@ static void handle_hotplug_event(acpi_ha
 {
 	struct acpiphp_context *context;
 	u32 ost_code = ACPI_OST_SC_SUCCESS;
+	acpi_status status;
 
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
@@ -976,13 +979,20 @@ static void handle_hotplug_event(acpi_ha
 
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
-	if (context && !WARN_ON(context->handle != handle)) {
-		get_bridge(context->func.parent);
-		acpiphp_put_context(context);
-		acpi_hotplug_execute(hotplug_event_work, context, type);
+	if (!context || WARN_ON(context->handle != handle)
+	    || context->func.parent->is_going_away)
+		goto err_out;
+
+	get_bridge(context->func.parent);
+	acpiphp_put_context(context);
+	status = acpi_hotplug_execute(hotplug_event_work, context, type);
+	if (ACPI_SUCCESS(status)) {
 		mutex_unlock(&acpiphp_context_lock);
 		return;
 	}
+	put_bridge(context->func.parent);
+
+ err_out:
 	mutex_unlock(&acpiphp_context_lock);
 	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 

