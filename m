Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaD3CIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:08:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:38896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbaD3CF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="531005395"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 17/27] ACPICA: acpidump: Fix truncated RSDP signature validation.
Date: Wed, 30 Apr 2014 10:05:21 +0800
Message-Id: <3ae7f67390b577e89c54825c22554399e23fd959.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enforces a rule to always use ACPI_VALIDATE_RSDP_SIG for RSDP
signatures passed from table header or ACPI_SIG_RSDP so that truncated
string comparison can be avoided.  This could help to fix the issue that
"RSD " matches but "RSD PTR " doesn't match.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 .../acpi/os_specific/service_layers/oslinuxtbl.c   |   41 +++++++++++++++-----
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
index dc65098..a8cd344 100644
--- a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
+++ b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
@@ -996,10 +996,21 @@ osl_map_table(acpi_size address,
 
 	/* If specified, signature must match */
 
-	if (signature && !ACPI_COMPARE_NAME(signature, mapped_table->signature)) {
-		acpi_os_unmap_memory(mapped_table,
-				     sizeof(struct acpi_table_header));
-		return (AE_BAD_SIGNATURE);
+	if (signature) {
+		if (ACPI_VALIDATE_RSDP_SIG(signature)) {
+			if (!ACPI_VALIDATE_RSDP_SIG(mapped_table->signature)) {
+				acpi_os_unmap_memory(mapped_table,
+						     sizeof(struct
+							    acpi_table_header));
+				return (AE_BAD_SIGNATURE);
+			}
+		} else
+		    if (!ACPI_COMPARE_NAME(signature, mapped_table->signature))
+		{
+			acpi_os_unmap_memory(mapped_table,
+					     sizeof(struct acpi_table_header));
+			return (AE_BAD_SIGNATURE);
+		}
 	}
 
 	/* Map the entire table */
@@ -1135,12 +1146,22 @@ osl_read_table_from_file(char *filename,
 
 	/* If signature is specified, it must match the table */
 
-	if (signature && !ACPI_COMPARE_NAME(signature, header.signature)) {
-		fprintf(stderr,
-			"Incorrect signature: Expecting %4.4s, found %4.4s\n",
-			signature, header.signature);
-		status = AE_BAD_SIGNATURE;
-		goto exit;
+	if (signature) {
+		if (ACPI_VALIDATE_RSDP_SIG(signature)) {
+			if (!ACPI_VALIDATE_RSDP_SIG(header.signature)) {
+				fprintf(stderr,
+					"Incorrect RSDP signature: found %8.8s\n",
+					header.signature);
+				status = AE_BAD_SIGNATURE;
+				goto exit;
+			}
+		} else if (!ACPI_COMPARE_NAME(signature, header.signature)) {
+			fprintf(stderr,
+				"Incorrect signature: Expecting %4.4s, found %4.4s\n",
+				signature, header.signature);
+			status = AE_BAD_SIGNATURE;
+			goto exit;
+		}
 	}
 
 	table_length = ap_get_table_length(&header);
-- 
1.7.10

