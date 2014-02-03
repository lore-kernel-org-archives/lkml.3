Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaBCXet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:34:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60499 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753533AbaBCX2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 14/24][Update] ACPI / hotplug / PCI: Simplify hotplug_event()
Date: Tue, 04 Feb 2014 00:33:46 +0100
Message-ID: <2410580.0hC0rE6lqd@vostro.rjw.lan>
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

A few lines of code can be cut from hotplug_event() by defining
and initializing the slot variable at the top of the function,
so do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -817,6 +817,7 @@ static void hotplug_event(acpi_handle ha
 {
 	struct acpiphp_context *context = data;
 	struct acpiphp_func *func = &context->func;
+	struct acpiphp_slot *slot = func->slot;
 	struct acpiphp_bridge *bridge;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
@@ -838,14 +839,11 @@ static void hotplug_event(acpi_handle ha
 		pr_debug("%s: Bus check notify on %s\n", __func__, objname);
 		pr_debug("%s: re-enumerating slots under %s\n",
 			 __func__, objname);
-		if (bridge) {
+		if (bridge)
 			acpiphp_check_bridge(bridge);
-		} else {
-			struct acpiphp_slot *slot = func->slot;
+		else if (!(slot->flags & SLOT_IS_GOING_AWAY))
+			enable_slot(slot);
 
-			if (!(slot->flags & SLOT_IS_GOING_AWAY))
-				enable_slot(slot);
-		}
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
@@ -853,12 +851,7 @@ static void hotplug_event(acpi_handle ha
 		pr_debug("%s: Device check notify on %s\n", __func__, objname);
 		if (bridge) {
 			acpiphp_check_bridge(bridge);
-		} else {
-			struct acpiphp_slot *slot = func->slot;
-
-			if (slot->flags & SLOT_IS_GOING_AWAY)
-				break;
-
+		} else if (!(slot->flags & SLOT_IS_GOING_AWAY)) {
 			/*
 			 * Check if anything has changed in the slot and rescan
 			 * from the parent if that's the case.
@@ -871,7 +864,7 @@ static void hotplug_event(acpi_handle ha
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		pr_debug("%s: Device eject notify on %s\n", __func__, objname);
-		acpiphp_disable_and_eject_slot(func->slot);
+		acpiphp_disable_and_eject_slot(slot);
 		break;
 	}
 
