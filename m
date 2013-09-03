Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab3ICIrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:47:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53448 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab3ICIrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:47:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,1012,1367942400"; 
   d="scan'208";a="8390264"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, joe@perches.com, toshi.kani@hp.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 4/4] acpi: Return -ENOENT in acpi_table_parse() and fix wrong comment.
Date: Tue, 3 Sep 2013 16:45:41 +0800
Message-Id: <1378197941-26479-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 16:44:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 16:44:53,
	Serialize complete at 2013/09/03 16:44:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment about return value of acpi_table_parse() is incorrect.
This patch fix it.

Since all callers only check if the function succeeded or not, this
patch simplifies the semantics by returning -errno for all failure
cases. This will also simply the comment.

As suggested by Toshi Kani <toshi.kani@hp.com>, also change the stub
in linux/acpi.h to return -ENODEV.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/tables.c |    7 ++++---
 include/linux/acpi.h  |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 5a5263b..e6de24f 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -278,12 +278,13 @@ acpi_table_parse_madt(enum acpi_madt_type id,
 
 /**
  * acpi_table_parse - find table with @id, run @handler on it
- *
  * @id: table id to find
  * @handler: handler to run
  *
  * Scan the ACPI System Descriptor Table (STD) for a table matching @id,
- * run @handler on it.  Return 0 if table found, return on if not.
+ * run @handler on it.
+ *
+ * Return 0 on success, -errno on failure.
  */
 int __init acpi_table_parse(char *id, acpi_tbl_table_handler handler)
 {
@@ -306,7 +307,7 @@ int __init acpi_table_parse(char *id, acpi_tbl_table_handler handler)
 		early_acpi_os_unmap_memory(table, tbl_size);
 		return 0;
 	} else
-		return 1;
+		return -ENOENT;
 }
 
 /* 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 353ba25..39fd53a 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -443,7 +443,7 @@ struct acpi_table_header;
 static inline int acpi_table_parse(char *id,
 				int (*handler)(struct acpi_table_header *))
 {
-	return -1;
+	return -ENODEV;
 }
 
 static inline int acpi_nvs_register(__u64 start, __u64 size)
-- 
1.7.1

