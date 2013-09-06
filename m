Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3IFNgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:36:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36751 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3IFNgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:36:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 1/2] ACPI / hotplug / PCI: Avoid doing too much for spurious notifies
Date: Fri, 06 Sep 2013 15:43:52 +0200
Message-ID: <1831138.AvDtjG8RWn@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2228690.GcUDD3xFfP@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <1599165.8kjc3DtEzc@vostro.rjw.lan> <2228690.GcUDD3xFfP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Sometimes we may get a spurious device check or bus check notify for
a hotplug device and in those cases we should avoid doing all of the
configuration work needed when something actually changes.  To that
end, check the return value of pci_scan_slot() in enable_slot() and
bail out early if it is 0.

This turns out to help reduce the amount of diagnostic output from
the ACPIPHP subsystem and speed up boot on at least one system that
generates multiple device check notifies for PCIe ports during
boot.

Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -542,12 +542,12 @@ static void __ref enable_slot(struct acp
 	struct acpiphp_func *func;
 	int max, pass;
 	LIST_HEAD(add_list);
+	int nr_found;
 
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_add(func_to_handle(func));
 
-	pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
-
+	nr_found = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
 	max = acpiphp_max_busnr(bus);
 	for (pass = 0; pass < 2; pass++) {
 		list_for_each_entry(dev, &bus->devices, bus_list) {
@@ -566,8 +566,11 @@ static void __ref enable_slot(struct acp
 			}
 		}
 	}
-
 	__pci_bus_assign_resources(bus, &add_list, NULL);
+	/* Nothing more to do here if there are no new devices on this bus. */
+	if (!nr_found && (slot->flags & SLOT_ENABLED))
+		return;
+
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);
 	acpiphp_set_acpi_region(slot);

