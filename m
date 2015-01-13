Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbbAMSkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:40:49 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33885 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbbAMSkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:40:47 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPICA: rsdump: Remove some unused functions
Date: Tue, 13 Jan 2015 19:43:52 +0100
Message-Id: <1421174632-5146-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
acpi_rs_dump_irq_list() acpi_rs_dump_resource_list()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/acpi/acpica/acresrc.h |    7 ---
 drivers/acpi/acpica/rsdump.c  |  110 -----------------------------------------
 2 files changed, 117 deletions(-)

diff --git a/drivers/acpi/acpica/acresrc.h b/drivers/acpi/acpica/acresrc.h
index 4b008e8..4a4f8af 100644
--- a/drivers/acpi/acpica/acresrc.h
+++ b/drivers/acpi/acpica/acresrc.h
@@ -299,13 +299,6 @@ acpi_rs_set_resource_length(acpi_rsdesc_size total_length,
 			    union aml_resource *aml);
 
 /*
- * rsdump
- */
-void acpi_rs_dump_resource_list(struct acpi_resource *resource);
-
-void acpi_rs_dump_irq_list(u8 * route_table);
-
-/*
  * Resource conversion tables
  */
 extern struct acpi_rsconvert_info acpi_rs_convert_dma[];
diff --git a/drivers/acpi/acpica/rsdump.c b/drivers/acpi/acpica/rsdump.c
index c3c56b5..8bd41ec 100644
--- a/drivers/acpi/acpica/rsdump.c
+++ b/drivers/acpi/acpica/rsdump.c
@@ -357,116 +357,6 @@ static void acpi_rs_dump_address_common(union acpi_resource_data *resource)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_rs_dump_resource_list
- *
- * PARAMETERS:  resource_list       - Pointer to a resource descriptor list
- *
- * RETURN:      None
- *
- * DESCRIPTION: Dispatches the structure to the correct dump routine.
- *
- ******************************************************************************/
-
-void acpi_rs_dump_resource_list(struct acpi_resource *resource_list)
-{
-	u32 count = 0;
-	u32 type;
-
-	ACPI_FUNCTION_ENTRY();
-
-	/* Check if debug output enabled */
-
-	if (!ACPI_IS_DEBUG_ENABLED(ACPI_LV_RESOURCES, _COMPONENT)) {
-		return;
-	}
-
-	/* Walk list and dump all resource descriptors (END_TAG terminates) */
-
-	do {
-		acpi_os_printf("\n[%02X] ", count);
-		count++;
-
-		/* Validate Type before dispatch */
-
-		type = resource_list->type;
-		if (type > ACPI_RESOURCE_TYPE_MAX) {
-			acpi_os_printf
-			    ("Invalid descriptor type (%X) in resource list\n",
-			     resource_list->type);
-			return;
-		}
-
-		/* Sanity check the length. It must not be zero, or we loop forever */
-
-		if (!resource_list->length) {
-			acpi_os_printf
-			    ("Invalid zero length descriptor in resource list\n");
-			return;
-		}
-
-		/* Dump the resource descriptor */
-
-		if (type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
-			acpi_rs_dump_descriptor(&resource_list->data,
-						acpi_gbl_dump_serial_bus_dispatch
-						[resource_list->data.
-						 common_serial_bus.type]);
-		} else {
-			acpi_rs_dump_descriptor(&resource_list->data,
-						acpi_gbl_dump_resource_dispatch
-						[type]);
-		}
-
-		/* Point to the next resource structure */
-
-		resource_list = ACPI_NEXT_RESOURCE(resource_list);
-
-		/* Exit when END_TAG descriptor is reached */
-
-	} while (type != ACPI_RESOURCE_TYPE_END_TAG);
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_rs_dump_irq_list
- *
- * PARAMETERS:  route_table     - Pointer to the routing table to dump.
- *
- * RETURN:      None
- *
- * DESCRIPTION: Print IRQ routing table
- *
- ******************************************************************************/
-
-void acpi_rs_dump_irq_list(u8 * route_table)
-{
-	struct acpi_pci_routing_table *prt_element;
-	u8 count;
-
-	ACPI_FUNCTION_ENTRY();
-
-	/* Check if debug output enabled */
-
-	if (!ACPI_IS_DEBUG_ENABLED(ACPI_LV_RESOURCES, _COMPONENT)) {
-		return;
-	}
-
-	prt_element = ACPI_CAST_PTR(struct acpi_pci_routing_table, route_table);
-
-	/* Dump all table elements, Exit on zero length element */
-
-	for (count = 0; prt_element->length; count++) {
-		acpi_os_printf("\n[%02X] PCI IRQ Routing Table Package\n",
-			       count);
-		acpi_rs_dump_descriptor(prt_element, acpi_rs_dump_prt);
-
-		prt_element = ACPI_ADD_PTR(struct acpi_pci_routing_table,
-					   prt_element, prt_element->length);
-	}
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_rs_out*
  *
  * PARAMETERS:  title       - Name of the resource field
-- 
1.7.10.4

