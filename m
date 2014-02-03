Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaBCXaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:30:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64953 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753773AbaBCX2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 5/24][New] ACPI / hotplug / PCI: Fix bridge removal race vs dock events
Date: Tue, 04 Feb 2014 00:18:57 +0100
Message-ID: <1844787.IDye8ayOzv@vostro.rjw.lan>
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
      unregister_hotplug_dock_device (drops dock references to the bridge)
     put_bridge
      free_bridge
       acpiphp_put_context (for each child, under context lock)
        kfree (context)

Now, if a dock event affecting one of the bridge's child devices
occurs (roughly at the same time), it will lead to the following code
path:

acpi_dock_deferred_cb
 dock_notify
  handle_eject_request
   hot_remove_dock_devices
    dock_hotplug_event
     hotplug_event (dereferences context)

That may lead to a kernel crash in hotplug_event() if it is executed
after the last kfree() in the bridge removal code path.

To prevent that from happening, add a wrapper around hotplug_event()
called dock_event() and point the .handler pointer in acpiphp_dock_ops
to it.  Make that wrapper retrieve the device's ACPIPHP context using
acpiphp_get_context() (instead of taking it from the data argument)
under acpiphp_context_lock and check if the parent bridge's
is_going_away flag is set.  If that flag is set, it will return
immediately and if it is not set it will grab a reference to the
device's parent bridge before executing hotplug_event().

Then, in the above scenario, the reference to the parent bridge
held by dock_event() will prevent free_bridge() from being executed
for it until hotplug_event() returns.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -210,10 +210,29 @@ static void post_dock_fixups(acpi_handle
 	}
 }
 
+static void dock_event(acpi_handle handle, u32 type, void *data)
+{
+	struct acpiphp_context *context;
+
+	mutex_lock(&acpiphp_context_lock);
+	context = acpiphp_get_context(handle);
+	if (!context || WARN_ON(context->handle != handle)
+	    || context->func.parent->is_going_away) {
+		mutex_unlock(&acpiphp_context_lock);
+		return;
+	}
+	get_bridge(context->func.parent);
+	acpiphp_put_context(context);
+	mutex_unlock(&acpiphp_context_lock);
+
+	hotplug_event(handle, type, data);
+
+	put_bridge(context->func.parent);
+}
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
 	.fixup = post_dock_fixups,
-	.handler = hotplug_event,
+	.handler = dock_event,
 };
 
 /* Check whether the PCI device is managed by native PCIe hotplug driver */

