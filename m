Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaD3CD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:03:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:40581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaD3CDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:03:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="532134512"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 03/27] ACPICA: acpidump: Fix code issue in invoking fread in the loop.
Date: Wed, 30 Apr 2014 10:03:45 +0800
Message-Id: <6710a20ad0f5cf0ee29ee1ef54a62c92b1dab5dc.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an issue that the while loop is not needed as fread()
should return exact the bytes of expected.

The patch is tested by runing diff against the output of "-c" mode and
the normal mode, and only finds the following differences:
1. table addresses: the "-c" mode will always fill 0x0000000000000000 for
                    the address.
2. RSDP/RSDT/XSDT: there is no generation of such tables for "-c" mode.
So the test result shows the fix is valid.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 .../acpi/os_specific/service_layers/oslinuxtbl.c      |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
index e975aa9..dc65098 100644
--- a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
+++ b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
@@ -1112,7 +1112,6 @@ osl_read_table_from_file(char *filename,
 	struct acpi_table_header *local_table = NULL;
 	u32 table_length;
 	s32 count;
-	u32 total = 0;
 	acpi_status status = AE_OK;
 
 	/* Open the file */
@@ -1163,16 +1162,12 @@ osl_read_table_from_file(char *filename,
 
 	fseek(table_file, file_offset, SEEK_SET);
 
-	while (!feof(table_file) && total < table_length) {
-		count = fread(local_table + total, 1, table_length - total, table_file);
-		if (count < 0) {
-			fprintf(stderr, "%4.4s: Could not read table content\n",
-				header.signature);
-			status = AE_INVALID_TABLE_LENGTH;
-			goto exit;
-		}
-
-		total += count;
+	count = fread(local_table, 1, table_length, table_file);
+	if (count != table_length) {
+		fprintf(stderr, "%4.4s: Could not read table content\n",
+			header.signature);
+		status = AE_INVALID_TABLE_LENGTH;
+		goto exit;
 	}
 
 	/* Validate checksum */
-- 
1.7.10

