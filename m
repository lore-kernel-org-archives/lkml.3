Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3GQX13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:27:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47803 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab3GQX1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:27:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 30/30] ACPI / hotplug / PCI: Get rid of check_sub_bridges()
Date: Thu, 18 Jul 2013 01:36:56 +0200
Message-ID: <2212556.JheKCNdYg0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2366394.4EoP1MXmG2@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan> <2366394.4EoP1MXmG2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Now that acpiphp_check_bridge() always enumerates devices behind the
bridge, there is no need to do that for each sub-bridge anymore like
it is done in the current ACPI-based PCI hotplug (ACPIPHP) code.

Given this we don't need check_sub_bridges() anymore, so drop that
function completely.

This also simplifies the ACPIPHP code a bit.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   25 -------------------------
 1 file changed, 25 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -788,25 +788,6 @@ static void acpiphp_sanitize_bus(struct
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
@@ -816,9 +797,6 @@ void acpiphp_check_host_bridge(acpi_hand
 		acpiphp_check_bridge(bridge);
 		put_bridge(bridge);
 	}
-
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
-		ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
 }
 
 static void hotplug_event(acpi_handle handle, u32 type, void *data)
@@ -846,9 +824,6 @@ static void hotplug_event(acpi_handle ha
 		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
 		if (bridge) {
 			acpiphp_check_bridge(bridge);
-			acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
-					    ACPI_UINT32_MAX, check_sub_bridges,
-					    NULL, NULL, NULL);
 		} else {
 			struct acpiphp_slot *slot = func->slot;
 

