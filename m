Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3KUKU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:20:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:29219 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3KUKU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:20:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,743,1378882800"; 
   d="scan'208";a="412313135"
Date: Thu, 21 Nov 2013 11:20:27 +0100
Message-Id: <87bo1e839w.fsf@tldlab276.tl.intel.com>
From: Jeremy Compostella <jeremy.compostella@intel.com>
Subject: [PATCH] acpi: Incorrect ACPI tables walk in acpi_tables_sysfs_init
TO: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "Jeremy Compostella" <jeremy.compostella@gmail.com>,
        "Gross, Mark" <mark.gross@intel.com>, rjw@rjwysocki.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 21 Nov 2013 11:20:23 +0100
Message-ID: <87d2lu83a0.fsf@tldlab276.tl.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
--text follows this line--
Hi,

When executing on a ACPI Hardware reduced hardware, all the ACPI tables are not
exposed in sysfs due to the fact that FACS is silently ignored by the kernel in
ACPI hardware reduced and, moreover, the acpi_tables_sysfs_init ACPI table walk
is buggy and stop too soon.

The acpi_tables_sysfs_init function should to rely on the appropriate
acpi_status return values to decide or not to stop the iteration.  This way,
when running on a ACPI Reduced Harware environment where the FACS table is
silently ignored by the kernel or some ACPI table are not correctly memory
mapped or have a bad checksum it would not stop the iteration.

Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>

---
 drivers/acpi/sysfs.c |   52 ++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index fcae5fa..72a3250 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -354,8 +354,9 @@ static int acpi_tables_sysfs_init(void)
 {
 	struct acpi_table_attr *table_attr;
 	struct acpi_table_header *table_header = NULL;
-	int table_index = 0;
-	int result;
+	int table_index;
+	acpi_status status;
+	int ret;
 
 	tables_kobj = kobject_create_and_add("tables", acpi_kobj);
 	if (!tables_kobj)
@@ -365,33 +366,34 @@ static int acpi_tables_sysfs_init(void)
 	if (!dynamic_tables_kobj)
 		goto err_dynamic_tables;
 
-	do {
-		result = acpi_get_table_by_index(table_index, &table_header);
-		if (!result) {
-			table_index++;
-			table_attr = NULL;
-			table_attr =
-			    kzalloc(sizeof(struct acpi_table_attr), GFP_KERNEL);
-			if (!table_attr)
-				return -ENOMEM;
-
-			acpi_table_attr_init(table_attr, table_header);
-			result =
-			    sysfs_create_bin_file(tables_kobj,
-						  &table_attr->attr);
-			if (result) {
-				kfree(table_attr);
-				return result;
-			} else
-				list_add_tail(&table_attr->node,
-					      &acpi_table_attr_list);
+	for (table_index = 0;; table_index++) {
+		status = acpi_get_table_by_index(table_index, &table_header);
+
+		if (status == AE_BAD_PARAMETER)
+			break;
+
+		if (ACPI_FAILURE(status))
+			continue;
+
+		table_attr = NULL;
+		table_attr = kzalloc(sizeof(*table_attr), GFP_KERNEL);
+		if (!table_attr)
+			return -ENOMEM;
+
+		acpi_table_attr_init(table_attr, table_header);
+		ret = sysfs_create_bin_file(tables_kobj, &table_attr->attr);
+		if (ret) {
+			kfree(table_attr);
+			return ret;
 		}
-	} while (!result);
+		list_add_tail(&table_attr->node, &acpi_table_attr_list);
+	}
+
 	kobject_uevent(tables_kobj, KOBJ_ADD);
 	kobject_uevent(dynamic_tables_kobj, KOBJ_ADD);
-	result = acpi_install_table_handler(acpi_sysfs_table_handler, NULL);
+	status = acpi_install_table_handler(acpi_sysfs_table_handler, NULL);
 
-	return result == AE_OK ? 0 : -EINVAL;
+	return ACPI_FAILURE(status) ? -EINVAL : 0;
 err_dynamic_tables:
 	kobject_put(tables_kobj);
 err:
-- 
1.7.10.4

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

