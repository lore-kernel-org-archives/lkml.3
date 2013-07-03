Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab3GCOCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:02:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:16372 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589Ab3GCOCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="263621137"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 3/8] PCI: acpiphp: enable_device(): rescan even if no new devices on slot
Date: Wed,  3 Jul 2013 17:04:50 +0300
Message-Id: <1372860295-8306-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

pci_scan_slot() returns number of new devices connected *directly*
connected to the slot. Current enable_device() checks the return value
and stops if it doesn't see a new device.

In Thunderbolt chaining case the new device can be deeper in hierarchy, so
do the rescan anyway.

Because of that we must make sure that pcibios_resource_survey_bus() and
check_hotplug_bridge() get called only for a just found bus and not the
ones already added to the system. Failure to do so will lead to resource
conflicts.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index b983e29..0f4da3b 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -685,18 +685,13 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
 	struct acpiphp_func *func;
-	int num, max, pass;
+	int max, pass;
 	LIST_HEAD(add_list);
 
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_add(func);
 
-	num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
-	if (num == 0) {
-		/* Maybe only part of funcs are added. */
-		dbg("No new device found\n");
-		goto err_exit;
-	}
+	pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
 
 	max = acpiphp_max_busnr(bus);
 	for (pass = 0; pass < 2; pass++) {
@@ -742,8 +737,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 		}
 	}
 
-
- err_exit:
 	return 0;
 }
 
-- 
1.8.3.2

