Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab3GLAGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:06:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38994 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab3GKX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 25/30] ACPI / hotplug / PCI: Allow slots without new devices to be rescanned
Date: Fri, 12 Jul 2013 02:03:14 +0200
Message-ID: <4646223.5BGkX74cI8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Currently, enable_device() checks the return value of pci_scan_slot()
and returns immediately if that's 0 (meaning that no new functions
have been found in the slot).  However, if one of the functions in
the slot is a bridge, some new devices may appear below it even if
the bridge itself is present continuously, so it generally is
necessary to do the rescan anyway just in case.  [In particular,
that's necessary with the Thunderbolt daisy chaining in which case
new devices may be connected to the existing ones down the chain.]

The correctness of this change relies on the ability of
pcibios_resource_survey_bus() to detect if it has already been called
for the given bus and to skip it if so.  Failure to do that will lead
to resource allocation conflicts.

[rjw: Changelog]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
drivers/pci/hotplug/acpiphp_glue.c | 11 ++---------
 drivers/pci/hotplug/acpiphp_glue.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -554,18 +554,13 @@ static int __ref enable_device(struct ac
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bus;
 	struct acpiphp_func *func;
-	int num, max, pass;
+	int max, pass;
 	LIST_HEAD(add_list);
 
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_add(func_to_handle(func));
 
-	num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
-	if (num == 0) {
-		/* Maybe only part of funcs are added. */
-		dbg("No new device found\n");
-		goto err_exit;
-	}
+	pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
 
 	max = acpiphp_max_busnr(bus);
 	for (pass = 0; pass < 2; pass++) {
@@ -611,8 +606,6 @@ static int __ref enable_device(struct ac
 		}
 	}
 
-
- err_exit:
 	return 0;
 }
 

