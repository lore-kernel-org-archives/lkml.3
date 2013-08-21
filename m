Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3HUKUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:20:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19009 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab3HUKUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:20:15 -0400
X-IronPort-AV: E=Sophos;i="4.89,927,1367942400"; 
   d="scan'208";a="8261332"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: konrad.wilk@oracle.com, robert.moore@intel.com, lv.zheng@intel.com,
        rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 7/8] x86, acpi, brk: Make early_alloc_acpi_override_tables_buf() available with va/pa.
Date: Wed, 21 Aug 2013 18:15:42 +0800
Message-Id: <1377080143-28455-8-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 18:15:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 18:15:18,
	Serialize complete at 2013/08/21 18:15:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using the same trick in previous patch.

Introduce a "bool is_phys" to early_alloc_acpi_override_tables_buf(). When it
is true, convert all golbal variables va to pa, so that we can access them on
32bit before paging is enabled.

NOTE: Do not call printk() on 32bit before paging is enabled
      because it will use global variables.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    2 +-
 drivers/acpi/osl.c      |   11 ++++++++---
 include/linux/acpi.h    |    2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1290ea7..5729cd2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1071,7 +1071,7 @@ void __init setup_arch(char **cmdline_p)
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_BLK_DEV_INITRD)
 	/* Allocate buffer to store acpi override tables in brk. */
-	early_alloc_acpi_override_tables_buf();
+	early_alloc_acpi_override_tables_buf(false);
 #endif
 
 	/*
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index ccdb5a6..25ba68d 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -560,10 +560,15 @@ u8 __init acpi_table_checksum(u8 *buffer, u32 length)
 /* Reserve 256KB in BRK to store acpi override tables */
 #define ACPI_OVERRIDE_TABLES_SIZE (256 * 1024)
 RESERVE_BRK(acpi_override_tables_alloc, ACPI_OVERRIDE_TABLES_SIZE);
-void __init early_alloc_acpi_override_tables_buf(void)
+void __init early_alloc_acpi_override_tables_buf(bool is_phys)
 {
-	acpi_tables_addr = __pa(extend_brk(ACPI_OVERRIDE_TABLES_SIZE,
-					   PAGE_SIZE, false));
+	u64 *acpi_tables_addr_p;
+
+	acpi_tables_addr_p = is_phys ? (u64 *)__pa_nodebug(&acpi_tables_addr) :
+				       (u64 *)&acpi_tables_addr;
+
+	*acpi_tables_addr_p = __pa_nodebug(extend_brk(ACPI_OVERRIDE_TABLES_SIZE,
+					      PAGE_SIZE, is_phys));
 }
 
 /**
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index af4da51..17f2e8e 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -81,7 +81,7 @@ typedef int (*acpi_tbl_entry_handler)(struct acpi_subtable_header *header,
 
 #ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
 void acpi_initrd_override(void *data, size_t size, bool is_phys);
-void early_alloc_acpi_override_tables_buf(void);
+void early_alloc_acpi_override_tables_buf(bool is_phys);
 #else
 static inline void acpi_initrd_override(void *data, size_t size, bool is_phys)
 {
-- 
1.7.1

