Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3F1Q2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:28:19 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61388 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3F1Q2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:28:16 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 10/10] ACPI: simplify acpiphp driver with new helper functions
Date: Sat, 29 Jun 2013 00:24:43 +0800
Message-Id: <1372436683-31711-11-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use new helper functions to simplify acpiphp driver.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/acpiphp_glue.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 59df857..a0a7133 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -201,7 +201,6 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	struct acpiphp_bridge *bridge = (struct acpiphp_bridge *)context;
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *newfunc;
-	acpi_handle tmp;
 	acpi_status status = AE_OK;
 	unsigned long long adr, sun;
 	int device, function, retval, found = 0;
@@ -232,19 +231,19 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	newfunc->handle = handle;
 	newfunc->function = function;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &tmp)))
+	if (acpi_has_method(handle, "_EJ0"))
 		newfunc->flags = FUNC_HAS_EJ0;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_STA", &tmp)))
+	if (acpi_has_method(handle, "_STA"))
 		newfunc->flags |= FUNC_HAS_STA;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS0", &tmp)))
+	if (acpi_has_method(handle, "_PS0"))
 		newfunc->flags |= FUNC_HAS_PS0;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3", &tmp)))
+	if (acpi_has_method(handle, "_PS3"))
 		newfunc->flags |= FUNC_HAS_PS3;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_DCK", &tmp)))
+	if (acpi_has_method(handle, "_DCK"))
 		newfunc->flags |= FUNC_HAS_DCK;
 
 	status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
@@ -843,25 +842,14 @@ static unsigned int get_slot_status(struct acpiphp_slot *slot)
  */
 int acpiphp_eject_slot(struct acpiphp_slot *slot)
 {
-	acpi_status status;
 	struct acpiphp_func *func;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		/* We don't want to call _EJ0 on non-existing functions. */
 		if ((func->flags & FUNC_HAS_EJ0)) {
-			/* _EJ0 method take one argument */
-			arg_list.count = 1;
-			arg_list.pointer = &arg;
-			arg.type = ACPI_TYPE_INTEGER;
-			arg.integer.value = 1;
-
-			status = acpi_evaluate_object(func->handle, "_EJ0", &arg_list, NULL);
-			if (ACPI_FAILURE(status)) {
-				warn("%s: _EJ0 failed\n", __func__);
+			if (ACPI_FAILURE(acpi_evaluate_ej0(func->handle)))
 				return -1;
-			} else
+			else
 				break;
 		}
 	}
@@ -1171,7 +1159,6 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
  */
 void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle)
 {
-	acpi_handle dummy_handle;
 	struct acpiphp_bridge *bridge;
 
 	if (acpiphp_disabled)
@@ -1200,8 +1187,7 @@ void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle)
 	get_device(&bus->dev);
 
 	if (!pci_is_root_bus(bridge->pci_bus) &&
-	    ACPI_SUCCESS(acpi_get_handle(bridge->handle,
-					"_EJ0", &dummy_handle))) {
+	    acpi_has_method(bridge->handle, "_EJ0")) {
 		dbg("found ejectable p2p bridge\n");
 		bridge->flags |= BRIDGE_HAS_EJ0;
 		bridge->func = acpiphp_bridge_handle_to_function(handle);
-- 
1.8.1.2

