Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaBRSXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:23:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaBRSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:22:54 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        devel@acpica.org, mingo@redhat.com, ck@conrad-kostecki.de,
        tglx@linutronix.de, trenn@suse.de, rjw@rjwysocki.net
Subject: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add OS callback
Date: Tue, 18 Feb 2014 19:22:41 +0100
Message-Id: <1392747763-3384-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1392747763-3384-1-git-send-email-trenn@suse.de>
References: <530265A3.3020302@zytor.com>
 <1392747763-3384-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
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
 drivers/acpi/acpica/tbutils.c |   24 ++++++++++++++++++++++++
 include/acpi/acpiosxf.h       |    6 ++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 6412d3c..c763816 100644
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
@@ -623,5 +625,27 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 		}
 	}
 
+	/*
+	 * ACPI Table Add:
+	 * Allow the OS to add additional tables to the global root table list
+	 */
+	for (i = 0; i < ACPI_MAX_TABLE_ADD; i++) {
+		int tmp;
+		table_entry_size = 0;
+		address = 0;
+		status = acpi_os_physical_table_add(&address,
+						    &table_entry_size);
+		if (status == AE_OK && table_entry_size && address) {
+			table = acpi_os_map_memory(address, table_entry_size);
+			ACPI_INFO((AE_INFO, "Add OS provided table:"));
+			acpi_tb_print_table_header(address, table);
+			status = acpi_tb_store_table(address,
+						     table,
+						     table_entry_size,
+						     ACPI_TABLE_ORIGIN_MAPPED,
+						     &tmp);
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

