Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137Ab3GQX1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:27:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47854 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934279Ab3GQX1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:27:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 13/30] ACPI / hotplug / PCI: Drop flags field from struct acpiphp_bridge
Date: Thu, 18 Jul 2013 01:24:12 +0200
Message-ID: <1619021.iXxrTV6Dob@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2366394.4EoP1MXmG2@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan> <2366394.4EoP1MXmG2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The only bridge flag used by the ACPI-based PCI hotplug (ACPIPHP)
code is BRIDGE_HAS_EJ0, but it is only used by the event handling
function hotplug_event() and if that flag is set, the corresponding
function flag FUNC_HAS_EJ0 is set as well, so that bridge flag is
redundant.

For this reason, drop BRIDGE_HAS_EJ0 and all code referring to it
and since it is the only bridge flag defined, drop the flags field
from struct acpiphp_bridge entirely.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    5 -----
 drivers/pci/hotplug/acpiphp_glue.c |    9 ---------
 2 files changed, 14 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -83,8 +83,6 @@ struct acpiphp_bridge {
 
 	int nr_slots;
 
-	u32 flags;
-
 	/* This bus (host bridge) or Secondary bus (PCI-to-PCI bridge) */
 	struct pci_bus *pci_bus;
 
@@ -154,9 +152,6 @@ struct acpiphp_attention_info
 /* ACPI _STA method value (ignore bit 4; battery present) */
 #define ACPI_STA_ALL			(0x0000000f)
 
-/* bridge flags */
-#define BRIDGE_HAS_EJ0		(0x00000001)
-
 /* slot flags */
 
 #define SLOT_POWEREDON		(0x00000001)
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -986,9 +986,6 @@ static void hotplug_event(acpi_handle ha
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		dbg("%s: Device eject notify on %s\n", __func__, objname);
-		if (bridge && !(bridge->flags & BRIDGE_HAS_EJ0))
-			break;
-
 		if (!(acpiphp_disable_slot(func->slot)))
 			acpiphp_eject_slot(func->slot);
 
@@ -1125,12 +1122,6 @@ void acpiphp_enumerate_slots(struct pci_
 		mutex_unlock(&acpiphp_context_lock);
 	}
 
-	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
-	if (ACPI_SUCCESS(status)) {
-		dbg("found ejectable p2p bridge\n");
-		bridge->flags |= BRIDGE_HAS_EJ0;
-	}
-
 	/* must be added to the list prior to calling register_slot */
 	mutex_lock(&bridge_mutex);
 	list_add(&bridge->list, &bridge_list);

