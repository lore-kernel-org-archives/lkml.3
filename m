Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBRSXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:23:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaBRSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:22:54 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        devel@acpica.org, mingo@redhat.com, ck@conrad-kostecki.de,
        tglx@linutronix.de, trenn@suse.de, rjw@rjwysocki.net
Subject: [PATCH 1/4] ACPI: Provide support for ACPI table adding via OS
Date: Tue, 18 Feb 2014 19:22:40 +0100
Message-Id: <1392747763-3384-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1392747763-3384-1-git-send-email-trenn@suse.de>
References: <530265A3.3020302@zytor.com>
 <1392747763-3384-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is done the same way as the previous ACPI physical table override
mechanism.
How to override or add tables via initrd, please look up:
Documentation/acpi/initrd_table_override.txt

SSDTs can only be overridden, not added.

Overriding only happens if the OEM id of the table header matches the one
with the BIOS provided one.
All table types (SSDTs are an exception), must only show up once.
So either you:
   - Add a fresh new table for adding of which type (signature) none exists
     in the BIOS  -> OS ACPI table adding happens.
or
   - Add a table which already exists in BIOS, but the OEM id must match the
     one of the table of the same type (signature) that exists in BIOS already
     -> OS ACPI table overriding happens
     Typically one copies away the original ACPI table, disassembles,
     modifies (for example adding debug strings), compiles it and provides
     the table via initrd for overriding (will have the same OEM id).
     But this is not necessary, one could also come up with a selfmade
     table for overriding, by taking care that the signature and OEM id is
     the same as the one provided by BIOS

In ACPI table overriding case you see in dmesg:
   ACPI: Override [DSDT-  BXDSDT], this is unsafe: tainting kernel
   Disabling lock debugging due to kernel taint

In ACPI table adding case you see in dmesg (BGRT table got added):
   ACPI: Add [BGRT-SLIC-WKS], this is unsafe: tainting kernel
   ACPI: BGRT 000000007fffd1ba 000038 (v00 HPQOEM SLIC-WKS 01072009
         INTL 20130823)

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
 drivers/acpi/osl.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 88 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index fc1aa79..07439b4 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -566,6 +566,8 @@ static const char * const table_sigs[] = {
 
 #define ACPI_OVERRIDE_TABLES 64
 static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
+/* Remember physical address of overriden or added tables */
+static acpi_physical_address acpi_table_overridden[ACPI_OVERRIDE_TABLES];
 
 #define MAP_CHUNK_SIZE   (NR_FIX_BTMAPS << PAGE_SHIFT)
 
@@ -715,7 +717,7 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 	*address = 0;
 	return AE_OK;
 #else
-	int table_offset = 0;
+	int no, table_offset = 0;
 	struct acpi_table_header *table;
 
 	*table_length = 0;
@@ -759,6 +761,12 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 		*table_length = table->length;
 		acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
 		*address = acpi_tables_addr + table_offset;
+		for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
+			if (acpi_table_overridden[no] == 0) {
+				acpi_table_overridden[no] = *address;
+				break;
+			}
+		}
 		break;
 	} while (table_offset + ACPI_HEADER_SIZE < all_tables_size);
 
@@ -768,6 +776,85 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 #endif
 }
 
+acpi_status
+acpi_os_physical_table_add(acpi_physical_address *address,
+			   u32 *table_length)
+{
+#ifndef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+	*table_length = 0;
+	*address = 0;
+	return AE_OK;
+#else
+	int no, table_offset = 0;
+	struct acpi_table_header *table;
+
+	*table_length = 0;
+	*address = 0;
+
+	if (!acpi_tables_addr)
+		return AE_OK;
+
+	do {
+		if (table_offset + ACPI_HEADER_SIZE > all_tables_size) {
+			WARN_ON(1);
+			return AE_OK;
+		}
+
+		table = acpi_os_map_memory(acpi_tables_addr + table_offset,
+					   ACPI_HEADER_SIZE);
+
+		if (table_offset + table->length > all_tables_size) {
+			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+			WARN_ON(1);
+			return AE_OK;
+		}
+
+		table_offset += table->length;
+
+		/* Do not add SSDTs for now, they might be intended to get
+		   overridden when an SSDT gets loaded dynamically in ACPI
+		   context at any time later */
+		if (!memcmp("SSDT", table->signature, 4)) {
+			acpi_os_unmap_memory(table,
+				     ACPI_HEADER_SIZE);
+			continue;
+		}
+
+		/* Only add tables that have not been overridden already */
+		for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
+			if (acpi_table_overridden[no] == 0)
+				break;
+			if (acpi_table_overridden[no] ==
+			    acpi_tables_addr + table_offset - table->length)
+				break;
+		}
+		/* All tables have been added or overridden */
+		if (acpi_table_overridden[no] != 0) {
+			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+			continue;
+		}
+		/* Max table override/add limit reached */
+		if (no == ACPI_OVERRIDE_TABLES) {
+			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+			return AE_ERROR;
+		}
+
+		table_offset -= table->length;
+		*table_length = table->length;
+		*address = acpi_tables_addr + table_offset;
+		/* do not add this table again */
+		acpi_table_overridden[no] = *address;
+		pr_warn(PREFIX
+			"Add [%4.4s-%8.8s], this is unsafe: tainting kernel\n",
+			table->signature, table->oem_table_id);
+		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, LOCKDEP_NOW_UNRELIABLE);
+		acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+		return AE_OK;
+	} while (table_offset + ACPI_HEADER_SIZE < all_tables_size);
+	return AE_OK;
+#endif
+}
+
 static irqreturn_t acpi_irq(int irq, void *dev_id)
 {
 	u32 handled;
-- 
1.7.6.1

