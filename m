Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaB1RYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:24:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaB1RYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:24:07 -0500
From: Thomas Renninger <trenn@suse.de>
To: robert.moore@intel.com, lv.zheng@intel.com, david.e.box@intel.com,
        rafael.j.wysocki@intel.com
Cc: Thomas Renninger <trenn@suse.de>, hpa@zytor.com, tglx@linutronix.de,
        ck@conrad-kostecki.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        mingo@redhat.com, rjw@rjwysocki.net, devel@acpica.org
Subject: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add OS callback
Date: Fri, 28 Feb 2014 18:23:59 +0100
Message-Id: <1393608241-31037-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1393608241-31037-1-git-send-email-trenn@suse.de>
References: <1393608241-31037-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one allows OS to add arbitrary ACPI tables.

ToDo: It should get checked whether a table with the same signature already
exists and if this is the case, adding should not happen.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: hpa@zytor.com
CC: tglx@linutronix.de
CC: ck@conrad-kostecki.de
CC: linux-kernel@vger.kernel.org
CC: x86@kernel.org
CC: mingo@redhat.com
CC: rjw@rjwysocki.net
CC: devel@acpica.org
---
 drivers/acpi/acpica/tbutils.c |   36 ++++++++++++++++++++++++++++++++++++
 include/acpi/acpiosxf.h       |    6 ++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 6412d3c..a819d198 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -453,6 +453,8 @@ static acpi_status acpi_tb_validate_xsdt(acpi_physical_address xsdt_address)
  *
  ******************************************************************************/
 
+#define ACPI_MAX_TABLE_ADD 64
+
 acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 {
 	struct acpi_table_rsdp *rsdp;
@@ -623,5 +625,39 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 		}
 	}
 
+	/*
+	 * ACPI Table Add:
+	 * Allow the OS to add additional tables to the global root table list
+	 */
+	for (i = 0; i < ACPI_MAX_TABLE_ADD; i++) {
+		int tmp, k;
+		table_entry_size = 0;
+		address = 0;
+		status = acpi_os_physical_table_add(&address,
+						    &table_entry_size);
+		if (status == AE_OK && table_entry_size && address) {
+			table = acpi_os_map_memory(address, table_entry_size);
+			for (k = 2; k < acpi_gbl_root_table_list.current_table_count; k++) {
+				/*
+				  Always add SSDTs. Only allow adding of other
+				  tables if none of such a signature already
+				  exists. Use the override interface instead
+				  in such a case.
+				*/
+				if (ACPI_COMPARE_NAME("SSDT", table->signature) &&
+				    !ACPI_COMPARE_NAME(&acpi_gbl_root_table_list.tables[i].signature, table->signature)) {
+	ACPI_INFO((AE_INFO, "OS table not added, signature already exists:"));
+	acpi_tb_print_table_header(address, table);
+	acpi_os_unmap_memory(table, table_entry_size);
+				} else {
+	ACPI_INFO((AE_INFO, "Add OS provided table:"));
+	acpi_tb_print_table_header(address, table);
+	status = acpi_tb_store_table(address, table, table_entry_size,
+				     ACPI_TABLE_ORIGIN_MAPPED, &tmp);
+				}
+			}
+		} else
+			break;
+	}
 	return_ACPI_STATUS(AE_OK);
 }
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 01e6c6d..70c00ed 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -111,6 +111,12 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 				u32 *new_table_length);
 #endif
 
+#ifndef ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_physical_table_add
+acpi_status
+acpi_os_physical_table_add(acpi_physical_address * new_address,
+			   u32 *new_table_length);
+#endif
+
 /*
  * Spinlock primitives
  */
-- 
1.7.6.1

