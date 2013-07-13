Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab3GMRG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 13:06:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:10895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3GMRG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 13:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,660,1367996400"; 
   d="scan'208";a="364779161"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] PCI / hotplug / ACPI: Get rid of check_sub_bridges()
Date: Sat, 13 Jul 2013 20:09:59 +0300
Message-Id: <1373735399-28055-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that acpiphp_check_bridge() always enumerates devices behind the
bridge, there is no need to do that for each sub-bridge anymore like it is
done in the current ACPI-based PCI hotplug code. Given this we don't need
check_sub_bridges() anymore and can drop the function completely.

This also simplifies the ACPIPHP code a bit.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
This applies on top of v3.10 with Rafael's ACPIPHP + Thunderbolt series
applied:

	http://www.spinics.net/lists/linux-acpi/msg44480.html


 drivers/pci/hotplug/acpiphp_glue.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 62e09af..741504a 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -760,25 +760,6 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
  * ACPI event handlers
  */
 
-static acpi_status
-check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	struct acpiphp_bridge *bridge;
-	char objname[64];
-	struct acpi_buffer buffer = { .length = sizeof(objname),
-				      .pointer = objname };
-
-	bridge = acpiphp_handle_to_bridge(handle);
-	if (bridge) {
-		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
-		dbg("%s: re-enumerating slots under %s\n",
-			__func__, objname);
-		acpiphp_check_bridge(bridge);
-		put_bridge(bridge);
-	}
-	return AE_OK ;
-}
-
 void acpiphp_check_host_bridge(acpi_handle handle)
 {
 	struct acpiphp_bridge *bridge;
@@ -788,9 +769,6 @@ void acpiphp_check_host_bridge(acpi_handle handle)
 		acpiphp_check_bridge(bridge);
 		put_bridge(bridge);
 	}
-
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
-		ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
 }
 
 static void hotplug_event(acpi_handle handle, u32 type, void *data)
@@ -818,9 +796,6 @@ static void hotplug_event(acpi_handle handle, u32 type, void *data)
 		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
 		if (bridge) {
 			acpiphp_check_bridge(bridge);
-			acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
-					    ACPI_UINT32_MAX, check_sub_bridges,
-					    NULL, NULL, NULL);
 		} else {
 			struct acpiphp_slot *slot = func->slot;
 
-- 
1.8.3.2

