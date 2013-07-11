Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3GLAC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:02:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39041 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab3GKX7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 12/30] ACPI / hotplug / PCI: Drop sun field from struct acpiphp_slot
Date: Fri, 12 Jul 2013 01:51:35 +0200
Message-ID: <2141941.XUL7llpgGZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

If the slot unique number is passed as an additional argument to
acpiphp_register_hotplug_slot(), the slot field in struct
acpiphp_slot is not necessary and may be dropped, so make that
happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    4 +---
 drivers/pci/hotplug/acpiphp_core.c |    5 +++--
 drivers/pci/hotplug/acpiphp_glue.c |    7 +++----
 3 files changed, 7 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -106,8 +106,6 @@ struct acpiphp_slot {
 	struct mutex crit_sect;
 
 	u8		device;		/* pci device# */
-
-	unsigned long long sun;		/* ACPI _SUN (slot unique number) */
 	u32		flags;		/* see below */
 };
 
@@ -180,7 +178,7 @@ struct acpiphp_attention_info
 /* acpiphp_core.c */
 int acpiphp_register_attention(struct acpiphp_attention_info*info);
 int acpiphp_unregister_attention(struct acpiphp_attention_info *info);
-int acpiphp_register_hotplug_slot(struct acpiphp_slot *slot);
+int acpiphp_register_hotplug_slot(struct acpiphp_slot *slot, unsigned int sun);
 void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 
 /* acpiphp_glue.c */
Index: linux-pm/drivers/pci/hotplug/acpiphp_core.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_core.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_core.c
@@ -290,7 +290,8 @@ static void release_slot(struct hotplug_
 }
 
 /* callback routine to initialize 'struct slot' for each slot */
-int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
+int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot,
+				  unsigned int sun)
 {
 	struct slot *slot;
 	int retval = -ENOMEM;
@@ -317,7 +318,7 @@ int acpiphp_register_hotplug_slot(struct
 	slot->hotplug_slot->info->adapter_status = acpiphp_get_adapter_status(slot->acpi_slot);
 
 	acpiphp_slot->slot = slot;
-	snprintf(name, SLOT_NAME_SIZE, "%llu", slot->acpi_slot->sun);
+	snprintf(name, SLOT_NAME_SIZE, "%u", sun);
 
 	retval = pci_hp_register(slot->hotplug_slot,
 					acpiphp_slot->bridge->pci_bus,
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -354,16 +354,15 @@ static acpi_status register_slot(acpi_ha
 		if (ACPI_FAILURE(status))
 			sun = bridge->nr_slots;
 
-		slot->sun = sun;
 		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
-		    slot->sun, pci_domain_nr(pbus), pbus->number, device);
+		    sun, pci_domain_nr(pbus), pbus->number, device);
 
-		retval = acpiphp_register_hotplug_slot(slot);
+		retval = acpiphp_register_hotplug_slot(slot, sun);
 		if (retval) {
 			bridge->nr_slots--;
 			if (retval == -EBUSY)
 				warn("Slot %llu already registered by another "
-					"hotplug driver\n", slot->sun);
+					"hotplug driver\n", sun);
 			else
 				warn("acpiphp_register_hotplug_slot failed "
 					"(err code = 0x%x)\n", retval);

