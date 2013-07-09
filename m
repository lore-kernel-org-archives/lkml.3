Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3GIAPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:15:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35121 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab3GIANS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:13:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 6/8] ACPI / hotplug / PCI: Drop acpiphp_handle_to_bridge()
Date: Tue, 09 Jul 2013 02:20:31 +0200
Message-ID: <3804403.VVlzfJfUyu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <26431283.HJCKsss0rt@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Using the hotplug context objects introduced previously rework the
ACPI-based PCI hotplug (acpiphp) core code to get to acpiphp_bridge
objects associated with hotplug bridges from those context objects
rather than from the global list of hotplug bridges.

After that the acpiphp_handle_to_bridge() is not necessary any more,
so drop it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   54 +++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -441,22 +441,6 @@ static int detect_ejectable_slots(acpi_h
 	return found;
 }
 
-static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
-{
-	struct acpiphp_bridge *bridge;
-
-	mutex_lock(&bridge_mutex);
-	list_for_each_entry(bridge, &bridge_list, list)
-		if (bridge->handle == handle) {
-			get_bridge(bridge);
-			mutex_unlock(&bridge_mutex);
-			return bridge;
-		}
-	mutex_unlock(&bridge_mutex);
-
-	return NULL;
-}
-
 static void cleanup_bridge(struct acpiphp_bridge *bridge)
 {
 	struct acpiphp_slot *slot;
@@ -953,37 +937,49 @@ static void acpiphp_sanitize_bus(struct
  * ACPI event handlers
  */
 
-static acpi_status
-check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
+static acpi_status check_sub_bridges(acpi_handle handle, u32 lvl, void *data,
+				     void **rv)
 {
-	struct acpiphp_bridge *bridge;
-	char objname[64];
-	struct acpi_buffer buffer = { .length = sizeof(objname),
-				      .pointer = objname };
+	struct acpiphp_context *context = acpiphp_get_context(handle);
+
+	if (!context)
+		return AE_OK;
 
-	bridge = acpiphp_handle_to_bridge(handle);
-	if (bridge) {
+	if (context->bridge) {
+		struct acpiphp_bridge *bridge = context->bridge;
+		char objname[64];
+		struct acpi_buffer buffer = { .length = sizeof(objname),
+					      .pointer = objname };
+
+		get_bridge(bridge);
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
-		dbg("%s: re-enumerating slots under %s\n",
-			__func__, objname);
+		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
 		acpiphp_check_bridge(bridge);
 		put_bridge(bridge);
 	}
+	acpiphp_put_context(context);
 	return AE_OK ;
 }
 
 void acpiphp_check_host_bridge(acpi_handle handle)
 {
-	struct acpiphp_bridge *bridge;
+	struct acpiphp_context *context = acpiphp_get_context(handle);
 
-	bridge = acpiphp_handle_to_bridge(handle);
-	if (bridge) {
+	if (!context)
+		return;
+
+	if (context->bridge) {
+		struct acpiphp_bridge *bridge = context->bridge;
+
+		get_bridge(bridge);
 		acpiphp_check_bridge(bridge);
 		put_bridge(bridge);
 	}
 
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
 		ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
+
+	acpiphp_put_context(context);
 }
 
 static void _handle_hotplug_event_bridge(struct work_struct *work)

