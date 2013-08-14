Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab3HNJih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:38:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759483Ab3HNJif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:38:35 -0400
X-IronPort-AV: E=Sophos;i="4.89,876,1367942400"; 
   d="scan'208";a="8200294"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        zhangyanfei@cn.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] acpi: Kill macro INVALID_TABLE().
Date: Wed, 14 Aug 2013 17:37:08 +0800
Message-Id: <1376473028-29380-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376473028-29380-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1376473028-29380-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/14 17:36:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/14 17:36:58,
	Serialize complete at 2013/08/14 17:36:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro INVALID_TABLE() is defined like this:

 #define INVALID_TABLE(x, path, name)                                    \
         { pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); continue; }

And it is used like this:

	for (...) {
		...
		if (...)
			INVALID_TABLE()
		...
	}

The "continue" in the macro makes the code hard to understand.

And also, this macro is only used several times in a single file.
As suggested by Joe Perches <joe@perches.com>, we can remote it and
use pr_err directly.

So after this patch, this macro is removed, and pr_err() is used
like this:

	for (...) {
		...
		if (...) {
			pr_err("ACPI OVERRIDE: ......");
			continue;
		}
		...
	}

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/osl.c |   36 ++++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab2c35..e7effc1 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -563,10 +563,6 @@ static const char * const table_sigs[] = {
 	ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
 	ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
 
-/* Non-fatal errors: Affected tables/files are ignored */
-#define INVALID_TABLE(x, path, name)					\
-	{ pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); continue; }
-
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
 /* Must not increase 10 or needs code modification below */
@@ -593,9 +589,11 @@ void __init acpi_initrd_override(void *data, size_t size)
 		data += offset;
 		size -= offset;
 
-		if (file.size < sizeof(struct acpi_table_header))
-			INVALID_TABLE("Table smaller than ACPI header",
-				      cpio_path, file.name);
+		if (file.size < sizeof(struct acpi_table_header)) {
+			pr_err("ACPI OVERRIDE: Table smaller than ACPI header [%s%s]\n",
+				cpio_path, file.name);
+			continue;
+		}
 
 		table = file.data;
 
@@ -603,15 +601,21 @@ void __init acpi_initrd_override(void *data, size_t size)
 			if (!memcmp(table->signature, table_sigs[sig], 4))
 				break;
 
-		if (!table_sigs[sig])
-			INVALID_TABLE("Unknown signature",
-				      cpio_path, file.name);
-		if (file.size != table->length)
-			INVALID_TABLE("File length does not match table length",
-				      cpio_path, file.name);
-		if (acpi_table_checksum(file.data, table->length))
-			INVALID_TABLE("Bad table checksum",
-				      cpio_path, file.name);
+		if (!table_sigs[sig]) {
+			pr_err("ACPI OVERRIDE: Unknown signature [%s%s]\n",
+				cpio_path, file.name);
+			continue;
+		}
+		if (file.size != table->length) {
+			pr_err("ACPI OVERRIDE: File length does not match table length [%s%s]\n",
+				cpio_path, file.name);
+			continue;
+		}
+		if (acpi_table_checksum(file.data, table->length)) {
+			pr_err("ACPI OVERRIDE: Bad table checksum [%s%s]\n",
+				cpio_path, file.name);
+			continue;
+		}
 
 		pr_info("%4.4s ACPI table found in initrd [%s%s][0x%x]\n",
 			table->signature, cpio_path, file.name, table->length);
-- 
1.7.1

