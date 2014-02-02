Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaBBASa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:18:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52975 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754922AbaBBAS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:18:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 2/13] ACPI / hotplug / PCI: Move PCI rescan-remove locking to hotplug_event()
Date: Sun, 02 Feb 2014 01:22:06 +0100
Message-ID: <3266705.b26GDtjItd@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1935791.liE9ZlzmO9@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1935791.liE9ZlzmO9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 9217a984671e (ACPI / hotplug / PCI: Use global PCI rescan-remove
locking) modified ACPIPHP to protect its PCI device removal and addition
code paths from races against sysfs-driven rescan and remove operations
with the help of PCI rescan-remove locking.  However, it overlooked the
fact that hotplug_event_work() is not the only caller of hotplug_event()
which may also be called by dock_hotplug_event() and that code path
is missing the PCI rescan-remove locking.  This means that, although
the PCI rescan-remove lock is held as appropriate during the handling
of events originating from handle_hotplug_event(), the ACPIPHP's
operations resulting from dock events may still suffer the race
conditions that commit 9217a984671e was supposed to eliminate.

To address that problem, move the PCI rescan-remove locking from
hotplug_event_work() to hotplug_event() so that it is used regardless
of the way that function is invoked.

Revamps: 9217a984671e (ACPI / hotplug / PCI: Use global PCI rescan-remove locking)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -852,6 +852,7 @@ static void hotplug_event(acpi_handle ha
 
 	mutex_unlock(&acpiphp_context_lock);
 
+	pci_lock_rescan_remove();
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
 	switch (type) {
@@ -905,6 +906,7 @@ static void hotplug_event(acpi_handle ha
 		break;
 	}
 
+	pci_unlock_rescan_remove();
 	if (bridge)
 		put_bridge(bridge);
 }
@@ -915,11 +917,9 @@ static void hotplug_event_work(void *dat
 	acpi_handle handle = context->handle;
 
 	acpi_scan_lock_acquire();
-	pci_lock_rescan_remove();
 
 	hotplug_event(handle, type, context);
 
-	pci_unlock_rescan_remove();
 	acpi_scan_lock_release();
 	acpi_evaluate_hotplug_ost(handle, type, ACPI_OST_SC_SUCCESS, NULL);
 	put_bridge(context->func.parent);

