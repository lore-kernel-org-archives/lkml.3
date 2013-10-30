Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3J3Mkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:40:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:46468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3J3Mkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,601,1378882800"; 
   d="scan'208";a="425170662"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / hotplug / PCI: Always rescan the slot for new devices
Date: Wed, 30 Oct 2013 14:40:36 +0200
Message-Id: <1383136836-15306-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2dc4128 (ACPI / hotplug / PCI: Avoid doing too much for spurious
notifies) changed the enable_slot() to check return value of pci_scan_slot()
and if it is zero return early from the function. It means that there were
no new devices in this particular slot.

However, if a device appeared deeper in the hierarchy the code now ignores
it causing things like Thunderbolt chaining fail to recognize new devices.

The problem with Alex Williamson's machine was solved with commit
a47d8c8 (ACPI / hotplug / PCI: Avoid parent bus rescans on spurious device
checks) and hence we should be able to restore the original functionality
that we always rescan on bus check notification.

On a device check notification we still check what acpiphp_rescan_slot()
returns and on zero bail out early.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Alex,

Are you able to check if your machine still works and doesn't slow down
during boot after this patch is applied?

Thanks.

 drivers/pci/hotplug/acpiphp_glue.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index be12fbf..1ea7523 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -552,9 +552,8 @@ static void __ref enable_slot(struct acpiphp_slot *slot)
 	struct acpiphp_func *func;
 	int max, pass;
 	LIST_HEAD(add_list);
-	int nr_found;
 
-	nr_found = acpiphp_rescan_slot(slot);
+	acpiphp_rescan_slot(slot);
 	max = acpiphp_max_busnr(bus);
 	for (pass = 0; pass < 2; pass++) {
 		list_for_each_entry(dev, &bus->devices, bus_list) {
@@ -574,9 +573,6 @@ static void __ref enable_slot(struct acpiphp_slot *slot)
 		}
 	}
 	__pci_bus_assign_resources(bus, &add_list, NULL);
-	/* Nothing more to do here if there are no new devices on this bus. */
-	if (!nr_found && (slot->flags & SLOT_ENABLED))
-		return;
 
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);
-- 
1.8.4.rc3

