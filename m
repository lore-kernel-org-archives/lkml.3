Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3GLADQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:03:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39032 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab3GKX67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 13/30] ACPI / hotplug / PCI: Use common slot count variable in register_slot()
Date: Fri, 12 Jul 2013 01:52:30 +0200
Message-ID: <1394590.kyA5M17lev@vostro.rjw.lan>
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

It is not necessary to use per-bridge slot count fields just in
order to label slots for devices without _SUN, so use a common
static slot_count variable for this purpose and drop the nr_slots
field from struct acpiphp_bridge.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    2 --
 drivers/pci/hotplug/acpiphp_glue.c |    7 ++++---
 2 files changed, 4 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -80,8 +80,6 @@ struct acpiphp_bridge {
 
 	struct acpiphp_context *context;
 
-	int nr_slots;
-
 	u32 flags;
 
 	/* This bus (host bridge) or Secondary bus (PCI-to-PCI bridge) */
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -346,20 +346,21 @@ static acpi_status register_slot(acpi_ha
 
 	/* Register slots for ejectable funtions only. */
 	if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
+		static unsigned int slot_count;
 		unsigned long long sun;
 		int retval;
 
-		bridge->nr_slots++;
+		slot_count++;
 		status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
 		if (ACPI_FAILURE(status))
-			sun = bridge->nr_slots;
+			sun = slot_count;
 
 		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
 		    sun, pci_domain_nr(pbus), pbus->number, device);
 
 		retval = acpiphp_register_hotplug_slot(slot, sun);
 		if (retval) {
-			bridge->nr_slots--;
+			slot_count--;
 			if (retval == -EBUSY)
 				warn("Slot %llu already registered by another "
 					"hotplug driver\n", sun);

